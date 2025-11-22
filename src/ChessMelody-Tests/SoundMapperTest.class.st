"
I test the SoundMapper class to ensure correct mapping between chess elements and MIDI notes/instruments.
"
Class {
	#name : 'SoundMapperTest',
	#superclass : 'TestCase',
	#instVars : [
		'mapper'
	],
	#category : 'ChessMelody-Tests',
	#package : 'ChessMelody-Tests'
}

{ #category : 'running' }
SoundMapperTest >> setUp [
    "Initialize a mapper for each test"
    super setUp.
    mapper := SoundMapper new
]

{ #category : 'tests' }
SoundMapperTest >> testDifferentPiecesHaveDifferentInstruments [
    "Test that different pieces map to different instruments"
    | pawnInst knightInst |
    pawnInst := mapper instrumentForPiece: 'P'.
    knightInst := mapper instrumentForPiece: 'N'.
    
    self assert: pawnInst ~= knightInst
]

{ #category : 'tests' }
SoundMapperTest >> testInitialization [
    "Test that mapper is properly initialized"
    self assert: mapper notNil.
    self assert: (mapper noteForSquare: 'a1') isInteger.
    self assert: (mapper instrumentForPiece: 'P') isInteger
]

{ #category : 'tests' }
SoundMapperTest >> testInvalidSquareReturnsDefault [
    "Test that invalid square returns default note"
    | note |
    note := mapper noteForSquare: 'z9'.
    
    self assert: note equals: 60 "middle C as default"
]

{ #category : 'tests' }
SoundMapperTest >> testMidiNoteRange [
    "Test that all notes are in valid MIDI range (0-127)"
    #('a1' 'e4' 'h8' 'd5' 'b2') do: [ :square |
        | note |
        note := mapper noteForSquare: square.
        self assert: note >= 0.
        self assert: note <= 127
    ]
]

{ #category : 'tests' }
SoundMapperTest >> testNoteForMove [
    "Test getting note from a chess move"
    | move note |
    move := ChessMove from: 'e2' to: 'e4' piece: 'P'.
    note := mapper noteForMove: move.
    
    self assert: note isInteger.
    self assert: note equals: (mapper noteForSquare: 'e4')
]

{ #category : 'tests' }
SoundMapperTest >> testPieceMapping [
    "Test that all piece types have valid instrument mappings"
    #('P' 'N' 'B' 'R' 'Q' 'K') do: [ :piece |
        | instrument |
        instrument := mapper instrumentForPiece: piece.
        self assert: instrument isInteger.
        self assert: instrument >= 0.
        self assert: instrument <= 127
    ]
]

{ #category : 'tests' }
SoundMapperTest >> testSameSquareSameNote [
    "Test that same square always returns same note"
    | note1 note2 |
    note1 := mapper noteForSquare: 'e4'.
    note2 := mapper noteForSquare: 'e4'.
    
    self assert: note1 equals: note2
]

{ #category : 'tests' }
SoundMapperTest >> testSquareMapping [
    "Test that different squares map to different notes"
    | noteA1 noteE4 noteH8 |
    noteA1 := mapper noteForSquare: 'a1'.
    noteE4 := mapper noteForSquare: 'e4'.
    noteH8 := mapper noteForSquare: 'h8'.
    
    self assert: noteA1 ~= noteE4.
    self assert: noteE4 ~= noteH8.
    self assert: noteA1 ~= noteH8
]
