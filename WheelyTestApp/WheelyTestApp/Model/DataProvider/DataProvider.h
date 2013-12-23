//
// DataProvider
//

#import <Foundation/Foundation.h>

typedef void(^LoadDataCompleteBlock)(NSError *, NSData *);

@interface DataProvider : NSObject

- (NSData *)loadDataWithError:(NSError **)error;
- (void)loadDataWithCompletion:(LoadDataCompleteBlock)completion;

@end