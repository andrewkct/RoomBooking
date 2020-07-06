//
//  SortViewController.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import UIKit

protocol SortViewControllerDelegate: class {
    func didApplySorting(type: String?)
}

class SortViewController: UIViewController {
    @IBOutlet weak var imgViewSnapshot: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var handlerView: UIView!
    @IBOutlet weak var tblSort: UITableView!
    @IBOutlet weak var btnReset: CustomButton!
    @IBOutlet weak var btnApply: CustomButton!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    
    weak var delegate: SortViewControllerDelegate?
    var snapshotImage: UIImage?
    var viewModel: SortViewModel!
    
    private let sortTableViewCellId = String(describing: SortTableViewCell.self)
    private var cardPanStartingTopConstant : CGFloat = 100.0
    
    init(_ viewModel: SortViewModel, delegate: SortViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setObervations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    private func configureView() {
        imgViewSnapshot.image = snapshotImage
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        handlerView.layer.cornerRadius = 3.0
        
        // Hide the card view at the bottom when the view first load
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
        dimmerView.alpha = 0.0
        
        let stvcNib = UINib(nibName: sortTableViewCellId, bundle: nil)
        tblSort.register(stvcNib, forCellReuseIdentifier: sortTableViewCellId)
    }
    
    private func setObervations() {
        viewModel.data.observe(on: self) { [weak self] (items) in
            self?.tblSort.reloadData()
        }
    }
    
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer?) {
        showCard(isHidden: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        viewModel.reset()
    }
    
    @IBAction func applyAction(_ sender: Any) {
        delegate?.didApplySorting(type: viewModel.applyAndGetSortType())
        dimmerViewTapped(nil)
    }
    
    private func showCard(isHidden: Bool = false) {
        // Ensure there's no pending layout changes before animation runs
        view.layoutIfNeeded()
        
        // Set the new top constraint value for card view
        // Card view won't move up or down just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
          
            cardViewTopConstraint.constant = isHidden ? safeAreaHeight + bottomPadding : 100
        }
        
        // Move card up from or down to bottom by telling
        // the app to refresh the frame/position of view
        // Create a new property animator
        let card = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // Show or hide dimmer view
        // This will animate the dimmerView alpha together with
        // the card move up or down animation
        card.addAnimations({
            self.dimmerView.alpha = isHidden ? 0.0 : 0.7
        })
        
        // When the animation completes, position == .end means the animation has ended
        // Dismiss this view controller (if there is a presenting view controller)
        card.addCompletion { (position) in
            if position == .end && isHidden {
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
        card.startAnimation()
    }
}

extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sortTableViewCellId, for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }
               
        cell.set(viewModel.data.value[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension SortViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectAt(indexPath)
    }
}
