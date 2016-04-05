//
//  EBCollectViewController.m
//  MyLimitFree
//
//  Created by Edward on 16/2/18.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCollectViewController.h"
#import "EBDBHelper.h"
#import "EBDBModel.h"
#import "EBCollectCell.h"
#import "EBCarEachBrandController.h"
#import "EBCarDetailModel.h"

@interface EBCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,EBCollectCellDelegate>

@end

@implementation EBCollectViewController{
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_dataArray.count > 0 && _collectionView) {
        [_collectionView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat marginX = 20;
    CGFloat marginW = marginX / 2;
    CGFloat marginH = marginX;
    CGFloat layoutW = (WIDTH - 2 * marginX - 2 * marginW -10) / 3;
    CGFloat layoutH = layoutW + 20;
    layout.itemSize = CGSizeMake(layoutW, layoutH);
    layout.minimumInteritemSpacing = marginW;
    layout.minimumLineSpacing = marginH;
    layout.sectionInset = UIEdgeInsetsMake(40, 20, 40, 20);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate =self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[EBCollectCell class] forCellWithReuseIdentifier:@"cell_ID"];
    
    [self.view addSubview:_collectionView];
    
    [self loadDataModel];
    [self customizeNavigationBar];
}

- (void)loadDataModel{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    //从数据库中添加收藏的数据
    [_dataArray addObjectsFromArray:[[EBDBHelper helper] getAllCollections]];
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EBCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_ID" forIndexPath:indexPath];
    EBCarSeriallist *model = _dataArray[indexPath.row];
    cell.edit = _isEdit;
    cell.model = model;
    cell.delegate = self;
//    if (!_isEdit) {
//        cell.transform = CGAffineTransformMakeTranslation(WIDTH, HEIGHT);
//        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            cell.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }
    
    if (_isEdit) {
        cell.transform = CGAffineTransformMakeRotation(-0.22);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else{
        //复原原有的transform
        cell.transform = CGAffineTransformIdentity;
    }
    return cell;
}

- (void) customizeNavigationBar{
//    UIButton *backButton = [EBUIFactory creatButtonWithTitle:@"返回" image:nil bgImage:nil target:self action:@selector(backToLastViewConTroller:) frame:CGRectMake(0, 0, 60, 30)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIButton *editeButton = [EBUIFactory creatButtonWithTitle:@"编辑" image:nil bgImage:nil target:self action:@selector(editButtonClick:) frame:CGRectMake(0, 0, 60, 30)];
    [editeButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [editeButton setTitleColor:[UIColor colorWithHexValue:0x2894FF] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editeButton];
}

- (void) editButtonClick:(UIButton *)button{
    _isEdit = !_isEdit;
    [button setTitle:_isEdit ? @"完成":@"编辑" forState:UIControlStateNormal];
    [_collectionView reloadData];
}

- (void)backToLastViewConTroller:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)appButtonClick:(EBCollectCell *)collectCell{
    EBCarEachBrandController *newDetailViewController = [[EBCarEachBrandController alloc] init];
    newDetailViewController.model = collectCell.model;
//    newDetailViewController.isSettingView = YES;
    [self.navigationController pushViewController:newDetailViewController animated:YES];
}

- (void)deleteButtonClick:(EBCollectCell *)collectCell{
    
    if([[EBDBHelper helper] removeFromCollect:[NSString stringWithFormat:@"%ld",collectCell.model.serialId]]){
        [_dataArray removeObject:collectCell.model];
        
        NSIndexPath *indexpath = [_collectionView indexPathForCell:collectCell];
        [_collectionView deleteItemsAtIndexPaths:@[indexpath]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
        
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
