//
//  UIImageView+Utility.swift
//  WeatherAppDemo
//
//  Created by Valiant Lamban on 4/15/20.
//  Copyright © 2020 Valiant L. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadURL(url: URL?) {
        guard let url = url else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
            if let resp = response, let dat = data, resp.isHTTPResponseValid() {
                DispatchQueue.main.async {
                    if UIImage(data: dat) != nil {                    
                        self.image = UIImage(data: dat)
                    }
                    
                }
            }
        }.resume()
    }
    
}

extension URLResponse {
    func isHTTPResponseValid() -> Bool {
        guard let response = self as? HTTPURLResponse else {
            return false
        }
        
        return (response.statusCode >= 200 && response.statusCode <= 299)
    }
}
