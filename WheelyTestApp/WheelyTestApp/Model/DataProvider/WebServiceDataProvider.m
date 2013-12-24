//
// WebServiceDataProvider.m
//

#import "WebServiceDataProvider.h"

@implementation WebServiceDataProvider {

}

- (id)initWithWebServiceUrl:(NSString *)webUrl {
  if (self = [super init]) {
    self.webUrl = webUrl;
  }
  
  return self;
}

- (void)loadDataWithCompletion:(LoadDataCompleteBlock)completion {
  NSURL *url = [NSURL URLWithString:self.webUrl];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"GET";
  
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           completion(connectionError, data);
                         }];
}

@end