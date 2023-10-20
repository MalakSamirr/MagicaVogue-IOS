//    [1:13 PM] hebaelcc287 (Guest)
//
//    //
//
//    //  LeaguesCollectionViewController.swift
//
//    //  ProjectCollectionn
//
//    //
//
//    //  Created by Heba Elcc on 27.9.2023.
//
//    //
//
//    //
//
//     
//
//    import UIKit
//
//    import Kingfisher
//
//     
//
//    class LeaguesCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
//
//        
//
//        @IBOutlet var LeagesDetailsCollection: UICollectionView!
//
//        var upcommingMatches : [upcommingEvents]?
//
//        var latestMatches : [upcommingEvents]?
//
//        var Teams : [Int:TeamsDetails]?
//
//        var viewModel : LeagesDetailsViewModel!
//
//        
//
//        convenience init(viewModel: LeagesDetailsViewModel) {
//
//            self.init()
//
//            self.viewModel = viewModel
//
//        }
//
//        
//
//        override func viewDidLoad() {
//
//            super.viewDidLoad()
//
//            let addButton = UIBarButtonItem(image:UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonlicked))
//
//            addButton.tintColor = UIColor.black
//
//            navigationItem.rightBarButtonItem = addButton
//
//         
//
//            
//
//            
//
//            
//
//            collectionView.register(UINib(nibName: "TeamsCell", bundle: nil), forCellWithReuseIdentifier: "TeamsCell")
//
//            collectionView.register(UINib(nibName: "IncomingCell", bundle: nil), forCellWithReuseIdentifier: "IncomingCell")
//
//            collectionView.register(UINib(nibName: "LatestCell", bundle: nil), forCellWithReuseIdentifier: "LatestCell")
//
//            Teams = [Int:TeamsDetails]()
//
//            upcommingMatches = [upcommingEvents]()
//
//            let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
//
//                switch sectionIndex {
//
//                case 0 :
//
//                    return self.UpcomingEvents()
//
//                case 1 :
//
//                    return self.LatestEvents()
//
//                default:
//
//                    return self.TeamsSection()
//
//                    
//
//                }
//
//            }
//
//            collectionView.setCollectionViewLayout(layout, animated: true)
//
//            
//
//            
//
//            //fetch data
//
//            
//
//            upcommingMatches = [upcommingEvents]()
//
//            viewModel.fetch { [weak self] leagesUpEvent in
//
//                self?.upcommingMatches = leagesUpEvent
//
//                self?.getTeams()
//
//                // print(self?.Teams?.count)
//
//                // print("Teams:\(self?.Teams!)")
//
//                self?.LeagesDetailsCollection.reloadSections(IndexSet(integer: 0))
//
//                self?.LeagesDetailsCollection.reloadSections(IndexSet(integer: 2))
//
//                //self?.LeagesDetailsCollection.reloadData()
//
//                
//
//            }
//
//            
//
//            viewModel.fetchLatestEvents { [weak self] latestMatches in
//
//                
//
//                self?.latestMatches = latestMatches
//
//                self?.getTeams()
//
//                //print("Teams:\(self?.Teams!.count)")
//
//                self?.LeagesDetailsCollection.reloadSections(IndexSet(integer: 1))
//
//                self?.LeagesDetailsCollection.reloadSections(IndexSet(integer: 2))
//
//                self?.LeagesDetailsCollection.reloadData()
//
//                
//
//            }
//
//            
//
//            
//
//            guard let result1 = CoreDataManger.sharedCoreManger.checkIfExixst(leageName: viewModel.LeageName!)else{return}
//
//            if result1 == true{
//
//                let addButton = UIBarButtonItem(image:UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteButtonlicked))
//
//                addButton.tintColor = UIColor.red
//
//                navigationItem.rightBarButtonItem = addButton
//
//            }
//
//            
//
//        }
//
//        
//
//        @objc func favoriteButtonlicked(_ sender: Any) {
//
//           //
//
//            
//
//            
//
//                let imageUrl = URL(string: viewModel.image ?? "")
//
//            
//
//            
//
//            if let url = URL(string: viewModel.image ?? "") {
//
//                URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
//
//                  // Error handling...
//
//                    if let httpResponse = response as? HTTPURLResponse {
//
//                        if httpResponse.statusCode == 403{
//
//                            DispatchQueue.main.async { [self] in
//
//                                let image = UIImage(named: "placeHolder")
//
//                                let result = CoreDataManger.sharedCoreManger.Save(leageName: self.viewModel.LeageName, sportName: self.viewModel.sport, leageKey: Int32(self.viewModel.id!), Image: image)
//
//                                ckeckresult(result: result)
//
//                                return
//
//                            }
//
//                            
//
//                        }
//
//                        print("placeh \(httpResponse.statusCode)")
//
//                    }
//
//                 
//
//                  guard let imageData = data else {
//
//                        return
//
//                      
//
//                  }
//
//     
//
//                    DispatchQueue.main.async { [self] in
//
//                      let image = UIImage(data: imageData)
//
//                      
//
//                      let result = CoreDataManger.sharedCoreManger.Save(leageName: viewModel.LeageName, sportName: self.self.viewModel.sport, leageKey: Int32(viewModel.id!), Image: image)
//
//                      
//
//                      ckeckresult(result: result)
//
//                      let addButton = UIBarButtonItem(image:UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteButtonlicked))
//
//                      addButton.tintColor = UIColor.red
//
//                      navigationItem.rightBarButtonItem = addButton
//
//                  }
//
//                }.resume()
//
//            }else{
//
//                
//
//                    let image = UIImage(named: "placeHolder")
//
//                    let result = CoreDataManger.sharedCoreManger.Save(leageName: self.viewModel.LeageName, sportName: self.viewModel.sport, leageKey: Int32(self.viewModel.id!), Image: image)
//
//                    ckeckresult(result: result)
//
//                    let addButton = UIBarButtonItem(image:UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteButtonlicked))
//
//                    addButton.tintColor = UIColor.red
//
//                    navigationItem.rightBarButtonItem = addButton
//
//                    return
//
//                
//
//               
//
//                
//
//            }
//
//            
//
//    //
//
//    //
//
//    //                let imageData = try? Data(contentsOf: (imageUrl ?? URL(string: ""))!)
//
//    //                guard let data = imageData else {
//
//    //                    let image = UIImage(named: "placeHolder")
//
//    //                    let result = CoreDataManger.sharedCoreManger.Save(leageName: self.viewModel.LeageName, sportName: self.viewModel.sport, leageKey: Int32(self.viewModel.id!), Image: image)
//
//    //                    ckeckresult(result: result)
//
//    //                    return
//
//    //                }
//
//    //                let image = UIImage(data: data)
//
//    //
//
//    //                let result = CoreDataManger.sharedCoreManger.Save(leageName: viewModel.LeageName, sportName: self.self.viewModel.sport, leageKey: Int32(viewModel.id!), Image: image)
//
//    //
//
//    //                ckeckresult(result: result)
//
//    //                let addButton = UIBarButtonItem(image:UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favoriteButtonlicked))
//
//    //                addButton.tintColor = UIColor.red
//
//    //                navigationItem.rightBarButtonItem = addButton
//
//    //
//
//    //
//
//    //
//
//    //
//
//    //
//
//    //
//
//        }
//
//        
//
//        func ckeckresult(result:(isSaved:Bool,error:Error?)){
//
//            
//
//            if result.error != nil {
//
//                // Show an alert that the league already exists
//
//                let alertController = UIAlertController(title: "Error", message: result.error?.localizedDescription, preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                alertController.addAction(okAction)
//
//                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//
//            }
//
//            else{
//
//                if(result.isSaved){
//
//                    // Show an alert to indicate success
//
//                    let alertController = UIAlertController(title: "Success", message: "Data is successfully added.", preferredStyle: .alert)
//
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                    alertController.addAction(okAction)
//
//                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//
//                }
//
//                else{
//
//                    // Show an alert that the league already exists
//
//                    let alertController = UIAlertController(title: "League Exists", message: "The Leages allready Exist", preferredStyle: .alert)
//
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                    alertController.addAction(okAction)
//
//                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//
//                }
//
//                
//
//            }
//
//            
//
//        }
//
//        
//
//        func getTeams (){
//
//            if let upcomming = upcommingMatches {
//
//                for index in upcommingMatches!{
//
//                    if ((Teams?[viewModel.sport=="tennis" ? index.first_player_key! : index.home_team_key!]) == nil){
//
//                        Teams?[viewModel.sport=="tennis" ? index.first_player_key! : index.home_team_key!] = TeamsDetails(TeamName: index.event_home_team , teamLogo: viewModel.sport=="basketball" ? index.event_home_team_logo: viewModel.sport=="cricket" ?  index.event_home_team_logo :index.home_team_logo )
//
//                    }
//
//                    if ((Teams?[viewModel.sport=="tennis" ? index.second_player_key! : index.away_team_key!]) == nil){
//
//                        Teams?[viewModel.sport=="tennis" ? index.second_player_key! : index.away_team_key!] = TeamsDetails(TeamName: index.event_away_team , teamLogo: viewModel.sport=="basketball" ? index.event_away_team_logo: viewModel.sport=="cricket" ?  index.event_away_team_logo : index.away_team_logo)
//
//                    }
//
//                    
//
//                    
//
//                    
//
//                }
//
//            }
//
//            if let latest = latestMatches {
//
//                for index in latestMatches!{
//
//                    if ((Teams?[viewModel.sport=="tennis" ? index.first_player_key! : index.home_team_key!]) == nil){
//
//                        
//
//                        Teams?[viewModel.sport=="tennis" ? index.first_player_key! : index.home_team_key!] = TeamsDetails(TeamName: index.event_home_team , teamLogo: viewModel.sport=="basketball" ? index.event_home_team_logo: viewModel.sport=="cricket" ?  index.event_home_team_logo :index.home_team_logo )
//
//                    }
//
//                    if ((Teams?[viewModel.sport=="tennis" ? index.second_player_key! : index.away_team_key!]) == nil){
//
//                        
//
//                        Teams?[viewModel.sport=="tennis" ? index.second_player_key! : index.away_team_key!] = TeamsDetails(TeamName: index.event_away_team , teamLogo: viewModel.sport=="basketball" ? index.event_away_team_logo: viewModel.sport=="cricket" ?  index.event_away_team_logo : index.away_team_logo)
//
//                    }
//
//                    
//
//                }
//
//                
//
//                
//
//            }
//
//            
//
//            //LeagesDetailsCollection.reloadSections(IndexSet(integer: 2))
//
//        }
//
//     
//
//        
//
//            //MARK: 3 Functions for 3 sections (Upcoming Events - Latest Events - Teams)
//
//            
//
//            func UpcomingEvents()-> NSCollectionLayoutSection {
//
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//
//                                                      , heightDimension: .fractionalHeight(1))
//
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//                
//
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//
//                                                       , heightDimension: .absolute(200))
//
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
//
//                                                               , subitems: [item])
//
//                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
//
//                                                              , bottom: 0, trailing: 25)
//
//                
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
//
//                                                                , bottom: 10, trailing: 0)
//
//                section.orthogonalScrollingBehavior = .paging
//
//                section.boundarySupplementaryItems = [self.supplementtryHeader()]
//
//                
//
//                //animation
//
//                
//
//                section.visibleItemsInvalidationHandler = { items, offset, environment in
//
//                    items.forEach { item in
//
//                        if item.representedElementCategory == .cell {
//
//                            let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//
//                            let minScale: CGFloat = 0.8
//
//                            let maxScale: CGFloat = 1.0
//
//                            let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//
//                            item.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                        }
//
//                    }
//
//                }
//
//                return section
//
//            }
//
//            
//
//            func LatestEvents()->NSCollectionLayoutSection {
//
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//
//                                                      , heightDimension: .fractionalHeight(1))
//
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//                
//
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//
//                                                       , heightDimension: .absolute(220))
//
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
//
//                                                             , subitems: [item])
//
//                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
//
//                                                              , bottom: 8, trailing: 0)
//
//                
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
//
//                                                                , bottom: 10, trailing: 15)
//
//                section.boundarySupplementaryItems = [self.supplementtryHeader()]
//
//                return section
//
//            }
//
//            
//
//            func TeamsSection()-> NSCollectionLayoutSection {
//
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
//
//                                                      , heightDimension: .fractionalHeight(1))
//
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//                
//
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45)
//
//                                                       , heightDimension: .absolute(150))
//
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize
//
//                                                             , subitems: [item])
//
//                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
//
//                                                              , bottom: 0, trailing: 15)
//
//                
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15
//
//                                                                , bottom: 10, trailing: 0)
//
//                section.orthogonalScrollingBehavior = .continuous
//
//                section.boundarySupplementaryItems = [self.supplementtryHeader()]
//
//                // Animation
//
//                section.visibleItemsInvalidationHandler = { items, offset, environment in
//
//                    items.forEach { item in
//
//                        if item.representedElementCategory == .cell {
//
//                            let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//
//                            let minScale: CGFloat = 0.8
//
//                            let maxScale: CGFloat = 1.0
//
//                            let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//
//                            item.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//                        }
//
//                    }
//
//                }
//
//                
//
//                return section
//
//            }
//
//            
//
//            
//
//        }
//
//        
//
//        
//
//     
//
//     
//
//    extension LeaguesCollectionViewController {
//
//        
//
//        // MARK: UICollectionViewDataSource
//
//        
//
//        override func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//            
//
//            return 3
//
//        }
//
//        
//
//        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//            switch section {
//
//            case 0 : return upcommingMatches?.count ?? 0
//
//            case 1 : return latestMatches?.count ?? 0
//
//            default: return Teams?.count ?? 0
//
//            }
//
//            
//
//        }
//
//        
//
//        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            
//
//            
//
//            switch indexPath.section {
//
//            case 0:
//
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingCell", for: indexPath) as! IncomingCell
//
//               
//
//                if let imageUrl = URL(string: viewModel.sport == "basketball" ?  self.upcommingMatches?[indexPath.row].event_home_team_logo ?? "" : self.upcommingMatches?[indexPath.row].home_team_logo ?? "") {
//
//                    cell.HomeTeamLogo.kf.setImage(with: imageUrl)
//
//                }
//
//                if let imageUrl = URL(string: viewModel.sport == "basketball" ?  self.upcommingMatches?[indexPath.row].event_away_team_logo ?? "" : self.upcommingMatches?[indexPath.row].away_team_logo ?? "") {
//
//                    cell.AwayTeamLogo.kf.setImage(with: imageUrl)
//
//                }
//
//                /*if let imageUrl = URL(string: self.upcommingMatches?[indexPath.row].league_logo ?? "") {
//
//                    cell.BackgroundImage.kf.setImage(with: imageUrl)
//
//                }*/
//
//                else{
//
//                cell.BackgroundImage.image = UIImage(named: "league")}
//
//                cell.HomeTeamName.text = viewModel.sport == "tennis" ? self.upcommingMatches?[indexPath.row].event_first_player ?? " ":
//
//                    self.upcommingMatches?[indexPath.row].event_home_team ?? ""
//
//                
//
//                cell.awayTeamName.text = viewModel.sport == "tennis" ? self.upcommingMatches?[indexPath.row].event_second_player ?? " ":
//
//                self.upcommingMatches?[indexPath.row].event_away_team ?? ""
//
//                
//
//                
//
//                cell.matchTime.text = self.upcommingMatches?[indexPath.row].event_time
//
//                cell.matchDate.text = self.upcommingMatches?[indexPath.row].event_date
//
//                return cell
//
//                
//
//            case 1:
//
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingCell", for: indexPath) as! IncomingCell
//
//                if let imageUrl = URL(string: viewModel.sport == "basketball" ?  self.latestMatches?[indexPath.row].event_home_team_logo ?? "" : self.latestMatches?[indexPath.row].home_team_logo ?? "") {
//
//                    cell.HomeTeamLogo.kf.setImage(with: imageUrl)
//
//                }
//
//                if let imageUrl = URL(string: viewModel.sport == "basketball" ?  self.latestMatches?[indexPath.row].event_away_team_logo ?? "" : self.latestMatches?[indexPath.row].away_team_logo ?? "") {
//
//                    cell.AwayTeamLogo.kf.setImage(with: imageUrl)
//
//                }
//
//                
//
//                cell.HomeTeamName.text = viewModel.sport == "tennis" ? self.latestMatches?[indexPath.row].event_first_player ?? " ":
//
//                    self.latestMatches?[indexPath.row].event_home_team ?? ""
//
//                
//
//                cell.awayTeamName.text = viewModel.sport == "tennis" ? self.latestMatches?[indexPath.row].event_second_player ?? " ":
//
//                self.latestMatches?[indexPath.row].event_away_team ?? ""
//
//                
//
//                
//
//                
//
//                cell.matchTime.text = "Match Finished"
//
//                
//
//                cell.matchDate.text = self.latestMatches?[indexPath.row].event_final_result
//
//                cell.LatestTime.text = self.latestMatches?[indexPath.row].event_time
//
//                cell.LatestDate.text = self.latestMatches?[indexPath.row].event_date
//
//     
//
//            
//
//                return cell
//
//                
//
//            case 2:
//
//                
//
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCell", for: indexPath) as! TeamsCell
//
//               // print(Teams?[0].value)
//
//                
//
//                let index = Array(Teams!.keys)[indexPath.row]
//
//               
//
//               // print(index)
//
//               // print(Teams?[index]?.TeamName)
//
//                
//
//                cell.TeamName.text = Teams?[index]?.TeamName
//
//                if let imageUrl = URL(string: Teams?[index]?.teamLogo ?? ""){
//
//                    cell.TeamImage.kf.setImage(with:imageUrl)
//
//                    
//
//                }
//
//                else{
//
//                    cell.TeamImage.image = UIImage(named: "placeHolder")
//
//                }
//
//                return cell
//
//                
//
//            default:
//
//                return UICollectionViewCell()
//
//            }
//
//        }
//
//        
//
//        
//
//        
//
//        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//            if indexPath.section == 2 {
//
//                
//
//                if let TeamDetailVc  = storyboard?.instantiateViewController(withIdentifier: "TeamDetailVc") as? TeamDetails{
//
//                    let index = Array(Teams!.keys)[indexPath.row]
//
//                    TeamDetailVc.viewModel = TeamDetailViewModel(id: index , sport: self.viewModel.sport ?? "football")
//
//                   
//
//                    self.navigationController?.pushViewController(TeamDetailVc, animated: true)
//
//                    
//
//                }
//
//                else{
//
//                    print("Cant institiate vc")
//
//                }
//
//            }
//
//        }
//
//        
//
//        //MARK: Header Functions
//
//        func supplementtryHeader()->NSCollectionLayoutBoundarySupplementaryItem{
//
//            
//
//            .init(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top )
//
//            
//
//        }
//
//        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//            if kind == UICollectionView.elementKindSectionHeader{
//
//                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
//
//                
//
//                switch indexPath.section {
//
//                case 0 :
//
//                    sectionHeader.HeaderTitle?.text = "Upcoming Events"
//
//                    return sectionHeader
//
//                    
//
//                case 1 :
//
//                    sectionHeader.HeaderTitle?.text = "latest Events"
//
//                    return sectionHeader
//
//                    
//
//                case 2 :
//
//                    sectionHeader.HeaderTitle?.text = "Teams "
//
//                    return sectionHeader
//
//                    
//
//                default :
//
//                    sectionHeader.HeaderTitle?.text = "Sports"
//
//                    return sectionHeader
//
//                }
//
//            }
//
//            return UICollectionViewCell()
//
//        }
//
//        
//
//        
//
//        
//
//        
//
//        //MARK: Functions For Animation
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//            return 0
//
//        }
//
//    }
//
//     
//
//     
