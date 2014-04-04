//
//  App.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class History;

@interface App : NSManagedObject

+ (instancetype) app;
+ (NSDictionary *) defaultConfig;
/*

 */
@property (nonatomic, retain) NSDictionary * o_formConfig;
@property (nonatomic, retain) NSString * o_id;
@property (nonatomic, retain) NSString * o_title;
@property (nonatomic, retain) NSNumber * o_type;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *history;

-(BOOL) addItem:(NSDictionary *) values;

- (RACSignal *) shareLink;
- (RACSignal *) uploadToGists;
- (NSString *) geojson;

@end

@interface App (CoreDataGeneratedAccessors)

@end
