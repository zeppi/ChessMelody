"
I test the ChessMove class to ensure moves are created and manipulated correctly.
"
Class {
	#name : 'ChessMoveTest',
	#superclass : 'TestCase',
	#category : 'ChessMelody-Tests',
	#package : 'ChessMelody-Tests'
}

{ #category : 'tests' }
ChessMoveTest >> testCreation [
    "Test that a move can be created with proper attributes"
    | move |
    move := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    
    self assert: move piece equals: 'P'.
    self assert: move fromSquare equals: 'e2'.
    self assert: move toSquare equals: 'e4'
]

{ #category : 'tests' }
ChessMoveTest >> testKnightMove [
    "Test knight move notation"
    | move |
    move := ChessMove from: 'g1' to: 'f3' piece: 'N'.
    
    self assert: move notation equals: 'Nf3'
]

{ #category : 'tests' }
ChessMoveTest >> testNotationGeneration [
    "Test that notation is generated correctly"
    | move |
    move := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    
    self assert: move notation equals: 'Pe4'
]
