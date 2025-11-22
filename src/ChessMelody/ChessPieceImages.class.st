"
I manage chess piece images for the UI.

I load and cache PNG images of chess pieces.
"
Class {
	#name : 'ChessPieceImages',
	#superclass : 'Object',
	#instVars : [
		'imageCache'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'utilities' }
ChessPieceImages >> assetsDirectory [
    "Return the assets directory in the git repository"
    | repo |
    repo := IceRepository registry 
        detect: [ :r | r name = 'ChessMelody' ]
        ifNone: [ ^ FileLocator imageDirectory / 'chess-pieces' ].
    
    ^ repo location / 'assets' / 'chess-pieces'
]

{ #category : 'actions' }
ChessPieceImages >> createPlaceholderForm: piece color: color [
    "Create a simple form with text"
    | form canvas |
    form := Form extent: 50@50 depth: 32.
    form fillColor: Color transparent.
    
    canvas := FormCanvas on: form.
    canvas fillColor: color.
    canvas frameAndFillRectangle: (0@0 corner: 50@50) 
           fillColor: (color alpha: 0.3)
           borderWidth: 2 
           borderColor: color.
    
    "Draw text"
    canvas 
        drawString: piece asString 
        at: 15@10 
        font: (LogicalFont familyName: 'Arial' pointSize: 24)
        color: color.
    
    ^ form
]

{ #category : 'actions' }
ChessPieceImages >> generatePlaceholderImages [
    "Generate simple placeholder images for pieces"
    | whiteColor blackColor |
    whiteColor := Color white.
    blackColor := Color black.
    
    "White pieces"
    imageCache at: 'K' put: (self createPlaceholderForm: 'K' color: whiteColor).
    imageCache at: 'Q' put: (self createPlaceholderForm: 'Q' color: whiteColor).
    imageCache at: 'R' put: (self createPlaceholderForm: 'R' color: whiteColor).
    imageCache at: 'B' put: (self createPlaceholderForm: 'B' color: whiteColor).
    imageCache at: 'N' put: (self createPlaceholderForm: 'N' color: whiteColor).
    imageCache at: 'P' put: (self createPlaceholderForm: 'P' color: whiteColor).
    
    "Black pieces"
    imageCache at: 'k' put: (self createPlaceholderForm: 'k' color: blackColor).
    imageCache at: 'q' put: (self createPlaceholderForm: 'q' color: blackColor).
    imageCache at: 'r' put: (self createPlaceholderForm: 'r' color: blackColor).
    imageCache at: 'b' put: (self createPlaceholderForm: 'b' color: blackColor).
    imageCache at: 'n' put: (self createPlaceholderForm: 'n' color: blackColor).
    imageCache at: 'p' put: (self createPlaceholderForm: 'p' color: blackColor)
]

{ #category : 'utilities' }
ChessPieceImages >> imageFor: piece [
    "Return the image for a piece"
    ^ imageCache at: piece ifAbsent: [ self createPlaceholderForm: piece color: Color red ]
]

{ #category : 'initialization' }
ChessPieceImages >> initialize [
    "Initialize the image cache"
    super initialize.
    imageCache := Dictionary new.
    self loadImages
]

{ #category : 'actions' }
ChessPieceImages >> loadImages [
    "Load all piece images from files or generate placeholders"
    | assetsDir |
    assetsDir := self assetsDirectory.
    
    assetsDir exists 
        ifTrue: [ 
            Transcript show: 'Loading images from: ', assetsDir fullName; cr.
            self loadImagesFromDirectory: assetsDir 
        ]
        ifFalse: [ 
            Transcript show: 'Assets directory not found, using placeholders'; cr.
            self generatePlaceholderImages 
        ]
]

{ #category : 'utilities' }
ChessPieceImages >> loadImagesFromDirectory: directory [
    "Load images from a specific directory"
    
    "White pieces"
    imageCache at: 'K' put: (self loadPNG: directory / 'white-king.png').
    imageCache at: 'Q' put: (self loadPNG: directory / 'white-queen.png').
    imageCache at: 'R' put: (self loadPNG: directory / 'white-rook.png').
    imageCache at: 'B' put: (self loadPNG: directory / 'white-bishop.png').
    imageCache at: 'N' put: (self loadPNG: directory / 'white-knight.png').
    imageCache at: 'P' put: (self loadPNG: directory / 'white-pawn.png').
    
    "Black pieces"
    imageCache at: 'k' put: (self loadPNG: directory / 'black-king.png').
    imageCache at: 'q' put: (self loadPNG: directory / 'black-queen.png').
    imageCache at: 'r' put: (self loadPNG: directory / 'black-rook.png').
    imageCache at: 'b' put: (self loadPNG: directory / 'black-bishop.png').
    imageCache at: 'n' put: (self loadPNG: directory / 'black-knight.png').
    imageCache at: 'p' put: (self loadPNG: directory / 'black-pawn.png').
    
    Transcript show: 'Loaded ', imageCache size asString, ' piece images'; cr
]

{ #category : 'utilities' }
ChessPieceImages >> loadPNG: fileReference [
    "Load a PNG file as a Form and resize it"
    | originalForm scaledForm |
    
    fileReference exists ifFalse: [
        Transcript show: 'File not found: ', fileReference fullName; cr.
        ^ self createPlaceholderForm: '?' color: Color red
    ].
    
    [ 
        originalForm := ImageReadWriter formFromFileNamed: fileReference fullName.
        
        "Redimensionner à 45x45 pixels"
        scaledForm := originalForm scaledToSize: 45 @ 45.
        
        Transcript show: 'Loaded: ', fileReference basename; cr.
        
        ^ scaledForm
    ]
    on: Error do: [ :ex |
        Transcript show: 'Failed to load: ', fileReference basename, ' - ', ex messageText; cr.
        ^ self createPlaceholderForm: '?' color: Color red
    ]
]
