//
//  PickerViewController.swift
//  FireCart
//
//  Created by Plamen Iliev on 26.06.18.
//  Copyright © 2018 Plamen Iliev. All rights reserved.
//

import UIKit

protocol PickerViewControllerDelegate: class {
    func numberPicked(number: Int)
}

class PickerViewController: UIViewController {

    let valueRangeLimit = 20
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    private var pickerValues = [Int]()
    private var initialValue: Int?
    
    weak var pickerViewControllerDelegate: PickerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(nibName: String, initialValue: Int, pickerValues: [Int]){
        self.init(nibName: nibName, bundle: nil)
        self.initialValue = initialValue
        self.pickerValues = pickerValues
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerViewDelegate()
        picker.selectRow(initialValue! - 1, inComponent: 0, animated: true)
    }

    @IBAction func buttonOKPressed(_ sender: UIButton) {
        pickerViewControllerDelegate?.numberPicked(number: pickerValues[picker.selectedRow(inComponent: 0)])
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    private func setupPickerViewDelegate() {
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerValues[row])
    }
    
}
