//
//  ArticleDetailsViewController.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import UIKit
import Photos

protocol EditPhotoScreenDelegate: AnyObject {
    func didSaveBtnPressed()
}

extension EditPhotoViewController {
    struct Props {
        let title: String
        let image: UIImage?
        let stamp: String
        let location: String
        let isSaved: Bool
        
        let onSetTitle: CommandWith<String>
        let onSetImage: CommandWith<(UIImage, String)>
        let onSetStamp: CommandWith<String>
        let onSetLocation: CommandWith<String>
        
        let onBack: Command
        
        static let initial: Props = .init(
            title: "",
            image: nil,
            stamp: "",
            location: "",
            isSaved: false,
            onSetTitle: .nop,
            onSetImage: .nop,
            onSetStamp: .nop,
            onSetLocation: .nop,
            onBack: .nop
        )
    }
}

final class EditPhotoViewController: UIViewController {
    var viewModel: EditPhotoViewModelType!
    var props: Props = .initial
    weak var delegate: EditPhotoScreenDelegate?
    
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var saveInListBtn: GradientButton!
    @IBOutlet private var photoImageView: UIImageView!

    @IBOutlet private var stampLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    
    @IBOutlet private var menuStackView: UIStackView!
    
    @IBOutlet private var chooseImageStackView: UIStackView!
    @IBOutlet private var cameraBtn: GradientButton!
    @IBOutlet private var galleryBtn: GradientButton!
    
    @IBOutlet private var timestampBtn: GradientButton!
    
    @IBOutlet private var locationBtn: GradientButton!
    @IBOutlet private var saveInGalleryBtn: GradientButton!
    @IBOutlet private var shareBtn: GradientButton!
    @IBOutlet private var printBtn: GradientButton!
    
    @IBOutlet private var addImageBtn: GradientButton!
    
    @IBOutlet private var heightImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private var widthImageViewConstraint: NSLayoutConstraint!

    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.didStateChanged = { [weak self] props in
            self?.render(props)
            self?.delegate?.didSaveBtnPressed()
        }
    }
    
    private func render(_ props: Props) {
        self.props = props
        if let image = props.image {
            photoImageView.image = image
        }
        fitImageViewSize()

        stampLabel.text = props.stamp
        locationLabel.text = props.location
        titleLabel.text = titleLabel.text
        addImageBtn.isHidden = props.image != nil
        updateShowDataBtn()
    }
    
    private func setupUI() {
        widthImageViewConstraint.constant = view.frame.width - 30
        configureImagePicker()
        photoImageView.setCornersRadius(6)
        setupButtons([
            saveInListBtn,
            cameraBtn,
            galleryBtn,
            timestampBtn,
            locationBtn,
            saveInGalleryBtn,
            shareBtn,
            printBtn,
            addImageBtn
        ])
    }

    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
    }

    private func fitImageViewSize() {
        var height = photoImageView.intrinsicContentSize.height * photoImageView.bounds.width / photoImageView.intrinsicContentSize.width
        var width = view.frame.width - 30
        let multiplier: CGFloat = 0.8
        
        if height > view.frame.height * multiplier {
            height *= multiplier
            width *= multiplier
            widthImageViewConstraint.constant = width
        }
        
        heightImageViewConstraint.constant = height
        
        if photoImageView.frame.width > photoImageView.frame.height {
            photoImageView.contentMode = .scaleAspectFit
            //since the width > height we may fit it and we'll have bands on top/bottom
        } else {
            photoImageView.contentMode = .scaleToFill
            //width < height we fill it until width is taken up and clipped on top/bottom
        }
        
        view.layoutSubviews()
    }
    
    private func showChooseImageAlert() {
        showAlert(title: "Error", message: "Please choose the image")
    }
    
    private func saveInList(with title: String) {
        props.onSetTitle.perform(with: title)
        delegate?.didSaveBtnPressed()
        props.onBack.perform()
    }
    
    private func updateShowDataBtn() {
        let stampBtnImage = (stampLabel.isHidden || props.stamp.isEmpty) ? Style.Image.timestampOn : Style.Image.timestampOff
        let locationBtnImage = (locationLabel.isHidden || props.location.isEmpty) ? Style.Image.locationOn : Style.Image.locationOff
        timestampBtn.setImageForAllStates(stampBtnImage)
        locationBtn.setImageForAllStates(locationBtnImage)
    }
    
    private func showShareController(image: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func saveInList() {
        if props.title.isEmpty {
            let onCancel = AlertOptionWithText(
                title: "Cancel",
                action: .nop
            )
            let onOk = AlertOptionWithText(
                title: "Save",
                action: CommandWith { [weak self] text in
                    self?.saveInList(with: text)
                }
            )
            showAlertWithOptionsAndInput(
                title: "",
                message: "Please enter the photo title",
                options: [onCancel, onOk]
            )
        } else {
            saveInList(with: props.title)
        }
    }
    
    @IBAction private func backBtnAction(_ sender: GradientButton) {
        if props.isSaved {
            props.onBack.perform()
        } else if props.image == nil {
            props.onBack.perform()
        } else {
            let options = [
                AlertOption(
                    title: "No",
                    action: .nop
                ),
                AlertOption(
                    title: "Yes",
                    action: props.onBack
                ),
            ]
            showAlertWithOptions(
                title: "",
                message: "Photo will not save. Are you sure?",
                options: options
            )
        }
    }
    
    @IBAction private func cameraBtnAction(_ sender: GradientButton) {
#if targetEnvironment(simulator)
        showAlert(title: "Info", message: "You are using simulator. Native camera crashes it.")
#else
        imagePicker.sourceType = .camera
        checkPermissionsCamera() { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
#endif
    }
    
    @IBAction private func galleryBtnAction(_ sender: GradientButton) {
        imagePicker.sourceType = .photoLibrary
        checkPermissionsLibrary() { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction private func timestampBtnAction(_ sender: GradientButton) {
        stampLabel.isHidden.toggle()
        updateShowDataBtn()
    }
    
    @IBAction func locationBtnAction(_ sender: GradientButton) {
        locationLabel.isHidden.toggle()
        updateShowDataBtn()
    }
    
    @IBAction private func saveInGalleryBtnAction(_ sender: GradientButton) {
        if props.image != nil,
           let image = containerView.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            saveInList()
        } else {
            showChooseImageAlert()
        }
    }
    
    @IBAction private func shareBtnAction(_ sender: GradientButton) {
        guard props.image != nil,
              let image: UIImage = containerView.toImage() else {
                  showChooseImageAlert()
                  return
              }
        showShareController(image: image)
    }
    
    @IBAction private func printBtnAction(_ sender: GradientButton) {
        guard props.image != nil else {
            showChooseImageAlert()
            return
        }
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "Photo with real date stamp"

        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = self.containerView.toImage()
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
    
    @IBAction private func saveInListBtnAction(_ sender: GradientButton) {
        if props.title.isEmpty {
            let onCancel = AlertOptionWithText(
                title: "Cancel",
                action: .nop
            )
            let onOk = AlertOptionWithText(
                title: "Save",
                action: CommandWith { [weak self] text in
                    self?.saveInList(with: text)
                }
            )
            showAlertWithOptionsAndInput(
                title: "",
                message: "Please enter the photo title",
                options: [onCancel, onOk]
            )
        } else {
            saveInList(with: props.title)
        }
    }
    
    @IBAction func addImageBtnAction(_ sender: GradientButton) {
        chooseImageStackView.isHidden.toggle()
    }
    
    deinit {
        print("deinit \(self.self)")
    }
}

// MARK: UIImagePicker
extension EditPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage,
           let imagePath = info[.imageURL] as? URL,
           let fixedImage = pickedImage.fixedOrientation() {
            chooseImageStackView.isHidden = true

            props.onSetImage.perform(with: (fixedImage, imagePath.absoluteString))
                         
            if let pickedAsset = info[.phAsset] as? PHAsset {
                if let date = pickedAsset.creationDate {
                    props.onSetStamp.perform(with: "\(date)")
                }
                if let location = pickedAsset.location {
                    props.onSetLocation.perform(with: "<\(location.coordinate.latitude), \(location.coordinate.longitude)>")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let onOk = AlertOption(title: "OK", action: .nop)
            showAlertWithOptions(title: "Save error", message: error.localizedDescription, options: [onOk])
        } else {
            let onOk = AlertOption(title: "OK", action: props.onBack)
            showAlertWithOptions(title: "Saved!", message: "Your image has been saved to your photos.", options: [onOk])
        }
    }
}
