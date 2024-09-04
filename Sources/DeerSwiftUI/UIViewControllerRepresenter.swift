#if os(iOS) || os(tvOS) || os(visionOS)
import SwiftUI
import UIKit

@available(iOS 16.0, tvOS 16.0, visionOS 1.0, *)
public struct UIViewControllerRepresenter<
    ViewController: UIViewController,
    Coordinator
>: UIViewControllerRepresentable {
    private let makeCoordinatorHandler: @MainActor () -> Coordinator
    private let makeUIViewControllerHandler: @MainActor (Context) -> ViewController
    private let updateUIViewControllerHandler: @MainActor (ViewController, Context) -> Void
    private let sizeThatFitsHandler: @MainActor (ProposedViewSize, ViewController, Context) -> CGSize?

    public init(
        makeCoordinator: @escaping @MainActor () -> Coordinator = { () },
        makeUIViewController: @escaping @MainActor (Context) -> ViewController,
        updateUIViewController: @escaping @MainActor (ViewController, Context) -> Void = { _, _ in },
        sizeThatFits: @escaping @MainActor (ProposedViewSize, ViewController, Context) -> CGSize? = { _, _, _ in nil }
    ) {
        self.makeCoordinatorHandler = makeCoordinator
        self.makeUIViewControllerHandler = makeUIViewController
        self.updateUIViewControllerHandler = updateUIViewController
        self.sizeThatFitsHandler = sizeThatFits
    }

    public func makeCoordinator() -> Coordinator {
        makeCoordinatorHandler()
    }

    public func makeUIViewController(context: Context) -> ViewController {
        makeUIViewControllerHandler(context)
    }

    public func updateUIViewController(_ viewController: ViewController, context: Context) {
        updateUIViewControllerHandler(viewController, context)
    }

    @available(iOS 16.0, tvOS 16.0, *)
    @MainActor public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiViewController: ViewController,
        context: Context
    ) -> CGSize? {
        sizeThatFitsHandler(proposal, uiViewController, context)
    }
}
#endif
