//
//  SearchViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit
import SDWebImage
import MBProgressHUD

var searchTrack = [Track]()

class SearchViewController: UIViewController {
    
    //MARK: - Props
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    var searchText: String = ""
    var dbManager = DatabaseManager()
    
    //MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dbManager.initDB()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        hiddenTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hiddenTable()
        searchTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hiddenTable()
        searchTableView.reloadData()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTrack = [Track]()
        searchText = searchTextField.text!
        getDataSearch(name: searchText)
        searchTableView.reloadData()
    }
    
    //MARK: - Custom Methods
    func hiddenTable(){
        if searchTrack.count == 0 {
            searchTableView.isHidden = true
            logoImage.isHidden = false
        } else {
            searchTableView.isHidden = false
            logoImage.isHidden = true
        }
    }
    
    @objc func updateTrack(_ sender: UIButton){
        let tag = sender.tag
        searchTrack[tag].isFavorite = "true"
        let track = Track(imageName: searchTrack[tag].imageName, trackTitle: searchTrack[tag].trackTitle, artistName: searchTrack[tag].artistName, albumCover: searchTrack[tag].albumCover, isFavorite: "true", urlMusic: searchTrack[tag].urlMusic)
        dbManager.saveDBValueTrack(inputData: track)
    }
    
    @objc func reload(){
        searchTableView.reloadData()
        hiddenTable()
    }
    
    func getDataSearch(name: String){
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = "fetching recommended track for you"
        Indicator.show(animated: true)
        
        let myURLRequest = UrlRequestBuilder().buildUrlRequestDeezer(artist: name)
        RestWebService().sendRequest(urlRequest: myURLRequest, input: nil) {
            json, error in
            DispatchQueue.main.sync {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    
                } else {
                    var name: String
                    var titleName: String
                    var albumName: String
                    var image: String
                    
                    let dict = json as! Dictionary<String, Any>
                    if let dictData = dict["data"] as? [[String:Any]] {
                        for arrayDict in dictData {
                            let title = arrayDict["title"]
                            let music = arrayDict["preview"] as! String
                            let artist = arrayDict["artist"] as? [String:Any]
                            let arrArtist = artist!["name"]
                            let imagePict = artist!["picture"]
                            
                            name = arrArtist as! String
                            image = imagePict as! String
                            
                            print("name: \(String(describing: arrArtist))")
                            print("image: \(String(describing: imagePict))")
                            
                            let album = arrayDict["album"] as? [String:Any]
                            let arrAlbum = album!["title"]
                            
                            albumName = arrAlbum as! String
                            
                            print("album: \(String(describing: arrAlbum))")
                            
                            titleName = title as! String
                            
                            print("title: \(String(describing: title))")
                            
                            searchTrack.append(Track(imageName: image, trackTitle: titleName, artistName: name, albumCover: albumName, isFavorite: "false", urlMusic: music))
                            
                        }
                    }
                    self.searchTableView.isHidden = false
                    self.logoImage.isHidden = true
                    self.searchTableView.reloadData()
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as? CustomTableViewCell)!
        cell.artistName.text = searchTrack[indexPath.row].artistName
        cell.trackTitle.text = searchTrack[indexPath.row].trackTitle
        cell.albumCover.text = searchTrack[indexPath.row].albumCover
        cell.trackImageView.sd_setImage(with: URL(string: searchTrack[indexPath.row].imageName), placeholderImage: UIImage(named: "placeholder.png"))
        cell.favoriteButton.tag = indexPath.row
        if searchTrack[indexPath.row].isFavorite == "false" {
            cell.favoriteButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.favoriteButton.addTarget(self, action: #selector(updateTrack(_:)), for:.touchUpInside)
            cell.favoriteButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "minus"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
