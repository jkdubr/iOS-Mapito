//
//  MOBAppFormEditItemViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormEditItemViewController.h"

#import "App.h"

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
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    if ([self.config[@"items"] isKindOfClass:[NSArray class]]) {
        self.formConfigItems = self.config[@"items"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions


- (IBAction)save:(UIBarButtonItem *)sender
{
    NSMutableDictionary * valuesReturn = [[NSMutableDictionary alloc] init];
    valuesReturn[@"type"] = self.config[@"name"];
    
    for (NSString * key in self.formValues.allKeys) {
        NSString * val = self.formValues[key][@"value"];
        if (val) {
            valuesReturn[key] =val;
            if ([key isEqualToString:@"title"]) {
                valuesReturn[@"name"] =val;
            }
        }
    }
    [self.resultsFormConfig addObject:valuesReturn];
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
}

- (IBAction)remove:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - MOBFormTableViewControllerDelegate
- (void)formTableViewControllerChangeElement:(MOBFormCell *)formCell withName:(NSString *)name withValue:(id)value
{
    [super formTableViewControllerChangeElement:formCell withName:name withValue:value];
    
    if ([name isEqualToString:@"title"]) {
        [self.navigationItem.rightBarButtonItem setEnabled:([value length]>0)];
    }
}
@end
