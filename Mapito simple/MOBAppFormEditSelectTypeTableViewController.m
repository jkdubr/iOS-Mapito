//
//  MOBAppFormEditSelectTypeTableViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 14/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormEditSelectTypeTableViewController.h"

#import "App.h"

#import "MOBFormCell.h"

#import "MOBAppFormEditItemViewController.h"

@interface MOBAppFormEditSelectTypeTableViewController ()
@property(nonatomic, strong) NSArray * resultsFormTypes;
@end

@implementation MOBAppFormEditSelectTypeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultsFormTypes = [MOBFormCell allTypes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"App Form Edit Select"
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
    return self.resultsFormTypes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Add new form element";
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Application: %@", self.detail.o_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSString * title;
    
    title = self.resultsFormTypes[indexPath.row][@"title"];
    
    if (title) {
        [cell.textLabel setText:title];
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toItem"]) {
        
            NSDictionary * config = [self.resultsFormTypes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [segue.destinationViewController setDetail:self.detail];
        [segue.destinationViewController setConfig:config];
             [segue.destinationViewController setResultsFormConfig:self.resultsFormConfig];
        [segue.destinationViewController setEditingForm:YES];
    }}


#pragma mark - actions
- (IBAction)close:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
