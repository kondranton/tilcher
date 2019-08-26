import XCTest
import Quick
import Nimble
@testable import TiLcher

class PasingTests: XCTestCase {
    func testSendCodeParsing() {
        let json = """
{\"verification_id\":\"0f3b9059-f5ca-4a2f-8e63-c1a2db8ab419\"}
"""
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder.common

        expect {
            try decoder.decode(Verifier.self, from: jsonData)
        }.to(
            beAKindOf(Verifier.self),
            description: "Should successfully parse the answer"
        )
    }
}
