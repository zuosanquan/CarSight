//
//  EBHotNewsController.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHotNewsController.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import <UIImage+MultiFormat.h>
#import <MJRefresh.h>
#import "EBCar.h"
#import "EBHotNewModel.h"
#import "EBHotNewsTableCell.h"
#import "CellFrame.h"
#import "EBHotWideCellClick.h"
#import "EBHotLittleCellClick.h"
#import "EBScrollView.h"
#import "EBNavigationBarView.h"

#define kHotNewHeadHeight 200
#define kHotNewHeadTables 3
#define kTableViews 2
#define kTableViewTagStart 300

@interface EBHotNewsController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EBNavigationBarViewDelegate>

//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *scrollArr;

@property (nonatomic,strong) NSMutableArray<EBHotNewModel *> *headerModel;

@property (nonatomic,strong) NSArray *scrollAPIArr;

@property (nonatomic, assign) NSInteger currentpage;

@property (nonatomic, strong) NSMutableArray *firstPageArr;

@property (nonatomic, strong) NSMutableArray *secondPageArr;

@property (nonatomic, strong) EBNavigationBarView *barView;

@property (nonatomic, assign) NSInteger newCarPage;

@property (nonatomic, assign) NSInteger picPage;

@property (nonatomic, assign) NSInteger showCarPage;

@end

@implementation EBHotNewsController{
    UIScrollView *_biggerScrollView;
    NSTimer *_headViewTimer;
    UIView *_headView;
}

- (NSMutableArray *)firstPageArr{
    if (!_firstPageArr) {
        _firstPageArr = @[].mutableCopy;
    }
    return _firstPageArr;
}

- (NSMutableArray *)secondPageArr{
    if (!_secondPageArr) {
        _secondPageArr = @[].mutableCopy;
    }
    return _secondPageArr;
}

- (NSMutableArray<EBHotNewModel *> *)headerModel{
    if (!_headerModel) {
        _headerModel = @[].mutableCopy;
    }
    return _headerModel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray ) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)scrollArr{
    if (!_scrollArr) {
        _scrollArr = @[].mutableCopy;
        for (int i = 0; i < self.scrollAPIArr.count; i++) {
            NSMutableArray *array = @[].mutableCopy;
            [_scrollArr addObject:array];
        }
    }
    return _scrollArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.barView.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    //设置初始进入的页面
    self.currentpage = 0;
    //API数组
    self.scrollAPIArr = @[HOTNEW,NEWCAR,PICTURE,CARSHOW];
    //创建主滑动的scrollView
    _biggerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _biggerScrollView.delegate = self;
    _biggerScrollView.contentSize = CGSizeMake(WIDTH * self.scrollAPIArr.count,0);
    _biggerScrollView.pagingEnabled = true;
    [self.view addSubview:_biggerScrollView];
    
    [self customNavigationBar];
    
    for (int i = 0; i < self.scrollAPIArr.count; i++) {
        [self creatTableView:i];
        NSMutableArray *array = [NSMutableArray array];
        [self.scrollArr addObject:array];
    }
    [self loadDataModel:NO];

}
//自定义的navigationbar
- (void) customNavigationBar{
    self.barView = [[EBNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    self.barView.titleArr = @[@"头条",@"新车",@"图片",@"说车"];
    self.barView.barDelegate = self;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    [self.navigationController.navigationBar addSubview:self.barView];
}
//创建tableView
- (void) creatTableView:(NSInteger)index{
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(index * WIDTH, 0, WIDTH, HEIGHT - 40) style:UITableViewStylePlain];
    myTableView.tag = index + kTableViewTagStart;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [_biggerScrollView addSubview:myTableView];
    
    //设置上拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataModel:YES];
        [myTableView.mj_header endRefreshing];
    }];
    myTableView.mj_header = header;
    
    //设置下拉刷新
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataModel:NO];
        [myTableView.mj_footer endRefreshing];
    }];
    myTableView.mj_footer = footer;
//    为第一页还需要设置头视图
    if (index == 0) {
        //设置_tableView.tableHeaderView
        myTableView.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200);
        
        _scrollView = [[UIScrollView alloc] initWithFrame:myTableView.tableHeaderView.frame];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kHotNewHeadTables * WIDTH, 0);
        _scrollView.pagingEnabled = YES;
        
        myTableView.tableHeaderView = _scrollView;
        
        /**添加手势*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        [_scrollView addGestureRecognizer:tap];
        _headViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(changeHeadViewOffSet:) userInfo:nil repeats:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_headViewTimer invalidate];
}
#pragma mark 头视图scrollView.contenfOffset变化定时器
- (void)changeHeadViewOffSet:(NSTimer *)timer{
    CGPoint offset = _scrollView.contentOffset;
    offset.x += WIDTH;
    if (offset.x >= kHotNewHeadTables * WIDTH) {
        offset.x = 0;
    }
    [_scrollView setContentOffset:offset animated:YES];
}

#pragma mark 第一页头视图的scrollView的点击手势
- (void)tapHeader:(UITapGestureRecognizer *)tap{
    self.barView.hidden = true;
    if (!self.headerModel.count) {
        return;
    }
    UIScrollView *scroll = (UIScrollView *)tap.view;
    NSInteger count = scroll.contentOffset.x / WIDTH;
    EBHotNewModel *model = self.headerModel[count];
    
    if (model.type == 3) {
        EBHotWideCellClick *detailVC = [EBHotWideCellClick new];
        detailVC.newsId = model.newsId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        EBHotLittleCellClick *detailVC = [EBHotLittleCellClick new];
        detailVC.webUrl = [NSString stringWithFormat:LittleCell,model.newsId,model.lastModify];
        detailVC.lastmodify = model.lastModify;
        detailVC.webTitle = model.title;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
//返回页码
- (NSInteger) currentPageIndex:(BOOL)fresh{
    //判断上下拉刷新，病对相应页面的页码做设置
    NSInteger current = 0;
    if (_currentpage == 0) {
        if (fresh) {
            self.page = 1;
        }else{
            self.page += 1;
        }
        current = self.page;
    }
    if (_currentpage == 1) {
        if (fresh) {
            self.newCarPage = 1;
        }else{
            self.newCarPage += 1;
        }
        current = self.newCarPage;
    }
    if (_currentpage == 2) {
        if (fresh) {
            self.picPage = 1;
        }else{
            self.picPage += 1;
        }
        current = self.picPage;
    }
    if (_currentpage == 3) {
        if (fresh) {
            self.showCarPage = 1;
        }else{
            self.showCarPage += 1;
        }
        current = self.showCarPage;
    }
    return current;
}
#pragma mark 加载数据模型
- (void) loadDataModel:(BOOL)fresh{
   
    NSInteger current = [self currentPageIndex:fresh];
    //获取当前页面数据源的API
    NSString *urlStr = nil;
    urlStr = [NSString stringWithFormat:self.scrollAPIArr[self.currentpage],current];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",urlStr);
        //获得当前页面的数据源数组
        NSMutableArray *tempArr = self.scrollArr[_currentpage];
        if (fresh) {
            if (tempArr.count > 0) {
                [tempArr removeAllObjects];
            }
        }
        //图片页面返回的类型稍有不同
        if (_currentpage == 2) {
            NSArray *pictureArr = responseObject[@"data"];
            [self parseDownloadData:pictureArr];
        }else{
            NSDictionary *dict = responseObject[@"data"];
            [self parseDownloadData:dict];
        }
        //取出当前页面的tableView
        UITableView *tableView = [_biggerScrollView viewWithTag:self.currentpage + kTableViewTagStart];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}
/**解析数据*/
- (void)parseDownloadData:(id)dict{
    static  NSInteger count = 0;
    NSArray *array = nil;
    if (_currentpage == 2) {
        array = dict;
    }else{
        array = dict[@"list"];
    }
    NSMutableArray *tempArr = self.scrollArr[_currentpage];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EBHotNewModel *model = [EBHotNewModel yy_modelWithDictionary:obj];
        //筛选出模型的type，其他样式比较复杂
        if (model.type == 3 || model.type == 1 || model.type == 20 || model.type == 21) {
                if (count < kHotNewHeadTables && _currentpage == 0) {
                    EBScrollView *scrollView = [[EBScrollView alloc] initWithFrame:CGRectMake(count * WIDTH, 0, WIDTH, 200)];
                    [_scrollView addSubview:scrollView];
                    [self.headerModel addObject:model];
                    scrollView.model = model;
                    count ++;
                }else{
                    [tempArr addObject:model];
                }
           }
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == kTableViewTagStart) {
        return 200;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == kTableViewTagStart) {
       return _scrollView;
    }
    return nil;
}
/**动态返回cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArr = self.scrollArr[_currentpage];
    EBHotNewModel *model = tempArr[indexPath.row];
    CellFrame *cellFrame = [CellFrame new];
    cellFrame.model = model;
    return cellFrame.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.scrollArr[_currentpage] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBHotNewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EBHotNewsTableCell"];
    NSMutableArray *tempArr = self.scrollArr[_currentpage];
    if (!cell) {
        cell = [[EBHotNewsTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"EBHotNewsTableCell"];
    }
    EBHotNewModel *model = tempArr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArr = self.scrollArr[_currentpage];
    self.barView.hidden = true;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EBHotNewModel *model = tempArr[indexPath.row];
    if (model.type == 3) {
        EBHotWideCellClick *detailVC = [EBHotWideCellClick new];
        detailVC.newsId = model.newsId;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        EBHotLittleCellClick *detailVC = [EBHotLittleCellClick new];
        if (self.currentpage == 1) {
            detailVC.webUrl = [NSString stringWithFormat:NewCarCell,model.newsId,model.lastModify];
        }else{
            detailVC.webUrl = [NSString stringWithFormat:LittleCell,model.newsId,model.lastModify];
        }
        detailVC.lastmodify = model.lastModify;
        detailVC.webTitle = model.title;
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.seriseId = model.newsId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        //判断_biggerScrollView是否为横向滑动
        if (self.currentpage != (NSInteger)_biggerScrollView.contentOffset.x / WIDTH) {
            //更新当前页面
            self.currentpage = _biggerScrollView.contentOffset.x / WIDTH;
            [self barViewLineViewAnimation];
            //获取当前页面的tableView
            UITableView *currentTableView = (UITableView *)[_biggerScrollView viewWithTag:_currentpage + kTableViewTagStart];
            //获取到当前页面的数组
            NSMutableArray *currentArray = self.scrollArr[_currentpage];
            //刷新当前页面的tableView
            if (currentArray.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [currentTableView reloadData];
                });
            }else{
                [self loadDataModel:NO];
            }
            
        }
}

//只是条下面的线移动动画
- (void) barViewLineViewAnimation{

        CGRect oringinFrame = self.barView.lineView.frame;
        CGFloat realOffset = (_currentpage + 1.5) * WIDTH / 7;

        __weak typeof(self) weakSelf = self;
        //执行动画
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.barView.lineView.frame = CGRectMake( realOffset, CGRectGetMinY(oringinFrame), CGRectGetWidth(oringinFrame), CGRectGetHeight(oringinFrame));
        } completion:^(BOOL finished) {
            
        }];

}
#pragma mark - EBNavigationBarViewDelegate

- (void)customNavigationBar:(EBNavigationBarView *)barView withTag:(NSInteger)index{
    [_biggerScrollView setContentOffset:CGPointMake(index * WIDTH, 0)];
    //更新当前页面
    self.currentpage = _biggerScrollView.contentOffset.x / WIDTH;

    __weak typeof(self) weakSelf = self;
    //执行动画
    CGRect oringinFrame = self.barView.lineView.frame;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.barView.lineView.frame = CGRectMake((index + 1.5) * kHotNewBarViewEachW, CGRectGetMinY(oringinFrame), CGRectGetWidth(oringinFrame), CGRectGetHeight(oringinFrame));
    } completion:^(BOOL finished) {
        
    }];
    //获取当前页面的tableView
    UITableView *currentTableView = (UITableView *)[_biggerScrollView viewWithTag:_currentpage + kTableViewTagStart];
    //获取到当前页面的数组
    NSMutableArray *currentArray = self.scrollArr[_currentpage];
    //刷新当前页面的tableView
    if (currentArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [currentTableView reloadData];
        });
    }else{
        [self loadDataModel:NO];
    }
}


@end
