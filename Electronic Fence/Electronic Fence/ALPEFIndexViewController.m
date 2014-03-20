//
//  ALPEFIndexViewController.m
//  Electronic Fence
//
//  Created by yukai44444 on 14-2-26.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "ALPEFIndexViewController.h"

#define ALPEFDeviceIsIphone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define ALPEFPayButtonOffset (ALPEFDeviceIsIphone5 ? 50 : 24)

#define NotifyPress  @"搜索魔力场，请按住"
#define NotifyFinding @"正在搜索魔力场"
#define NotifyNoFind @"貌似没有搜索到魔力场"
#define NotifyStartService @"点击魔力场面板开始使用服务"

static const float kDefaultLocalSeachTimeout = 5.0;

typedef enum {
    SearchBtSeaching,
    SearchBtStartAA
}SearchBtState;

@interface ALPEFIndexViewController ()
@property (nonatomic,weak)UIButton *searchButton;
@property (nonatomic,strong)UILabel *statustipLabel;
@property (nonatomic,strong)UILabel *panel;
@property (nonatomic)SearchBtState btState;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic, strong)AVAudioPlayer *panelDisplayPlayer;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ALPEFIndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"支付宝";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.btState = SearchBtSeaching;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"采集" style:UIBarButtonItemStyleDone target:self action:@selector(collect)];
    
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"lbs_wave" ofType:@"mp3"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.player.numberOfLoops = -1;
    [self.player prepareToPlay];
    
    NSString *userDisplaySoundPath=[[NSBundle mainBundle] pathForResource:@"AAPayUserDisplay" ofType:@"mp3"];
    NSURL *userDisplaySoundUrl=[[NSURL alloc] initFileURLWithPath:userDisplaySoundPath];
    self.panelDisplayPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:userDisplaySoundUrl error:nil];
    self.panelDisplayPlayer.numberOfLoops = 1;
    [self.panelDisplayPlayer prepareToPlay];
    [self buildSearchUI];
}

- (void)buildSearchUI
{
    UIImage *image = [UIImage imageNamed:@"AAPayBottomBg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImageView *bottomBgView = [[UIImageView alloc] initWithImage:image];
    float offsetY = ALPEFDeviceIsIphone5 ? 0 : 20;
    NSLog(@"%f", self.view.frame.size.height);
    NSLog(@"%f", image.size.height);
    NSLog(@"%f", offsetY);
    bottomBgView.frame = CGRectMake(0, self.view.frame.size.height - image.size.height + offsetY, 320, image.size.height);
    [self.view addSubview:bottomBgView];
    
    CGSize screenSize = self.view.bounds.size;
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImg = [UIImage imageNamed:@"AAPaySeach"];
    [self.searchButton setImage:searchImg forState:UIControlStateNormal];
    
    CGSize searchSize = CGSizeMake(searchImg.size.width, searchImg.size.height);
    self.searchButton.frame = CGRectMake((screenSize.width - searchSize.width)/2, screenSize.height-searchSize.height - (ALPEFPayButtonOffset ? 50 : 24), searchSize.width, searchSize.height);
    [self.view addSubview:self.searchButton];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.searchButton.frame.origin.y - 15 - 15, screenSize.width, 16)];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    [tipLabel setFont:[UIFont systemFontOfSize:16]];
    [tipLabel setTextColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setText:NotifyPress];
    [tipLabel setNumberOfLines:2];
    [self.view addSubview:tipLabel];
    self.statustipLabel = tipLabel;
    
    bottomBgView.alpha = 0;
    self.searchButton.alpha = 0;
    self.statustipLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        bottomBgView.alpha = 1;
        self.searchButton.alpha = 1;
        self.statustipLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self.searchButton addTarget:self action:@selector(searchPress:) forControlEvents:UIControlEventTouchDown];
        [self.searchButton addTarget:self action:@selector(searchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchButton addTarget:self action:@selector(searchOutUp:) forControlEvents:UIControlEventTouchUpOutside];
        [self.searchButton addTarget:self action:@selector(searchOutUp:) forControlEvents:UIControlEventTouchCancel];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collect {
    ALPEFCollectViewController *collectController = [[ALPEFCollectViewController alloc] init];
    [self.navigationController pushViewController:collectController animated:YES];
}

- (UIImageView *)createWave
{
    CGFloat waveScale = 2.1f;
    UIImage *waveImg = [UIImage imageNamed:@"lbs_wave.png"];
    UIImageView *waveView = [[UIImageView alloc] initWithImage:waveImg];
    CGSize waveSize = CGSizeMake(waveImg.size.width*waveScale, waveImg.size.height*waveScale);
    
    CGFloat waveX = (self.searchButton.frame.size.width - waveSize.width)/2 + self.searchButton.frame.origin.x;
    CGFloat waveY = (self.searchButton.frame.size.height - waveSize.height)/2 + self.searchButton.frame.origin.y;
    
    waveView.frame = CGRectMake(waveX, waveY, waveSize.width, waveSize.height);
    
    return waveView;
}

- (void)playAnimtaionWave
{
    UIImageView *waveView = [self createWave];
    [self.view insertSubview:waveView belowSubview:self.searchButton];
    [self waveAnimate:waveView];
}
- (void)startPlayMedioAndWave
{
    [self.player play];
    [self playAnimtaionWave];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.8
                                                  target: self
                                                selector: @selector(playAnimtaionWave)
                                                userInfo: nil
                                                 repeats: YES];
    
}

- (void)waveAnimate:(UIImageView *)waveView
{
    CGRect waveRect = waveView.frame;
    CGFloat waveScale = 3.5;
    CGFloat centerX = waveRect.origin.x + waveRect.size.width/2;
    CGFloat centerY = waveRect.origin.y + waveRect.size.height/2;
    
    waveRect.size.height = waveRect.size.height *waveScale;
    waveRect.size.width = waveRect.size.width *waveScale;
    waveRect.origin.x = centerX - waveRect.size.width/2;
    waveRect.origin.y = centerY - waveRect.size.height/2;
    
    [UIView animateWithDuration:2.3f animations:^{
        waveView.frame = waveRect;
        waveView.alpha = 0;
    } completion:^(BOOL finished) {
        [waveView removeFromSuperview];
    }];
}

- (void)notifyUserResultInDeafultTime
{
    if (self.panel > 0) {
    } else {
        [self.statustipLabel setText:NotifyNoFind];
    }
}
- (void)stopPlayMedioAndWave
{
    [self.player stop];
    [self.player prepareToPlay];
    [self.timer invalidate];
}
- (void)searchPress:(id)sender
{
    [self startPlayMedioAndWave];
    [self.statustipLabel setText:NotifyFinding];
    [self performSelector:@selector(notifyUserResultInDeafultTime) withObject:nil afterDelay:kDefaultLocalSeachTimeout];
}

- (void)searchOutUp:(id)sender
{
    if (self.btState == SearchBtSeaching) {
        [self searchUp:self];
    }
}

- (void)searchUp:(id)sender
{
    [self stopPlayMedioAndWave];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyUserResultInDeafultTime) object:nil];
    if (self.panel) {
        [self.statustipLabel setText:NotifyStartService];
    }
    else {
        [self.statustipLabel setText:NotifyPress];
    }
}
@end
