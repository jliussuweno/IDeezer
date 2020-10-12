//
//  HomeViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit
import SDWebImage
import MBProgressHUD

var homeTrack = [Track]()

class HomeViewController: UIViewController {
    
    //MARK: - Props
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    var dbManager = DatabaseManager()
    var soundUrl = ""
    var imageUrl = ""
    
    //MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dbManager.initDB()
        dbManager.deleteSavedData()
        dbManager.createTableTrack()
        greetingLabel.text = "Selamat Datang, \(userActive.email)!"
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "homeCell")
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeTableView.reloadData()
    }
    
    //MARK: - Custom Methods
    func loadData(){
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.isUserInteractionEnabled = false
        Indicator.detailsLabel.text = "fetching recommended track for you"
        Indicator.show(animated: true)
        
        let myURLRequest = UrlRequestBuilder().buildUrlRequestDeezer(artist: "Tulus")
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
                            
                            homeTrack.append(Track(imageName: image, trackTitle: titleName, artistName: name, albumCover: albumName, isFavorite: "false", urlMusic: music))
                            
                        }
                    }
                    self.homeTableView.reloadData()
                }
            }
        }
    }
    
    @objc func reload(){
        homeTableView.reloadData()
    }
    
    @objc func updateTrack(_ sender: UIButton){
        let tag = sender.tag
        homeTrack[tag].isFavorite = "true"
        let track = Track(imageName: homeTrack[tag].imageName, trackTitle: homeTrack[tag].trackTitle, artistName: homeTrack[tag].artistName, albumCover: homeTrack[tag].albumCover, isFavorite: "true", urlMusic: homeTrack[tag].urlMusic)
        dbManager.saveDBValueTrack(inputData: track)
    }
    
    func navigateToTrackViewController(soundName: String, image: String){
        performSegue(withIdentifier: "playSegue", sender: self)
        soundUrl = soundName
        imageUrl = image
        print("sound url : \(soundUrl)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            let destinationVC = segue.destination as! TrackViewController
            destinationVC.soundName = soundUrl
            destinationVC.imageURLView = imageUrl
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (homeTableView.dequeueReusableCell(withIdentifier: "homeCell") as? CustomTableViewCell)!
        cell.artistName.text = homeTrack[indexPath.row].artistName
        cell.trackTitle.text = homeTrack[indexPath.row].trackTitle
        cell.albumCover.text = homeTrack[indexPath.row].albumCover
        cell.trackImageView.sd_setImage(with: URL(string: homeTrack[indexPath.row].imageName), placeholderImage: UIImage(named: "placeholder.png"))
        if homeTrack[indexPath.row].isFavorite == "false" {
            cell.favoriteButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "minus"), for: .normal)
        }
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.layer.cornerRadius = 10
        cell.favoriteButton.clipsToBounds = true
        cell.favoriteButton.addTarget(self, action: #selector(updateTrack(_:)), for: .touchUpInside)
        cell.favoriteButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToTrackViewController(soundName: homeTrack[indexPath.row].urlMusic, image: homeTrack[indexPath.row].imageName)
    }
}
