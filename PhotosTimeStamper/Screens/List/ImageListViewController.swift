//
//  NewsViewController.swift
//  ViVNewsApp
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
        
        let onRefresh: Command
        
        let items: [StampedImageTableViewCell.Props]
        static let initial: Props = .init(state: .initial, onRefresh: .nop, items: [])
    }
}

final class ImageListViewController: UIViewController {
    var viewModel: ImageListViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var addPhotoBtn: UIButton!
    
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.didStateChanged = { [weak self] props in
            self?.render(props)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh()
    }
    
    private func setupUI() {
        setupTableView()
    }

    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([StampedImageTableViewCell.identifier])
        tableView.tableFooterView = UIView(frame: .zero)

        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        props.onRefresh.perform()
    }
    
    func render(_ props: Props) {
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
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        viewModel.addNewPhotoScreen()
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

extension ImageListViewController: ArticleScreenDelegate {
    func didSaveBtnPressed() {
        self.props.onRefresh.perform()
    }
}
