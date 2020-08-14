# GFZNetwork使用文档

### Pod集成使用：

```
source 'http://gitlab.egomsl.com/mobile/IOS/GFZPodspec.git'

pod 'GFZNetwork', '1.4'
```


[用法例子见内部Demo](http://gitlab.egomsl.com/mobile/IOS/GFZNetwork/-/archive/master/GFZNetwork-master.zip)

![](http://10.36.5.84/GFZNetwork.png)


### 1. 基础网络请求
基于AFNetwork的原生网络请求的包装，不做任何GFZ的功能定制，具体的Api属性如下：

```
/** 请求类型 */
@property (nonatomic, assign) GFZNetworkRequestType     requestType;

/** 请求地址 */
@property (nonatomic, copy)   NSString                  *requestUrl;

/** 请求参数 */
@property (nonatomic, strong) NSDictionary              *parmaters;

/** 请求超时，默认30s */
@property (nonatomic, assign) NSInteger                 timeOut;

/** 请求自定义头信息 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *requestHeaderDict;

/** 请求序列化对象 */
@property (nonatomic, strong) AFHTTPRequestSerializer  *requestSerializer;

/** 响应序列化对象 */
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

/** 上传文件Data数组 */
@property (nonatomic, strong) NSArray<NSData *>        *uploadFileDataArr;

/** 上传时包装的数据Data对象 */
@property (nonatomic, copy) GFZNetworkUploadDataBlock  uploadConfigDataBlock;

/** 监听上传进度 */
@property (nonatomic, copy) GFZNetworkProgressBlock    uploadProgressBlock;

/** 监听下载进度 */
@property (nonatomic, copy) GFZNetworkProgressBlock    downloadProgressBlock;

/** 请求任务对象 */
@property (nonatomic, strong) NSURLSessionDataTask     *requestDataTask;

/** 请求Session对象 */
@property (nonatomic, strong) NSURLSession             *urlSession;
```

使用方法如下：

```
GFZNetworkRequest *api = [[GFZNetworkRequest alloc] init];
api.requestType = GFZNetworkRequestTypeGET;
api.loadingSuperView = self.view;
api.requestUrl = @"http://t.weather.sojson.com/api/weather/city/101030100";
api.parmaters = nil;

[api startRequestWithBlock:^(GFZResponseModel *responseModel) {
    if (responseModel.isSuccess) {
        self.tipTextLabel.text = [responseModel.responseDict description];
    } else {
        self.tipTextLabel.text = [responseModel.error description];
    }
}];
```
