//
//  CMAppDelegate.h
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *globalUUID;
@property (nonatomic) NSInteger globalMajor;
@property (nonatomic) NSInteger globalMinor;

-(void)updateGlobals;

@end
