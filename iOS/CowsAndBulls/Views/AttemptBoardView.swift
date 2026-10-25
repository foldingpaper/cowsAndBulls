import SwiftUI

/// Board view presenting all submitted attempts in clear view.
public struct AttemptBoardView: View {
    public let attempts: [Attempt]
    public let isCartoonMode: Bool
    
    public init(attempts: [Attempt], isCartoonMode: Bool = true) {
        self.attempts = attempts
        self.isCartoonMode = isCartoonMode
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if attempts.isEmpty {
                    emptyStateView
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach(attempts, id: \.number) { attempt in
                            AttemptRowView(attempt: attempt, isCartoonMode: isCartoonMode)
                                .id(attempt.number)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            .onChange(of: attempts.count) { _ in
                if let last = attempts.last {
                    withAnimation(.spring()) {
                        proxy.scrollTo(last.number, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Text("🐮 🎯 🐂")
                .font(.system(size: 44))
            
            Text("Ready to Crack the Code?")
                .font(.headline)
            
            Text("Enter 4 unique digits on the keypad below\nand tap Lock In Guess to begin.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
