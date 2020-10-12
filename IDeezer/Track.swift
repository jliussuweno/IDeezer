//
//  Track.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import Foundation

class Track {
    
    var imageName: String
    var trackTitle: String
    var artistName: String
    var albumCover: String
    var isFavorite: String
    var urlMusic: String

    
    init(imageName: String, trackTitle: String, artistName: String, albumCover: String, isFavorite: String, urlMusic: String) {
        self.imageName = imageName
        self.trackTitle = trackTitle
        self.artistName = artistName
        self.albumCover = albumCover
        self.isFavorite = isFavorite
        self.urlMusic = urlMusic
    }
}
