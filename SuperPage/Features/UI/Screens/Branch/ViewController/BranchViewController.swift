//
//  BranchViewController.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/11/23.
//

import Foundation
import Combine
import SwiftUI
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
    
    var systemRoleView: AttatchmentView!
    
    var models = AIModel.allModels
    var localModel = AIModel.allModels.first!
    
    var errorView = ErrorView()
    
    var selectedMessagesIndexPaths: [IndexPath: Bool] = [:]
    var selectedMessagesIds: [String: Bool] = [:]
    
    // MARK: - StateVariables
    
    var chatInteractor: ChatInteractor
    
    private var _selectedBranchId: Branch.ID?
    var selectedBranchId: Branch.ID? {
        get {
            return _selectedBranchId
        }
        set {
            if let newValue, _selectedBranchId != newValue, _selectedBranchId != nil {
                loadBranch(newValue)
            }
            _selectedBranchId = newValue
        }
    }
    
    var branch: Branch?
    
    var draft: MessageDraft?
    
    var messages: [Message] = []
    
    var systemRole: String
    
    var localSystemRole: String {
        didSet {
            toolBar?.set(systemRole: !localSystemRole.isEmpty)
        }
    }
    
    var sendMessageHandler: ((_ message: String, _ model: AIModel, _ messageIds: [String]) -> Void)?
    
    var saveContextHandler: ((_ systemRole: String) -> Void)?
    
    var newMessage: String = ""
    
    var messageCellHeights: [CGFloat] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    var totalMessagesHeights: CGFloat {
        var total: CGFloat = 0.0
        for height in messageCellHeights {
            total += height
        }
        return total
    }
    
    init(
         systemRole: String, localSystemRole: String,
         selectedBranchId: Branch.ID?,
         chatInteractor: ChatInteractor
    ) {
        self.systemRole = systemRole
        self.localSystemRole = localSystemRole
        self.chatInteractor = chatInteractor
        super.init(nibName: nil, bundle: nil)
        self.selectedBranchId = selectedBranchId
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
        
        case drafts
        
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
        
        bindViewModel()
        loadBranch(selectedBranchId)
    }
    
    // MARK: Setup
    
    func setupView() {
        setupToolBar()
        setupTextView()
        setupCollectionView()
        setupPopUps()
        view.reloadLayoutIfNeeded()
        
        setupPlatform()
        reloadStateConstraints()
    }
    
    func setupPopUps() {
        view.addSubview(errorView)
        errorView
            .safeTop(to: view, const: 10.0)
            .centerX(to: view)
            .width(500.0)
    }
    
    func bindViewModel() {
        chatInteractor.$chats.sink { [weak self] chats in
            self?.didUpdateChats(chats)
        }.store(in: &cancellables)
        
        chatInteractor.$drafts.sink { [weak self] drafts in
            self?.didUpdate(drafts: drafts)
        }.store(in: &cancellables)
    }
    
    func didUpdateChats(_ chats: [Chat]) {
        guard
            let branch = chats.branch(for: branch)?.branch
        else { return }
        
        guard hasChanges(for: branch) else { return }
        let messagesChanged = messagesChanged(for: branch)
        
        self.branch = branch
        messages = branch.messages ?? []
        
        if hasDraft && hasError {
            newMessage = draft?.messages?.first?.text ?? ""
        }
        
        reloadCells()
        reloadToolBarState()
        reloadErrorState()
//        selectDefaultMessages()
        
        if messagesChanged {
            self.scrollToBottom()
        }
    }
    
    func hasChanges(for branch: Branch) -> Bool {
        stateChanged(for: branch) ||
        messagesChanged(for: branch) ||
        loadingStateChanged(for: branch) ||
        createErrorChanged(for: branch)
    }
    
    func didUpdate(drafts: [String: MessageDraft]) {
        guard
            let branchId = branch?._id,
            let draft = drafts[branchId]
        else {
            if self.draft != nil {
                self.draft = nil
                reloadCells()
            }
            return
        }
        
        guard hasChanges(for: draft) else { return }
        
        self.draft = draft
        if branch?.state != .creatingMessage {
            newMessage = draft.messages?.first?.text ?? ""
        }
        reloadCells()
    }
    
    func hasChanges(for draft: MessageDraft) -> Bool {
        self.draft?._id != draft._id ||
        self.draft?.messages?.count != draft.messages?.count ||
        self.draft?.messages?.first?.text != draft.messages?.first?.text
    }
    
    
    
    func reloadErrorState() {
        errorView.isHidden = !hasError
        errorView.configure(error: branch?.createMessageError)
    }
    
    func stateChanged(for branch: Branch) -> Bool {
        branch.state != self.branch?.state
    }
    
    func loadingStateChanged(for branch: Branch) -> Bool {
        branch.loadingState != self.branch?.loadingState
    }
    
    func messagesChanged(for branch: Branch) -> Bool {
        branch.messages?.count ?? 0 != messages.count ||
        branch.messages?.last?._id != messages.last?._id
    }
    
    func createErrorChanged(for branch: Branch) -> Bool {
        branch.createMessageError != self.branch?.createMessageError
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
        
        toolBar.messagesSelected {
            if self.hasMessageSelection {
                self.deselectMessages()
                self.saveContext()
            } else {
                self.selectDefaultMessages()
            }
        }
        
        toolBar.onModel { [weak self] in
            guard let self else { return }
            guard !models.isEmpty else { return }

            if let currentIndex = models.firstIndex(where: { $0.name == self.localModel.name }) {
                if currentIndex == models.count - 1 {
                    self.localModel = models[0]
                } else {
                    self.localModel = models[currentIndex + 1]
                }
            }
            
            self.reloadToolBarState()
        }
    }
    
    var textWidth: CGFloat {
        NODevice.readableWidth(for: view.bounds.size.width)
    }
    
    private func setupTextView() {
        view.addSubview(staticTextView)
        staticTextView.translatesAutoresizingMaskIntoConstraints = false
        staticTextView.backgroundColor = NOColor.gray
        staticTextView.lead(to: view).top(to: view)
        staticTextView.isHidden = true
    }
    
    private func showSystemRole() {
        guard systemRoleView == nil else {
            systemRoleView.popover?.noDismiss(animated: true)
            return
        }
        
        systemRoleView = AttatchmentView()
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
        saveContextHandler?(localSystemRole)
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
    
    var isLoading: Bool {
        branch?.loadingState == .loading
    }
    
    var isCreating: Bool {
        branch?.state == .creatingMessage
    }
    
//    var error: Error? {
//        switch branch?.state ?? .none {
//        case let .error(error):
//            return error
//        default:
//            return nil
//        }
//    }
//
//    var hasError: Bool {
//        error != nil
//    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        guard let hasMessage = selectedMessagesIndexPaths[indexPath] else { return false }
        return hasMessage
    }
    
    func isSelected(message: Message?) -> Bool {
        guard let id = message?._id, let hasMessage = selectedMessagesIds[id] else { return false }
        return hasMessage
    }
    
    func toggleSelection(at indexPath: IndexPath) {
        guard let message = item(at: indexPath), let id = message._id else { return }
        
        if selectedMessagesIndexPaths[indexPath] == true {
            selectedMessagesIndexPaths.removeValue(forKey: indexPath)
            selectedMessagesIds.removeValue(forKey: id)
        } else {
            selectedMessagesIndexPaths[indexPath] = true
            selectedMessagesIds[id] = true
        }
        
        reloadToolBarState()
    }
    
    
    var hasMessageSelection: Bool {
        selectedMessagesIds.count > 0
    }
    
    func deselectMessages() {
        selectedMessagesIndexPaths = [:]
        selectedMessagesIds = [:]
        reloadToolBarState()
        reloadCells()
    }
    
    func selectDefaultMessages() {
        guard
            messages.count >= 2
        else { return }
        let message1 = messages[messagesCount() - 1]
        let message2 = messages[messagesCount() - 2]
         
        selectedMessagesIds[message1.id] = true
        selectedMessagesIds[message2.id] = true
        selectedMessagesIndexPaths[IndexPath(item: messagesCount() - 1, section: Sections.messages.rawValue)] = true
        selectedMessagesIndexPaths[IndexPath(item: messagesCount() - 2, section: Sections.messages.rawValue)] = true
        
        reloadCells()
        reloadToolBarState()
    }
    
    func reloadItem(at indexPath: IndexPath) {
        let visibleItems = collectionView.visibleItems()
        for visibleItem in visibleItems {
            guard
                let visibleIndexPath = collectionView.indexPath(for: visibleItem),
                visibleIndexPath == indexPath,
                let messageCell = visibleItem as? MessageCell
            else { continue }
            configure(cell: messageCell, for: visibleIndexPath)
        }
    }
    
    func reloadMessageHeights() {
        messageCellHeights = []
        let maxWidth = textWidth
        for message in messages {
            staticTextView.noSetText(text: message.text ?? "")
            let textSize = staticTextView.targetTextSize(targetWidth: maxWidth)
            let textHeight = textSize.height +
            MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
            messageCellHeights.append(textHeight)
        }
    }
    
    func appendCellHeightFor(message: Message) {
        staticTextView.noSetText(text: message.text ?? "")
        let textSize = staticTextView.targetTextSize(targetWidth: textWidth)
        let textHeight = textSize.height + MessageCell.Constant.topSpace + MessageCell.Constant.bottomSpace
        messageCellHeights.append(textHeight)
    }
    
    func set(systemRole: String) {
        localSystemRole = systemRole
    }
    
    func reloadStateConstraints() {
        toolBar.reloadConstraints()
    }
    
    func loadBranch(_ branchId: Branch.ID?) {
        guard let branchId else {
            clearState()
            return
        }
        
        guard branchId != branch?._id, let branch = chatInteractor.branch(id: branchId) else { return }
        
        self.branch = branch
        messages = branch.messages ?? []
        draft = chatInteractor.draft(for: branch)
        newMessage = draft?.messages?.first?.text ?? ""
        
        selectedMessagesIndexPaths = [:]
        selectedMessagesIds = [:]
        
        reloadToolBarState()
        reloadCells()
        scrollToBottom()
        reloadErrorState()
        
        chatInteractor.getDraft(branch: branch)
        chatInteractor.getMessages(branch: branch)
    }
    
    func scrollToBottom() {
        collectionView?.scrollToBottom()
    }
    
    func clearState() {
        branch = nil
        draft = nil
        messages = []
        reloadToolBarState()
        reloadCells()
    }
    
    func reloadCells() {
        reloadMessageHeights()
        view.reloadLayoutIfNeeded()
        reloadStateConstraints()
        collectionView?.reloadData()
        view.reloadLayoutIfNeeded()
    }
    
    func reloadToolBarState() {
        toolBar.set(loading: isLoading || isCreating)
        toolBar.set(aiModel: localModel)
        toolBar.updateMessageSelection(count: messagesCount(), selectedCount: selectedMessagesIds.count)
    }
    
    // MARK: - Datasource
    
    var hasError: Bool {
        branch?.createMessageError != nil
    }
    
    var hasMessages: Bool {
        messages.count > 0
    }
    
    var hasDraft: Bool {
        draft?.messages?.count ?? 0 > 0
    }
    
    func messagesCount() -> Int {
        messages.count
    }
    
    func newMessageCount() -> Int {
        isLoading || isCreating ? 0 : 1
    }
    
    func loadingSectionCount() -> Int {
        isCreating || isLoading ? 1 : 0
    }
    
    func draftSectionCount() -> Int {
        isCreating && hasDraft ? 1 : 0
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


