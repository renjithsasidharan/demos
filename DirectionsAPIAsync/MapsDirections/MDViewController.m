//
//  MDViewController.m
//  MapsDirections
//
//  Created by Mano Marks on 4/8/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "MDViewController.h"
#import "MDDirectionService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MDViewController () {
  GMSMapView *mapView_;
  NSMutableArray *waypoints_;
  NSMutableArray *waypointStrings_;
}
@end

@implementation MDViewController

- (void)loadView {
  waypoints_ = [[NSMutableArray alloc]init];
  waypointStrings_ = [[NSMutableArray alloc]init];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778376
                                                          longitude:-122.409853
                                                               zoom:13];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.delegate = self;
  self.view = mapView_;

}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
                (CLLocationCoordinate2D)coordinate {
  
  CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                    coordinate.latitude,
                                    coordinate.longitude);
  GMSMarker *marker = [GMSMarker markerWithPosition:position];
  marker.map = mapView_;
  [waypoints_ addObject:marker];
  NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                              coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionString];
  if([waypoints_ count]>1){
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    MDDirectionService *mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
  }
}
- (void)addDirections:(NSDictionary *)json {

  NSDictionary *routes = [json objectForKey:@"routes"][0];
  
  NSDictionary *route = [routes objectForKey:@"overview_polyline"];
  NSString *overview_route = [route objectForKey:@"points"];
  GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
  GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
  polyline.map = mapView_;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
