//
//  App.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

typedef NS_ENUM(int16_t, kMOBAppType) {
    kMOBAppTypePrivate,
    kMOBAppTypeShared,
    kMOBAppTypeTemplate
};


@class History, Item, Workspace;

@interface App : NSManagedObject<MOBManagedObjectSerialization>

+ (void)reloadTemplates;

+ (instancetype) appWithId: (NSString *) id;
+ (instancetype) app;
+ (instancetype) appDefault;

@property (nonatomic, retain) NSArray * o_formConfigItems;
@property (nonatomic, retain) NSDictionary * o_formConfigMapping;
@property (nonatomic, retain) NSString * o_id;
@property (nonatomic, retain) NSString * o_title;
@property (nonatomic) kMOBAppType  o_type;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *history;

@property (nonatomic, retain) Workspace *workspace;

- (BOOL) addItem:(NSDictionary *) values;
- (void) removeItemsObject:(Item *)value;

- (instancetype)copyAsTemplate;

//@return History
- (RACSignal *) saveVersion;

- (RACSignal *) shareLink;
- (RACSignal *) uploadToGists;
- (NSString *) geojson;

@end

@interface App (CoreDataGeneratedAccessors)

@end
