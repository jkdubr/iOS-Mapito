//
//  JDProjectDataViewController.h
//  Mapito
//
//  Created by Jakub Dubrovsky on 19/02/14.
//  Copyright (c) 2014 Jakub Dubrovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;

@class App;

@interface MOBAppDataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, MKMapViewDelegate>

@property(nonatomic, strong) App * detail;




@end
