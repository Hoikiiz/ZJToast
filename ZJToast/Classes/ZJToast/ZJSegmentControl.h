//
//  ZJSegmentControl.h
//  CeshiTab
//
//  Created by 张子建 on 15/6/26.
//  Copyright (c) 2015年 张子建. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SegmentBloack)(NSInteger segIndex);

typedef enum : NSUInteger {
    ZJSegmentControlStyleDefault = 0,
    ZJSegmentControlStyleType1,
    ZJSegmentControlStyleType2,
} ZJSegmentControlStyle;

@interface ZJSegmentControl : UIView



@property (nonatomic,assign) ZJSegmentControlStyle segmentStyle;

@property (nonatomic,strong) UIColor *segTintorColor;
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) UIFont *textFont;

@property (nonatomic,assign) NSInteger segDefult;
@property (nonatomic,readonly) NSInteger currentSeg;

@property (nonatomic,strong) UIView *moveView;
@property (nonatomic,assign) CGFloat moveViewHeight;

-(void)setSuoJin:(CGFloat)newSuojin;

//yes 为可用
-(void)setZJSegEnable:(BOOL)isEnable;

-(void)toLoadSegments:(NSArray *)array withHandler:(SegmentBloack)segmentBlock;



@end
