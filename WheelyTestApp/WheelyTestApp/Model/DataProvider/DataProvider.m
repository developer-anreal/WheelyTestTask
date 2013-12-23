//
// DataProvider
//

#import "DataProvider.h"

@implementation DataProvider

- (NSData *)loadDataWithError:(NSError **)error {
  return nil;
}

- (void)loadDataWithCompletion:(LoadDataCompleteBlock)completion {

}

- (id)init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

@end