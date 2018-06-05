//
//  DevedorCell.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 24/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import Foundation
import UIKit

protocol DevedorCellDelegate {
    func devedorCellDidIncrease(_ devedor: Devedor)
    func devedorCellDidDecrease(_ devedor: Devedor)
}

class DevedorCell : UITableViewCell {
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    
    var delegate: DevedorCellDelegate?
    
    let gradientLayer = CAGradientLayer()
    var tickLabel: UILabel!, crossLabel: UILabel!
    var incrementarDivida = false, decrementarDivida = false
    var originalCenter = CGPoint()
    
    var devedor: Devedor? {
        didSet {
            self.nomeLabel.text = devedor!.nome
            self.quantidadeLabel.text = "\(devedor!.quantidade)"
        }
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    func setupCell() {
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.3).cgColor
        let color2 = UIColor(white: 1.0, alpha: 0.2).cgColor
        let color3 = UIColor.clear.cgColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.null)
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.backgroundColor = UIColor.clear
            return label
        }
        
        tickLabel = createCueLabel()
        tickLabel.text = "+"
        tickLabel.textAlignment = .right
        crossLabel = createCueLabel()
        crossLabel.text = "-"
        crossLabel.textAlignment = .left        
        
        addSubview(tickLabel)
        addSubview(crossLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
                                 width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
                                  width: kUICuesWidth, height: bounds.size.height)
        gradientLayer.frame = bounds
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            originalCenter = center
        }
        else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
            incrementarDivida = frame.origin.x > frame.size.width / 3.0
            decrementarDivida = frame.origin.x < -frame.size.width / 3.0
            
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 3.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = incrementarDivida ? UIColor.green : UIColor.black
            crossLabel.textColor = decrementarDivida ? UIColor.red : UIColor.black
        }
        else if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if incrementarDivida {
                self.quantidadeLabel.text = "\(Int(self.quantidadeLabel.text!)! + 1)"
                if let cellDelegate = delegate {
                    cellDelegate.devedorCellDidIncrease(devedor!)
                }
            }
            if decrementarDivida {
                if Int(self.quantidadeLabel.text!)! > 0 {
                    self.quantidadeLabel.text = "\(Int(self.quantidadeLabel.text!)! - 1)"
                }
                if let cellDelegate = delegate {
                    cellDelegate.devedorCellDidDecrease(devedor!)
                }
            }
            UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
}
