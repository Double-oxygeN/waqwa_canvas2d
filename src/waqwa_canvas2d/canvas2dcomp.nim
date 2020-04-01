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
import scenefw
import canvas2dpainter, canvasimagemanager, canvasmanager, actions
from private/htmlcanvas import CanvasElement

type
  CanvasSize* = tuple
    width, height: Positive

  Canvas2dComp* = ref object of Component
    targetElement: Element
    width, height: Positive

    painter: Canvas2dPainter
    image: CanvasImageManager
    canvas: CanvasManager
    input: Actions


proc painter*(self: Canvas2dComp): Canvas2dPainter = self.painter
proc image*(self: Canvas2dComp): CanvasImageManager = self.image
proc canvas*(self: Canvas2dComp): CanvasManager = self.canvas
proc input*(self: Canvas2dComp): Actions = self.input


proc newCanvas2dComp*(targetElementId: string): Canvas2dComp =
  Canvas2dComp(
    targetElement: document.getElementById(targetElementId),
    width: 600,
    height: 600)


proc size*(self: Canvas2dComp): CanvasSize =
  (self.width, self.height)


proc `size=`*(self: Canvas2dComp; size: CanvasSize) =
  self.width = size.width
  self.height = size.height


method init(self: Canvas2dComp) =
  let canvas = document.createElement("canvas").CanvasElement
  canvas.width = self.width
  canvas.height = self.height
  self.targetElement.appendChild(canvas)

  self.painter = newCanvas2dPainter(canvas)
  self.image = newCanvasImageManager()
  self.canvas = newCanvasManager(canvas)
  self.input = newActions(canvas)

  self.input.init()


method afterDraw(self: Canvas2dComp) =
  self.painter.display()


method afterUpdate(self: Canvas2dComp) =
  self.input.update()
