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

import dom
import actions/keyboardaction

export KeyCode, isKeyStartPressing, isKeyDown, isKeyStartReleasing, isKeyUp

type
  Actions* = ref object of RootObj
    keyboard: KeyboardAction


proc keyboard*(self: Actions): KeyboardAction = self.keyboard


proc newActions*(target: EventTarget): Actions =
  Actions(keyboard: newKeyboardAction(target))


proc init*(self: Actions) =
  self.keyboard.init()


proc update*(self: Actions) =
  self.keyboard.update()
