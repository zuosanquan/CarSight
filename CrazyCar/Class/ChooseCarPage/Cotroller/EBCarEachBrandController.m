//
//  EBCarEachBrandController.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarEachBrandController.h"
#import "EBCarDetailModel.h"
#import "EBCarBrandModel.h"
#import "EBCarBrandHeadView.h"
#import "EBCarGroupModel.h"
#import "EBCarBrandCell.h"
#import "EBDBHelper.h"
#import "EBDetailPictureController.h"

@interface EBCarEachBrandController ()<UITableViewDelegate,UITableViewDataSource,EBCarBrandHeadViewDelegate>

@property (nonatomic,strong) EBCarBrandModel *headViewModel;

@property (nonatomic,strong) EBCarBrandHeadView *headView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *headTitleArr;

@end

@implementation EBCarEachBrandController{
    UITableView *_tableView;
}

- (NSMutableArray *)headTitleArr{
    if (!_headTitleArr) {
        _headTitleArr = @[].mutableCopy;
    }
    return _headTitleArr;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cratNavigationVar];
    self.navigationController.navigationBar.translucent = false;
    
    if (self.title.length == 0) {
        self.title = self.model.serialName;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.headView = [[EBCarBrandHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kDefaultHeadViewHeight)];
    //添加协议
    self.headView.delegate = self;
    _tableView.tableHeaderView = self.headView;
    [self loadHeadDataModel];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel];
        [_tableView.mj_header endRefreshing];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
}

- (void) loadHeadDataModel{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:BRAND,self.seriseId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        
        EBCarBrandModel *model = [EBCarBrandModel yy_modelWithDictionary:dict];
        
        self.headView.model = model;
        
        if (_tableView.scaleImageView) {
            [_tableView removeScaleAvariabilityImage];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView addScaleAvariabilityImageWithImage:model.coverImg andHeight:(kDefaultHeadViewHeight - 15) * 7 / 8];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void) loadDataModel{
    if (self.dataArray.count) {
        return;
    }
    [KVNProgress showWithStatus:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:BRANDTYPE,self.seriseId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [KVNProgress dismiss];
        NSArray *array = responseObject[@"data"];
        [self parseDataWithArr:array];
        [KVNProgress showSuccess];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [KVNProgress dismiss];
    }];
}

- (void) parseDataWithArr:(NSArray *)array{
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = obj[@"CarGroup"];
        EBCarGroupModel *group = [EBCarGroupModel yy_modelWithDictionary:dict];
        if (group.CarList.count) {
            [self.dataArray addObject:group];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    EBCarGroupModel *model = self.dataArray[section];
    if (model.CarList.count == 0) {
        return 0;
    }
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EBCarGroupModel *model = self.dataArray[section];
    return [model.CarList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBCarBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID"];
    if (!cell) {
        cell = [[EBCarBrandCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_ID"];
    }
    EBCarGroupModel *model = self.dataArray[indexPath.section];
    EBCarlistModel *listModel = model.CarList[indexPath.row];
    cell.listModel = listModel;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    EBCarGroupModel *model = self.dataArray[section];
    return model.Name;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    label.backgroundColor = [UIColor whiteColor];
    EBCarGroupModel *model = self.dataArray[section];
    label.text = [NSString stringWithFormat:@"  %@",model.Name];
    label.font = [UIFont headViewNormalTextFont];
    label.textColor = [UIColor cellOtherContentColor];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EBDetailPictureController *pictureVC = [EBDetailPictureController new];
    EBCarGroupModel *model = self.dataArray[indexPath.section];
    EBCarlistModel *listModel = model.CarList[indexPath.row];
    pictureVC.seariseId = self.seriseId;
    pictureVC.CarId = listModel.CarId;
    pictureVC.Year = listModel.Year;
    pictureVC.title = [NSString stringWithFormat:@"%@款 %@",listModel.Year,listModel.Name];
    [self.navigationController pushViewController:pictureVC animated:YES];
}

- (void)cratNavigationVar{
    //如果是通过搜索进入该界面，就不添加收藏功能，毕竟用户已经想到看什么车了，心中有数，不用收藏
    if (!_isSearch) {
        UIButton *collection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        if ([[EBDBHelper helper] collected:[NSString stringWithFormat:@"%ld",self.model.serialId]]) {
            [collection setImage:[UIImage imageNamed:@"Star 2"] forState:UIControlStateNormal];
        }else{
            [collection setImage:[UIImage imageNamed:@"Star 1"] forState:UIControlStateNormal];
        }
        
        [collection addTarget:self action:@selector(collectionMyCar:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:collection];
        NSArray *array = @[collectionItem];
        self.navigationItem.rightBarButtonItems = array;
    }
    
}

- (void)collectionMyCar:(UIButton *)item{
    
    if ([[EBDBHelper helper] collected:[NSString stringWithFormat:@"%ld",self.seriseId]]) {
        if ([[EBDBHelper helper] removeFromCollect:[NSString stringWithFormat:@"%ld",self.seriseId]]) {
            [item setImage:[UIImage imageNamed:@"Star 1"] forState:UIControlStateNormal];
        }
    }else{
        
        if ([[EBDBHelper helper] addToCollect:self.model]) {
            [item setImage:[UIImage imageNamed:@"Star 2"] forState:UIControlStateNormal];
            [KVNProgress showSuccessWithStatus:@"收藏成功!"];
        }
    }
}

#pragma mark - EBCarBrandHeadViewDelegate
- (void)findMorePicture{
    EBDetailPictureController *pictureVC = [EBDetailPictureController new];
    pictureVC.seariseId = self.seriseId;
    pictureVC.title = self.title;
    [self.navigationController pushViewController:pictureVC animated:YES];
}

@end
