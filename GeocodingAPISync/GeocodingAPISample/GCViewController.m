//
//  GCViewController.m
//  GeocodingAPISample
//
//  Created by Mano Marks on 4/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "GCViewController.h"
#import "GCGeocodingService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GCViewController ()

@end

@implementation GCViewController

@synthesize gs;

- (void)loadView
{
    [super loadView];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
                 longitude:0.0                                                zoom:2];
    
    [mapView setCamera:camera];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    gs = [[GCGeocodingService alloc] init];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)geocode:(id)sender {
    [addressField resignFirstResponder];
    [gs geocodeAddress:addressField.text];
    [self addMarker];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)addMarker{
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    GMSMarkerOptions *options = [[GMSMarkerOptions alloc] init];
    options.position = CLLocationCoordinate2DMake(lat, lng);
    options.title = [gs.geocode objectForKey:@"address"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat                                                      longitude:lng                                                        zoom:10];
    
    [mapView setCamera:camera];
    [mapView addMarkerWithOptions:options];
}
@end
