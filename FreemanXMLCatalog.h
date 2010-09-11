//
//  FreemanXMLCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanCatalog.h"

@interface FreemanXMLCatalog : FreemanCatalog <NSXMLParserDelegate> {
	NSMutableArray			*_menuStack;
	NSMutableArray			*_sequenceStack;
	NSMutableString			*_navigationSequence;
	NSUInteger					_currentMenuLength;
}

- (id)initWithName:(NSString *)name catalogFile:(NSString *)catalogFile;

@end
