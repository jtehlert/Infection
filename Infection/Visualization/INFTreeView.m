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

static NSInteger const kCircleRadius = 12;
static NSInteger const kNodeHorizontalSpacing = 25;
static NSInteger const kNodeVerticalSpacing = 50;

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"DataUpdated" object:nil];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawRootNode];
}

- (void)dataUpdated:(NSNotification *)n
{
    [self setNeedsDisplay];
}

- (void)drawRootNode
{
    CAShapeLayer *rootCircle = [self drawCircleAtPoint:CGPointMake(CGRectGetMidX(self.frame), 30) withNode:self.rootNode];
    [self drawInteriorNodesFromNode:self.rootNode andCircle:rootCircle withLeftOffset:0];
}

- (void)drawInteriorNodesFromNode:(INFNode *)parentNode andCircle:(CAShapeLayer *)parentLayer withLeftOffset:(NSInteger)leftOffset
{
    CGPoint parentPosition = CGPointMake(parentLayer.position.x-kCircleRadius,parentLayer.position.y-kCircleRadius);
    NSInteger beginningPosition = parentPosition.x - [self rowWidthForNumbeOfNodes:[[parentNode nodes] count]] / 2 + leftOffset;
    NSInteger nodePosition = beginningPosition + kCircleRadius * 2;
    
    for(INFNode *node in [parentNode nodes])
    {
        CGPoint newNodePoint = CGPointMake(nodePosition+kCircleRadius, parentPosition.y + 4*kCircleRadius + kNodeVerticalSpacing);
        CAShapeLayer *newNode = [self drawCircleAtPoint:newNodePoint withNode:node];
        [self drawLineBetweenNodesParent:parentLayer andChild:newNode];
        if ([node nodes])
        {
            [self drawInteriorNodesFromNode:node andCircle:newNode withLeftOffset:0];
        }
        nodePosition += 2*kCircleRadius + kNodeHorizontalSpacing;
    }
    
}

- (CAShapeLayer *)drawCircleAtPoint:(CGPoint)point withNode:(INFNode *)node
{
    INFUser *user = [node user];
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*kCircleRadius, 2.0*kCircleRadius) cornerRadius:kCircleRadius].CGPath;
    circle.position = CGPointMake(point.x-kCircleRadius,point.y-kCircleRadius);
    
    circle.fillColor = [UIColor whiteColor].CGColor;
    
    if([user isUserInfected])
    {
        circle.strokeColor = [UIColor redColor].CGColor;
    } else
    {
        circle.strokeColor = [UIColor greenColor].CGColor;
    }
    
    circle.lineWidth = 2;
    circle.zPosition = 1000;
    
    [self.layer addSublayer:circle];
    
    return circle;
}

- (void)drawLineBetweenNodesParent:(CAShapeLayer *)parent andChild:(CAShapeLayer *)child
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    
    [linePath moveToPoint:[self centerPointOfNode:parent]];
    [linePath addLineToPoint:[self centerPointOfNode:child]];
    line.path=linePath.CGPath;
    line.opacity = 1.0;
    line.strokeColor = [UIColor whiteColor].CGColor;
    line.zPosition = -1000;
    
    [self.layer addSublayer:line];
}

- (NSInteger)rowWidthForNumbeOfNodes:(NSInteger)nodes
{
    return nodes * kCircleRadius * 2 + (nodes-1) * kNodeHorizontalSpacing;
}

- (CGPoint)centerPointOfNode:(CAShapeLayer *)layer
{
    return CGPointMake(layer.position.x+kCircleRadius, layer.position.y+kCircleRadius);
}

@end
