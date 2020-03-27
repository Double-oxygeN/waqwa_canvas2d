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

import dom except MouseButtons
from ../private/htmlcanvas import CanvasElement, width

type
  ButtonState* {.pure.} = enum
    up
    startClick
    down
    startRelease

  MouseButton* {.pure.} = enum
    primary
    auxilary
    secondary
    fourth
    fifth

  MouseAction* = ref object
    target: CanvasElement
    buttonState: array[MouseButton, ButtonState]
    x, y: int
    isInTarget: bool


const
  mouseButtonLeft* = MouseButton.primary
  mouseButtonRight* = MouseButton.secondary
  mouseButtonMiddle* = MouseButton.auxilary

proc x*(self: MouseAction): int = self.x
proc y*(self: MouseAction): int = self.y
proc isInTarget*(self: MouseAction): bool = self.isInTarget


proc newMouseAction*(target: CanvasElement): MouseAction =
  MouseAction(target: target, isInTarget: false)


proc init*(self: MouseAction) =
  for button in MouseButton:
    self.buttonState[button] = ButtonState.up

  self.target.addEventListener($DomEvent.MouseDown) do (ev: Event):
    let mouseEv = ev.MouseEvent

    if self.buttonState[mouseEv.button.MouseButton] != ButtonState.down:
      self.buttonState[mouseEv.button.MouseButton] = ButtonState.startClick

  self.target.addEventListener($DomEvent.MouseUp) do (ev: Event):
    let mouseEv = ev.MouseEvent

    if self.buttonState[mouseEv.button.MouseButton] != ButtonState.up:
      self.buttonState[mouseEv.button.MouseButton] = ButtonState.startRelease

  self.target.addEventListener($DomEvent.MouseMove) do (ev: Event):
    let
      mouseEv = ev.MouseEvent
      targetRect = self.target.getBoundingClientRect()
      scale = targetRect.width / self.target.width.toFloat()

    self.x = ((mouseEv.clientX.toFloat() - targetRect.left) / scale).toInt()
    self.y = ((mouseEv.clientY.toFloat() - targetRect.top) / scale).toInt()


proc update*(self: MouseAction) =
  for button in MouseButton:
    case self.buttonState[button]
    of ButtonState.startClick:
      self.buttonState[button] = ButtonState.down

    of ButtonState.startRelease:
      self.buttonState[button] = ButtonState.up

    else:
      discard


proc isButtonStartClick*(self: MouseAction; button: MouseButton): bool =
  self.buttonState[button] == ButtonState.startClick


proc isButtonDown*(self: MouseAction; button: MouseButton): bool =
  self.buttonState[button] in { ButtonState.down, ButtonState.startClick }


proc isButtonStartReleasing*(self: MouseAction; button: MouseButton): bool =
  self.buttonState[button] == ButtonState.startRelease


proc isButtonUp*(self: MouseAction; button: MouseButton): bool =
  self.buttonState[button] in { ButtonState.up, ButtonState.startRelease }

