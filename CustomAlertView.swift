import SwiftUI

struct CustomAlertView: View {
    @Binding var alertItem: AlertItem?
    var onDismiss: (() -> Void)?

    var body: some View {
        if let alertItem = alertItem {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    alertItem.title
                        .font(.title)
                        .foregroundColor(.primary)
                    alertItem.message
                        .font(.body)
                        .foregroundColor(.secondary)
                    Button(action: {
                        self.alertItem = nil
                        onDismiss?() // Call the onDismiss closure
                    }) {
                        alertItem.buttonTitle
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
                .padding()
                Spacer()
            }
            .background(Color.clear.edgesIgnoringSafeArea(.all))
        } else {
            EmptyView()
        }
    }
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}
