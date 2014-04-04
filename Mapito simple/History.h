//
//  History.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import <Foundation/Foundation.h>

@class App;

@interface History : NSManagedObject

+ (instancetype) history;

@property (nonatomic, retain) NSDate * o_timestamp;
@property (nonatomic, retain) NSString * o_title;
@property (nonatomic, retain) NSString * o_gistId;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) App *app;

- (NSString *) linkMap;
- (NSString *) linkGist;

- (NSString *)geojson;
- (RACSignal *) upload;

@end

@interface History (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
