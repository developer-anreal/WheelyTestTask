//
// HMItem.h
//

#import <Foundation/Foundation.h>

@interface HMItem : NSObject

@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemText;

- (instancetype)initItemWithDictionary:(NSDictionary *)dictionary;

@end