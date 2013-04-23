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
    SEL sel = @selector(addMarker);
    //[self performSelector:@selector(addMarker)];
    
    NSLog(@"%@",NSStringFromSelector(sel));
    [gs geocodeAddress:addressField.text withCallback:@selector(addMarker) withDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)addMarker{
    
    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    CLLocationCoordinate2D geolocation = CLLocationCoordinate2DMake(lat,lng);
    marker.position = geolocation;
    marker.title = [gs.geocode objectForKey:@"address"];
    
    marker.map = mapView;
    
    GMSCameraUpdate *geoLocateCam = [GMSCameraUpdate setTarget:geolocation zoom:10.0];
    [mapView animateWithCameraUpdate:geoLocateCam];

}
@end
