//
//  EBHotWideCellClick.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHotWideCellClick.h"
#import "EBCollectionViewLayout.h"
#import "EBCollectionViewCell.h"
#import "EBDescModel.h"

static const CGFloat kCellSizeCoef = 0.8f;

static const CGFloat kFirstItemTransform = 0.05f;

static NSString * collectionCellID = @"EBCollectionViewCell";

@interface EBHotWideCellClick ()<UICollectionViewDelegate,UICollectionViewDataSource,EBCollectionViewCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *imageNameArr;

@end

@implementation EBHotWideCellClick

- (NSMutableArray *)imageNameArr{
    if (!_imageNameArr) {
        _imageNameArr = @[].mutableCopy;
    }
    return _imageNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EBCollectionViewLayout *layout = [[EBCollectionViewLayout alloc] init];
    layout.firstItemTransform = kFirstItemTransform;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    //背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0.7];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册单元格
    [self.collectionView registerClass:[EBCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    [self loadDataModel];

}

- (void)loadDataModel{
    [KVNProgress showWithStatus:@"拼命加载中..."];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:WideCell,self.newsId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [KVNProgress dismiss];
        //数据解析
        NSDictionary *dict = responseObject[@"data"];
        NSArray *array = dict[@"albums"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EBDescModel *model = [EBDescModel yy_modelWithDictionary:obj];
            [self.imageNameArr addObject:model];
        }];
        //根据数组个数设置标题
         self.title = [NSString stringWithFormat:@"1 / %ld",self.imageNameArr.count];
        
        [KVNProgress showSuccess];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [KVNProgress dismiss];
    }];
}

#pragma mark - UICollectionViewDataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageNameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    //设置代理:以保存图片
    cell.cellDelegate = self;
    
    EBDescModel *model = self.imageNameArr[indexPath.row];
    //刷新数据
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.desLabel.text = model.content;
    cell.desLabel.adjustsFontSizeToFitWidth = YES;
    cell.desLabel.numberOfLines = 0;
    
    return cell;
}
#pragma mark - EBCollectionViewCell协议 保存照片的长按手势
- (void)longpressToSaveAlbum:(UIImage *)desImage{
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示:" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(desImage, nil, nil, nil);
        [KVNProgress showSuccess];
    }];
    [alter addAction:save];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:cancel];
    
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark -=CollectionView layout=-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.collectionView.bounds) * kCellSizeCoef);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
#pragma mark - 设置标题label
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = (NSInteger)_collectionView.contentOffset.y / (CGRectGetHeight(self.collectionView.bounds) * kCellSizeCoef) + 1;
    if (count == 0) {
        count = 1;
    }
    if (_collectionView.contentOffset.y > ((CGFloat)count - 0.5)* CGRectGetHeight(self.collectionView.bounds) * kCellSizeCoef) {
        count = count + 1;
    }
    self.title = [NSString stringWithFormat:@"%ld / %ld",count,self.imageNameArr.count];
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
