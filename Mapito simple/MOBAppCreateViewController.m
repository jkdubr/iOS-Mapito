//
//  MOBAppCreateViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppCreateViewController.h"

#import "MOBAppFormEditViewController.h"

#import "App.h"

@interface MOBAppCreateViewController ()

@end

@implementation MOBAppCreateViewController

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

    
    self.formConfig = @[
                        @{
                            @"items"    :   @[
                                    @{
                                        @"type" :   @"textfield",
                                        @"title"  :   @"Application name",
                                        @"name" :   @"name"
                                        }
                                    ]
                            }
                        ];
    
    [self setEditingForm:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Create form for...";
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toFormEdit"]) {
        App * app = (App *) sender;
        [segue.destinationViewController setDetail:app];
    }
}

#pragma mark - actions
- (IBAction)go:(UIBarButtonItem *)sender {
    NSString * title = self.formValues[@"name"][@"value"];

    
    
    App * app = [App app];
    [app setO_title:title];
    [app setO_formConfig:[App defaultConfig]];
    [[MOBDataManager sharedManager] saveContext];
    
    [self performSegueWithIdentifier:@"toFormEdit" sender:app];
}

@end
