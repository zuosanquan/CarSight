//
//  EBVideoWebView.m
//  CrazyCar
//
//  Created by Edward on 16/3/4.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EBVideoWebView.h"
#import "WMPlayer/WMPlayer.h"

@interface EBVideoWebView()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

//@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIProgressView *progress;

//@property (nonatomic, strong) WMPlayer *player;

@end

@implementation EBVideoWebView{
    WMPlayer *wmPlayer;
    CGRect playerFrame;
}


- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _containerView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(- M_PI_2);
    }else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width - 40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
}

-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        [self.view addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
       [UIApplication sharedApplication].statusBarHidden = false;
        
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer == nil || wmPlayer.superview == nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
           // NSLog(@"第3个旋转方向---电池栏在下");
            [self toNormal];
            
        }
            break;
        case UIInterfaceOrientationPortrait:{
            //NSLog(@"第0个旋转方向---电池栏在上");
            [self toNormal];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
           // NSLog(@"第2个旋转方向---电池栏在左");
//            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
//            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            //NSLog(@"第1个旋转方向---电池栏在右");
//            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
//            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    playerFrame = CGRectMake(0, (HEIGHT - WIDTH * 3 / 4) / 2, WIDTH, WIDTH * 3 / 4);
    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:self.webUrl];
    wmPlayer.closeBtn.hidden = YES;
    [self.view addSubview:wmPlayer];
    [wmPlayer.player play];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (wmPlayer) {
        [self releaseWMPlayer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    @synchronized(self) {
        [wmPlayer.player.currentItem cancelPendingSeeks];
        [wmPlayer.player.currentItem.asset cancelLoading];
        
        [wmPlayer.player pause];
        [wmPlayer removeFromSuperview];
        [wmPlayer.playerLayer removeFromSuperlayer];
        [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
        wmPlayer = nil;
        wmPlayer.player = nil;
        wmPlayer.currentItem = nil;
        
        wmPlayer.playOrPauseBtn = nil;
        wmPlayer.playerLayer = nil;
    }
    
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //NSLog(@"player deallco");
}





//- (void)viewDidLoad {
//    [super viewDidLoad];
////    [self creatUI];
//   
////    [self.player play];
//    _player = [[WMPlayer alloc] initWithFrame:self.view.bounds videoURLStr:self.webUrl];
//    [self.view addSubview:_player];
//    [_player.player play];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_player.player pause];
//    //    [self.autoDismissTimer invalidate];
//    //    [self.durationTimer invalidate];
//    _player.autoDismissTimer = nil;
//    _player.durationTimer = nil;
//    _player.player = nil;
//}
#pragma mark - 自定制

//- (void)creatUI{
//    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player] ;
//    playLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:playLayer];
//    
//    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 200, WIDTH, 3)];
//    _progress.progressViewStyle = UIProgressViewStyleBar;
//    [self.view addSubview:_progress];
//}
//
//- (AVPlayer *)player{
//    if (!_player) {
//        AVPlayerItem *playerItem = [self getPlayItem:self.webUrl];
//        _player = [AVPlayer playerWithPlayerItem:playerItem];
//        [self addProgressObserver];
//        [self addObserverToPlayerItem:playerItem];
//    }
//    return _player;
//}
//
//- (AVPlayerItem *)getPlayItem:(NSString *)urlStr{
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
//    return item;
//}
//
////添加播放器通知
//- (void) addNotification{
//    //给播放器添加播放完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
//}
//
//- (void) removeNotification{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)dealloc{
//    [self removeNotification];
//}
//
//- (void) playbackFinish:(NSNotification *)notification{
//    
//}
//
////添加进度更新f
//- (void) addProgressObserver{
//    AVPlayerItem *playerItem = self.player.currentItem;
//    
//    __weak typeof(self) weakSelf = self;
//    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        CGFloat current = CMTimeGetSeconds(time);
//        CGFloat total = CMTimeGetSeconds([playerItem duration]);
//        if (current) {
//            [weakSelf.progress setProgress:(current / total) animated:YES];
//        }
//    }];
//}
////给avplayerItem添加监控
//- (void) addObserverToPlayerItem:(AVPlayerItem *)playerItem{
//    //监控状态属性，player有一个status属性
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    //监控网络加载情况
//    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    
//}
////移除监听
//- (void) removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
//    [playerItem removeObserver:self forKeyPath:@"status"];
//    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//}
//
////kvo回调
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    AVPlayerItem *playerItem = object;
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
//        if (status == AVPlayerStatusReadyToPlay) {
//            NSLog(@"正在播放 总时长%.2f",CMTimeGetSeconds(playerItem.duration));
//        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
//            NSArray *array = playerItem.loadedTimeRanges;
//            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//            
//            CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
//            CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
//            
//            NSTimeInterval totleBuffer = startSeconds + durationSeconds;
//            NSLog(@"共缓冲:%0.2f",totleBuffer);
//        }
//    }
//}
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.webView];
//    
//    NSURLRequest *vedioRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrl]];
//    self.webView.delegate = self;
//    [self.webView loadRequest:vedioRequest];
//}
//

#pragma mark - webView
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    if (request) {
//        
//    }
//    [KVNProgress dismiss];
//    NSLog(@"%ld",(long)navigationType);
//    return YES;
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [KVNProgress showWithStatus:@"正在加载"];
////    NSLog(@"2");
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"3");
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
//    [KVNProgress showErrorWithStatus:@"加载失败"];
////    NSLog(@"4");
//}

@end
