//
//  EQTableViewController.m
//  EarthquakeTable
//
//  Created by Mano Marks on 3/4/13.
//  Copyright (c) 2013 Google. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kUSGSEarthQuakes [NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/geojson/all/hour"]

#import "EQViewController.h"
#import "EQTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EQTableViewController (){
    NSMutableArray *quakeArray;
    NSMutableArray *markerArray;
}
@end

@implementation EQTableViewController

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
    [self fetchData];
}
-(void)fetchData
{
    quakeArray = [[NSMutableArray alloc]initWithObjects: nil];
    markerArray = [[NSMutableArray alloc]initWithObjects: nil];
    dispatch_async(kBgQueue, ^{
        _data = [NSData dataWithContentsOfURL:
                 kUSGSEarthQuakes];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:_data waitUntilDone:YES];
    });
    
}
- (void)fetchedData:(NSData *)responseData {
    
    quakeArray = [[NSMutableArray alloc] initWithCapacity:100];
    
    NSError* error;
    _json = [NSJSONSerialization
             JSONObjectWithData:responseData
             
             options:kNilOptions
             error:&error];
    
    NSArray* latestEarthquakes = [_json objectForKey:@"features"]; //2
    for(int i=0;i<[latestEarthquakes count];i++){
        NSDictionary* earthquake = [latestEarthquakes objectAtIndex:i];
        NSDictionary* properties = [earthquake objectForKey:@"properties"];
        NSDictionary* geometry = [earthquake objectForKey:@"geometry"];
        NSString *place = [properties objectForKey:@"place"];
        [quakeArray addObject:place];
        
        NSArray* coordinates = [geometry objectForKey:@"coordinates"];
        double latitude =  [[coordinates objectAtIndex:1] doubleValue];
        double longitude = [[coordinates objectAtIndex:0] doubleValue];
        NSString *magnitude = [[properties objectForKey:@"mag"] stringValue];
        GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
        options.snippet = magnitude;
        options.title = place;
        options.position = CLLocationCoordinate2DMake(latitude,longitude);
        [markerArray addObject:options];
        
    }
    
    [[self tableView] reloadData];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEarthQuakeMarker"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EQViewController *destViewController = segue.destinationViewController;
        destViewController.options = [markerArray objectAtIndex:indexPath.row];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [quakeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MapCell"];
    
    NSString* val = [quakeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = val;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



-(IBAction)instructions {
    [self fetchData];
}

@end
