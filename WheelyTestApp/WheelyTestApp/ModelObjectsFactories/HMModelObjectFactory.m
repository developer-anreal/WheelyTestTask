//
// HMModelObjectFactory.m
//

#import "HMModelObjectFactory.h"
#import "HMItem.h"

@implementation HMModelObjectFactory {

}

+ (instancetype)instance {
  static HMModelObjectFactory *_instance = nil;
  static dispatch_once_t p;
  dispatch_once(&p, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}


- (id<ItemWrapperProtocol>)createItemFromData:(id)itemData {
  NSDictionary *params = (NSDictionary *)itemData;
  if (!params) return nil;
  
  HMItem *item = [[HMItem alloc] init];
  item.title = params[@"title"];
  item.text = params[@"text"];
  item.itemId = [NSString stringWithFormat:@"%lld", [params[@"id"] longLongValue]];
  
  return item;
}

@end