//
//  EQTableViewController.h
//  EarthquakeTable
//
//  Created by Mano Marks on 3/4/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EQTableViewController : UITableViewController
@property (nonatomic, strong) IBOutlet UILabel *quakeLabel;
@property (nonatomic, strong) NSString *quakeName;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSData* data;
@property (nonatomic, strong) NSDictionary* json;

@end
