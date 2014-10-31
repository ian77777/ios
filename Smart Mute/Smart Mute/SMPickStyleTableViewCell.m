//
//  SMPickStyleTableViewCell.m
//  Smart Mute
//
//  Created by 凯子 on 14/10/29.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "SMPickStyleTableViewCell.h"

@interface SMPickStyleTableViewCell ()
@property (nonatomic, strong) UIDatePicker *datePicker;
//@property (nonatomic, strong) NSDictionary *data;
@end

@implementation SMPickStyleTableViewCell

- (id)initWithType:(kSMPickViewType)pickViewType withStyle:(UITableViewCellStyle)cellStyle
{
    self = [super initWithStyle:cellStyle reuseIdentifier:nil];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (pickViewType != kSMPickViewTypeNone) {
            self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 216.0)];
            self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            [self.contentView addSubview:self.datePicker];
        }
    }
    return self;
}

- (void)selectPickViewWithDate:(NSDate *)date
{
    [self.datePicker setDate:date animated:NO];
}

- (NSDate *)getCurrentDate
{
    return self.datePicker.date;
}

@end
