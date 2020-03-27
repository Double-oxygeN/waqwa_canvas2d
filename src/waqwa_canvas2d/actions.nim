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

import actions/[keyboardaction, mouseaction]
from private/htmlcanvas import CanvasElement

type
  Actions* = ref object of RootObj
    keyboard: KeyboardAction
    mouse: MouseAction


proc keyboard*(self: Actions): KeyboardAction = self.keyboard
proc mouse*(self: Actions): MouseAction = self.mouse


proc newActions*(target: CanvasElement): Actions =
  Actions(
    keyboard: newKeyboardAction(),
    mouse: newMouseAction(target))


proc init*(self: Actions) =
  self.keyboard.init()
  self.mouse.init()


proc update*(self: Actions) =
  self.keyboard.update()
  self.mouse.update()
