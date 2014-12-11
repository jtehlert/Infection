//
//  INFUser.h
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFTree.h"

@interface INFUser : NSObject

- (void)setIsInfected:(BOOL)isInfected;
- (void)setIsTeacher:(BOOL)isTeacher;
- (void)setName:(NSString *)name;
- (void)setTree:(INFTree *)tree;

- (BOOL)isUserATeacher;
- (BOOL)isUserInfected;
- (NSString *)userName;
- (INFTree *)parentTree;

@end
