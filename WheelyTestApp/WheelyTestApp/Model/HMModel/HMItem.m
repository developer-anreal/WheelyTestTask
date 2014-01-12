//
// HMItem.m
//

#import "HMItem.h"

@implementation HMItem {

}

- (instancetype)initItemWithDictionary:(NSDictionary *)dictionary {
  if (self = [super init]) {
    self.itemTitle = dictionary[@"title"];
    self.itemText = dictionary[@"text"];
    self.itemId = [NSString stringWithFormat:@"%lld", [dictionary[@"id"] longLongValue]];
  }

  return self;
}

@end