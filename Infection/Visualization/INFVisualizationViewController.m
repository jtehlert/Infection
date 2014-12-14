//
//  INFVisualizationViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFVisualizationViewController.h"
#import "INFTree.h"
#import "INFNode.h"
#import "INFUser.h"
#import "INFTreeView.h"

@interface INFVisualizationViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) INFTree *tree;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) INFTreeView *treeView;

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    
    [self setClassName];
    [self showTree];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setClassName
{
    [self.classNameLabel setText:[NSString stringWithFormat:@"%@", [self.tree className]]];
}
     
- (void)showTree
{
    self.scrollView.delegate = self;
    
    self.treeView = [[INFTreeView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width + 103, self.scrollView.frame.size.height + 119)andRootNode:[self.tree rootNode]];
    self.treeView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.treeView];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.treeView;
}

#pragma mark - Properties

- (NSInteger)viewControllerIndex
{
    return _index;
}

@end
