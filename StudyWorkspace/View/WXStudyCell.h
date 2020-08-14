//
//  WXStudyCell.h
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface WXStudyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, strong) WXDataModel *dataModel;

@end

NS_ASSUME_NONNULL_END
