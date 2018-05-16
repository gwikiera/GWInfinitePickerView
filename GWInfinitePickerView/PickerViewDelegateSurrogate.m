//
//  PickerViewDelegateSurrogate.m
//  GWInfinitePickerView
//
//  Created by Grzegorz Wikiera on 31.01.2018.
//  Copyright © 2018 Grzegorz Wikiera. All rights reserved.
//

#import "PickerViewDelegateSurrogate.h"
#import "GWInfinitePickerView+Private.h"
#import <objc/runtime.h>

@implementation PickerViewDelegateSurrogate

- (void)normalizeInvocation:(NSInvocation *)anInvocation
{
    __unsafe_unretained GWInfinitePickerView * pickerView = nil;
    [anInvocation getArgument:&pickerView atIndex:2];
    NSInteger row;
    [anInvocation getArgument:&row atIndex:3];
    NSInteger component;
    [anInvocation getArgument:&component atIndex:4];
    if(![pickerView isInfiniteScrollEnabledInComponent:component]) {
        return;
    }
    NSInteger normalizedRow = [pickerView normalizedRowForRow:row forComponent:component];
    [anInvocation setArgument:&normalizedRow atIndex:3];
}

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.pickerViewDelegate respondsToSelector:anInvocation.selector]) {
        if (sel_isEqual(anInvocation.selector, @selector(pickerView:titleForRow:forComponent:))) {
            [self normalizeInvocation:anInvocation];
        }
        if (sel_isEqual(anInvocation.selector, @selector(pickerView:attributedTitleForRow:forComponent:))) {
            [self normalizeInvocation:anInvocation];
        }
        if (sel_isEqual(anInvocation.selector, @selector(pickerView:viewForRow:forComponent:reusingView:))) {
            [self normalizeInvocation:anInvocation];
        }
        if (sel_isEqual(anInvocation.selector, @selector(pickerView:didSelectRow:inComponent:))) {
            [self normalizeInvocation:anInvocation];
        }
        
        [anInvocation invokeWithTarget:self.pickerViewDelegate];
        return;
    }
    
    [super forwardInvocation:anInvocation];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector] == YES)
        return YES;
    
    return [self.pickerViewDelegate respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (self.pickerViewDelegate != nil) {
        signature = [(NSObject *)self.pickerViewDelegate methodSignatureForSelector:selector];
    }
    return signature;
}

@end
