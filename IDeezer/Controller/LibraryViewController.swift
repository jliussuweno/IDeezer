//
//  LibraryViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit
import SDWebImage

class LibraryViewController: UIViewController {
    
    //MARK: - Props
    @IBOutlet weak var libraryTableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    var libraryTrack = [Track]()
    var dbManager = DatabaseManager()
    
    //MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
        libraryTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "libraryCell")
        dbManager.initDB()
        libraryTrack = dbManager.readDBValueTrack()
        libraryTableView.reloadData()
        hiddenTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        libraryTrack = dbManager.readDBValueTrack()
        libraryTableView.reloadData()
        hiddenTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        libraryTrack = dbManager.readDBValueTrack()
        libraryTableView.reloadData()
        hiddenTable()
    }
    
    //MARK: - Custom Methods
    func hiddenTable(){
        if libraryTrack.count == 0 {
            libraryTableView.isHidden = true
            logoImage.isHidden = false
        } else {
            libraryTableView.isHidden = false
            logoImage.isHidden = true
        }
    }
    
    @objc func updateTrack(_ sender: UIButton){
        let tag = sender.tag
        let track = Track(imageName: libraryTrack[tag].imageName, trackTitle: libraryTrack[tag].trackTitle, artistName: libraryTrack[tag].artistName, albumCover: libraryTrack[tag].albumCover, isFavorite: "false", urlMusic: libraryTrack[tag].urlMusic)
        dbManager.deleteSavedDataTrack(inputData: track)
        
        for track in homeTrack {
            if track.trackTitle.contains(libraryTrack[tag].trackTitle) {
                if track.artistName.contains(libraryTrack[tag].artistName){
                    track.isFavorite = "false"
                }
            }
        }
        
        for track in searchTrack {
            if track.trackTitle.contains(libraryTrack[tag].trackTitle) {
                if track.artistName.contains(libraryTrack[tag].artistName){
                    track.isFavorite = "false"
                }
            }
        }
    }
    
    @objc func reload(){
        libraryTrack = dbManager.readDBValueTrack()
        libraryTableView.reloadData()
        hiddenTable()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryTrack.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (libraryTableView.dequeueReusableCell(withIdentifier: "libraryCell") as? CustomTableViewCell)!
        cell.artistName.text = libraryTrack[indexPath.row].artistName
        cell.trackTitle.text = libraryTrack[indexPath.row].trackTitle
        cell.albumCover.text = libraryTrack[indexPath.row].albumCover
        cell.trackImageView.sd_setImage(with: URL(string: libraryTrack[indexPath.row].imageName), placeholderImage: UIImage(named: "placeholder.png"))
        cell.favoriteButton.tag = indexPath.row
        if libraryTrack[indexPath.row].isFavorite == "false" {
            cell.favoriteButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "minus"), for: .normal)
            cell.favoriteButton.addTarget(self, action: #selector(updateTrack(_:)), for:.touchUpInside)
            cell.favoriteButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
