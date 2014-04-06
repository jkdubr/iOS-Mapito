
//
//  MOBProjectFormEditViewControllerViewController.h
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBFormTableViewController.h"

@class App;

@interface MOBAppFormEditViewController : UITableViewController<UITextFieldDelegate>

@property(nonatomic, strong) App * detail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;

@end
