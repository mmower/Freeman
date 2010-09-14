//
//  FreemanModule.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanMenu;
@class FreemanCatalog;
@class FreemanRemoteProcess;

@interface FreemanModule : NSObject {
	NSString				*_name;
	float						_scoreForLastAbbreviation;
	FreemanMenu			*_menu;
	NSString				*_menuPath;
	NSArray					*_menuHierarchy;
	FreemanCatalog	*_catalog;
}

@property (assign) NSString *name;
@property (assign) float scoreForLastAbbreviation;
@property (assign) FreemanMenu *menu;
@property (assign) NSArray *menuHierarchy;
@property (assign) NSString *menuPath;
@property (assign) FreemanCatalog *catalog;

- (id)initWithName:(NSString *)name catalog:(FreemanCatalog *)catalog;

- (void)insertAt:(CGPoint)point inReaktorProcess:(FreemanRemoteProcess *)reaktorProcess;

@end
