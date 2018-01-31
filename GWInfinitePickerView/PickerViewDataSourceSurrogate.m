/*
 * Created by Grzegorz Wikiera on 31/01/18.
 * Copyright (c) 2018 Grzegorz Wikiera.
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


#import "PickerViewDataSourceSurrogate.h"
#import <objc/runtime.h>
#import "GWInfinitePickerView+Private.h"

@implementation PickerViewDataSourceSurrogate

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.pickerViewDataSource respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.pickerViewDataSource];
        return;
    }
    
    [super forwardInvocation:anInvocation];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector] == YES)
        return YES;
    
    return [self.pickerViewDataSource respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (self.pickerViewDataSource != nil) {
        signature = [(NSObject *)self.pickerViewDataSource methodSignatureForSelector:selector];
    }
    return signature;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerViewDataSource numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = [self.pickerViewDataSource pickerView:pickerView numberOfRowsInComponent:component];
    if (numberOfRowsInComponent <= 0) {
        return numberOfRowsInComponent;
    }
    return kInfinitivePickerViewRowOffset * 2 + numberOfRowsInComponent;
}

@end
