"
I map chess moves to MIDI notes and instruments.

I maintain two mappings:
- squareToNoteMap: associates each square (a1-h8) with a MIDI note number (0-127)
- pieceToInstrumentMap: associates each piece type with a MIDI instrument

Example:
    mapper := SoundMapper new.
    mapper noteForSquare: 'e4'. ""returns a MIDI note number""
    mapper instrumentForPiece: 'N'. ""returns an instrument number""

I am used by Opening to generate melodies from move sequences.

"
Class {
	#name : 'SoundMapper',
	#superclass : 'Object',
	#instVars : [
		'squareToNoteMap',
		'pieceToInstrumentMap'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'initialization' }
SoundMapper >> initialize [
    "Initialize the mappings"
    super initialize.
    self initializeSquareMapping.
    self initializePieceMapping
]

{ #category : 'initialization' }
SoundMapper >> initializePieceMapping [
    "Map pieces to MIDI instruments - Piano and Strings"
    pieceToInstrumentMap := Dictionary new.
    
    "Pièces majeures : Piano Acoustique"
    pieceToInstrumentMap at: 'K' put: 0.  "Piano - Roi"
    pieceToInstrumentMap at: 'Q' put: 0.  "Piano - Dame"
    
    "Pièces puissantes : Violon (40)"
    pieceToInstrumentMap at: 'R' put: 40.  "Violin - Tours"
    pieceToInstrumentMap at: 'B' put: 40.  "Violin - Fous"
    
    "Pièces mobiles : Violoncelle (42)"
    pieceToInstrumentMap at: 'N' put: 42.  "Cello - Cavaliers"
    pieceToInstrumentMap at: 'P' put: 42.  "Cello - Pions"
]

{ #category : 'initialization' }
SoundMapper >> initializeSquareMapping [
    "Map each square to a MIDI note (60-123 = C4 to B8)"
    squareToNoteMap := Dictionary new.
    
    "Files a-h mapped to octaves, ranks 1-8 to notes in octave"
    #($a $b $c $d $e $f $g $h) withIndexDo: [ :file :fileIndex |
        1 to: 8 do: [ :rank |
            | square midiNote |
            square := file asString, rank asString.
            midiNote := 60 + ((rank - 1) * 8) + (fileIndex - 1).
            squareToNoteMap at: square put: midiNote
        ]
    ]
]

{ #category : 'mapping' }
SoundMapper >> instrumentForPiece: aPiece [
    "Return the MIDI instrument for a given piece"
    ^ pieceToInstrumentMap at: aPiece ifAbsent: [ 0 "default piano" ]
]

{ #category : 'mapping' }
SoundMapper >> noteForMove: aChessMove [
    "Return the MIDI note for a move's destination square"
    ^ self noteForSquare: aChessMove toSquare
]

{ #category : 'mapping' }
SoundMapper >> noteForSquare: aSquare [
    "Return the MIDI note for a given square"
    ^ squareToNoteMap at: aSquare ifAbsent: [ 60 "default middle C" ]
]
