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
    
    // @{ 要测试的VC : 对应类的功能描述 }
    for (NSInteger i=0; i<100; i++) {
        [self.listDataArray addObject:@(i)];
    }
    [self.collectionView reloadData];
}

///由子类覆盖: 表格需要注册的Cell
- (Class)registerCollectionViewCell {
    return [WXCollectionViewCell class];
}

///由子类覆盖: 配置表格布局样式
- (void)configFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, kStatusBarHeight, 0);
    flowLayout.itemSize = CGSizeMake(200.0, 200.0);
}

///由子类覆盖: 配置表格数据方法
- (ZXCollectionViewConfigBlock)cellForItemBlock {
    return ^ (UICollectionViewCell *cell, id itemData, NSIndexPath *indexPath) {
        cell.contentView.backgroundColor = WX_ColorRandom();
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