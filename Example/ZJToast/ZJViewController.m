//
//  ZJViewController.m
//  ZJToast
//
//  Created by 407036069@qq.com on 08/16/2017.
//  Copyright (c) 2017 407036069@qq.com. All rights reserved.
//

#import "ZJViewController.h"
#import <ZJToast/ZJToast.h>
@interface ZJViewController ()

@end

@implementation ZJViewController

- (IBAction)showToast:(id)sender {
    [ZJToastView showStaut:@"Welcomin"];
}

- (IBAction)showAlert:(id)sender {
    [ZJAlertView showZJAlertTitle:@"Welcomin" Messages:@[@"Hello"] andOKButtonString:@"OK" andClickBack:^(NSInteger buttonIndex) {
        
    }];
}

@end
