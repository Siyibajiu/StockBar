import Foundation

actor StockService {
    private let baseURL = "https://hq.sinajs.cn/list="

    /// 批量查询股票实时数据
    /// - Parameter stockIds: 股票ID列表, e.g. ["sh600519", "sz000001"]
    /// - Returns: 股票数据数组
    func fetchStocks(stockIds: [String]) async throws -> [Stock] {
        guard !stockIds.isEmpty else { return [] }

        let list = stockIds.joined(separator: ",")
        guard let url = URL(string: "\(baseURL)\(list)") else {
            throw StockError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("https://finance.sina.com.cn", forHTTPHeaderField: "Referer")
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StockError.httpError
        }

        let gb18030 = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding("gb18030" as CFString))
        guard let text = String(data: data, encoding: String.Encoding(rawValue: gb18030)) else {
            throw StockError.decodingError
        }

        return parseSinaResponse(text, expectedIds: stockIds)
    }

    /// 解析新浪API返回的 var hq_str_xxx="..." 格式
    private func parseSinaResponse(_ text: String, expectedIds: [String]) -> [Stock] {
        var results: [Stock] = []

        for line in text.components(separatedBy: "\n") {
            guard line.hasPrefix("var hq_str_") else { continue }

            // Extract ID: var hq_str_sh600519="..."
            let prefix = "var hq_str_"
            guard let eqRange = line.range(of: "=\"") else { continue }
            let idStart = line.index(line.startIndex, offsetBy: prefix.count)
            let idEnd = line.range(of: "=")!.lowerBound
            let id = String(line[idStart..<idEnd])

            // Extract value between quotes
            guard let valueStart = line.range(of: "=\"")?.upperBound,
                  let valueEnd = line.range(of: "\";", range: valueStart..<line.endIndex)?.lowerBound else {
                continue
            }

            let value = String(line[valueStart..<valueEnd])
            let fields = value.components(separatedBy: ",")

            if let stock = Stock.fromSina(id: id, fields: fields) {
                results.append(stock)
            }
        }

        return results
    }
}

enum StockError: LocalizedError {
    case invalidURL
    case httpError
    case decodingError
    case timeout

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "连接异常"
        case .httpError: return "连接异常"
        case .decodingError: return "数据异常"
        case .timeout: return "连接超时"
        }
    }
}
