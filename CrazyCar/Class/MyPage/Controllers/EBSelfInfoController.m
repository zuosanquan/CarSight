//
//  EBSelfInfoController.m
//  CrazyCar
//
//  Created by Edward on 16/3/7.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBSelfInfoController.h"
#import "EBSelfInfoHeadView.h"
#import "EBSelfInfoModel.h"
#import "EBModifyNickName.h"
#import "EBChooseViewController.h"
#import "EBRightViewController.h"

@interface EBSelfInfoController()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EBModifyNickNameDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) EBSelfInfoHeadView *headView;

@end

@implementation EBSelfInfoController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"个人信息";
    self.navigationController.navigationBar.translucent = false;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    _headView = [[EBSelfInfoHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    self.tableView.tableHeaderView = _headView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePicture:)];
    [_headView addGestureRecognizer:tap];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [user objectForKey:@"nickName"];
    EBSelfInfoModel *model = [EBSelfInfoModel new];
    model.title = @"昵称";
    if (nickName.length == 0) {
        model.subTitle = @"";
    }else{
        model.subTitle = nickName;
    }
    
    EBSelfInfoModel *model2 = [EBSelfInfoModel new];
    model2.title = @"我的爱车";
    NSString *loveCar = [user objectForKey:@"loveCar"];
    if (loveCar.length == 0) {
        model2.subTitle = @"";
    }else{
        model2.subTitle = loveCar;
    }

    self.dataArray = @[model,model2];
    
}

- (void)choosePicture:(UITapGestureRecognizer *)tap{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"头像设置来源" preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    UIAlertAction *fromTakePc = [UIAlertAction actionWithTitle:@"拍照上传" style:0 handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
       
    }];
    [alter addAction:fromTakePc];
    
    UIAlertAction *fromAlbums = [UIAlertAction actionWithTitle:@"从手机相册中选取" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alter addAction:fromAlbums];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alter addAction:cancel];
    
    [self presentViewController:alter animated:true completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_ID"];
    }
    EBSelfInfoModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EBSelfInfoModel *model = self.dataArray[indexPath.row];
    //设置昵称
    if (indexPath.row == 0) {
        EBModifyNickName *nickName = [EBModifyNickName new];
        nickName.nickName = model.subTitle;
        nickName.modifyDelegate = self;
        [self.navigationController pushViewController:nickName animated:YES];
    }
    //设置我的爱车
    if (indexPath.row == 1) {
        EBChooseViewController *chooseVC = [EBChooseViewController new];
        chooseVC.isLoveCar = YES;
        chooseVC.rightVC.setLoveCarHandle = ^(NSString *name,NSString *logurl){
            model.subTitle = name;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:name forKey:@"loveCar"];
            [user setObject:logurl forKey:@"logUrl"];
            [user synchronize];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
}

#pragma mark - EBModifyNickName协议方法
- (void)modifyNickNameSuccess:(EBModifyNickName *)modify andNickName:(NSString *)nickName{
    for (EBSelfInfoModel *model in self.dataArray) {
        if ([model.title isEqualToString:@"昵称"]) {
            model.subTitle = nickName;
            [self.tableView reloadData];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:nickName forKey:@"nickName"];
            [user synchronize];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate conformsToProtocol:@protocol(EBSelfInfoControllerDelegate) ]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *nickName = [user objectForKey:@"nickName"];
        NSString *logUrl = [user objectForKey:@"logUrl"];
        [self.delegate setImage:self.headView.image andNickName:nickName andCarIconUrl:logUrl];
    }
}
@end
