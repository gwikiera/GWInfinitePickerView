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


#import "GWInfinitePickerView.h"
#import <objc/runtime.h>


static NSInteger const kInfinitivePickerViewRowOffset = 1000;


@interface PickerViewDataSourceSurrogate : NSObject <UIPickerViewDataSource>

@property (weak, nonatomic) id<UIPickerViewDataSource> pickerViewDataSource;

@end


@interface PickerViewDelegateSurrogate : NSObject <UIPickerViewDelegate>

@property (weak, nonatomic) id<UIPickerViewDelegate> pickerViewDelegate;

@end


@interface GWInfinitePickerView()

@property (strong, nonatomic) PickerViewDataSourceSurrogate * dataSourceSurrogate;
@property (strong, nonatomic) PickerViewDelegateSurrogate * delegateSurrogate;

@end

@implementation GWInfinitePickerView

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    for (int i = 0; i < [self numberOfComponents]; i++) {
        [self selectRow:0 inComponent:i animated:NO];
    }
}

- (NSInteger)normalizedRowForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = [self numberOfRowsInComponent:component];
    if (numberOfRowsInComponent <= 0) {
        return row;
    }
    
    NSInteger normalizedRow = (row - kInfinitivePickerViewRowOffset) % numberOfRowsInComponent;
    if (normalizedRow < 0) {
        normalizedRow += numberOfRowsInComponent;
    }
    return normalizedRow;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return [super numberOfRowsInComponent:component] - 2 * kInfinitivePickerViewRowOffset;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [super viewForRow:[self normalizedRowForRow:row forComponent:component] forComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [super selectRow:row + kInfinitivePickerViewRowOffset inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    NSInteger row = [super selectedRowInComponent:component];
    return [self normalizedRowForRow:row forComponent:component];
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    PickerViewDataSourceSurrogate * surrogate = [[PickerViewDataSourceSurrogate alloc] init];
    surrogate.pickerViewDataSource = dataSource;
    [super setDataSource:surrogate];
    self.dataSourceSurrogate = surrogate;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    PickerViewDelegateSurrogate * surrogate = [[PickerViewDelegateSurrogate alloc] init];
    surrogate.pickerViewDelegate = delegate;
    [super setDelegate:surrogate];
    self.delegateSurrogate = surrogate;
}

@end


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


@implementation PickerViewDelegateSurrogate

- (void)normalizeInvocation:(NSInvocation *)anInvocation
{
    __unsafe_unretained GWInfinitePickerView * pickerView = nil;
    [anInvocation getArgument:&pickerView atIndex:2];
    NSInteger row;
    [anInvocation getArgument:&row atIndex:3];
    NSInteger component;
    [anInvocation getArgument:&component atIndex:4];
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
