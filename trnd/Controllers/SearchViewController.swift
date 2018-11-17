//
//  SearchViewController.swift
//  gift
//
//  Created by Kareem Arab on 2018-02-03.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import UIKit
import VBFPopFlatButton
//import TabPageViewController

class SearchViewController: UIViewController {

    // MARK: - IBOutvars
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var searchTextField: UITextField!
    //@IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var searchBar = UISearchBar()
    //var collectionView: UICollectionView?
    var searchTableDataSource: SearchTableDataSource?
    var searchCollectionDataSource: SearchCollectionDataSource?
    let overlayButton = UIButton(type: .custom)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()    
        
        setupSearchTableDataSource()
        
        self.navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navBar.shadowImage = UIImage()
        
        let popFlatButtonLeft = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30), buttonType: FlatButtonType.buttonDownBasicType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        popFlatButtonLeft?.tintColor = UIColor.white
        popFlatButtonLeft?.addTarget(self, action: #selector(SearchViewController.backPressed), for: UIControl.Event.touchUpInside)
        let collapseButtonLeft = UIBarButtonItem(customView: popFlatButtonLeft!)
        self.navBar.topItem?.leftBarButtonItem = collapseButtonLeft
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(textFieldDidEndChanging(_:)), for: .editingDidEnd)
        
        searchTextField.clearButtonMode = .whileEditing
        
        self.tableView.isMultipleTouchEnabled = false
        
        //self.hideKeyboardWhenTappedAround()
        
        setupCollectionView()
        
        //collectionView?.backgroundColor = UIColor.fabishPink()
        
        //self.tableView.delegate = self
        //self.tableView.dataSource = UITableViewDataSource.self as? UITableViewDataSource
        
    }
    
    @objc func textFieldDidEndChanging(_ textField: UITextField) {
        
        overlayButton.isHidden = true
        //collectionView.removeFromSuperview()
        //self.view.bringSubview(toFront: self.tableView)
        
        setupCollectionView()
        
    }
    
    func clearTextFieldSearchBar() {
        
    }
    
    @nonobjc func searchBarTextDidEndEditing(_ textField: UITextField) {
        print("ended editing")
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        overlayButton.isHidden = false
        
        guard searchTextField.text?.isEmpty == false else {
            resetUserInterface()
            let text = UILabel(frame: CGRect(x: tableView.frame.width/2, y: 74, width: tableView.frame.width-10, height: 40))
            text.text = "Try searching for people and gifs"
            //searchBar.resignFirstResponder()
            //self.setupCollectionView()
            return
        }
        
        if let searchTableDataSource = searchTableDataSource {
            if let collectionView = collectionView {
                collectionView.removeFromSuperview()
                self.view.bringSubviewToFront(self.tableView)
                /*
                 // removes collection view when text is changed in search bar.
                 
                 //self.view.bringSubviewToFront(self.tableView)
                 
                 let tc = TabPageViewController.create()
                 
                 let vc1 = UIViewController()
                 vc1.view.backgroundColor = UIColor.whiteColor()
                 let vc2 = HashtagViewController()
                 tc.tabItems = [(vc1, "People"), (vc2, "#tags")]
                 var option = TabPageOption()
                 option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
                 tc.option = option
                 self.view.bringSubviewToFront(tc.view)
                 */
            }
            searchTableDataSource.searchUsers(searchTextField.text!)
            //searchTableDataSource.searchUsers(searchBar.text!)
        }
           
    }
    
    @objc func backPressed() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setupSearchBar()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //searchBar.text = ""
    }
    
    // MARK: - Methods
    
    func setupSearchTableDataSource() {
        print("Called")
        searchTableDataSource = SearchTableDataSource(tableView: tableView)
        tableView.dataSource = searchTableDataSource
        tableView.delegate = self
    }
    
    func setupSearchCollectionViewDataSource(_ collectionView: UICollectionView) {
        searchCollectionDataSource = SearchCollectionDataSource(collectionView: collectionView)
        collectionView.dataSource = searchCollectionDataSource
        searchCollectionDataSource?.downloadNewestPosts()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        //searchBar.tintColor = UIColor.fabishPink()
        
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        //searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        //searchBar.delegate = self
       // searchBar.barTintColor = UIColor.fabishPink()
        //searchBar.tintColor = UIColor.red
        searchBar.layer.borderColor = UIColor.clear.cgColor
        //searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.fabishPink()
        //searchBar.text = UIColor.white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.white

        //UISearchBar.appearance().setSearchFieldBackgroundImage(UIImage(named: "text_box")!, for: .normal)
        
        searchBar.frame.size.width = self.view.frame.width - 30
        searchBar.showsCancelButton = false
        //searchBar.
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
    }
    
    func setupCollectionView() {
        print("Setup collection view")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let size: CGFloat = UIScreen.main.bounds.width / 3
        flowLayout.itemSize = CGSize(width: size, height: size)
        let screen = UIScreen.main.bounds
        let height = screen.height
        let frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: 200)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        //setupSearchCollectionViewDataSource(collectionView!)
        
        collectionView?.alwaysBounceVertical = true
        //collectionView?.backgroundColor = UIColor.red
        ////self.view.addSubview(collectionView!)
        //collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //self.view.bringSubview(toFront: collectionView!)
        
        //self.view.addSubview(collectionView!)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //self.view.bringSubview(toFront: collectionView!)
        print("Setup collection view done")
    }
    
    func resetUserInterface() {
        guard let searchTableDataSource = searchTableDataSource else { return }
        searchTableDataSource.usernames.removeAll()
        searchTableDataSource.avatarFiles.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func usernameButton(_ sender: UIButton) {
        print("Pressed")
        //guard let searchTableDataSource = searchTableDataSource else { return }
        let username = sender.titleLabel?.text
        NavigationManager.showProfileViewController(withPresenter: self, forUsername: username!)
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        print("pressed1")
        guard let searchTableDataSource = searchTableDataSource else { return }
        //let user = searc
        let username = searchTableDataSource.usernames[(indexPath as NSIndexPath).row]
        print("\(username)")
        print("Pressed2")
        NavigationManager.showProfileViewController(withPresenter: self, forUsername: username)
        print("Pressed3")
        
    }
    
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print("Pressedd")
    //guard let searchTableDataSource = searchTableDataSource else { return }
    //let user = searc
    //let username = searchTableDataSource?.usernames[(indexPath as NSIndexPath).row]
    //print("\(username)")
    //print("Pressed2")
    //NavigationManager.showProfileViewController(withPresenter: self, forUsername: username!)
    //print("Pressed3")
    
    //let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
    
    //let currentCell = tableView.cellForRow(at: indexPath!)!
    
    //print(currentCell.textLabel!.text)
    
    //}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchTextField.endEditing(true)
    }
    
}


// MARK: - UITableViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchCollectionDataSource = searchCollectionDataSource else {return}
        let uniqueID = searchCollectionDataSource.uniqueIDs[(indexPath as NSIndexPath).row]
        NavigationManager.showFeedViewController(withPresenter: self, forMode: FeedMode.singlePost(uniqueID))
        print("slected")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let searchCollectionDataSource = searchCollectionDataSource else { return }
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
            searchCollectionDataSource.loadMorePosts()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //setupTabsUnderSearch()
        
        /*
        guard searchText.isEmpty == false else {
            resetUserInterface()
            //searchBar.resignFirstResponder()
            self.setupCollectionView()
            return
        }
        */
        if let searchTableDataSource = searchTableDataSource {
            if let collectionView = collectionView {
                collectionView.removeFromSuperview()
                self.view.bringSubviewToFront(self.tableView)
                /*
                // removes collection view when text is changed in search bar.
                
                //self.view.bringSubviewToFront(self.tableView)
                
                let tc = TabPageViewController.create()
                
                let vc1 = UIViewController()
                vc1.view.backgroundColor = UIColor.whiteColor()
                let vc2 = HashtagViewController()
                tc.tabItems = [(vc1, "People"), (vc2, "#tags")]
                var option = TabPageOption()
                option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
                tc.option = option
                self.view.bringSubviewToFront(tc.view)
 */
            }
            //searchTableDataSource.searchUsers(searchTextField.text!)
            //searchTableDataSource.searchUsers(searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
