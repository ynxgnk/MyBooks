//
//  APICaller.swift
//  MyBooks
//
//  Created by Nazar Kopeyka on 04.05.2023.
//

import Foundation

final class APICaller { /* 20 */
    static let shared = APICaller() /* 21 */
    
    private init() {} /* 22 */
    
    public private(set) var models = [String]() /* 23 */
    
    func fetchData(completion: @escaping () -> Void) { /* 24 */ /* 67 remove [String] from completion */
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in /* 25 */
            self?.models = Array(1...20).map { "Book \($0)"} /* 26 */
            completion() /* 27 */ /* 68 remove self?.models ?? [] */ 
        }
    }
                                          
    func loadMorePosts(completion: @escaping ([String]) -> Void) { /* 28 */
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in /* 29 */
            guard let strongSelf = self, let last = strongSelf.models.last else { /* 32 */
                return /* 33 */
            }
            let number = Int(last.components(separatedBy: " ").last!)! /* 34 */
            let start = number+1 /* 35 */
            let end = start+20 /* 36 */
            let newData = Array(start...end).map { "Book \($0)" } /* 30 */
            strongSelf.models.append(contentsOf: newData) /* 37 */
           completion(newData) /* 31 */ /* 66 change self?.models ?? [] */
            }
        }
    }
