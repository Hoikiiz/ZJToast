//
//  ZJSegmentControl.m
//  CeshiTab
//
//  Created by 张子建 on 15/6/26.
//  Copyright (c) 2015年 张子建. All rights reserved.
//

#import "ZJSegmentControl.h"

//十六进制颜色转换（0xFFFFFF）
#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

@implementation ZJSegmentControl
{
    UISegmentedControl *segment;
    
    SegmentBloack aSegmentBlock;
    
    CGFloat moveWidth;
    
    NSArray *infoArray;
    
    CGFloat suojin;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.segmentStyle = ZJSegmentControlStyleDefault;
        self.segTintorColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        self.selectColor = [UIColor blueColor];
        self.textFont = [UIFont systemFontOfSize:15];
        
        self.moveView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, 12, 1)];
        self.moveView.backgroundColor = self.selectColor;
        [self addSubview:self.moveView];
        
        suojin = 9;
        
    }
    return self;
}

-(void)setSuoJin:(CGFloat)newSuojin
{
    suojin = newSuojin;
}

-(void)setZJSegEnable:(BOOL)isEnable
{
    [segment setEnabled:isEnable];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [HEXRGBCOLOR(0xDDDDDD) setStroke];
        
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath setLineWidth:0.5];
    [aPath moveToPoint:CGPointMake(0, CGRectGetMaxY(rect) - 0.5)];
    [aPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [aPath stroke];
    
    for (NSInteger i = 1; i < infoArray.count; i++)
    {
        [aPath setLineWidth:0.5];
        [aPath moveToPoint:CGPointMake(moveWidth * i, CGRectGetMaxY(rect) / 3)];
        [aPath addLineToPoint:CGPointMake(moveWidth * i, CGRectGetMaxY(rect) * 2 / 3)];
        [aPath stroke];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.segmentStyle = ZJSegmentControlStyleDefault;
    self.segTintorColor = [UIColor lightGrayColor];
    self.selectColor = [UIColor blueColor];
    self.textFont = [UIFont systemFontOfSize:15];
    
    self.moveView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, 12, 1)];
    self.moveView.backgroundColor = self.selectColor;
    [self addSubview:self.moveView];
    
    suojin = 9;
}


-(void)toLoadSegments:(NSArray *)array withHandler:(SegmentBloack)segmentBlock
{
    infoArray = array;
    
    moveWidth = self.frame.size.width / array.count;

    [segment removeFromSuperview];
    segment = [[UISegmentedControl alloc]initWithItems:array];
    [segment setSelectedSegmentIndex:self.segDefult];
    [segment setTintColor:[UIColor clearColor]];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:self.segTintorColor,NSFontAttributeName:self.textFont} forState:UIControlStateNormal];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXRGBCOLOR(0xDDDDDD),NSFontAttributeName:self.textFont} forState:UIControlStateHighlighted];
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:self.selectColor} forState:UIControlStateSelected];
    [segment setFrame:CGRectMake(0, self.frame.size.height * 0.5 - 14.5, self.frame.size.width, 29)];
    [segment addTarget:self action:@selector(toSelectAction:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:segment];
    [self sendSubviewToBack:segment];
    
    [self.moveView removeFromSuperview];
    self.moveViewHeight = self.frame.size.height - 2;
    self.moveView = [[UIView alloc]initWithFrame:CGRectMake(self.segDefult * moveWidth + suojin, self.moveViewHeight, moveWidth - 2 * suojin, 2)];
    self.moveView.backgroundColor = self.selectColor;
    
    [self addSubview:self.moveView];
    
    aSegmentBlock = segmentBlock;
    
    [self setNeedsDisplay];
}

-(void)toSelectAction:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.moveView setFrame:CGRectMake(segment.selectedSegmentIndex * moveWidth + suojin, self.moveViewHeight, moveWidth - 2 * suojin, self.moveView.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
    _currentSeg = segment.selectedSegmentIndex;
    
    if (aSegmentBlock)
    {
        aSegmentBlock(segment.selectedSegmentIndex);
    }
}

#pragma mark Color

-(void)setSegTintorColor:(UIColor *)segTintorColor
{
    _segTintorColor = segTintorColor;
    
    [self setNeedsDisplay];
}

-(void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    self.moveView.backgroundColor = selectColor;
    
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:self.selectColor} forState:UIControlStateSelected];
}

-(void)setSegDefult:(NSInteger)segDefult
{
    if (segDefult > infoArray.count)
    {
        return;
    }
    
    _segDefult = segDefult;
    
    [segment setSelectedSegmentIndex:segDefult];
    
    [self.moveView  setFrame:CGRectMake(self.segDefult * moveWidth + suojin, self.moveViewHeight, self.moveView.frame.size.width, self.moveView.frame.size.height)];
}




@end
