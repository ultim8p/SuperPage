//
//  BranchViewController.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/11/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class BranchViewController: NOViewController {
    
    // MARK: - UIVariables
    
    private var initialContentOffset: CGPoint?
    
    var collectionView: NOCollectionView!
    
    var staticTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var toolBar: SendMessageToolBar!
    
    var wasScrolledToBottom = false
    
    var shouldScrollToBottom = true
    
    var stateWidthConstraint: NSLayoutConstraint!
    
    var systemRoleView: SystemRoleView!
    
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
    
    var chatMode: Bool
    
    var localChatMode: Bool {
        didSet {
            toolBar?.set(chatMode: localChatMode)
        }
    }
    
    var systemRole: String
        
    
    var localSystemRole: String {
        didSet {
            toolBar?.set(systemRole: !localSystemRole.isEmpty)
        }
    }
    
//    var chatMode: Bool
    
//    var localChatMode: Bool
    
    var sendMessageHandler: ((_ message: String) -> Void)?
    
    var saveContextHandler: ((_ systemRole: String, _ chatMode: Bool) -> Void)?
    
    var newMessage: String = ""
    
    var messageCellHeights: [CGFloat] = []
    
    var totalMessagesHeights: CGFloat {
        var total: CGFloat = 0.0
        for height in messageCellHeights {
            total += height
        }
        return total
    }
    
    init(messages: [Message], localMessages: [Message],
         chatMode: Bool, localChatMode: Bool,
         systemRole: String, localSystemRole: String) {
        self.messages = messages
        self.localMessages = localMessages
        self.chatMode = chatMode
        self.localChatMode = localChatMode
        self.systemRole = systemRole
        self.localSystemRole = localSystemRole
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constant {
        
        static let loadingHeight: CGFloat = 30.0
        
        static let minimumNewMessageHeight: CGFloat = 150.0
        
        static let messageSpace: CGFloat = 10.0
    }
    
    enum Sections: Int, CaseIterable {
        
        case messages
        
        case loading
        
        case newMessage
    }
    
#if os(macOS)
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
        setupView()
        
    }
    
    // MARK: Setup
    
    func setupView() {
        setupToolBar()
        setupTextView()
        setupCollectionView()
        
        view.reloadLayoutIfNeeded()
        
        setupPlatform()
        reloadStateConstraints()
        
    }
    
    func setupPlatform() {
#if os(macOS)
    (view as? NOView)?.noBackgroundColor = SuperColor.branchBackground
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
    view.backgroundColor = SuperColor.branchBackground
#endif
    }
    
    private func setupToolBar() {
        toolBar = SendMessageToolBar.setup(in: view)
        toolBar.onSend(handler: sendNewMessage)
        toolBar.onSystemRole {
            self.showSystemRole()
        }
        toolBar.onChatMode {
            self.localChatMode = !self.localChatMode
            self.saveContext()
        }
    }
    
    private func setupTextView() {
        view.addSubview(staticTextView)
        staticTextView.translatesAutoresizingMaskIntoConstraints = false
        staticTextView.backgroundColor = PlatformColor.gray
        NSLayoutConstraint.activate([
            staticTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            staticTextView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        stateWidthConstraint = staticTextView.widthAnchor.constraint(
            equalToConstant: NODevice.readableWidth(for: view.bounds.size.width))
        stateWidthConstraint.isActive = true
        staticTextView.isHidden = true
    }
    
    private func showSystemRole() {
        guard systemRoleView == nil else {
            systemRoleView.popover?.noDismiss(animated: true)
            return
        }
        
        systemRoleView = SystemRoleView()
        let fromRect = toolBar.systemRoleFrame()
        let size = NODevice.popoverSize(for: view.frame.size)
        systemRoleView.show(in: self, fromRect: fromRect, relativeTo: toolBar.frame, size: size)
        systemRoleView.onTextChange { text in
            self.localSystemRole = text
        }
        systemRoleView.set(text: localSystemRole)
        systemRoleView.popover?.onDismiss(handler: {
            self.saveContext()
            self.systemRoleView = nil
        })
    }
    
    func saveContext() {
        saveContextHandler?(localSystemRole, localChatMode)
    }
    
    private func setupCollectionView() {
        collectionView = NOCollectionView()
        collectionView.noRegisterCell(cell: MessageCell.self)
        collectionView.noRegisterCell(cell: LoadingCell.self)
        setupCollectionScrollView()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupCollectionScrollView() {
    #if os(macOS)
        let scrollView = NSScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = collectionView
        scrollView.drawsBackground = false
        view.addSubview(scrollView)
        scrollView.onFullTop(to: view).onTop(to: toolBar)
    #elseif os(iOS)
        view.addSubview(collectionView)
        collectionView.onFullTop(to: view).onTop(to: toolBar)
    #endif
    }
    
    // MARK: State
    
    func reloadMessageHeights() {
        messageCellHeights = []
        for message in localMessages {
            staticTextView.noSetText(text: message.text ?? "")
            let textHeight = staticTextView.targetTextSize.height +
            MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
            messageCellHeights.append(textHeight)
        }
    }
    
    func appendCellHeightFor(message: Message) {
        staticTextView.noSetText(text: message.text ?? "")
        let textHeight = staticTextView.targetTextSize.height +
        MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
        messageCellHeights.append(textHeight)
    }
    
    func set(systemRole: String) {
        localSystemRole = systemRole
    }
    
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
        reloadMessageHeights()
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
            guard indexPath.item < messageCellHeights.count else {
                return PlatformSize(width: collectionView.bounds.size.width, height: 0.0)
            }
            let cellHeight = messageCellHeights[indexPath.item]
            return PlatformSize(width: collectionView.bounds.size.width, height: cellHeight)
        case .loading:
            return PlatformSize(width: collectionView.bounds.size.width, height: Constant.loadingHeight)
        case .newMessage:
            let item = newMessage
            staticTextView.noSetText(text: item)
            let textHeight = staticTextView.targetTextSize.height +
            MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
            
            var cellHeight = 0.0
            
            let cellHeights = totalMessagesHeights + (CGFloat(loadingSectionCount()) * Constant.loadingHeight)
            
            let cvHeight = collectionView.collectionHeight
            if cellHeights < cvHeight {
                cellHeight = cvHeight - cellHeights
            }
            
            cellHeight = max(textHeight, max(Constant.minimumNewMessageHeight, cellHeight))
            
            let cellSize = PlatformSize(width: collectionView.bounds.size.width, height: cellHeight)
            return cellSize
        }
    }
}

#if os(iOS)

extension UIView.AnimationCurve {
    var animationOptions: UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: UInt(rawValue << 16))
    }
}

extension BranchViewController {
    
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


