import SwiftUI

struct ScorekeeperLayout: View {
    @StateObject private var viewModel: ScoreKeeperViewModel
    
    init(viewModel: ScoreKeeperViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            ProperGrid(
                orientation: viewModel.orientation,
                playersNumber: viewModel.playerNumber
            ) {
                ForEach(0...(viewModel.playerNumber-1), id: \.self) { index in
                    ScoreBox(
                        playerInfo: $viewModel.players[index],
                        orientation: $viewModel.orientation,
                        speechTrigger: $viewModel.speechTrigger,
                        playerNumber: $viewModel.playerNumber
                    )
                    .frame(
                        width: viewModel.handleWidthCalculation(geometryProxy: geo),
                        height: viewModel.handleHeightCalculation(geometryProxy: geo)
                    )
                }
            }
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}

struct ProperGrid<Content: View>: View {
    private let content: Content
    private let playersNumber: Int
    private let orientation: UIDeviceOrientation

    @State var gridItemsOneLine = [GridItem(spacing: 0)]
    @State var gridItemsTwoLines = [GridItem(spacing: 0), GridItem(spacing: 0)]

    init(
        orientation: UIDeviceOrientation,
        playersNumber: Int,
        @ViewBuilder content: () -> Content
    ) {
        self.orientation = orientation
        self.playersNumber = playersNumber
        self.content = content()
    }

    var body: some View {
        if orientation.isLandscape {
            LazyHGrid(rows: playersNumber == 4 ? gridItemsTwoLines : gridItemsOneLine) { content }
        } else {
            LazyVGrid(columns: playersNumber == 4 ? gridItemsTwoLines : gridItemsOneLine) { content }
        }
    }
}
