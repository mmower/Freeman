//
//  FreemanXMLCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanCatalog.h"
#import "FreemanModularObject.h"

@class FreemanMenu;

@interface FreemanXMLCatalog : FreemanCatalog {
	NSMutableArray						*_menuStack;
	id<FreemanModularObject>	_currentContainer;
}

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name catalogFile:(NSString *)catalogFile;

@end
