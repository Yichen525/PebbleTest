//
//  ViewController.m
//  PebbleTest
//
//  Created by Yu Yichen on 5/5/14.
//  Copyright (c) 2014 Yu Yichen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    PBWatch *myWatch;
    id updateHandle;
}



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    myWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    NSLog(@"Last connected watch: %@", myWatch);
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    uuid_t myAppUUIDbytes;
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"44835af9-3fda-4a46-bb14-4beeadf30c9d"];
    [myAppUUID getUUIDBytes:myAppUUIDbytes];
    
    [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
    
    [myWatch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            NSLog(@"This Pebble supports app message!");
        }
        else {
            NSLog(@":( - This Pebble does not support app message!");
        }
    }];
    
//    NSDictionary *update = @{ @(0):[NSNumber numberWithInt16:42],
//                              @(1):@"a string" };
//    [myWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
//        if (!error) {
//            NSLog(@"Successfully sent message.");
//        }
//        else {
//            NSLog(@"Error sending message: %@", error);
//        }
//    }];
//    
//    [myWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
//        NSLog(@"Received message: %d", [[update objectForKey:@(5)] intValue]);
//        return YES;
//    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PBPebbleCentralDelegate
- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    NSLog(@"Pebble connected: %@", [watch name]);
    myWatch = watch;
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    NSLog(@"Pebble disconnected: %@", [watch name]);
    
    if (myWatch == watch || [watch isEqual:myWatch]) {
        myWatch = nil;
    }
}

- (IBAction)didTapStart:(UIButton *)sender {
    [myWatch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Successfully launched app.");
        }
        else {
            NSLog(@"Error launching app - Error: %@", error);
        }
    }
    ];
 
}

- (IBAction)didTapEnd:(UIButton *)sender {
    
    [myWatch appMessagesKill:^(PBWatch *watch, NSError *error) {
        if (!error) {
            NSLog(@"Successfully killed app.");
        }
        else {
            NSLog(@"Error killing app - Error: %@", error);
        }
    }
    ];
}

- (IBAction)didTapGetInfo:(UIButton *)sender {
    
    NSDictionary *update = @{ @(0):[NSNumber numberWithInt16:-1]};
    [myWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
            
            updateHandle =
            [myWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
                NSLog(@"Received message: %d", [[update objectForKey:@(526)] intValue]);
                NSLog(@"Received message: %d", [[update objectForKey:@(527)] intValue]);
                NSLog(@"Received message: %d", [[update objectForKey:@(528)] intValue]);
                NSLog(@"Received message: %d", [[update objectForKey:@(529)] intValue]);
                return YES;
            }];
            
            [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(receiveTimeOut) userInfo:nil repeats:NO];
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (IBAction)didTapSendInfo:(UIButton *)sender {
    
    int random = arc4random()%10000;
    NSLog(@"The random number is %d", random);
    
    NSDictionary *update = @{ @(0):[NSNumber numberWithInt16:random]};
    [myWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
            
            updateHandle =
            [myWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
                NSLog(@"Received message: %d", [[update objectForKey:@(555)] intValue]);
                return YES;
            }];
            
            [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(receiveTimeOut) userInfo:nil repeats:NO];
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];

}


-(void)receiveTimeOut
{
    [myWatch appMessagesRemoveUpdateHandler:updateHandle];
    NSLog(@"Receive Time out");
}
@end
