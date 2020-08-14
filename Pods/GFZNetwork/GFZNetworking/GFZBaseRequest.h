//
//  GFZBaseRequest.h
//  GFZNetwork
//
//  Created by 610582 on 2019/8/28.
//  Copyright © 2019 GFZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"

@class GFZResponseModel, AFHTTPRequestSerializer, AFHTTPResponseSerializer, GFZNetworkBatchRequest;

///  HTTP Request method
typedef NS_ENUM(NSInteger, GFZNetworkRequestType) {
    GFZNetworkRequestTypePOST = 0,
    GFZNetworkRequestTypeGET,
    GFZNetworkRequestTypeHEAD,
    GFZNetworkRequestTypePUT,
    GFZNetworkRequestTypeDELETE,
    GFZNetworkRequestTypePATCH,
};

typedef void(^GFZNetworkResponseBlock) (GFZResponseModel *responseModel);
typedef void(^GFZNetworkBatchBlock) (NSArray<GFZResponseModel *> *responseModelArray, GFZNetworkBatchRequest *batchRequest);
typedef void(^GFZNetworkSuccessBlock) (id responseObject);
typedef void(^GFZNetworkFailureBlcok) (NSError *error);
typedef void(^GFZNetworkProgressBlock) (NSProgress *progress);
typedef void(^GFZNetworkUploadDataBlock) (id<AFMultipartFormData> formData);


@protocol GFZPackParameters <NSObject>
@optional
/**
 外部可包装最终网络底层最终请求参数

 @param parameters 默认外部传进来的<parameters>
 @return 网络底层最终的请求参数
 */
- (NSDictionary *)parametersWillTransformFromOriginParamete:(NSDictionary *)parameters;
@end


@interface GFZBaseRequest : NSObject


/** 请求类型 */
@property (nonatomic, assign) GFZNetworkRequestType     requestType;

/** 请求地址 */
@property (nonatomic, copy)   NSString                  *requestUrl;

/** 请求参数 */
@property (nonatomic, strong) NSDictionary              *parameters;

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

/** 底层最终的请求参数 (页面上可实现<GFZPackParameters>协议来实现重新包装请求参数) */
@property (nonatomic, strong, readonly) NSDictionary    *finalParameters;

/** 请求任务对象 */
@property (nonatomic, strong, readonly) NSURLSessionDataTask *requestDataTask;

/** 请求Session对象 */
@property (nonatomic, strong, readonly) NSURLSession    *urlSession;


/*
 * 网络请求方法 (原始的AFNetwork请求，页面上不建议直接用，请使用子类请求方法)
 * @parm successBlock 请求成功回调block
 * @parm failureBlock 请求失败回调block
 */
- (NSURLSessionDataTask *)requestWithBlock:(GFZNetworkSuccessBlock)successBlock
                              failureBlock:(GFZNetworkFailureBlcok)failureBlock;

@end
