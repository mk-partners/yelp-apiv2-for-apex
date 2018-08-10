@isTest
private class yelpAPI_Tests {

	static testMethod void yelpAPI_UnitTest() {
		test.startTest();
			yelpAPI.businessGet('MK Partners');
			yelpAPI.businessWrapper w = (yelpAPI.businessWrapper)JSON.deserialize(yelpAPI.businessAPIResponse,yelpAPI.businessWrapper.class);
			system.assert(w.id == 'urban-curry-san-francisco');

			yelpAPI.locationWrapper lw = new yelpAPI.locationWrapper();
			lw.address = new List<String>();
			lw.display_address = new List<String>();
			lw.city = '';
			lw.state_code = '';
			lw.postal_code = '';
			lw.country_code = '';
			lw.cross_streets = '';
			lw.neighborhoods = new List<String>();

			yelpAPI.userWrapper uw = new yelpAPI.userWrapper();
			uw.id = '';
			uw.image_url = '';
			uw.name = '';
	 			
			yelpAPI.reviewWrapper rw = new yelpAPI.reviewWrapper();
			rw.id = '';
			rw.rating_image_url = '';
			rw.rating_image_small_url = '';
			rw.rating_image_large_url = '';
			rw.excerpt = '';
			rw.time_created = 1;
			rw.rating  = 1.1;
			rw.user = uw;

			yelpAPI.businessWrapper testWrapper = new yelpAPI.businessWrapper();
			testWrapper.categories = new List<list<String>>();
			testWrapper.categories.add(new List<String>{'Indian', 'indpak'});
			testWrapper.deals = new List<yelpAPI.dealWrapper>();
				yelpAPI.dealWrapper dw = new yelpAPI.dealWrapper();
				dw.currency_code = 'USD';
				dw.image_url = 'http://s3-media4.ak.yelpcdn.com/dphoto/ShQGf5qi-52HwPiKyZTZ3w/m.jpg';
				dw.options = new List<yelpAPI.optionWrapper>();
					yelpAPI.optionWrapper ow = new yelpAPI.optionWrapper();
					ow.formatted_original_price = '$20';
					ow.formatted_price = '$10';
					ow.is_quantity_limited = true;
					ow.original_price = 2000;
					ow.price = 1000;
					ow.purchase_url = 'http://www.yelp.com/deal/cC24ccQGIH8mowfu5Vbe0Q/view';
					ow.remaining_count = 36;
					ow.title = '$10 for $20 voucher';
				dw.options.add(ow);
				dw.url = 'http://www.yelp.com/biz/urban-curry-san-francisco?deal=1';
				dw.is_popular = true;
				dw.time_start = 1317414369;
				dw.time_end = 1317414369;
				dw.title = '$10 for $20 voucher';
			testWrapper.display_phone = '+1-415-677-9744';
			testWrapper.gift_certificates = new List<yelpAPI.giftCertificateWrapper>();
				yelpAPI.giftCertificateWrapper gw = new yelpAPI.giftCertificateWrapper();
				gw.currency_code = 'USD';
				gw.id = 'test';
				gw.image_url = 'http://s3-media4.ak.yelpcdn.com/bphoto/Hv5vsWpqeaUKepr9nffJnw/m.jpg';
				gw.options = new List<yelpAPI.optionWrapper>();
				gw.unused_balances  = 
				gw.url = 'http://s3-media4.ak.yelpcdn.com/bphoto/Hv5vsWpqeaUKepr9nffJnw/m.jpg';
			testWrapper.deals.add(dw);
			testWrapper.display_phone = '(818) 760-8285';
			testWrapper.distance = 1.1;			
		test.stopTest();
	}

	
}