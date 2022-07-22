
#include <glog/logging.h>

//[[Rcpp::export]]
int rcpp_glog_test()
{

	FLAGS_logtostderr = 1;

	// Initialize Google’s logging library.
	google::InitGoogleLogging("rcpp_glog");

	// test with setting a value for num_cookies
	int num_cookies = 3;

	// ...
	LOG(INFO) << "Found " << num_cookies << " cookies";

	return 0;

}

// output - Found 3 cookies
