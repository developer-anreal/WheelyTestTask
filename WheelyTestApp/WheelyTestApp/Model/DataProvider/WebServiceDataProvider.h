//
// WebServiceDataProvider.h
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"

@interface WebServiceDataProvider : DataProvider

- (id)initWithWebServiceUrl:(NSString *)webUrl;

@property (strong) NSString *webUrl;

@end