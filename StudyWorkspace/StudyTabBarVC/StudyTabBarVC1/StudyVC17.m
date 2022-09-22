//
//  StudyVC17.m
//  StudyWorkspace
//
//  Created by 610582 on 2022/9/13.
//  Copyright © 2022 MaoWX. All rights reserved.
//

#import "StudyVC17.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>

//声明的协议，当前viewController必须遵守
@protocol JSObjcDelegate <JSExport>
- (void)jsCallNative;
- (void)shareString:(NSString *)shareString;
@end


@interface StudyVC17 ()<WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler>
/**WKWebView*/
@property (strong, nonatomic)WKWebView *webView;
@property (strong, nonatomic)JSContext *jsContext;
@end


@implementation StudyVC17
#pragma mark- init初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebview];
    [self loadLocalHttpServer];
}

- (void)setWebview{
//    NSString *js = @"document.getElementsByClassName('libao')[0].style.display='none';document.getElementsByClassName('mengceng_1')[0].style.display='none';document.getElementById('icon_7724').style.display='none'";
//
//    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart  forMainFrameOnly:YES];//初始化WKUserScript对象，在为网页加载完成时注入
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    [config.userContentController addUserScript:script];
    
    
//    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//    [userContentController addScriptMessageHandler:self name:@"jsCallNative"];
//    [userContentController addScriptMessageHandler:self name:@"NativeObject.shareString"];
//    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.userContentController   = userContentController;
//    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = UIColor.whiteColor;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    /**参数1：index 是要打开的html的名称
        参数2：html 是index的后缀名
     参数3：HtmlFile/app/index 是文件夹的路径
    */
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"js-interaction" ofType:@"html"];
    NSURL *pathURL = [NSURL fileURLWithPath:filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];

}

//方法实现，在webViewDidFinishLoad中调用
- (void)doSomeJsThings {
    
    self.jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"出现异常，异常信息：%@",exception);
    };
    
    //oc调用js
    JSValue * jsObj = self.jsContext[@"globalObject"];//拿到js中要调用方法的全局对象
    //jsObj执行其方法nativeCallJS
    JSValue * returnValue = [jsObj invokeMethod:@"nativeCallJS" withArguments:@[@"hello word"]];
   //调用了js中方法"nativeCallJS",并且传参数@"hello word",这里returnValue是调用之后的返回值，可能为nil
    NSLog(@"returnValue:%@",returnValue);
    
    //写法1
    JSValue * jsCallNative = [JSValue valueWithObject:self inContext:self.jsContext];//此方法会转换self为JS对象，但是self中必须实现指定的方法和协议
    self.jsContext[@"NativeObject"] = jsCallNative;
    //写法2
    //self.jsContext[@"NativeObject"] = self;
    //注：写法1和写法2效果相同，推荐写法1，毕竟系统方法
}

- (void)jsCallNative{//在本地生成js方法，供js调用
    
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParamers = [JSContext currentArguments];
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  js调起OC代码，代码在子线程，更新OC中的UI，需要回到主线程
         */
    });
    NSLog(@"currentThis is %@",[currentThis toString]);
    NSLog(@"currentCallee is %@",[currentCallee toString]);
    NSLog(@"currentParamers is %@",currentParamers);
}


- (void)shareString:(NSString *)shareString{//在本地生成js方法，供js调用
    
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParamers = [JSContext currentArguments];
    dispatch_async(dispatch_get_main_queue(), ^{
        /**
         *  js调起OC代码，代码在子线程，更新OC中的UI，需要回到主线程
         */
        NSLog(@"js传过来：%@",shareString);
    });
    NSLog(@"JS paramer is %@",shareString);
    NSLog(@"currentThis is %@",[currentThis toString]);
    NSLog(@"currentCallee is %@",[currentCallee toString]);
    NSLog(@"currentParamers is %@",currentParamers);
}

- (BOOL)loadLocalHttpServer{
//    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *port = appd.serverPort;
//    if (port == nil) {
//        return NO;
//    }
//    NSString *str = [NSString stringWithFormat:@"http://localhost:%@", port];
//    NSURL *url = [NSURL URLWithString:str];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    return YES;
}

//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"didReceiveScriptMessage：%@", message);
    
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //设置addScriptMessageHandler与name.并且设置<WKScriptMessageHandler>协议与协议方法
    [[_webView configuration].userContentController addScriptMessageHandler:self name:@"jsCallNative"];
    return;
    
    // 设置javaScriptContext上下文
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将bsg对象指向自身//网页端设置点击方法：bsg.call()，call()方法由bsg对象调用，此处将自身设置为bsg对象，用来调用本地方法而非网页方法
    self.jsContext[@"ios"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //WKWebView:网页URL和内容变化的时候调用
    NSURL *url = [navigationAction.request URL];
    NSLog(@"shouldStartLoadWithRequest = %@", [url absoluteString]);
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
//    if (YES == [self willGotoOutSideWebViewByKey:@"skipType=goNative" observerUrl:url]) {
//        NSDictionary *parameterDict = [self analysisParameterWithURL:url];
//        NSLog(@"shouldStartLoadWithRequest-参数:%@",parameterDict);
//        BYVideoDetailVC *videoDetailVC = [[BYVideoDetailVC alloc]init];
//        videoDetailVC.videoType = BYSafeStr([parameterDict objectForKey:@"courseType"]);//视频的类型：1点播、2直播
//        videoDetailVC.courseId = BYSafeStr([parameterDict objectForKey:@"id"]);//当前课程id 6a328f708d2f4431aeb9c670c13bba6a
//        NSString *token = BYSafeStr([parameterDict objectForKey:@"token"]);//@"4cde92f1e8fd159d3d5205a057861b46";
//        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"userToken"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        videoDetailVC.chapterId = BYSafeStr([parameterDict objectForKey:@"charpterId"]);//@"";//当前章节的id
//        videoDetailVC.vodeoPath = BYSafeStr([parameterDict objectForKey:@"path"]);//@"";//视频路径
//        [self presentViewController:videoDetailVC animated:YES completion:nil];
//        //        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:videoDetailVC] animated:YES completion:nil];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}

- (BOOL)willGotoOutSideWebViewByKey:(NSString *)key observerUrl:(NSURL *)url {//判断url是否包含字符串key
    if (nil != url) {
        NSRange _rang = [[url absoluteString] rangeOfString:key];
        if(_rang.length > 0 && _rang.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)analysisParameterWithURL:(NSURL *)url {//将url所有参数转化为字典
    NSMutableDictionary *paraDic= [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paraDic setObject:obj.value forKey:obj.name];
    }];
    return paraDic;
}

- (void)dealloc{
    NSLog(@"已释放");
}


@end
