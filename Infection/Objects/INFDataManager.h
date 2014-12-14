//
//  INFDataManager.h
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFTree.h"
#import "INFUser.h"

@interface INFDataManager : NSObject

+ (INFDataManager *)sharedManager;

- (void)generateDefaultData;
- (INFTree *)treeThatUserExistsIn:(INFUser *)user;
- (void)infectTree:(INFTree *)tree;

- (NSArray *)trees;
- (NSInteger)healthyUsers;
- (NSInteger)infectedUsers;

- (NSArray *)users;
- (NSArray *)nonInfectedUsers;

@end
