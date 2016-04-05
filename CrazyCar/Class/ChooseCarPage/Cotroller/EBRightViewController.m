//
//  EBRightViewController.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBRightViewController.h"
#import "EBCarTableViewCell.h"
#import "EBCar.h"
#import "EBCarDetailModel.h"
#import <UIImageView+WebCache.h>
#import <YYModel.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "EBCarLogoModel.h"
#import "EBCarLogoController.h"
#import "EBCarEachBrandController.h"
#import "EBSelfInfoController.h"


@interface EBRightViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSMutableArray *sectionArr;
@property (nonatomic,copy) NSMutableArray *groupNames;
@property (nonatomic,strong) EBCarLogoModel *logoModel;

@end

@implementation EBRightViewController{
    UITableView *_tableView;
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
    }
    return _groupNames;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.logUrl] placeholderImage:[UIImage imageNamed:@"Icon-60"]];
    [view addSubview:imageView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 30, CGRectGetMinY(imageView.frame), WIDTH - CGRectGetMaxX(imageView.frame) - 30, CGRectGetHeight(imageView.frame))];
    nameLabel.text = [NSString stringWithFormat:@"品牌介绍"];
    [view addSubview:nameLabel];
    
    _tableView.tableHeaderView = view;
    
    //给headView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBrandStory:)];
    [view addGestureRecognizer:tap];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel];
        [_tableView.mj_header endRefreshing];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EBCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"EBCarTableViewCell"];
    
}

- (void) loadDataModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:CARDETAIL,self.masterid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.sectionArr) {
            [_sectionArr removeAllObjects];
        }
        NSArray *array = responseObject[@"data"];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EBCarDetailModel *detail = [EBCarDetailModel yy_modelWithDictionary:obj];
            [self.sectionArr addObject:detail];
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EBCarDetailModel *model = self.sectionArr[section];
    return [model.serialList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EBCarTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EBCarTableViewCell" owner:self options:nil] lastObject];
    }
    EBCarDetailModel *model = self.sectionArr[indexPath.section];
    EBCarSeriallist *list = model.serialList[indexPath.row];
    NSString *imageStr = nil;
    if ([list.Picture containsString:@"{"]) {
        NSString *str = [[list.Picture componentsSeparatedByString:@"{"] firstObject];
        NSString *urlStr = [str stringByAppendingString:@"3.jpg"];
        imageStr = urlStr;
    }else{
        imageStr = list.Picture;
    }
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage sd_animatedGIFNamed:@"car_loading.gif"]];
    cell.nameLabel.text = list.serialName;
    cell.nameLabel.adjustsFontSizeToFitWidth = YES;
    cell.nameLabel.numberOfLines = 0;
    cell.priceLabel.text = list.dealerPrice;
    cell.priceLabel.adjustsFontSizeToFitWidth = YES;
    cell.priceLabel.numberOfLines = 0;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    EBCarDetailModel *model = self.sectionArr[section];
    return model.brandName;
}

- (void)showBrandStory:(UITapGestureRecognizer *)tap{
    EBCarLogoController *logo = [EBCarLogoController new];
    logo.masterId = self.masterid;
    logo.name = self.name;
    [self.navigationController pushViewController:logo animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EBCarDetailModel *model = self.sectionArr[indexPath.section];
    EBCarSeriallist *list = model.serialList[indexPath.row];
    //判断是否从个人信息页面跳转过来，并用block传值
    if (_isLoveCar) {
        EBSelfInfoController *selfInfo = nil;
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[EBSelfInfoController class]]) {
                selfInfo = (EBSelfInfoController *)viewController;
            }
        }
        if (self.setLoveCarHandle) {
            self.setLoveCarHandle(list.serialName,self.logUrl);
        }
        [self.navigationController popToViewController:selfInfo animated:YES];
    }else{
        //正常界面的跳转
        EBCarEachBrandController *eachBrand = [EBCarEachBrandController new];
        eachBrand.model = list;
        eachBrand.seriseId = list.serialId;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //    EBEachBrandController *brandVC = [EBEachBrandController new];
        [self.navigationController pushViewController:eachBrand animated:YES];

    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
