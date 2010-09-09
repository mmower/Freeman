//
//  FreemanModuleDatabase.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModuleDatabase.h"


@interface FreemanModuleDatabase (PrivateMethods)

- (void)openMenu:(NSDictionary *)attributes;
- (void)addModule:(NSDictionary *)attributes;
- (void)closeMenu;

@end



@implementation FreemanModuleDatabase


- (id)initWithDatabasePath:(NSString *)databasePath {
	if( ( self = [super init] ) ) {
		NSData *xmlData = [[NSFileManager defaultManager] contentsAtPath:databasePath];
		if( xmlData ) {
			NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
			[parser setDelegate:self];
			if( ![parser parse] ) {
				NSLog( @"Failed to parse module database: %@", [[parser parserError] localizedDescription] );
				self = nil;
			}
		} else {
			self = nil;
		}
	}
	
	return self;
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	_menuStack = [NSMutableArray array];
	_modules = [NSMutableArray array];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	_menuStack = nil;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if( [elementName isEqualToString:@"menu"] ) {
		[self openMenu:attributeDict];
	} else if( [elementName isEqualToString:@"module"] ) {
		[self addModule:attributeDict];
	} else {
		NSAssert1( NO, @"Encountered unexpected element: %@", elementName );
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if( [elementName isEqualToString:@"menu"] ) {
		[self closeMenu];
	}		
}


- (void)openMenu:(NSDictionary *)attributes {
	NSString *name = [attributes objectForKey:@"name"];
	[_menuStack addObject:name];
//	NSLog( @"Open menu: %@ [%@]", name, _menuStack );
	
}


- (void)addModule:(NSDictionary *)attributes {
//	NSString *name = [attributes objectForKey:@"name"];
//	NSLog( @"Module: %@", name );	
}


- (void)closeMenu {
	[_menuStack removeLastObject];
//	NSLog( @"Close menu: [%@]", _menuStack );
}


@end
