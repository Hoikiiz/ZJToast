//
//  ZJAlertView.h
//  WKAlertViewDemo
//
//  Created by 张子建 on 15/5/28.
//  Copyright (c) 2015年 王琨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^callBacks)(NSInteger buttonIndex);

typedef void (^callTextFieldBacks)(NSInteger buttonIndex, NSString *textFieldText);

@interface ZJAlertView : UIWindow

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) callBacks clickBlock ;//按钮点击事件的回调

@property (nonatomic, strong) callTextFieldBacks callTextFieldBack;

//+(void)initializeBtnNomarlImage:(UIImage *)image;
//+(void)initializeBtnHighlightImage:(UIImage *)image;

+(void)initializeBtnNomarlColor:(UIColor *)color;
+(void)initializeBtnHighlightColor:(UIColor *)color;


/**
 显示单个按钮 Alert

 @param titleText 标题
 @param messages 内容 [String]
 @param okstr 按钮标题
 @param aCallBack 按钮callback
 */
+(void)showZJAlertTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack;


/**
 显示两个按钮 Alert

 @param titleText 标题
 @param messages 内容 [String]
 @param okstr 确定按钮标题
 @param cancelstr 取消按钮标题
 @param aCallBack 回调
 */
+(void)showZJAlertTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack;

+(void)dissMissAlert;

 /*
@param  messages
array:
 [
 {"key" : "value"},
 {"入院时间" : "2015-08-25 12:00:01"},
 {"患者姓名" : "张三"},
 {"住院号" : "2015"},
 {"床号" : "20"},
 {"预交款" : "2015"},
 {"累计费用" : "10"},
 {"可用押金" : "2005"},
 {"科室名称" : "心血管内科"},
 ]
 */
+(void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack;

//确定，取消
+(void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack;

//image
+(void)showZJAlertTitle:(NSString *)titleText subTitle:(NSString *)subTitle imageInfo:(UIImage *)image keyValueMessages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack;

// 签到
+ (void)showSignViewtadayTitle:(NSString *)tadayText weekTitle:(NSString *)weekText monthTitle:(NSString *)monthText andOKButtonString:(NSString *)okstr andClickBack:(callBacks)aCallBack;

// 就医足迹
+ (void)showRecordViewfirstTitle:(NSString *)firstText secondTitle:(NSString *)secondText thirdTitle:(NSString *)thirdText andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callBacks)aCallBack;

// textfield
+ (void)showTextFieldViewTitle:(NSString *)titleText Messages:(NSArray *)messages andOKButtonString:(NSString *)okstr andCancelString:(NSString *)cancelstr andClickBack:(callTextFieldBacks)acallTextFieldBack;
@end

@interface ZJControllerForAlert : UIViewController

@end
