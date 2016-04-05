//
//  EBPriceOfOilController.m
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBPriceOfOilController.h"
#import "EBOilPriceModel.h"


@implementation EBPriceOfOilController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Background + Group"];
    [self.view addSubview:imageView];
    self.title = [NSString stringWithFormat:@"%@今日油价",self.province];
    [self creatUI];
    [self loadDataModel];
}

- (void) creatUI{
    CGFloat marginW = WIDTH / 4;
    CGFloat marginH = 20;
    CGFloat marginY = HEIGHT / 4;
    CGFloat labelH = 30;
    CGFloat labelW = 50;
    CGFloat Bmargin = WIDTH / 5;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW, marginY - marginH - labelH, WIDTH / 2, labelH)];
    timeLabel.tag = 888;
    [self.view addSubview:timeLabel];
    NSArray *array = @[@"#0",@"#90",@"#93",@"#97"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginW, i * (labelH + marginH) + marginY, labelW, labelH)];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + Bmargin, CGRectGetMinY(label.frame), marginW, labelH)];
        priceLabel.tag = i + 1000;
        [self.view addSubview:priceLabel];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadDataSource)];
}

- (void)reloadDataSource{
    [self loadDataModel];
}

- (void) loadDataModel{
    [KVNProgress showWithStatus:@"正在查询"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:OILPRICE parameters:@{@"key":@"3b250b1eaa154fbc839680a03db9e628",@"prov":self.province} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [KVNProgress dismiss];
        NSDictionary *result = [responseObject[@"result"][@"list"] firstObject];
        EBOilList *list = [EBOilList yy_modelWithDictionary:result];
        [self reloadDataWithModel:list];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void) reloadDataWithModel:(EBOilList *)model{
    UILabel *timeLabel = (UILabel *)[self.view viewWithTag:888];
    timeLabel.text = [[model.ct componentsSeparatedByString:@"."] firstObject];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.text = [NSString stringWithFormat:@"%@更新",timeLabel.text];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    for (int i = 0; i < 4; i++) {
        UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 1000];
        if (i == 0) {
            priceLabel.text = model.p0;
        }else if (i == 1){
            priceLabel.text = model.p90;
        }else if (i == 2){
            priceLabel.text = model.p93;
        }else if (i == 3){
            priceLabel.text = model.p97;
        }
        priceLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.textAlignment = NSTextAlignmentCenter;
    }
   
}

@end
