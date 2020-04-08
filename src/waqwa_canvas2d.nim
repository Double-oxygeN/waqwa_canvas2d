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

import waqwa_canvas2d/[
  canvas2dcomp,
  canvas2dpainter,
  canvasimagemanager,
  canvasmanager,
  actions]
import waqwa_canvas2d/actions/[keyboardaction, mouseaction]

export canvas2dcomp
export Canvas2dPainter, canvas2dpainter.clear, drawImage, canvas2dpainter.rect, canvas2dpainter.circle, canvas2dpainter.ellipse, canvas2dpainter.fill, canvas2dpainter.stroke
export CanvasImageManager, addImage, addSprite, getImage, canvasimagemanager.load, canvasimagemanager.progress
export CanvasManager, canvasmanager.width, canvasmanager.height, requestFullscreen, exitFullscreen
export Actions, keyboard, mouse
export KeyboardAction, KeyCode, isKeyStartPressing, isKeyDown, isKeyStartReleasing, isKeyUp
export MouseAction, MouseButton, mouseaction.x, mouseaction.y, isInTarget,
  isButtonStartClick, isButtonDown, isButtonStartReleasing, isButtonUp,
  mouseButtonLeft, mouseButtonMiddle, mouseButtonRight
