//
//  MOBProjectFormEditViewControllerViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormEditViewController.h"


#import "MOBAppFormViewController.h"

#import "MOBFormCell.h"

#import "App.h"

@interface MOBAppFormEditViewController ()

@property(nonatomic, strong) NSMutableArray * resultsFormConfig;

@end

@implementation MOBAppFormEditViewController

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
    
    
    self.resultsFormConfig = [NSMutableArray arrayWithArray:self.detail.o_formConfigItems];
    
    
    
    [self.textFieldTitle setText:self.detail.o_title];
    [self.textFieldTitle.rac_textSignal subscribeNext:^(NSString * val){
        [self.detail setO_title:val];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"App Form Edit"
                                                                                    forKey:kGAIScreenName] build]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsFormConfig.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Edit your application";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Application: %@", self.detail.o_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString * title = self.resultsFormConfig[indexPath.row][@"title"];
    NSString * subtitle = [MOBFormCell cellInfoForName:self.resultsFormConfig[indexPath.row][@"type"]][@"title"] ;
    
    if (title) {
        [cell.textLabel setText:title];
    }
    
    if (subtitle) {
        [cell.detailTextLabel setText:subtitle];
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.resultsFormConfig removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - actions

- (IBAction)save:(UIBarButtonItem *)sender {
    
    NSMutableDictionary * mapping = [[NSMutableDictionary alloc] init];
    for (NSDictionary * item in self.resultsFormConfig) {
        if (!mapping[@"title"] && [item[@"type"] isEqualToString:@"textfield"]) {
            mapping[@"title"] = item[@"name"];
        }else if (!mapping[@"loc"] && [item[@"type"] isEqualToString:@"loc"]){
            mapping[@"loc"] = item[@"name"];
        }
    }
    
    self.detail.o_formConfigItems = self.resultsFormConfig;
    self.detail.o_formConfigMapping = mapping;
    
    [[MOBDataManager sharedManager] saveContext];
    
    [self performSegueWithIdentifier:@"toLayer" sender:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toLayer"]){
        [segue.destinationViewController setDetail:self.detail];
    } else if ([segue.identifier isEqualToString:@"toTypes"]){
        [segue.destinationViewController setResultsFormConfig:self.resultsFormConfig];
        [segue.destinationViewController setDetail:self.detail];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
