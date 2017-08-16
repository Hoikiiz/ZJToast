//
//  CommonDef.h
//  Dependency
//
//  Created by LiuBin on 1/15/16.
//
//

#ifndef CommonDef_h
#define CommonDef_h


#pragma mark - 屏幕尺寸

//设备全屏尺寸
#ifndef ZRFullScreenSize
#define ZRFullScreenSize        [UIScreen mainScreen].bounds.size
#endif

//设备全屏宽度
#ifndef ZRFullScreenWidth
#define ZRFullScreenWidth       [UIScreen mainScreen].bounds.size.width
#endif

//设备全屏高度
#ifndef ZRFullScreenHight
#define ZRFullScreenHight       [UIScreen mainScreen].bounds.size.height
#endif

//应用程序高度
#ifndef ZRAppFrameHeight
#define ZRAppFrameHeight        [UIScreen mainScreen].applicationFrame.size.height
#endif

#ifndef ZRNavBarHeight
#define ZRNavBarHeight          64
#endif

#ifndef ZRTabBarHeight
#define ZRTabBarHeight          49
#endif

#ifndef FONT_NORMAL
#define FONT_NORMAL @"Helvetica"
#endif

#ifndef FONT_BOLD_NORMAL
#define FONT_BOLD_NORMAL    @"Helvetica-Bold"
#endif

#ifndef FontSize
#define FontSize(x)         [UIFont fontWithName: FONT_NORMAL size:x]
#endif

#ifndef is320
#define is320 (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size))
#endif

#ifndef isIPhone4
#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef isIPhone5
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef isIPhone6
#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef isIPhone6P
#define isIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef IS_IPHONE_5
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#endif

#ifndef IOS7_Later
#define IOS7_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0)
#endif

#ifndef IOS8_Later
#define IOS8_Later      ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.0)
#endif

#ifdef DEBUG
#define TGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TGLog(...)
#endif

#ifndef RectChangeX
#define RectChangeX(rect,X) CGRectMake(X, rect.origin.y, rect.size.width, rect.size.height)
#endif

#ifndef RectChangeY
#define RectChangeY(rect,Y) CGRectMake(rect.origin.x, Y, rect.size.width, rect.size.height)
#endif

#ifndef RectChangeW
#define RectChangeW(rect,W) CGRectMake(rect.origin.x, rect.origin.y, W, rect.size.height)
#endif

#ifndef RectChangeH
#define RectChangeH(rect,H) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, H)
#endif

#ifndef DoubleToString
#define DoubleToString(val) [NSString stringWithFormat:@"%.15f",val]
#endif

#ifndef FloatToString
#define FloatToString(val) [NSString stringWithFormat:@"%f",val]
#endif

#ifndef NORMALSTRING
#define NORMALSTRING(val) ((val.length==0)?@"":val)
#endif



#endif /* CommonDef_h */
