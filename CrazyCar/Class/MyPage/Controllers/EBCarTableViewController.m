//
//  EBCarTableViewController.m
//  CrazyCar
//
//  Created by Edward on 16/3/1.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarTableViewController.h"
#import "EBCollectViewController.h"
#import "EBSelfInfoController.h"
#import "EBSelfCenterView.h"
#import "EBPriceOfOilController.h"
#import "JokerViewController.h"
#import <PopMenu.h>

@interface EBCarTableViewController ()<UITableViewDelegate,UITableViewDataSource,EBSelfInfoControllerDelegate>

@property (nonatomic, strong) EBSelfCenterView *placeHolder;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *dataArray2;

@end

@implementation EBCarTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeHolder = [[EBSelfCenterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT / 5)];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updatePicture:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.tableView addScaleAvariabilityImageWithImage:@"my_header_background_img" andHeight:CGRectGetHeight(self.placeHolder.frame)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.placeHolder;
    [self.tableView.tableHeaderView addGestureRecognizer:longpress];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView = view;

    [self.view addSubview:self.tableView];
    
    self.dataArray = @[@"个人信息",@"我的收藏",@"今日油价"];
    
    self.dataArray2 = @[@"清除缓存",@"关于我们"];
}

- (void)updatePicture:(UILongPressGestureRecognizer *)longpress{
    NSLog(@"yes");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 0) {
        return self.dataArray2.count;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    if (indexPath.section != 0) {
        cell.textLabel.text = self.dataArray2[indexPath.row];
    }else{
        cell.textLabel.text = self.dataArray[indexPath.row];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = nil;
    if (indexPath.section == 0) {
        str = self.dataArray[indexPath.row];
    }else{
        str = self.dataArray2[indexPath.row];
    }
    
    if ([str isEqualToString:@"个人信息"]) {
        EBSelfInfoController *infoVC = [EBSelfInfoController new];
        infoVC.delegate = self;
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if ([str isEqualToString:@"我的收藏"]){
        EBCollectViewController *collection = [EBCollectViewController new];
        collection.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collection animated:YES];
    }else if ([str isEqualToString:@"清除缓存"]){
        [self clearWebCache];
    }else if ([str isEqualToString:@"关于我们"]){
        JokerViewController *joker = [[JokerViewController alloc] init];
        joker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:joker animated:YES];
    }else if ([str isEqualToString:@"今日油价"]){
        [self showPopMenu];
    }
    
    
}

//清除缓存
- (void)clearWebCache
{
    //缓存的文件个数
    NSUInteger diskCount = [SDImageCache sharedImageCache].getDiskCount;
    //获取缓存的大小
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    
    NSString * msg = [NSString stringWithFormat:@"缓存文件数量:%lu,缓存文件大小:%.2fM",diskCount,cacheSize/1024.0/1024.0];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    //添加action
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];
    //清除action
    UIAlertAction * clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    [alertController addAction:clearAction];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPopMenu{
    NSArray *titleArr = @[@"北京",
                          @"上海",
                          @"四川",
                          @"重庆",
                          @"湖南",
                          @"湖北",
                          @"其他"];
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < titleArr.count; i++) {
        MenuItem *item = [[MenuItem alloc] initWithTitle:titleArr[i] iconName:nil];
        [items addObject:item];
    }
    
    //创建弹出页面
    PopMenu *menu = [[PopMenu alloc] initWithFrame:[UIScreen mainScreen].bounds items:items];
    menu.didSelectedItemCompletion = ^(MenuItem *item){
        if ([item.title isEqualToString:@"其他"]) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示:" message:@"输入您要查询省份或直辖市" preferredStyle:UIAlertControllerStyleAlert];

            [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                item.title = textField.text;
            }];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                EBPriceOfOilController *priceVC = [EBPriceOfOilController new];
                priceVC.province = [alter.textFields firstObject].text;
                priceVC.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:priceVC animated:YES];
            }];
            [alter addAction:sureAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alter addAction:cancelAction];
            
            [self presentViewController:alter animated:YES completion:^{
                
            }];
        }else{
            EBPriceOfOilController *priceVC = [EBPriceOfOilController new];
            priceVC.province = item.title;
            priceVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:priceVC animated:YES];
        }
       
    };
    [menu showMenuAtView:self.view];
    
}

#pragma mark EBSelfInfoControllerDelegate
- (void)setImage:(UIImage *)image andNickName:(NSString *)nickName andCarIconUrl:(NSString *)logUrl{
    if (image) {
        self.placeHolder.selfImage = image;
    }
    if (nickName.length) {
        self.placeHolder.nickName = nickName;
    }
    if (logUrl.length) {
        self.placeHolder.logUrl = logUrl;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
