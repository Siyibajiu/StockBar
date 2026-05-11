import SwiftUI

struct HeatmapView: View {
    let value: Double  // changePercent
    let label: String
    let step: Double
    var showColor: Bool = true

    private let totalBlocks = 10

    init(value: Double, label: String, step: Double = 0.2, showColor: Bool = true) {
        self.value = value
        self.label = label
        self.step = step
        self.showColor = showColor
    }

    var body: some View {
        VStack(spacing: 4) {
            // 10 blocks
            HStack(spacing: 2) {
                ForEach(0..<totalBlocks, id: \.self) { i in
                    let threshold = Double(i) * step
                    let isLit = abs(value) >= threshold

                    RoundedRectangle(cornerRadius: 3)
                        .fill(blockColor(isLit: isLit))
                        .frame(width: 10, height: 10)
                }
                Spacer()
            }

            // Label
            HStack(spacing: 6) {
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(formatValue(value))
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(showColor ? valueColor(value) : .primary)
                Spacer()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }

    private func blockColor(isLit: Bool) -> Color {
        if isLit {
            return value >= 0 ? Color.red.opacity(0.6) : Color.green.opacity(0.6)
        }
        return Color.gray.opacity(0.12)
    }

    private func formatValue(_ v: Double) -> String {
        return String(format: "%.1fKB/s", abs(v))
    }

    private func valueColor(_ v: Double) -> Color {
        return v >= 0 ? .red : .green
    }
}
