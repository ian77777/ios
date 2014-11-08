//
//  SMPickStyleTableViewCell.h
//  Smart Mute
//
//  Created by 凯子 on 14/10/29.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kSMPickViewType) {
    kSMPickViewTypeStart,
    kSMPickViewTypeEnd,
    kSMPickViewTypeNone
};

@interface SMPickStyleTableViewCell : UITableViewCell
- (id)initWithType:(kSMPickViewType)pickViewType withStyle:(UITableViewCellStyle)cellStyle;
- (void)selectPickViewWithDate:(NSDate *)date;
- (NSDate *)getCurrentDate;
@end
