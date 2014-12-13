//
//  INFVisualizationPageViewController.m
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFVisualizationPageViewController.h"
#import "INFVisualizationViewController.h"
#import "INFDataManager.h"
#import "INFTree.h"

static NSString *const kVisualizationViewControllerNibName = @"INFVisualizationViewController";

@interface INFVisualizationPageViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *viewControllersArray;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation INFVisualizationPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    
    [self generateViewControllers];
    [self createPageControl];
    
    self.view.backgroundColor = [UIColor colorWithRed:(57.0/255.0) green:(69.0/255.0) blue:(81.0/255.0) alpha:1.0];
    
    [self setViewControllers:[NSArray arrayWithObjects:[self.viewControllersArray firstObject], nil] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)generateViewControllers
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger index = 0;
    
    for (INFTree *tree in [[INFDataManager sharedManager] trees])
    {
        INFVisualizationViewController *visualization = [[INFVisualizationViewController alloc] initWithNibName:kVisualizationViewControllerNibName bundle:nil andTree:tree andIndex:index];
        [viewControllers addObject:visualization];
        index++;
    }

    self.viewControllersArray = [NSArray arrayWithArray:viewControllers];
}

- (void)createPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 30);
    self.pageControl.numberOfPages = [[[INFDataManager sharedManager] trees] count];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

- (void)pageControlValueChanged
{
    NSInteger selectedIndex = self.pageControl.currentPage;
    INFVisualizationViewController *newViewController = [self.viewControllersArray objectAtIndex:selectedIndex];
    [self setViewControllers:[NSArray arrayWithObject:newViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(INFVisualizationViewController *)viewController viewControllerIndex];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    [self.pageControl setCurrentPage:index];
    
    return [self.viewControllersArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(INFVisualizationViewController *)viewController viewControllerIndex];
    
    index++;
    
    if (index == [[[INFDataManager sharedManager] trees] count]) {
        return nil;
    }
    
    [self.pageControl setCurrentPage:index];
    
    return [self.viewControllersArray objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [[[INFDataManager sharedManager] trees] count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    
    // Find index of current page
    INFVisualizationViewController *currentViewController = (INFVisualizationViewController *)[self.viewControllers lastObject];
    NSUInteger indexOfCurrentPage = [currentViewController viewControllerIndex];
    self.pageControl.currentPage = indexOfCurrentPage;
}

@end
