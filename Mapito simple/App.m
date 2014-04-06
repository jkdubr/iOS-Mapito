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
    [app setO_formConfigMapping: @{
                                   @"title"   :   @"title",
                                   @"loc"     :   @"loc"
                                   }];
    [app setO_formConfigItems: @[
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
                                 ]];
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
    
    App * app1 = [App app];
    [app1 setO_id:@"template-1"];
    [app1 setO_type:kMOBAppTypeTemplate];
    [app1 setO_title:@"Flowers"];
    [app1 setO_formConfigItems:@[
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"title",
                                     @"title": @"Title"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"founder",
                                     @"title": @"Founder"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"vicinity",
                                     @"title": @"Vicinity"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"weather",
                                     @"title": @"Weather"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"description",
                                     @"title": @"Description"
                                     },
                                 @{
                                     @"type": @"selectbox",
                                     @"name": @"vitality",
                                     @"title": @"Vitality",
                                     @"options"  : @[@"Good", @"Poor", @"Withered"]
                                     },
                                 @{
                                     @"type": @"switch",
                                     @"name": @"blooming",
                                     @"title": @"Blooming"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   : @"Position"
                                     }
                                 ]];
    [app1 setO_formConfigMapping: @{
                                   @"title"   :   @"title",
                                   @"loc"     :   @"loc"
                                   }];
    
    App * app2 = [App app];
    [app2 setO_id:@"template-2"];
    [app2 setO_type:kMOBAppTypeTemplate];
    [app2 setO_title:@"Pipe check"];
    [app2 setO_formConfigItems:@[
                                 @{
                                     @"type": @"selectbox",
                                     @"name": @"relevance",
                                     @"title": @"Relevance",
                                     @"options" : @[@"Low", @"Middle", @"Critical"]
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"maintainer",
                                     @"title": @"Maintainer"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"notes",
                                     @"title": @"Notes"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   : @"Position"
                                     }
                                 ]];
    [app2 setO_formConfigMapping: @{
                                   @"title"   :   @"relevance",
                                   @"loc"     :   @"loc"
                                   }];
    
    App * app3 = [App app];
    [app3 setO_id:@"template-3"];
    [app3 setO_type:kMOBAppTypeTemplate];
    [app3 setO_title:@"Pubs"];
    [app3 setO_formConfigItems:@[
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"title",
                                     @"title": @"Title"
                                     },
                                 @{
                                     @"type": @"tags",
                                     @"name": @"beers",
                                     @"title": @"Beers"
                                     },
                                 @{
                                     @"type": @"switch",
                                     @"name": @"outdoor",
                                     @"title": @"Outdoor garden"
                                     },
                                 @{
                                     @"type": @"switch",
                                     @"name": @"hot",
                                     @"title": @"Hot kitchen"
                                     },
                                 @{
                                     @"type": @"selectbox",
                                     @"name": @"waitresses",
                                     @"title": @"Approach of waitresses",
                                     @"options" : @[@"Nice", @"Normal", @"Uncomfortable"]
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"close",
                                     @"title": @"Closing time"
                                     },
                                 @{
                                     @"type": @"selectbox",
                                     @"name": @"Finance",
                                     @"title": @"Finance",
                                     @"options"  : @[@"Cheap", @"Standart", @"Expensive"]
                                     },
                                 @{
                                     @"type": @"stepper",
                                     @"name": @"consume",
                                     @"title": @"Beer consumed"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   : @"Position"
                                     }
                                 ]];
    [app3 setO_formConfigMapping: @{
                                   @"title"   :   @"title",
                                   @"loc"     :   @"loc"
                                   }];
    
    
    App * app4 = [App app];
    [app4 setO_title:@"template-4"];
    [app4 setO_type:kMOBAppTypeTemplate];
    [app4 setO_title:@"Fishing"];
    [app4 setO_formConfigItems:@[
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"species",
                                     @"title": @"Fish species"
                                     },
                                 @{
                                     @"type": @"number",
                                     @"name": @"length",
                                     @"title": @"Length"
                                     },
                                 @{
                                     @"type": @"number",
                                     @"name": @"weight",
                                     @"title": @"Weight"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"notes",
                                     @"title": @"Notes"
                                     },
                                 @{
                                     @"type": @"tags",
                                     @"name": @"river",
                                     @"title": @"Type of river"
                                     },
                                 @{
                                     @"type": @"tags",
                                     @"name": @"bait",
                                     @"title": @"Bait"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   : @"Position"
                                     }
                                 ]];
    [app4 setO_formConfigMapping: @{
                                    @"title"   :   @"species",
                                    @"loc"     :   @"loc"
                                    }];
    
    
    
    App * app5 = [App app];
    [app5 setO_title:@"template-5"];
    [app5 setO_type:kMOBAppTypeTemplate];
    [app5 setO_title:@"Meeting point"];
    [app5 setO_formConfigItems:@[
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"title",
                                     @"title": @"Title"
                                     },
                                 @{
                                     @"type": @"switch",
                                     @"name": @"subway",
                                     @"title": @"Subway access"
                                     },
                                 @{
                                     @"type": @"switch",
                                     @"name": @"seating",
                                     @"title": @"Seating area"
                                     },
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"notes",
                                     @"title": @"Notes"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   : @"Position"
                                     }
                                 ]];
    [app5 setO_formConfigMapping: @{
                                    @"title"   :   @"title",
                                    @"loc"     :   @"loc"
                                    }];
    
    
    
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
