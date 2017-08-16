//
//  ZJToastView.m
//  hospital
//
//  Created by 张子建 on 15/6/8.
//  Copyright (c) 2015年 LiuBin. All rights reserved.
//

#import "ZJToastView.h"

#define FULLSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define FULLSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define TOSTA_SPACE 80  // tosta 距离两边的距离
#define TOAST_WIDTH (FULLSCREEN_WIDTH-2*TOSTA_SPACE)

// 字体默认配置
#define FONT_NORMAL         @"Helvetica"
#define FONT_BOLD_NORMAL    @"Helvetica-Bold"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define HEXRGBCOLOR80(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:0.8]



UIColor* backgroundColor;

static ZJToastView *sharedZJToast;

@implementation ZJToastView
{
    UIView *customView;
    NSString *title;
    UIView *backView;
    
}

-(id)init
{
    self  = [super init];
    if (self) {
     
        self.showStyle = ZJToastViewShowStyleNormal;
        self.toastTextColor = [UIColor whiteColor];
        self.toastBackGround = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        if(backgroundColor)
        {
            const CGFloat *compatents = CGColorGetComponents(backgroundColor.CGColor);
            self.toastBackGround = [UIColor colorWithRed:compatents[0] green:compatents[1] blue:compatents[2] alpha:0.8];
        }
        
        [self setRootViewController:[[ZJControllerForToast alloc]init]];
        
        
    }
    return self;
}

+(void)initializeBackgroundColor:(UIColor*)color
{
    backgroundColor = color;
}

+(id)sharedZJAlertView
{
    if (!sharedZJToast) {
        sharedZJToast = [[ZJToastView alloc] init];
        sharedZJToast.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        sharedZJToast.alpha = 1;
        [sharedZJToast setBackgroundColor:[UIColor clearColor]];
        sharedZJToast.windowLevel = 100;
    }
    return sharedZJToast;
}

-(void)addTitle:(NSString *)text
{
    title = text;
}


#pragma Show Method

+(void)showLoading:(NSString *)text
{
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    [ZJToastView dissMissToast];
    [sharedZJToast setHidden:NO];
    
    [[ZJToastView sharedZJAlertView]addTitle:text];
    [[ZJToastView sharedZJAlertView]initCustomViewForLoading];
    [[ZJToastView sharedZJAlertView]makeKeyAndVisible];
}

-(void)initCustomViewForLoading
{
    if (self.showStyle == ZJToastViewShowStyleDark) {
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FULLSCREEN_WIDTH, FULLSCREEN_HEIGHT)];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:backView];
    }
    
    CGFloat textJiange = 12;
    
    CGFloat currentHeight = 15;
    
    while (self.rootViewController.view.subviews.count)
    {
        [self.rootViewController.view.subviews.firstObject removeFromSuperview];
    }
    
    if (title.length > 0) {
        
        customView = [[UIView alloc]initWithFrame:CGRectMake((FULLSCREEN_WIDTH - TOAST_WIDTH) * 0.5, 0, TOAST_WIDTH, TOAST_WIDTH)];
    }
    else
    {
        customView = [[UIView alloc]initWithFrame:CGRectMake((FULLSCREEN_WIDTH - 80) * 0.5, 0, 80, TOAST_WIDTH)];
    }
    
    UIImageView *aLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(customView.frame.size.width * 0.5 - 14, currentHeight, 28, 28)];
    [aLoadingImageView setImage:[UIImage imageNamed:@"Tostloading.png"]];
    [customView addSubview:aLoadingImageView];
    
    {
        CABasicAnimation *loadingAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        loadingAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        loadingAnimation.duration = 1.0;
        loadingAnimation.repeatCount = MAXFLOAT;
        [aLoadingImageView.layer addAnimation:loadingAnimation forKey:nil];
    }
    
    
    currentHeight += 28;
    
    if (title) {
        
        currentHeight += 12;
        
        UILabel *aTextLabe = [[UILabel alloc]initWithFrame:CGRectMake(textJiange, currentHeight, TOAST_WIDTH - textJiange * 2, 15)];
        [aTextLabe setTextColor:self.toastTextColor];
        [aTextLabe setFont:[UIFont systemFontOfSize:15]];
        aTextLabe.textAlignment = NSTextAlignmentCenter;
        [aTextLabe setNumberOfLines:0];
        [aTextLabe setText:title];
        
        [aTextLabe sizeToFit];
        
        CGRect aRect = aTextLabe.frame;
        aRect.size.width = TOAST_WIDTH - textJiange * 2;
        [aTextLabe setFrame:aRect];
        [customView addSubview:aTextLabe];
        
        currentHeight = CGRectGetMaxY(aTextLabe.frame);
        
    }
    
    
    [customView setFrame:CGRectMake((FULLSCREEN_WIDTH - customView.frame.size.width) * 0.5, (FULLSCREEN_HEIGHT - currentHeight - 15) * 0.5 - 64, customView.frame.size.width, currentHeight + 15)];
    
    customView.layer.cornerRadius = 8;
    customView.layer.borderWidth = 0.5;
    customView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [customView setBackgroundColor:self.toastBackGround];
    
    [self addSubview:customView];

    [self setFrame:CGRectMake(0, 64, FULLSCREEN_WIDTH, FULLSCREEN_HEIGHT - 64)];
}

+(void)showStaut:(NSString *)text
{
    [ZJToastView showStaut:text afterDelay:1.0];
}

+(void)showStaut:(NSString *)text afterDelay:(NSTimeInterval)time
{
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    [ZJToastView dissMissToast];
    [sharedZJToast setHidden:NO];
    
    [[ZJToastView sharedZJAlertView]addTitle:text];
    [[ZJToastView sharedZJAlertView]initCustomView];
    [[ZJToastView sharedZJAlertView]makeKeyAndVisible];
    [[ZJToastView sharedZJAlertView]performSelector:@selector(toDisMiss) withObject:nil afterDelay:time];
}

-(void)initCustomView
{
    if (self.showStyle == ZJToastViewShowStyleDark) {
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FULLSCREEN_WIDTH, FULLSCREEN_HEIGHT)];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:backView];
    }
    
    CGFloat textJiange = 12;
    
    while (self.rootViewController.view.subviews.count)
    {
        [self.rootViewController.view.subviews.firstObject removeFromSuperview];
    }
    
    customView = [[UIView alloc]initWithFrame:CGRectMake((FULLSCREEN_WIDTH - TOAST_WIDTH) * 0.5, 0, TOAST_WIDTH, TOAST_WIDTH)];
    
    UILabel *aTextLabe = [[UILabel alloc]initWithFrame:CGRectMake(textJiange, 15, TOAST_WIDTH - textJiange * 2, 15)];
    [aTextLabe setTextColor:self.toastTextColor];
    [aTextLabe setFont:[UIFont systemFontOfSize:13]];
    aTextLabe.textAlignment = NSTextAlignmentCenter;
    [aTextLabe setNumberOfLines:0];
    [aTextLabe setText:title];
    
    [aTextLabe sizeToFit];
    
    CGRect aRect = aTextLabe.frame;
    aRect.size.width = TOAST_WIDTH - textJiange * 2;
    [aTextLabe setFrame:aRect];
    [customView addSubview:aTextLabe];
    
    
    aRect = customView.frame;
    aRect.size.height = CGRectGetMaxY(aTextLabe.frame) + 15;
    [customView setFrame:CGRectMake((FULLSCREEN_WIDTH - TOAST_WIDTH) * 0.5, FULLSCREEN_HEIGHT * 0.8 - (aTextLabe.frame.size.height + 30) * 0.5, TOAST_WIDTH, aTextLabe.frame.size.height + 30)];
    
    customView.layer.cornerRadius = 8;
    
    customView.layer.borderColor = [UIColor whiteColor].CGColor;
    customView.layer.borderWidth = 0.5;
    [customView setBackgroundColor:self.toastBackGround];

    [self addSubview:customView];
}

-(void)toDisMiss
{
    [customView removeFromSuperview];
    customView = nil;
    
    [backView removeFromSuperview];
    backView = nil;
    
    [[ZJToastView sharedZJAlertView]resignKeyWindow];
    [sharedZJToast setHidden:YES];
    
    [[[UIApplication sharedApplication]keyWindow]setNeedsDisplay];
}

+(void)dissMissToast
{
   [sharedZJToast toDisMiss];
}


@end

@implementation ZJControllerForToast

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[UIApplication sharedApplication]statusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return false;
}

@end
