//
//  ListenToRecordingsViewController.swift
//  MIXR
//
//  Created by Zuheir Chikh Al Sagha on 2019-07-21.
//  Copyright © 2019 MIXR. All rights reserved.
//

import UIKit

class ListenToRecordingsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var songNames = ["Happy", "Happy LPF 800", "Mena Solo", "Mena Solo LPF"]
    var songLengths = ["4:30", "4:30", "1:35", "1:35"]
    var selectedSong = "Happy"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let logo = UIImage(named: "MIXRLogoBlack")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else { return UITableViewCell() }
        cell.nameLabel.text = songNames[indexPath.row]
        cell.lengthLabel.text = "Length: \(songLengths[indexPath.row])"
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSong = songNames[indexPath.row]
        performSegue(withIdentifier: "SelectedTrackSegue", sender: self)
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToHomeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayBackViewController {
            destinationVC.selectedSong = selectedSong
        }
    }
}
