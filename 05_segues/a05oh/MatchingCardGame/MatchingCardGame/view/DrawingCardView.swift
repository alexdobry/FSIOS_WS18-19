//
//  DrawingCardView.swift
//  MatchingCardGame
//
//  Created by Alex Dobrynin on 06.11.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

fileprivate extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

fileprivate extension Card {
    
    var image: UIImage? {
        let r: String
        
        switch rank {
        case .J:
            r = "jack"
        case .Q:
            r = "queen"
        case .K:
            r = "king"
        case .A:
            r = "ace"
        case _:
            r = rank.rawValue
        }
        
        let s: String
        
        switch suit {
        case .club:
            s = "clubs"
        case .diamond:
            s = "diamonds"
        case .heart:
            s = "hearts"
        case .spade:
            s = "spades"
        }
        
        return UIImage(named: "\(r)_of_\(s)")
    }
}

protocol DrawingCardViewDelegate {
    func drawingCardView(_ cardView: DrawingCardView, flippedWith card: Card?)
}

@IBDesignable
final class DrawingCardView: UIView {
    
    @IBInspectable
    var lineColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) { didSet { redraw() } }
    
    @IBInspectable
    var cardColor: UIColor = #colorLiteral(red: 0.8412953019, green: 0.2027314007, blue: 0.5099305511, alpha: 1) { didSet { redraw() } }
    
    @IBInspectable
    var lines: Int = 12 { didSet { redraw() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5 { didSet { redraw() } }
    
    @IBInspectable
    var matched: Bool = false {
        didSet {
            let duration = 1.0
            
            UIView.animate(
                withDuration: duration / 2,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
                completion: { _ in
                    UIView.animate(
                        withDuration: duration / 2,
                        animations: {
                            self.transform = CGAffineTransform.identity
                            self.alpha = self.matched ? 0.5 : 1.0
                        }
                    )
                }
            )
            
            isUserInteractionEnabled = !matched
        }
    }
    
    var card: Card? {
        didSet {
            UIView.transition(
                with: self,
                duration: 0.3,
                options: card != nil ? .transitionFlipFromLeft : .transitionFlipFromRight,
                animations: redraw,
                completion: nil
            )
        }
    }
    
    var delegate: DrawingCardViewDelegate?
    
    override func draw(_ rect: CGRect) {
        if let card = card {
            UIColor.white.setFill()
            pathForRoundedRect().fill()
            
            card.image?.draw(in: bounds)
        } else {
            cardColor.setFill()
            pathForRoundedRect().fill()
            
            lineColor.setStroke()
            pathFor(lines: lines).stroke()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardViewTapped)))
    }
    
    @objc func cardViewTapped() {
        delegate?.drawingCardView(self, flippedWith: card)
    }
    
    private func redraw() {
        setNeedsDisplay()
    }
    
    private func pathForRoundedRect() -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: 4.0)
    }
    
    private func pathFor(lines: Int) -> UIBezierPath {
        func drawLine(at path: UIBezierPath, with offset: CGFloat) {
            path.move(to: path.currentPoint.offsetBy(dx: 0, dy: offset))
            
            let direction = path.currentPoint.x == bounds.minX ? 1 : -1
            path.addLine(to: path.currentPoint.offsetBy(dx: CGFloat(direction) * bounds.maxX, dy: 0))
        }
        
        func rotate(_ path: UIBezierPath, by angle: CGFloat, offsettedBy offset: CGFloat) {
            path.lineWidth = lineWidth
            path.apply(CGAffineTransform(translationX: -bounds.midX, y: -bounds.midY))
            path.apply(CGAffineTransform(scaleX: 2.0, y: 1))
            path.apply(CGAffineTransform(rotationAngle: angle))
            path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY - ((offset + (lineWidth / 2)) / 2)))
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        
        let offset = bounds.height / CGFloat(lines)
        
        (1...lines).forEach { _ in
            drawLine(at: path, with: offset)
        }
        
        rotate(path, by: -CGFloat.pi / 4, offsettedBy: offset)
        
        return path
    }
}
