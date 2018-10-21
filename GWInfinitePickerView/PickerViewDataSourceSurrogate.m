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
#import "GWInfinitePickerView+Private.h"

NSInteger const kInfinitePickerViewRowOffset = 1000;

@implementation PickerViewDataSourceSurrogate

- (NSInteger)pickerView:(UIPickerView *)pickerView rowOffsetForComponent:(NSInteger)component {
    NSInteger numberOfRowsInComponent = [self.pickerViewDataSource pickerView:pickerView numberOfRowsInComponent:component];
    if (numberOfRowsInComponent <= 0) {
        return kInfinitePickerViewRowOffset;
    }
    return ((kInfinitePickerViewRowOffset / numberOfRowsInComponent) + 1) * numberOfRowsInComponent;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerViewDataSource numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isKindOfClass:[GWInfinitePickerView class]]) {
        GWInfinitePickerView *infinitePickerView = (GWInfinitePickerView *)pickerView;
        if([infinitePickerView isInfiniteScrollEnabledInComponent:component]) {
            NSInteger numberOfRowsInComponent = [self.pickerViewDataSource pickerView:pickerView numberOfRowsInComponent:component];
            return [self pickerView:pickerView rowOffsetForComponent:component] * 2 + numberOfRowsInComponent;
        }
    }
    return [self.pickerViewDataSource pickerView:pickerView numberOfRowsInComponent:component];
}

@end
