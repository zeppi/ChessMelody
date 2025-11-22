"
I represent a chess opening with its sequence of moves and associated melody.

I store:
- The name of the opening (e.g., 'Italian Game')
- An ordered collection of ChessMove instances
- The melody (MIDI notes) associated with this opening sequence

Example of use:
    opening := Opening named: 'Italian Game'.
    opening addMove: (ChessMove from: 'e2' to: 'e4' piece: 'P').
    opening addMove: (ChessMove from: 'e7' to: 'e5' piece: 'P').
    opening moves size. ""returns 2""

I am the core class that links chess moves to their musical representation.
"
Class {
	#name : 'Opening',
	#superclass : 'Object',
	#instVars : [
		'name',
		'moves',
		'melody'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'instance creation' }
Opening class >> named: aName [
    ^ self new initializeNamed: aName
]

{ #category : 'adding' }
Opening >> addMove: aChessMove [
    "Add a move to the opening sequence"
    moves add: aChessMove
]

{ #category : 'initialization' }
Opening >> generateMelody [
    "Generate MIDI melody from the move sequence"
    | mapper |
    mapper := SoundMapper new.
    melody := moves collect: [ :move | 
        Dictionary new
            at: #note put: (mapper noteForMove: move);
            at: #instrument put: (mapper instrumentForPiece: move piece);
            at: #duration put: 500; "milliseconds"
            yourself
    ]
]

{ #category : 'initialization' }
Opening >> initializeNamed: aName [
    "Initialize an opening with a name"
    name := aName.
    moves := OrderedCollection new.
    melody := OrderedCollection new
]

{ #category : 'accessing' }
Opening >> melody [
    ^ melody
]

{ #category : 'accessing' }
Opening >> melodyAt: index [
    "Return the melody note at given index"
    melody ifEmpty: [ self generateMelody ].
    ^ melody at: index
]

{ #category : 'accessing' }
Opening >> moves [
    ^ moves

]

{ #category : 'initialization' }
Opening >> name [
    ^ name
]

{ #category : 'accessing' }
Opening >> printMelodyOn: aStream [
    "Print a readable version of the melody"
    melody ifEmpty: [ self generateMelody ].
    melody withIndexDo: [ :note :index |
        aStream 
            nextPutAll: index asString, '. ';
            nextPutAll: 'Note: ', (note at: #note) asString;
            nextPutAll: ' Instrument: ', (note at: #instrument) asString;
            cr
    ]
]

{ #category : 'printing' }
Opening >> printOn: aStream [
    super printOn: aStream.
    aStream nextPutAll: ' (', name, ', ', moves size asString, ' moves)'
]
