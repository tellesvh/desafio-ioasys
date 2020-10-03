//
//  Desafio_IoasysUITests.swift
//  Desafio.IoasysUITests
//
//  Created by Victor Hugo Telles on 29/09/20.
//

import XCTest

class Desafio_IoasysUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        app.launch()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testSuccessfulLogin() throws {
        let emailTextField = app.textFields["Digite seu email."]
        let passwordSecureField = app.secureTextFields["Digite sua senha."]
        let enterButton = app.buttons["ENTRAR"]
        
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText("testeapple@ioasys.com.br")
        
        passwordSecureField.tap()
        sleep(1)
        passwordSecureField.typeText("12341234")
        
        enterButton.tap()
        
        sleep(5)
        
        let searchEnterprisesBackgroundOverlay = app.images["background_overlay"]
        
        XCTAssertTrue(searchEnterprisesBackgroundOverlay.exists)
    }

    func testUnsuccessfulLogin() throws {
        let emailTextField = app.textFields["Digite seu email."]
        let passwordSecureField = app.secureTextFields["Digite sua senha."]
        let enterButton = app.buttons["ENTRAR"]
        
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText("testeapple@ioasys.com.br")
        
        passwordSecureField.tap()
        sleep(1)
        passwordSecureField.typeText("0000")
        
        enterButton.tap()
        
        sleep(5)
        
        let invalidEmailLabel = app.staticTexts["Este email não é válido."]
        let invalidCredentialsLabel = app.staticTexts["Invalid login credentials. Please try again."]
        
        XCTAssertTrue(invalidEmailLabel.exists || invalidCredentialsLabel.exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
