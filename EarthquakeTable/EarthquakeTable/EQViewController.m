//
//  EQViewController.m
//  EarthquakeTable
//
//  Created by Mano Marks on 2/28/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "EQViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface EQViewController ()

@end

@implementation EQViewController
    @synthesize options;    
    GMSMapView *mapView_;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapView_ addMarkerWithOptions:options];
    CLLocationDegrees latitude = options.position.latitude;
    CLLocationDegrees longitude = options.position.longitude;
    GMSCameraPosition *cameraNew = [GMSCameraPosition cameraWithLatitude:latitude
                                                               longitude:longitude
                                                                    zoom:6];
    mapView_.camera = cameraNew;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:0
                                                                 zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = NO;
    self.view = mapView_;

    }


@end
