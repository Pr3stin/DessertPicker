//
//  DessertInfoViewController.swift
//  DessertPicker
//
//  Created by Prestin Lau on 6/22/23.
//

import UIKit

class DessertInfoViewController: UIViewController {
    
    let ingredientLabel = UILabel()
    @IBOutlet weak var dessertInfoLabel: UILabel!
    var dessertID: String?
    var dessertName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundPink")
        
        fetchInstructions()
    }
    
    func fetchInstructions() {
        guard let mealID = dessertID else {
            return
        }
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let meals = json?["meals"] as? [[String: Any]], let firstMeal = meals.first, let instructions = firstMeal["strInstructions"] as? String
                {
                    
                    var ingredients: [String] = []
                    
                    for i in 1...20 {
                        if let ingredient = firstMeal["strIngredient\(i)"] as? String,
                           let measure = firstMeal["strMeasure\(i)"] as? String,
                           !ingredient.isEmpty, !measure.isEmpty {
                            let ingredientWithMeasure = "\(measure) \(ingredient)"
                            ingredients.append(ingredientWithMeasure)
                        }
                    }
                    
                    let joinedIngredients = ingredients.joined(separator: ", ")
                    
                    DispatchQueue.main.async {
                        self?.dessertInfoLabel.text = instructions
                        self?.configureScrollView(withSubtitle: joinedIngredients)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func configureScrollView(withSubtitle subtitle: String) {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = "\(dessertName ?? "") "
        
        let ingredientsHeaderLabel = UILabel()
        ingredientsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsHeaderLabel.textAlignment = .center
        ingredientsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 17)
        ingredientsHeaderLabel.text = "Ingredients:"
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = subtitle
        
        let instructionsHeaderLabel = UILabel()
        instructionsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsHeaderLabel.textAlignment = .center
        instructionsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 17)
        instructionsHeaderLabel.text = "Instructions:"
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(ingredientsHeaderLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(instructionsHeaderLabel)
        contentView.addSubview(dessertInfoLabel)
        
        dessertInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        dessertInfoLabel.textAlignment = .center
        dessertInfoLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 8),
            
            instructionsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            instructionsHeaderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            
            dessertInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dessertInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dessertInfoLabel.topAnchor.constraint(equalTo: instructionsHeaderLabel.bottomAnchor, constant: 8),
            dessertInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        view.addSubview(scrollView)
    }
    
    
}




    

    


