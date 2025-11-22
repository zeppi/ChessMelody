"
I represent a single chess move in the game.

I store information about:
- The piece being moved (e.g., 'P' for pawn, 'N' for knight)
- The starting square (e.g., 'e2')
- The destination square (e.g., 'e4')
- The algebraic notation of the move

Example of use:
    move := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    move notation. ""returns 'Pe4'""

I am used by Opening to build sequences of moves that form chess openings.
"
Class {
	#name : 'ChessMove',
	#superclass : 'Object',
	#instVars : [
		'piece',
		'fromSquare',
		'toSquare',
		'notation'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'instance creation' }
ChessMove class >> from: aFromSquare to: aToSquare piece: aPiece [
    ^ self new initializeFrom: aFromSquare to: aToSquare piece: aPiece
]

{ #category : 'accessing' }
ChessMove >> fromSquare [
    ^ fromSquare
]

{ #category : 'initialization' }
ChessMove >> generateNotation [
    "Generate algebraic notation for the move"
    ^ piece asString, toSquare asString
]

{ #category : 'initialization' }
ChessMove >> initializeFrom: aFromSquare to: aToSquare piece: aPiece [
    "Initialize a chess move"
    fromSquare := aFromSquare.
    toSquare := aToSquare.
    piece := aPiece.
    notation := self generateNotation
]

{ #category : 'accessing' }
ChessMove >> notation [
    ^ notation
]

{ #category : 'accessing' }
ChessMove >> piece [
    ^ piece
]

{ #category : 'accessing' }
ChessMove >> toSquare [
    ^ toSquare
]
