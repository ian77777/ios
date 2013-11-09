//
//  BIDPresident.h
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIDPresident : NSObject <NSCoding, NSCopying>

@property (assign, nonatomic) NSInteger number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fromYear;
@property (copy, nonatomic) NSString *toYear;
@property (copy, nonatomic) NSString *party;

@end
