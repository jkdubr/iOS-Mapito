//
//  MOBAppFormViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppFormViewController.h"

#import "MOBAppFormEditViewController.h"
#import "MOBAppDataViewController.h"

#import "App.h"
#import "History.h"

@interface MOBAppFormViewController ()

@end

@implementation MOBAppFormViewController

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
    self.formValues = [[NSMutableDictionary alloc] init];
    [self setEditingForm:YES];
    self.formConfigItems = self.detail.o_formConfigItems;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
  //  NSLog(@"x %@", self.formConfig);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.detail.o_title;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toData"]) {
        [segue.destinationViewController setDetail:self.detail];
    } else if ([segue.identifier isEqualToString:@"toFormEdit"]){
        [segue.destinationViewController setDetail:self.detail];
    } else if ([segue.identifier isEqualToString:@"toShare"]){
        [segue.destinationViewController setDetail:self.detail];
    } else if ([segue.identifier isEqualToString:@"toHistory"]){
        [segue.destinationViewController setDetail:self.detail];
    }
}


#pragma mark - actions
- (IBAction)save:(UIBarButtonItem *)sender {
    
    [self.detail addItem:self.formValues];
    
    [[MOBDataManager sharedManager] saveContext];
    self.formValues = [[NSMutableDictionary alloc] init];
    
    
    UIImageView * v=[[UIImageView alloc] initWithFrame:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view].frame];
    CALayer * layer = self.tableView.layer;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),self.tableView.frame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [v setImage:screenImage];
    
    [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:v];
    
    [UIView animateWithDuration:1 animations:^(void){
        [v setFrame:CGRectMake(320, 0, 10, 30)];
        [self.tableView reloadData];
    } completion:^(BOOL finished){
        [v removeFromSuperview];
    }];
    
    
}
- (IBAction)toHome:(UIBarButtonItem *)sender {
    [self.navigationController setViewControllers:@[self.navigationController.viewControllers[0]] animated:YES];
}

- (IBAction)share:(UIButton *)sender {
    
    [[self.detail saveVersion] subscribeNext:^(History * history){
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[history linkMap]] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }];
}

@end
