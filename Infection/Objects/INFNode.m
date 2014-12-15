//
//  INFNode.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFNode.h"
#import "INFUser.h"

@interface INFNode()

@property (strong, nonatomic) INFUser *user;
@property (strong, nonatomic) NSArray *nodes;
@property (assign, nonatomic) NSInteger childrenSize;
@property (assign, nonatomic) BOOL isRoot;

@end

@implementation INFNode

- (void)setUserObject:(INFUser *)obj
{
    _user = obj;
}

- (void)setInteriorNodes:(NSArray *)nodes
{
    _nodes = nodes;
}

- (void)setSize:(NSInteger)size
{
    _childrenSize = size;
}

- (void)setIsARootNode:(BOOL)isRoot
{
    _isRoot = isRoot;
}

- (INFUser *)user
{
    return _user;
}

- (NSArray *)nodes
{
    return _nodes;
}

- (NSInteger)size
{
    return _childrenSize;
}

- (BOOL)isARootNode
{
    return _isRoot;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ - Size: %ld", [self.user userName], self.childrenSize];
}

@end
