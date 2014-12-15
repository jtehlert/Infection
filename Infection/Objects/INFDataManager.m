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
@property (strong, nonatomic) NSMutableArray *allUsers, *teacherNodes;
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
            shared.teacherNodes = [[NSMutableArray alloc] initWithCapacity:0];
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
        [root setIsARootNode:YES];
        
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
            
            [self.teacherNodes addObject:root];
        }
        
        [tree setRoot:root];
//        self.healthyUsers++;
        
        [mutableData addObject:tree];
    }
    
    _trees = [NSArray arrayWithArray:mutableData];
    
    [self generateTeacherSizes];
    
    NSLog(@"%@", self.teacherNodes);
    
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
    if(![rootUser isUserInfected])
    {
        [rootUser setIsInfected:YES];
        self.infectedUsers++;
    }
    
    [self infectInteriorNodes:[rootNode nodes]];
//    self.healthyUsers--;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:nil];
}

- (void)resetData
{
    self.infectedUsers = 0;
    self.healthyUsers = [[self users] count];
    
    for(INFUser *user in [self users])
    {
        [user setIsInfected:NO];
    }
    
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

// Utilizes Dynamic programming to determine if an exact combination can be made
// Runs in polynomial time
- (BOOL)canInfectExactNumberOfUsers:(NSInteger)num
{
    if(num == 0)
    {
        return YES;
    }
    
    NSInteger length = [self.teacherNodes count];
    
    NSMutableArray *table = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSInteger i = 0; i < num+1; i++)
    {
        [table addObject:[[NSMutableArray alloc] initWithCapacity:length+1]];
    }
    
    NSInteger i = 0;
    
    for(i = 0; i <= length; i++)
    {
        [[table objectAtIndex:0] setObject:[NSNumber numberWithBool:YES] atIndex:i];
    }
    
    for(i = 1; i <= num; i++)
    {
        [[table objectAtIndex:i] setObject:[NSNumber numberWithBool:NO] atIndex:0];
    }

    for(i = 1; i <= num; i++)
    {
        for(NSInteger j = 1; j <= length; j++)
        {
            table[i][j] = table[i][j-1];
            [[table objectAtIndex:i] setObject:[[table objectAtIndex:i] objectAtIndex:j-1] atIndex:j];
            
            INFNode *node = [self.teacherNodes objectAtIndex:j-1];
            if(i >= [node size])
            {
                if([[table objectAtIndex:i] objectAtIndex:j] == [NSNumber numberWithBool:YES] ||
                   [[table objectAtIndex:i - [node size]] objectAtIndex:j-1] == [NSNumber numberWithBool:YES])
                {
                    [[table objectAtIndex:i] setObject:[NSNumber numberWithBool:YES] atIndex:j];
                } else
                {
                    [[table objectAtIndex:i] setObject:[NSNumber numberWithBool:NO] atIndex:j];
                }
            }
        }
    }
    
    if([[table objectAtIndex:num] objectAtIndex:length] == [NSNumber numberWithBool:YES])
    {
        NSMutableArray *resultSet = [[NSMutableArray alloc] initWithCapacity:0];
        NSInteger i = num;
        NSInteger j = [(NSMutableArray *)[table objectAtIndex:0] count] - 1;
        
        do {
            while([[table objectAtIndex:i] objectAtIndex:j] == [NSNumber numberWithBool:YES])
            {
                j--;
            }
            j++;
            
            INFNode *node = [self.teacherNodes objectAtIndex:j-1];
            [resultSet addObject:node];
            i = i - [node size];
            
            if(i == 0)
            {
                break;
            }
        } while ([[table objectAtIndex:i] objectAtIndex:j] == [NSNumber numberWithBool:YES]);
        
        NSLog(@"%@", resultSet);
        
        for(INFNode *node in resultSet)
        {
            [self infectNodeDownToOneLevel:node];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated" object:nil];
        
    }
    
    return table[num][length] == [NSNumber numberWithBool:YES];
}

- (void)infectNodeDownToOneLevel:(INFNode *)node
{
    INFUser *user = [node user];
    [user setIsInfected:YES];
    
    self.infectedUsers++;
//    self.healthyUsers--;
    
    if([node nodes])
    {
        for(INFNode *interiorNode in [node nodes])
        {
            INFUser *user = [interiorNode user];
            if(![user isUserATeacher])
            {
                [user setIsInfected:YES];
                
                self.infectedUsers++;
//                self.healthyUsers--;
            }
        }
    }
}

#pragma mark - properties

- (NSInteger)healthyUsers
{
    return [[self users] count] - _infectedUsers;
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
            [self.teacherNodes addObject:node];
            
            [mutableArray addObject:node];
//            self.healthyUsers++;
        } else if ([object isKindOfClass:[NSString class]])
        {
            self.studentCount++;
            
            INFUser *student = [[INFUser alloc] init];
            [student setTree:tree];
            [student setName:[NSString stringWithFormat:@"Student %ld", self.studentCount]];
            [self.allUsers addObject:student];
            
            [node setUserObject:student];
            
            [mutableArray addObject:node];
//            self.healthyUsers++;
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

- (void)infectInteriorNodes:(NSArray *)array
{
    for(INFNode *node in array)
    {
        INFUser *user = [node user];
        
        if(![user isUserInfected])
        {
            [user setIsInfected:YES];
            self.infectedUsers++;
        }
        
        if([user isUserATeacher])
        {
            [self infectInteriorNodes:[node nodes]];
        }
    }
}

- (void)generateTeacherSizes
{
    for(INFNode *node in self.teacherNodes)
    {
        [node setSize:[self interiorTeacherNodeSize:node andPreviousSize:1]];
    }
}

- (NSInteger)interiorTeacherNodeSize:(INFNode *)node andPreviousSize:(NSInteger)size
{
    for(INFNode *interiorNode in [node nodes])
    {
        if(![interiorNode size] > 0)
        {
            size++;
        }
    }
    
    return size;
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
