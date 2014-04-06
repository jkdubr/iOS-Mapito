//
//  MOBProjectFormEditViewControllerViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormEditViewController.h"

#import "MOBAppFormEditItemViewController.h"
#import "MOBAppFormViewController.h"

#import "MOBFormCell.h"

#import "App.h"

@interface MOBAppFormEditViewController ()

@property(nonatomic, strong) NSMutableArray * resultsFormConfig;
@property(nonatomic, strong) NSArray * resultsFormTypes;
@property(nonatomic, strong) UITableView * tableViewFormTypes;

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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableViewFormTypes = [[UITableView alloc] initWithFrame:[[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] frame]  style:UITableViewStyleGrouped];
    
    [self.tableViewFormTypes setDelegate:self];
    [self.tableViewFormTypes setDataSource:self];
    [self.tableViewFormTypes registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.resultsFormConfig = [NSMutableArray arrayWithArray:self.detail.o_formConfigItems];
    self.resultsFormTypes = [MOBFormCell allTypes];
    
    
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
    if (self.tableView==tableView) {
        return self.resultsFormConfig.count;
    }else if(self.tableViewFormTypes == tableView){
        return self.resultsFormTypes.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        return @"Edit your application";
    }else if (self.tableViewFormTypes == tableView){
        return @"Add new form element";
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Application: %@", self.detail.o_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary * item;
    
    if (self.tableView == tableView) {
        item = self.resultsFormConfig[indexPath.row];
    }else if (self.tableViewFormTypes == tableView){
        item = self.resultsFormTypes[indexPath.row];
    }
    [cell.textLabel setText:item[@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView == tableView) {
        ;
    } else if (self.tableViewFormTypes == tableView) {
        NSDictionary * config = [self.resultsFormTypes objectAtIndex:indexPath.row];
        
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.tableViewFormTypes setAlpha:0];
        } completion:^(BOOL finished){
            [self.tableViewFormTypes removeFromSuperview];
            [self performSegueWithIdentifier:@"toItem" sender:config];
        }];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView == tableView) {
        [self.resultsFormConfig removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView == tableView) {
        return YES;
    }
    return NO;
}

#pragma mark - actions

- (IBAction)add:(UIBarButtonItem *)sender
{
    [self.view endEditing:YES];
    [self.tableViewFormTypes setAlpha:0.0];
    [self.tableViewFormTypes reloadData];
    [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:self.tableViewFormTypes];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        [self.tableViewFormTypes setAlpha:1];
    } completion:^(BOOL finished){
        ;
    }];
}

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
    if ([segue.identifier isEqualToString:@"toItem"]) {
        NSMutableDictionary * values = [[NSMutableDictionary alloc] init];
        [self.resultsFormConfig addObject:values];
        
        [segue.destinationViewController setValuesReturn:values];
        [segue.destinationViewController setConfig:sender];
        
        [segue.destinationViewController setEditingForm:YES];
    }else if ([segue.identifier isEqualToString:@"toLayer"]){
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
