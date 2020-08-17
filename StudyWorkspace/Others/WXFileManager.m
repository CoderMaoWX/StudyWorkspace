//
//  WXFileManager.m
//  CommonFrameWork
//
//  Created by mao wangxin on 2017/2/7.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "WXFileManager.h"
#import "WXPublicHeader.h"

@implementation WXFileManager

/**
 *  创建文件夹
 *
 *  @param rootPath      路径，必须是文件夹路径
 *  @param directoryName 路径下面的文件夹名字
 *
 *  @return 返回整个文件夹的路径
 */
+(NSString *)creatDirectoryRootPath:(NSString *)rootPath
                   andDirectoryName:(NSString *)directoryName{
    
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@", rootPath,directoryName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}

/**
 *  得到沙盒的缓存路径
 */
+ (NSString *)cacheDir
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  得到沙盒根目录
 */
+ (NSString *)docDir
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  得到沙盒临时目录
 */
- (NSString *)tmpDir
{
    return  NSTemporaryDirectory();;
}

/**
 * 获取tabbar目录的
 */
+ (NSString *)getTabBarDirectory{
    return [WXFileManager creatDirectoryRootPath:[WXFileManager cacheDir] andDirectoryName:kWXabBarImagePathKey];
}


/**
 计算self这个文件夹\文件的大小
 */
- (unsigned long long)ok_fileSize:(NSString *)filePath
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件类型
    NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    NSString *fileType = attrs.fileType;
    
    if ([fileType isEqualToString:NSFileTypeDirectory]) { // 文件夹
        // 获得文件夹的遍历器
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:filePath];
        
        // 总大小
        unsigned long long fileSize = 0;
        
        // 遍历所有子路径
        for (NSString *subpath in enumerator) {
            // 获得子路径的全路径
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            fileSize += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        
        return fileSize;
    }
    
    // 文件大小
    return attrs.fileSize;
}

/**
 把对象归档存到沙盒里
 */
+(void)saveObject:(id)object byFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:path];
}

/**
 通过文件名从沙盒中找到归档的对象
 */
+(id)getObjectByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/**
 根据文件名删除沙盒中的 plist 文件
 */
+(void)removeFileByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 拼接文件路径
 */
+(NSString*)appendFilePath:(NSString*)fileName
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *file = [NSString stringWithFormat:@"%@/%@.archiver",documentsPath,fileName];
    return file;
}

/**
 存储用户偏好设置 到 NSUserDefults
 */
+(void)saveUserData:(id)data forKey:(NSString*)key
{
    if (data)
    {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

/**
 读取用户偏好设置
 */
+(id)readUserDataForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
}

/**
 删除用户偏好设置
 */
+(void)removeUserDataForkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end

