//
//  INFUser.m
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import "INFUser.h"

@interface INFUser()

@property (assign, nonatomic) NSInteger versionNumber;
@property (assign, nonatomic) BOOL isTeacher;

@end

@implementation INFUser

- (id)init
{
    self = [super init];
    
    if(self)
    {
        _versionNumber = 1;
        _isTeacher = NO;
    }
    
    return self;
}

- (void)setVersionNumber:(NSInteger)versionNumber
{
    _versionNumber = versionNumber;
}

- (void)setIsTeacher:(BOOL)isTeacher
{
    _isTeacher = isTeacher;
}

@end
