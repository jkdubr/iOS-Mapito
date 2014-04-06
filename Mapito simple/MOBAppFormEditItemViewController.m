//
//  MOBAppFormEditItemViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormEditItemViewController.h"

@interface MOBAppFormEditItemViewController ()

@end

@implementation MOBAppFormEditItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.formConfigItems = self.config[@"items"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions


- (IBAction)save:(UIBarButtonItem *)sender
{
    self.valuesReturn[@"type"] = self.config[@"name"];
    
    for (NSString * key in self.formValues.allKeys) {
        NSString * val = self.formValues[key][@"value"];
        if (val) {
            self.valuesReturn[key] =val;
            if ([key isEqualToString:@"title"]) {
                self.valuesReturn[@"name"] =val;
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)remove:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
