//
//  History.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "History.h"
#import "Item.h"

@implementation History

@dynamic o_timestamp;
@dynamic o_title;
@dynamic o_gistId;
@dynamic items;
@dynamic app;

+ (instancetype)history
{
    History * history = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]];
    [history setO_timestamp:[NSDate date]];
    [[MOBDataManager sharedManager] saveContext];
    return history;
}

- (NSString *)geojson
{
    NSMutableArray * features = [[NSMutableArray alloc] init];
    NSDictionary * temp = @{
                            @"type" :   @"FeatureCollection",
                            @"features" :   features
                            };
    
    for (Item * item in [self.items allObjects]) {
        NSMutableDictionary * tempData = [[NSMutableDictionary alloc] init];
        if ([item.o_data isKindOfClass:[NSDictionary class]]) {
            for (NSString * keyData in [item.o_data allKeys]) {
                if ([item.o_data[keyData] isKindOfClass:[NSString class]] || [item.o_data[keyData] isKindOfClass:[NSNumber class]] || [item.o_data[keyData] isKindOfClass:[NSArray class]]) {
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
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString ;
}

- (RACSignal *)upload
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
        [self setO_gistId:gistId];
        NSString * link = [NSString stringWithFormat:@"http://geojson.io/#id=gist:anonymous/%@", gistId];
        NSLog(@"gist %@ %@", gistId, link);
        return link;
    }];
}

#pragma mark - links
- (NSString *)linkGist
{
    return [NSString stringWithFormat:@"http://gist.github.com/%@", self.o_gistId];
}

- (NSString *)linkMap
{
    return [NSString stringWithFormat:@"http://geojson.io/#id=gist:anonymous/%@", self.o_gistId];
}
@end
