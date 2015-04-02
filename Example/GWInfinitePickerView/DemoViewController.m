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


#import "DemoViewController.h"
#import "GWInfinitePickerView.h"

@interface DemoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutletCollection(UIPickerView) NSArray *pickerViews;
@property (nonatomic, readonly) UIPickerView *pickerView;

@end

@implementation DemoViewController

- (IBAction)segmentedContolValueChanged:(UISegmentedControl *)sender
{
    for (UIPickerView * pickerView in self.pickerViews) {
        pickerView.hidden = pickerView.tag != sender.selectedSegmentIndex;
    }
    [self updateTimeLabelText];
}

#pragma mark - IBActions

- (IBAction)resetButtonTapped:(id)sender
{
    [self resetPickerToCurrentTime];
}

#pragma mark - Private Properties

- (UIPickerView *)pickerView
{
    for (UIPickerView * pickerView in self.pickerViews) {
        if (pickerView.tag == self.segmentedControl.selectedSegmentIndex) {
            return pickerView;
        }
    }
    return nil;
}

#pragma mark - Private Methods

- (void)resetPickerToCurrentTime
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [self.pickerView selectRow:[components hour] inComponent:0 animated:YES];
    [self.pickerView selectRow:[components minute] inComponent:1 animated:YES];
    [self updateTimeLabelText];
}

- (void)updateTimeLabelText
{
    NSInteger hour = [self.pickerView selectedRowInComponent:0];
    NSInteger minute = [self.pickerView selectedRowInComponent:1];
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UILabel alloc] init];
    }
    [(UILabel *)view setText: [NSString stringWithFormat:@"%02ld", (long)row]];
    return view;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateTimeLabelText];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }
    return 60;
}

@end
