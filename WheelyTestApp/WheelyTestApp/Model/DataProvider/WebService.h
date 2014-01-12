//
// WebService.h
//

#import <Foundation/Foundation.h>

typedef void(^LoadDataCompleteBlock)(NSError *, NSData *);

@interface WebService : NSObject

- (id)initWithWebServiceUrl:(NSString *)webUrl;
- (void)loadDataWithCompletion:(LoadDataCompleteBlock)completion;
- (NSData *)loadDataWithError:(NSError *)error;

@property (strong) NSString *webUrl;

@end