//
//  INFTree.h
//  Infection
//
//  Created by Justin Ehlert on 12/9/14.
//  Copyright (c) 2014 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INFNode;

@interface INFTree : NSObject

- (void)setRoot:(INFNode *)node;
- (INFNode *)rootNode;

- (void)printOut;

@end
