//
//  MOBAppFormEditSelectTypeTableViewController.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 14/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class App;

@interface MOBAppFormEditSelectTypeTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray * resultsFormConfig;
@property(nonatomic, strong) App * detail;

@end
