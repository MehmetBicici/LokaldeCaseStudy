//
//  LokaldeCaseStudyTests.swift
//  LokaldeCaseStudyTests
//
//  Created by Mehmet Biçici on 1.06.2026.
//

import XCTest
@testable import LokaldeCaseStudy 

final class FiltersViewModelTests: XCTestCase {
    
    func test_toggleSelection_shouldChangeSelectionState() {
        print("GIVEN: Initializing ViewModel with mock cities...")
        let mockCities = ["Antalya", "Istanbul", "Izmir"]
        let viewModel = FiltersViewModel(filterType: .city,
                                         activeSelection: [],
                                         availableOptions: mockCities)
        
        print("GIVEN: Triggering viewDidLoad to load options...")
        viewModel.viewDidLoad()
        
        print("GIVEN: Asserting initial state is false (not selected)...")
        XCTAssertFalse(viewModel.options[0].isSelected, "Initial state should not be selected.")
        
        print("WHEN: Toggling selection at index 0...")
        viewModel.toggleSelection(at: 0)
        
        print("THEN: Asserting new state is true (selected)...")
        XCTAssertTrue(viewModel.options[0].isSelected, "State should be selected after toggle.")
    }
}
