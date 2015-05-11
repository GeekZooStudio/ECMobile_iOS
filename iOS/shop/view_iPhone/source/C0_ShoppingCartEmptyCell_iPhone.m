//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/ 
//
//	Copyright (c) 2012 BEE creators
//	http://www.whatsbug.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "C0_ShoppingCartEmptyCell_iPhone.h"

#pragma mark -

@implementation C0_ShoppingCartEmptyCell_iPhone
{
    BeeUIImageView *    _imageView;
    BeeUILabel *        _label;
    BeeUILabel *        _sublabel;
}

- (void)load
{
    _imageView = [[BeeUIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping_cart_empty_cart_icon.png"]];
    [self addSubview:_imageView];
    
    _label = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont boldSystemFontOfSize:20];
    _label.textColor = [UIColor darkGrayColor];
	_label.lineBreakMode = UILineBreakModeWordWrap;
	_label.numberOfLines = 2;
    _label.text = __TEXT(@"shopcar_nothing");
    [self addSubview:_label];
    _sublabel = [[BeeUILabel alloc] initWithFrame:CGRectZero];
    _sublabel.font = [UIFont boldSystemFontOfSize:14];
    _sublabel.textColor = [UIColor grayColor];
    _sublabel.text = __TEXT(@"shopcar_add");
    [self addSubview:_sublabel];
}

- (void)unload
{
}

- (void)layoutDidFinish
{
    _imageView.frame = CGRectMake(0, (self.size.height - 150.0f) / 2.0f - 60.0f, self.width,150 );

    _label.frame = CGRectMake( 0, _imageView.bottom, self.width, 25 );
	[_label sizeToFit];

	_label.frame = CGRectMake( 0, _imageView.bottom, self.width, _label.height );
	
    _sublabel.frame = CGRectMake( 0, _label.bottom + 5, self.width, 20 );
}

@end
