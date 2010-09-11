//
//  FreemanDiskCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanCatalog.h"

@interface FreemanDiskCatalog : FreemanCatalog {

}

- (id)initWithName:(NSString *)name fromRootPath:(NSString *)rootPath withFileType:(NSString *)fileType;

@end
