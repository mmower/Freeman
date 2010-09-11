//
//  FreemanXMLCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanXMLCatalog.h"

#import "FreemanModule.h"


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
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[self catalogLoaded];
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

@end
