//
//  ViewController.swift
//  ChatAI
//
//  Created by Seattle on 2024/2/13.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let field: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .red
        textField.returnKeyType = .done
        return textField
    }()
    
    private var models = [String]()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableView.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(field)
        view.addSubview(table)
        field.delegate = self
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 50),
            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: field.topAnchor)
        ])
    }
    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            models.append(text)
            APICaller.shared.getResponse(input: text) { [weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.field.text = nil
                    }
                    
                case .failure:
                    print("Failed")
                }
            }
        }
        return true
    }
    
}
