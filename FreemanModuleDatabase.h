//
//  FreemanModuleDatabase.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FreemanModuleDatabase : NSObject <NSXMLParserDelegate> {
	NSMutableArray			*_modules;
	
	NSMutableArray			*_menuStack;
	NSMutableArray			*_sequenceStack;
	NSMutableString			*_navigationSequence;
	NSUInteger				_currentMenuLength;
}

- (id)initWithDatabasePath:(NSString *)databasePath;

- (NSArray *)searchFor:(NSString *)query;

@end
