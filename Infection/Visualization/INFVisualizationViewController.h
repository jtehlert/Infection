//
//  INFVisualizationViewController.h
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INFTree.h"

@interface INFVisualizationViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTree:(INFTree *)tree andIndex:(NSInteger)index;
- (NSInteger)viewControllerIndex;

@end
