//
//  WeatherVC.m
//  Demo
//
//  Created by Justin Raney on 10/14/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//

#import "WeatherVC.h"

@interface WeatherVC ()

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getWeatherButton;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end

@implementation WeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.zipCodeField resignFirstResponder];
	[self getWeather];
	
	return YES;
}

- (IBAction)getWeatherButtonPressed:(id)sender {
	[self.zipCodeField resignFirstResponder];
	[self getWeather];
}

- (void)getWeather {
	self.zipCodeLabel.text = [NSString stringWithFormat:@"Current weather in %@ is:", self.zipCodeField.text];
	
	// retrieve weather from http://api.openweathermap.org/data/2.5/weather?q=<query>
	
	// build url for request
	NSString *weatherRequestUrlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,ky&units=imperial", self.zipCodeField.text];
	NSURL *weatherRequestUrl = [NSURL URLWithString:weatherRequestUrlString];
	// get data from url
	NSData *weatherData = [[NSData alloc] initWithContentsOfURL:weatherRequestUrl];
	
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
		NSNumber *humidity = [mainDictionary objectForKey:@"humidity"];
		NSString *locationName = [weatherResponseObject objectForKey:@"name"];
		
		self.weatherLabel.text = [NSString stringWithFormat:@"\
							 %@\n\
							 %@\n\
							 %@ degrees F\n\
							 %@ %% humidity\n",
							 locationName, description, temp, humidity];
	}
	
	
	
}


@end
