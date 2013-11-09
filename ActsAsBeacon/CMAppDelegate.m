//
//  CMAppDelegate.m
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMAppDelegate.h"
#import "CMBeaconViewController.h"
#import "CMClientViewController.h"
#import "CMUpdateViewController.h"

#define kCMUDID @"B0702880-A295-A8AB-F734-031A98A512DE"

@interface CMAppDelegate ()
@property (nonatomic, strong) CMBeaconViewController *beaconController;
@property (nonatomic, strong) CMClientViewController *clientController;
@property (nonatomic, strong) CMUpdateViewController *updateViewController;
@end

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    self.beaconController = [[CMBeaconViewController alloc] initWithNibName:@"CMBeaconViewController" bundle:nil];
    [self.beaconController setTitle:@"Beacon"];
    [self.beaconController.tabBarItem setImage:[UIImage imageNamed:@"bullhorn"]];
    
    self.clientController = [[CMClientViewController alloc] initWithNibName:@"CMClientViewController" bundle:nil];
    [self.clientController setTitle:@"Client"];
    [self.clientController.tabBarItem setImage:[UIImage imageNamed:@"radar"]];
    
    self.updateViewController = [[CMUpdateViewController alloc] initWithNibName:@"CMUpdateViewController" bundle:nil];
    [self.updateViewController setTitle:@"Update"];
    [self.updateViewController.tabBarItem setImage:[UIImage imageNamed:@"redo"]];
    
//    [self.beaconController setCMUDID:@"dae137d2-48a7-11e3-b6c8-ce3f5508acd9"];
//    [self.clientController setCMUDID:@"dae137d2-48a7-11e3-b6c8-ce3f5508acd9"];
    
    self.globalMajor = 100;
    self.globalMinor = 123;

    [self.beaconController setCMUDID:kCMUDID];
    [self.beaconController setMajor:self.globalMajor];
    [self.beaconController setMinor:self.globalMinor];
    
    [self.clientController setCMUDID:kCMUDID];
    [self.clientController setMajor:self.globalMajor];
    [self.clientController setMinor:self.globalMinor];
    
    [self.updateViewController setCMUUID:kCMUDID];
    [self.updateViewController setMajor:self.globalMajor];
    [self.updateViewController setMinor:self.globalMinor];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[self.beaconController, self.clientController, self.updateViewController]];

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)updateGlobals {
    
    [self.beaconController setCMUDID:self.globalUUID];
    [self.beaconController setMajor:self.globalMajor];
    [self.beaconController setMinor:self.globalMinor];
    
    [self.clientController setCMUDID:self.globalUUID];
    [self.clientController setMajor:self.globalMajor];
    [self.clientController setMinor:self.globalMinor];
    
    [self.updateViewController setCMUUID:self.globalUUID];
    [self.updateViewController setMajor:self.globalMajor];
    [self.updateViewController setMinor:self.globalMinor];
    
}

@end
