import SwiftUI

/// Board view presenting all submitted attempts chronologically with rock-solid auto-scrolling
/// and drag-to-dismiss keypad interaction.
public struct AttemptBoardView: View {
    public let attempts: [Attempt]
    public let isCartoonMode: Bool
    public let isKeypadCollapsed: Bool
    public let onScrollDrag: () -> Void
    
    private let bottomAnchorId = "BOTTOM_SCROLL_ANCHOR"
    
    public init(
        attempts: [Attempt],
        isCartoonMode: Bool = true,
        isKeypadCollapsed: Bool = false,
        onScrollDrag: @escaping () -> Void = {}
    ) {
        self.attempts = attempts
        self.isCartoonMode = isCartoonMode
        self.isKeypadCollapsed = isKeypadCollapsed
        self.onScrollDrag = onScrollDrag
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(attempts, id: \.number) { attempt in
                        AttemptRowView(attempt: attempt, isCartoonMode: isCartoonMode)
                            .id(attempt.number)
                    }
                    
                    // Invisible bottom anchor for reliable auto-scrolling
                    Color.clear
                        .frame(height: 1)
                        .id(bottomAnchorId)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .simultaneousGesture(
                DragGesture().onChanged { value in
                    // Collapse keypad when user starts scrolling to inspect board
                    if abs(value.translation.height) > 6 {
                        onScrollDrag()
                    }
                }
            )
            .onChange(of: attempts.count) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: isKeypadCollapsed) { collapsed in
                if !collapsed {
                    // Keypad just expanded: scroll to bottom so the latest attempts stay visible
                    scrollToBottom(proxy: proxy, delay: 0.18)
                }
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, delay: Double = 0.05) {
        guard !attempts.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                proxy.scrollTo(bottomAnchorId, anchor: .bottom)
            }
        }
    }
}
