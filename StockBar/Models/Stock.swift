import Foundation

struct Stock: Identifiable, Codable, Equatable {
    let id: String           // e.g. "sh600519"
    let code: String         // e.g. "600519"
    let name: String         // e.g. "贵州茅台"
    var currentPrice: Double // 当前价
    var previousClose: Double // 昨收

    var changePercent: Double {
        guard previousClose != 0 else { return 0 }
        return (currentPrice - previousClose) / previousClose * 100
    }

    var changeAmount: Double {
        currentPrice - previousClose
    }

    var isUp: Bool { changePercent > 0 }
    var isDown: Bool { changePercent < 0 }

    /// 从新浪API原始数据构造
    /// - Parameters:
    ///   - id: 股票代码前缀+代码, e.g. "sh600519"
    ///   - fields: 逗号分隔的字段数组
    static func fromSina(id: String, fields: [String]) -> Stock? {
        guard fields.count >= 4 else { return nil }
        let code = String(id.dropFirst(2))
        guard let currentPrice = Double(fields[3]),
              let previousClose = Double(fields[2]) else { return nil }

        return Stock(
            id: id,
            code: code,
            name: fields[0],
            currentPrice: currentPrice,
            previousClose: previousClose
        )
    }
}
