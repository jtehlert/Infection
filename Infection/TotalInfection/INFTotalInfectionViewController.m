//
//  INFTotalInfectionViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFTotalInfectionViewController.h"
#import "INFDataManager.h"

@interface INFTotalInfectionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infectedUsersLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthyUsersLabel;

@end

@implementation INFTotalInfectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUserStatusLabels];
}

- (void)setUserStatusLabels
{
    self.infectedUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] infectedUsers]];
    self.healthyUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] healthyUsers]];
}

@end
