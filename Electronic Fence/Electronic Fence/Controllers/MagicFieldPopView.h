//
//  MagicFieldPopView.h
//  APNFD
//
//  Created by satyso on 14-2-19.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>



#import "PopBar.h"
#import "PopLoadingBar.h"
#import "PopPanel.h"

#import "UIScrollView+TouchEvent.h"
#import "UIColor+HexString.h"

@interface MagicFieldPopView : UIView

/**
 *  初始化控件
 *
 *  @param view 依赖的控件
 *
 *  @return self
 */
- (instancetype)initWithDependentView:(UIView*)view;

/**
 *  显示popBar(小横条，展示发现内容)
 *
 *  @param logoImagePath 图标path
 *  @param title         标题
 *  @param content       内容
 *  @param yesOrNo       控件出现是否需要动画效果
 *  @param completion    控件出现动画完成的回调
 */
- (void)showPopBarWithLogo:(NSString*)logoImagePath
                     title:(NSString*)title
                   content:(NSString*)content
                  animaion:(BOOL)yesOrNo
                completion:(void (^)(BOOL finished))completion;

/**
 *  展示popPanel(面板，展示详细的服务信息)
 *
 *  @param logoIamgePath 图标path
 *  @param title         标题
 *  @param content       内容
 *  @param yesOrNo       控件出现是否需要动画效果
 *  @param completion    控件出现动画完成的回调
 */
- (void)showPopPanelWithLogo:(NSString*)logoIamgePath
                       title:(NSString*)title
                     content:(NSString*)content
                    animaion:(BOOL)yesOrNo
                  completion:(void (^)(BOOL finished))completion;

/**
 *  展示popLoadingBar(服务载入提示)
 *
 *  @param yesOrNo    控件出现是否需要动画效果
 *  @param completion 控件出现动画完成的回调
 */
- (void)showPopLoadingBarWithAnimaion:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  隐藏popBar(小横条，展示发现内容)
 *
 *  @param yesOrNo    控件的隐藏是否需要动画效果
 *  @param completion 控件隐藏动画完成的回调
 */
- (void)hidePopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  隐藏popPanel(面板，展示详细的服务信息)
 *
 *  @param yesOrNo    控件的隐藏是否需要动画效果
 *  @param completion 控件隐藏动画完成的回调
 */
- (void)hidePopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  隐藏popLoadingBar(服务载入提示)
 *
 *  @param yesOrNo    控件的隐藏是否需要动画效果
 *  @param completion 控件隐藏动画完成的回调
 */
- (void)hidePopLoadingBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

@end
