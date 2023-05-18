//
//  ViewController.swift
//  MyBooks
//
//  Created by Nazar Kopeyka on 04.05.2023.
//
import UIScrollView_InfiniteScroll /* 1 */
import UIKit

//setup table
//setup scroll handler
// add cells

final class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { /* 2 */ /* 13 add 2 protocols */

    private let table: UITableView = { /* 3 */
       let table = UITableView() /* 4 */
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell") /* 5 */
        table.translatesAutoresizingMaskIntoConstraints = false /* 6 */
        return table /* 7 */
    }()
    
    let service = APICaller.shared /* 38 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUpTable() /* 47 */
        
        setUpDataBindings() /* 49 */

    }
    
    private func setUpTable() { /* 46 */
        view.addSubview(table) /* 8 */
        table.delegate = self /* 9 */
        table.dataSource = self /* 10 */
        NSLayoutConstraint.activate([ /* 11 */
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 12 */
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 12 */
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 12 */
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), /* 12 */
        ])
        
    }
    
    private func setUpDataBindings() { /* 48 */
        service.fetchData { [weak self] in /* 42 */ /* 45 add weak self */ /* 69 remove _ before in */
            DispatchQueue.main.async { /* 43 */
                self?.table.reloadData() /* 44 */
            }
        }
        
        table.infiniteScrollDirection = .vertical /* 50 */
        table.addInfiniteScroll { [weak self] table in /* 51 */ /* 53 add weak self */
            //Fetch more data
            self?.service.loadMorePosts { [weak self] moreData in /* 54 */
                DispatchQueue.main.async { /* 56 */
                    print(moreData) /* 65 */
                    let startIndex = Int(moreData.first!.components(separatedBy: " ").last!)! /* 57 */
                    let start = startIndex-1 /* 58 */
                    let end = start + moreData.count /* 59 */
                    print(start) /* 63 */
                    print(end) /* 64 */
                    let indices = Array(start..<end).compactMap({ /* 60 */
                        return IndexPath(row: $0, section: 0) /* 61 */
                    })
                    self?.table.insertRows(at: indices,
                                            with: .automatic) /* 62 */
//                    self?.table.reloadData() /* 55 */
                    table.finishInfiniteScroll() /* 52 */
                }
            }
        }
    }

//MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 14 */
        return service.models.count /* 15 */ /* 39 change 10 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 16 */
        let model = service.models[indexPath.row] /* 40 */
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 17 */
        cell.textLabel?.text = model /* 18 */ /* 41 change "hello" */
        return cell /* 19 */
    }
}

