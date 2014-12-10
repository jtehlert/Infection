//
//  INFTree.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFTree.h"
#import "INFNode.h"

@interface INFTree()

@property (strong, nonatomic) INFNode *rootNode;

@end

@implementation INFTree

- (INFNode *)rootNode
{
    return _rootNode;
}

@end
