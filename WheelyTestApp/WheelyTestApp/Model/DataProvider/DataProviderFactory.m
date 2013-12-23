//
// DataProviderFactory
//

#import "DataProviderFactory.h"
#import "DataProvider.h"
#import "WebServiceDataProvider.h"

@implementation DataProviderFactory {
}

+ (DataProvider *)dataProviderByType:(DataProviderType)type {
  DataProvider *dataProvider = nil;
  switch (type) {
    case WebServiceDataProviderType:
      dataProvider = [[WebServiceDataProvider alloc] initWithWebServiceUrl:WEBSERVICE_URL];
      break;
    default:
      dataProvider = [[DataProvider alloc] init];
      break;
  }
  return dataProvider;
}

@end