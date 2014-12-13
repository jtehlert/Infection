//
//  INFTreeView.m
//  Infection
//
//  Created by Justin Ehlert on 12/12/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFTreeView.h"
#import "INFNode.h"
#import "INFUser.h"

@interface INFTreeView()

@property (strong, nonatomic) INFNode *rootNode;

@end

@implementation INFTreeView

- (id)initWithFrame:(CGRect)frame andRootNode:(INFNode *)rootNode
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _rootNode = rootNode;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawRootNode];
}

- (void)drawRootNode
{
    [self drawCircleWithRect:CGRectMake(self.frame.size.width/2, 20, 40, 40) andParent:nil];
}

- (void)drawCircleWithRect:(CGRect)rect andParent:(NSObject *)parent
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    button.center = CGPointMake(rect.origin.x, rect.origin.y);
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImage *buttonImage = [UIImage imageNamed:@"infected"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    [self addSubview:button];
}

@end
