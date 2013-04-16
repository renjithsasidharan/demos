//
//  GCViewController.h
//  GeocodingAPISample
//
//  Created by Mano Marks on 4/11/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGeocodingService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GCViewController : UIViewController <UITextFieldDelegate>
{
    
    __weak IBOutlet GMSMapView *mapView;
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UITextField *addressField;
    
}
- (IBAction)geocode:(id)sender;
- (void)addMarker;
@property (strong,nonatomic) GCGeocodingService *gs;
@end
