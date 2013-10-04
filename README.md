GeocodingQueue
==============

This class is great for reverse geocoding multiple MKAnnotations in a background thread. 
It has a queue that you add the MKAnnotations to, and once the MKAnnotations are reverse geocoded, they are removed.
The class is a singleton, with one method that reverse geocodes all of the MKAnnotations. Before you call this method,
make sure that the operation isn't alread running, so your program doesn't crash.

Here is one example of implementing this class:

		- (IBAction)fingerPressed:(UILongPressGestureRecognizer *)recognizer
		{
		    CGPoit touchPoint = [recognizer locationInView:self.mapView];
		    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateInView:self.mapView];
		    
		    if ([recognizer state] == UIGestureRecognizerStateBegan)
		    {
						//use your custom class that conforms to the MKAnnotation protocol
						MapPin *pin = [[MapPin alloc] init];
						pin.coordinate = coordinate;
						//this title will only show if the user has a bad connection, and will change once the coordinare is reverse geocoded
						pin.title = @"Temporary title";
				
						[[GeocodingSingleton sharedGeocoder].geocodingQueue addObject:pin];
						if (![GeocodingSingleton sharedGeocoder].isOperationRunning)
						{
								[[GeocodingSingleton sharedGeocoder] performOperations];
						}
		}

This example reverse geocodes the pin's title in a background thread. In my code, the class that conforms to the MKAnnotation property
is called 'MapPoint', but you can swap it out for your own class.
