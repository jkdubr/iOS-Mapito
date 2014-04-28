//
//  MOBAppHistoryTableViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 04/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppHistoryTableViewController.h"

#import "App.h"
#import "History.h"

#import <TSMessage.h>

@interface MOBAppHistoryTableViewController (){
    NSDateFormatter * dateFormatter;
}

@property(nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@end

@implementation MOBAppHistoryTableViewController

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
    
    [self setTitle:@"Mapito"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ssZ
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSSortDescriptor *descriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"o_timestamp" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor1];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"app = %@", self.detail]];
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"App History"
                                                                                    forKey:kGAIScreenName] build]];

    
    if ([[self.fetchedResultsController.sections objectAtIndex:0] numberOfObjects]==0)
    {
        [self share:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Layer sharing history";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Application: %@", self.detail.o_title];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    History * history = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString * title = [dateFormatter stringFromDate:history.o_timestamp];
    [cell.textLabel setText:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    History * history = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[history linkMap]] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    History * history = [_fetchedResultsController objectAtIndexPath:indexPath];
    [[[MOBDataManager sharedManager] managedObjectContext] deleteObject:history];
    [[MOBDataManager sharedManager] saveContext];
}

#pragma mark - fetchedResultsController


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - actoins
- (IBAction)share:(UIBarButtonItem *)sender {
    
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"AppHistory"     // Event category (required)
                                                                                        action:@"share"  // Event action (required)
                                                                                         label:@"Share"          // Event label
                                                                                         value:nil] build]];    // Event value
    
    [sender setEnabled:NO];
    
    [TSMessage showNotificationWithTitle:@"Uploading data" subtitle:nil type:TSMessageNotificationTypeMessage];
    [[self.detail saveVersion] subscribeNext:^(History * history)
     {
         [TSMessage showNotificationWithTitle:@"Data was successfully uploaded" subtitle:nil type:TSMessageNotificationTypeSuccess];
         UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[history linkMap]] applicationActivities:nil];
         [self presentViewController:activityVC animated:YES completion:nil];
     } error:^(NSError * error){
         [TSMessage showNotificationWithTitle:@"Error during uploading" subtitle:nil type:TSMessageNotificationTypeError];
     } completed:^(void){
         [sender setEnabled:YES];
     }];
}


@end
