import AlertToast
import SwiftUI

struct ScorekeeperView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: ScoreKeeperViewModel
    
    init(viewModel: ScoreKeeperViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScorekeeperLayout(viewModel: viewModel)
            .onAppear {
                self.viewModel.orientation = UIDevice.current.orientation
                viewModel.onAppear()
            }
            .onChange(of: scenePhase, perform: { phase in
                if phase != .active {
                    AppState.shared.lastPlayedGame = viewModel.players
                    AppState.shared.lastPlayedGamePlayerNumber = viewModel.playerNumber
                    if viewModel.isListening { viewModel.recordButtonTapped() }
                }
            })
            .onDisappear {
                AppState.shared.lastPlayedGame = viewModel.players
                AppState.shared.lastPlayedGamePlayerNumber = viewModel.playerNumber
                if viewModel.isListening { viewModel.recordButtonTapped() }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                self.viewModel.orientation = UIDevice.current.orientation
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleListening()
                    } label: {
                        Image(systemName: "mic")
                            .scaleEffect(x: viewModel.isListening ? 0.8 : 1, y: viewModel.isListening ? 0.8 : 1)
                            .animation(viewModel.isListening ? .easeInOut.repeatForever() : .easeInOut, value: viewModel.isListening)
                    }
                    .padding()
                    
                    Image(systemName: "gearshape")
                        .foregroundColor(.blue)
                }
            }
            .toast(isPresenting: $viewModel.shouldShowError) {
                AlertToast(
                    displayMode: .alert,
                    type: .error(.accentColor),
                    title: "An error has occured.",
                    subTitle: "\(String(describing: viewModel.error?.localizedDescription))"
                )
            }
            .toast(isPresenting: $viewModel.showNoPermissionAlert) {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .error(.accentColor),
                    title: "Microphone permission not given.",
                    subTitle: "Please enable microphone usage for this app in order to use this function."
                )
            }
    }
}
