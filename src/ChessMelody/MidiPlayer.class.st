"
I am responsible for playing chess opening melodies using MIDI.

I convert the melody data (notes, instruments, durations) from Opening instances into actual MIDI sound output.

Example:
    player := MidiPlayer new.
    opening := OpeningLibrary new openingNamed: 'Italian Game'.
    player play: opening.

I use external MIDI capabilities to generate sound. The implementation depends on the platform
"
Class {
	#name : 'MidiPlayer',
	#superclass : 'Object',
	#instVars : [
		'isPlaying',
		'currentOpening',
		'midiFFI',
		'midiHandle'
	],
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'accessing' }
MidiPlayer >> closeMidi [
    "Close MIDI device"
    midiHandle ifNotNil: [
        midiFFI midiOutClose: midiHandle.
        midiHandle := nil.
        Transcript show: 'MIDI device closed'; cr
    ]
]

{ #category : 'accessing' }
MidiPlayer >> currentOpening [
    ^ currentOpening
]

{ #category : 'initialization' }
MidiPlayer >> initialize [
    "Initialize the player"
    super initialize.
    isPlaying := false.
    currentOpening := nil.
    midiFFI := MidiFFI new.
    midiHandle := nil
]

{ #category : 'accessing' }
MidiPlayer >> isPlaying [
    ^ isPlaying
]

{ #category : 'accessing' }
MidiPlayer >> midiFFI [
    "Return the MIDI FFI interface"
    ^ midiFFI
]

{ #category : 'accessing' }
MidiPlayer >> midiHandle [
    "Return the current MIDI handle"
    ^ midiHandle
]

{ #category : 'accessing' }
MidiPlayer >> openMidi [
    "Open MIDI device"
    midiHandle ifNil: [
        midiHandle := midiFFI midiOutOpen.
        Transcript show: 'MIDI device opened'; cr
    ]
]

{ #category : 'accessing' }
MidiPlayer >> play: anOpening [
    "Play the melody of an opening with real MIDI"
    currentOpening := anOpening.
    isPlaying := true.
    
    self openMidi.
    [
        self playMelody
    ] ensure: [
        self closeMidi.
        isPlaying := false
    ]
]

{ #category : 'accessing' }
MidiPlayer >> playMelody [
    "Play each note in the melody"
    currentOpening melody do: [ :noteData |
        self playNote: noteData
    ]
]

{ #category : 'accessing' }
MidiPlayer >> playNote: noteData [
    "Play a single MIDI note"
    | note instrument duration channel |
    note := noteData at: #note.
    instrument := noteData at: #instrument.
    duration := noteData at: #duration.
    channel := 0. "Use channel 0 for now"
    
    "Change instrument"
    midiFFI changeInstrument: instrument channel: channel onDevice: midiHandle.
    
    "Play note"
    midiFFI playNote: note velocity: 100 channel: channel onDevice: midiHandle.
    Transcript show: 'Playing: note=', note asString, ' instrument=', instrument asString; cr.
    
    "Wait for duration"
    (Delay forMilliseconds: duration) wait.
    
    "Stop note"
    midiFFI stopNote: note channel: channel onDevice: midiHandle
]

{ #category : 'accessing' }
MidiPlayer >> stop [
    "Stop playing immediately"
    isPlaying := false.
    self closeMidi
]
