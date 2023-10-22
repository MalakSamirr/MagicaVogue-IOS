////
////  BaseURL.swift
////  MagicaVogue
////
////  Created by Hoda Elnaghy on 10/22/23.
////
//
//import Foundation
//
//// MARK: - Token
//struct Token {
////    static let APIKey = "0537e30da2720f6e62679690742a746c3831f677ea92b00dab26a3918ecbae73" // old APIKey
//    static let APIKey = "186650e3d372f3aaf0b301606734a2d9ac20c430ffa717ff31657c838963c357" // new APIKey
//}
//
//// MARK: - Met
//enum Met: String {
//    case fixtures = "Fixtures"
//    case teams = "Teams"
//    case leagues = "Leagues"
//    case players = "Players"
//}
//
//// MARK: - URLs
//struct URLs {
//    
//    // MARK: - Base URL
//    static let base = "https://apiv2.allsportsapi.com"
//  
//    // MARK: - Path RUL
//    // get all leagues
//    // https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=[YourKey]
//    
//    // Football
//    //https://apiv2.allsportsapi.com/football/
//    /// GET{met, APIkey}
//    static let football = "/football"
//    
//    // Tennis
//    //https://apiv2.allsportsapi.com/tennis/
//    /// GET{met, APIkey}
//    static let tennis = "/tennis"
//    
//    // Basketball
//    //https://apiv2.allsportsapi.com/basketball/
//    /// GET{met, APIkey}
//    static let basketball = "/basketball"
//    
//    // Cricket
//    //https://apiv2.allsportsapi.com/cricket/
//    /// GET{met, APIkey}
//    static let cricket = "/cricket"
//    
//    
//    // MARK: Extra
//    /*
//    // Get upcoming events
//    // https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=[leagueId]&from=[CurrentDate]&to=[CurrentDate + OneYear]&APIkey=[YourKey]
//    // https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=205&from=2023-01-18&to=2024-01-18&APIkey=[YourKey]
//    // GET{met, leagueId, from, to, APIkey}
//    static let upComingEvents = "/football"
//    
//    
//    // Get Latest Results :
//    // https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=[leagueId]&from=[CurrentDate - OneYear]&to=[CurrentDate]&APIkey=[YourKey]
//    // https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=205&from=2022-01-18&to=2023-01-18&APIkey=[YourKey]
//    /// GET{met, leagueId, from, to, APIkey}
//    static let latestResults = "/football"
//
//    // Get All Teams
//    // https://apiv2.allsportsapi.com/football/?met=Teams&leagueId=[leagueId]&APIkey=[YourKey]
//    // https://apiv2.allsportsapi.com/football/?met=Teams&APIkey=0537e30da2720f6e62679690742a746c3831f677ea92b00dab26a3918ecbae73&leagueId=207
//    /// get{met, leagueId, APIkey}
//    static let allTeams = "/football"
//    
//    // Get Team Details
//    // https://apiv2.allsportsapi.com/football/?met=Teams&teamId=[teamId]&APIkey=[YourKey]
//    // https://apiv2.allsportsapi.com/football/?&met=Teams&teamId=96&APIkey=0537e30da2720f6e62679690742a746c3831f677ea92b00dab26a3918ecbae73
//    /// get{met, teamId, APIkey}
//    // static let teamDetails = "/football"
//     */
//
//    
//}
