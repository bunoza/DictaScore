import AlertToast
import SwiftUI
import Lottie

struct StartView: View {
    @State private var showNoPreviousGamesAlert = false
    @ObservedObject private var appState: AppState = AppState.shared
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 50) {
                    Group {
                        Text("DictaScore")
                            .font(.custom(
                                "AmericanTypewriter",
                                fixedSize: 34
                            )
                                .weight(.black)
                            )
                        Text("Your hands-free scoreboard.")
                            .font(.custom(
                                "AmericanTypewriter",
                                fixedSize: 20)
                            )
                    }
                    
                    LottieView(name: "bouncing-ball-animation", loopMode: .loop)
                        .frame(maxHeight: geo.size.height/3)
                        .scaledToFill()
                        .padding()
                    
                    HStack(spacing: 50) {
                        if !appState.lastPlayedGame.isEmpty {
                            NavigationLink(
                                destination: ScorekeeperView(
                                    viewModel: ScoreKeeperViewModel(
                                        players: appState.lastPlayedGame,
                                        playerNumber: appState.lastPlayedGamePlayerNumber
                                    )
                                )
                            ) {
                                VStack {
                                    Text("Continue")
                                        .font(.custom("AmericanTypewriter",fixedSize: 20))
                                    Image(systemName: "playpause.circle")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 80, maxHeight: 80)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        
                        NavigationLink(destination: AddGameDetailsView()) {
                            VStack {
                                Text("Start")
                                    .font(.custom("AmericanTypewriter",fixedSize: 20))
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 80, maxHeight: 80)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        colors: [.cyan.opacity(0.5), .red.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                )
            }
            .toast(isPresenting: $showNoPreviousGamesAlert) {
                AlertToast(
                    displayMode: .alert,
                    type: .error(.accentColor),
                    title: "No previous games found"
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
