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

#import "MOBAppFormViewController.h"


@interface MOBAppDataViewController ()

@property(nonatomic, strong) NSFetchedResultsController * fetchedResultsController;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) UISearchBar * searchBar;
@property(nonatomic, strong) UIBarButtonItem * barButtonCancel;


-(void) reloadData;

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
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[[MOBDataManager sharedManager] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
    
    
    
    
    
    self.barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self  action:@selector(searchBarCancel:)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 0.0, 200.0, 44.0)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Search POI"];
    self.navigationItem.titleView = self.searchBar;
    
    CGRect frame = self.mapView.frame;
    frame.origin.y=64;
    frame.size.height = frame.size.height-64;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setHidden:YES];
    [self.mapView addSubview:self.tableView];
    
    // [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.fetchedResultsController = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadData];
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
        Item * item = [_fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [segue.destinationViewController setApp:self.detail];
//        [segue.destinationViewController setItem:item];
        [segue.destinationViewController setEditingForm:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.detail.o_title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Item * item = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:item.o_title];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toDetail" sender:nil];
}

#pragma mark - actions
- (void)searchBarCancel:(id)sender{
    [self searchBarDismiss];
}


-(void)reloadData{

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[self.detail.items allObjects]];
    
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
    
    NSArray *selectedAnnotations = self.mapView.selectedAnnotations;
    for (id<MKAnnotation>a in selectedAnnotations) {
        [self.mapView deselectAnnotation:a animated:YES];
    }
    
    NSMutableArray * subPredicates = [NSMutableArray arrayWithObject:[NSPredicate predicateWithFormat: @"app == %@ ", self.detail]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
    
    [self.tableView setHidden:NO];
    [self.tableView setAlpha:0.7];
    [self.navigationItem setRightBarButtonItem:self.barButtonCancel animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSMutableArray * subPredicates = [NSMutableArray arrayWithObject:[NSPredicate predicateWithFormat: @"app == %@ ", self.detail]];
    if ([searchBar.text length]) {
        [subPredicates addObject:[NSPredicate predicateWithFormat: @"title contains[c] %@ ", searchBar.text]];
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

#pragma mark - misc
- (void)searchBarDismiss{
    [self.searchBar resignFirstResponder];
    [self.tableView setHidden:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}
@end
