/*
 * Created by Grzegorz Wikiera on 30/03/15.
 * Copyright (c) 2015 Grzegorz Wikiera.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "GWInfinitePickerViewDelegate.h"

//! Project version number for GWInfinitePickerView.
FOUNDATION_EXPORT double GWInfinitePickerViewVersionNumber;

//! Project version string for GWInfinitePickerView.
FOUNDATION_EXPORT const unsigned char GWInfinitePickerViewVersionString[];

/**
 `UIPickerView` subclass which enables endless scrolling (like UIDatePicker).
*/
@interface GWInfinitePickerView : UIPickerView

/**
 The delegate for the picker view.
 */
@property(nullable,nonatomic,weak) id<GWInfinitePickerViewDelegate> delegate;

/**
 Returns the information if infinite scrolling is enable for a component.

 @param component A zero-indexed number identifying a component of the picker view.
 @return true if infinite scroll is enable, otherwise false.
 */
- (BOOL)isInfiniteScrollEnableInComponent:(NSInteger)component;

@end
