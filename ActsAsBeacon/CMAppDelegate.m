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

@interface CMAppDelegate ()
@property (nonatomic, strong) CMBeaconViewController *beaconController;
@property (nonatomic, strong) CMClientViewController *clientController;
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
    
    [self.beaconController setCMUDID:@"B0702880-A295-A8AB-F734-031A98A512DE"];
    [self.clientController setCMUDID:@"B0702880-A295-A8AB-F734-031A98A512DE"];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[self.beaconController, self.clientController]];

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

-(void)updateUUID {
    
}

@end
