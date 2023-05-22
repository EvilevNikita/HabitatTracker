//
//  ProfileView.swift
//  HabitatTracker
//
//  Created by Георгий Матченко on 20.05.2023.
//

import UIKit
import PhotosUI

class ProfileView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileProtocol{
    
    private let heightScreen = UIScreen.main.bounds.height
    private let presenter: ProfilePresenter

    //Delegates
    private weak var passInfoToProfileCell: PassInfoToAny?
    private weak var passInfoToHeader: PassSettingsForHeaderProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.setViewToDelegate(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //table view settings
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .myBackgorundColor
        tableView.isScrollEnabled = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseId)
        tableView.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: ProfileHeader.reuseId)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseId, for: indexPath) as? ProfileCell else { return UITableViewCell()}
            cell.backgroundColor = UIColor(named: "backgroundColor")
            passInfoToProfileCell = cell
            switch indexPath.row {
            case 0:
                let text = NSLocalizedString("Log out", comment: "log out row")
                let image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
                self.passInfoToProfileCell?.passInfo(info: (text, image))
                return cell
            default:
                return cell
            }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightScreen * 0.08
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            presenter.logOut()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileHeader.reuseId) as? ProfileHeader {
            passInfoToHeader = header
            header.passInfoBack = self
            let user = presenter.user
            header.headerSettings(user: user)
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightScreen * 0.27
    }

    //MARK: Image picker
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        return imagePickerController
    }
    
    func chooseImagePickerType() {
        let title = NSLocalizedString("Pick a photo", comment: "pick photo title")
        let message = NSLocalizedString("Choose a picture from", comment: "choose photo message")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let titleCamera = NSLocalizedString("Camera", comment: "camera action")
        let cameraAction = UIAlertAction(title: titleCamera, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true) {
                print("todo camera")
            }
        }
        
        let titleLibrary = NSLocalizedString("Library", comment: "labrary action")
        let libraryAction = UIAlertAction(title: titleLibrary, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true) {
                print("todo library")
            }
        }
        
        let titleCancel = NSLocalizedString("Cancel", comment: "cancel action")
        let cancel = UIAlertAction(title: titleCancel, style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        presenter.user.image = image
        self.tableView.reloadData()
        self.dismiss(animated: true)
    }
}

//info from header
extension ProfileView: PassInfoBack {
    func passInfo<T>(info: T) {
        if let _ = info as? Bool {
            chooseImagePickerType()
        } else if let index = info as? Int {
            presenter.user.selectedTheme = Theme(rawValue: index) ?? .device
            view.window?.overrideUserInterfaceStyle = presenter.user.selectedTheme.getUserInterfaceStyle()
        } else if let string = info as? String {
            presenter.user.name = string
        }
    }
}
