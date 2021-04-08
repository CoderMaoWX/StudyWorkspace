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

@interface WXStudyTabBarVC3 ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) StudyTmpView *studyTmpView;
@end

@implementation WXStudyTabBarVC3

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
    
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StudyTmpView" owner:nil options:nil];
//
//    // Find the view among nib contents (not too hard assuming there is only one view in it).
//    StudyTmpView *plainView = [nibContents lastObject];
//
//    // Some hardcoded layout.
////    CGSize padding = (CGSize){ 22.0, 22.0 };
////    plainView.frame = (CGRect){padding.width, padding.height, plainView.frame.size};
//
//    // Add to the view hierarchy (thus retain).
//    [self.view addSubview:plainView];
//    self.studyTmpView = plainView;
//
//    [self.studyTmpView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.mas_equalTo(self.view);
//    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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

#pragma mark -============== <UICollectionView> 配置父类表格数据和代理 ==============

//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
//        flowLayout.minimumLineSpacing = 12;
//        flowLayout.minimumInteritemSpacing = 12;
////        flowLayout.itemSize = CGSizeMake(150, 150);
//        flowLayout.estimatedItemSize = CGSizeMake(100, 150);
//
////        if (@available(iOS 10.0, *)) {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
////        } else {
////            // Fallback on earlier versions
////        }//
//
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        CGFloat height = [UIScreen mainScreen].bounds.size.height;
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height - 88) collectionViewLayout:flowLayout];
//        _collectionView.backgroundColor = self.view.backgroundColor;
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.alwaysBounceHorizontal = YES;
//
////        [_collectionView registerClass:[WXCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([WXCollectionViewCell class])];
//
//        UINib *nib = [UINib nibWithNibName:NSStringFromClass([WXCollectionViewCell class]) bundle:nil];
//        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([WXCollectionViewCell class])];
//    }
//    return _collectionView;
//}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;//self.listDataArray.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
//        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
//        if (CGSizeEqualToSize(flowLayout.estimatedItemSize, CGSizeZero)) {
//            return flowLayout.itemSize;
//        } else {
//            return flowLayout.estimatedItemSize;
//        }
//    }
//    return CGSizeMake(80.0, 80.0);//System Cell Size
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WXCollectionViewCell class]) forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return cell;
}

@end
