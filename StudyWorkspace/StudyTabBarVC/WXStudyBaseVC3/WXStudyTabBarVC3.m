//
//  WXStudyTabBarVC3.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/28.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXStudyTabBarVC3.h"
#import "WXCollectionViewCell.h"
#import "StudyTmpView.h"
#import "Masonry.h"
#import "WXNetworking.h"

@interface WXStudyTabBarVC3 ()
@property (nonatomic, strong) StudyTmpView *studyTmpView;
@end

@implementation WXStudyTabBarVC3

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *text = @"随着网络的迅速发展，万维网成为大量信息的载体，如何有效地提取并利用这些信息成为一个巨大的挑战 ! ";
    
    for (NSInteger i=0; i<20; i++) {
        NSMutableString *string = [NSMutableString stringWithString:text];
        for (NSInteger j=0; j<i; j++) {
            [string appendFormat:@"%@ %ld", text, (long)j];
        }
        [self.listDataArray addObject:string];
    }
    [self.collectionView reloadData];
    
    [self saveDocument];
}

- (void)saveDocument {
    
//    //云端文档转存: https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
    
//    NSURL *cloudImgUrl = [NSURL fileURLWithPath:
//                          [NSString stringWithFormat:@"%@/%@",kCacheDirectory,self.fileObject.name]];
//    UIDocumentInteractionController *tmpUIDocumentInteractionController
//    = [[UIDocumentInteractionController interactionControllerWithURL:cloudImgUrl] retain];
//    tmpUIDocumentInteractionController.UTI = @"public.data";
//    tmpUIDocumentInteractionController.delegate = self;
//    if (![tmpUIDocumentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES])
//    {
//        [tmpUIDocumentInteractionController release];
//        [[YBProgressShow defaultProgress] showText:NSLocalizedString(@"filemgr_other_app_canotopen", nil)
//                                            InMode:MBProgressHUDModeText
//                             OriginViewEnableTouch:YES HideAfterDelayTime:1];
//    }
//
}

///由子类覆盖: 表格需要注册的Cell <UICollectionViewCell.type>
- (NSArray<Class> *)registerCollectionViewCell {
    return @[ [WXCollectionViewCell class] ];
}

///由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, kStatusBarHeight+10, 10);
    CGFloat size = (kScreenWidth - 10 * 3) / 2.0;
    flowLayout.itemSize = CGSizeMake(size, size);
//    flowLayout.estimatedItemSize = CGSizeMake(150, 150);
}

///由子类覆盖: 配置表格数据方法
- (WXCollectionViewCellBlock)cellForItemBlock {
    return ^ (WXCollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
        cell.contentView.backgroundColor = WX_ColorRandom();
        cell.textLabel.text = itemData;
    };
}

- (void)requestData {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/a7cb21c736b358d436d6c08038185154"]];
    
    WXNetworkRequest *request = [[WXNetworkRequest alloc] init];
    request.requestType = WXNetworkRequestTypeGET;
    request.requestUrl = @"http://www.pgyer.com/apiv1/app/install?_api_key=63ac25e7297c94e9a6382900e9675b95&aKey=a7cb21c736b358d436d6c08038185154";
//    request.parameters = @{
//        @"_api_key" : @"63ac25e7297c94e9a6382900e9675b95",
//        @"appKey"  : @"a7cb21c736b358d436d6c08038185154"
//    };
    [request startRequestWithBlock:^(WXResponseModel *responseModel) {
        NSLog(@"responseModel: %@", responseModel.responseDict);
    }];
}

- (void)testLoadXib {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StudyTmpView" owner:nil options:nil];

    // Find the view among nib contents (not too hard assuming there is only one view in it).
    StudyTmpView *plainView = [nibContents lastObject];

    // Some hardcoded layout.
//    CGSize padding = (CGSize){ 22.0, 22.0 };
//    plainView.frame = (CGRect){padding.width, padding.height, plainView.frame.size};

    // Add to the view hierarchy (thus retain).
    [self.view addSubview:plainView];
    self.studyTmpView = plainView;

    [self.studyTmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.view);
    }];
}

@end
