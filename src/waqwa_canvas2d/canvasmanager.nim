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
import private/htmlcanvas

type
  CanvasManager* = ref object of RootObj
    canvas: CanvasElement
    parent: Node
    hover: Element
    resizeListener: (proc (ev: Event) {.closure, tags: [].})
    isFullscreen: bool

proc newCanvasManager*(canvas: CanvasElement): CanvasManager =
  CanvasManager(canvas: canvas, parent: canvas.parentNode, isFullscreen: false)


proc width*(self: CanvasManager): Natural =
  self.canvas.width


proc height*(self: CanvasManager): Natural =
  self.canvas.height


proc createHoverElement: Element {.inline.} =
  result = document.createElement("div")
  let hoverStyle = result.style

  hoverStyle.setProperty "position", "absolute"
  hoverStyle.setProperty "margin", "0"
  hoverStyle.setProperty "padding", "0"
  hoverStyle.setProperty "top", "0"
  hoverStyle.setProperty "bottom", "0"
  hoverStyle.setProperty "left", "0"
  hoverStyle.setProperty "right", "0"
  hoverStyle.setProperty "width", "100vw"
  hoverStyle.setProperty "height", "100vh"
  hoverStyle.setProperty "background-color", "#000C"


proc requestFullscreen*(self: CanvasManager) =
  if self.isFullscreen: return
  if self.hover.isNil:
    self.hover = createHoverElement()

  self.parent.removeChild(self.canvas)
  document.body.appendChild(self.hover)

  proc center =
    let
      hoverRect = self.hover.getBoundingClientRect()
      scaleX = hoverRect.width / self.canvas.width.toFloat()
      scaleY = hoverRect.height / self.canvas.height.toFloat()
      scale = min(scaleX, scaleY)

      canvasStyle = self.canvas.style
      canvasWidth = self.canvas.width.toFloat() * scale
      canvasHeight = self.canvas.height.toFloat() * scale

    canvasStyle.setProperty "position", "relative"
    canvasStyle.setProperty "margin", "auto"
    canvasStyle.setProperty "width", $toInt(canvasWidth) & "px"
    canvasStyle.setProperty "height", $toInt(canvasHeight) & "px"
    canvasStyle.setProperty "left", $toInt((hoverRect.width - canvasWidth) / 2) & "px"
    canvasStyle.setProperty "right", $toInt((hoverRect.width - canvasWidth) / 2) & "px"
    canvasStyle.setProperty "top", $toInt((hoverRect.height - canvasHeight) / 2) & "px"
    canvasStyle.setProperty "bottom", $toInt((hoverRect.height - canvasHeight) / 2) & "px"

  center()

  self.resizeListener = (proc (ev: Event) = center())
  window.addEventListener($DomEvent.Resize, self.resizeListener)

  self.hover.appendChild(self.canvas)

  self.isFullscreen = true


proc exitFullScreen*(self: CanvasManager) =
  if not self.isFullscreen: return

  self.hover.removeChild(self.canvas)

  window.removeEventListener($DomEvent.Resize, self.resizeListener)
  self.resizeListener = nil

  let canvasStyle = self.canvas.style

  canvasStyle.removeProperty "position"
  canvasStyle.removeProperty "margin"
  canvasStyle.removeProperty "width"
  canvasStyle.removeProperty "height"
  canvasStyle.removeProperty "left"
  canvasStyle.removeProperty "right"
  canvasStyle.removeProperty "top"
  canvasStyle.removeProperty "bottom"

  document.body.removeChild(self.hover)
  self.parent.appendChild(self.canvas)

  self.isFullscreen = false
