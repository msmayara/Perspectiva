//
//  ViewController.swift
//  Perspectiva
//
//  Created by Mayara on 11/03/20.
//  Copyright © 2020 Mayara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Hide the results view
        resultsView.isHidden = true
        calculateView.isHidden = false
        
        //Dismiss keyboard
        configureTextFields()
        configureTapGesture()
        setupDoneButton()
        
        //Disable the calculate button if the text fields are empty
        calculationButton.isEnabled = false
        calculationButton.alpha = 0.5
        
        //Listen for changes in text fields to disable calculate button
        salaryTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        weeklyWorkloadTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        productPriceTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        //Listen for keyboard events to move the content if it's under the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        
        // Stop Listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    
    @IBOutlet weak var salaryTextField: UITextField!
    
    @IBOutlet weak var weeklyWorkloadLabel: UILabel!
    
    @IBOutlet weak var weeklyWorkloadTextField: UITextField!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productPriceTextField: UITextField!
    
    @IBOutlet weak var resultsView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var calculateView: UIView!
    
    @IBOutlet weak var calculationButton: UIButton!
    
    // MARK: Actions
    @IBAction func calculateButton(_ sender: Any) {
        //Show the view for results
        resultsView.isHidden = false
        calculateView.isHidden = true
        
        //Hide the keyboard
        hideKeyboard()
        
        //Perform calculation
        calculation()
    }
    
    @IBAction func recalculateButton(_ sender: Any) {
        //Show the view for calculation
        calculateView.isHidden = false
        resultsView.isHidden = true
        
        //Clear the text fields
        salaryTextField.text = nil
        weeklyWorkloadTextField.text = nil
        productPriceTextField.text = nil
        
        //Deactivate calculate button
        toggleButton(deactivate: true)
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("return is pressed")
        // Hide the keyboard
        hideKeyboard()
        return true
    }
    
    // MARK: Functions
    private func configureTextFields(){
        // Handle the text field’s user input through delegate callbacks.
        salaryTextField.delegate = self
        weeklyWorkloadTextField.delegate = self
        productPriceTextField.delegate = self
    }
    
    // MARK: Dismiss keyboard
    private func configureTapGesture(){
        //Dismiss the keyboard if the user taps outside of the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(){
        print("Handle tap was called")
        view.endEditing(true)
    }
    
    func hideKeyboard(){
        salaryTextField.resignFirstResponder()
        weeklyWorkloadTextField.resignFirstResponder()
        productPriceTextField.resignFirstResponder()
    }
    
    func setupDoneButton(){
        //Setup a Done button in decimal pads
        let toolbar = UIToolbar(frame:CGRect(origin: .zero, size: .init(width:view.frame.size.width, height: 30)))
        
        //Create left side empty space so that the Done button is set on the right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        
        //Setting toolbar as inputAcesssoryView
        salaryTextField.inputAccessoryView = toolbar
        weeklyWorkloadTextField.inputAccessoryView = toolbar
        productPriceTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    

    //MARK: Move content that is under the keyboard
    var isProductPriceTextField = false
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //Check if the the text field being edited is the Product Price text field
        if (textField != salaryTextField && textField != weeklyWorkloadTextField) {
            isProductPriceTextField = true
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =  (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if (self.view.frame.origin.y == 0 && isProductPriceTextField == true){
                self.view.frame.origin.y -= 0.6 * (keyboardSize.height)
                isProductPriceTextField = false
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: Deactivate calculation button
    @objc func textChanged(_ textField: UITextField){
        //Checks if any of the text fields is empty
        let thereIsAnEmptyTextField = [salaryTextField, weeklyWorkloadTextField, productPriceTextField].contains { $0.text!.isEmpty }
        toggleButton(deactivate: thereIsAnEmptyTextField)
    }
    
    func toggleButton(deactivate: Bool){
        //Deactivates button if there's an empty text field
        if (deactivate){
            calculationButton.isEnabled = false
            calculationButton.alpha = 0.5
        } else {
            calculationButton.isEnabled = true
            calculationButton.alpha = 1.0
        }
    }
    
    
    func calculation(){
        let salaryString = salaryTextField.text!
        let weeklyWorkloadString = weeklyWorkloadTextField.text!
        let productPriceString = productPriceTextField.text!
        
        //Converting types
        let salaryDouble = Double(salaryString)!
        let weeklyWorkloadInt = Int(weeklyWorkloadString)!
        let productPriceDouble = Double(productPriceString)!
        
        //Creating an instance of the Finance class
        let finance = Finance(salary: salaryDouble, weeklyWorkload: weeklyWorkloadInt, productPrice: productPriceDouble)
        
        //Calling the instance's methods
        let hoursNeeded = finance.convertMoneyIntoTime()
        let percentageOfSalary = finance.calculateSalaryPercentage()
        
        //Formatting the results to have only one decimal place and saving it to a String
        let hoursNeededRounded = String(format: "%.1f", hoursNeeded)
        let hoursNeededString = "Para pagar por esse produto, é necessário \(hoursNeededRounded) horas do seu trabalho.\n\n"
        let percentageOfSalaryRounded = String(format: "%.1f", percentageOfSalary)
        let percentageOfSalaryString = "O valor deste produto representa \(percentageOfSalaryRounded)% do seu salário. "
        
        //Updating the result label's text
        resultLabel.text = hoursNeededString + percentageOfSalaryString
        
    }
    
}

