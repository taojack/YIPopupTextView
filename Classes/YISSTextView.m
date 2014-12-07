//
//  YISSTextView.m
//  SSToolkit
//
//  Created by Sam Soffes on 8/18/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "YISSTextView.h"

@interface YISSTextView (PrivateMethods)
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end


@implementation YISSTextView

#pragma mark -
#pragma mark Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

- (void)setText:(NSString *)string {
	[super setText:string];
	[self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}
    _placeholder = string;
	
	[self _updateShouldDrawPlaceholder];
}


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark -
#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
		
		self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
		_shouldDrawPlaceholder = NO;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	if (_shouldDrawPlaceholder) {
		[_placeholderColor set];
		CGRect drawInRect = CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f);
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
		paragraphStyle.alignment = NSTextAlignmentLeft;
		NSDictionary *attributes = @{ NSFontAttributeName: self.font,
                                      NSForegroundColorAttributeName: self.placeholderColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
		[_placeholder drawInRect:drawInRect withAttributes:attributes];
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)_updateShouldDrawPlaceholder {
	BOOL prev = _shouldDrawPlaceholder;
	_shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
	
	if (prev != _shouldDrawPlaceholder) {
		[self setNeedsDisplay];
	}
}


- (void)_textChanged:(NSNotification *)notificaiton {
	[self _updateShouldDrawPlaceholder];	
}

@end
