//
//  Account.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * o_nameFirst;
@property (nonatomic, retain) NSString * o_nameLast;
@property (nonatomic, retain) NSString * o_token;
@property (nonatomic, retain) NSString * o_mail;

@end
