//
//  MOBHomeTableViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 02/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBHomeTableViewController.h"

#import "MOBAppFormViewController.h"

#import "App.h"

@interface MOBHomeTableViewController ()

@property(nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@end

@implementation MOBHomeTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"App"];
    NSSortDescriptor *descriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"o_type" ascending:YES];
    NSSortDescriptor *descriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"o_title" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor1,descriptor2];
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]
                                                                          sectionNameKeyPath:@"o_type"
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"Home"
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
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    App * app = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (app.o_type == kMOBAppTypePrivate) {
        return @"Private layers";
    }else if (app.o_type == kMOBAppTypeTemplate){
        return @"Prepared Templates";
    }else if (app.o_type == kMOBAppTypeShared){
        return @"Shared Layers";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    App * app = [_fetchedResultsController objectAtIndexPath:indexPath];
    if (app.o_type == kMOBAppTypePrivate) {
        [self performSegueWithIdentifier:@"toLayer" sender:app];
    }else if (app.o_type == kMOBAppTypeTemplate){
        App * appCopied = [app copyAsTemplate];
        [self performSegueWithIdentifier:@"toLayer" sender:appCopied];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    App * app = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:app.o_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    App * app = [_fetchedResultsController objectAtIndexPath:indexPath];
    [[[MOBDataManager sharedManager] managedObjectContext] deleteObject:app];
    [[MOBDataManager sharedManager] saveContext];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    App * app = [_fetchedResultsController objectAtIndexPath:indexPath];
    if (app.o_type == kMOBAppTypeTemplate) {
        return NO;
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toLayer"]) {
        App * app = (App *) sender;
        [segue.destinationViewController setDetail:app];
    }}


#pragma mark - actoins
- (IBAction)toCustom:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toCustom" sender:nil];
}

- (IBAction)actions:(UIBarButtonItem *)sender {
    UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:@"Mapito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Contact Us", @"Share this app", @"Review this app", nil];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"Home"     // Event category (required)
                                                                                        action:@"actions"  // Event action (required)
                                                                                         label:@"Actions"          // Event label
                                                                                         value:@(buttonIndex)] build]];    // Event value
    switch (buttonIndex) {
        case 0:
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                [mailCont setMailComposeDelegate:self];
                [mailCont setSubject:@"Mapito"];
                [mailCont setToRecipients:[NSArray arrayWithObject:@"dubrovsky@mobera.eu"]];
                
                [self presentViewController:mailCont animated:YES completion:NULL];
            }
            break;
        case 1:{
            
            NSString * text = @"Try Mapito, #mobile field #mapping solution designed for #GIS professionals based on @geojsonio";
            NSURL *url = [NSURL URLWithString:@"http://bit.ly/1hDWLbf"];
            
            UIActivityViewController *controller =
            [[UIActivityViewController alloc]
             initWithActivityItems:@[text, url]
             applicationActivities:nil];
            
            [self presentViewController:controller animated:YES completion:nil];
            
        }break;
            case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id866590820"]];

            break;
            
        default:
            break;
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
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

@end
