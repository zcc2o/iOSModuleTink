//
//  ZCCBaseTableViewCell.m
//  ZCCUIComponent
//

#import "ZCCBaseTableViewCell.h"

@implementation ZCCBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zcc_setupSubviews];
    }
    return self;
}

- (void)zcc_setupSubviews {
    // 子类重写
}

- (void)zcc_bindModel:(id)model {
    // 子类重写
}

@end
