//
//  NSShadow+Additions.m
//  MyStyledView
//
// http://www.seanpatrickobrien.com/journal/posts/3
//  BSD License
//

#import "NSShadow+Additions.h"


@implementation NSShadow (Additions)

+ (id)shadowWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur {
	
	return [[self alloc] initWithColor:color offset:offset blurRadius:blur];
}

- (id)initWithColor:(NSColor *)color offset:(NSSize)offset blurRadius:(CGFloat)blur {
	
	self = [self init];
	
	if (self != nil) {
		self.shadowColor = color;
		self.shadowOffset = offset;
		self.shadowBlurRadius = blur;
	}
	
	return self;
}

@end
