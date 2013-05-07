//
//  ViewController.m
//  Markers
//
//  Created by Luke Mahe on 5/7/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController {
  UISegmentedControl *switcher_;

  
  GMSMapView *mapView_;
  NSMutableArray *redMarkers_;
  NSMutableArray *greenMarkers_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                          longitude:151.20
                                                               zoom:6];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  self.view = mapView_;
  
  NSArray *colors = @[@"all", @"none", @"red", @"green"];
  
  switcher_ = [[UISegmentedControl alloc] initWithItems:colors];
  switcher_.selectedSegmentIndex = 0;
  switcher_.segmentedControlStyle = UISegmentedControlStyleBar;
  switcher_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  switcher_.frame = CGRectMake(0, 0, 300, switcher_.frame.size.height);
  self.navigationItem.titleView = switcher_;

  // Listen to touch events on the UISegmentedControl.
  [switcher_ addTarget:self action:@selector(didChangeSwitcher)
      forControlEvents:UIControlEventValueChanged];
  
  [self performSelector:@selector(addMarkers) withObject:nil afterDelay:1];
}

- (void)addMarkers {
  redMarkers_ = [[NSMutableArray alloc] init];
  greenMarkers_ = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 10; ++i) {
    CLLocationCoordinate2D position = [self getRandomPosition];
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    UIColor *color;
    if (i % 2 == 0) {
      // Green
      color = [UIColor colorWithHue:.2 saturation:1.f brightness:1.f alpha:1.0f];
      [greenMarkers_ addObject:marker];
    } else {
      color = [UIColor colorWithHue:1. saturation:1.f brightness:1.f alpha:1.0f];
      [redMarkers_ addObject:marker];
    }
    marker.icon = [GMSMarker markerImageWithColor:color];
    marker.map = mapView_;
  }
}

- (void)didChangeSwitcher {
  NSString *color = [switcher_ titleForSegmentAtIndex:switcher_.selectedSegmentIndex];  
  for (int i = 0; i < [redMarkers_ count]; i++) {
    GMSMarker *marker = [redMarkers_ objectAtIndex:i];
    
    if ([color isEqual:@"red"] || [color isEqual:@"all"]) {
      marker.map = mapView_;
    } else {
      marker.map = nil;
    }
  }
  
  for (int i = 0; i < [greenMarkers_ count]; i++) {
    GMSMarker *marker = [greenMarkers_ objectAtIndex:i];
    
    if ([color isEqual:@"green"] || [color isEqual:@"all"]) {
      marker.map = mapView_;
    } else {
      marker.map = nil;
    }
  }
}

- (CLLocationCoordinate2D)getRandomPosition {
  GMSVisibleRegion region = [mapView_.projection visibleRegion];
  GMSCoordinateBounds *bounds =
  [[GMSCoordinateBounds alloc] initWithRegion:region];
  
  CLLocationDegrees latitude = bounds.southWest.latitude +
  randf() * (bounds.northEast.latitude - bounds.southWest.latitude);
  
  // If the visible region crosses the antimeridian (the right-most point is
  // "smaller" than the left-most point), adjust the longitude accordingly.
  BOOL offset = (bounds.northEast.longitude < bounds.southWest.longitude);
  CLLocationDegrees longitude = bounds.southWest.longitude + randf() *
  (bounds.northEast.longitude - bounds.southWest.longitude + (offset ?
                                                              360 : 0));
  if (longitude > 180.f) {
    longitude -= 360.f;
  }
  
  CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
  return position;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static CGFloat randf() {
  return (((float)arc4random()/0x100000000)*1.0f);
}

@end
