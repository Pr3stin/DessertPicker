//
//  DessertInfoViewController.swift
//  DessertPicker
//
//  Created by Prestin Lau on 6/22/23.
//

import UIKit

class DessertInfoViewController: UIViewController {
    
    let dessertNameLabel = UILabel()
    let dessertInfoLabel = UILabel()
    var dessertID: String?
    var dessertName: String?
    struct DessertInfo {
        let instructions: String
        let ingredients: [String]
        let measurements: [String]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        guard let mealID = dessertID else {
                    return
                }
        let url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
               
                fetchMealInfo(with: url)
            }
    
    func fetchMealInfo(with url: String) {
        guard let mealID = dessertID else {
                    return
                }
        let url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let apiUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
         URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
             guard let data = data,
                          let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let desserts = jsonResponse["desserts"] as? [[String: Any]] else {
                        print("Invalid response or missing data")
                        return
                    }
                    
                    var instructions = ""
                    for dessert in desserts {
                        if let dessertInstructions = dessert["strInstructions"] as? String {
                            instructions += dessertInstructions + "\n\n"
                        }
                    }
            
            DispatchQueue.main.async {
                self?.dessertInfoLabel.text = instructions
            }
             
        }.resume()
        
    }
    
    }




    

    


