//
//  NSURL+Freeman.h
//  Freeman
//
//  Created by Matt Mower on 19/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSURL (Freeman)

- (NSURL *)URLByAppendingPathComponent:(NSString *)pathComponent;

@end
