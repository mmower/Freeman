//
//  FreemanXMLCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanXMLCatalog.h"

#import "FreemanModule.h"
#import "FreemanMenu.h"

@interface FreemanXMLCatalog (PrivateMethods)

- (void)pushMenu:(FreemanMenu *)menu;
- (FreemanMenu *)popMenu;
	
@end


@implementation FreemanXMLCatalog

- (id)initWithName:(NSString *)name catalogFile:(NSString *)catalogFile {
	if( ( self = [super initWithName:name] ) ) {
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
	_currentMenu = [self menu];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self catalogLoaded];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if( [elementName isEqualToString:@"menuset"] ) {
		//
	} else if( [elementName isEqualToString:@"menu"] ) {
		FreemanMenu *subMenu = [[FreemanMenu alloc] initWithName:[attributeDict objectForKey:@"name"]];
		[_currentMenu addSubMenu:subMenu];
		[self pushMenu:_currentMenu];
		_currentMenu = subMenu;
	} else if( [elementName isEqualToString:@"module"] ) {
		[_currentMenu addModule:[[FreemanModule alloc] initWithName:[attributeDict objectForKey:@"name"] catalog:self]];
	} else {
		NSAssert1( NO, @"Encountered unexpected element: %@", elementName );
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if( [elementName isEqualToString:@"menu"] ) {
		_currentMenu = [self popMenu];
	}		
}


- (void)pushMenu:(FreemanMenu *)menu {
	[_menuStack addObject:menu];
}


- (FreemanMenu *)popMenu {
	FreemanMenu *menu = [_menuStack objectAtIndex:([_menuStack count]-1)];
	[_menuStack removeLastObject];
	return menu;
}

@end
