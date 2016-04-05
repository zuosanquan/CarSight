//
//  EBCategoryVedioController.m
//  CrazyCar
//
//  Created by Edward on 16/3/3.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCategoryVedioController.h"
#import "EBVedioModel.h"
#import "EBCategoryTableCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "EBVideoWebView.h"
#import "KRVideoPlayerController.h"

@interface EBCategoryVedioController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) KRVideoPlayerController *videoPlayer;

@end

@implementation EBCategoryVedioController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.nameTitle;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[EBCategoryTableCell class] forCellReuseIdentifier:@"EBCategoryTableCell"];
    
    [self.view addSubview:_tableView];
    
    self.index = 1;
    
    //设置上拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel:YES];
        [_tableView.mj_header endRefreshing];
    }];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    
    //设置下拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataModel:NO];
        [_tableView.mj_footer endRefreshing];
    }];
    _tableView.mj_footer = footer;
}

- (void)loadDataModel:(BOOL)fresh{
    if (fresh) {
        self.index = 1;
    }else{
        self.index += 1;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:CATEGORYVEDIO,self.categoryId,self.index] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"list"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EBVedioModel *model = [EBVedioModel yy_modelWithDictionary:obj];
            [self.dataArray addObject:model];
        }];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EBCategoryTableCell"];
    if (!cell) {
        cell = [[EBCategoryTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EBCategoryTableCell"];
    }
    EBVedioModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EBVedioModel *model = self.dataArray[indexPath.row];
//    EBVideoWebView *video = [EBVideoWebView new];
//    video.webUrl = model.Mp4Link;
    if (!self.videoPlayer) {
        self.videoPlayer = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 3 / 4)];
    }
    self.videoPlayer.contentURL = [NSURL URLWithString:model.Mp4Link];
    [self.videoPlayer showInWindow];
//    video.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:video animated:YES];
    
}

@end
