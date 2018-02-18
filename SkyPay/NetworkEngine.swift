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
    public static func networkCall(url:String, method:HTTPMethod, params:NSDictionary = [:], header:NSDictionary = [:])->Promise<NSDictionary>{
        return Promise{success,failure in
            let x = params as! [String:Any]
            let y = header as! [String:Any]
            Alamofire.request(url, method:method, parameters:x).responseJSON{
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
    class WalletAPI {
        // information on a public address
        func createWallet(NAME_OF_THE_WALLET:String, ADDRESSES:[String])->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets" + "?token=" + Constants.TOKEN
            let params = [
                "name":NAME_OF_THE_WALLET,
                "addresses":ADDRESSES
                ] as NSDictionary
            return Constants.networkCall(url: url, method: .post, params: params)
        }
        // list all the wallets from the token
        func listWallets()->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets" + "?token=" + Constants.TOKEN
            return Constants.networkCall(url: url, method: .get)
        }
        // get addresses and all the information about a wallet from a wallet name
        func getWalletAddressesFromName(NAME_OF_THE_WALLET:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets/" + NAME_OF_THE_WALLET + "/addresses?token=" + Constants.TOKEN
            return Constants.networkCall(url: url, method: .get)
        }
        // add an address from the wallet with name
        func addAddressesToWallet(NAME_OF_THE_WALLET:String, ADDRESSES:[String])->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets/" + NAME_OF_THE_WALLET + "/addresses?token=" + Constants.TOKEN
            let params = [
                "addresses":ADDRESSES
                ] as NSDictionary
            return Constants.networkCall(url: url, method: .post, params: params)
        }
        // delete an address from the wallet with name
        func deleteAddressFromWallet(NAME_OF_THE_WALLET:String, ADDRESS:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets/" + NAME_OF_THE_WALLET + "/addresses?token=" + Constants.TOKEN + "&address=" + ADDRESS
            return Constants.networkCall(url: url, method: .delete)
        }
        // delete all the wallets with token
        func deleteWallet(NAME_OF_THE_WALLET:String)->Promise<NSDictionary>{
            let url = Constants.BASE_URL + "/wallets/" + NAME_OF_THE_WALLET + "/addresses?token=" + Constants.TOKEN
            return Constants.networkCall(url: url, method: .delete)
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

