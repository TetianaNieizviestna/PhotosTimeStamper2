//
//  ArticleDetailsViewController.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import UIKit
import CoreGraphics
import AVFAudio

protocol EditPhotoScreenDelegate: AnyObject {
    func didSaveBtnPressed()
}

extension EditPhotoViewController {
    struct Props {
        let title: String
        let image: UIImage?
        let stamp: String
        let isSaved: Bool
        
        let onSetTitle: CommandWith<String>
        let onSetImage: CommandWith<(UIImage, String)>
        let onSetStamp: CommandWith<String>
        
        let onBack: Command
        
        static let initial: Props = .init(
            title: "",
            image: nil,
            stamp: "",
            isSaved: false,
            onSetTitle: .nop,
            onSetImage: .nop,
            onSetStamp: .nop,
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
    @IBOutlet private var saveInListBtn: UIButton!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var stampLabel: UILabel!
    @IBOutlet private var cameraBtn: GradientButton!
    @IBOutlet private var galleryBtn: GradientButton!
    @IBOutlet private var showDataBtn: GradientButton!
    @IBOutlet private var saveInGalleryBtn: GradientButton!
    @IBOutlet private var shareBtn: GradientButton!
    @IBOutlet private var printBtn: GradientButton!
    
    
    @IBOutlet private var ratioConstraint: NSLayoutConstraint!
    
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
        photoImageView.image = props.image
        
        fitImageViewSize()
        
        stampLabel.text = props.stamp
        titleLabel.text = titleLabel.text
    }
    
    private func setupUI() {
        configureImagePicker()
        setupButtons()
    }

    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
    }

    private func setupButtons() {

    }

    private func fitImageViewSize() {
        guard let image = props.image,
              image.size.height > 0,
              image.size.width > 0 else { return }
        
        let ratio = image.size.width / image.size.height
        
        ratioConstraint.constant = ratio
        
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
    
    @IBAction private func backBtnAction(_ sender: UIButton) {
        if props.isSaved {
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
    
    @IBAction private func cameraBtnAction(_ sender: UIButton) {
#if targetEnvironment(simulator)
        showAlert(title: "Info", message: "You are using simulator. Native camera crashes it.")
#else
        imagePicker.sourceType = .camera
        checkAllowsCamera() { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
#endif
    }
    
    @IBAction private func galleryBtnAction(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        checkPermissionsLibrary() { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction private func showDataBtnAction(_ sender: UIButton) {
        stampLabel.isHidden.toggle()
    }
    
    @IBAction private func saveInGalleryBtnAction(_ sender: UIButton) {
        if props.image != nil,
           let image = containerView.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            showChooseImageAlert()
        }
    }
    
    @IBAction private func shareBtnAction(_ sender: UIButton) {
        guard props.image != nil,
              let image: UIImage = containerView.toImage() else {
                  showChooseImageAlert()
                  return
              }
        
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
    
    @IBAction private func printBtnAction(_ sender: UIButton) {
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
    
    @IBAction private func saveInListBtnAction(_ sender: UIButton) {
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

            props.onSetImage.perform(with: (fixedImage, imagePath.absoluteString))
            
            if let imageSource = CGImageSourceCreateWithURL(imagePath as CFURL, nil),
               let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?,
               let exifDict = imageProperties[kCGImagePropertyExifDictionary],
               let dateTimeOriginal = exifDict[kCGImagePropertyExifDateTimeOriginal] {

                if let stamp = dateTimeOriginal as? String {
                    props.onSetStamp.perform(with: stamp)
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
