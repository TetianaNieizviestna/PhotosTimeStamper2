//
//  ArticleDetailsViewController.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 21.03.2021.
//

import UIKit
import CoreGraphics

protocol ArticleScreenDelegate: AnyObject {
    func didSaveBtnPressed()
}

extension EditPhotoViewController {
    struct Props {
        let title: String
        let image: UIImage?
        let stamp: String

        let onBack: Command
        
        static let initial: Props = .init(
            title: "",
            image: nil,
            stamp: "",
            onBack: .nop
        )
    }
}

final class EditPhotoViewController: UIViewController {
    var viewModel: EditPhotoViewModelType!
    var props: Props = .initial
    weak var delegate: ArticleScreenDelegate?
    
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var saveInListBtn: UIButton!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var stampLabel: UILabel!
    @IBOutlet private var cameraBtn: UIButton!
    @IBOutlet private var galleryBtn: UIButton!
    @IBOutlet private var showDataBtn: UIButton!
    @IBOutlet private var saveInGalleryBtn: UIButton!
    @IBOutlet private var shareBtn: UIButton!
    @IBOutlet private var printBtn: UIButton!
    
    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.didStateChanged = { [weak self] props in
            self?.render(props)
            self?.delegate?.didSaveBtnPressed()
        }
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
    
    func render(_ props: Props) {
        self.props = props
        photoImageView.image = props.image
        
        fitImageViewSize()
        
        stampLabel.text = props.stamp
        titleLabel.text = titleLabel.text
    }
    
    private func fitImageViewSize() {
        if let image = props.image {
            guard image.size.height > 0,
                  image.size.width > 0 else { return }

            let ratio = image.size.width / image.size.height
            if containerView.frame.width > containerView.frame.height {
                let newHeight = containerView.frame.width / ratio
                photoImageView.frame.size = CGSize(width: containerView.frame.width, height: newHeight)
            } else{
                let newWidth = containerView.frame.height * ratio
                photoImageView.frame.size = CGSize(width: newWidth, height: containerView.frame.height)
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
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
    
    @IBAction func cameraBtnAction(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        Permissions.checkAllowsCamera(target: self, imagePicker: imagePicker)
    }
    
    @IBAction func galleryBtnAction(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        Permissions.checkAllowsLibrary(target: self, imagePicker: imagePicker)
    }
    
    @IBAction func showDataBtnAction(_ sender: UIButton) {
        stampLabel.isHidden.toggle()
    }
    
    @IBAction func saveInGalleryBtnAction(_ sender: UIButton) {
        if let image = props.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func printBtnAction(_ sender: UIButton) {

    }
    
    @IBAction func saveInListBtnAction(_ sender: UIButton) {
        if props.title.isEmpty {
            let onCancel = AlertOptionWithText(title: "Cancel", action: .nop)
            let onOk = AlertOptionWithText(title: "Save", action: CommandWith { [weak self] text in
                self?.viewModel.changeTitle(text: text)
            })
            showAlertWithOptionsAndInput(title: "", message: "Please enter the photo title", options: [onCancel, onOk])
        }
        delegate?.didSaveBtnPressed()
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

            viewModel.setImage(fixedImage, path: imagePath.absoluteString)

            if let imageSource = CGImageSourceCreateWithURL(imagePath as CFURL, nil),
               let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?,
               let exifDict = imageProperties[kCGImagePropertyExifDictionary],
               let dateTimeOriginal = exifDict[kCGImagePropertyExifDateTimeOriginal] {
                viewModel.setStamp(text: "DATE: \(String(describing: dateTimeOriginal))")
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
