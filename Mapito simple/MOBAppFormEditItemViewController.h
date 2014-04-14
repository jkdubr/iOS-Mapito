//
//  MOBAppFormEditItemViewController.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBFormTableViewController.h"

@class App;

@interface MOBAppFormEditItemViewController : MOBFormTableViewController

@property(nonatomic, strong) App * detail;
@property(nonatomic, strong) NSDictionary * config;
@property(nonatomic, strong) NSMutableArray * resultsFormConfig;

@end
