//
//  FreemanModule.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FreemanModule : NSObject {
	NSString		*_name;
	float			_scoreForLastAbbreviation;
}

@property (assign) NSString *name;
@property (assign) float scoreForLastAbbreviation;

- (id)initWithName:(NSString *)name;

@end
