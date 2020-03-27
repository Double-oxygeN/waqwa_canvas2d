# Copyright 2020 Double-oxygeN
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import dom, tables
from math import nextPowerOfTwo
from strutils import capitalizeAscii

type
  KeyState* {.pure.} = enum
    up
    startPress
    down
    startRelease

  KeyCode* {.pure.} = enum
    unidentified

    digit0, digit1, digit2, digit3, digit4
    digit5, digit6, digit7, digit8, digit9

    keyA, keyB, keyC, keyD, keyE, keyF, keyG, keyH
    keyI, keyJ, keyK, keyL, keyM, keyN, keyO, keyP
    keyQ, keyR, keyS, keyT, keyU, keyV, keyW, keyX
    keyY, keyZ

    minus, equal, semicolon, quote, backquote, backslash,
    bracketLeft, bracketRight
    comma, period, slash, intlBackslash, intlRo, intlYen

    arrowUp, arrowLeft, arrowRight, arrowDown

    escape, backspace, tab, enter, controlLeft, controlRight
    shiftLeft, shiftRight, altLeft, altRight, metaLeft, metaRight
    space, capsLock, pause, scrollLock, printScreen
    numLock, home, `end`, pageUp, pageDown, insert, delete
    kanaMode, lang1, lang2
    convert, nonConvert, undo, paste, cut, copy
    mediaTrackPrevious, mediaTrackNext, mediaPlayPause, mediaStop
    audioVolumeMute, audioVolumeDown, audioVolumeUp
    volumeDown, volumeUp, contextMenu, power
    browserSearch, browserFavorites, browserRefresh
    browserStop, browserForward, browserBack

    numpad0, numpad1, numpad2, numpad3, numpad4
    numpad5, numpad6, numpad7, numpad8, numpad9
    numpadDecimal, numpadComma, numpadAdd, numpadSubtract
    numpadMultiply, numpadDivide, numpadEnter

    f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12
    f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24

  KeyboardAction* = ref object
    keyState: array[KeyCode, KeyState]


proc newKeyboardAction*: KeyboardAction =
  new KeyboardAction


proc init*(self: KeyboardAction) =
  proc makeConvertKeyCodeToEnum: Table[string, KeyCode] {.compileTime.} =
    result = initTable[string, KeyCode](KeyCode.high.ord.nextPowerOfTwo())
    for key in KeyCode:
      result[capitalizeAscii($key)] = key

  const convertKeyCodeToEnum = makeConvertKeyCodeToEnum()

  for key in KeyCode:
    self.keyState[key] = KeyState.up

  window.addEventListener("keydown") do (ev: Event):
    ev.preventDefault()
    let
      keyEv = ev.KeyboardEvent
      keyCode = convertKeyCodeToEnum[$keyEv.code]

    if self.keyState[keyCode] != KeyState.down:
      self.keyState[keyCode] = KeyState.startPress

  window.addEventListener("keyup") do (ev: Event):
    ev.preventDefault()
    let
      keyEv = ev.KeyboardEvent
      keyCode = convertKeyCodeToEnum[$keyEv.code]

    if self.keyState[keyCode] != KeyState.up:
      self.keyState[keyCode] = KeyState.startRelease


proc update*(self: KeyboardAction) =
  for key in KeyCode:
    case self.keyState[key]
    of KeyState.startPress:
      self.keyState[key] = KeyState.down

    of KeyState.startRelease:
      self.keyState[key] = KeyState.up

    else:
      discard


proc isKeyStartPressing*(self: KeyboardAction; code: KeyCode): bool =
  self.keyState[code] == KeyState.startPress


proc isKeyDown*(self: KeyboardAction; code: KeyCode): bool =
  self.keyState[code] in { KeyState.down, KeyState.startPress }


proc isKeyStartReleasing*(self: KeyboardAction; code: KeyCode): bool =
  self.keyState[code] == KeyState.startRelease


proc isKeyUp*(self: KeyboardAction; code: KeyCode): bool =
  self.keyState[code] in { KeyState.up, KeyState.startRelease }
