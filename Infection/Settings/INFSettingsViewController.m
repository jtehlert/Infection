//
//  INFSettingsViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFSettingsViewController.h"
#import "INFDataManager.h"

@interface INFSettingsViewController ()

- (IBAction)resetDataPressed:(id)sender;

@end

@implementation INFSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)resetDataPressed:(id)sender
{
    [[INFDataManager sharedManager] resetData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Reset" message:@"All users are no longer infected!" delegate:nil cancelButtonTitle:@"Thanks!" otherButtonTitles:nil, nil];
    [alert show];
}

@end
