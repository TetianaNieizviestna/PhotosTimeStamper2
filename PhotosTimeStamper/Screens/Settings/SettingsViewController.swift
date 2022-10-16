//
//  SettingsViewController.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 16.10.2022.
//

import UIKit

extension SettingsViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        let title: String
        let tempLabelText: String
        
        let onSave: Command
        let onRefresh: Command
        
        let items: [StampedImageTableViewCell.Props]
        
        static let initial: Props = .init(
            state: .initial,
            title: "",
            tempLabelText: "",
            onSave: .nop,
            onRefresh: .nop,
            items: []
        )
    }
}

final class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tempImageView: UIImageView!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var addPhotoBtn: GradientButton!
    
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.didStateChanged = { [weak self] props in
            self?.render(props)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        props.onRefresh.perform()
    }
    
    private func render(_ props: Props) {
        self.props = props

        switch props.state {
        case .initial:
            view.stopHud()
        case .loading:
            view.startHud()
        case .loaded:
            refreshControl.endRefreshing()
            view.stopHud()
        case .failed(let error):
            refreshControl.endRefreshing()
            view.stopHud()
            showAlert(title: "Error", message: error)
        }
        
        titleLabel.text = props.title
        tempLabel.text = props.tempLabelText
        tempImageView.image = Style.Image.settingsBig
        self.tableView.reloadData()
    }
    
    private func setupUI() {
        setupTableView()
        setupButtons([addPhotoBtn])
    }

    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([StampedImageTableViewCell.identifier])
        tableView.tableFooterView = UIView(frame: .zero)

        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc
    private func refresh(_ sender: AnyObject) {
        props.onRefresh.perform()
    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        props.onSave.perform()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StampedImageTableViewCell.identifier) as? StampedImageTableViewCell else { return UITableViewCell() }
        cell.render(props.items[indexPath.row])
        return cell
    }
}

extension SettingsViewController: EditPhotoScreenDelegate {
    func didSaveBtnPressed() {
        props.onRefresh.perform()
    }
}
