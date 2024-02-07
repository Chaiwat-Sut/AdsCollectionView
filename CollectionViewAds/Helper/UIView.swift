import UIKit

protocol NSLayoutConstraintAttributeConvertable {
    var attribute: NSLayoutConstraint.Attribute { get }
}

extension UIView {
    enum Layout {
        enum Dimension: NSLayoutConstraintAttributeConvertable {
            case width
            case height
            
            var attribute: NSLayoutConstraint.Attribute {
                switch self {
                case .width:
                    return .width
                case .height:
                    return .height
                }
            }
        }
        
        enum Dimensions {
            case all
            
            var dimensions: [Dimension] {
                [.width, .height]
            }
        }
        
        enum Axis: NSLayoutConstraintAttributeConvertable {
            // X
            case left
            case right
            case centerX
            // Y
            case top
            case bottom
            case centerY
            case lastBaseline
            case firstBaseline
            
            var attribute: NSLayoutConstraint.Attribute {
                switch self {
                    // X
                case .left:
                    return .left
                case .right:
                    return .right
                case .centerX:
                    return .centerX
                    // Y
                case .top:
                    return .top
                case .bottom:
                    return .bottom
                case .centerY:
                    return .centerY
                case .lastBaseline:
                    return .lastBaseline
                case .firstBaseline:
                    return .firstBaseline
                }
            }
        }
        
        enum Axes {
            case all
            case top
            case right
            case bottom
            case left
            case horizontal
            case vertical
            case center
            case topLeft
            case topRight
            case bottomLeft
            case bottomRight
            
            var axes: [Axis] {
                switch self {
                case .all:
                    return [.top, .right, .bottom, .left]
                case .top:
                    return [.top, .right, .left]
                case .right:
                    return [.top, .right, .bottom]
                case .bottom:
                    return [.right, .bottom, .left]
                case .left:
                    return [.top, .bottom, .left]
                case .horizontal:
                    return [.right, .left]
                case .vertical:
                    return [.top, .bottom]
                case .center:
                    return [.centerX, .centerY]
                case .topLeft:
                    return [.top, .left]
                case .topRight:
                    return [.top, .right]
                case .bottomLeft:
                    return [.bottom, .left]
                case .bottomRight:
                    return [.bottom, .right]
                }
            }
        }
    }
    
    // NSLayoutConstraint
    @discardableResult
    private func anchor<T: NSLayoutConstraintAttributeConvertable>(attributable: T,
                                                                   relation: NSLayoutConstraint.Relation = .equal,
                                                                   toItem item: UIView? = nil,
                                                                   itemAttributable: T? = nil,
                                                                   multiplier: CGFloat = 1,
                                                                   constant: CGFloat = 0,
                                                                   priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = .init(item: self,
                                                   attribute: attributable.attribute,
                                                   relatedBy: relation,
                                                   toItem: item,
                                                   attribute: item == nil ? .notAnAttribute : itemAttributable?.attribute ?? attributable.attribute,
                                                   multiplier: multiplier,
                                                   constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    private func getAxisLayoutConstraint(attribute: Layout.Axis,
                                         relation: NSLayoutConstraint.Relation = .equal,
                                         toItem item: UIView,
                                         attribute itemAttribute: Layout.Axis? = nil) -> NSLayoutConstraint? {
        var attributes: [NSLayoutConstraint.Attribute] = [attribute.attribute]
        switch attribute {
        case .right:
            attributes += [.trailing]
        case .left:
            attributes += [.leading]
        default:
            break
        }
        return attributes
            .compactMap({ attribute in
                superview.flatMap({ superview in
                    superview.constraints.first(where: { constraint in
                        guard
                            let firstItem = constraint.firstItem as? UIView,
                            let secondItem = constraint.secondItem as? UIView
                        else {
                            return false
                        }
                        let views = [self, item]
                        return views.contains(firstItem)
                            && constraint.firstAttribute == attribute
                            && constraint.relation == relation
                            && views.contains(secondItem)
                            && constraint.secondAttribute == itemAttribute?.attribute ?? attribute
                    })
                })
            })
            .first
    }
    
    private func getDimensionLayoutConstraint(attribute: NSLayoutConstraint.Attribute,
                                              relation: NSLayoutConstraint.Relation,
                                              toItem: UIView? = nil,
                                              attribute itemAttribute: NSLayoutConstraint.Attribute? = nil) -> NSLayoutConstraint? {
        (toItem.isNotNil ? superview : self).flatMap({
            $0.constraints.first(where: { constraint in
                (constraint.firstItem as? UIView) == self
                    && constraint.firstAttribute == attribute
                    && constraint.relation == relation
                    && (constraint.secondItem as? UIView) == toItem
                    && constraint.secondAttribute == (toItem.isNotNil ? itemAttribute ?? attribute : .notAnAttribute)
            })
        })
    }
    
    private func update(_ layoutConstraint: NSLayoutConstraint,
                        constant: CGFloat? = nil,
                        priority: UILayoutPriority? = nil) {
        if let constant = constant {
            layoutConstraint.constant = constant
        }
        if let priority = priority {
            layoutConstraint.priority = priority
        }
    }
    
    // Dimension
    @discardableResult
    func anchor(dimension attribute: Layout.Dimension,
                relation: NSLayoutConstraint.Relation = .equal,
                toItem item: UIView? = nil,
                dimension itemAttribute: Layout.Dimension? = nil,
                multiplier: CGFloat = 1,
                constant: CGFloat = 0,
                priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        anchor(attributable: attribute,
               relation: relation,
               toItem: item,
               itemAttributable: itemAttribute,
               multiplier: multiplier,
               constant: constant,
               priority: priority)
    }
    
    @discardableResult
    func updateAnchor(dimension attribute: Layout.Dimension,
                      relation: NSLayoutConstraint.Relation = .equal,
                      toItem item: UIView? = nil,
                      dimension itemAttribute: Layout.Dimension? = nil,
                      constant: CGFloat? = nil,
                      priority: UILayoutPriority? = nil) -> NSLayoutConstraint? {
        getDimensionLayoutConstraint(attribute: attribute.attribute,
                                     relation: relation,
                                     toItem: item,
                                     attribute: itemAttribute?.attribute)
            .flatMap({
                update($0,
                       constant: constant,
                       priority: priority)
                return $0
            })
    }
    
    func removeAnchor(
        dimension attribute: Layout.Dimension,
        relation: NSLayoutConstraint.Relation = .equal,
        toItem item: UIView? = nil,
        dimension itemAttribute: Layout.Dimension? = nil
    ) {
        getDimensionLayoutConstraint(
            attribute: attribute.attribute,
            relation: relation,
            toItem: item,
            attribute: itemAttribute?.attribute)?.isActive = false
    }
    
    @discardableResult
    func anchorToSuperView(dimension attribute: Layout.Dimension,
                           relation: NSLayoutConstraint.Relation = .equal,
                           dimension itemAttribute: Layout.Dimension? = nil,
                           multiplier: CGFloat = 1,
                           constant: CGFloat = 0,
                           priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        superview.flatMap({
            anchor(dimension: attribute,
                   relation: relation,
                   toItem: $0,
                   dimension: itemAttribute,
                   multiplier: multiplier,
                   constant: constant,
                   priority: priority)
        })
    }
    
    @discardableResult
    func updateAnchorToSuperView(dimension attribute: Layout.Dimension,
                                 relation: NSLayoutConstraint.Relation = .equal,
                                 dimension itemAttribute: Layout.Dimension? = nil,
                                 constant: CGFloat? = nil,
                                 priority: UILayoutPriority? = nil) -> NSLayoutConstraint? {
        superview.flatMap({
            updateAnchor(dimension: attribute,
                         relation: relation,
                         toItem: $0,
                         dimension: itemAttribute,
                         constant: constant,
                         priority: priority)
        })
    }
    
    // Dimensions
    @discardableResult
    func anchorDimensions(relation: NSLayoutConstraint.Relation = .equal,
                          toItem item: UIView? = nil,
                          multiplier: CGFloat = 1,
                          size: CGSize = .zero,
                          priority: UILayoutPriority = .required) -> [Layout.Dimension: NSLayoutConstraint?] {
        .init(uniqueKeysWithValues: Layout.Dimensions.all.dimensions.compactMap({
            ($0, anchor(dimension: $0,
                        toItem: item,
                        multiplier: multiplier,
                        constant: $0.getConstant(from: size),
                        priority: priority))
        }))
    }
    
    @discardableResult
    func updateAnchorDimensions(relation: NSLayoutConstraint.Relation = .equal,
                                toItem item: UIView? = nil,
                                size: CGSize? = nil,
                                priority: UILayoutPriority? = nil) -> [Layout.Dimension: NSLayoutConstraint?] {
        .init(uniqueKeysWithValues: Layout.Dimensions.all.dimensions.compactMap({ dimension in
            (dimension, updateAnchor(dimension: dimension,
                                     relation: relation,
                                     toItem: item,
                                     constant: size.flatMap(dimension.getConstant),
                                     priority: priority))
        }))
    }
    
    @discardableResult
    func anchorToSuperViewDimensions(relation: NSLayoutConstraint.Relation = .equal,
                                     multiplier: CGFloat = 1,
                                     size: CGSize = .zero,
                                     priority: UILayoutPriority = .required) -> [Layout.Dimension: NSLayoutConstraint?]? {
        superview.flatMap({
            anchorDimensions(relation: relation,
                             toItem: $0,
                             multiplier: multiplier,
                             size: size,
                             priority: priority)
        })
    }
    
    @discardableResult
    func updateAnchorToSuperViewDimensions(relation: NSLayoutConstraint.Relation = .equal,
                                           size: CGSize? = nil,
                                           priority: UILayoutPriority? = nil) -> [Layout.Dimension: NSLayoutConstraint?]? {
        superview.flatMap({
            updateAnchorDimensions(relation: relation,
                                   toItem: $0,
                                   size: size,
                                   priority: priority)
        })
    }
    
    // Axis
    @discardableResult
    func anchor(axis attribute: Layout.Axis,
                relation: NSLayoutConstraint.Relation = .equal,
                toItem item: UIView,
                axis itemAttribute: Layout.Axis? = nil,
                constant: CGFloat = 0,
                priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        anchor(attributable: attribute,
               relation: attribute.getTranslateRelation(with: relation),
               toItem: item,
               itemAttributable: itemAttribute,
               constant: attribute.getTranslateConstant(with: constant),
               priority: priority)
    }
    
    @discardableResult
    func updateAnchor(axis attribute: Layout.Axis,
                      relation: NSLayoutConstraint.Relation = .equal,
                      toItem item: UIView,
                      axis itemAttribute: Layout.Axis? = nil,
                      constant: CGFloat? = nil,
                      priority: UILayoutPriority? = nil) -> NSLayoutConstraint? {
        getAxisLayoutConstraint(attribute: attribute,
                                relation: relation,
                                toItem: item,
                                attribute: itemAttribute)
            .flatMap({ constraint in
                update(constraint,
                       constant: constant.flatMap({ attribute.getTranslateConstant(with: $0, isTrailing: constraint.firstAttribute == .trailing || constraint.secondAttribute == .trailing) }),
                       priority: priority)
                return constraint
            })
    }
    
    func removeAnchor(
        axis attribute: Layout.Axis,
        relation: NSLayoutConstraint.Relation = .equal,
        toItem item: UIView,
        axis itemAttribute: Layout.Axis? = nil
    ) {
        getAxis(
            attribute: attribute,
            relation: relation,
            toItem: item,
            attribute: itemAttribute)?.isActive = false
    }
    
    @discardableResult
    func anchorToSuperView(axis attribute: Layout.Axis,
                           relation: NSLayoutConstraint.Relation = .equal,
                           itemAttribute: Layout.Axis? = nil,
                           constant: CGFloat = 0,
                           priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        superview.flatMap({
            anchor(axis: attribute,
                   relation: relation,
                   toItem: $0,
                   axis: itemAttribute,
                   constant: constant,
                   priority: priority)
        })
    }
    
    @discardableResult
    func updateAnchorToSuperView(axis attribute: Layout.Axis,
                                 relation: NSLayoutConstraint.Relation = .equal,
                                 axis itemAttribute: Layout.Axis? = nil,
                                 constant: CGFloat? = nil,
                                 priority: UILayoutPriority? = nil) -> NSLayoutConstraint? {
        superview.flatMap({
            updateAnchor(axis: attribute,
                         relation: relation,
                         toItem: $0,
                         axis: itemAttribute,
                         constant: constant,
                         priority: priority)
        })
    }
    
    func removeAnchorToSuperView(
        axis attribute: Layout.Axis,
        relation: NSLayoutConstraint.Relation = .equal,
        axis itemAttribute: Layout.Axis? = nil
    ) {
        superview.flatMap({
            getAxis(
                attribute: attribute,
                relation: relation,
                toItem: $0,
                attribute: itemAttribute)?.isActive = false
        })
    }
    
    // Axes
    @discardableResult
    func anchor(axes attribute: Layout.Axes = .all,
                relation: NSLayoutConstraint.Relation = .equal,
                toItem item: UIView,
                insets: UIEdgeInsets = .zero) -> [Layout.Axis: NSLayoutConstraint?] {
        .init(uniqueKeysWithValues: attribute.axes.compactMap({
            ($0, anchor(axis: $0,
                        relation: relation,
                        toItem: item,
                        constant: $0.getConstant(from: insets)))
        }))
    }
    
    @discardableResult
    func updateAnchor(axes attribute: Layout.Axes = .all,
                      relation: NSLayoutConstraint.Relation = .equal,
                      toItem item: UIView,
                      insets: UIEdgeInsets = .zero) -> [Layout.Axis: NSLayoutConstraint?] {
        .init(uniqueKeysWithValues: attribute.axes.compactMap({
            ($0, updateAnchor(axis: $0,
                              relation: relation,
                              toItem: item,
                              constant: $0.getConstant(from: insets)))
        }))
    }
    
    func removeAnchor(
        axes: Layout.Axes = .all,
        relation: NSLayoutConstraint.Relation = .equal,
        toItem item: UIView
    ) {
        axes.axes.forEach({
            removeAnchor(
                axis: $0,
                relation: relation,
                toItem: item,
                axis: $0)
        })
    }
    
    @discardableResult
    func anchorToSuperView(axes attribute: Layout.Axes = .all,
                           relation: NSLayoutConstraint.Relation = .equal,
                           insets: UIEdgeInsets = .zero) -> [Layout.Axis: NSLayoutConstraint?]? {
        superview.flatMap({
            anchor(axes: attribute,
                   relation: relation,
                   toItem: $0,
                   insets: insets)
        })
    }
    
    @discardableResult
    func updateAnchorToSuperView(axes attribute: Layout.Axes = .all,
                                 relation: NSLayoutConstraint.Relation = .equal,
                                 insets: UIEdgeInsets = .zero) -> [Layout.Axis: NSLayoutConstraint?]? {
        superview.flatMap({
            updateAnchor(axes: attribute,
                         relation: relation,
                         toItem: $0,
                         insets: insets)
        })
    }
    
    func removeAnchorToSuperView(
        axes: Layout.Axes = .all,
        relation: NSLayoutConstraint.Relation = .equal
    ) {
        superview.flatMap({ view in
            axes.axes.forEach({
                removeAnchor(
                    axis: $0,
                    relation: relation,
                    toItem: view,
                    axis: $0)
            })
        })
    }
}

extension Dictionary where Key == UIView.Layout.Axis, Value == NSLayoutConstraint? {
    func update(axes: UIView.Layout.Axes = .all, insets: UIEdgeInsets) {
        axes.axes.forEach({
            self[$0]??.constant = $0.getTranslateConstant(from: insets)
        })
    }
}

fileprivate extension UIView.Layout.Axis {
    func getConstant(from insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top:
            return insets.top
        case .right:
            return insets.right
        case .bottom:
            return insets.bottom
        case .left:
            return insets.left
        default:
            return .zero
        }
    }
    
    func getTranslateConstant(with constant: CGFloat, isTrailing: Bool = false) -> CGFloat {
        switch self {
        case .right where !isTrailing:
            return -constant
        case .bottom:
            return -constant
        default:
            return constant
        }
    }
    
    func getTranslateConstant(from insets: UIEdgeInsets) -> CGFloat {
        getTranslateConstant(with: getConstant(from: insets))
    }
    
    func getTranslateRelation(with relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint.Relation {
        switch self {
        case .right,
             .bottom:
            switch relation {
            case .lessThanOrEqual:
                return .greaterThanOrEqual
            case .equal:
                return relation
            case .greaterThanOrEqual:
                return .lessThanOrEqual
            @unknown default:
                return relation
            }
        default:
            return relation
        }
    }
}

fileprivate extension UIView.Layout.Dimension {
    func getConstant(from size: CGSize) -> CGFloat {
        switch self {
        case .width:
            return size.width
        case .height:
            return size.height
        }
    }
}

extension UIView {
    func getAxis(
        attribute: Layout.Axis,
        relation: NSLayoutConstraint.Relation = .equal,
        toItem item: UIView,
        attribute itemAttribute: Layout.Axis? = nil
    ) -> NSLayoutConstraint? {
        getAxisLayoutConstraint(
            attribute: attribute,
            relation: relation,
            toItem: item,
            attribute: attribute)
    }
    
    func getAxisToSuperView(
        attribute: Layout.Axis,
        relation: NSLayoutConstraint.Relation = .equal,
        attribute itemAttribute: Layout.Axis? = nil
    ) -> NSLayoutConstraint? {
        superview.flatMap({
            getAxis(
                attribute: attribute,
                relation: relation,
                toItem: $0,
                attribute: attribute)
        })
    }
    
    func getDimension(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        toItem item: UIView? = nil,
        attribute itemAttribute: NSLayoutConstraint.Attribute? = nil
    ) -> NSLayoutConstraint? {
        getDimensionLayoutConstraint(
            attribute: attribute,
            relation: relation,
            toItem: item,
            attribute: attribute)
    }
    
    func getDimensionToSuperView(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        attribute itemAttribute: NSLayoutConstraint.Attribute? = nil
    ) -> NSLayoutConstraint? {
        superview.flatMap({
            getDimension(
                attribute: attribute,
                relation: relation,
                toItem: $0,
                attribute: attribute)
        })
    }
}
