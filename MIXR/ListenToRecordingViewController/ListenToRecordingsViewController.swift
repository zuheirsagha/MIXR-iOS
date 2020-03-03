//
//  ListenToRecordingsViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit
import AVKit

class ListenToRecordingsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var songNames = ["Happy", "Happy LPF 800", "Mena Solo", "Mena Solo LPF"]
    var songLengths = ["4:30", "4:30", "1:35", "1:35"]
    var selectedSong = "Happy"
    
    var files : [URL]!
    var fileNames : [String]!
    var fileLengths : [Int]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var logo : UIImage
        if #available(iOS 13.0, *) {
            logo = (UIImage(named: "MIXRLogo")?.withTintColor(.black))!
        } else {
            logo = UIImage(named: "MIXRLogo")!
        }
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .black

        // Get all MOV files
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                                includingPropertiesForKeys: nil)
            
            files = directoryContents.filter{ $0.pathExtension == "wav" }
            fileNames = files.map{ $0.deletingPathExtension().lastPathComponent }
        } catch {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else { return UITableViewCell() }
        cell.nameLabel.text = fileNames[indexPath.row]
        cell.lengthLabel.text = "Length: \(fileNames[indexPath.row])"
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSong = fileNames[indexPath.row]
        performSegue(withIdentifier: "SelectedTrackSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayBackViewController {
            destinationVC.selectedSong = selectedSong
        }
    }
}


