import XCTest

@testable import XyoClient

@available(iOS 13.0, *)
final class PanelTests: XCTestCase {
  static var allTests = [
    (
      "createPanel", testCreatePanel,
      "simplePanelReport", testSimplePanelReport,
      "singleWitnessPanel", testSingleWitnessPanel,
      "multiWitnessPanel", testMultiWitnessPanel
    )
  ]

  func testCreatePanel() throws {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    let account = Account()
    let witness = AbstractWitness(account: account)
    let panel = XyoPanel(archive: archive, apiDomain: apiDomain, witnesses: [witness])
    XCTAssertNotNil(account)
    XCTAssertNotNil(panel)
  }

  func testSimplePanelReport() async {
    let panel = XyoPanel {
      return nil
    }
    do {
      let result = try await panel.report()
      XCTAssertTrue(result.isEmpty, "Expected empty result from report")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }

  func testSingleWitnessPanel() async {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    let panel = XyoPanel(
      archive: archive,
      apiDomain: apiDomain,
      witnesses: [
        XyoBasicWitness(observer: {
          return XyoPayload("network.xyo.basic")
        })
      ]
    )
    do {
      let result = try await panel.report()
      XCTAssertFalse(result.isEmpty, "Expected non-empty result from report")
      XCTAssertEqual(result.count, 1, "Expected one payload in the result")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }

  func testMultiWitnessPanel() async {
    let apiDomain = XyoPanel.Defaults.apiDomain
    let archive = XyoPanel.Defaults.apiModule
    let panel = XyoPanel(
      archive: archive,
      apiDomain: apiDomain,
      witnesses: [
        XyoBasicWitness(observer: {
          return XyoPayload("network.xyo.basic")
        }),
        XyoSystemInfoWitness(),
      ]
    )
    do {
      let result = try await panel.report()
      XCTAssertFalse(result.isEmpty, "Expected non-empty result from report")
      XCTAssertEqual(result.count, 2, "Expected two payloads in the result")
    } catch {
      XCTFail("Report method threw an error: \(error)")
    }
  }
}
