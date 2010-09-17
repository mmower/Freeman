/*
 *  FreemanModularObject.h
 *  Freeman
 *
 *  Created by Matt Mower on 14/09/2010.
 *  Copyright 2010 LucidMac Software. All rights reserved.
 *
 */

@protocol FreemanModularObject

- (id<FreemanModularObject>)owner;
- (NSArray *)contents;
- (NSArray *)allModules;
- (void)addContent:(id<FreemanModularObject>)content;
- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content;
- (NSString *)navigationSequence;
- (NSString *)name;
- (NSString *)path;
- (BOOL)isModule;
- (BOOL)primary;

@end