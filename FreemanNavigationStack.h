//
//  FreemanNavigationStack.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FreemanNavigationStack : NSObject {
	NSMutableArray			*_menuStack;
	NSMutableArray			*_sequenceStack;
	NSMutableString			*_navigationSequence;
	NSUInteger					_currentMenuLength;
}

@property (readonly) NSMutableArray *menuStack;
@property (readonly) NSMutableArray *sequenceStack;
@property (readonly) NSMutableString *navigationSequence;
@property (readonly) NSUInteger currentMenuLength;

- (void)enterMenu:(NSString *)name;
- (void)exitMenu;
- (void)addedModule;

@end
