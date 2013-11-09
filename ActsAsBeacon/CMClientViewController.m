//
//  CMSecondViewController.m
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMClientViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "CMBeacon.h"

@interface CMClientViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@property (nonatomic, weak) IBOutlet UIButton *seekButton;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataArray;

@property (nonatomic, weak) IBOutlet UILabel *serviceUUIDLabel;

@property (nonatomic) BOOL isSeeking;

@end

@implementation CMClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CMClientTableCell" bundle:nil] forCellReuseIdentifier:@"CMClientTableCell"];
    
    self.tableDataArray = [[NSMutableArray alloc] init];
    [self.statusLabel setText:@"Not seeking"];
    [self.serviceUUIDLabel setText:self.CMUDID];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self stopSeeking];
    [self startSeeking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited Region: %@", region);
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if (state == CLRegionStateInside) {
        NSLog(@"Inside Region");
        
        [self.statusLabel setText:@"Inside region"];
        
        [self.locManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    } else {
        NSLog(@"Outside Region");
        
        [self.statusLabel setText:@"Outside region"];
        
        [self.locManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"Beacons: %@", beacons);
    
    if ([beacons count] == 0) {
        [self.tableDataArray removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    
    if ([beacons count] != 0) {
        
        for (CLBeacon *beacon in beacons) {
        
            // Update data array with new values
            // Find existing beacon if it exists
            NSUInteger arrayIndex = [self.tableDataArray indexOfObjectPassingTest:^BOOL(CMBeacon *beaconRecord, NSUInteger idx, BOOL *stop) {
                return ([[beaconRecord minor] isEqualToNumber:beacon.minor]);
            }];
            
            // If not found, create new beacon record
            if (arrayIndex == NSNotFound) {
                
                CMBeacon *newBeaconRecord = [[CMBeacon alloc] init];
                [newBeaconRecord setProximityUUID:[beacon.proximityUUID UUIDString]];
                [newBeaconRecord setMajor:beacon.major];
                [newBeaconRecord setMinor:beacon.minor];
                [newBeaconRecord setProximity:beacon.proximity];
                [newBeaconRecord setAccuracy:beacon.accuracy];
                [newBeaconRecord setRssi:beacon.rssi];
                
                [self.tableDataArray addObject:newBeaconRecord];
                
            } else {
                
                // Have found an existing beacon with a matching minor;
                // need to update it
                
                CMBeacon *existingBeaconRecord = [self.tableDataArray objectAtIndex:arrayIndex];

                [existingBeaconRecord setProximityUUID:[beacon.proximityUUID UUIDString]];
                [existingBeaconRecord setMajor:beacon.major];
                [existingBeaconRecord setMinor:beacon.minor];
                [existingBeaconRecord setProximity:beacon.proximity];
                [existingBeaconRecord setAccuracy:beacon.accuracy];
                [existingBeaconRecord setRssi:beacon.rssi];
                
            }
            
        }
        
    }
    
    // Check for any beacons that have gone missing
    
    NSMutableArray *missingBeacons = [[NSMutableArray alloc] init];
    
    for (CMBeacon *beaconRecord in self.tableDataArray) {
        // Iterate across all the records in the data array
        // see if we can find one that doesn't exist in the detected beacons array
        NSUInteger foundIndex = [beacons indexOfObjectPassingTest:^BOOL(CLBeacon *clBeacon, NSUInteger idx, BOOL *stop) {
            return ([clBeacon.minor isEqualToNumber:beaconRecord.minor]);
        }];
        
        if (foundIndex == NSNotFound) {
            // Can't find the beacon record, need to delete it
            [missingBeacons addObject:beaconRecord];
        }
        
    }

    // Remove any beacons found to be missing
    if ([missingBeacons count] != 0) {
        [self.tableDataArray removeObjectsInArray:missingBeacons];
    }
    
    // Force update of the table
    [self.tableView reloadData];

}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Beacon Ranging Failed");
    [self.statusLabel setText:@"Beacon ranging failed"];
}

#pragma mark -
#pragma mark UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 162.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMClientTableCell"];
    
    CMBeacon *beacon = [self.tableDataArray objectAtIndex:indexPath.row];
    
    UILabel *majorLabel = (UILabel *)[cell viewWithTag:1000];
    UILabel *minorLabel = (UILabel *)[cell viewWithTag:2000];
    UILabel *proxLabel = (UILabel *)[cell viewWithTag:3000];
    UILabel *accuracyLabel = (UILabel *)[cell viewWithTag:4000];
    UILabel *rssiLabel = (UILabel *)[cell viewWithTag:5000];
    
    NSString *proximityText = nil;
    
    switch (beacon.proximity) {
        case 0:
            proximityText = @"0 - Proximity Unknown";
            break;
        case 1:
            proximityText = @"1 - Proximity Immediate";
            break;
        case 2:
            proximityText = @"2 - Proximity Near";
            break;
        case 3:
            proximityText = @"3 - Proximity Far";
            break;
        default:
            break;
    }
    
    [majorLabel setText:[beacon.major stringValue]];
    [minorLabel setText:[beacon.minor stringValue]];
    [proxLabel setText:proximityText];
    [accuracyLabel setText:[NSString stringWithFormat:@"%0.2fm", beacon.accuracy]];
    [rssiLabel setText:[NSString stringWithFormat:@"%d dB", beacon.rssi]];
    
    UIView *strengthView = [cell viewWithTag:6000];
    
    NSInteger absRSSI = ABS(beacon.rssi);
    float strengthAlpha = absRSSI * 0.01;
    [strengthView setAlpha:strengthAlpha];
    
    return cell;
    
}

#pragma mark -
#pragma mark Interaction methods

-(IBAction)didTapSeekButton:(id)sender {
    
    if (self.isSeeking) {
        self.isSeeking = NO;
        [self.seekButton setTitle:@"Start seeking" forState:UIControlStateNormal];
        [self stopSeeking];
    } else {
        self.isSeeking = YES;
        [self.seekButton setTitle:@"Stop seeking" forState:UIControlStateNormal];
        [self startSeeking];
    }
    
}

-(void)startSeeking {

    self.locManager = [[CLLocationManager alloc] init];
    [self.locManager setDelegate:self];
    
    if ([CLLocationManager isRangingAvailable]) {
        
        NSLog(@"Beacon ranging available");
        
        [self.statusLabel setText:@"Starting seeking"];
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:self.CMUDID];
        
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"identifier"];
        
        [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
        [self.beaconRegion setNotifyOnEntry:NO];
        [self.beaconRegion setNotifyOnExit:NO];
        
        [self.locManager startMonitoringForRegion:self.beaconRegion];
        
    }
    
    [self.serviceUUIDLabel setText:self.CMUDID];
    
}

-(void)stopSeeking {

    if ([CLLocationManager isRangingAvailable]) {
        
        [self.locManager stopMonitoringForRegion:self.beaconRegion];
        self.beaconRegion = nil;
        
    }
    
    self.locManager = nil;
    
    [self.tableDataArray removeAllObjects];
    [self.tableView reloadData];
    [self.statusLabel setText:@"Not seeking"];
    
}

@end
