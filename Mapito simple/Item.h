//
//  Item.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

@import MapKit;

@class App, History;

@interface Item : NSManagedObject<MKAnnotation,MOBManagedObjectSerialization>


@property (nonatomic, retain) NSDictionary* o_data;
@property (nonatomic, retain) NSString * o_id;
@property (nonatomic, retain) NSNumber * o_lat;
@property (nonatomic, retain) NSNumber * o_lon;
@property (nonatomic, retain) NSString * o_title;
@property (nonatomic, retain) NSDate * o_timestamp;
@property (nonatomic, retain) NSNumber * o_uploading;
@property (nonatomic, retain) NSNumber * o_changed;
@property (nonatomic, retain) App *app;
@property (nonatomic, retain) NSSet *history;


@property (nonatomic, copy, readonly) NSString * title;
//@property (nonatomic, copy) NSString * subtitle;    //datum zmeny
@property (nonatomic, assign, readonly)CLLocationCoordinate2D coordinate;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addHistoryObject:(History *)value;
- (void)removeHistoryObject:(History *)value;
- (void)addHistory:(NSSet *)values;
- (void)removeHistory:(NSSet *)values;

@end
