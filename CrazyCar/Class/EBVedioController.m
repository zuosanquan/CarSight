//
//  EBVedioController.m
//  CrazyCar
//
//  Created by Edward on 16/3/3.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBVedioController.h"
#import "EBVedioModel.h"
#import "EBVedioCollectionCell.h"
#import "EBCollectionHeadView.h"
#import "EBCategoryVedioController.h"
#import "EBVideoWebView.h"
#import "KRVideoPlayerController.h"


@interface EBVedioController()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *originBuildArr;

@property (nonatomic, strong) NSMutableArray *socialArr;

@property (nonatomic, strong) NSMutableArray *internetArr;

@property (nonatomic, strong) KRVideoPlayerController *videoPlayerController;

@end

@implementation EBVedioController{
    UICollectionView *_collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)originBuildArr{
    if (!_originBuildArr) {
        _originBuildArr = @[].mutableCopy;
    }
    return _originBuildArr;
}

- (NSMutableArray *)socialArr{
    if (!_socialArr) {
        _socialArr = @[].mutableCopy;
    }
    return _socialArr;
}

- (NSMutableArray *)internetArr{
    if (!_internetArr) {
        _internetArr = @[].mutableCopy;
    }
    return _internetArr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((WIDTH - 30) / 2, (WIDTH - 30) / 2 + 10);
    
    layout.headerReferenceSize = CGSizeMake(WIDTH, 40);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[EBVedioCollectionCell class] forCellWithReuseIdentifier:@"EBVedioCollectionCell"];
    [_collectionView registerClass:[EBCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EBCollectionHeadView"];
    
    //设置上拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel];
        [_collectionView.mj_header endRefreshing];
    }];
    _collectionView.mj_header = header;
    [_collectionView.mj_header beginRefreshing];
    
       
}

- (void) loadDataModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:VEDIOAPI parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.originBuildArr.count != 0) {
            [self.originBuildArr removeAllObjects];
            [self.internetArr removeAllObjects];
        }
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"list"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EBVedioModel *model = [EBVedioModel yy_modelWithDictionary:obj];
            if ([model.CategoryName isEqualToString:@"原创节目"]) {
                [self.originBuildArr addObject:model];
            }else if([model.CategoryName isEqualToString:@"网络精选"]){
                [self.internetArr addObject:model];
            }
        }];
        [self.dataArray addObject:self.originBuildArr];
        [self.dataArray addObject:self.internetArr];
        
        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}  

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.internetArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EBVedioCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EBVedioCollectionCell" forIndexPath:indexPath];
    EBVedioModel *model = nil;
    if (indexPath.section == 0) {
        model = self.originBuildArr[indexPath.row];
    }else if(indexPath.section == 1){
        model = self.internetArr[indexPath.row];
    }
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        EBCollectionHeadView *headView = (EBCollectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EBCollectionHeadView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            EBVedioModel *model = [self.originBuildArr firstObject];
            headView.categoryId = model.CategoryId;
            headView.titleName = @"专题节目";
        }else{
            EBVedioModel *model = [self.internetArr firstObject];
            headView.categoryId = model.CategoryId;
            headView.titleName = model.CategoryName;
        }
        headView.allLabelName = @"点击查看全部";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllVedios:)];
        
        [headView addGestureRecognizer:tap];
        reusableView = headView;
        
    }
    return reusableView;
}

- (void) showAllVedios:(UITapGestureRecognizer *)tap{
    EBCollectionHeadView *headView = (id)tap.view;
    EBCategoryVedioController *categoryVC = [EBCategoryVedioController new];
    categoryVC.categoryId = headView.categoryId;
    categoryVC.hidesBottomBarWhenPushed = true;
    categoryVC.nameTitle = headView.titleName;
    [self.navigationController pushViewController:categoryVC animated:YES];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *mp4Url = nil;
    if (indexPath.section == 0) {
        EBVedioModel *model = self.originBuildArr[indexPath.row];
        mp4Url = model.Mp4Link;
    }else{
        EBVedioModel *model = self.internetArr[indexPath.row];
        mp4Url = model.Mp4Link;
    }
    if (!self.videoPlayerController) {
        self.videoPlayerController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 3 / 4)];
    }
    self.videoPlayerController.contentURL = [NSURL URLWithString:mp4Url];
    [self.videoPlayerController showInWindow];
//    EBVideoWebView *video = [EBVideoWebView new];
//    video.webUrl = mp4Url;
//    video.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:video animated:YES];
    
}

@end
