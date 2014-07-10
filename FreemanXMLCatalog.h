//
//  FreemanXMLCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
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
