//
//  CMUpdateViewController.h
//  ActsAsBeacon
//
//  Created by Tim on 09/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMUpdateViewController : UIViewController
@property (nonatomic, copy) NSString *CMUUID;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@end
