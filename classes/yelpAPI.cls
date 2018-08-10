public with sharing class yelpAPI {

	public static string BASE_URL = 'http://api.yelp.com/v2/';
	public static string CONSUMER_KEY = '';
	public static string CONSUMER_SECRET = '';
	public static string TOKEN = '';
	public static string TOKEN_SECRET = '';

	public static businessWrapper businessGet(String name){
		name = 'yelp san francisco';
		String PATH = 'business/';
		httpResponse res = callYelp(BASE_URL+PATH+name.toLowerCase().replace(' ','-'),'GET');
		businessWrapper w = (businessWrapper)JSON.deserialize(res.getBody(),businessWrapper.class);
		return w;
	}

//	public static void searchYelp(String name){
//		String PATH = '';
//		httpResponse res = callYelp('','');
//	}

	public static httpResponse callYelp(String endpoint, String method){
		String timestamp = string.valueof(system.now().getTime()/1000);
		String nonce = string.valueOf(Crypto.getRandomLong());
		PageReference toSignURL = new PageReference('http://www.toreplace.com');
		toSignURL.getParameters().put('oauth_consumer_key',CONSUMER_KEY);
		toSignURL.getParameters().put('oauth_token',TOKEN);
		toSignURL.getParameters().put('oauth_signature_method','hmac-sha1');
		toSignURL.getParameters().put('oauth_timestamp',timestamp);
		toSignURL.getParameters().put('oauth_nonce',nonce);

		String signatureBaseString = method.toUpperCase() + '&' + encodingUtil.urlEncode(endpoint, 'UTF-8') + '&' + toSignURL.getURL().subStringAfter('?');
		String key = encodingUtil.urlEncode(CONSUMER_SECRET, 'UTF-8') + '&' + encodingUtil.urlEncode(token, 'UTF-8');
		String signature = encodingUtil.urlEncode( encodingUtil.base64Encode( crypto.generateMac('hmacSHA1', blob.valueOf(signatureBaseString), blob.valueOf(key) ) ), 'UTF-8' );

		httpRequest req = new httpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');
		String oAuth = 'OAuth ';
		for ( String p : toSignURL.getParameters().keySet() ){
			oAuth += p + '="' + toSignURL.getParameters().get(p) + '", ';
		}
		oAuth += 'oauth_signature="' + signature + '"';

		req.setHeader('Authorization',oAUth);
		httpResponse res;
		if ( test.isRunningTest() ){
			res = new httpResponse();
			res.setStatusCode(200);
			res.setBody(businessAPIResponse);
		} else {
			res = new http().send(req);
		}
		return res;
	}

	public class businessWrapper {
		public string id {get;set;} 					//	Yelp ID for this business
		public boolean is_claimed {get;set;} 			//	Whether business has been claimed by a business owner
		public boolean is_closed {get;set;}				//	Whether business has been (permanently) closed
		public string name {get;set;} 					//	Name of this business
		public string image_url {get;set;} 				// 	URL of photo for this business
		public string url {get;set;} 					//	URL for business page on Yelp
		public string mobile_url {get;set;} 			//	URL for mobile business page on Yelp
		public string phone {get;set;} 					//	Phone number for this business with international dialing code (e.g. +442079460000)
		public string display_phone	{get;set;}			//	Phone number for this business formatted for display
		public integer review_count	{get;set;}			//	Number of reviews for this business
		public list<list<string>> categories {get;set;} //	list	Provides a list of category name, alias pairs that this business is associated with. For example,  [["Local Flavor", "localflavor"], ["Active Life", "active"], ["Mass Media", "massmedia"]]  The alias is provided so you can search with the category_filter.
		public decimal distance	{get;set;}				// 	Distance that business is from search location in meters, if a latitude/longitude is specified.
		public decimal rating {get;set;}				//	Rating for this business (value ranges from 1, 1.5, ... 4.5, 5)
		public string rating_img_url {get;set;} 		//	URL to star rating image for this business (size = 84x17)
		public string rating_img_url_small {get;set;}	//	URL to small version of rating image for this business (size = 50x10)
		public string rating_img_url_large {get;set;}	//	URL to large version of rating image for this business (size = 166x30)
		public string snippet_text {get;set;} 			//	Snippet text associated with this business
		public string snippet_image_url {get;set;} 		//	URL of snippet image associated with this business
		public locationWrapper location {get;set;}
		public List<dealWrapper> deals {get;set;}
		public List<giftCertificateWrapper> gift_certificates {get;set;} //	list	Gift certificate info for this business (optional: this field is present only if there are gift certificates available)
		public string menu_provider	{get;set;}			// 	Provider of the menu for this business
		public decimal menu_date_updated {get;set;}		//	number	Last time this menu was updated on Yelp (Unix timestamp)
		public List<reviewWrapper> reviews {get;set;}	//	List of up to 3 review snippets for the business
	}

	public class locationWrapper {
		public List<String> address {get;set;}			//	Address for this business. Only includes address fields.
		public List<String> display_address {get;set;}	//	Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
		public string city {get;set;} 					//	City for this business
		public string state_code {get;set;} 			//	ISO 3166-2 state code for this business
		public string postal_code {get;set;} 			//	Postal code for this business
		public string country_code {get;set;} 			//	string	ISO 3166-1 country code for this business
		public string cross_streets {get;set;} 			//	Cross streets for this business
		public list<String> neighborhoods {get;set;}	//	List that provides neighborhood(s) information for business
	}

	public class dealWrapper {
		public string id {get;set;} 					//	Deal identifier
		public string title	{get;set;}					//	Deal title
		public string url {get;set;}					//	Deal url
		public string image_url {get;set;}				//	Deal image url
		public string currency_code {get;set;}			//	ISO_4217 Currency Code
		public integer time_start {get;set;}			//	Deal start time (Unix timestamp)
		public integer time_end {get;set;}				//	Deal end time (optional: this field is present only if the Deal ends)
		public boolean is_popular {get;set;}			//	Whether the Deal is popular (optional: this field is present only if true)
		public string what_you_get {get;set;}			//	Additional details for the Deal, separated by newlines
		public string important_restrictions {get;set;}	//	Important restrictions for the Deal, separated by newlines
		public string additional_restrictions {get;set;}//	Deal additional restrictions
		public list<optionWrapper> options {get;set;}
	}

	public class optionWrapper {
		public string title {get;set;} //	Deal option title
		public string purchase_url {get;set;} //	Deal option url for purchase
		public integer price {get;set;} //	number	Deal option price (in cents)
		public string formatted_price {get;set;} //		Deal option price (formatted, e.g. "$6")
		public integer original_price {get;set;} //	Deal option original price (in cents)
		public string formatted_original_price {get;set;} //	Deal option original price (formatted, e.g. "$12")
		public boolean is_quantity_limited {get;set;} //	Whether the deal option is limited or unlimited
		public integer remaining_count {get;set;} //	The remaining deal options available for purchase (optional: this field is only present if the deal is limited)
	}

	public class giftCertificateWrapper {
		public string id {get;set;}						//	Gift certificate identifier
		public string url {get;set;}					//	Gift certificate landing page url
		public string image_url {get;set;}				//	Gift certificate image url
		public string currency_code {get;set;}			//	ISO_4217 Currency Code
		public string unused_balances {get;set;}		// Whether unused balances are returned as cash or store credit
		public List<optionWrapper> options {get;set;}	//	Gift certificate options
	}

	public class reviewWrapper {
		public string id {get;set;} //	string	Review identifier
		public decimal rating {get;set;} //	number	Rating from 1-5
		public string rating_image_url {get;set;} //	url	URL to star rating image for this business (size = 84x17)
		public string rating_image_small_url {get;set;} //	url	URL to small version of rating image for this business (size = 50x10)
		public string rating_image_large_url {get;set;} //	url	URL to large version of rating image for this business (size = 166x30)
		public string excerpt {get;set;} //	string	Review excerpt
		public integer time_created {get;set;} //	number	Time created (Unix timestamp)
		public userWrapper user	{get;set;} //dict	User who wrote the review
	}

	public class userWrapper {
		public string id {get;set;} //	User identifier
		public string image_url {get;set;} //	User profile image url
		public string name {get;set;} //	User name
	}

	public static String businessAPIResponse = '{"categories": [ [ "Indian", "indpak" ], [ "Pakistani", "pakistani" ] ], "deals": [ { "currency_code": "USD", "image_url": "http://s3-media4.ak.yelpcdn.com/dphoto/ShQGf5qi-52HwPiKyZTZ3w/m.jpg", "options": [ { "formatted_original_price": "$20", "formatted_price": "$10", "is_quantity_limited": true, "original_price": 2000, "price": 1000, "purchase_url": "http://www.yelp.com/deal/cC24ccQGIH8mowfu5Vbe0Q/view", "remaining_count": 36, "title": "$10 for $20 voucher" } ], "url": "http://www.yelp.com/biz/urban-curry-san-francisco?deal=1", "is_popular": true, "time_start": 1317414369, "title": "$10 for $20 voucher" } ], "display_phone": "+1-415-677-9744", "gift_certificates": [ { "currency_code": "USD", "image_url": "http://s3-media4.ak.yelpcdn.com/bphoto/Hv5vsWpqeaUKepr9nffJnw/m.jpg", "options": [ { "formatted_price": "$25", "price": 2500 }, { "formatted_price": "$50", "price": 5000 } ], "url": "http://www.yelp.com/gift-certificates/some-donut-place-pasadena", "id": "ZZy5EwrI3wyHw8y54jZruA", "unused_balances": "CREDIT" } ], "id": "urban-curry-san-francisco", "image_url": "http://s3-media4.ak.yelpcdn.com/bphoto/Hv5vsWpqeaUKepr9nffJnw/ms.jpg", "is_claimed": true, "is_closed": false, "location": { "address": [ "523 Broadway" ], "city": "San Francisco", "country_code": "US", "cross_streets": "Kearny St & Romolo Pl", "display_address": [ "523 Broadway", "(b/t Kearny St & Romolo Pl)", "North Beach/Telegraph Hill", "San Francisco, CA 94133" ], "neighborhoods": [ "North Beach/Telegraph Hill" ], "postal_code": "94133", "state_code": "CA" }, "mobile_url": "http://m.yelp.com/biz/EFjaNaqg2foSIM--mML49g", "name": "Urban Curry", "phone": "4156779744", "rating": 4.0, "rating_img_url": "http://media2.ak.yelpcdn.com/static/201012164084228337/img/ico/stars/stars_4.png", "rating_img_url_large": "http://media4.ak.yelpcdn.com/static/20101216169592178/img/ico/stars/stars_large_4.png", "rating_img_url_small": "http://media2.ak.yelpcdn.com/static/20101216418129184/img/ico/stars/stars_small_4.png", "review_count": 227, "reviews": [ { "excerpt": "I gave this restaurant two stars just because of the extremely quick delivery and friendly delivery guy, but the food was nothing I would order again....", "id": "-RDZxLTUExM9Q02x4hZmHg", "rating": 2, "rating_image_large_url": "http://media2.ak.yelpcdn.com/static/20101216220207235/img/ico/stars/stars_large_2.png", "rating_image_small_url": "http://media4.ak.yelpcdn.com/static/201012164278297776/img/ico/stars/stars_small_2.png", "rating_image_url": "http://media4.ak.yelpcdn.com/static/201012163489049252/img/ico/stars/stars_2.png", "time_created": 1317939620, "user": { "id": "AUEDVbP9XNlOcgYOAfR8yg", "image_url": "http://s3-media2.ak.yelpcdn.com/photo/0CX0RSoz8NkPlOTo7Ckqdg/ms.jpg", "name": "Holly E." } } ], "snippet_image_url": "http://s3-media1.ak.yelpcdn.com/photo/39c5Vpe0cFCtZ-rmgAr3YQ/ms.jpg", "snippet_text": "Shame on me for taking so long to update a review. I have been there several times now and love it everytime. Devour: My fav the Lamb Tikka Masala, my...", "url": "http://www.yelp.com/biz/urban-curry-san-francisco", "menu_provider": "yelp", "menu_date_updated": 1317414369 }';

}
