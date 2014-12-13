//
//  INFVisualizationViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFVisualizationViewController.h"
#import "INFTree.h"

@interface INFVisualizationViewController ()

@property (strong, nonatomic) INFTree *tree;
@property (assign, nonatomic) NSInteger index;

@end

@implementation INFVisualizationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTree:(INFTree *)tree andIndex:(NSInteger)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        _tree = tree;
        _index = index;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)viewControllerIndex
{
    return _index;
}

@end
