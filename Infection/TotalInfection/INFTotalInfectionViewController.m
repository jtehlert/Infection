//
//  INFTotalInfectionViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFTotalInfectionViewController.h"
#import "INFDataManager.h"
#import "INFUser.h"
#import "INFNode.h"

static NSString * const kTotalInfectionTableViewCellReuseIdentifier = @"TotalInfectionTableViewCellReuseIdentifier";

@interface INFTotalInfectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infectedUsersLabel;
@property (weak, nonatomic) IBOutlet UILabel *healthyUsersLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation INFTotalInfectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"DataUpdated" object:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUserStatusLabels];
}

- (void)setUserStatusLabels
{
    self.infectedUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] infectedUsers]];
    self.healthyUsersLabel.text = [NSString stringWithFormat:@"%ld", [[INFDataManager sharedManager] healthyUsers]];
}

- (void)dataUpdated:(NSNotification *)n
{
    [self setUserStatusLabels];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[INFDataManager sharedManager] nonInfectedUsers] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTotalInfectionTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    INFUser *user = [[[INFDataManager sharedManager] nonInfectedUsers] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [user userName];
    cell.detailTextLabel.text = [[user parentTree] className];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INFUser *user = [[[INFDataManager sharedManager] nonInfectedUsers] objectAtIndex:indexPath.row];
    
    [[INFDataManager sharedManager] infectTree:[[INFDataManager sharedManager] treeThatUserExistsIn:user]];
}

@end
