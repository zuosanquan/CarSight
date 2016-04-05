//
//  EBDetailPictureController.m
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBDetailPictureController.h"
#import "EBPictureModel.h"
#import "EBPictureTableCell.h"


@interface EBDetailPictureController()<UITableViewDelegate,UITableViewDataSource,EBPictureTableCellChangeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *scalImageView;

@end

@implementation EBDetailPictureController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (UIImageView *)scalImageView{
    if (!_scalImageView) {
        _scalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (HEIGHT - 64) / 2, 0, 0)];
        _scalImageView.contentMode = UIViewContentModeScaleAspectFit;
        _scalImageView.hidden = true;
        [self.view addSubview:_scalImageView];
        //添加点击手势
        _scalImageView.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_scalImageView addGestureRecognizer:tap];
    }
    return _scalImageView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.pageIndex = 1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //添加换一批按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"换一批" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont headViewColorTextFont];
    [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextGroupImages:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self loadDataModel];

}

#pragma mark - 换一批按钮点击事件
- (void) nextGroupImages:(UIButton *)button{
    self.pageIndex += 1;
    [self loadDataModel];
}

- (void)loadDataModel{
    [KVNProgress showWithStatus:@"加载中"];
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求url
    NSString *urlStr = [NSString stringWithFormat:DETAILPICTURE,self.seariseId,self.CarId,self.Year,self.pageIndex];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [KVNProgress dismiss];
        [KVNProgress showSuccess];
        NSDictionary *dict = responseObject[@"data"];
        NSArray *list = dict[@"list"];
        
        for (NSDictionary *desdict in list) {
            EBPictureGroup *group = [EBPictureGroup yy_modelWithDictionary:desdict];
            [self.dataArray addObject:group];
            if (group.Images.count == 0) {
                [KVNProgress showErrorWithStatus:@"没有更多数据了"];
                self.pageIndex = 1;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"加载失败"];
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT / 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EBPictureTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID"];
     EBPictureGroup *group = self.dataArray[indexPath.section];
    if (!cell) {
        cell = [[EBPictureTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_ID" andGroups:group];
    }
    cell.largeDelegate = self;
    cell.models = group;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat marginX = 10;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.tag = section + 250;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkMorePictures:)];
    [view addGestureRecognizer:tap];
    view.backgroundColor = [UIColor whiteColor];
    //设置标题label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, WIDTH / 8, CGRectGetHeight(view.frame))];
    [view addSubview:titleLabel];
    titleLabel.textColor = [UIColor barTitleColor];
    titleLabel.font = [UIFont headViewNormalTextFont];
    EBPictureGroup *group = self.dataArray[section];
    titleLabel.text = group.PositionName;
//    //设置数量label
//    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + marginX, CGRectGetMidY(titleLabel.frame) - CGRectGetHeight(view.frame) / 4, WIDTH / 8, CGRectGetHeight(view.frame) / 2)];
//    number.text = [NSString stringWithFormat:@"%ld张",group.Count];
//    number.textColor = [UIColor cellOtherContentColor];
//    number.font = [UIFont headViewSmallFont];
//    [view addSubview:number];
//    
//    CGFloat moreLabelW = WIDTH / 7;
//    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - marginX - moreLabelW , CGRectGetMinY(number.frame), moreLabelW, CGRectGetHeight(number.frame))];
//    [view addSubview:moreLabel];
//    moreLabel.textColor = [UIColor barTitleColor];
//    moreLabel.text = @"查看更多";
//    moreLabel.font = [UIFont headViewSmallFont];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) checkMorePictures:(UITapGestureRecognizer *)tap{
    
}

- (void)enlargeImage:(UIImage *)image withUrl:(NSString *)imageUrl{
    [KVNProgress showWithStatus:@"加载中"];
    [self.scalImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [KVNProgress dismiss];
        self.scalImageView.image = image1;
    }];
    //动画起始点左中屏处
    if (CGRectGetMinX(self.scalImageView.frame) != 0) {
        self.scalImageView.frame = CGRectMake(0, (HEIGHT - 64) / 2, 0, 0);
    }
    //弹出动画
    [UIView animateWithDuration:0.5 animations:^{
        self.scalImageView.frame = CGRectMake(0, -64, WIDTH, HEIGHT);
        self.scalImageView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:0.7];
        self.scalImageView.hidden = false;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)tapImageView:(UITapGestureRecognizer *)tap{
    //收回动画
    [UIView animateWithDuration:0.5 animations:^{
        self.scalImageView.frame = CGRectMake(WIDTH, (HEIGHT - 64) / 2, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
@end
