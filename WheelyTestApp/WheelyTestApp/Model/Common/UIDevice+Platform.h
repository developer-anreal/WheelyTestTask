//
//  UIDevice+Platform.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define scaleDeviceHeight 1.19

@interface UIDevice (Platform)

- (NSString *)platform;
- (NSString *)platformString;
- (NSInteger)platformRAM;

@end





