//
//  FreemanXMLCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanXMLCatalog.h"


@interface FreemanXMLCatalog (PrivateMethods)

- (void)openMenu:(NSDictionary *)attributes;
- (void)addModule:(NSDictionary *)attributes;
- (void)closeMenu;

@end



@implementation FreemanXMLCatalog

- (id)initWithCatalogFile:(NSString *)catalogFile {
	if( ( self = [super init] ) ) {
		NSData *xmlData = [[NSFileManager defaultManager] contentsAtPath:catalogFile];
		if( xmlData ) {
			NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
			[parser setDelegate:self];
			if( ![parser parse] ) {
				NSLog( @"Failed to parse module catalog: %@", [[parser parserError] localizedDescription] );
				self = nil;
			}
		} else {
			self = nil;
		}
	}
	
	return self;
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	_modules = [NSMutableArray array];
	_menuStack = [NSMutableArray array];
	_sequenceStack = [NSMutableArray array];
	_navigationSequence = [NSMutableString stringWithCapacity:20];
	[_navigationSequence appendString:@"R"];
	_currentMenuLength = 0;
	
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
	[_sequenceStack addObject:[_navigationSequence mutableCopy]];
	[_navigationSequence appendString:@"R"];
}


- (void)addModule:(NSDictionary *)attributes {
	[_modules addObject:[[FreemanModule alloc] initWithName:[attributes objectForKey:@"name"] navigationSequence:[NSString stringWithFormat:@"%@!",[_navigationSequence copy]] menuHierarchy:[_menuStack copy]]];
	[_navigationSequence appendString:@"D"];
}


- (void)closeMenu {
	[_menuStack removeLastObject];
	_navigationSequence = [_sequenceStack objectAtIndex:([_sequenceStack count]-1)];
	[_navigationSequence appendString:@"D"];
	[_sequenceStack removeLastObject];
}

@end
