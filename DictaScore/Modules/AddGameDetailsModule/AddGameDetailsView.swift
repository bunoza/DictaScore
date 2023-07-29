import SwiftUI

struct AddGameDetailsView: View {
    @State private var playerNickname: String = ""
    @State private var playersNumber: Int = 2
    
    @State private var players: [PlayerInfo] = [
        PlayerInfo(nickname: "John", score: 0, hotword: "First", color: .red),
        PlayerInfo(nickname: "Mark", score: 0, hotword: "Second", color: .blue),
        PlayerInfo(nickname: "Daniel", score: 0, hotword: "Third", color: .green),
        PlayerInfo(nickname: "Eric", score: 0, hotword: "Fourth", color: .pink)
    ]
    
    var body: some View {
        List {
            Section {
            } header: {
                Text("Number of players")
            } footer: {
                Picker(selection: $playersNumber) {
                    ForEach(1...4, id: \.self) { playerNum in
                        Text(String(playerNum))
                    }
                } label: {
                    Text("Number of players")
                }
                .tag(playersNumber)
                .pickerStyle(.segmented)
            }
            
            ForEach(0...(playersNumber-1), id: \.self) { number in
                Section {} header: {
                    Text("Player #\(number+1)")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                .textCase(nil)
                .padding(.top, 20)
                
                Section {
                    TextField("", text: $players[number].nickname)
                } header: {
                    Text("Player nickname")
                } footer: {
                    Text("Nickname is displayed above current score.")
                }
                
                Section {
                    TextField("", text: $players[number].hotword)
                } header: {
                    Text("Hotword")
                } footer: {
                    Text("When listening mode is active, you can say hotword to assign point to this player. Works best with one word.")
                }
                
                Section {
                    ColorPicker(selection: $players[number].color, supportsOpacity: false) {
                        Text("Choose color")
                    }
                }
            }
        }
        .navigationTitle("New game")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ScorekeeperView(
                        viewModel: ScoreKeeperViewModel(
                            players: players,
                            playerNumber: playersNumber
                        )
                    )
                } label: {
                    Text("Start")
                }
            }
        }
    }
}

struct AddGameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameDetailsView()
    }
}
