//
//  App.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "App.h"
#import "Item.h"
#import "History.h"

@interface App  ()

- (void)addItemsObject:(NSManagedObject *)value;

- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addHistoryObject:(History *)value;
- (void)removeHistoryObject:(History *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end

@implementation App

@dynamic o_formConfigItems;
@dynamic o_formConfigMapping;
@dynamic o_id;
@dynamic o_title;
@dynamic o_type;
@dynamic items;
@dynamic history;


+ (instancetype)app
{
    App * app = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]];
    return app;
}

+ (instancetype)appDefault
{
    App * app = [App app];
    app.o_formConfigMapping = @{
                                @"title"   :   @"title",
                                @"loc"     :   @"loc"
                                };
    app.o_formConfigItems = @[
                              @{
                                  @"type": @"textfield",
                                  @"name": @"title",
                                  @"title": @"Title"
                                  },
                              @{
                                  @"type"    : @"loc",
                                  @"name"    : @"loc",
                                  @"title"   : @"Position"
                                  }
                              ];
    [[MOBDataManager sharedManager] saveContext];
    return app;
}

+ (void)reloadTemplates
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"App"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"o_type = %i", kMOBAppTypeTemplate]];
    for (App * a in [[[MOBDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:NULL]) {
        [[[MOBDataManager sharedManager] managedObjectContext] deleteObject:a];
    }
    
    App * app = [App app];
    [app setO_title:@"template-1"];
    [app setO_type:kMOBAppTypeTemplate];
    [app setO_title:@"Flowers"];
    [app setO_formConfigItems:@[
                                @{
                                    @"type": @"textfield",
                                    @"name": @"title",
                                    @"title": @"Flower"
                                    },
                                @{
                                    @"type": @"number",
                                    @"name": @"height",
                                    @"title": @"Height [cm]"
                                    },
                                @{
                                    @"type"    : @"loc",
                                    @"name"    : @"loc",
                                    @"title"   : @"Position"
                                    }
                                ]];
    [[MOBDataManager sharedManager] saveContext];
}

#pragma mark -
- (instancetype)copyAsTemplate
{
    App * app = [App app];
    [app setO_formConfigItems:[self.o_formConfigItems copy]];
    [app setO_formConfigMapping:[self.o_formConfigMapping copy]];
    [app setO_title:[self.o_title copy]];
    [app setO_type:kMOBAppTypePrivate];
    [[MOBDataManager sharedManager] saveContext];
    return app;
}

- (BOOL)addItem:(NSDictionary *)values
{
    
    // NSLog(@"config %@",self.o_formConfig);
    //NSLog(@"data %@",values);
    
    NSMutableDictionary * itemData = [[NSMutableDictionary alloc] init];
    for (NSString * itemKey in [values allKeys]) {
        id val = values[itemKey][@"value"];
        if (val) {
            itemData[itemKey] = val;
        }
    }
    
    
    Item * item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]];
    [item setO_data:itemData];
    [item setO_id:[[NSUUID UUID] UUIDString]];
    
    if (self.o_formConfigMapping[@"title"] && item.o_data[self.o_formConfigMapping[@"title"] ]) {
        [item setO_title:item.o_data[self.o_formConfigMapping[@"title"]]];
    }
    
    if (self.o_formConfigMapping[@"loc"] && item.o_data[self.o_formConfigMapping[@"loc"]]) {
        [item setO_lat:item.o_data[self.o_formConfigMapping[@"loc"]][@"lat"]];
        [item setO_lon:item.o_data[self.o_formConfigMapping[@"loc"]][@"lon"]];
    }
    
    [self addItemsObject:item];
    
    return YES;
}

- (RACSignal *)saveVersion{
    
    History * history = [History history];
    [history setItems:self.items];
    [history setApp:self];
    
    return [[history upload] map:^id(id x){
        return history;
    }];
}



@end
