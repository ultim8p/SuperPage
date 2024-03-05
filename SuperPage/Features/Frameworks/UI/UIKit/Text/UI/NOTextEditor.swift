//
//  NOTextEditor.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/8/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

protocol NOTextEditorDelegate: AnyObject {
    
    func noTextEditor(_ editor: NOTextEditor, didChangeText text: String)
    
    func noTextEditor(_ editor: NOTextEditor, didPerform shortcut: KeyboardShortcut)
}

class NOTextEditor: PlatformView {
    
    var contentWidth: CGFloat = 0.0
    var contentHeight: CGFloat = 0.0
    
    var collectionView: NOCollectionView!
    
    var measureTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var textHeight: CGFloat = 0.0
    
    weak var delegate: NOTextEditorDelegate?
    
    private var text: String = ""
    private var placeholder: String = ""
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension NOTextEditor {
    
    func setupView() {
        addSubview(measureTextView)
        measureTextView.lead(to: self).top(to: self)
        measureTextView.isHidden = true
        
        collectionView = NOCollectionView()
        addSubview(collectionView)
        collectionView.noRegisterCell(cell: NOTextViewCell.self)
        setupCollectionScrollView()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupCollectionScrollView() {
#if os(macOS)
        let scrollView = NSScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = collectionView
        scrollView.drawsBackground = false
        addSubview(scrollView)
        scrollView.onFull(to: self)
#elseif os(iOS)
        addSubview(collectionView)
        collectionView.onFull(to: self)
#endif
    }
}

extension NOTextEditor {
    
    func reloadTextHeight() {
        measureTextView.noSetText(text: text)
        textHeight = measureTextView.targetTextSize(targetWidth: contentWidth).height
    }
}

// MARK: - Layout

extension NOTextEditor {
    
#if os(macOS)
    override func layout() {
        super.layout()
        
        didUpdateContentSize()
    }
#elseif os(iOS)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        didUpdateContentSize()
    }
#endif
    
    func didUpdateContentSize() {
        if bounds.size.width != contentWidth {
            contentWidth = bounds.size.width
            reloadTextHeight()
            collectionView?.reloadData()
        }
        
        if bounds.size.height != contentHeight {
            contentHeight = bounds.size.height
            collectionView?.reloadData()
        }
    }
}

// MARK: - Scroll

extension NOTextEditor {
    
    func scrollToBottom() {
        collectionView?.scrollToBottom()
    }
}

extension NOTextEditor {
    
    func noSet(text: String) {
        guard self.text != text else { return }
        self.text = text
        reloadTextHeight()
        updateTextViewLayout()
    }
    
    func noSet(placeholder: String) {
        self.placeholder = placeholder
        collectionView?.reloadData()
    }
    
    func updateTextViewLayout() {
        collectionView.collectionLayout.invalidateLayout()
        reloadLayoutIfNeeded()
    }
}

extension NOTextEditor {
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let height = max(textHeight, contentHeight)
        return CGSize(width: contentWidth, height: height)
    }
    
    func cellItem(at indexPath: IndexPath) -> NOTextViewCell {
        let cell: NOTextViewCell = collectionView.noReusableCell(for: indexPath)
        cell.configure(text: text)
        cell.configure(placeHolder: placeholder)
        cell.delegate = self
        return cell
    }
}

extension NOTextEditor: PlatformCollectionViewDatasource, PlatformCollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: PlatformCollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: PlatformCollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    
    #if os(macOS)
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        cellItem(at: indexPath)
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NOSize {
        let height = max(textHeight, contentHeight)
        return CGSize(width: contentWidth, height: height)
    }

#elseif os(iOS)
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    cellItem(at: indexPath)
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NOSize {
    return sizeForItem(at: indexPath)
}
#endif
}

extension NOTextEditor: NOTextViewCellDelegate {
    
    func noTextViewCell(_ cell: NOTextViewCell, didPerform shortcut: KeyboardShortcut) {
        switch shortcut {
        case .commandP:
            break
        case .commandEnter:
            break
        case .commandN:
            break
        }
        delegate?.noTextEditor(self, didPerform: shortcut)
    }
    
    func noTextViewCellWillUpdateMessage(_ cell: NOTextViewCell) {
        
    }
    
    func noTextViewCell(_ cell: NOTextViewCell, didUpdateMessage message: String) {
        noSet(text: message)
        
        delegate?.noTextEditor(self, didChangeText: message)
    }
}
