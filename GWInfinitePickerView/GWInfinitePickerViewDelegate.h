//
//  PickerViewDelegateSurrogate.h
//  GWInfinitePickerView
//
//  Created by Grzegorz Wikiera on 16.05.2018.
//  Copyright © 2018 Grzegorz Wikiera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWInfinitePickerView;

/**
 The delegate of a GWInfinitePickerView object must adopt this protocol. It extends the `UIPickerViewDelegate` protocol.
 */
@protocol GWInfinitePickerViewDelegate<UIPickerViewDelegate>

@optional
/**
 Tells the picker view if the infinite scroll feature is enable for a picker component.

 @param pickerView An object representing the picker view requesting the data.
 @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 @return true to enable the infinite scroll feature, otherwise false.
 */
- (BOOL)pickerView:(GWInfinitePickerView *)pickerView isInfiniteScrollEnableInComponent:(NSInteger)component;

@end
