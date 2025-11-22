"
provide Foreign Function Interface (FFI) bindings to native MIDI libraries.

I handle platform-specific MIDI functionality through system libraries:
- Windows: winmm.dll
- macOS: CoreMIDI/CoreAudio
- Linux: ALSA

I am used by MidiPlayer to generate actual sound output.
"
Class {
	#name : 'MidiFFI',
	#superclass : 'Object',
	#category : 'ChessMelody-ChessMelody-Core',
	#package : 'ChessMelody',
	#tag : 'ChessMelody-Core'
}

{ #category : 'accessing' }
MidiFFI >> changeInstrument: programNumber channel: channel onDevice: handle [
    "Change MIDI instrument (Program Change)"
    | message |
    message := self createMidiMessage: (16rC0 + channel) data1: programNumber data2: 0.
    ^ self midiOutShortMsg: handle message: message
]

{ #category : 'accessing' }
MidiFFI >> createMidiMessage: status data1: data1 data2: data2 [
    "Create a MIDI message from status and data bytes"
    ^ status + (data1 bitShift: 8) + (data2 bitShift: 16)
]

{ #category : 'library path' }
MidiFFI >> ffiLibraryName [
    "Return the platform-specific MIDI library"
    Smalltalk os isWindows ifTrue: [ ^ 'winmm.dll' ].
    Smalltalk os isMacOS ifTrue: [ ^ '/System/Library/Frameworks/CoreMIDI.framework/CoreMIDI' ].
    Smalltalk os isUnix ifTrue: [ ^ 'libasound.so.2' ].
    ^ self error: 'Unsupported platform'
]

{ #category : 'testing' }
MidiFFI >> isLinux [
    "Check if running on Linux"
    ^ self platform includesSubstring: 'unix'
]

{ #category : 'testing' }
MidiFFI >> isMacOS [
    "Check if running on macOS"
    ^ self platform includesSubstring: 'Mac'
]

{ #category : 'testing' }
MidiFFI >> isWindows [
    "Check if running on Windows"
    ^ self platform includesSubstring: 'Win'
]

{ #category : 'accessing' }
MidiFFI >> midiOutClose: handle [
    "Close a MIDI output device"
    ^ self ffiCall: #(uint midiOutClose(void *handle))
]

{ #category : 'accessing' }
MidiFFI >> midiOutGetNumDevs [
    "Get the number of MIDI output devices"
    ^ self ffiCall: #(uint midiOutGetNumDevs())
]

{ #category : 'accessing' }
MidiFFI >> midiOutOpen [
    "Open the default MIDI output device"
    | handle result |
    handle := ExternalAddress new.
    result := self midiOutOpenHandle: handle device: 0 callback: 0 instance: 0 flags: 0.
    result = 0 ifFalse: [ self error: 'Failed to open MIDI device' ].
    ^ handle
]

{ #category : 'accessing' }
MidiFFI >> midiOutOpen: lphmo device: uDeviceID callback: dwCallback instance: dwInstance flags: fdwOpen [
    "Open a MIDI output device"
    ^ self ffiCall: #(uint midiOutOpen(void **lphmo, uint uDeviceID, uint dwCallback, uint dwInstance, uint fdwOpen))
]

{ #category : 'accessing' }
MidiFFI >> midiOutOpenHandle: lphmo device: uDeviceID callback: dwCallback instance: dwInstance flags: fdwOpen [
    "Open a MIDI output device - internal call"
    ^ self ffiCall: #(uint midiOutOpen(void **lphmo, uint uDeviceID, uint dwCallback, uint dwInstance, uint fdwOpen))
]

{ #category : 'accessing' }
MidiFFI >> midiOutShortMsg: handle message: dwMsg [
    "Send a short MIDI message"
    ^ self ffiCall: #(uint midiOutShortMsg(void *handle, uint dwMsg))
]

{ #category : 'accessing' }
MidiFFI >> platform [
    "Return the current platform"
    ^ Smalltalk os platformName
]

{ #category : 'accessing' }
MidiFFI >> playNote: noteNumber velocity: velocity channel: channel onDevice: handle [
    "Play a MIDI note (Note On message)"
    | message |
    message := self createMidiMessage: (16r90 + channel) data1: noteNumber data2: velocity.
    ^ self midiOutShortMsg: handle message: message
]

{ #category : 'accessing' }
MidiFFI >> stopNote: noteNumber channel: channel onDevice: handle [
    "Stop a MIDI note (Note Off message)"
    | message |
    message := self createMidiMessage: (16r80 + channel) data1: noteNumber data2: 0.
    ^ self midiOutShortMsg: handle message: message
]
