//
//  DetailViewController.swift
//  MyProject4 - InstantMomentCapture
//
//  Created by Vitali Vyucheiski on 4/12/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageToDisplay: UIImageView!
    var moments = [Moment]()
    var momentNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moment = moments[momentNumber]
        let path = getDocumentsDirectory().appendingPathComponent(moment.image)
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        title = moment.name
        navigationItem.largeTitleDisplayMode = .never
        
        imageToDisplay.image = UIImage(contentsOfFile: path.path)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        let moment = moments[momentNumber]
        let path = getDocumentsDirectory().appendingPathComponent(moment.image)
        
        let image = UIImage(contentsOfFile: path.path)
        
        let vc = UIActivityViewController(activityItems: [image!, moment.name], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
