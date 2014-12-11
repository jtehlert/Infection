//
//  INFDataManager.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFDataManager.h"
#import "INFTree.h"
#import "INFNode.h"
#import "INFUser.h"

static NSString * const kDefaultDataPlist = @"INFDefaultData";

@interface INFDataManager()

@property (strong, nonatomic) NSArray *trees;
@property (assign, nonatomic) NSInteger studentCount, teacherCount, rootTeacherCount;

@end

@implementation INFDataManager

static INFDataManager *shared = NULL;

+ (INFDataManager *)sharedManager {
    {
        if ( !shared || shared == NULL )
        {
            shared = [[INFDataManager alloc] init];
        }
        return shared;
    }
}

#pragma mark - public methods

- (void)generateDefaultData
{
    NSMutableArray *mutableData = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Open up INFDefaultData.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:kDefaultDataPlist ofType:@"plist"];
    NSArray *plist = [[NSArray alloc] initWithContentsOfFile:path];
    
    for(NSArray *class in plist)
    {
        INFTree *tree = [[INFTree alloc] init];
        INFNode *root = [[INFNode alloc] init];
        
        // Make sure class has data
        if([class count] > 0)
        {
            INFUser *rootUser = [[INFUser alloc] init];
            [rootUser setIsTeacher:YES];
            self.rootTeacherCount++;
            [rootUser setName:[NSString stringWithFormat:@"Root Teacher %ld", self.rootTeacherCount]];
            
            [root setUserObject:rootUser];
            
            [root setInteriorNodes:[self generateInteriorNodes:[class objectAtIndex:0]]];
        }
        
        [tree setRoot:root];
        
        [mutableData addObject:tree];
    }
    
    _trees = [NSArray arrayWithArray:mutableData];
    
    [self printOutAllTrees];
}

- (NSArray *)trees
{
    return _trees;
}

#pragma mark - private methods

- (NSArray *)generateInteriorNodes:(NSArray *)array
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSObject *object in array)
    {
        INFNode *node = [[INFNode alloc] init];
        
        if ([object isKindOfClass:[NSArray class]])
        {
            INFUser *teacher = [[INFUser alloc] init];
            [teacher setIsTeacher:YES];
            self.teacherCount++;
            [teacher setName:[NSString stringWithFormat:@"Teacher %ld", self.teacherCount]];
            
            [node setUserObject:teacher];
            [node setInteriorNodes:[self generateInteriorNodes:(NSArray *)object]];
            
            [mutableArray addObject:node];
        } else if ([object isKindOfClass:[NSString class]])
        {
            INFUser *student = [[INFUser alloc] init];
            self.studentCount++;
            [student setName:[NSString stringWithFormat:@"Student %ld", self.studentCount]];
            
            [node setUserObject:student];
            
            [mutableArray addObject:node];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

#pragma mark - Data Logging

- (void)printOutAllTrees
{
    NSInteger classCount = 1;
    for (INFTree *tree in _trees) {
        NSLog(@"Class %ld", classCount);
        [tree printOut];
        classCount++;
    }
}

@end
