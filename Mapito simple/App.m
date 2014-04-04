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
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addHistoryObject:(History *)value;
- (void)removeHistoryObject:(History *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end

@implementation App

@dynamic o_formConfig;
@dynamic o_id;
@dynamic o_title;
@dynamic o_type;
@dynamic items;
@dynamic history;


+ (instancetype)app{
    App * app;
    app = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]];
    [[MOBDataManager sharedManager] saveContext];
    return app;
}

+ (NSDictionary *)defaultConfig{
    return @{
             @"mapping" :   @{
                     @"title"   :   @"title",
                     @"loc"     :   @"loc"
                     },
             @"sections"    :   @[
                     @{
                         @"items" :   @[
                                 @{
                                     @"type": @"textfield",
                                     @"name": @"p1",
                                     @"title": @"Pokus"
                                     },
                                 @{
                                     @"type"    : @"loc",
                                     @"name"    : @"loc",
                                     @"title"   :   @"Position"
                                     }
                                 ]
                         }
                     ]
             };
}

#pragma mark -
- (BOOL)addItem:(NSDictionary *)values{
    
    NSLog(@"config %@",self.o_formConfig);
    NSLog(@"data %@",values);
    
    NSMutableDictionary * itemData = [[NSMutableDictionary alloc] init];
    for (NSString * itemKey in [values allKeys]) {
        id val = [[values objectForKey:itemKey] objectForKey:@"value"];
        if (val) {
            [itemData setObject:val forKey:itemKey];
        }
    }
    
    
    Item * item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]];
    [item setO_data:itemData];
    [item setO_id:[[NSUUID UUID] UUIDString]];
    
    if (self.o_formConfig[@"mapping"][@"title"] && item.o_data[self.o_formConfig[@"mapping"][@"title"] ]) {
        [item setO_title:item.o_data[self.o_formConfig[@"mapping"][@"title"]]];
    }
    if ([[self.o_formConfig objectForKey:@"mapping"] objectForKey:@"loc"] && [item.o_data objectForKey:[[self.o_formConfig objectForKey:@"mapping"] objectForKey:@"loc"]]) {
        [item setO_lat:[[item.o_data objectForKey:[[self.o_formConfig objectForKey:@"mapping"] objectForKey:@"loc"]] objectForKey:@"lat"]];
        [item setO_lon:[[item.o_data objectForKey:[[self.o_formConfig objectForKey:@"mapping"] objectForKey:@"loc"]] objectForKey:@"lon"]];
    }
    
    [self addItemsObject:item];
    
    return YES;
}

- (NSString *)geojson{
    
    NSMutableArray * features = [[NSMutableArray alloc] init];
    NSDictionary * temp = @{
                            @"type" :   @"FeatureCollection",
                            @"features" :   features
                            };
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"app = %@", self]];
    NSArray * items = [[[MOBDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:NULL];
    for (Item * item in items) {
        NSMutableDictionary * tempData = [[NSMutableDictionary alloc] init];
        if ([item.o_data isKindOfClass:[NSDictionary class]]) {
            for (NSString * keyData in [item.o_data allKeys]) {
                if ([item.o_data[keyData] isKindOfClass:[NSString class]] || [item.o_data[keyData] isKindOfClass:[NSNumber class]]) {
                    tempData[keyData] = item.o_data[keyData];
                }
            }
        }
        NSDictionary * t = @{
                             @"type"    :   @"Feature",
                             @"properties"  :   tempData,
                             @"geometry"    :   @{
                                     @"type"    :   @"Point",
                                     @"coordinates" :   @[item.o_lon,item.o_lat]
                                     }
                             };
        [features addObject:t];
        
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString ;
}
#pragma mark - share
- (RACSignal *)shareLink
{
    return nil;
}

- (RACSignal *)uploadToGists
{
    NSURL * url = [NSURL URLWithString:@"https://api.github.com/gists"];
    NSDictionary * params = @{
                              @"files"  :   @{
                                      @"mapito.geojson" :   @{
                                              @"content"    :   [self geojson]
                                              }
                                      }
                              };
    
    return  [[[MOBDataManager sharedManager] postJSON:params toURL:url] map:^id(NSDictionary * json){
        NSString * gistId = json[@"id"];
        NSString * link = [NSString stringWithFormat:@"http://geojson.io/#id=gist:anonymous/%@", gistId];
        NSLog(@"gist %@ %@", gistId, link);
        return link;
    }];
}

@end
