//
//  MOBAppHistoryTableViewController.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 04/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class App;

@interface MOBAppHistoryTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) App * detail;

@end
