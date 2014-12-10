//
//  INFNode.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFNode.h"

@interface INFNode()

@property (strong, nonatomic) INFUser *user;
@property (strong, nonatomic) NSArray *nodes;

@end

@implementation INFNode

- (void)setUserObject:(INFUser *)obj
{
    _user = obj;
}

- (INFUser *)user
{
    return _user;
}

- (void)setInteriorNodes:(NSArray *)nodes
{
    _nodes = nodes;
}

- (NSArray *)nodes
{
    return _nodes;
}

@end
