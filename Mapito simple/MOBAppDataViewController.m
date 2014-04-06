//
//  JDProjectDataViewController.m
//  Mapito
//
//  Created by Jakub Dubrovsky on 19/02/14.
//  Copyright (c) 2014 Jakub Dubrovsky. All rights reserved.
//

#import "MOBAppDataViewController.h"


#import "App.h"
#import "Item.h"

#import "MOBAppDataDetailViewController.h"


@interface MOBAppDataViewController ()

@property(nonatomic, strong) NSFetchedResultsController * fetchedResultsController;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) UISearchBar * searchBar;
@property(nonatomic, strong) UIBarButtonItem * barButtonCancel;


-(void) reloadMap;

@end

@implementation MOBAppDataViewController

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
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"app == %@", self.detail]];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"o_id" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [_fetchedResultsController setDelegate:self];
    [_fetchedResultsController performFetch:nil];
    
    
    
    
    
    self.barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self  action:@selector(searchBarCancel:)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 0.0, 200.0, 44.0)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Search POI"];
    self.navigationItem.titleView = self.searchBar;
    
    CGRect frame = self.mapView.frame;
    frame.origin.y=0;
    frame.size.height = frame.size.height-216;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setHidden:YES];
    [self.mapView addSubview:self.tableView];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    [self reloadMap];
    // [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.fetchedResultsController = nil;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetail"]){
        Item * item = (Item *) sender;
        [(MOBAppDataDetailViewController *)segue.destinationViewController setDetail:item];
        [segue.destinationViewController setEditingForm:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.detail.o_title;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item * item = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:item.o_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item * item = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toDetail" sender:item];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item * item = [_fetchedResultsController objectAtIndexPath:indexPath];
    [[[MOBDataManager sharedManager] managedObjectContext] deleteObject:item];
    [[MOBDataManager sharedManager] saveContext];
}

#pragma mark - map

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Item * item = (Item *)view.annotation;
    [self performSegueWithIdentifier:@"toDetail" sender:item];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapannot-poi"];
    
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    advertButton.frame = CGRectMake(0, 0, 23, 23);
    advertButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    advertButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    annView.rightCalloutAccessoryView = advertButton;
    
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}


#pragma mark - actions
- (void)searchBarCancel:(id)sender
{
    [self searchBarDismiss];
}


-(void)reloadMap{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.fetchedResultsController.fetchedObjects];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    if (self.mapView.annotations.count>0) {
        [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
    }
    
}



#pragma mark - searchbar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    /*
    NSArray *selectedAnnotations = self.mapView.selectedAnnotations;
    for (id<MKAnnotation>a in selectedAnnotations) {
        [self.mapView deselectAnnotation:a animated:YES];
    }
    */
    
    /*
    NSMutableArray * subPredicates = [NSMutableArray arrayWithObject:[NSPredicate predicateWithFormat: @"app == %@ ", self.detail]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    */
    [self.tableView setHidden:NO];
    [self.tableView setAlpha:0.7];
    [self.navigationItem setRightBarButtonItem:self.barButtonCancel animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSMutableArray * subPredicates = [NSMutableArray arrayWithObject:[NSPredicate predicateWithFormat: @"app == %@ ", self.detail]];
    if ([searchBar.text length]) {
        [subPredicates addObject:[NSPredicate predicateWithFormat: @"o_title contains[c] %@ ", searchBar.text]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
    [_fetchedResultsController.fetchRequest setPredicate:predicate];

    [_fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
    [self reloadMap];
}

#pragma mark - misc
- (void)searchBarDismiss{
    [self.searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
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
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:_fetchedResultsController.fetchedObjects];
    
    [self reloadMap];
}
@end
