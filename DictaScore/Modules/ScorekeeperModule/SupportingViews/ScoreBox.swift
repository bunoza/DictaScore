import Combine
import SwiftUI
import SwiftySound

struct ScoreBox: View {
    @Binding private var playerInfo: PlayerInfo
    @Binding private var orientation: UIDeviceOrientation
    @Binding private var speechTrigger: UUID?
    @Binding private var playerNumber: Int
    @State private var shouldAnimate: Bool = false
    
    init(
        playerInfo: Binding<PlayerInfo>,
        orientation: Binding<UIDeviceOrientation>,
        speechTrigger: Binding<UUID?>,
        playerNumber: Binding<Int>
    ) {
        self._playerInfo = playerInfo
        self._orientation = orientation
        self._speechTrigger = speechTrigger
        self._playerNumber = playerNumber
    }
    
    var body: some View {
            GeometryReader { geo in
                VStack {
                    Text(playerInfo.nickname)
                        .scaleEffect(x: shouldAnimate ? 1.4 : 1, y: shouldAnimate ? 1.4 : 1)
                        .font(.system(size: handleNicknameSize(geometryProxy: geo)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Text(playerInfo.scoreStringRepresentation)
                        .scaleEffect(x: shouldAnimate ? 1.4 : 1, y: shouldAnimate ? 1.4 : 1)
                        .font(.system(size: handleScoreSize(geometryProxy: geo)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(playerInfo.color))
                .padding(shouldAnimate ? 5 : 15)
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            increaseScore()
                        }
                )
                .gesture(
                    DragGesture(minimumDistance: 100, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.height > 0 {
                                decreaseScore()
                            }
                        })
                )
                .onChange(of: speechTrigger) { _ in
                    if speechTrigger == playerInfo.id {
                        increaseScore()
                        speechTrigger = nil
                    }
                }
            }
    }
    
    func handleScoreSize(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height/3
    }
    
    func handleNicknameSize(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height/8
    }
    
    func decreaseScore() {
        withAnimation(.easeInOut(duration: 0.07)) {
            if playerInfo.score - 1 >= 0 {
                playerInfo.score -= 1
            }
        }
        withAnimation(.easeInOut(duration: 0.15).delay(0.07)) {
            shouldAnimate.toggle()
        }
        withAnimation(.easeInOut(duration: 0.15).delay(0.1)) {
            shouldAnimate.toggle()
        }
        Sound.play(file: "decrease", fileExtension: "wav", numberOfLoops: 0)
    }
    
    func increaseScore() {
        withAnimation(.easeInOut(duration: 0.07)) {
            if playerInfo.score + 1 <= 99 {
                playerInfo.score += 1
            }
        }
        withAnimation(.easeInOut(duration: 0.15).delay(0.07)) {
            shouldAnimate.toggle()
        }
        withAnimation(.easeInOut(duration: 0.15).delay(0.1)) {
            shouldAnimate.toggle()
        }
        Sound.play(file: "increase", fileExtension: "wav", numberOfLoops: 0)
    }
}
