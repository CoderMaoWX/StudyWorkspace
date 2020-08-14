//
//  WXStudyCell.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "WXStudyCell.h"
#import "WXDataModel.h"

@implementation WXStudyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataModel:(WXDataModel *)dataModel {
    if (![dataModel isKindOfClass:[WXDataModel class]]) return;
    _dataModel = dataModel;
}
@end
