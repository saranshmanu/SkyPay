//
//  NetworkEngine.swift
//  SkyPay
//
//  Created by Saransh Mittal on 09/02/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class Constants {
    public static let BASE_URL = "https://api.blockcypher.com/v1/btc/main"
    public static let TOKEN = "ce6a007f303a458bb0c73aa8d892f081"
    public static func networkCall(url:String, method:HTTPMethod)->Promise<NSDictionary>{
        return Promise{success,failure in
            Alamofire.request(url, method:method).responseJSON{
                response in
                if response.result.isSuccess{
                    success(response.result.value as! NSDictionary)
                } else {
                    failure(response.result.error as! Error)
                }
            }
        }
    }
}

class networkEngine {
    class BlockchainAPI {
        // general information about a blockchain
        func chainEndpoint()->Promise<NSDictionary>{
            let url = Constants.BASE_URL
            return Constants.networkCall(url: url, method: .get)
        }
        // query for information on a block using its hash
        func blockHash(BLOCK_HASH:String)->Promise<NSDictionary> {
            let url = Constants.BASE_URL + "/blocks/" + BLOCK_HASH
            return Constants.networkCall(url: url, method: .get)
        }
        // query for information on a block using its height
        func blockHeight(BLOCK_HEIGHT:Int)->Promise<NSDictionary> {
            let url = Constants.BASE_URL + "/blocks/" + String(BLOCK_HEIGHT)
            return Constants.networkCall(url: url, method: .get)
        }
    }
    class AddressAPI {
        // information on a public address
        func addressBalance(ADDRESS:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/addrs/" + ADDRESS + "/balance"
            return Constants.networkCall(url: url, method: .get)
        }
        // detailed information on a public address and returns more information about an address’s transactions
        func addressEndpoint(ADDRESS:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/addrs/" + ADDRESS
            return Constants.networkCall(url: url, method: .get)
        }
        // returns all information available about a particular address
        func addressFullEndpoint(ADDRESS:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/addrs/" + ADDRESS + "/full"
            return Constants.networkCall(url: url, method: .get)
        }
        // generate multisig addresses
        public static func generateAddress()->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/addrs"
            return Constants.networkCall(url: url, method: .post)
        }
    }
}

//private static func c(completionHandler:@escaping (Bool) -> ()) {
//    completionHandler(false)
//}
//
//firstly{
//    networkEngine.AddressAPI.generateAddress()
//}.then{res in
//        print(res)
//}

