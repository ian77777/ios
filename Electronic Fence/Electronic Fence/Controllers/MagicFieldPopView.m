//
//  MagicFieldPopView.m
//  APNFD
//
//  Created by satyso on 14-2-19.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "MagicFieldPopView.h"

#define KPopBarHeight 20
#define KPopPanelHeight 80

#define KPopBarRect CGRectMake(0, 0  - KPopBarHeight, self.frame.size.width, KPopBarHeight)
#define KPopPanelRect CGRectMake(0, 0, self.frame.size.width, KPopPanelHeight)


@interface MagicFieldPopView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView*     scrollView;

@property (nonatomic, strong) PopLoadingBar*    popLoadingBar;

@property (nonatomic, strong) PopBar*           popBar;

@property (nonatomic, strong) PopPanel*         PopPanel;

@property (nonatomic, assign) BOOL              shouldPlaySound;

@property (nonatomic, assign) BOOL              isHideBarAction;//防止被scrollViewDidScroll干扰

/**
 *  展示PopBar,没有构造过程，展示过程前会Hide其他控件
 *
 *  @param yesOrNo    是否需要动画展示
 *  @param completion 展示动画完成后的回调
 */
- (void)showPopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  展示PopPanel,没有构造过程，展示过程前会Hide其他控件
 *
 *  @param yesOrNo    是否需要动画展示
 *  @param completion 展示动画完成后的回调
 */
- (void)showPopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  设置PopBar，没有动画，没有展示
 *
 *  @param logoIamgePath 图片路径
 *  @param title         标题
 *  @param content       内容
 */
- (void)setPopBarWithLogo:(NSString*)logoIamgePath title:(NSString*)title content:(NSString*)content;

/**
 *  设置PopPanel，没有动画，没有展示
 *
 *  @param logoIamgePath 图片路径
 *  @param title         标题
 *  @param content       内容
 */
- (void)setPopPanelWithLogo:(NSString*)logoIamgePath title:(NSString*)title content:(NSString*)content;

/**
 *  PopBar单纯的展示，与showPopBarViaAnimation区别在于，不做Hide其他控件操作
 *
 *  @param yesOrNo    是否需要动画展示
 *  @param completion 展示动画完成后的回调
 */
- (void)_showPopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  PopPanel单纯的展示，与showPopPanelViaAnimation区别在于，不做Hide其他控件操作
 *
 *  @param yesOrNo    是否需要动画展示
 *  @param completion 展示动画完成后的回调
 */
- (void)_showPopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  PopLoadingBar单纯的展示，与showPopLoadingBarWithAnimaion区别在于，不做Hide其他控件操作
 *
 *  @param yesOrNo    是否需要动画展示
 *  @param completion 展示动画完成后的回调
 */
- (void)_showPopLoadingBarWithAnimaion:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion;

/**
 *  播放Panel展开声音
 */
- (void)playLoadingSound;

@end

@implementation MagicFieldPopView

- (instancetype)initWithDependentView:(UIView*)view
{
    self = [super initWithFrame:view.frame];
    if (self) {
        // Initialization code
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        self.scrollView.delaysContentTouches = NO;
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [self.scrollView addSubview:view];
        
        [self.scrollView setContentOffset:view.frame.origin animated:NO];
        
        
        self.backgroundColor = [UIColor colorWithHexString:@"#0080FF"];
    }
    return self;
}

- (void)showPopBarWithLogo:(NSString*)logoIamgePath
                     title:(NSString*)title
               content:(NSString*)content
                  animaion:(BOOL)yesOrNo
                completion:(void (^)(BOOL))completion
{
    
    [self setPopBarWithLogo:logoIamgePath title:title content:content];
    
    [self showPopBarViaAnimation:yesOrNo completion:completion];
}

- (void)showPopPanelWithLogo:(NSString*)logoIamgePath
                       title:(NSString*)title
                 content:(NSString*)content
                    animaion:(BOOL)yesOrNo
                  completion:(void (^)(BOOL))completion
{
    [self setPopPanelWithLogo:logoIamgePath title:title content:content];

    [self showPopPanelViaAnimation:yesOrNo completion:completion];
}

- (void)showPopLoadingBarWithAnimaion:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion
{
    if (self.popBar)
    {
        [self hidePopBarViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopLoadingBarWithAnimaion:yesOrNo completion:completion];
        }];
    }
    else if (self.PopPanel)
    {
        [self hidePopPanelViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopLoadingBarWithAnimaion:yesOrNo completion:completion];
        }];
    }
    else
    {
        [self _showPopLoadingBarWithAnimaion:yesOrNo completion:completion];
    }
}

- (void)hidePopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL))completion
{
    if (self.popBar == nil)
    {
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    
    self.isHideBarAction = YES;
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [self.popBar removeFromSuperview];
            self.popBar = nil;
            
            if (completion)
            {
                completion(finished);

            }
        }];
    }
    else
    {
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.popBar removeFromSuperview];
        self.popBar = nil;
        if (completion != nil)
        {
            completion(YES);
        }
    }
    //去掉上部填充
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)hidePopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL))completion
{
    if (self.PopPanel == nil)
    {
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        } completion:^(BOOL finished) {
            [self.PopPanel removeFromSuperview];
            self.PopPanel = nil;
            if (completion != nil)
            {
                completion(finished);
            }
        }];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.PopPanel removeFromSuperview];
        self.PopPanel = nil;
        if (completion != nil)
        {
            completion(YES);
        }
    }
    //去掉上部填充
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)hidePopLoadingBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion
{
    if (self.popLoadingBar == nil)
    {
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.02 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [self.popLoadingBar removeFromSuperview];
            self.popLoadingBar = nil;
            if (completion)
            {
                completion(finished);
            }
        }];
    }
    else
    {
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.popLoadingBar removeFromSuperview];
        self.popLoadingBar = nil;
        if (completion != nil)
        {
            completion(YES);
        }
    }
    //去掉上部填充
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark- private

- (void)showPopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion
{
    if (self.popLoadingBar)
    {
        [self hidePopLoadingBarViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopBarViaAnimation:yesOrNo completion:completion];
        }];
    }
    else if (self.PopPanel)
    {
        [self hidePopPanelViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopBarViaAnimation:yesOrNo completion:completion];
        }];
    }
    else
    {
        [self _showPopBarViaAnimation:yesOrNo completion:completion];
    }
}

- (void)showPopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL finished))completion
{
    if (self.popBar)
    {
        [self hidePopBarViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopPanelViaAnimation:yesOrNo completion:completion];
        }];
    }
    else if (self.popLoadingBar)
    {
        self.shouldPlaySound = YES;//只有在loading状态转到面板才出声音
        [self hidePopLoadingBarViaAnimation:yesOrNo completion:^(BOOL finished) {
            [self _showPopPanelViaAnimation:yesOrNo completion:completion];
        }];
    }
    else
    {
        [self _showPopPanelViaAnimation:yesOrNo completion:completion];
    }
}

- (void)setPopBarWithLogo:(NSString*)logoIamgePath title:(NSString*)title content:(NSString*)content
{
    if (self.popBar == nil)
    {
        _popBar = [[PopBar alloc] initWithFrame:KPopBarRect logo:logoIamgePath title:title content:content];
        [self.scrollView addSubview:_popBar];
    }
    else
    {
        [_popBar setLogo:logoIamgePath title:title content:content];
    }
}

- (void)setPopPanelWithLogo:(NSString*)logoIamgePath title:(NSString*)title content:(NSString*)content
{
    if (self.PopPanel == nil)
    {
        _PopPanel = [[PopPanel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, KPopPanelHeight) logo:logoIamgePath title:title content:content];
        [self insertSubview:_PopPanel belowSubview:self.scrollView];
    }
    else
    {
        [_PopPanel setLogo:logoIamgePath title:title content:content];
    }
}

- (void)_showPopBarViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL))completion
{
    if (self.popBar == nil)
    {
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    
    self.isHideBarAction = NO;
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.scrollView.contentOffset = self.popBar.frame.origin;
        } completion:completion];
    }
    else
    {
        self.scrollView.contentOffset = self.popBar.frame.origin;
        if (completion)
        {
            completion(YES);
        }
    }
    //上部填充KPopPanelHeight
    [self.scrollView setContentInset:UIEdgeInsetsMake(KPopBarHeight, 0, 0, 0)];
}

- (void)_showPopPanelViaAnimation:(BOOL)yesOrNo completion:(void (^)(BOOL))completion
{
    if (self.PopPanel == nil)
    {
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    
    if (self.shouldPlaySound == YES)
    {
        [self playLoadingSound];
        self.shouldPlaySound = NO;
    }
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0 - KPopPanelHeight) animated:NO];
        } completion:completion];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0 - KPopPanelHeight) animated:NO];
        if (completion != nil)
        {
            completion(YES);
        }
    }
    //上部填充KPopPanelHeight
    [self.scrollView setContentInset:UIEdgeInsetsMake(KPopPanelHeight, 0, 0, 0)];
}

- (void)_showPopLoadingBarWithAnimaion:(BOOL)yesOrNo completion:(void (^)(BOOL))completion
{
    if (self.popLoadingBar == nil)
    {
        _popLoadingBar = [[PopLoadingBar alloc] initWithFrame:KPopBarRect];
        [self.scrollView addSubview:_popLoadingBar];
    }
    
    if (yesOrNo)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.scrollView.contentOffset = self.popLoadingBar.frame.origin;
        } completion:^(BOOL finished) {
            [self.popLoadingBar startLoading];
            if (completion != nil)
            {
                completion(finished);
            }
        }];
    }
    else
    {
        self.scrollView.contentOffset = self.popLoadingBar.frame.origin;
        if (completion)
        {
            completion(YES);
        }
    }
}

- (void)playLoadingSound
{
    SystemSoundID soundID;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"APNFD.bundle/loading.wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path]
                                     , &soundID);
    AudioServicesPlaySystemSound (soundID);
}

#pragma mark- touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (CGRectContainsPoint(self.PopPanel.frame, p))
    {
        [self.PopPanel touchesBegan:touches withEvent:event];
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark- scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (0 - yOffset > KPopPanelHeight)
    {
        if (self.PopPanel != nil)
        {
            CGRect frame = self.PopPanel.frame;
            frame.origin.y = 0;
            frame.size.height = 0 - yOffset;
            self.PopPanel.frame = frame;
            
            self.PopPanel.transform = CGAffineTransformMakeScale(0 - yOffset / KPopPanelHeight, 0 - yOffset / KPopPanelHeight);
        }
    }
    
    if (self.popBar && self.isHideBarAction == NO)
    {
        if (0 - yOffset < KPopBarHeight)
        {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0 - KPopBarHeight);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat yOffset = self.scrollView.contentOffset.y;
    if (self.popBar)
    {
        if (0 - yOffset < KPopPanelHeight / 3)
        {//不够1/3，popBar 归位
            [self _showPopBarViaAnimation:YES completion:nil];
            if (yOffset > 0)
            {
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        else
        {//超过1/3 划出
            [self setPopPanelWithLogo:self.popBar.logoPath title:self.popBar.title content:self.popBar.content];
            [self _showPopPanelViaAnimation:YES completion:nil];
            
            
            [UIView animateWithDuration:0.5 animations:^{
                self.popBar.alpha = 0;
            } completion:^(BOOL finished) {
                [self.popBar removeFromSuperview];
                self.popBar = nil;
            }];
        }
    }
    else if (self.PopPanel)
    {
        if ((0 - yOffset) > (KPopPanelHeight / 3 * 2))
        {//不够1/3,panel归位
            [self _showPopPanelViaAnimation:YES completion:nil];
        }
        else
        {
            [self showPopBarWithLogo:self.PopPanel.logoPath
                               title:self.PopPanel.title
                             content:self.PopPanel.content
                            animaion:YES
                          completion:nil];
        }
    }
}

@end
