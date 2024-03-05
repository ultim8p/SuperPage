//
//  Platform.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if os(macOS)
typealias PlatformView = NSView
typealias PlatformButton = NSButton
typealias NOImage = NSImage
typealias PTextView = NSTextView
typealias NOColor = NSColor
typealias NOFont = NSFont
typealias PlatformViewRepresentable = NSViewRepresentable
typealias PlatformViewControlerRepresentable = NSViewControllerRepresentable
typealias PlatformViewControler = NSViewController
typealias PlatformTextViewDelegate = NSTextViewDelegate
typealias NOSize = NSSize
typealias PlatformRect = NSRect
typealias PlatformCollectionView = NSCollectionView
typealias PCollectionViewCell = NSCollectionViewItem
typealias PlatformCollectionViewDatasource = NSCollectionViewDataSource
typealias PlatformCollectionViewDelegateFlowLayout = NSCollectionViewDelegateFlowLayout
typealias PlatformCollectionViewFlowLayout = NSCollectionViewFlowLayout
typealias PlatformCollectionViewLayoutAttributes = NSCollectionViewLayoutAttributes
typealias PlatformActivityIndicator = NSProgressIndicator
typealias PlatformScrollView = NSScrollView
typealias PlatformLabel = NSTextField

#elseif os(iOS)
typealias PlatformView = UIView
typealias PlatformButton = UIButton
typealias NOImage = UIImage
typealias PTextView = UITextView
typealias NOColor = UIColor
typealias NOFont = UIFont
typealias PlatformViewRepresentable = UIViewRepresentable
typealias PlatformViewControlerRepresentable = UIViewControllerRepresentable
typealias PlatformViewControler = UIViewController
typealias PlatformTextViewDelegate = UITextViewDelegate
typealias NOSize = CGSize
typealias PlatformRect = CGRect
typealias PlatformCollectionView = UICollectionView
typealias PCollectionViewCell = UICollectionViewCell
typealias PlatformCollectionViewDatasource = UICollectionViewDataSource
typealias PlatformCollectionViewDelegateFlowLayout = UICollectionViewDelegateFlowLayout
typealias PlatformCollectionViewFlowLayout = UICollectionViewFlowLayout
typealias PlatformCollectionViewLayoutAttributes = UICollectionViewLayoutAttributes
typealias PlatformActivityIndicator = UIActivityIndicatorView
typealias PlatformScrollView = UIScrollView
typealias PlatformLabel = UILabel

#endif
