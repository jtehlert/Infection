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

- (void)setRoot:(INFNode *)node
{
    _rootNode = node;
}

- (INFNode *)rootNode
{
    return _rootNode;
}

#pragma mark - Data Logging

- (void)printOut
{
    NSLog(@"\tTeacher - Root");

    [self printOutInterior:[_rootNode nodes] withTabLevel:2];
}

- (void)printOutInterior:(NSArray *)array withTabLevel:(NSInteger)tabLevel
{
    for(INFNode *node in array)
    {
        NSString *tabIndentation = @"";
        for(NSInteger i = 0; i < tabLevel; i++)
        {
            tabIndentation = [tabIndentation stringByAppendingString:@"\t"];
        }
        
        if ([node nodes])
        {
            NSLog(@"%@Teacher", tabIndentation);
            [self printOutInterior:[node nodes] withTabLevel:tabLevel+1];
        } else
        {
            NSLog(@"%@Student", tabIndentation);
        }
    }
}

@end
