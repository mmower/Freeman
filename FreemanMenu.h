//
//  FreemanMenu.h
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanModule;

@interface FreemanMenu : NSObject <FreemanModularObject> {
	id<FreemanModularObject>	_owner;
	NSString				*_name;
	NSMutableArray	*_contents;
}

@property (assign) id<FreemanModularObject> owner;
@property (assign) NSString *name;
@property (readonly) NSMutableArray *contents;

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name;

@end
