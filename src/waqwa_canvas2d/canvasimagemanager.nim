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

import dom, tables, asyncjs
from scenefw import WaqwaError
import private/htmlcanvas

type
  ImageContainer = ref object
    src: string
    width, height: Natural
    originalImage: ImageElement
    case isSprite: bool
    of true:
      spriteWidth, spriteHeight: Positive
      spriteImages: seq[ImageBitmap]

    of false:
      image: ImageBitmap

  CanvasImageManager* = ref object
    images: TableRef[string, ImageContainer]
    loadingImageIds: seq[string]
    loadingImageCount: Natural


proc newImage: ImageElement {.importcpp: "(new Image())".}
proc newImage(width, height: Positive): ImageElement {.importcpp: "(new Image(@))".}


proc newCanvasImageManager*: CanvasImageManager =
  CanvasImageManager(images: newTable[string, ImageContainer](), loadingImageCount: 0)


proc addImage*(self: CanvasImageManager; imageId, src: string) =
  self.images[imageId] = ImageContainer(src: src, width: 0, height: 0, isSprite: false)
  self.loadingImageIds.add imageId


proc addImage*(self: CanvasImageManager; imageId, src: string; width, height: Positive) =
  self.images[imageId] = ImageContainer(src: src, width: width, height: height, isSprite: false)
  self.loadingImageIds.add imageId


proc addSprite*(self: CanvasImageManager; imageId, src: string; spriteWidth, spriteHeight: Positive) =
  self.images[imageId] = ImageContainer(src: src, width: 0, height: 0, isSprite: true,
    spriteWidth: spriteWidth, spriteHeight: spriteHeight)
  self.loadingImageIds.add imageId


proc addSprite*(self: CanvasImageManager; imageId, src: string; width, height, spriteWidth, spriteHeight: Positive) =
  self.images[imageId] = ImageContainer(src: src, width: width, height: height, isSprite: true,
    spriteWidth: spriteWidth, spriteHeight: spriteHeight)
  self.loadingImageIds.add imageId


proc loadOriginalImage(container: ImageContainer): Future[ImageElement] =
  result = newPromise() do (resolve: (proc (response: ImageElement) {.closure.})):
    let originalImage = if container.width > 0: newImage(container.width, container.height) else: newImage()

    originalImage.addEventListener($DomEvent.Load) do (ev: Event):
      container.originalImage = originalImage

      if container.width == 0:
        container.width = originalImage.width
        container.height = originalImage.height

      resolve(originalImage)

    originalImage.src = container.src


proc load*(self: CanvasImageManager) {.async.} =
  self.loadingImageCount = self.loadingImageIds.len
  while self.loadingImageIds.len > 0:
    let
      imageId = self.loadingImageIds[0]
      container = self.images[imageId]
      originalImage = await loadOriginalImage(container)

    if container.isSprite:
      let
        columnCount = container.width div container.spriteWidth
        rowCount = container.height div container.spriteHeight

      for i in 0..<columnCount * rowCount:
        let
          x = (i mod columnCount) * container.spriteWidth
          y = (i div columnCount) * container.spriteHeight
          bitmap = await originalImage.createImageBitmap(x, y, container.spriteWidth, container.spriteHeight)

        container.spriteImages.add bitmap

    else:
      let bitmap = await originalImage.createImageBitmap()
      container.image = bitmap

    self.loadingImageIds.del(0)

  self.loadingImageCount = 0


proc progress*(self: CanvasImageManager): range[0.0..1.0] =
  if self.loadingImageCount == 0: return 1.0
  let loadedCount = self.loadingImageCount - self.loadingImageIds.len
  result = loadedCount.toFloat() / self.loadingImageCount.toFloat()


proc getImage*(self: CanvasImageManager; imageId: string; spriteNumber: Natural = 0): ImageBitmap =
  if not self.images.hasKey(imageId):
    raise WaqwaError.newException("[canvas2d] There is no image of id '" & imageId & "'.")

  let container = self.images[imageId]
  if container.isSprite:
    let idx = spriteNumber mod container.spriteImages.len
    result = container.spriteImages[idx]

  else:
    result = container.image
