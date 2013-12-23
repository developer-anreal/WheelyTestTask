//
// UILabel(Additions)
//

@implementation UILabel (Additions)

- (void)resizeToStretchMaxHeight:(float)maxHeight {
  float height = [self expectedHeight:maxHeight];
  CGRect newFrame = [self frame];
  newFrame.size.height = floorf(height) + 1;
  [self setFrame:newFrame];
}

- (void)resizeToStretch {
  [self resizeToStretchMaxHeight:CGFLOAT_MAX];
}

- (void)resizeToFill {
  float height = [self expectedHeight];
  float width = [self expectedWidth];
  CGRect newFrame = [self frame];
  newFrame.size.height = floorf(height) + 1;
  newFrame.size.width = floorf(width) + 1;
  [self setFrame:newFrame];
}

- (float)expectedHeight {
  return [self expectedHeight:CGFLOAT_MAX];
}

- (float)expectedHeight:(float)maxHeight {
  CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, maxHeight);
  
  CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:[self lineBreakMode]];
  return floorf(expectedLabelSize.height);
}

- (float)expectedWidth {
  CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, self.frame.size.width);

  CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:[self lineBreakMode]];
  return floorf(expectedLabelSize.width);
}

@end