import SwiftUI

/// Information sheet explaining Cows and Bulls rules and indicators.
public struct RulesSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Objective
                    ruleSection(
                        title: "🎯 Objective",
                        description: "Guess the secret 4-digit code picked by the computer. All 4 digits are unique (from 0 to 9, leading 0 allowed). You have 20 attempts to solve it!"
                    )
                    
                    // Indicators
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🐂 & 🐮 Indicators")
                            .font(.headline)
                        
                        HStack(alignment: .top, spacing: 12) {
                            Text("🐂")
                                .font(.title)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("BULL")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.green)
                                Text("A digit is in the secret code and in the EXACT right position.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Text("🐮")
                                .font(.title)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("COW")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.orange)
                                Text("A digit is in the secret code, but in the WRONG position.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardBackground)
                    .cornerRadius(14)
                    
                    // Conceding
                    ruleSection(
                        title: "🏳️ Conceding",
                        description: "You can surrender early at any time by tapping the flag icon. Surrendering will reveal the secret code immediately."
                    )
                    
                    // Tips
                    ruleSection(
                        title: "💡 Pro Tip",
                        description: "Use process of elimination! Start by testing distinct sets of digits (e.g. 1-2-3-4 then 5-6-7-8) to narrow down which digits belong in the secret code."
                    )
                }
                .padding()
            }
            .navigationTitle("How to Play")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func ruleSection(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
