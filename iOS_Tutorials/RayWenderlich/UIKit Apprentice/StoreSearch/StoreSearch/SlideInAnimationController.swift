import UIKit

class SlideInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
       let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
      let containerView = transitionContext.containerView
      toView.frame = transitionContext.finalFrame(for: toViewController)
      containerView.addSubview(toView)
      let time = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: time, animations: {
        toView.center.y = containerView.bounds.size.height
        toView.center.y -= containerView.bounds.size.height / 2
      }, completion: { finished in
        transitionContext.completeTransition(finished)
      }
      )
    }
  }
}
//    UIView.animate(withDuration: time, animations: {
//      fromView.center.y -= containerView.bounds.size.height
//      fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//    }, completion: { finished in
//      transitionContext.completeTransition(finished)
  

