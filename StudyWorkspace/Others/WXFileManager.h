//
//  WXFileManager.h
//  CommonFrameWork
//
//  Created by mao wangxin on 2017/2/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXFileManager : NSObject


/**
 *  创建文件夹
 */
+(NSString *)creatDirectoryRootPath:(NSString *)rootPath
                   andDirectoryName:(NSString *)directoryName;

/**
 *  得到沙盒的缓存路径
 */
+ (NSString *)cacheDir;

/**
 *  得到沙盒document目录
 */
+ (NSString *)docDir;

/**
 *  得到沙盒临时目录
 */
- (NSString *)tmpDir;

/**
 * 获取tabbar目录的
 */
+ (NSString *)getTabBarDirectory;

/**
 计算self这个文件夹\文件的大小
 */
- (unsigned long long)ok_fileSize:(NSString *)filePath;

/**
 *  把对象归档存到沙盒里
 */
+(void)saveObject:(id)object byFileName:(NSString*)fileName;

/**
 *  通过文件名从沙盒中找到归档的对象
 */
+(id)getObjectByFileName:(NSString*)fileName;

/**
 *  根据文件名删除沙盒中的 plist 文件
 */
+(void)removeFileByFileName:(NSString*)fileName;

/**
 *  存储用户偏好设置 到 NSUserDefults
 */
+(void)saveUserData:(id)data forKey:(NSString*)key;

/**
 *  读取用户偏好设置
 */
+(id)readUserDataForKey:(NSString*)key;

/**
 *  删除用户偏好设置
 */
+(void)removeUserDataForkey:(NSString*)key;

@end
