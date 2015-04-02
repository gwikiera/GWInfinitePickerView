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
    return kInfinitivePickerViewRowOffset * 2 + [self.pickerViewDataSource pickerView:pickerView numberOfRowsInComponent:component];
}

@end


@implementation PickerViewDelegateSurrogate

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.pickerViewDelegate respondsToSelector:anInvocation.selector]) {
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

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewDelegate pickerView:pickerView titleForRow:[(GWInfinitePickerView *)pickerView normalizedRowForRow:row forComponent:component] forComponent:component];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewDelegate pickerView:pickerView attributedTitleForRow:[(GWInfinitePickerView *)pickerView normalizedRowForRow:row forComponent:component] forComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [self.pickerViewDelegate pickerView:pickerView viewForRow:[(GWInfinitePickerView *)pickerView normalizedRowForRow:row forComponent:component]  forComponent:component reusingView:view];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.pickerViewDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    [pickerView selectRow:row inComponent:component animated:NO];
}

@end
