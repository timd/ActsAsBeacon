//
//  CMBeacon.h
//  ActsAsBeacon
//
//  Created by Tim on 08/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMBeacon : NSObject

@property (nonatomic, copy) NSString *proximityUUID;
@property (nonatomic) NSNumber *major;
@property (nonatomic) NSNumber *minor;
@property (nonatomic) NSInteger proximity;
@property (nonatomic) CGFloat accuracy;
@property (nonatomic) NSInteger rssi;

@end
