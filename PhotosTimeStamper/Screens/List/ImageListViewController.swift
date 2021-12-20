//
//  NewsViewController.swift
//  PhotosTimeStamper
//
//  Created by Tetiana Nieizviestna on 19.03.2021.
//

import UIKit

extension ImageListViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        
        let onAddPhoto: Command
        let onRefresh: Command
        
        let items: [StampedImageTableViewCell.Props]
        
        static let initial: Props = .init(
            state: .initial,
            onAddPhoto: .nop,
            onRefresh: .nop,
            items: []
        )
    }
}

final class ImageListViewController: UIViewController {
    var viewModel: ImageListViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var titleLabel: UILabel!
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
        props.onAddPhoto.perform()
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StampedImageTableViewCell.identifier) as? StampedImageTableViewCell else { return UITableViewCell() }
        cell.render(props.items[indexPath.row])
        return cell
    }
}

extension ImageListViewController: EditPhotoScreenDelegate {
    func didSaveBtnPressed() {
        props.onRefresh.perform()
    }
}
