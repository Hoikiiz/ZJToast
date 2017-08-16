//
//  ZJSelectorView.m
//  CeshiTab
//
//  Created by 张子建 on 15/10/12.
//  Copyright (c) 2015年 张子建. All rights reserved.
//

#import "ZJSelectorView.h"
#import "CommonDef.h"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

@implementation ZJCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Size_Cell, Size_Cell)];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.imageView.layer.cornerRadius = 8;
        self.imageView.layer.masksToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)clearSubView
{
    while (self.subviews.count)
    {
        UIView *view = self.subviews.firstObject;
        
        [view removeFromSuperview];
    }
}

@end

@implementation ZJTextFeild

- (void)deleteBackward
{
    [super deleteBackward];
    if ([self.textdelegate respondsToSelector:@selector(textFieldDidChangeForBackward)] && !self.isHasChange)
    {
        [self.textdelegate textFieldDidChangeForBackward];
    }
    self.isHasChange = NO;
}

@end

@implementation ZJSelectorView
{
    UICollectionView *collectView;
    
    ZJTextFeild *searchText;
    UIImageView *searchImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, frame.size.height)];
        [searchImageView setImage:[UIImage imageNamed:@"selectSearch"]];
        [searchImageView setContentMode:UIViewContentModeCenter];
        [self addSubview:searchImageView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = Interitem;
        layout.sectionInset = UIEdgeInsetsMake(0, layout.minimumInteritemSpacing, 0, layout.minimumInteritemSpacing);
        layout.itemSize = CGSizeMake(Size_Cell, Size_Cell);
        collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height) collectionViewLayout:layout];
        
        [collectView registerClass:[ZJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [collectView setBackgroundColor:[UIColor whiteColor]];
        [collectView setDelegate:self];
        [collectView setDataSource:self];
        [self addSubview:collectView];
        
        searchText = [[ZJTextFeild alloc]initWithFrame:CGRectMake(searchImageView.frame.size.width, 0, frame.size.width - searchImageView.frame.size.width, frame.size.height)];
        [searchText setBorderStyle:UITextBorderStyleNone];
        [searchText setDelegate:self];
        [searchText setTextdelegate:self];
        [searchText setFont:[UIFont systemFontOfSize:14]];
        searchText.returnKeyType = UIReturnKeySearch;
        [searchText setBackgroundColor:[UIColor whiteColor]];
        searchText.placeholder = @"搜索";
        
        [self addSubview:searchText];
    }
    return self;
}

-(void)refreshSelectorView
{
    CGFloat with = 0;
    
    NSInteger count = [self.delegate respondsToSelector:@selector(selectViewNumberForRows)] ? [self.delegate selectViewNumberForRows] : 0;
    
    if (count > 0)
    {
        if (count * (Size_Cell + Interitem) + Interitem > MAX_Collection_With)
        {
            with = MAX_Collection_With;
        }
        else
        {
            with = count * (Size_Cell + Interitem) + Interitem;
        }
    }
    CGRect frame = collectView.frame;
    frame.size.width = with;
    [collectView setFrame:frame];
    
    if (collectView.frame.size.width > 0)
    {
        CGRect frame = searchText.frame;
        frame.origin.x = CGRectGetMaxX(collectView.frame);
        frame.size.width = self.frame.size.width - collectView.frame.size.width;
        [searchText setFrame:frame];
    }
    else
    {
        if (searchText.isFirstResponder)
        {
            CGRect frame = searchText.frame;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            [searchText setFrame:frame];
        }
        else
        {
            CGRect frame = searchText.frame;
            frame.origin.x = CGRectGetMaxX(searchImageView.frame);
            frame.size.width = self.frame.size.width - searchImageView.frame.size.width;
            [searchText setFrame:frame];
        }
    }
    
    [collectView reloadData];
}

-(BOOL)isFirstResponder
{
    [super isFirstResponder];
    
    return [searchText isFirstResponder];
}

-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [searchText becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [searchText resignFirstResponder];
}

-(void)refreshSearchTextWidth
{
    if (collectView.frame.size.width == 0)
    {
        if ([searchText isFirstResponder])
        {
            CGRect frame = searchText.frame;
            frame.origin.x = CGRectGetMaxX(searchImageView.frame);
            frame.size.width = self.frame.size.width - searchImageView.frame.size.width;
            [searchText setFrame:frame];
        }
        else
        {
            CGRect frame = searchText.frame;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            [searchText setFrame:frame];
        }
    }
}

-(void)scrollViewToRight
{
    [collectView setContentOffset:CGPointMake(MAX(0, collectView.contentSize.width - collectView.frame.size.width ), 0) animated:NO];
}

-(void)setTextForSearch:(NSString *)aStr
{
    searchText.text = NORMALSTRING(aStr);
}

-(NSString *)getTextForSearch
{
    return searchText.text;
}

#pragma mark UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        [searchText setIsHasChange:YES];
    }
    
    return YES;
}

-(void)textFieldDidChangeForBackward
{
    if ([self.delegate respondsToSelector:@selector(clickDeleteButtonWhenNoText:)])
    {
        [self.delegate clickDeleteButtonWhenNoText:searchText];
    }
    [self refreshSelectorView];
    
    [self scrollViewToRight];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(selectorViewShouldBeginEditing:)])
    {
        [self.delegate selectorViewShouldBeginEditing:searchText];
    }
    [self refreshSearchTextWidth];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self refreshSearchTextWidth];
    if ([self.delegate respondsToSelector:@selector(selectorViewShouldEndEditing:)])
    {
        [self.delegate selectorViewShouldEndEditing:searchText];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(clickSearchButton:)] && textField.returnKeyType == UIReturnKeySearch)
    {
        [self.delegate clickSearchButton:searchText];
        return YES;
    }
    return NO;
}

#pragma mark UICollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(selectViewNumberForRows)])
    {
        return [self.delegate selectViewNumberForRows];
    }
    return 0;
}

-(NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier :@"cell" forIndexPath :indexPath];
    
    if ([self.delegate respondsToSelector:@selector(selectView:AndIndexPath:WithZJCollectionViewCell:)])
    {
        [self.delegate selectView:self AndIndexPath:indexPath WithZJCollectionViewCell:cell];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(selectView:didSeleectIndexPath:)])
    {
        [self.delegate selectView:self didSeleectIndexPath:indexPath];
    }
    [self refreshSelectorView];
}

@end
