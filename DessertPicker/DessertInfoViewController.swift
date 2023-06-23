//
//  DessertInfoViewController.swift
//  DessertPicker
//
//  Created by Prestin Lau on 6/22/23.
//

import UIKit

class DessertInfoViewController: UIViewController {
    var selectedValue: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let value = selectedValue {
            fetchMealDetails(for: value)
        }
    }
    
    func fetchMealDetails(for mealID: String) {
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Invalid API data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = json as? [String: Any],
                   let meals = dictionary["meals"] as? [[String: Any]],
                   let meal = meals.first {
                    DispatchQueue.main.async {
                        self?.displayMealDetails(meal)
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func displayMealDetails(_ meal: [String: Any]) {
        if let mealName = meal["strMeal"] as? String {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            label.center = view.center
            label.textAlignment = .center
            label.text = mealName
            
            view.addSubview(label)
        }
        
        
        if let mealCategory = meal["strCategory"] as? String {
            let categoryLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 200, height: 40))
            categoryLabel.center.x = view.center.x
            categoryLabel.textAlignment = .center
            categoryLabel.text = "Category: \(mealCategory)"
            
            view.addSubview(categoryLabel)
        }
    }
    
}
    


