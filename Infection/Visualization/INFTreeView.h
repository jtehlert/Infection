//
//  INFTreeView.h
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INFNode.h"

@interface INFTreeView : UIView

- (id)initWithFrame:(CGRect)frame andRootNode:(INFNode *)rootNode;

@end
