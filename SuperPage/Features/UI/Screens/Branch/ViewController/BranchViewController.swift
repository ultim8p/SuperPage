//
//  BranchViewController.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/11/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

struct ViewControllerWrapper: PlatformViewControlerRepresentable {
    
    @Binding var messages: [Message]
    
    var sendMessageHandler: ((_ message: String) -> Void)?
    
#if os(macOS)
    typealias NSViewControllerType = ViewController
    
    func makeNSViewController(context: Context) -> ViewController {
        return makeViewController()
    }
    
    func updateNSViewController(_ nsViewController: ViewController, context: Context) {
        updateViewController(nsViewController, context: context)
        
    }
#elseif os(iOS)
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return makeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        updateViewController(uiViewController, context: context)
    }
#endif
    
    func makeViewController() -> ViewController {
        let viewController = ViewController(messages: messages, localMessages: messages)
        viewController.sendMessageHandler = sendMessageHandler
        return viewController
    }
    
    func updateViewController(_ viewController: ViewController, context: Context) {
        viewController.messages = messages
        viewController.localMessages = _messages.wrappedValue
        viewController.sendMessageHandler = sendMessageHandler
    }
}

class ViewController: PlatformViewControler {
    
    // MARK: - UIVariables
    
    private var initialContentOffset: CGPoint?
    
    var collectionView: NOCollectionView!
    
    var staticTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var toolBar: SendMessageToolBar!
    
    var wasScrolledToBottom = false
    
    var shouldScrollToBottom = true
    
    var stateWidthConstraint: NSLayoutConstraint!
    
    var isLoading = false {
        didSet {
            toolBar?.set(loading: isLoading)
        }
    }
    
    // MARK: - StateVariables
    
//    var branch: Branch
    
    var messages: [Message] {
        didSet {
            isLoading = false
        }
    }
    
    var localMessages: [Message] {
        didSet {
            reloadCells()
            view.reloadLayoutIfNeeded()
            if localMessages.count > 0 && shouldScrollToBottom {
                loadInitialState()
            }
        }
    }
    
    var sendMessageHandler: ((_ message: String) -> Void)?
    
    var newMessage: String = ""
    
    init(messages: [Message], localMessages: [Message]) {
        self.messages = messages
        self.localMessages = localMessages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constant {
        
        static let loadingHeight: CGFloat = 30.0
        
        static let minimumNewMessageHeight: CGFloat = 150.0
        
        
    }
    
    enum Sections: Int, CaseIterable {
        
        case messages
        
        case loading
        
        case newMessage
    }
    
#if os(macOS)
    override func loadView() {
        view = NOView(frame: .zero)
    }
#elseif os(iOS)
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.reloadCells()
        }, completion: { context in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.reloadCells()
            })
        })
    }
    
#endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolBar()
        setupTextView()
        setupCollectionView()
        view.reloadLayoutIfNeeded()
        collectionView.dataSource = self
        collectionView.delegate = self
        staticTextView.isHidden = true
        reloadStateConstraints()
    #if os(macOS)
        (view as? NOView)?.noBackgroundColor = PlatformColor(named: "branchScreenBackground")!
    #elseif os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        view.backgroundColor = PlatformColor(named: "branchScreenBackground")!
    #endif
    }
    
    // MARK: Setup
    
    
//    override func viewWillTransition(to newSize: NSSize) {
//        super.viewWillTransition(to: newSize)
//        print("VIEW WILL TRANSITION")
//    }
    
    private func setupToolBar() {
        toolBar = SendMessageToolBar.setup(in: view, handler: {
            self.sendNewMessage()
        })
    }
    
    private func setupTextView() {
        view.addSubview(staticTextView)
        staticTextView.translatesAutoresizingMaskIntoConstraints = false
        staticTextView.backgroundColor = PlatformColor.gray
        print("VIEW WIDTH: \(view.bounds.size.width)")
        NSLayoutConstraint.activate([
            staticTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            staticTextView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        stateWidthConstraint = staticTextView.widthAnchor.constraint(
            equalToConstant: NODevice.readableWidth(for: view.bounds.size.width))
        stateWidthConstraint.isActive = true
    }
    
    private func setupCollectionView() {
        collectionView = NOCollectionView()
        collectionView.noRegisterCell(cell: MessageCell.self)
        collectionView.noRegisterCell(cell: LoadingCell.self)
        setupCollectionScrollView()
    }

    func setupCollectionScrollView() {
#if os(macOS)
        let scrollView = NSScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = collectionView
        scrollView.drawsBackground = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
        ])
#elseif os(iOS)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
        ])
#endif
    }
    
    // MARK: State
    
    func reloadStateConstraints() {
        toolBar.reloadConstraints()
        stateWidthConstraint.constant = NODevice.readableWidth(for: view.bounds.size.width)
    }
    
    func loadInitialState() {
        
        self.collectionView?.scrollToBottom()
//        let cell = cellItem(at: IndexPath(item: 0, section: Sections.newMessage.rawValue))
//        cell.textView.noBecomeFirstResponder()
    }
    
    func reloadCells() {
        view.reloadLayoutIfNeeded()
        reloadStateConstraints()
        collectionView?.reloadData()
        view.reloadLayoutIfNeeded()
    }
    
    func messagesCount() -> Int {
        return localMessages.count
    }
    
    func newMessageCount() -> Int {
        return 1
    }
    
    func loadingSectionCount() -> Int {
        return isLoading ? 1 : 0
    }
    
    func item(at indexPath: IndexPath) -> Message? {
        guard indexPath.item < localMessages.count else { return nil }
        return localMessages[indexPath.item]
    }
    
    func cellItem(at indexPath: IndexPath) -> PlatformCollectionViewCell {
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            let cell: MessageCell = collectionView.noReusableCell(for: indexPath)
            cell.configure(message: item(at: indexPath), editable: false, width: view.bounds.size.width)
            cell.delegate = self
            return cell
        case .loading:
            let cell: LoadingCell = collectionView.noReusableCell(for: indexPath)
            return cell
        case .newMessage:
            let cell: MessageCell = collectionView.noReusableCell(for: indexPath)
            cell.configure(text: newMessage, editable: !isLoading, width: view.bounds.size.width)
            cell.delegate = self
            return cell
        }
    }
    
    func sizeForItem(at indexPath: IndexPath) -> PlatformSize {
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            let item = item(at: indexPath)?.text ?? ""
            staticTextView.noSetText(text: item)
            let textSize = staticTextView.targetTextSize
            let cellSize = PlatformSize(width: collectionView.bounds.size.width, height: textSize.height)
            return cellSize
        case .loading:
            return PlatformSize(width: collectionView.bounds.size.width, height: Constant.loadingHeight)
        case .newMessage:
            let item = newMessage
            staticTextView.noSetText(text: item)
            let textSize = staticTextView.targetTextSize
            let cellHeight = max(Constant.minimumNewMessageHeight, textSize.height)
            let cellSize = PlatformSize(width: collectionView.bounds.size.width, height: cellHeight)
            return cellSize
        }
    }
}

// MARK: - Actions

extension ViewController {
    
    func sendNewMessage() {
        guard !newMessage.isEmpty else { return }
        sendMessageHandler?(newMessage)
        
        isLoading = true
        
        let placeholderMessage = Message(role: .user, text: newMessage)
        localMessages.append(placeholderMessage)
        newMessage = ""
        collectionView.collectionLayout.invalidateLayout()
        reloadCells()
        updateCollectionLayoutForMessage(isNew: true)
    }
}

// MARK: - CollectionViewDatasource

extension ViewController: PlatformCollectionViewDatasource, PlatformCollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: PlatformCollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: PlatformCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .messages:
            return messagesCount()
        case .loading:
            return loadingSectionCount()
        case .newMessage:
            return newMessageCount()
        }
    }
    
    #if os(macOS)
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return cellItem(at: indexPath)
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> PlatformSize {
        return sizeForItem(at: indexPath)
    }
    
    #elseif os(iOS)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> PlatformSize {
        return sizeForItem(at: indexPath)
    }
    #endif
}

extension ViewController: MessageCellDelegate {
    
    func messageCell(_ item: MessageCell, didPerform shortcut: KeyboardShortcut) {
        switch shortcut {
        case .commandEnter:
            sendNewMessage()
        default:
            break
        }
    }
    
    func messageCellWillUpdateMessage(_ item: MessageCell) {
        wasScrolledToBottom = collectionView.isScrolledToBottom()
    }
    
    func messageCell(_ item: MessageCell, didUpdateMessage message: String) {
        guard let indexPath = collectionView.indexPath(for: item) else { return }
        switch Sections(rawValue: indexPath.section)! {
        case .messages:
            localMessages[indexPath.item].text = message
            updateCollectionLayoutForMessage(isNew: false)
        case .newMessage:
            newMessage = message
            updateCollectionLayoutForMessage(isNew: false)
        default:
            break
        }
    }
    
    func updateCollectionLayoutForMessage(isNew: Bool) {
        collectionView.collectionLayout.invalidateLayout()
        view.reloadLayoutIfNeeded()
        if wasScrolledToBottom || isNew {
            collectionView.scrollToBottom(animated: isNew)
        }
    }
}

#if os(iOS)

extension UIView.AnimationCurve {
    var animationOptions: UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: UInt(rawValue << 16))
    }
}

extension ViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//              let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
//              let animationCurveRawValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
//              let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRawValue)
//        else { return }
//        let keyboardHeight = keyboardFrame.height
//        initialContentOffset = collectionView.contentOffset
//        let safeAreaBottom = view.safeAreaInsets.bottom
//
//        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve.animationOptions, animations: {
//            if self.collectionView.isScrolledToBottom() {
//                self.collectionView.contentInset.bottom = keyboardFrame.height - safeAreaBottom
//                self.collectionView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height - safeAreaBottom
//                let targetOffset = max(0.0,  self.initialContentOffset!.y + keyboardHeight - safeAreaBottom)
//                self.collectionView.contentOffset = CGPoint(x: 0, y: targetOffset)
//            } else {
//                let targetOffset = max(0.0,  self.initialContentOffset!.y + keyboardHeight + safeAreaBottom)
//                self.collectionView.contentOffset = CGPoint(x: 0, y: targetOffset)
//            }
//            self.view.layoutIfNeeded()
//        }, completion: nil)
    }

    @objc func keyboardDidShow(notification: Notification) {
//        self.collectionView.contentInset.bottom = 0
//        self.collectionView.verticalScrollIndicatorInsets.bottom = 0
    }
}
#endif


