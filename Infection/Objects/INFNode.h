//
//  INFNode.h
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INFUser;

@interface INFNode : NSObject

- (void)setUserObject:(INFUser *)obj;
- (INFUser *)user;

- (void)setInteriorNodes:(NSArray *)nodes;
- (NSArray *)nodes;

@end
