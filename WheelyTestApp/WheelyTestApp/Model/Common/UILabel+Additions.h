//
// UILabel(Additions)
//

#import <Foundation/Foundation.h>

@interface UILabel (Additions)

- (float)expectedHeight;
- (float)expectedHeight:(float)maxHeight;
- (float)expectedWidth;
- (void)resizeToStretch;
- (void)resizeToStretchMaxHeight:(float)maxHeight;
- (void)resizeToFill;

@end