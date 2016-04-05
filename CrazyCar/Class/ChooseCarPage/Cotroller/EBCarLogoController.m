//
//  EBCarLogoController.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarLogoController.h"
#import "EBCarLogoModel.h"

@interface EBCarLogoController ()

@property (nonatomic,copy) NSString *htmlString;

@end

@implementation EBCarLogoController{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:_webView];
    [self loadDataModel];
    
}

- (void) loadDataModel{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:LOGOSTORY,self.masterId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        EBCarLogoModel *model = [EBCarLogoModel yy_modelWithDictionary:dict];
        [self creatHtmlStringWithModel:model];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)creatHtmlStringWithModel:(EBCarLogoModel *)model{
    NSString *introduceStr = [model.introduction stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"<br/><br/>"];
    if (model.logoMeaning) {
        NSString *logoMeaning = [model.logoMeaning stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"<br/><br/>"];
        self.htmlString = [NSString stringWithFormat: @"<!DOCTYPE html><html><head lang='en'><meta charset='UTF-8'><title>我的html</title></head><body><p style=color:blue;font-size:20px;text-align:left>品牌介绍</p><p font-size:15px>%@</p><p style=color:blue;font-size:20px;text-align:left>车标故事</p><p font-size:15px>%@</p></body></html>",introduceStr,logoMeaning];
    }else{
        self.htmlString = [NSString stringWithFormat: @"<!DOCTYPE html><html><head lang='en'><meta charset='UTF-8'><title>我的html</title></head><body><p style=color:blue;font-size:20px;text-align:left>品牌介绍</p><p font-size:15px>%@</p></body></html>",introduceStr];
    }
   
//    NSLog(@"%@",model.introduction);
    [_webView loadHTMLString:self.htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
