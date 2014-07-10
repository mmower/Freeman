//
//  NSURL+Freeman.h
//  Freeman
//
//  Created by Matt Mower on 19/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

@interface NSURL (Freeman)

- (NSURL *)URLByAppendingPathComponent:(NSString *)pathComponent;

@end
