//
//  FreemanModule.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanRemoteProcess;
@class FreemanModularObject;
@class FreemanCatalog;

@interface FreemanModule : NSObject <FreemanModularObject> {
	id<FreemanModularObject>	_owner;
	NSString									*_name;
	float											_scoreForLastAbbreviation;
	FreemanCatalog						*	_catalog;
}

@property (assign) id<FreemanModularObject> owner;
@property (assign) NSString *name;
@property (assign) float scoreForLastAbbreviation;
@property (assign) FreemanCatalog *catalog;

- (id)initWithOwner:(id<FreemanModularObject>)owner catalog:(FreemanCatalog *)catalog name:(NSString *)name;

- (void)insertAt:(CGPoint)point inReaktorProcess:(FreemanRemoteProcess *)reaktorProcess;

- (NSString *)menuPath;

- (NSComparisonResult)scoreRelativeTo:(FreemanModule *)module;

@end
