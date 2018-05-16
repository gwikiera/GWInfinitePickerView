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

import XCTest
@testable import GWInfinitePickerView

class GWInfinitePickerViewTests: XCTestCase {
    var tested: GWInfinitePickerView!
    let numberOfComponents = 4
    lazy var numberOfRows: [Int] = (0..<self.numberOfComponents).map { return $0 * 10 }
    lazy var dataSourceMock: UIPickerViewDataSourceMock! = {
        let dataSourceMock = UIPickerViewDataSourceMock()
        dataSourceMock.numberOfComponents = self.numberOfComponents
        dataSourceMock.numberOfRowsInComponent = { return self.numberOfRows[$0] }
        return dataSourceMock
    }()
    
    lazy var delegateMock: GWPickerViewDelegateMock! = GWPickerViewDelegateMock()
    
    override func setUp() {
        super.setUp()
        
        tested = GWInfinitePickerView()
        tested.dataSource = dataSourceMock
        tested.delegate = delegateMock
    }
    
    override func tearDown() {
        super.tearDown()
        
        dataSourceMock = nil
        delegateMock = nil
    }
    
    func testDidMoveToWindow() {
        tested.selectRow(1, inComponent: 1, animated: false)
        let selectedRow = tested.selectedRow(inComponent: 1)
        XCTAssertEqual(selectedRow, 1)
        
        tested.didMoveToWindow()
        XCTAssertEqual(selectedRow, tested.selectedRow(inComponent: 1))
    }
}

// MARK: DataSource
extension GWInfinitePickerViewTests {
    func testDataSourceNumberOfComponents() {
        dataSourceMock.numberOfComponents = 4
        
        XCTAssertEqual(tested.numberOfComponents, 4)
    }
    
    func testDataSourceNumberOfRows() {
        let pickerViewNumberOfRows = (0..<numberOfComponents).map(tested.numberOfRows)
        
        XCTAssertEqual(pickerViewNumberOfRows, numberOfRows)
    }
}

// MARK: Delegate
extension GWInfinitePickerViewTests {
    func testDelegateWidthForComponent() {
        let widthForComponent: [CGFloat] = (0..<numberOfComponents).map { return CGFloat($0 * 10) }
        delegateMock.widthForComponent = { return widthForComponent[$0] }
        
        let pickerViewWidthForComponent = (0..<numberOfComponents).map(tested.rowSize).map { $0.width }
        
        XCTAssertEqual(pickerViewWidthForComponent, widthForComponent)
    }
    
    func testDelegateViewForRow() {
        delegateMock.viewForRow = { (row, component) in
            let view = UIView()
            view.tag = component * 100 + row
            return view
        }
        
        XCTAssertEqual(tested.view(forRow: 1, forComponent: 0)?.tag, 1)
        XCTAssertEqual(tested.view(forRow: 1, forComponent: 1)?.tag, 101)
    }

    func testDelegateIsInfiniteScrollEnableInComponent() {
        delegateMock.isInfiniteScrollEnableInComponent = { (component) in
            return component == 0
        }

        XCTAssertEqual(tested.isInfiniteScrollEnabled(inComponent: 0), true)
        XCTAssertEqual(tested.isInfiniteScrollEnabled(inComponent: 11), false)
    }
}

