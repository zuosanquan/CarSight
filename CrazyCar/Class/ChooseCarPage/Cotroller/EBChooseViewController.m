//
//  EBChooseViewController.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBChooseViewController.h"
#import <AFNetworking.h>
#import "EBCar.h"
#import "EBCarModel.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "EBRightViewController.h"
#import <RESideMenu.h>
#import "EBCarListCell.h"
#import "EBCarListSearchController.h"
#import "EBSearchResultModel.h"
@interface EBChooseViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (nonatomic,copy) NSMutableArray *sectionArr;

@property (nonatomic,copy) NSMutableArray *groupNames;

@property (nonatomic, strong) UISearchController *searchVC;

@end

@implementation EBChooseViewController{
    UITableView *_tableView;
}

- (EBRightViewController *)rightVC{
    if (!_rightVC) {
        _rightVC = [EBRightViewController new];
    }
    return _rightVC;
}

- (NSMutableArray *)sectionArr{
    if (!_sectionArr) {
        _sectionArr = @[].mutableCopy;
    }
    return _sectionArr;
}
- (NSMutableArray *)groupNames{
    if (!_groupNames) {
        _groupNames = @[].mutableCopy;
        for (int i = 'A'; i <= 'Z'; i++) {
            NSString *groupTitle = [NSString stringWithFormat:@"%c",i];
            [_groupNames addObject:groupTitle];
        }
    }
    return _groupNames;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if (_isLoveCar) {
        self.title = @"我的爱车";
    }
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel];
        [_tableView.mj_header endRefreshing];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    //判断从什么界面进入
    if (!_isLoveCar) {
        self.searchVC = [[UISearchController alloc] initWithSearchResultsController:[[UINavigationController alloc] initWithRootViewController:[EBCarListSearchController new]]];
        self.searchVC.searchResultsUpdater = self;
        self.searchVC.searchBar.frame = CGRectMake(self.searchVC.searchBar.frame.origin.x, self.searchVC.searchBar.frame.origin.y, self.searchVC.searchBar.frame.size.width, 44.0);
        
        _tableView.tableHeaderView = self.searchVC.searchBar;
        self.definesPresentationContext = YES;
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    NSString *searchString = [self.searchVC.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:SearchAPI,searchString] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.searchVC.searchResultsController) {
            UINavigationController *searchController = (UINavigationController *)self.searchVC.searchResultsController;
            EBCarListSearchController *resultVC = (EBCarListSearchController *)searchController.topViewController;
        
        NSArray *results = responseObject[@"suglist"];
        for (int i = 0; i < results.count; i++) {
            NSDictionary *dict = results[i];
            EBSearchResultModel *model = [EBSearchResultModel yy_modelWithDictionary:dict];
            [resultVC.resultArray addObject:model];
        }
            dispatch_async(dispatch_get_main_queue(), ^{
                [resultVC.tableView reloadData];
            });
    }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void) loadDataModel{
    if (self.sectionArr.count) {
        return;
    }
    [KVNProgress showWithStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:CARLIST parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [KVNProgress dismiss];
        NSArray *array = responseObject[@"data"];
        NSMutableArray *secArr = @[].mutableCopy;
        for (NSUInteger i = self.groupNames.count; i > 0; i--) {
            NSString *obj = self.groupNames[i - 1];
            NSMutableArray *groupArr = @[].mutableCopy;
            for (NSDictionary *dict in array) {
                if ([obj isEqualToString:dict[@"initial"]]) {
                    EBCarModel *model = [EBCarModel yy_modelWithDictionary:dict];
                    [groupArr addObject:model];
                }
            }
            if (groupArr.count) {
                [secArr addObject:groupArr];
            }else{
                [self.groupNames removeObject:obj];
            }
        }
        for (NSInteger i = secArr.count - 1; i >= 0; i--) {
            [self.sectionArr addObject:secArr[i]];
        }
        [KVNProgress showSuccess];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [KVNProgress dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sectionArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID"];
    if (!cell) {
        cell = [[EBCarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_ID"];
    }
    NSMutableArray *sections = self.sectionArr[indexPath.section];
    EBCarModel *model = sections[indexPath.row];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage sd_animatedGIFNamed:@"car_loading.gif"]];
    cell.nameLabel.text = model.name;
    
    cell.transform = CGAffineTransformMakeTranslation(-WIDTH, 0);
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.groupNames[section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.groupNames;
}


- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.sectionArr[indexPath.section];
    EBCarModel *model = array[indexPath.row];
    if (_isLoveCar) {
        self.rightVC.isLoveCar = self.isLoveCar;
        self.rightVC.masterid = model.masterId;
        self.rightVC.name = model.name;
        self.rightVC.logUrl = model.logoUrl;
        _rightVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.rightVC animated:YES];
    }else{
       
        EBRightViewController *right = [[EBRightViewController alloc] init];
        right.isLoveCar = self.isLoveCar;
        right.masterid = model.masterId;
        right.name = model.name;
        right.logUrl = model.logoUrl;
        right.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:right animated:YES];
    }

}
@end
