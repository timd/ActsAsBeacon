//
//  CMFirstViewController.m
//  ActsAsBeacon
//
//  Created by Tim on 07/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMBeaconViewController.h"

@interface CMBeaconViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIButton *toggleButton;
@property (nonatomic, weak) IBOutlet UILabel *udidLabel;

@property (nonatomic, weak) IBOutlet UITextField *uuidField;

@property (nonatomic, weak) IBOutlet UITextField *majorField;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *minorLabel;
@property (nonatomic, weak) IBOutlet UITextField *minorField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic) NSString *identifier;

@property (nonatomic) BOOL isBeaconing;
@property (nonatomic, strong) CBPeripheralManager *peripheralMgr;
@end

@implementation CMBeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.identifier = @"com.charismaticmegafauna.actsasbeacon";
    self.isBeaconing = NO;

    self.peripheralMgr = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    [self.uuidField setText:self.CMUDID];
    [self.majorField setText:[NSString stringWithFormat:@"%d", self.major]];
    [self.majorLabel setText:[NSString stringWithFormat:@"Major: %d", self.major]];
    [self.minorField setText:[NSString stringWithFormat:@"%d", self.minor]];
    [self.minorLabel setText:[NSString stringWithFormat:@"Minor: %d", self.minor]];
    [self.statusLabel setText:@"Not advertising"];
    
    UITapGestureRecognizer *tapCatcher = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBackground:)];
    [tapCatcher setNumberOfTapsRequired:1];
    [tapCatcher setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapCatcher];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.uuidField setText:self.CMUDID];
    [self.majorField setText:[NSString stringWithFormat:@"%ld", (long)self.major]];
    [self.minorField setText:[NSString stringWithFormat:@"%ld", (long)self.minor]];
    
    [self stopAdvertising];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didTapToggleButton:(id)sender {
    
    if (self.isBeaconing) {
        // Switch off
        [self.toggleButton setTitle:@"Start Advertising" forState:UIControlStateNormal];
        self.isBeaconing = NO;
        [self stopAdvertising];
        
    } else {
        // Switch on
        [self.toggleButton setTitle:@"Stop Advertising" forState:UIControlStateNormal];
        self.isBeaconing = YES;
        [self startAdvertising];
    }
    
}

-(void)startAdvertising {

    if (self.peripheralMgr.state == CBPeripheralManagerStatePoweredOn) {
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:self.CMUDID];
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                         major:self.major
                                                                         minor:self.minor
                                                                    identifier:self.identifier];
        
        NSDictionary *proximityData = [region peripheralDataWithMeasuredPower:nil];
        
        
        [self.peripheralMgr startAdvertising:proximityData];
        [self.toggleButton setTitle:@"Stop advertising" forState:UIControlStateNormal];
        [self.statusLabel setText:@"Advertising..."];
    }

}

-(void)stopAdvertising {
    
    if (self.peripheralMgr.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralMgr stopAdvertising];
        [self.statusLabel setText:@"Not advertising"];
        [self.toggleButton setTitle:@"Start advertising" forState:UIControlStateNormal];
    }
    
}


-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
    }
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(IBAction)didTapOnBackground:(id)sender {
    [self.uuidField resignFirstResponder];
    [self.majorField resignFirstResponder];
    [self.minorField resignFirstResponder];
}

-(IBAction)didTapUpdateButton:(id)sender {
    
    [self.majorLabel setText:[NSString stringWithFormat:@"Major: %d", self.major]];
    [self.minorLabel setText:[NSString stringWithFormat:@"Minor: %d", self.minor]];
    [self.udidLabel setText:self.CMUDID];

    [self stopAdvertising];
    [self startAdvertising];
    
}

@end
