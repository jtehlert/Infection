//
//  INFVisualizationTableViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/10/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFVisualizationTableViewController.h"
#import "INFDataManager.h"
#import "INFTree.h"
#import "INFNode.h"
#import "INFUser.h"

static NSString * const kVisualizationTableViewStoryboardIdentifier = @"INFVisualizationTableViewController";
static NSString * const kVisualizationTableViewCellReuseIdentifier = @"VisualizationTableViewCellReuseIdentifier";

@interface INFVisualizationTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *titleString;
@property (nonatomic) VisualizationTableViewType type;
@property (strong, nonatomic) INFVisualizationTableViewController *nextTableView;

@end

@implementation INFVisualizationTableViewController

- (void)setData:(NSArray *)data
{
    _data = data;
    _type = VisualizationTableViewTypeInterior;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setTitle];
}

- (void)setTitle
{
    // Make sure there is data before trying to access it
    if(self.type == VisualizationTableViewTypeTop)
    {
        self.title = @"Classes";
        
        // If coming from the storyboard
        if([_data count] == 0)
        {
            _data = [self useTrees];
            [self.tableView reloadData];
        }
    } else
    {
        self.title = _titleString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVisualizationTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    NSObject *object = [_data objectAtIndex:indexPath.row];
    
    NSString *cellLabel;
    
    if([object isKindOfClass:[INFTree class]])
    {
        INFNode *node = [(INFTree *)object rootNode];
        INFUser *user = [node user];
        
        cellLabel = [NSString stringWithFormat:@"Class %ld - %@", indexPath.row + 1, [user userName]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = [self generateDetailStringForUser:user];
    } else if([object isKindOfClass:[INFNode class]])
    {
        INFUser *user = [(INFNode *)object user];
        
        if([user isUserATeacher])
        {
            cellLabel = [user userName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else
        {
            cellLabel = [user userName];
            cell.userInteractionEnabled = NO;
        }
        
        cell.detailTextLabel.text = [self generateDetailStringForUser:user];
    }
    
    cell.textLabel.text = cellLabel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *object = [_data objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if([object isKindOfClass:[INFTree class]])
    {
        INFNode *rootNode = [(INFTree *)object rootNode];
        self.nextTableView = [storyboard instantiateViewControllerWithIdentifier:kVisualizationTableViewStoryboardIdentifier];
        [self.nextTableView setData:[rootNode nodes]];
    } else if([object isKindOfClass:[INFNode class]])
    {
        INFUser *user = [(INFNode *)object user];
        
        if([user isUserATeacher])
        {
            self.nextTableView = [storyboard instantiateViewControllerWithIdentifier: kVisualizationTableViewStoryboardIdentifier];
            [self.nextTableView setData:[(INFNode *)object nodes]];
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.nextTableView setTitleString:cell.textLabel.text];
    
    [self.navigationController pushViewController:self.nextTableView animated:YES];
}

#pragma mark - private methods

- (NSArray *)useTrees
{
    return [[INFDataManager sharedManager] trees];
}

- (NSString *)generateDetailStringForUser:(INFUser *)user
{
    if([user isUserInfected])
    {
        return @"Infected";
    } else
    {
        return @"Not Infected";
    }
}

@end
