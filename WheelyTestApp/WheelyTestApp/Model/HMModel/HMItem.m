//
// HMItem.m
//

#import "HMItem.h"

@implementation HMItem {
  NSString *itemTitle;
  NSString *itemId;
  NSString *itemText;
}

- (NSString *)itemId {
  return itemId;
}

- (void)setItemId:(NSString *)itemId_ {
  if ([itemId isEqualToString:itemId_]) return;
  
  itemId = [[NSString alloc] initWithString:itemId_];
}

- (NSString *)title {
  return itemTitle;
}

- (void)setTitle:(NSString *)title {
  if ([itemTitle isEqualToString:title]) return;
  
  itemTitle = [[NSString alloc] initWithString:title];
}

- (NSString *)text {
  return itemText;
}

- (void)setText:(NSString *)text {
  if ([itemText isEqualToString:text]) return;
  
  itemText = [[NSString alloc] initWithString:text];
}

@end