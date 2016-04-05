//
//  EBHotLittleCellClick.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBHotLittleCellClick.h"
#import "EBHtmlModel.h"

@interface EBHotLittleCellClick ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,copy) NSString *htmlStr;

@property (nonatomic,strong) UIProgressView *progress;

@end

@implementation EBHotLittleCellClick



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    [self loadDataModel];
    
    
    // Do any additional setup after loading the view.
}

- (void)loadDataModel{
    self.htmlStr = nil;
    NSString *dateStr=[NSString stringWithFormat:@"更新时间:%@-%@-%@ %@:%@:%@",
                       [_lastmodify substringWithRange:NSMakeRange(0, 4)],
                       [_lastmodify substringWithRange:NSMakeRange(4, 2)],
                       [_lastmodify substringWithRange:NSMakeRange(6, 2)],
                       [_lastmodify substringWithRange:NSMakeRange(8, 2)],
                       [_lastmodify substringWithRange:NSMakeRange(10, 2)],
                       [_lastmodify substringWithRange:NSMakeRange(12, 2)]];

    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head lang='en'><meta charset='UTF-8'><title>我的html</title></head><body><h1 style=color:black;font-size:20px;text-align:left>%@</h1><h2 style=color:black;font-size:10px;text-align:left>%@</h2>",self.webTitle,dateStr];
    self.htmlStr = html;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:self.webUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSArray *content = dict[@"content"];
        //若请求无数据说明API接口和普通的有差异，换接口再次请求
        if (content.count == 0) {
            self.webUrl = [NSString stringWithFormat:MediaCell,self.seriseId,self.lastmodify];
            [self loadDataModel];
        }
        for (NSDictionary *contentDict in content) {
            EBHtmlModel *model = [EBHtmlModel yy_modelWithDictionary:contentDict];
            //是图片
            if (model.type == 2) {
                EBImageSize *size = [model.style firstObject];
                NSString *image = [NSString stringWithFormat:@"<img src='%@' style='width:%fpx;height:%fpx'></img>",model.content,WIDTH - 16,size.height * (WIDTH - 16) / size.width];
               self.htmlStr = [self.htmlStr stringByAppendingString:image];
            }else if (model.type == 1){//文字
                NSString *doc = [NSString stringWithFormat:@"<p>%@</p>",model.content];
                self.htmlStr = [self.htmlStr stringByAppendingString:doc];
            }
        }
        self.htmlStr = [_htmlStr stringByAppendingString:@"</body></html>"];
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [KVNProgress showWithStatus:@"加载中..."];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [KVNProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [KVNProgress showError];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
