//
//  StudyVC11.m
//  DrawDemo
//
//  Created by mao wangxin on 2017/6/3.
//  Copyright © 2017年 Luke. All rights reserved.
//

#import "StudyVC11.h"

@interface StudyVC11 ()<CAAnimationDelegate>

@end

@implementation StudyVC11

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"23"].CGImage;
    
}

- (IBAction)buttonAction:(UIButton *)sender
{
    //百叶窗动画
    [self blindTransitionAnimation];
}


/**
 *  百叶窗动画
 */
- (void)blindTransitionAnimation
{
    NSInteger separateCount = 15;
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    self.view.layer.contents = nil;
    
    NSDictionary *dice = [self separateImage:bgImage separate:separateCount cacheQuality:0.5];
    // 百叶窗动画
    CABasicAnimation *rotation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotation.duration = 2;
    rotation.fromValue = [NSNumber numberWithFloat:0];    // 从0°开始
    rotation.toValue = [NSNumber numberWithFloat:M_PI_2]; // 转动180°
    rotation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    rotation.autoreverses = YES;  // 翻转后是否反向翻转
    rotation.repeatCount = MAXFLOAT;    // 循环次数
    rotation.delegate = self;    // 动画代理
    NSArray *keys=[dice allKeys];
    for (int count = 0; count < separateCount; count++)
    {
        NSString *key=[keys objectAtIndex:count];
        UIImageView *imageView=[dice objectForKey:key];
        [imageView.layer addAnimation:rotation forKey:@"rotation"];
        [self.view addSubview:imageView];
    }
}


/**
 *  图片切割
 *
 *  @param image   需要切割的图片
 *  @param x       切割的份数
 *  @param quality 切割的质量
 *
 *  @return 切割后小图片的文件路径
 */
- (NSDictionary *)separateImage:(UIImage *)image separate:(NSInteger)x cacheQuality:(CGFloat)quality
{
    // 错误处理
    if (x<1) {
        NSLog(@"illegal x!");
        return nil;
    }
    if (![image isKindOfClass:[UIImage class]]) {
        NSLog(@"illegal image format!");
        return nil;
    }
    
    CGFloat multiple = 1;//[UIScreen mainScreen].scale;
    
    CGFloat xstep = image.size.width * multiple;
    CGFloat ystep = image.size.height * multiple/x;
    NSMutableDictionary *mutableDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
    NSString *prefixName = @"win";
    
    // 把图片裁剪为小图片存进沙盒
    for (int i=0; i<x; i++)
    {
        for (int j=0; j<1; j++)
        {
            CGRect rect=CGRectMake(xstep*j, ystep*i, xstep, ystep);
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
            UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
            UIImageView *imageView=[[UIImageView alloc] initWithImage:elementImage];
            imageView.frame=rect;
            NSString *imageString=[NSString stringWithFormat:@"%@_%d_%d.jpg",prefixName,i,j];
            // 切割后的图片保存进字典        图片               图片名
            [mutableDictionary setObject:imageView forKey:imageString];
            
            if (quality<=0)
            {
                continue;
            }
//            quality=(quality>1)?1:quality;
//            // 切割后的图片写进文件
//            NSString *imagePath=[NSHomeDirectory() stringByAppendingPathComponent:imageString];
//            // 图片压缩 quality是压缩系数  0~1 之间
//            NSData *imageData=UIImageJPEGRepresentation(elementImage, quality);
//            // 压缩后的图片 写进文件
//            [imageData writeToFile:imagePath atomically:NO];
        }
    }
    NSDictionary *dictionary = mutableDictionary;
    return dictionary;
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
