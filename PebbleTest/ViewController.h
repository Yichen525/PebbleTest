//
//  ViewController.h
//  PebbleTest
//
//  Created by Yu Yichen on 5/5/14.
//  Copyright (c) 2014 Yu Yichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<PBPebbleCentralDelegate>

- (IBAction)didTapStart:(UIButton *)sender;
- (IBAction)didTapEnd:(UIButton *)sender;
- (IBAction)didTapGetInfo:(UIButton *)sender;
- (IBAction)didTapSendInfo:(UIButton *)sender;

@end
