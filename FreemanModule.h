//
//  FreemanModule.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanCatalog;

@interface FreemanModule : NSObject {
	NSString				*_name;
	float						_scoreForLastAbbreviation;
	NSString				*_navigationSequence;
	NSArray					*_menuHierarchy;
	NSString				*_menuPath;
	FreemanCatalog	*_catalog;
}

@property (assign) NSString *name;
@property (assign) float scoreForLastAbbreviation;
@property (assign) NSString *navigationSequence;
@property (assign) NSArray *menuHierarchy;
@property (readonly) NSString *menuPath;
@property (assign) FreemanCatalog *catalog;

- (id)initWithName:(NSString *)name catalog:(FreemanCatalog *)catalog navigationSequence:(NSString *)navigationSequence menuHierarchy:(NSArray *)menuHierarchy;

- (NSString *)completeNavigationSequence;

@end
