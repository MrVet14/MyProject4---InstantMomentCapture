//
//  ViewController.swift
//  MyProject4 - InstantMomentCapture
//
//  Created by Vitali Vyucheiski on 4/12/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var moments = [Moment]()
    var editMode = false
    var deleteMode = false
    var VCLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "InstantMoments"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMoment))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editNewMoment))
        
        navigationItem.leftBarButtonItems = [addButton, editButton]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMoment))
        
        save()
        
        VCLoaded = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MomentCell else { fatalError("Unable to dequeue PersonCell") }
        
        let moment = moments[indexPath.item]
        
        cell.NameOfCell.text = moment.name
        
        let path = getDocumentsDirectory().appendingPathComponent(moment.image)
        cell.imageOfCell.image = UIImage(contentsOfFile: path.path)
        cell.separatorInset = .zero
        
        return cell
    }
    
    @objc func addNewMoment() {
        if deleteMode { deleteMoment() }
        if editMode { editNewMoment() }
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    @objc func editNewMoment() {
        editMode.toggle()
        if deleteMode { deleteMode.toggle() }
        if editMode {
            title = "Edit Mode"
        } else {
            title = "InstantMomentsCapture"
        }
    }
    
    @objc func deleteMoment() {
        if editMode { editMode.toggle() }
        deleteMode.toggle()
        if deleteMode {
            title = "Delete Mode"
        } else {
            title = "InstantMomentsCapture"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let moment = Moment(name: "Edit ME 😉", image: imageName)
        moments.append(moment)
        tableView.reloadData()
        save()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let moment = moments[indexPath.item]
        
        if editMode {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()

            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                moment.name = newName
                self?.save()
                self?.tableView.reloadData()
            })

            present(ac, animated: true)
        } else if deleteMode {
            moments.remove(at: indexPath.row)
            save()
            tableView.reloadData()
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.moments = self.moments
                vc.momentNumber = indexPath.row
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        if VCLoaded {
            if let savedData = try? jsonEncoder.encode(moments) {
                
                defaults.set(savedData, forKey: "moments")
            } else {
                print("Failed to save Moments")
            }
        } else {
            if let savedMoments = defaults.object(forKey: "moments") as? Data {
                let jsonDecoder = JSONDecoder()

                do {
                    moments = try jsonDecoder.decode([Moment].self, from: savedMoments)
                } catch {
                    print("Failed to load Moments")
                }
            }
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
//    }
    
}

