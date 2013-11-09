//
//  CMFirstViewController.h
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CMBeaconViewController : UIViewController <CBPeripheralManagerDelegate>

@property (nonatomic, copy) NSString *CMUDID;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;

@end
