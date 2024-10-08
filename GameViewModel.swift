import SwiftUI

final class GameViewModel: ObservableObject {
    
    @Published var showingOptions = false
    @Published var showingPlayerLabel = false
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem? // Make sure this property exists
    @Published var humanWins = 0
    @Published var computerWins = 0
    @Published var rounds: Int = UserDefaults.standard.integer(forKey: "rounds")
    @Published var showingWinView = false
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertItem(title: Text("You Win!"),
                                  message: Text("You are pretty smart!"),
                                  buttonTitle: Text("Hell yeah"))
            humanWins += 1
            checkForGameEnd()
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertItem(title: Text("Draw"),
                                  message: Text("What a battle was that..."),
                                  buttonTitle: Text("Try again"))
            return
        }
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertItem(title: Text("Computer Win!"),
                                      message: Text("Try again!"),
                                      buttonTitle: Text("Rematch"))
                computerWins += 1
                checkForGameEnd()
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertItem(title: Text("Draw"),
                                      message: Text("What a battle was that..."),
                                      buttonTitle: Text("Try again"))
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index})
    }

    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        //1
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6,7,8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        //2
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        //3
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        
        //4
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }

    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6,7,8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }

    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    func checkForGameEnd() {
        if humanWins == rounds {
            showingWinView = true
            
        } else if computerWins == rounds {
            showingWinView = true
        }
    }
}
