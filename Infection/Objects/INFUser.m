//
//  INFUser.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFUser.h"

@interface INFUser()

@property (assign, nonatomic) BOOL isTeacher, isInfected;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) INFTree *tree;

@end

@implementation INFUser

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _isInfected = NO;
        _isTeacher = NO;
        _name = @"";
    }
    
    return self;
}

- (void)setIsInfected:(BOOL)isInfected
{
    _isInfected = isInfected;
}

- (void)setIsTeacher:(BOOL)isTeacher
{
    _isTeacher = isTeacher;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setTree:(INFTree *)tree
{
    _tree = tree;
}

- (BOOL)isUserATeacher
{
    return _isTeacher;
}

- (BOOL)isUserInfected
{
    return _isInfected;
}

- (NSString *)userName
{
    return _name;
}

- (INFTree *)parentTree
{
    return _tree;
}

@end
