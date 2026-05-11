import Foundation

struct Position: Codable {
    let stockId: String   // e.g. "sz300170"
    var costPrice: Double // 成本价
    var shares: Int       // 持仓股数
}
