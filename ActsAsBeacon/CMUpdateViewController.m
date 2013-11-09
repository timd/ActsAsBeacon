//
//  CMUpdateViewController.m
//  ActsAsBeacon
//
//  Created by Tim on 09/11/2013.
//  Copyright (c) 2013 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMUpdateViewController.h"
#import "CMAppDelegate.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface CMUpdateViewController () <UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>
{
    
    int characteristicCount;
    
    CBCharacteristic *serviceCharacteristic;
    CBCharacteristic *majorCharacteristic;
    CBCharacteristic *minorCharacteristic;
    CBCharacteristic *powerCharacteristic;
    
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;

@property (nonatomic, strong) NSString *serviceUUID;

@property (nonatomic, strong) NSString *blobOneString;
@property (nonatomic, strong) NSString *blobTwoString;
@property (nonatomic, strong) NSString *blobThreeString;
@property (nonatomic, strong) NSString *blobFourString;
@property (nonatomic, strong) NSString *blobFiveString;

@property (nonatomic, strong) NSString *majorString;
@property (nonatomic, strong) NSString *minorString;

@property (nonatomic, weak) IBOutlet UITextField *blobOneField;
@property (nonatomic, weak) IBOutlet UITextField *blobTwoField;
@property (nonatomic, weak) IBOutlet UITextField *blobThreeField;
@property (nonatomic, weak) IBOutlet UITextField *blobFourField;
@property (nonatomic, weak) IBOutlet UITextField *blobFiveField;
@property (nonatomic, weak) IBOutlet UITextField *majorField;
@property (nonatomic, weak) IBOutlet UITextField *minorField;
@property (nonatomic, weak) IBOutlet UITextField *powerField;

@property (nonatomic, weak) IBOutlet UILabel *uuidLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *minorLabel;
@property (nonatomic, weak) IBOutlet UILabel *powerLabel;

@property (nonatomic, weak) IBOutlet UILabel *bleStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton *updateBLEButton;

@property (nonatomic, retain) IBOutletCollection(UITextField) NSArray *textFieldsArray;

@end

@implementation CMUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Split UUID into separate strings
    //           1         2         3`
    // 012345678901234567890123456789012345
    // 5affffff-ffff-ffff-ffff-ffffffffffff
    // blob 1 0 7
    // blob 1 9 4
    // blob 1 14 4
    // blob 1 19 4
    // blob 1 24 12
    
    self.blobOneString = [self.CMUUID substringWithRange:NSMakeRange(0, 8)];
    self.blobTwoString = [self.CMUUID substringWithRange:NSMakeRange(9, 4)];
    self.blobThreeString = [self.CMUUID substringWithRange:NSMakeRange(14, 4)];
    self.blobFourString = [self.CMUUID substringWithRange:NSMakeRange(19, 4)];
    self.blobFiveString = [self.CMUUID substringWithRange:NSMakeRange(24, 12)];
    
    [self.blobOneField setText:self.blobOneString];
    [self.blobTwoField setText:self.blobTwoString];
    [self.blobThreeField setText:self.blobThreeString];
    [self.blobFourField setText:self.blobFourString];
    [self.blobFiveField setText:self.blobFiveString];
    
    [self.majorField setText:[NSString stringWithFormat:@"%d", self.major]];
    [self.minorField setText:[NSString stringWithFormat:@"%d", self.minor]];
    
    [self.uuidLabel setText:self.CMUUID];
    [self.majorLabel setText:[NSString stringWithFormat:@"%d", self.major]];
    [self.minorLabel setText:[NSString stringWithFormat:@"%d", self.minor]];
    
    
    [self.updateBLEButton setEnabled:NO];
    [self.bleStatusLabel setText:@"No BLE"];
    self.centralManager =  [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CoreBluetooth methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self scan];
    
}

- (void)scan {
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"Scanning started");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
        [self.updateBLEButton setEnabled:YES];
        [self.bleStatusLabel setText:@"BLE connected"];
    }
    
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}

- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        [self.updateBLEButton setEnabled:NO];
        return;
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
    [self scan];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:self.CMUUID]]) {
            characteristicCount = 0;
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 1000:
            // blobOne
            self.blobOneString = textField.text;
            break;
        case 2000:
            // blobTwo
            self.blobTwoString = textField.text;
            break;
        case 3000:
            // blobThree
            self.blobThreeString = textField.text;
            break;
        case 4000:
            // blobFour
            self.blobFourString = textField.text;
            break;
        case 5000:
            // blobFive
            self.blobFiveString = textField.text;
            break;
        case 6000:
            // Major
            self.major = [textField.text integerValue];
            break;
        case 7000:
            // Minor
            self.minor = [textField.text integerValue];
            break;
            
        default:
            break;
    }

    // Update serviceUUID
    self.serviceUUID = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", self.blobOneString, self.blobTwoString, self.blobThreeString, self.blobFourString, self.blobFiveString];
    
    
    NSLog(@"ServiceUUID = %@", self.serviceUUID);
    
}

#pragma mark -
#pragma mark interaction methods

-(void)dismissKeyboards {
    for (UITextField *textField in self.textFieldsArray) {
        [textField resignFirstResponder];
    }
}

-(IBAction)didTapUpdateClientButton:(id)sender {
    
    [self dismissKeyboards];
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setGlobalUUID:self.serviceUUID];
    [appDelegate setGlobalMajor:self.major];
    [appDelegate setGlobalMinor:self.minor];
    [appDelegate updateGlobals];
    
    [self.uuidLabel setText:self.serviceUUID];
    [self.majorLabel setText:[NSString stringWithFormat:@"%d", self.major]];
    [self.minorLabel setText:[NSString stringWithFormat:@"%d", self.minor   ]];
}

-(IBAction)didTapUpdateBLEButton:(id)sender {

//    CBUUID *uuid = [CBUUID UUIDWithString:self.CMUUID];

    CBUUID *uuid = [CBUUID UUIDWithString:@"B0702880-A295-A8AB-F734-031A98A512DE"];
    NSData *data = uuid.data;
    [self.discoveredPeripheral writeValue:data forCharacteristic:serviceCharacteristic type:CBCharacteristicWriteWithResponse];
    
    int major = self.major;
    if ((major < 0) || (major > 65535))
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Major number not valid!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    uint8_t buf[] = {0x00 , 0x00};
    buf[1] =  (unsigned int) (major & 0xff);
    buf[0] =  (unsigned int) (major>>8 & 0xff);
    data = [[NSData alloc] initWithBytes:buf length:2];
    [self.discoveredPeripheral writeValue:data forCharacteristic:majorCharacteristic type:CBCharacteristicWriteWithResponse];
    
    int minor = self.minor;
    if ((minor < 0) || (minor > 65535))
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Minor number not valid!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    buf[1] =  (unsigned int) (minor & 0xff);
    buf[0] =  (unsigned int) (minor>>8 & 0xff);
    data = [[NSData alloc] initWithBytes:buf length:2];
    [self.discoveredPeripheral writeValue:data forCharacteristic:minorCharacteristic type:CBCharacteristicWriteWithResponse];
    
    int power = -59 + 256;
    buf[0] = power;
    data = [[NSData alloc] initWithBytes:buf length:1];
    [self.discoveredPeripheral writeValue:data forCharacteristic:powerCharacteristic type:CBCharacteristicWriteWithResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Update successful, please restart BLE Mini!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}

@end
