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
@property (strong, nonatomic) NSMutableArray *allUsers;
@property (assign, nonatomic) NSInteger treeCount, studentCount, teacherCount, rootTeacherCount, infectedUsers, healthyUsers;

@end

@implementation INFDataManager

static INFDataManager *shared = NULL;

+ (INFDataManager *)sharedManager {
    {
        if ( !shared || shared == NULL )
        {
            shared = [[INFDataManager alloc] init];
            shared.allUsers = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    self.treeCount = 0;
    
    for(NSArray *class in plist)
    {
        self.treeCount++;
        
        INFTree *tree = [[INFTree alloc] init];
        [tree setClassName:[NSString stringWithFormat:@"Class %ld", self.treeCount]];
        
        INFNode *root = [[INFNode alloc] init];
        
        // Make sure class has data
        if([class count] > 0)
        {
            self.rootTeacherCount++;
            
            INFUser *rootUser = [[INFUser alloc] init];
            [rootUser setIsTeacher:YES];
            [rootUser setName:[NSString stringWithFormat:@"Root Teacher %ld", self.rootTeacherCount]];
            [rootUser setTree:tree];
            [self.allUsers addObject:rootUser];
            
            [root setUserObject:rootUser];
            
            [root setInteriorNodes:[self generateInteriorNodes:[class objectAtIndex:0] inTree:tree]];
        }
        
        [tree setRoot:root];
        self.healthyUsers++;
        
        [mutableData addObject:tree];
    }
    
    _trees = [NSArray arrayWithArray:mutableData];
    
    [self printOutAllTrees];
}

- (INFTree *)treeThatUserExistsIn:(INFUser *)user
{
    return [user parentTree];
}

- (void)infectTree:(INFTree *)tree
{
    INFNode *rootNode = [tree rootNode];
    INFUser *rootUser = [rootNode user];
    [rootUser setIsInfected:YES];
    
    [self infectInteriorNodes:[rootNode nodes]];
    self.infectedUsers++;
    self.healthyUsers--;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:nil];
}

- (NSArray *)users
{
    return [NSArray arrayWithArray:self.allUsers];
}

- (NSArray *)nonInfectedUsers
{
    NSMutableArray *nonInfectedUsers = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(INFUser *user in [self users])
    {
        if(![user isUserInfected])
        {
            [nonInfectedUsers addObject:user];
        }
    }
    
    return nonInfectedUsers;
}

#pragma mark - properties

- (NSInteger)healthyUsers
{
    return _healthyUsers;
}

- (NSInteger)infectedUsers
{
    return _infectedUsers;
}

- (NSArray *)trees
{
    return _trees;
}

#pragma mark - private methods

- (NSArray *)generateInteriorNodes:(NSArray *)array inTree:(INFTree *)tree
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSObject *object in array)
    {
        INFNode *node = [[INFNode alloc] init];
        
        if ([object isKindOfClass:[NSArray class]])
        {
            self.teacherCount++;
            
            INFUser *teacher = [[INFUser alloc] init];
            [teacher setIsTeacher:YES];
            [teacher setTree:tree];
            [teacher setName:[NSString stringWithFormat:@"Teacher %ld", self.teacherCount]];
            [self.allUsers addObject:teacher];
            
            [node setUserObject:teacher];
            [node setInteriorNodes:[self generateInteriorNodes:(NSArray *)object inTree:tree]];
            
            [mutableArray addObject:node];
            self.healthyUsers++;
        } else if ([object isKindOfClass:[NSString class]])
        {
            self.studentCount++;
            
            INFUser *student = [[INFUser alloc] init];
            [student setTree:tree];
            [student setName:[NSString stringWithFormat:@"Student %ld", self.studentCount]];
            [self.allUsers addObject:student];
            
            [node setUserObject:student];
            
            [mutableArray addObject:node];
            self.healthyUsers++;
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (void)infectInteriorNodes:(NSArray *)array
{
    for(INFNode *node in array)
    {
        INFUser *user = [node user];
        
        [user setIsInfected:YES];
        self.infectedUsers++;
        self.healthyUsers--;
        
        if([user isUserATeacher])
        {
            [self infectInteriorNodes:[node nodes]];
        }
    }
}

#pragma mark - Data Logging

- (void)printOutAllTrees
{
    NSInteger classCount = 1;
    for (INFTree *tree in _trees) {
        NSLog(@"%@", [tree className]);
        [tree printOut];
        classCount++;
    }
}

@end
