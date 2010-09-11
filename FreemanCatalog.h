//
//  FreemanCatalog.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FreemanCatalog : NSObject {
	NSString						*_name;
	NSMutableArray			*_modules;
}

@property (readonly) NSString *name;
@property (readonly) NSMutableArray *modules;

- (id)initWithName:(NSString *)name;

@end
