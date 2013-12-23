//
// DataProviderFactory
//

#import <Foundation/Foundation.h>

#define WEBSERVICE_URL @"http://crazy-dev.wheely.com"

@class DataProvider;

typedef NS_ENUM(NSInteger, DataProviderType) {
  WebServiceDataProviderType
};

@interface DataProviderFactory : NSObject

+ (DataProvider *)dataProviderByType:(DataProviderType)type;

@end