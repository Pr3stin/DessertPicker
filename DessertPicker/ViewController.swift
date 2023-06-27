//
//  ViewController.swift
//  DessertPicker
//
//  Created by Prestin Lau on 6/22/23.
//

import UIKit

class ViewController: UIViewController {

    let scroll = UIScrollView()
    var dessertApi = [Dessert]()
    
    struct Dessert {
        let dessertName: String
        let dessertID: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.frame = view.bounds
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scroll)
        
       fetchAPIResponse()
        
    }
    
    func fetchAPIResponse() {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
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
                   let meals = dictionary["meals"] as? [[String: Any]] {
                    
                    self?.dessertApi = meals.compactMap { meal in
                        guard let mealName = meal["strMeal"] as? String,
                              let mealID = meal["idMeal"] as? String else {
                            return nil
                        }
                        
                        return Dessert(dessertName: mealName, dessertID: mealID)
                    }
                    
                    DispatchQueue.main.async {
                        self?.createButtons()
                    }
                }
            }
            catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    
    func createButtons() {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 20
        var yOffset: CGFloat = 100

        for (index, meal) in (self.dessertApi).enumerated() {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: (scroll.frame.width - buttonWidth) / 2, y: yOffset, width: buttonWidth, height: buttonHeight)
            button.setTitle("\(meal.dessertName)", for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.tag = index

            scroll.addSubview(button)

            yOffset += buttonHeight + buttonSpacing
        }

        scroll.contentSize = CGSize(width: scroll.frame.width, height: yOffset)
    }
    

    @objc func buttonTapped(_ sender: UIButton) {
        let selectedDessert = self.dessertApi[sender.tag]
        print("Button tapped with value: \(selectedDessert)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
           guard let mealDetailVC = storyboard.instantiateViewController(withIdentifier: "DessertInfoViewController") as? DessertInfoViewController else {
               return
           }
           
           mealDetailVC.dessertID = selectedDessert.dessertID
           self.navigationController?.pushViewController(mealDetailVC, animated: true)
    }

    
}
    

    

    


