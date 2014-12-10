//
//  INFDataManager.h
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INFDataManager : NSObject

+ (INFDataManager *)sharedManager;

- (void)generateDefaultData;

- (NSArray *)trees;

@end
