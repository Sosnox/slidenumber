import SwiftUI

struct ContentView: View {
    @State private var game = FifteenPuzzle()
    @State private var won = false
    @State private var moveCount = 0
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 4)
    
    var body: some View {
        VStack {
            Button(action: newGame){
                Text("New Game")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.top, 8)
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<game.board.count, id: \.self) { index in
                    if let number = game.board[index] {
                        Button(action: {
                            if game.moveTile(at: index) {
                                moveCount += 1
                            }
                            won = game.isGameWon()
                        }) {
                            Text("\(number)")
                                .font(.largeTitle)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .border(Color.orange)
                                .foregroundColor(.orange)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    } else {
                        Color.clear
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .cornerRadius(8)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .padding(25)
            
            //ชนะเเล้วข้อความขึ้น You Won Leaw นะ
            if won {
                Text("You Won Leaw!!!")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            Text("Moves: \(moveCount)")
                .font(.title)
                .foregroundColor(.blue)
                .padding(.top, 8)
        }
    }
    //Func ไว้เรียกเกมใหม่
    func newGame() {
        game.shuffleBoard()
        moveCount = 0
        won = false
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

extension FifteenPuzzle {
    mutating func moveTile(at index: Int) -> Bool {
        guard canMoveTile(at: index) else { return false }
        let emptyIndex = board.firstIndex(of: nil)!
        board.swapAt(emptyIndex, index)
        return true
    }
    mutating func shuffleBoard(){
        board.shuffle()
        while !isSolvable(){
            board.shuffle()
        }
    }

    func isGameWon() -> Bool {
        for i in 0..<15 {
            if board[i] != i + 1 {
                return false
            }
        }
        return true
    }
}


struct FifteenPuzzle {
    var board: [Int?] = Array(1...15) + [nil]

    init() {
        board.shuffle()
        while !isSolvable() {
            board.shuffle()
        }
    }

    func isSolvable() -> Bool {
        var inversions = 0
        for i in 0..<board.count where board[i] != nil {
            for j in i+1..<board.count where board[j] != nil {
                if board[i]! > board[j]! {
                    inversions += 1
                }
            }
        }

        return inversions % 2 == 0
    }

    func canMoveTile(at index: Int) -> Bool {
        guard let emptyIndex = board.firstIndex(of: nil) else { return false }
        let emptyRow = emptyIndex / 4
        let emptyCol = emptyIndex % 4
        let tileRow = index / 4
        let tileCol = index % 4
       
        return (emptyRow == tileRow && abs(emptyCol - tileCol) == 1) ||
               (emptyCol == tileCol && abs(emptyRow - tileRow) == 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
