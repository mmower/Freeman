//
//  FreemanXMLCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "FreemanXMLCatalog.h"

#import "FreemanModularObject.h"
#import "FreemanModule.h"
#import "FreemanMenu.h"

@interface FreemanXMLCatalog (PrivateMethods)

- (void)pushMenu:(id<FreemanModularObject>)menu;
- (id<FreemanModularObject>)popMenu;
	
@end


@implementation FreemanXMLCatalog

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name catalogFile:(NSString *)catalogFile {
	if( ( self = [super initWithOwner:owner name:name] ) ) {
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
	_menuStack = [NSMutableArray array];
	_currentContainer = self;
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self catalogLoaded];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if( [elementName isEqualToString:@"menuset"] ) {
		//
	} else if( [elementName isEqualToString:@"menu"] ) {
		FreemanMenu *subMenu = [[FreemanMenu alloc] initWithOwner:_currentContainer name:[attributeDict objectForKey:@"name"]];
		[_currentContainer addContent:subMenu];
		[self pushMenu:_currentContainer];
		_currentContainer = subMenu;
	} else if( [elementName isEqualToString:@"module"] ) {
		FreemanModule *module = [[FreemanModule alloc] initWithOwner:_currentContainer catalog:self name:[attributeDict objectForKey:@"name"]];
		[_currentContainer addContent:module];
	} else {
		NSAssert1( NO, @"Encountered unexpected element: %@", elementName );
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if( [elementName isEqualToString:@"menu"] ) {
		_currentContainer = [self popMenu];
	}		
}


- (void)pushMenu:(id<FreemanModularObject>)menu {
	[_menuStack addObject:menu];
}


- (id<FreemanModularObject>)popMenu {
	id<FreemanModularObject> menu = [_menuStack objectAtIndex:([_menuStack count]-1)];
	[_menuStack removeLastObject];
	return menu;
}

@end
