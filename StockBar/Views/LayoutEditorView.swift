import SwiftUI

struct LayoutEditorView: View {
    @Bindable var viewModel: StockViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedStockId: String? = nil
    @State private var draggingStockId: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("拖拽股票卡片可以合并到同一行（每行最多2个）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.layout.indices, id: \.self) { rowIndex in
                        let rowIds = viewModel.layout[rowIndex]
                        HStack(spacing: 8) {
                            ForEach(rowIds, id: \.self) { stockId in
                                if let stock = viewModel.stocks.first(where: { $0.id == stockId }) {
                                    editorCard(stock: stock, rowIds: rowIds)
                                }
                            }
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 12)
                    }
                }
                .padding(.vertical, 8)
            }

            Divider()

            HStack {
                Text("提示：")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("拖拽股票到另一股票的右侧可以合并为一行")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack {
                TextField("输入股票代码", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)

                Button("添加股票") {
                }
                .disabled(true)
            }
        }
        .frame(width: 400, height: 500)
        .padding()
    }

    @ViewBuilder
    private func editorCard(stock: Stock, rowIds: [String]) -> some View {
        let style = viewModel.displayStyle(for: stock.id)
        let isDragging = draggingStockId == stock.id

        HStack(spacing: 8) {
            Image(systemName: "line.3.horizontal")
                .foregroundStyle(.secondary)
                .font(.caption)

            GaugeView(
                value: stock.changePercent,
                label: stock.name,
                detail: String(format: "%.2f", stock.currentPrice)
            )
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isDragging ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        )
        .opacity(isDragging ? 0.6 : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedStockId == stock.id ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onDrag {
            draggingStockId = stock.id
            return NSItemProvider(object: stock.id as NSString)
        }
        .onDrop(of: [.plainText], isTargeted: nil) { providers in
            guard let draggedId = draggingStockId, draggedId != stock.id else {
                return false
            }
            viewModel.moveStock(draggedId, to: stock.id)
            draggingStockId = nil
            return true
        }
        .contextMenu {
            Menu("显示样式") {
                Button(style == .gauge ? "✓ 音量条" : "音量条") {
                    viewModel.setDisplayStyle(.gauge, for: stock.id)
                }
                Button(style == .heatmap ? "✓ 热力图" : "热力图") {
                    viewModel.setDisplayStyle(.heatmap, for: stock.id)
                }
                Button(style == .barStack ? "✓ 柱状图" : "柱状图") {
                    viewModel.setDisplayStyle(.barStack, for: stock.id)
                }
            }

            if rowIds.count > 1 {
                Button("拆分行") {
                    viewModel.splitStock(stock.id)
                }
            }

            Divider()

            Button("移除", role: .destructive) {
                viewModel.removeStock(stock.id)
            }
        }
    }
}