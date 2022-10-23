//
//  SupportViewController.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 22.10.2022.
//

import UIKit

extension SupportViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        let title: String
        let appVersionText: String
        
        let onSave: Command
        
        let items: [MenuTableViewCell.Props]
        
        static let initial: Props = .init(
            state: .initial,
            title: "",
            appVersionText: "",
            onSave: .nop,
            items: []
        )
    }
}

final class SupportViewController: UIViewController {
    var viewModel: SupportViewModel!
    var props: Props = .initial
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var addPhotoBtn: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData()
        
        viewModel.didStateChanged = { [weak self] props in
            self?.render(props)
        }
    }
    
    private func render(_ props: Props) {
        self.props = props

        switch props.state {
        case .initial:
            view.stopHud()
        case .loading:
            view.startHud()
        case .loaded:
            view.stopHud()
        case .failed(let error):
            view.stopHud()
            showAlert(title: "Error", message: error)
        }
        
        titleLabel.text = props.title
        tempLabel.text = props.appVersionText
        tableView.reloadData()
    }
    
    private func setupUI() {
        setupTableView()
        setupButtons([addPhotoBtn])
    }

    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([MenuTableViewCell.identifier])
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        props.onSave.perform()
    }
}

extension SupportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
}

extension SupportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier) as? MenuTableViewCell else { return UITableViewCell() }
        cell.render(props.items[indexPath.row])
        return cell

    }
}
