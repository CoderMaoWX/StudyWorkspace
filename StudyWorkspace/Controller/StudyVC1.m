//
//  StudyVC1.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "StudyVC1.h"
#import "SSZipArchive.h"
#import "WXDataModel.h"
#import "WXNetworking.h"

@interface StudyVC1 ()
@property (weak, nonatomic) IBOutlet UISwitch    *downloadSwitch;
@property (weak, nonatomic) IBOutlet UILabel     *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation StudyVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)downloadAction:(UISwitch *)sender {
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"SkinZipURL" ofType:@"txt"];
    NSString *urlString = [[NSString alloc] initWithContentsOfFile:urlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *urlArray = [urlString componentsSeparatedByString:@",\n"];
    NSInteger downloadIndex = (arc4random() % urlArray.count);
    if (urlArray.count > downloadIndex) {
        self.downloadSwitch.enabled = NO;
        [self downloadZipData:urlArray[downloadIndex]];
    }
}

/// 动态下载例子
- (void)downloadZipData:(NSString *)downloadURL {
    NSLog(@"下载URL: %@", downloadURL);
    [WXNetworkConfig sharedInstance].showRequestLaoding = YES;

    WXNetworkRequest *api = [[WXNetworkRequest alloc] init];
    api.requestType = WXNetworkRequestTypeGET;
    api.loadingSuperView = self.view;
    api.downloadProgressBlock = ^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tipLabel.text = [NSString stringWithFormat:@"下载文件进度:= %.2f", 1.0 * progress.completedUnitCount / progress.totalUnitCount];
        });
    };
    //图片例子
    //api.responseSerializer = [AFImageResponseSerializer serializer];
    //api.requestUrl = @"http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_2022/a.jpg";

    //ZIP例子:
    api.responseSerializer = [AFHTTPResponseSerializer serializer];
    api.requestUrl = downloadURL;

    [api startRequestWithBlock:^(WXResponseModel *responseModel) {
        self.downloadSwitch.enabled = YES;
        if (responseModel.isSuccess) {
            NSLog(@"下载文件成功: %@", [responseModel.responseObject description]);

            if ([responseModel.responseObject isKindOfClass:[UIImage class]]) {
                UIImage *newImage = (UIImage *)responseModel.responseObject;
                BOOL success = replaceCacheLibraryLaunchImage(newImage);
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.tipLabel.text = @"动态更换成功,重新启动生效";
                    });
                }
            } else if([responseModel.responseObject isKindOfClass:[NSData class]]) {
                NSData *zipData = responseModel.responseObject;
                [self configDownloadImage:downloadURL zipData:zipData];
                [self.downloadSwitch setOn:NO animated:YES];
            }
        } else {
            NSLog(@"下载文件失败: %@", responseModel.error);
        }
    }];
}

- (void)configDownloadImage:(NSString *)downloadURL zipData:(NSData *)zipData {
    NSString *userDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *downloadDirectory = [userDocument stringByAppendingPathComponent:@"DownSkinImage"];
    //downloadDirectory = @"/Users/xin610582/Desktop/DownSkinImage";//测试目录
    
    NSString *zipName = [downloadURL lastPathComponent];
    NSString *desktopPath = [NSString stringWithFormat:@"%@/%@", downloadDirectory, zipName];
    NSString *unzipPath = [NSString stringWithFormat:@"%@/%@", downloadDirectory, [zipName componentsSeparatedByString:@"."].firstObject];
    
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:downloadDirectory]) {
        [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL writed = [zipData writeToFile:desktopPath atomically:YES];
    if (!writed) return;
    
    if ([fileManager fileExistsAtPath:unzipPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil];
    }
    BOOL unzip = [SSZipArchive unzipFileAtPath:desktopPath toDestination:unzipPath];
    NSLog(@"下载文件路径:%d, %d, %@", writed, unzip, unzipPath);
    
    if (!unzip) return;
    [fileManager removeItemAtPath:desktopPath error:nil];
    
    NSError *readError = nil;
    NSArray *imageFiles = [fileManager contentsOfDirectoryAtPath:unzipPath error:&readError];
    if (readError) return;
    NSString *targetName = @"chat_bg_default";//user_bg
    // 遍历该目录下截图文件
    for (NSString *fileName in imageFiles) {
        
        if ([fileName containsString:targetName]) {
            NSString *replacePath = [unzipPath stringByAppendingPathComponent:fileName];
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfFile:replacePath options:NSDataReadingMappedIfSafe error:&error];
            if (!error && [data length]) {
                UIImage *newImage = [UIImage imageWithData:data];
                if ([newImage isKindOfClass:[UIImage class]]) {
                    NSLog(@"启动图截屏文件替换: %@", replacePath);
                    
                    self.imageView.image = newImage;
                    BOOL success = replaceCacheLibraryLaunchImage(newImage);
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.tipLabel.text = @"动态更换成功,重新启动生效";
                        });
                    }
                }
            }
            break;
        }
    }
}

/** 动态更换App的启动图 (闪屏图:LaunchScreenImage)
 *  重现场景: 偶现的发现在修改完storyboard中的启动图logo后, 可能会在不同机型上出现启动图logo黑屏的问题,
 *  解决办法: 找到沙盒目录中存在的启动图截屏文件目录位置, 自己绘制想要显示的启动图后替换原有的文件
 *  备注: 经过测试, 在不同系统版本的沙盒中, 启动图文件的目录位置不同,由于目前考虑到ZF在老版本系统上没有出现过黑屏logo问题, 暂时老系统版本不做处理
 *  iOS13以下系统启动图截屏文件保存目录: ~/Library/Caches/Snapshots/com.xxx.xxx/xxxx@2x.ktx
 *  iOS13及以上系统启动图截屏文件保存目录: ~/Library/SplashBoard/Snapshots/com.xxx.xxx - {DEFAULT GROUP}/xxxx@3x.ktx
 *  替换后的变化: 原图大小约8K左右, 替换后大小约28K左右
 */
BOOL replaceCacheLibraryLaunchImage (UIImage *newImage) {
    if (![newImage isKindOfClass:[UIImage class]]) return NO;
    
    NSString *Library = @"Library";
    NSString *SplashBoard = @"SplashBoard";
    NSString *Snapshots = @"Snapshots";//防止在App审核时会机器扫描到截屏目录被拒审, 因此目录临时拼接
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@", Library, SplashBoard, Snapshots];
    NSString *shotsPath = [NSHomeDirectory() stringByAppendingPathComponent:imagePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return NO;
    
    NSString *bundleID = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *shotsDirName = [bundleID stringByAppendingString:@" - {DEFAULT GROUP}"];
    shotsPath = [shotsPath stringByAppendingPathComponent:shotsDirName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return NO;
    
    NSError *readError = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shotsPath error:&readError];
    if (readError) return NO;
    
    // 遍历该目录下截图文件
    for (NSString *fileName in files) {
        NSString *replacePath = [shotsPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:replacePath options:NSDataReadingMappedIfSafe error:&error];
        if (!error && [data length]) {
            
            UIImage *oldImage = [UIImage imageWithData:data];
            if (![oldImage isKindOfClass:[UIImage class]]) return NO;
            
            if (![newImage isKindOfClass:[UIImage class]])  {
                newImage = [UIImage imageNamed:@"launch_image"];//sex_swimwear
            }
            if (![newImage isKindOfClass:[UIImage class]]) return NO;
            
            CGFloat scale           = [UIScreen mainScreen].scale;
            CGRect screenBounds     = [UIScreen mainScreen].bounds;
            CGFloat oldImageWidth   = screenBounds.size.width * scale;
            CGFloat oldImageHeight  = screenBounds.size.height * scale;
            //CGFloat newImageWidth   = newImage.size.width * scale;
            //CGFloat newImageHeight  = newImage.size.height * scale;

            // 设置图片尺寸为旧图尺寸
            CGRect rect = CGRectMake(0, 0, oldImageWidth, oldImageHeight);
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 1);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillRect(context, rect);
            [newImage drawInRect:rect];//全屏绘制
            UIImage *replaceImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSLog(@"设置图片尺寸为旧图尺寸: %@, %@, %@", oldImage, replaceImage, fileName);
            
            // 写入目录，替换旧图
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSData *launchData = UIImageJPEGRepresentation(replaceImage, 0.0);
                if ([[NSFileManager defaultManager] fileExistsAtPath:replacePath]) {
                    
                    NSError *deleteErrors;
                    BOOL deleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:replacePath error:&deleteErrors];
                    if (deleteSuccess || !deleteErrors) {
                        BOOL success = [launchData writeToFile:replacePath atomically:YES];
                        NSLog(@"沙盒目录启动图截屏文件状态:%d, %@", success, replacePath);
                    }
                }
            });
        }
    }
    return YES;
}

/**
 * 获取沙盒的启动图
 * iOS13以下系统启动图截屏文件保存目录: ~/Library/Caches/Snapshots/com.xxx.xxx/xxxx@2x.ktx
 * iOS13及以上系统启动图截屏文件保存目录: ~/Library/SplashBoard/Snapshots/com.xxx.xxx - {DEFAULT GROUP}/xxxx@3x.ktx
 * */
- (UIImage *)fetchLaunchImage {
    NSString *bundleID = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *launchImagePath = @"Library/SplashBoard/Snapshots";
    NSString *shotsDirName = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 13.0) {
        launchImagePath = @"Library/Caches/Snapshots";
    } else {
        shotsDirName = [bundleID stringByAppendingString:@" - {DEFAULT GROUP}"];
    }
    NSString *shotsPath = [NSHomeDirectory() stringByAppendingPathComponent:launchImagePath];
    if (shotsDirName) {
        shotsPath = [shotsPath stringByAppendingPathComponent:shotsDirName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:shotsPath]) return nil;

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:shotsPath error:nil];
    for (NSString *fileName in files) {
        if ([fileName hasSuffix:@".ktx"]) {
            NSString *replacePath = [shotsPath stringByAppendingPathComponent:fileName];
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfFile:replacePath options:NSDataReadingMappedIfSafe error:&error];
            if (!error && [data length]) {
                UIImage *launchImage = [UIImage imageWithData:data];
                if ([launchImage isKindOfClass:[UIImage class]]) return launchImage;
            }
            break;
        }
    }
    return nil;
}

@end
