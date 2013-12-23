//
// ItemWrapperProtocol.h
//

#import <Foundation/Foundation.h>
#import "ObjectWrapperProtocol.h"

@protocol ItemWrapperProtocol<ObjectWrapperProtocol>

@required
- (NSString *)itemId;
- (void)setItemId:(NSString *)itemId;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)text;
- (void)setText:(NSString *)text;

@end