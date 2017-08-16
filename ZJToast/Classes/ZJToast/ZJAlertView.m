//
//  ZJAlertView.m
//  WKAlertViewDemo
//
//  Created by 张子建 on 15/5/28.
//  Copyright (c) 2015年 王琨. All rights reserved.
//

#import "ZJAlertView.h"
#import "CommonDef.h"

#define FULLSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define FULLSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define ALERT_WIDTTH  FULLSCREEN_WIDTH - 58.0

// 字体默认配置
#define FONT_NORMAL         @"Helvetica"
#define FONT_BOLD_NORMAL    @"Helvetica-Bold"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define ALERT_TEXT_COLOR HEXRGBCOLOR(0x686868)
#define ALERT_STYLE_COLOR HEXRGBCOLOR(0x31AEB2)

static ZJAlertView *sharedZJAlert;

UIImage* BtnNormalImage;
UIImage* BtnHighlightImage;

UIColor *normalColor;
UIColor *highlightColor;

@interface ZJAlertView()<UITextFieldDelegate>
@end

@implementation ZJAlertView
{
    UIView *customView;
    
    NSArray *MessageArray;
    
    NSString *okBtnStr;
    
    NSString *cancelBtnStr;
    
    NSString *title;
    
    NSString *subTips;         //标题下面的提示语
    
    UIView *backView;
    
    CGFloat ALERT_WIDTTH;
    
    UIImage *imageQR;
    
    CGFloat imageQRX;
    
    UIImageView *ribbonImage;
    UIButton *signBtn;
    NSString *today;
    NSAttributedString *current_week_num;
    NSAttributedString *current_month_num;
    
    NSAttributedString *secondTitle;
    NSAttributedString *thirdTitle;
    
    
}

+ (void)initializeBtnNomarlImage:(UIImage *)image
{
    BtnNormalImage = image;
    
    normalColor = [ZJAlertView getPixelColorAtLocation:image];
}

+ (void)initializeBtnHighlightImage:(UIImage *)image
{
    BtnHighlightImage = image;
    
    highlightColor = [ZJAlertView getPixelColorAtLocation:image];
}

+ (void)initializeBtnNomarlColor:(UIColor *)color
{
    normalColor = color;
}

+ (void)initializeBtnHighlightColor:(UIColor *)color
{
    highlightColor = color;
}


+ (void)showZJAlertTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView]isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andMessages:messages andOKButtonString:okstr andCancelString:nil];
        [[ZJAlertView sharedZJAlertView]initCustomViewSecond];
        [[ZJAlertView sharedZJAlertView]setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView]makeKeyAndVisible];
        
    }
}

+ (void)showZJAlertTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView]isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andMessages:messages andOKButtonString:okstr andCancelString:cancelstr];
        
        [[ZJAlertView sharedZJAlertView]initCustomViewSecond];
        [[ZJAlertView sharedZJAlertView]setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
    
}

+ (void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andSubTitle:subTitle andMessages:messages andOKButtonString:okstr andCancelString:nil];
        [[ZJAlertView sharedZJAlertView] initCustomViewSecondByKeyValue];
        [[ZJAlertView sharedZJAlertView]setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

+ (void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andSubTitle:subTitle andMessages:messages andOKButtonString:okstr andCancelString:cancelstr];
        [[ZJAlertView sharedZJAlertView] initCustomViewSecondByKeyValue];
        [[ZJAlertView sharedZJAlertView]setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

#pragma - mark 增加image
+ (void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle imageInfo:(UIImage *)image keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andSubTitle:subTitle andImage:image andMessages:messages andOKButtonString:okstr andCancelString:cancelstr];
        [[ZJAlertView sharedZJAlertView] initCustomViewForImage];
        [[ZJAlertView sharedZJAlertView]setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

#pragma - mark 增加签到
+ (void)showSignViewtadayTitle:(NSString *)tadayText weekTitle:(NSString *)weekText monthTitle:(NSString *)monthText andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView] addtadayTitle:tadayText weekTitle:weekText monthTitle:monthText andOKButtonString:okstr andCancelString:nil];
        [[ZJAlertView sharedZJAlertView] initCustomViewForSign];
        [[ZJAlertView sharedZJAlertView] setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

#pragma - mark 就医足迹
+ (void)showRecordViewfirstTitle:(NSString *)firstText secondTitle:(NSString *)secondText thirdTitle:(NSString *)thirdText andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView] addFirstTitle:firstText secondTitle:secondText thirdTitle:thirdText andOKButtonString:okstr andCancelString:cancelstr];
        [[ZJAlertView sharedZJAlertView] initCustomViewForRecord];
        [[ZJAlertView sharedZJAlertView] setClickBlock:aCallBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

#pragma - mark 带textField
+ (void)showTextFieldViewTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callTextFieldBacks)acallTextFieldBack
{
    if (![[ZJAlertView sharedZJAlertView] isKeyWindow]) {
        
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        
        [[ZJAlertView sharedZJAlertView]addTitle:titleText andMessages:messages andOKButtonString:okstr andCancelString:cancelstr];
        [[ZJAlertView sharedZJAlertView] initCustomViewForTextField];
        [[ZJAlertView sharedZJAlertView] setCallTextFieldBack:acallTextFieldBack];
        [[ZJAlertView sharedZJAlertView] makeKeyAndVisible];
    }
}

- (id)init
{
    self  = [super init];
    if (self) {
        
        ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
        
        if (!normalColor)
        {
            normalColor = HEXRGBCOLOR(0x31aeb2);
        }
        
        if (!highlightColor)
        {
            highlightColor = HEXRGBCOLOR(0x25898A);
        }
        
        
        [self setRootViewController:[[ZJControllerForAlert alloc]init]];
        
    }
    return self;
}

+ (id)sharedZJAlertView
{    
    if (!sharedZJAlert) {
        
        sharedZJAlert = [[ZJAlertView alloc] init];
    
        sharedZJAlert.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        sharedZJAlert.alpha = 1;
        [sharedZJAlert setBackgroundColor:[UIColor clearColor]];
        sharedZJAlert.windowLevel = 100;
    }
    return sharedZJAlert;
}

- (void)addTitle:(NSString *)titleText andMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr
{
    title = titleText;
    MessageArray = messages;
    okBtnStr = okstr;
    cancelBtnStr = cancelstr;
}

- (void)addTitle:(NSString *)titleText andSubTitle:(NSString *)subTitle  andMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr
{
    title = titleText;
    subTips = subTitle;
    MessageArray = messages;
    okBtnStr = okstr;
    cancelBtnStr = cancelstr;
}

#pragma - mark 增加图片 
//message的传值方式：@[@{@"subtitle":@"姓名",@"detail":@" 哈哈哈"},@{@"subtitle":@"手机号",@"detail":@" 138374648373"}]
- (void)addTitle:(NSString *)titleText andSubTitle:(NSString *)subTitle andImage:(UIImage *)image andMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr
{
    title = titleText;
    subTips = subTitle;
    imageQR = image;
    MessageArray = messages;
    okBtnStr = okstr;
    cancelBtnStr = cancelstr;
}

#pragma - mark 签到
- (void)addtadayTitle:(NSString *)tadayText weekTitle:(NSString *)weekText monthTitle:(NSString *)monthText andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr
{
    title = tadayText;
    
    NSString *weekString = [NSString stringWithFormat:@"本周累计签到：%@" ,weekText];
    NSMutableAttributedString *weekAttributedStr = [[NSMutableAttributedString alloc]initWithString:weekString];
    [weekAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXRGBCOLOR(0xED761C) range:NSMakeRange(7, weekText.length)];
    current_week_num = weekAttributedStr;
    
    NSString *monthString = [NSString stringWithFormat:@"本月累计签到：%@" ,monthText];
    NSMutableAttributedString *monthAttributedStr = [[NSMutableAttributedString alloc]initWithString:monthString];
    [monthAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXRGBCOLOR(0xED761C) range:NSMakeRange(7, monthText.length)];
    current_month_num = monthAttributedStr;
    
    okBtnStr = okstr;
}

#pragma - mark 就医足迹
- (void)addFirstTitle:(NSString *)firstText secondTitle:(NSString *)secondText thirdTitle:(NSString *)thirdText andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr
{
    NSString *firstString = [NSString stringWithFormat:@"挂号就医%@次" ,firstText];
    NSMutableAttributedString *firstAttributedStr = [[NSMutableAttributedString alloc]initWithString:firstString];
    [firstAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXRGBCOLOR(0xED761C) range:NSMakeRange(4, firstText.length)];
    title = [firstAttributedStr copy];
    
    NSString *secondString = [NSString stringWithFormat:@"检查报告%@份" ,secondText];
    NSMutableAttributedString *secondAttributedStr = [[NSMutableAttributedString alloc]initWithString:secondString];
    [secondAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXRGBCOLOR(0xED761C) range:NSMakeRange(4, secondText.length)];
    secondTitle = [secondAttributedStr copy];
    
    NSString *thirdString = [NSString stringWithFormat:@"检验报告%@份" ,thirdText];
    NSMutableAttributedString *thirdAttributedStr = [[NSMutableAttributedString alloc]initWithString:thirdString];
    [thirdAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXRGBCOLOR(0xED761C) range:NSMakeRange(4, thirdText.length)];
    thirdTitle = [thirdAttributedStr copy];
    
    okBtnStr = okstr;
}

#pragma - mark  增加图片
- (void)initCustomViewForImage
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 250, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    //title
    if (title.length > 0) {
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(21, 15, ALERT_WIDTTH - 21 * 2, 20)];
        [aTitle setFont:[UIFont fontWithName:FONT_BOLD_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x252525)];
        [aTitle setText:title];
        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
    }
    
    //subtitle
    if (subTips.length > 0) {
        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, currentHeight + 7, ALERT_WIDTTH, 20)];
        [subTitle setFont:FontSize(16)];
        [subTitle setTextColor:HEXRGBCOLOR(0xaeaeae)];
        [subTitle setText:subTips];
//        [subTitle setNumberOfLines:0];
//        [subTitle sizeToFit];
        [subTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:subTitle];
        currentHeight = CGRectGetMaxY(subTitle.frame);
    }
    currentHeight += 10;
    
    //iamge
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((customView.frame.size.width - 140)/2, currentHeight, 140, 140)];
    imageView.image = imageQR;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [customView addSubview:imageView];
    currentHeight = CGRectGetMaxY(imageView.frame);
    imageQRX = imageView.frame.origin.x;
    currentHeight += 10;

    //message
    UIView *messageView = [self toLoadAllMessageForDict:MessageArray];
    [messageView setFrame:RectChangeY(messageView.frame, currentHeight)];
    [customView addSubview:messageView];
    
    currentHeight = CGRectGetMaxY(messageView.frame);
    currentHeight += 10;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 0.5)];
    [lineView setBackgroundColor:HEXRGBCOLOR(0xcecece)];
    [customView addSubview:lineView];
    currentHeight += 0.5;
    
    if (cancelBtnStr.length > 0)
    {
        UIView *buttonLine = [[UIView alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5, 45)];
        [buttonLine setBackgroundColor:HEXRGBCOLOR(0xcecece)];
        [customView addSubview:buttonLine];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        cancelBtn.tag = 2;
        [cancelBtn setTitle:cancelBtnStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    else
    {
        if (okBtnStr.length == 0) {
            
            okBtnStr = @"确定";
        }
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    
    currentHeight += 45;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.5, ALERT_WIDTTH, currentHeight)];
    
    [self.rootViewController.view addSubview:customView];
}

- (UIView *)toLoadAllMessageForDict:(NSArray *)message
{
    if (![message.firstObject isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    CGFloat currectHeight = 0;

    for (int i = 0;i< message.count; i++)
    {
        NSDictionary *dict = message[i];
        NSString *subTitle;
        NSString *detailStr;
        
        @try {
            subTitle = [dict objectForKey:@"subtitle"];
            detailStr = [dict objectForKey:@"detail"];
        }
        @catch (NSException *exception) {
            subTitle = @"";
            detailStr = @"";
        }
        @finally {
            
        }
        UILabel *keyLable = [[UILabel alloc] initWithFrame:CGRectMake(imageQRX, currectHeight, ALERT_WIDTTH - 38, 15)];
        [keyLable setFont:[UIFont systemFontOfSize:13]];
        [keyLable setTextColor:HEXRGBCOLOR(0x252525)];
        [keyLable setText:subTitle];
        [messageView addSubview:keyLable];
        [keyLable sizeToFit];
        
        UILabel *valueLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(keyLable.frame)+5, currectHeight, ALERT_WIDTTH - CGRectGetMaxX(keyLable.frame)-5, 15)];
        [valueLable setFont:[UIFont systemFontOfSize:13]];
        [valueLable setTextColor:HEXRGBCOLOR(0x252525)];
        [valueLable setText:detailStr];
        [messageView addSubview:valueLable];
        currectHeight += valueLable.frame.size.height;
        currectHeight += 5;
        [valueLable setNumberOfLines:0];
    }
    
    CGRect fr = messageView.frame;
    fr.size.height = currectHeight;
    [messageView setFrame:fr];

    return messageView;

}

- (void)initCustomViewSecond
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 180, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    if (title.length > 0) {
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(21, 22, ALERT_WIDTTH - 21 * 2, 20)];
        [aTitle setFont:[UIFont fontWithName:FONT_BOLD_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x252525)];
        [aTitle setText:title];
        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
        
    }
    
    currentHeight += 22;
    
    UIView *messageView = [self toLoadAllMessage:MessageArray];
    [messageView setFrame:RectChangeY(messageView.frame, currentHeight)];
    [customView addSubview:messageView];
    
    currentHeight = CGRectGetMaxY(messageView.frame);
    currentHeight += 22;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 0.5)];
    [lineView setBackgroundColor:HEXRGBCOLOR(0xcecece)];
    [customView addSubview:lineView];
    currentHeight += 0.5;
    
    if (cancelBtnStr.length > 0)
    {
        UIView *buttonLine = [[UIView alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5, 45)];
        [buttonLine setBackgroundColor:HEXRGBCOLOR(0xcecece)];
        [customView addSubview:buttonLine];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        cancelBtn.tag = 2;
        [cancelBtn setTitle:cancelBtnStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    else
    {
        if (okBtnStr.length == 0) {
            
            okBtnStr = @"确定";
        }
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    
    currentHeight += 45;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.5, ALERT_WIDTTH, currentHeight)];
    
    [self.rootViewController.view addSubview:customView];
}

#pragma - mark textfield
- (void)initCustomViewForTextField
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 180, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    if (title.length > 0) {
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(21, 22, ALERT_WIDTTH - 21 * 2, 20)];
        [aTitle setFont:[UIFont fontWithName:FONT_BOLD_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x252525)];
        [aTitle setText:title];
        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
        
    }
    
    currentHeight += 22;
    
    UIView *messageView = [self toLoadAllMessage:MessageArray];
    [messageView setFrame:RectChangeY(messageView.frame, currentHeight)];
    [customView addSubview:messageView];
    
    currentHeight = CGRectGetMaxY(messageView.frame);
    currentHeight += 22;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(40, currentHeight, ALERT_WIDTTH - 80, 40)];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.layer.borderColor = HEXRGBCOLOR(0xcecece).CGColor;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.cornerRadius = 5;
    self.textField.clipsToBounds = YES;
    self.textField.textColor = [UIColor blackColor];
    self.textField.tintColor = [UIColor blackColor];
    self.textField.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.textField.delegate = self;
    [customView addSubview:self.textField];
    
    currentHeight += 60;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 0.5)];
    [lineView setBackgroundColor:HEXRGBCOLOR(0xcecece)];
    [customView addSubview:lineView];
    currentHeight += 0.5;
    
    if (cancelBtnStr.length > 0)
    {
        UIView *buttonLine = [[UIView alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5, 45)];
        [buttonLine setBackgroundColor:HEXRGBCOLOR(0xcecece)];
        [customView addSubview:buttonLine];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        cancelBtn.tag = 2;
        [cancelBtn setTitle:cancelBtnStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    else
    {
        if (okBtnStr.length == 0) {
            
            okBtnStr = @"确定";
        }
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    
    currentHeight += 45;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.35, ALERT_WIDTTH, currentHeight)];
    
    [self.rootViewController.view addSubview:customView];
}

- (void)initCustomViewForSign
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 150, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    signBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, customView.frame.size.width - 30, 32)];
    signBtn.userInteractionEnabled = NO;
    [signBtn setBackgroundImage:[UIImage imageNamed:@"signbgv"] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:FONT_NORMAL size:20];
    [signBtn setTitle:@"每日签到" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customView addSubview:signBtn];
    
    if (title.length > 0) {
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(signBtn.frame)+18, ALERT_WIDTTH - 15 * 2, 20)];
        [aTitle setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x777777)];
        [aTitle setText:title];
        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
    }
    
    currentHeight += 30;
    
    UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, currentHeight, ALERT_WIDTTH - 15 * 2, 20)];
    [weekLabel setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
    [weekLabel setTextColor:HEXRGBCOLOR(0x252525)];
    [weekLabel setAttributedText:current_week_num];
    [weekLabel setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:weekLabel];
    currentHeight = CGRectGetMaxY(weekLabel.frame);

    currentHeight += 15;
    
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, currentHeight, ALERT_WIDTTH - 15 * 2, 20)];
    [monthLabel setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
    [monthLabel setTextColor:HEXRGBCOLOR(0x252525)];
    [monthLabel setAttributedText:current_month_num];
    [monthLabel setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:monthLabel];
    currentHeight = CGRectGetMaxY(monthLabel.frame);
    
    currentHeight += 30;

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 60)];
    bottomView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    bottomView.layer.cornerRadius = 10;
    [customView addSubview:bottomView];
    
    if (okBtnStr.length == 0) {
        
        okBtnStr = @"确定";
    }
    
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 10, ALERT_WIDTTH - 50, 40)];
    okBtn.layer.cornerRadius = 5;
    okBtn.layer.masksToBounds = YES;
    okBtn.tag = 1;
    [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[self imageWithColor:normalColor] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[self imageWithColor:highlightColor] forState:UIControlStateHighlighted];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:okBtn];
    
    currentHeight += 60;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.45, ALERT_WIDTTH, currentHeight)];
    [self.rootViewController.view addSubview:customView];
    
    ribbonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -46, ALERT_WIDTTH, 56)];
    ribbonImage.image = [UIImage imageNamed:@"ribbon"];
    [customView addSubview:ribbonImage];
}

- (void)initCustomViewForRecord
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 150, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    signBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, customView.frame.size.width - 30, 32)];
    signBtn.userInteractionEnabled = NO;
    [signBtn setBackgroundImage:[UIImage imageNamed:@"signbgv"] forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont fontWithName:FONT_NORMAL size:20];
    [signBtn setTitle:@"我的就医足迹" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customView addSubview:signBtn];
    
//    if (title.length > 0) {
        UIImageView *appIcon = [[UIImageView alloc]initWithFrame:CGRectMake(ALERT_WIDTTH/2.0 - 90, CGRectGetMaxY(signBtn.frame)+25, 30, 30)];
        appIcon.image = [UIImage imageNamed:@"appointmenticon"];
        [customView addSubview:appIcon];
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(appIcon.frame)+14, CGRectGetMaxY(signBtn.frame)+25, 136, 30)];
        [aTitle setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x252525)];
        [aTitle setText:title];
//        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
//    }
    
    currentHeight += 25;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, currentHeight, ALERT_WIDTTH -20, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0xcecece);
    [customView addSubview:lineView];
    
    UIImageView *reportIcon = [[UIImageView alloc]initWithFrame:CGRectMake(ALERT_WIDTTH/2.0 - 90, CGRectGetMaxY(lineView.frame)+32, 30, 30)];
    reportIcon.image = [UIImage imageNamed:@"reporticon"];
    [customView addSubview:reportIcon];
    
    currentHeight += 25;
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(appIcon.frame)+14, currentHeight, 136, 20)];
    [secondLabel setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
    [secondLabel setTextColor:HEXRGBCOLOR(0x252525)];
    [secondLabel setAttributedText:secondTitle];
//    [secondLabel setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:secondLabel];
    currentHeight = CGRectGetMaxY(secondLabel.frame);
    
    currentHeight += 7;
    
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(appIcon.frame)+14, currentHeight, 136, 20)];
    [thirdLabel setFont:[UIFont fontWithName:FONT_NORMAL size:18]];
    [thirdLabel setTextColor:HEXRGBCOLOR(0x252525)];
    [thirdLabel setAttributedText:thirdTitle];
//    [thirdLabel setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:thirdLabel];
    currentHeight = CGRectGetMaxY(thirdLabel.frame);
    
    currentHeight += 25;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 60)];
    bottomView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    bottomView.layer.cornerRadius = 10;
    [customView addSubview:bottomView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, (ALERT_WIDTTH - 40 -20)/2.0, 35)];
    cancelBtn.tag = 2;
    [cancelBtn setTitle:cancelBtnStr forState:UIControlStateNormal];
    [cancelBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [cancelBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:cancelBtn];
    
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame)+20, 10, (ALERT_WIDTTH - 40 -20)/2.0, 35)];
    okBtn.tag = 1;
    [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
    [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:okBtn];
    
    currentHeight += 60;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.45, ALERT_WIDTTH, currentHeight)];
    [self.rootViewController.view addSubview:customView];
}

- (UIView *)toLoadMessageForVersionTwo:(NSArray *)message
{
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    CGFloat currectHeight = 0;
    
    for (NSDictionary *dict in message)
    {
        NSString *subTitle;
        NSString *detailStr;
        
        @try {
            subTitle = [dict objectForKey:@"subtitle"];
            detailStr = [dict objectForKey:@"detail"];
        }
        @catch (NSException *exception) {
            subTitle = @"";
            detailStr = @"";
        }
        @finally {
            
        }
        
        UILabel *subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(19, currectHeight, ALERT_WIDTTH - 38, 18)];
        [subTitleLab setFont:[UIFont systemFontOfSize:17]];
        [subTitleLab setTextColor:HEXRGBCOLOR(0x252525)];
        [subTitleLab setText:subTitle];
        [messageView addSubview:subTitleLab];
        
        currectHeight += subTitleLab.frame.size.height;
        currectHeight += 12;
        
        CGRect fr = subTitleLab.frame;
        fr.origin.y = currectHeight;
        UILabel *detail = [[UILabel alloc]initWithFrame:fr];
        [detail setNumberOfLines:0];
        
        NSMutableParagraphStyle *aParagraph = [[NSMutableParagraphStyle alloc]init];
        [aParagraph setLineSpacing:7];
        NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:detailStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:HEXRGBCOLOR(0x686868),NSParagraphStyleAttributeName:aParagraph}];
        
        [detail setAttributedText:attribute];
        [detail sizeToFit];
        
        if (detail.frame.size.height < 13)
        {
            fr.size.height = 13;
            [detail setFrame:fr];
        }
        
        [messageView addSubview:detail];
        
        currectHeight += detail.frame.size.height;
        
        currectHeight += 22;
    }
    
    currectHeight -= 22;
    
    CGRect fr = messageView.frame;
    fr.size.height = currectHeight;
    [messageView setFrame:fr];
    
    return messageView;
}

- (UIView *)toLoadAllMessage:(NSArray *)messages
{
    if ([messages.firstObject isKindOfClass:[NSDictionary class]])
    {
        return [self toLoadMessageForVersionTwo:messages];
    }
    
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    CGFloat currectHeight = 0;
    
    CGFloat messageBianju = 21;
    
    for (NSInteger i = 0;i < MessageArray.count; i++)
    {
        NSString *str = [MessageArray objectAtIndex:i];
        
        UILabel *markLab = [[UILabel alloc]initWithFrame:CGRectMake(messageBianju, currectHeight, 30, 15)];
        
        if (MessageArray.count > 1) {
            
            [markLab setTextColor:ALERT_TEXT_COLOR];
            [markLab setFont:FontSize(16)];
            [markLab setText:[NSString stringWithFormat:@"%ld、",(long)(i + 1)]];
            [markLab sizeToFit];
        }
        else
        {
            [markLab setFrame:CGRectMake(messageBianju, 0, 0, 0)];
        }
        
        UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markLab.frame), currectHeight, ALERT_WIDTTH - messageBianju * 2 - markLab.frame.size.width, 15)];
        
        [textLab setFont:markLab.font];
        [textLab setTextColor:ALERT_TEXT_COLOR];
        [textLab setNumberOfLines:0];
        [textLab setText:str];
        if (MessageArray.count == 1) {
            
            [textLab setTextAlignment:NSTextAlignmentCenter];
            [textLab setFont:[UIFont systemFontOfSize:17]];
        }
        
        [textLab setFrame:CGRectMake(CGRectGetMaxX(markLab.frame), currectHeight, ALERT_WIDTTH - messageBianju * 2 - markLab.frame.size.width, 15)];

        [textLab sizeToFit];
        
        CGRect aTextLabRect = textLab.frame;
        aTextLabRect.size.width = ALERT_WIDTTH - messageBianju * 2 - markLab.frame.size.width;
        textLab.frame = aTextLabRect;
        
        [messageView addSubview:markLab];
        [messageView addSubview:textLab];
        
        currectHeight = CGRectGetMaxY(textLab.frame) + 12 - 2;
    }
    
    currectHeight = currectHeight - 10;
    
    CGRect aRect = messageView.frame;
    aRect.size.height = currectHeight;
    messageView.frame = aRect;
    
    return messageView;
}

#pragma mark SecondView:key、value
- (void)initCustomViewSecondByKeyValue
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    ALERT_WIDTTH = FULLSCREEN_WIDTH - 50;
    
    CGFloat currentHeight = 0;
    customView = [[UIView alloc]initWithFrame:CGRectMake(25, 180, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    if (title.length > 0) {
        
        UILabel *aTitle = [[UILabel alloc]initWithFrame:CGRectMake(21, 22, ALERT_WIDTTH - 21 * 2, 20)];
        [aTitle setFont:[UIFont fontWithName:FONT_BOLD_NORMAL size:18]];
        [aTitle setTextColor:HEXRGBCOLOR(0x252525)];
        [aTitle setText:title];
        [aTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:aTitle];
        currentHeight = CGRectGetMaxY(aTitle.frame);
        
    }
    
    if (subTips.length > 0) {
        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, currentHeight + 7, ALERT_WIDTTH, 20)];
        [subTitle setFont:FontSize(16)];
        [subTitle setTextColor:HEXRGBCOLOR(0xaeaeae)];
        [subTitle setText:subTips];
        [subTitle setTextAlignment:NSTextAlignmentCenter];
        [customView addSubview:subTitle];
        currentHeight = CGRectGetMaxY(subTitle.frame);
    }
    
    currentHeight += 22;
    
    UIView *messageView = [self toLoadAllMessageByKeyValue:MessageArray];
    [messageView setFrame:RectChangeY(messageView.frame, currentHeight)];
    [customView addSubview:messageView];
    
    currentHeight = CGRectGetMaxY(messageView.frame);
    currentHeight += 22;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 0.5)];
    [lineView setBackgroundColor:HEXRGBCOLOR(0xcecece)];
    [customView addSubview:lineView];
    currentHeight += 0.5;
    
    if (cancelBtnStr.length > 0)
    {
        UIView *buttonLine = [[UIView alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5, 45)];
        [buttonLine setBackgroundColor:HEXRGBCOLOR(0xcecece)];
        [customView addSubview:buttonLine];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        cancelBtn.tag = 2;
        [cancelBtn setTitle:cancelBtnStr forState:UIControlStateNormal];
        [cancelBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [cancelBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5 * ALERT_WIDTTH, currentHeight, 0.5 * ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    else
    {
        if (okBtnStr.length == 0) {
            
            okBtnStr = @"确定";
        }
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentHeight, ALERT_WIDTTH, 45)];
        okBtn.tag = 1;
        [okBtn setTitle:okBtnStr forState:UIControlStateNormal];
        [okBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [okBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [okBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:okBtn];
    }
    
    currentHeight += 45;
    
    customView.layer.cornerRadius = 10;
    [customView setBackgroundColor:[UIColor whiteColor]];
    [customView setFrame:CGRectMake(customView.frame.origin.x, (FULLSCREEN_HEIGHT - currentHeight) * 0.5, ALERT_WIDTTH, currentHeight)];
    
    [self.rootViewController.view addSubview:customView];
    
}

- (UIView *)toLoadAllMessageByKeyValue:(NSArray *)messages
{
    UIView *messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ALERT_WIDTTH, ALERT_WIDTTH)];
    
    CGFloat currectHeight = 0;
    
    CGFloat messageBianju = 21;
    
    for (NSInteger i = 0;i < MessageArray.count; i++)
    {
        NSDictionary *aDict = [MessageArray objectAtIndex:i];
        //keyLabel
        UILabel *keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(messageBianju, currectHeight, ALERT_WIDTTH * 0.3, 20)];
        keyLabel.textAlignment = NSTextAlignmentLeft;
        [keyLabel setTextColor:ALERT_TEXT_COLOR];
        [keyLabel setFont:FontSize(16)];
        [keyLabel setText:[aDict.allKeys lastObject]];

        CGSize keySize = [keyLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        keyLabel.frame = RectChangeW(keyLabel.frame, keySize.width);
        
        //ValueLabel
        CGFloat value_x_space = 20;
        CGFloat value_width = ALERT_WIDTTH - CGRectGetMaxX(keyLabel.frame) - value_x_space - messageBianju;
        CGSize valueSize = [ZJAlertView labelAutoCalculateRectWith:[aDict.allValues lastObject] FontSize:16 MaxSize:CGSizeMake(value_width, 50)];
        
        UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(keyLabel.frame) + value_x_space, currectHeight,value_width, valueSize.height)];
        valueLabel.numberOfLines = 2;
        valueLabel.textAlignment = NSTextAlignmentRight;
        [valueLabel setFont:FontSize(16)];
        [valueLabel setTextColor:ALERT_TEXT_COLOR];
        [valueLabel setText:[aDict.allValues lastObject]];

        if (valueSize.height > 20)
        {   //2行
            valueLabel.frame = CGRectMake(valueLabel.frame.origin.x, currectHeight - 3, value_width, 41);
        }
        else
        {   //1行
            valueLabel.frame = RectChangeH(valueLabel.frame, 20);
        }

        [messageView addSubview:keyLabel];
        [messageView addSubview:valueLabel];
        
        currectHeight = CGRectGetMaxY(valueLabel.frame) + 12 - 2;
    }
    
    currectHeight = currectHeight - 10;
    
    CGRect aRect = messageView.frame;
    aRect.size.height = currectHeight;
    messageView.frame = aRect;
    
    return messageView;
}

- (void)singleTapForFinger:(UIGestureRecognizer *)single
{
    
}

- (void)dissMiss
{
    if (ribbonImage)
    {
        [ribbonImage removeFromSuperview];
        ribbonImage = nil;
    }
    
    [customView removeFromSuperview];
    customView = nil;
    
    [backView removeFromSuperview];
    backView = nil;
    
    [[ZJAlertView sharedZJAlertView]resignKeyWindow];
    [[ZJAlertView sharedZJAlertView]setHidden:YES];
    sharedZJAlert = nil;
    
    [[[UIApplication sharedApplication]keyWindow]setNeedsDisplay];
}

- (void)clickedBtn:(id)sender
{
    [self dissMiss];
    UIButton *aBtn = sender;
    if(self.clickBlock)
        self.clickBlock(aBtn.tag);
    
    if (_callTextFieldBack)
    {
        _callTextFieldBack(aBtn.tag, self.textField.text);
    }
    
}

+ (void)dissMissAlert
{
    [[ZJAlertView sharedZJAlertView]dissMiss];
}

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)getPixelColorAtLocation:(UIImage *)image
{
    CGPoint point = CGPointMake(image.size.width * 0.5, image.size.height * 0.5);
    
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [ZJAlertView createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    return color;
}

+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary* attributes = @{NSFontAttributeName:FontSize(fontSize),NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = ceil(labelSize.height);
    
    labelSize.width = ceil(labelSize.width);
    
    return labelSize;
}

@end

@implementation ZJControllerForAlert

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[UIApplication sharedApplication]statusBarStyle];
}



@end
