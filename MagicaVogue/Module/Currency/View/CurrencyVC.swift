//
//  CurrencyVC.swift
//  MagicaVogue
//
//  Created by Gsm on 30/10/2023.
//

import UIKit
import Alamofire

class CurrencyVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var currencies: Currency?
    var currencies2 : Currency?
    var currencySelected : String = ""
    var changedCurrencyTo : CurrencyChange?


    @IBOutlet weak var currencySearchBar: UISearchBar!
    @IBOutlet weak var currrencyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currrencyTableView.dataSource = self
        currrencyTableView.delegate = self
        currencySearchBar.delegate = self
        currrencyTableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
       
        fetchCurrencies()
        self.currrencyTableView.reloadData()
        print(currencies?.results?.count)

       // print(currencies.count)
        print("---------")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies?.results?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell

        
        if let results = currencies?.results {
            let keys = Array(results.keys)
            if indexPath.row < keys.count {
                cell.currencyLabel.text = keys[indexPath.row]
            } else {
                cell.currencyLabel.text = "Out of range"
            }
        } else {
            cell.currencyLabel.text = "N/A"
        }
        cell.selectionStyle = .none
      


       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = currrencyTableView.cellForRow(at: indexPath) as! CurrencyCell
        if cell.isChecked == false{
            cell.isChecked = true
            cell.checkMark.image = UIImage(systemName: "checkmark.circle.fill")
            cell.checkMark.tintColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
            currencySelected = cell.currencyLabel.text!
        }
//        else{
//            cell.isChecked = false
//            cell.checkMark.image = UIImage(systemName: "circle")
//            cell.checkMark.tintColor = .black
//        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = currrencyTableView.cellForRow(at: indexPath) as! CurrencyCell
        cell.isChecked = false
        cell.checkMark.image = UIImage(systemName: "circle")
        cell.checkMark.tintColor = .black


    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func fetchCurrencies() {
        let apiKey = "e07402dc31-efa888e5a7-s3av7p"
        let apiUrl = "https://api.fastforex.io/fetch-all?api_key=\(apiKey)"
        AF.request(apiUrl).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let currencyResponse = try JSONDecoder().decode(Currency.self, from: data)
                    // Handle the decoded data
                    self.currencies = currencyResponse
                    self.currencies2 = currencyResponse
                    print(self.currencies)
                    self.currrencyTableView.reloadData()

                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    
    @IBAction func DoneButton(_ sender: Any) {
        print(currencySelected)
        changeCurrency()
        print("------------------------------")
        print(changedCurrencyTo?.result)
        print("------------------------------")

        
    }
    
    func changeCurrency(){
        let api = "https://api.fastforex.io/fetch-one?api_key=e07402dc31-efa888e5a7-s3av7p&to=EGP&from=USD"
        
        AF.request(api).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let currencyResponse = try JSONDecoder().decode(CurrencyChange.self, from: data)
                    // Handle the decoded data
                    self.changedCurrencyTo = currencyResponse
                    print(currencyResponse)
                    print(self.changedCurrencyTo?.result)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

}

// MARK: - Search
extension CurrencyVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            currencies?.results = currencies2?.results
        } else {
            currencies?.results = currencies2?.results?.filter { (key, _) in
                return key.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.currrencyTableView.reloadData()
        }
    }

}
