//
//  WXWebViewVC.m
//  StudyWorkspace
//
//  Created by 610582 on 2021/7/15.
//  Copyright © 2021 MaoWX. All rights reserved.
//

#import "WXWebViewVC.h"
#import <WebKit/WebKit.h>
#import "UIScrollView+WXBlankPageView.h"
#import "AFNetworkReachabilityManager.h"

@interface WXWebViewVC ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView                *webView;
@property (nonatomic, strong) UIActivityIndicatorView  *loadingView;
@end

@implementation WXWebViewVC

#pragma mark -===========生命周期方法===========
- (void)dealloc {
    if (!self.forbidObserverTitle) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    [self.webView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WX_ColorWhite();
    [self addBlankStateView];
    [self observerKeypath];
    [self loadCurrentWebURL];
    [self addHeaderRefreshKit];
}

- (void)loadCurrentWebURL {
    if (!WX_isEmptyString(self.webURL)) {
        NSString *trimmingURL = [self.webURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去除首尾空格
        NSString *decodeURL = WX_DecodeString(trimmingURL);//URL解码
        if (!WX_isEmptyString(decodeURL)) {
            [self addLoadRequestURL:decodeURL];
            [self showLoadingActivity:YES];
        }
    }
}

- (void)showLoadingActivity:(BOOL)show {
    if (show) {
        [self.loadingView startAnimating];
        [self.view bringSubviewToFront:self.loadingView];
    } else {
        [self.loadingView stopAnimating];
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

- (void)addHeaderRefreshKit {
    @weakify(self)
    [self.webView.scrollView addHeaderRefreshBlock:^{
        @strongify(self)
        [self.webView reload];
    } footerRefreshBlock:nil startRefreshing:NO];
}

- (void)goBackAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        if (self.webviewBackBlock) {
            self.webviewBackBlock();
        }
        [super goBackAction];
    }
}

/** 添加无网络/失败空白页 */
- (void)addBlankStateView {
    @weakify(self)
    self.webView.scrollView.requestFailImage = WX_ImageName(@"blankPage_networkError");
    self.webView.scrollView.requestFailTitle = @"糟糕, 页面加载失败!";
    self.webView.scrollView.requestFailBtnTitle = @"点击重试";
    self.webView.scrollView.blankTipViewActionBlcok = ^(WXBlankTipViewStatus status) {
        @strongify(self)
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            [self loadCurrentWebURL];
        } else {
            [self.webView.scrollView judgeBlankView:nil];
        }
    };
}

#pragma mark -=========== 加载WebView ===========

/**  加载页面URL */
- (void)addLoadRequestURL:(NSString *)loadURL {
    if (WX_isEmptyString(loadURL)) return;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark -===========监听WebView==========

- (void)observerKeypath {
    if (!self.forbidObserverTitle) {
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
}

#pragma mark -=========== WKWebView代理WKNavigationDelegate ===========

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self showLoadingActivity:NO];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self showLoadingActivity:NO];
    if (error) {
        [webView.scrollView judgeBlankView:nil];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 防止加载失败一直显示空白页面
    [webView.scrollView removeBlankView];
    
    if (!navigationAction.targetFrame.isMainFrame) { //规避链接新打开窗口
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSURL *url = navigationAction.request.URL;
    WX_Log(@"\n=========================== 链接地址 ======================\n👉URL👈: %@", url);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    WX_showAlertController(@"提示", message, nil, nil, @"好的", ^{
        completionHandler();
    });
}

#pragma mark -======== <LayoutSubView> ========

/// 子类实现:添加子视图
- (void)zxInitView {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.loadingView];
}

/// 子类实现: 布局视图
- (void)zxAutoLayoutView {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

#pragma mark -======== <Getter> ========

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _loadingView.color = WX_ColorHex(0x2D2D2D);
        [_loadingView hidesWhenStopped];
    }
    return _loadingView;
}

@end
