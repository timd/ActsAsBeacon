//
//  CMSecondViewController.h
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMClientViewController : UIViewController 

@property (nonatomic, copy) NSString *CMUDID;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@end
