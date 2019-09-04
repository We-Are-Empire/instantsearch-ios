//
//  CollectionViewMultiIndexHitsControllerTests.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 04/09/2019.
//

import Foundation

@testable import InstantSearch
import InstantSearchCore
import Foundation
import XCTest

class TestCollectionViewCell: UICollectionViewCell {
  var content: String?
}

class CollectionViewMultiIndexHitsControllerTests: XCTestCase {
  
  func testDataSource() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let dataSource = MultiIndexHitsCollectionViewDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_, h: String, _) in
      let cell = TestCollectionViewCell()
      cell.content = h
      return cell
    }
    
    dataSource.hitsSource = hitsSource

    XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 2)
    XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 2)
    
  }
  
  func testDelegate() {
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    let delegate = MultiIndexHitsTableViewDelegate()
    delegate.hitsSource = hitsSource
    
  }
  
  func testMissingHitsSource() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let dataSource = MultiIndexHitsCollectionViewDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_, h: String, _) in
      let cell = TestCollectionViewCell()
      cell.content = h
      return cell
    }
    
    let delegate = MultiIndexHitsCollectionViewDelegate()
    
    delegate.setClickHandler(forSection: 0) { (_, h: String, _) in
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.numberOfSections(in: collectionView)
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      _ = dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
    }
    
    expectFatalError(expectedMessage: "Missing hits source") {
      delegate.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
    }
    
  }
  
  
  func testMissingCellHandler() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let dataSource = MultiIndexHitsCollectionViewDataSource()
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    dataSource.hitsSource = hitsSource
    
    expectFatalError(expectedMessage: "No cell configurator found for section 0") {
      _ = dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
    }
    
  }
  
  func testMissingClickHandler() {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    let delegate = MultiIndexHitsCollectionViewDelegate()
    
    let hitsSource = TestMultiHitsDataSource(hitsBySection: [["t11", "t12"], ["t21", "t22", "t23"]])
    
    delegate.hitsSource = hitsSource
    
    expectFatalError(expectedMessage: "No click handler found for section 0") {
      _ = delegate.collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
    }
    
  }
  
}
