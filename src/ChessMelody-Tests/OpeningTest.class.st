Class {
	#name : 'OpeningTest',
	#superclass : 'TestCase',
	#category : 'ChessMelody-Tests',
	#package : 'ChessMelody-Tests'
}

{ #category : 'tests' }
OpeningTest >> testAddingMoves [
    "Test adding moves to an opening"
    | opening move1 move2 |
    opening := Opening named: 'Italian Game'.
    move1 := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    move2 := ChessMove from: 'e7' to: 'e5' piece: 'P'.
    
    opening addMove: move1.
    opening addMove: move2.
    
    self assert: opening moves size equals: 2.
    self assert: opening moves first equals: move1
]

{ #category : 'tests' }
OpeningTest >> testCreation [
    "Test that an opening can be created"
    | opening |
    opening := Opening named: 'Italian Game'.
    
    self assert: opening name equals: 'Italian Game'.
    self assert: opening moves isEmpty
]

{ #category : 'tests' }
OpeningTest >> testMelodyAt [
    "Test accessing specific melody notes"
    | opening move note |
    opening := Opening named: 'Test Opening'.
    move := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    opening addMove: move.
    
    note := opening melodyAt: 1.
    
    self assert: (note at: #note) isInteger.
    self assert: (note at: #instrument) isInteger.
    self assert: (note at: #duration) equals: 500
]

{ #category : 'tests' }
OpeningTest >> testMelodyGeneration [
    "Test that melody is generated from moves"
    | opening move1 move2 |
    opening := Opening named: 'Test Opening'.
    move1 := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    move2 := ChessMove from: 'g1' to: 'f3' piece: 'N'.
    
    opening addMove: move1.
    opening addMove: move2.
    opening generateMelody.
    
    self assert: opening melody size equals: 2.
    self assert: (opening melody first at: #note) isInteger.
    self assert: (opening melody first at: #instrument) isInteger
]

{ #category : 'tests' }
OpeningTest >> testMelodyHasDifferentNotesForDifferentMoves [
    "Test that different moves produce different notes"
    | opening move1 move2 |
    opening := Opening named: 'Test Opening'.
    move1 := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    move2 := ChessMove from: 'e7' to: 'e5' piece: 'P'.
    
    opening addMove: move1.
    opening addMove: move2.
    opening generateMelody.
    
    self deny: (opening melody first at: #note) equals: (opening melody second at: #note)
]
