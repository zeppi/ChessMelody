"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestChessMelody',
	#superclass : 'PackageManifest',
	#category : 'ChessMelody-Manifest',
	#package : 'ChessMelody',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestChessMelody class >> ruleCascadedNextPutAllsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChessPieceImages #loadImagesFromDirectory: #false)) #'2025-11-24T19:23:14.576+01:00') #(#(#RGMethodDefinition #(#ChessPieceImages #loadImagesFromFiles #false)) #'2025-11-24T19:23:31.195+01:00') #(#(#RGMethodDefinition #(#ChessPieceImages #loadPNG: #false)) #'2025-11-24T19:23:53.443+01:00') #(#(#RGMethodDefinition #(#ChessPieceImages #loadImages #false)) #'2025-11-24T19:25:03.804+01:00') #(#(#RGMethodDefinition #(#Opening #printOn: #false)) #'2025-11-24T19:30:36.258+01:00') )
]

{ #category : 'code-critics' }
ManifestChessMelody class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChessMelodyUI #createOpeningButtonsBar #false)) #'2025-11-23T19:22:28.209+01:00') #(#(#RGMethodDefinition #(#ChessMelodyUI #defaultLayout #false)) #'2025-11-24T19:32:31.817+01:00') )
]

{ #category : 'code-critics' }
ManifestChessMelody class >> ruleLiteralArrayCharactersRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ChessMelodyUI #createChessboardMorph #false)) #'2025-11-23T19:04:08.209+01:00') #(#(#RGMethodDefinition #(#SoundMapper #initializeSquareMapping #false)) #'2025-11-24T19:19:10.642+01:00') #(#(#RGMethodDefinition #(#ChessMelodyUI #placePieces:onRank: #false)) #'2025-11-24T19:52:28.225+01:00') )
]

{ #category : 'code-critics' }
ManifestChessMelody class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SoundMapper #initializeSquareMapping #false)) #'2025-11-24T19:19:14.231+01:00') #(#(#RGMethodDefinition #(#ChessMelodyUI #createRankMorph:squareSize: #false)) #'2025-11-24T19:55:00.85+01:00') )
]
