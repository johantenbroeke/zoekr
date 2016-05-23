# Zoekr
#### A Simple Flickr search experiment.

This app allows a user to search Flickr for photos with specific words. The results are displayed in an endless scrolling collectionView. Tapping a thumbnail will display the large image in a modal view.

#### collection view
![collection-view](https://raw.githubusercontent.com/johantenbroeke/zoekr/master/collection-view.png "collection-view")

#### image view
![image-view](https://raw.githubusercontent.com/johantenbroeke/zoekr/master/image-view.png "image-view")


#### Dependencies

This project uses cococa-pods. See the podfile.

FlickrKit for easy consuming of the Flickr API: [https://github.com/devedup/FlickrKit](https://github.com/devedup/FlickrKit)

SDWebImage for async image loading: [https://github.com/rs/SDWebImage](https://github.com/rs/SDWebImage)

#How to build

1. Clone this repo, the cocoapods are committed for convenience. 
2. Open the workspace in Xcode `zoekr.xcworkspace` (Do not open the `zoekr.xcodeproj`)
3. Now edit the `settings.h` and add your Flickr API key and secret. You can get one [here](https://www.flickr.com/services/api/misc.api_keys.html).


		#ifndef settings_h
		#define settings_h

		#define FLICKR_API_KEY @"<YOUR_FLICKR_API_KEY>"
		#define FLICKR_API_SECRET @"<YOUR_FLICKR_API_SECRET>"

		#define FLICKR_RESULT_NUM_IMAGES_PER_PAGE 100

		#endif /* settings_h */
		
4. You should now be able to build the app.