//
//  INFLimitedInfectionViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFLimitedInfectionViewController.h"
#import "INFDataManager.h"

@interface INFLimitedInfectionViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infectedUsersLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthyUsersLabel;
@property (weak, nonatomic) IBOutlet UITextField *toInfectTextField;

@property (assign, nonatomic) NSInteger previouslyTriedNumber;

- (IBAction)infectButtonPressed:(id)sender;

@end

@implementation INFLimitedInfectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"DataUpdated" object:nil];
    
    [self setUserStatusLabels];
}

- (void)setUserStatusLabels
{
    self.infectedUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] infectedUsers]];
    self.healthyUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] healthyUsers]];
}

- (void)dataUpdated:(NSNotification *)n
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserStatusLabels];
    });
}

- (IBAction)infectButtonPressed:(id)sender {
    [[INFDataManager sharedManager] resetData];
    
    NSInteger enteredNumber = [[self.toInfectTextField text] integerValue];
    
    if([[INFDataManager sharedManager] canInfectExactNumberOfUsers:enteredNumber])
    {
        [self showSuccessMessageWithNumber:enteredNumber];
    } else
    {
        self.previouslyTriedNumber = enteredNumber;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"We cannot infect that exact number of users. Would you like to infect a number close to that instead?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (void)tryAlternateNumber:(NSInteger)original withOffset:(NSInteger)offset
{
    if([[INFDataManager sharedManager] canInfectExactNumberOfUsers:original+offset])
    {
        [self showSuccessMessageWithNumber:original+offset];
    } else
    {
        if(!(original-1 <= 0))
        {
            if([[INFDataManager sharedManager] canInfectExactNumberOfUsers:original-offset])
            {
                [self showSuccessMessageWithNumber:original-offset];
            } else
            {
                [self tryAlternateNumber:original withOffset:offset+1];
            }
        } else
        {
            [self tryAlternateNumber:original withOffset:offset+1];
        }
    }
}

- (void)showSuccessMessageWithNumber:(NSInteger)number
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"We successfully infected %ld users", number] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Thanks!", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && [alertView.title isEqualToString:@"Sorry"])
    {
        [self tryAlternateNumber:self.previouslyTriedNumber withOffset:1];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.toInfectTextField resignFirstResponder];
    }
}

@end
