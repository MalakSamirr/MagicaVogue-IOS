//
//  CurrencyVC.swift
//  MagicaVogue
//
//  Created by Gsm on 30/10/2023.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class CurrencyVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    let currencyViewModel = CurrencyViewModel()
    @IBOutlet weak var currencySearchBar: UISearchBar!
    @IBOutlet weak var currrencyTableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        currrencyTableView.dataSource = self
        currrencyTableView.delegate = self
        currencySearchBar.delegate = self
        currrencyTableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
       
        currencyViewModel.fetchCurrencies()
        self.currrencyTableView.reloadData()
        print(currencyViewModel.currencies?.results?.count)

       // print(currencies.count)
        print("---------")
        setupBindings()

    }
  
    func setupBindings() {
        currencyViewModel.refresh
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.currrencyTableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        currencyViewModel.havingError.skip(1)
            .bind { [weak self] error in
                DispatchQueue.main.async {[weak self] in
                    self?.showToast(message: error ?? "error")
                }
            }
            .disposed(by: disposeBag)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.currencies?.results?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell

        
        if let results = currencyViewModel.currencies?.results {
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
            currencyViewModel.currencySelected = cell.currencyLabel.text!
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
    
    
 

    
    @IBAction func DoneButton(_ sender: Any) {
        print(currencyViewModel.currencySelected)
        currencyViewModel.changeCurrency(to: currencyViewModel.currencySelected)
        print(currencyViewModel.changedCurrencyTo?.result)
        
       // currencyViewModel.addCurrency()
      
        
   
        
        
      
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
   

}

// MARK: - Search
extension CurrencyVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            currencyViewModel.currencies?.results = currencyViewModel.currencies2?.results
        } else {
            currencyViewModel.currencies?.results = currencyViewModel.currencies2?.results?.filter { (key, _) in
                return key.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.currrencyTableView.reloadData()
        }
    }

}
