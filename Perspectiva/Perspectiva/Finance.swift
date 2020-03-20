//
//  Finance.swift
//  Perspectiva
//
//  Created by Mayara on 11/03/20.
//  Copyright © 2020 Mayara. All rights reserved.
//

import Foundation

class Finance {
    var salary: Double
    var weeklyWorkload: Int
    var productPrice: Double
    
    init(salary:Double, weeklyWorkload: Int, productPrice: Double){
        self.salary = salary
        self.weeklyWorkload = weeklyWorkload
        self.productPrice = productPrice
    }
    
    func convertWorkload() -> Int{
        //Multiply the weekly workload by 4 to get the monthly workload
        var monthlyWorkload:Int
        monthlyWorkload = weeklyWorkload * 4
        return monthlyWorkload
    }
    
    func calculateHourPrice() -> Double{
        //Divide the salary by the monthy workload to get how much an hour costs
        var hourPrice: Double
        let monthlyWorkload = convertWorkload()
        hourPrice = salary/Double(monthlyWorkload)
        return hourPrice
    }
    
    func convertMoneyIntoTime() -> Double{
        //Divide the price of the product by the price of an hour of work to find the number of work hours needed to purchase that product
        var hoursOfWorkNeeded: Double
        let hourPrice = calculateHourPrice()
        hoursOfWorkNeeded = productPrice/hourPrice
        return hoursOfWorkNeeded
    }
    
    func calculateSalaryPercentage() -> Double{
        //Calculate how much the product represents in terms of salary
        var percentage: Double
        percentage = (productPrice * 100)/salary
        return percentage
    }
    
    func calculateCustoCem() -> Double{
        //Returns the number of hours you need to work to make 100 reais
        var custoCem: Double
        let monthlyWorkload = convertWorkload()
        custoCem = Double(monthlyWorkload * 100)/salary
        return custoCem
    }
    
    
}
