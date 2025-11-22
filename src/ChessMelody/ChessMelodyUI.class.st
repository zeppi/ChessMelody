"
I am the main graphical user interface for ChessMelody.

I display:
- An animated chessboard showing pieces moving
- Controls to select and play openings
- Visual feedback synchronized with the melody

I use Bloc framework for rendering and animation.

Example:
    ChessMelodyUI new open.
"
Class {
	#name : 'ChessMelodyUI',
	#superclass : 'SpPresenter',
	#instVars : [
		'chessboardPresenter',
		'library',
		'player',
		'pieces',
		'currentOpening',
		'pieceImages'
	],
	#category : 'ChessMelody-ChessMelody-UI',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-UI'
}

{ #category : 'instance creation' }
ChessMelodyUI class >> open [
    "Open a new ChessMelody UI"
    <script>
    ^ self new open
]

{ #category : 'printing' }
ChessMelodyUI >> animateMove: move [
    "Animate a single move on the board"
    | piece |
    piece := pieces at: move fromSquare ifAbsent: [ ^ self ].
    pieces removeKey: move fromSquare.
    pieces at: move toSquare put: piece.
    
    "Rebuild the chessboard"
    self refreshBoard
]

{ #category : 'printing' }
ChessMelodyUI >> animateOpening [
    "Animate the opening moves with music"
    currentOpening ifNil: [ ^ self ].
    
    "Play in separate process"
    [ 
        player openMidi.
        currentOpening moves withIndexDo: [ :move :index |
            self animateMove: move.
            self playMoveSound: (currentOpening melodyAt: index).
            (Delay forMilliseconds: 600) wait
        ].
        player closeMidi
    ] fork
]

{ #category : 'builder' }
ChessMelodyUI >> createChessboardMorph [
    "Create the chessboard as a Morph with proper grid layout"
    | squareSize container files |
    squareSize := 60.
    files := #($a $b $c $d $e $f $g $h).
    
    "Container principal"
    container := Morph new.
    container color: Color transparent.
    container extent: (squareSize * 8) @ (squareSize * 8).
    
    "Créer toutes les cases avec positionnement absolu"
    8 to: 1 by: -1 do: [ :rank |
        files withIndexDo: [ :file :fileIndex |
            | square position |
            position := ((fileIndex - 1) * squareSize) @ ((8 - rank) * squareSize).
            
            square := self createSquareMorph: file asString, rank asString 
                          size: squareSize 
                          light: (fileIndex + rank) even.
            square position: position.
            container addMorph: square
        ]
    ].
    
    ^ container
]

{ #category : 'builder' }
ChessMelodyUI >> createOpeningButtonsBar [
    "Create a container with buttons for each opening"
    | container |
    container := SpBoxLayout newLeftToRight.
    
    #('Italian Game' 'Ruy Lopez' 'Sicilian Defense' 'French Defense') do: [ :name |
        container add: (self newButton
            label: name;
            action: [ self playOpening: name ];
            yourself)
    ].
    
    ^ container
]

{ #category : 'builder' }
ChessMelodyUI >> createPieceMorph: piece [
    "Create a visual morph for a chess piece using images"
    | form imageMorph |
    form := pieceImages imageFor: piece.
    imageMorph := ImageMorph new.
    imageMorph image: form.
    ^ imageMorph
]

{ #category : 'builder' }
ChessMelodyUI >> createRankMorph: rank squareSize: squareSize [
    "Create a single rank (row) of the chessboard"
    | row |
    row := Morph new.
    row color: Color transparent.
    row extent: (squareSize * 8) @ squareSize.
    row layoutPolicy: TableLayout new.
    row listDirection: #leftToRight.
    
    #('a' 'b' 'c' 'd' 'e' 'f' 'g' 'h') do: [ :file |
        | square |
        square := self createSquareMorph: file, rank asString 
                      size: squareSize 
                      light: (file first asciiValue + rank) even.
        row addMorphBack: square
    ].
    
    ^ row
]

{ #category : 'builder' }
ChessMelodyUI >> createSquareMorph: position size: size light: isLight [
    "Create a single chess square"
    | square color piece |
    color := isLight 
        ifTrue: [ Color r: 0.93 g: 0.93 b: 0.82 ]
        ifFalse: [ Color r: 0.46 g: 0.59 b: 0.34 ].
    
    square := Morph new.
    square color: color.
    square extent: size @ size.
    square borderWidth: 1.
    square borderColor: Color gray.
    
    "Add piece if exists"
    pieces ifNotNil: [
        piece := pieces at: position ifAbsent: [ nil ].
        piece ifNotNil: [
            | pieceLabel |
            pieceLabel := self createPieceMorph: piece.
            "Centrer la pièce dans la case"
            pieceLabel position: ((size - 45) / 2) @ ((size - 45) / 2).
            square addMorph: pieceLabel
        ]
    ].
    
    ^ square
]

{ #category : 'layout' }
ChessMelodyUI >> defaultLayout [
    "Define the UI layout"
    | buttonsLayout |
    
    "Créer les boutons dans le layout"
    buttonsLayout := SpBoxLayout newLeftToRight.
    library allOpeningNames do: [ :name |
        buttonsLayout add: (self newButton
            label: name;
            action: [ self playOpening: name ];
            yourself)
    ].
    
    ^ SpBoxLayout newTopToBottom
        add: (self newLabel 
            label: 'ChessMelody - Learn Openings with Music') 
        expand: false;
        add: #chessboardPresenter;
        add: buttonsLayout expand: false;
        yourself
]

{ #category : 'initialization' }
ChessMelodyUI >> ensureInitialized [
    "Ensure all instance variables are initialized"
    pieces ifNil: [ pieces := Dictionary new. self initializePieces ].
    pieceImages ifNil: [ pieceImages := ChessPieceImages new ].
    library ifNil: [ library := OpeningLibrary new ].
    player ifNil: [ player := MidiPlayer new ].
    
    self initializePieces
]

{ #category : 'initialization' }
ChessMelodyUI >> initialize [
    "Initialize the UI"
    super initialize.
    self ensureInitialized.
]

{ #category : 'initialization' }
ChessMelodyUI >> initializePieces [
    "Initialize piece positions at starting position"
    pieces := Dictionary new.
    
    "Pawns"
    self placePieces: 'PPPPPPPP' onRank: 2.
    self placePieces: 'pppppppp' onRank: 7.
    
    "Back ranks"
    self placePieces: 'RNBQKBNR' onRank: 1.
    self placePieces: 'rnbqkbnr' onRank: 8
]

{ #category : 'initialization' }
ChessMelodyUI >> initializePresenters [
    "Initialize the Spec presenters"
    super initializePresenters.
    self ensureInitialized.
    
    chessboardPresenter := self newMorph.
    chessboardPresenter morph: self createChessboardMorph.
]

{ #category : 'presenters' }
ChessMelodyUI >> initializeWindow: aWindowPresenter [
    "Initialize the window"
    aWindowPresenter
        title: 'ChessMelody';
        initialExtent: 600 @ 600
]

{ #category : 'initialization' }
ChessMelodyUI >> placePieces: piecesString onRank: rank [
    "Place pieces from a string on a given rank"
    | files |
    files := #($a $b $c $d $e $f $g $h).
    
    piecesString withIndexDo: [ :piece :index |
        pieces at: (files at: index) asString, rank asString 
               put: piece asString
    ]
]

{ #category : 'actions' }
ChessMelodyUI >> playMoveSound: noteData [
    "Play the sound for a move"
    | note instrument channel |
    note := noteData at: #note.
    instrument := noteData at: #instrument.
    channel := 0.
    
    player midiFFI changeInstrument: instrument channel: channel onDevice: player midiHandle.
    player midiFFI playNote: note velocity: 100 channel: channel onDevice: player midiHandle.
    (Delay forMilliseconds: 500) wait.
    player midiFFI stopNote: note channel: channel onDevice: player midiHandle
]

{ #category : 'actions' }
ChessMelodyUI >> playOpening: openingName [
    "Play an opening with animation and music"
    currentOpening := library openingNamed: openingName.
    self initializePieces.
    self refreshBoard.
    self animateOpening
]

{ #category : 'printing' }
ChessMelodyUI >> refreshBoard [
    "Refresh the chessboard display"
    chessboardPresenter morph: self createChessboardMorph
]
