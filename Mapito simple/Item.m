//
//  Item.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "Item.h"
#import "App.h"
#import "History.h"


@implementation Item

@dynamic o_data;
@dynamic o_id;
@dynamic o_lat;
@dynamic o_lon;
@dynamic o_title;
@dynamic o_timestamp;
@dynamic o_uploading;
@dynamic o_changed;
@dynamic app;
@dynamic history;

- (NSString *)title{
    return self.o_title;
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.o_lat doubleValue], [self.o_lon doubleValue]);
}
@end
