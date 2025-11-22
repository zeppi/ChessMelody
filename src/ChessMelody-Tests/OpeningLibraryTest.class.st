"
I test the OpeningLibrary class to ensure it correctly loads and provides access to chess openings.
"
Class {
	#name : 'OpeningLibraryTest',
	#superclass : 'TestCase',
	#instVars : [
		'library'
	],
	#category : 'ChessMelody-Tests',
	#package : 'ChessMelody-Tests'
}

{ #category : 'running' }
OpeningLibraryTest >> setUp [
    "Initialize a library for each test"
    super setUp.
    library := OpeningLibrary new
]

{ #category : 'tests' }
OpeningLibraryTest >> testAllOpeningsHaveMelodies [
    "Test that all openings have generated melodies"
    library allOpenings do: [ :opening |
        self assert: opening melody notEmpty.
        self assert: opening melody size equals: opening moves size
    ]
]

{ #category : 'tests' }
OpeningLibraryTest >> testAllOpeningsHaveMinimumMoves [
    "Test that all openings have at least 2 moves"
    library allOpenings do: [ :opening |
        self assert: opening moves size >= 2
    ]
]

{ #category : 'tests' }
OpeningLibraryTest >> testDifferentOpeningsHaveDifferentMelodies [
    "Test that different openings produce different melodies"
    | italian ruyLopez |
    italian := library openingNamed: 'Italian Game'.
    ruyLopez := library openingNamed: 'Ruy Lopez'.
    
    "First 4 moves are the same, 5th should differ"
    self deny: (italian melodyAt: 5) equals: (ruyLopez melodyAt: 5)
]

{ #category : 'tests' }
OpeningLibraryTest >> testInitialization [
    "Test that library is properly initialized"
    self assert: library notNil.
    self assert: library allOpenings notEmpty
]

{ #category : 'tests' }
OpeningLibraryTest >> testItalianGameStructure [
    "Test that Italian Game has correct move sequence"
    | italian |
    italian := library openingNamed: 'Italian Game'.
    
    self assert: italian moves size equals: 5.
    self assert: italian moves first fromSquare equals: 'e2'.
    self assert: italian moves first toSquare equals: 'e4'
]

{ #category : 'tests' }
OpeningLibraryTest >> testLoadPopularOpenings [
    "Test that popular openings are loaded"
    | names |
    names := library allOpeningNames.
    
    self assert: (names includes: 'Italian Game').
    self assert: (names includes: 'Ruy Lopez').
    self assert: (names includes: 'Sicilian Defense').
    self assert: (names includes: 'French Defense')
]

{ #category : 'tests' }
OpeningLibraryTest >> testMelodyConsistency [
    "Test that melodies are consistent with moves"
    | sicilian mapper |
    sicilian := library openingNamed: 'Sicilian Defense'.
    mapper := SoundMapper new.
    
    sicilian moves withIndexDo: [ :move :index |
        | melodyNote expectedNote |
        melodyNote := (sicilian melodyAt: index) at: #note.
        expectedNote := mapper noteForMove: move.
        self assert: melodyNote equals: expectedNote
    ]
]

{ #category : 'tests' }
OpeningLibraryTest >> testNonExistentOpening [
    "Test that requesting non-existent opening returns nil"
    | opening |
    opening := library openingNamed: 'Nonexistent Opening'.
    
    self assert: opening isNil
]

{ #category : 'tests' }
OpeningLibraryTest >> testNumberOfOpenings [
    "Test that we have at least 4 openings"
    self assert: library allOpenings size >= 4
]

{ #category : 'tests' }
OpeningLibraryTest >> testOpeningNamed [
    "Test accessing an opening by name"
    | italian |
    italian := library openingNamed: 'Italian Game'.
    
    self assert: italian notNil.
    self assert: italian name equals: 'Italian Game'.
    self assert: italian moves notEmpty
]

{ #category : 'tests' }
OpeningLibraryTest >> testOpeningNamesSorted [
    "Test that opening names are returned sorted"
    | names sortedNames |
    names := library allOpeningNames.
    sortedNames := names asSortedCollection.
    
    self assert: names equals: sortedNames
]
