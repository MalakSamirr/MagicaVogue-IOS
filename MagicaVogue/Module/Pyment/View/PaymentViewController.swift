//
//  PaymentViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 20.10.2023.
//

import UIKit
import PassKit
import Lottie
import Alamofire

class PaymentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet var payementParentView: UIView!
    
    @IBOutlet weak var paymentBackgroundView: UIView!
    var dismissalCompletion: (() -> Void)?

    var draftOrderId: Int?
    var animationView: LottieAnimationView?
    
    var viewModel: BrandViewModel = BrandViewModel()

    @IBOutlet weak var paymentTable: UITableView!
    var payementMethodasArray: [Payement] = [
        Payement(type: "Cash on delivery", image: "money-icon-cash-icon", isSelected: true),
        Payement(type: "Apple pay", image: "apple-pay", isSelected: false)
    ]
    // Define the Apple Pay payment request
    private var paymentRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.MagicaVogue"
        request.supportedNetworks = [.visa, .masterCard, .quicPay , .vPay]
        request.supportedCountries = ["US", "EG", "QA", "AE", "SA"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        request.currencyCode = "EGP"
        
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "MagicaVogue", amount: 3234)]
        
        return request
    }
       override func viewDidLoad() {
           super.viewDidLoad()
           navigationController?.isNavigationBarHidden = true
           
           payementParentView.layer.cornerRadius = 24
           payementParentView.clipsToBounds = true
           payementParentView.dropShadow()
           
           paymentBackgroundView.layer.cornerRadius = 24
           paymentBackgroundView.clipsToBounds = true
           
           paymentTable.delegate = self
           paymentTable.dataSource = self
           paymentTable.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
           paymentTable.separatorStyle = .none
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return payementMethodasArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
           
           let paymentMethod = payementMethodasArray[indexPath.row]
           
           cell.titleLabel.text = paymentMethod.type
           cell.imageView?.image = UIImage(named: paymentMethod.image)
           
           cell.accessoryType = paymentMethod.isSelected ? .checkmark : .none
           
           return cell
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 70
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           
           let headerLabel = UILabel()
           headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
           headerLabel.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
           
           headerView.addSubview(headerLabel)
           headerLabel.translatesAutoresizingMaskIntoConstraints = false
           
           let inset: CGFloat = 20.0
           let leftConstraint = headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: inset)
           leftConstraint.isActive = true
           
           return headerView
       }
       
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return "Payment Options"
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           for index in 0..<payementMethodasArray.count {
               payementMethodasArray[index].isSelected = (index == indexPath.row)
           }
           
           if payementMethodasArray[indexPath.row].type == "Apple pay" {
               for (index, paymentMethod) in payementMethodasArray.enumerated() {
                   if paymentMethod.type == "Cash on delivery" {
                       payementMethodasArray[index].isSelected = false
                   }
               }
           }
           
           tableView.reloadData()
       }
       
       @IBAction func confirmPaymentButtonPressed(_ sender: UIButton) {
           if let selectedPaymentMethod = payementMethodasArray.first(where: { $0.isSelected }) {
               if selectedPaymentMethod.type == "Apple pay" {

                   let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                   paymentAuthorizationViewController?.delegate = self
                   present(paymentAuthorizationViewController!, animated: true, completion: {
                       self.completeOrder(draftOrderId: self.draftOrderId ?? 0) { result in
                           switch result {
                           case .success:
                               self.deleteDraftOrder(draftOrderId: self.draftOrderId ?? 0)
                               print("Order completed successfully.")
                           case .failure(let error):
                               // Handle failure
                               print("Error completing the order: \(error)")
                           }
                       }

                   })
               } else {
                   simulatePaymentProcess()
               }
           } else {
               
           }
       }
    
    func completeOrder(draftOrderId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId)/complete.json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]

        AF.request(baseURLString, method: .put, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Draft Order with ID \(draftOrderId) converted to order.")
                    completion(.success(())) // Success case

                case .failure(let error):
                    print("Failed: \(error)")
                    completion(.failure(error)) // Error case
                }
            }
    }

    
    func deleteDraftOrder(draftOrderId: Int) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        AF.request(baseURLString, method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Draft Order with ID \(draftOrderId) id deleted.")

                case .failure(let error):
                    print("Failed")
                }
            }
    }
    
    
       
       func simulatePaymentProcess() {

           let success = true

              if success {
                  playAnimation()
                 
              } else {
                  showPaymentResultAlert(success: false)
              }
       }
       
    func showPaymentResultAlert(success: Bool) {
        let title = success ? "Payment Successful" : "Payment Failed"
        let message = success ? "Your payment was successful." : "Your payment failed. Please try again."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

   }

   // MARK: - PKPaymentAuthorizationViewControllerDelegate
   extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
       func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
           controller.dismiss(animated: true) {
               self.playAnimation()
           }
       }

       func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
          
           let result = PKPaymentAuthorizationResult(status: .success, errors: nil)
           completion(result)

       }
       
       func playAnimation() {
           viewModel.animationView = .init(name: "SuccessAnimation")
           let animationSize = CGSize(width: 200, height: 200)
           
           let animationContainer = UIViewController()
           animationContainer.modalPresentationStyle = .pageSheet
           animationContainer.view.backgroundColor = .clear
           
           viewModel.animationView!.frame = CGRect(x: (animationContainer.view.bounds.width - animationSize.width) / 2,
                                                   y: (animationContainer.view.bounds.height - animationSize.height) / 2,
                                                   width: animationSize.width,
                                                   height: animationSize.height)
           viewModel.animationView!.contentMode = .scaleAspectFit
           viewModel.animationView!.loopMode = .playOnce
           viewModel.animationView!.alpha = 1.0
           animationContainer.view.addSubview(viewModel.animationView!)
           
           present(animationContainer, animated: true) { [weak self] in
               let startTime: CGFloat = 0.1
               let endTime: CGFloat = 0.8
               self?.viewModel.animationView?.play(
                   fromProgress: startTime,
                   toProgress: endTime
               ) { _ in
                   animationContainer.dismiss(animated: true, completion: nil)
               }
           }
       }
//       override func viewDidDisappear(_ animated: Bool) {
//           <#code#>
//       }
   }


