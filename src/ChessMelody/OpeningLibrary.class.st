"
I am a library of popular chess openings.

I store a collection of predefined Opening instances with their standard move sequences.

Example:
    library := OpeningLibrary new.
    italian := library openingNamed: 'Italian Game'.
    italian moves.

I provide easy access to common openings for learning and practice.
"
Class {
	#name : 'OpeningLibrary',
	#superclass : 'Object',
	#instVars : [
		'openings'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'adding' }
OpeningLibrary >> addFrenchDefense [
    "Add the French Defense opening"
    | opening |
    opening := Opening named: 'French Defense'.
    opening addMove: (ChessMove from: 'e2' to: 'e4' piece: 'P').
    opening addMove: (ChessMove from: 'e7' to: 'e6' piece: 'P').
    opening addMove: (ChessMove from: 'd2' to: 'd4' piece: 'P').
    opening addMove: (ChessMove from: 'd7' to: 'd5' piece: 'P').
    opening generateMelody.
    openings at: 'French Defense' put: opening
]

{ #category : 'adding' }
OpeningLibrary >> addItalianGame [
    "Add the Italian Game opening"
    | opening |
    opening := Opening named: 'Italian Game'.
    opening addMove: (ChessMove from: 'e2' to: 'e4' piece: 'P').
    opening addMove: (ChessMove from: 'e7' to: 'e5' piece: 'P').
    opening addMove: (ChessMove from: 'g1' to: 'f3' piece: 'N').
    opening addMove: (ChessMove from: 'b8' to: 'c6' piece: 'N').
    opening addMove: (ChessMove from: 'f1' to: 'c4' piece: 'B').
    opening generateMelody.
    openings at: 'Italian Game' put: opening
]

{ #category : 'adding' }
OpeningLibrary >> addRuyLopez [
    "Add the Ruy Lopez opening"
    | opening |
    opening := Opening named: 'Ruy Lopez'.
    opening addMove: (ChessMove from: 'e2' to: 'e4' piece: 'P').
    opening addMove: (ChessMove from: 'e7' to: 'e5' piece: 'P').
    opening addMove: (ChessMove from: 'g1' to: 'f3' piece: 'N').
    opening addMove: (ChessMove from: 'b8' to: 'c6' piece: 'N').
    opening addMove: (ChessMove from: 'f1' to: 'b5' piece: 'B').
    opening generateMelody.
    openings at: 'Ruy Lopez' put: opening
]

{ #category : 'adding' }
OpeningLibrary >> addSicilianDefense [
    "Add the Sicilian Defense opening"
    | opening |
    opening := Opening named: 'Sicilian Defense'.
    opening addMove: (ChessMove from: 'e2' to: 'e4' piece: 'P').
    opening addMove: (ChessMove from: 'c7' to: 'c5' piece: 'P').
    opening addMove: (ChessMove from: 'g1' to: 'f3' piece: 'N').
    opening addMove: (ChessMove from: 'd7' to: 'd6' piece: 'P').
    opening addMove: (ChessMove from: 'd2' to: 'd4' piece: 'P').
    opening generateMelody.
    openings at: 'Sicilian Defense' put: opening
]

{ #category : 'adding' }
OpeningLibrary >> allOpeningNames [
    "Return a collection of all opening names"
    ^ openings keys asSortedCollection
]

{ #category : 'adding' }
OpeningLibrary >> allOpenings [
    "Return all openings"
    ^ openings values
]

{ #category : 'initialization' }
OpeningLibrary >> initialize [
    "Initialize the library with popular openings"
    super initialize.
    openings := Dictionary new.
    self loadPopularOpenings
]

{ #category : 'initialization' }
OpeningLibrary >> loadPopularOpenings [
    "Load the most popular chess openings"
    self addItalianGame.
    self addRuyLopez.
    self addSicilianDefense.
    self addFrenchDefense
]

{ #category : 'adding' }
OpeningLibrary >> openingNamed: aName [
    "Return the opening with the given name"
    ^ openings at: aName ifAbsent: [ nil ]
]
