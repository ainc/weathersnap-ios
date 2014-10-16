//
//  MapVC.m
//  Demo
//
//  Created by Justin Raney on 10/14/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MapVC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// request user's location
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager requestWhenInUseAuthorization];
	
	[self setupMap];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupMap {
	
	// retrieve weather for a list of locations
	NSMutableArray *locations = [[NSMutableArray alloc] init];
	[locations addObject:@"40507,KY"];
	
	for (NSString *locationString in locations) {
		
		// build url for request
		NSString *weatherRequestUrlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&units=imperial", locationString];
		NSURL *weatherRequestUrl = [NSURL URLWithString:weatherRequestUrlString];
		// get data from url
		NSError *error = nil;
		NSData *weatherData = [[NSData alloc] initWithContentsOfURL:weatherRequestUrl options:kNilOptions error:&error];
		
		if (error != nil) {
			// handle error
			NSLog(@"%@", error.description);
		} else {
			
			// parse data into dictionary
			NSError *error;
			NSDictionary *weatherResponseObject = [NSJSONSerialization JSONObjectWithData:weatherData options:kNilOptions error:&error];
			
			// further parse weather data into what we are interested in
			NSArray *weather = [weatherResponseObject objectForKey:@"weather"];
			if (weather.count > 0) {
				NSDictionary *weatherDictionary = [weather firstObject];
				NSString *description = [weatherDictionary objectForKey:@"description"];
				NSDictionary *mainDictionary = [weatherResponseObject objectForKey:@"main"];
				NSNumber *temp = [mainDictionary objectForKey:@"temp"];
				NSString *locationName = [weatherResponseObject objectForKey:@"name"];
				
				// get lat/lon from weather dictionary
				NSDictionary *coordinateDictionary = [weatherResponseObject objectForKey:@"coord"];
				CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[coordinateDictionary objectForKey:@"lat"] floatValue], [[coordinateDictionary objectForKey:@"lon"] floatValue]);
				
				// create pin
				MKPointAnnotation *weatherPin = [[MKPointAnnotation alloc] init];
				weatherPin.coordinate = coordinate;
				weatherPin.title = [NSString stringWithFormat:@"%@ - %@°F", locationName, temp];
				weatherPin.subtitle = description;
				
				// add pin to map
				[self.mapView addAnnotation:weatherPin];
				
			}
		}
	}
	
	// set map region
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(38.05, -84.5), 15000, 15000);
	[self.mapView setRegion:region animated:YES];
	
	[self.activityIndicator stopAnimating];
	
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	// if user agreed to using their location, show it on map
	if (status == kCLAuthorizationStatusAuthorizedAlways ||
		status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		self.mapView.showsUserLocation = YES;
	}
}



@end
