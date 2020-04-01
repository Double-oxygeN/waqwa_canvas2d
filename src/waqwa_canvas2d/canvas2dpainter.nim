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

import dom, asyncjs
from scenefw import WaqwaDrawEffect
import private/htmlcanvas

type
  Canvas2dPainter* = ref object of RootObj
    canvas: CanvasElement
    bitmapRenderer: ImageBitmapRenderingContext
    ctx: CanvasRenderingContext2d ## not related to canvas property


proc newCanvas2dPainter*(canvas: CanvasElement): Canvas2dPainter =
  result = Canvas2dPainter(
    canvas: canvas,
    bitmapRenderer: canvas.getBitmapRendererContext())
  let offscreenCanvas = document.createElement("canvas").CanvasElement
  offscreenCanvas.width = canvas.width
  offscreenCanvas.height = canvas.height
  result.ctx = offscreenCanvas.getContext2d()


proc display*(self: Canvas2dPainter) =
  proc display0 {.async.} =
    let bitmap = await self.ctx.canvas.createImageBitmap()
    self.bitmapRenderer.transferFromImageBitmap(bitmap)
    close bitmap

  discard display0()


{.push tags: [WaqwaDrawEffect].}

proc clear*(self: Canvas2dPainter; color: string = "#000") =
  ## Clear the canvas with filling the color.
  self.ctx.fillStyle = color
  self.ctx.fillRect(0, 0, self.canvas.width, self.canvas.height)


proc drawImage*(self: Canvas2dPainter; image: ImageBitmap; x, y: int | float) =
  ## Draw an image.
  self.ctx.drawImage(image, x, y)

proc drawImage*(self: Canvas2dPainter; image: ImageBitmap; x, y, width, height: int | float) =
  ## Draw an image.
  self.ctx.drawImage(image, x, y, width, height)

proc drawImage*(self: Canvas2dPainter; image: ImageBitmap; sx, sy, swidth, sheight, dx, dy, dwidth, dheight: int | float) =
  ## Draw an image.
  self.ctx.drawImage(image, sx, sy, swidth, sheight, dx, dy, dwidth, dheight)



{.pop.}
