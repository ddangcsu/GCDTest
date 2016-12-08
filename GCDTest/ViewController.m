//
//  ViewController.m
//  GCDTest
//
//  Created by david on 12/7/16.
//  Copyright © 2016 David Dang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// Property that get changes by the GCD queue
@property (nonatomic) NSInteger gcdNumber;
@property (nonatomic) NSInteger userNumber;
// Property to control the start and stop of GCD loop
@property (nonatomic) BOOL runFlag;

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *gcdLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *interactiveLabel;

// Button to start the GCD process
- (IBAction)startButtonClick:(id)sender;

// Button to stop the GCD process
- (IBAction)stopButtonClick:(id)sender;

// Button to allow user to manually increase
- (IBAction)userButtonClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the data and button state
    [self.stopButton setEnabled:NO];
    [self.startButton setEnabled:YES];
    self.gcdLabel.text = @"Initialized";
    
    // Initialize the interface for user increase
    self.userNumber = 0;
    self.interactiveLabel.text = [NSString stringWithFormat:@"User num %ld", self.userNumber];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Function to update the gcdLabel
-(void) updateGCDLabel {
    self.gcdLabel.text = [NSString stringWithFormat:@"Num %ld", self.gcdNumber];
}

// Button to start the GCD
- (IBAction)startButtonClick:(id)sender {
    // Change the state of the buttons
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    
    // Set the runFlag to YES and also initialize the number to 0
    self.runFlag = YES;
    self.gcdNumber = -1;
    
	// Create a concurrent queue
    dispatch_queue_t GCDQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Dispatch GCDQueue and pass a block call back to run when the queue is submitted
    dispatch_async(GCDQueue, ^{
        NSLog(@"GCDQueue dispatched !");
        // We will get into an infinite loop
        while (YES) {
            // We modify the background number by 1
            self.gcdNumber += 1;

            // Then we tell the main thread to update the label
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateGCDLabel];
            });
            
            // Then we sleep for 1 second (change 1 to 5 to sleep for 5 second
            [NSThread sleepForTimeInterval:1];
            
            // Then we see if we should continue or if user clicked the stop button
            if (!self.runFlag) {
                break;
            }
        }
        NSLog(@"GCDQueue terminated !");
    });
    
}

// Button to stop the GCD
- (IBAction)stopButtonClick:(id)sender {
    // We change the runFlag to NO to quit the while loop of the gcd
    self.runFlag = NO;
    [self.startButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
}

// This button is click if user want to manually increase
- (IBAction)userButtonClick:(id)sender {
    self.userNumber += 1;
    self.interactiveLabel.text = [NSString stringWithFormat:@"User num %ld", self.userNumber];
}

@end
