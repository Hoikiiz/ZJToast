//
//  ZJSelectorView.h
//  CeshiTab
//
//  Created by 张子建 on 15/10/12.
//  Copyright (c) 2015年 张子建. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_Collection_With [UIScreen mainScreen].bounds.size.width - 70
#define Size_Cell 40
#define Interitem 9

@interface ZJCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

-(void)clearSubView;

@end


@protocol ZJTextFeildDelegate <NSObject>

-(void)textFieldDidChangeForBackward;

@end

@interface ZJTextFeild : UITextField

@property (nonatomic,weak) id <ZJTextFeildDelegate>textdelegate;

@property (nonatomic,assign) BOOL isHasChange;

@end


@interface ZJSelectorView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,ZJTextFeildDelegate>

@property (nonatomic,weak) id delegate;

-(void)refreshSelectorView;

-(void)scrollViewToRight;
-(void)setTextForSearch:(NSString *)aStr;

-(NSString *)getTextForSearch;


@end

@protocol ZJSelectorViewDelegate <NSObject>

@optional

-(NSInteger)selectViewNumberForRows;

-(void)selectView:(ZJSelectorView *)selectView AndIndexPath:(NSIndexPath *)indexPath WithZJCollectionViewCell:(ZJCollectionViewCell *)zjCell;

-(void)selectView:(ZJSelectorView *)selectView didSeleectIndexPath:(NSIndexPath *)indexPath;

-(void)clickSearchButton:(ZJTextFeild *)textField;

-(void)clickDeleteButtonWhenNoText:(ZJTextFeild *)textField;

- (void)selectorViewShouldBeginEditing:(ZJTextFeild *)textField;

- (void)selectorViewShouldEndEditing:(ZJTextFeild *)textField;


@end


