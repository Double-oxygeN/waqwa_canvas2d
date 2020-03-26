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
import scenefw/effects

type
  CanvasElement* {.importc.} = ref object of Element
    width*, height*: Natural

  RenderingContext {.importc.} = ref object of RootObj

  CanvasRenderingContext2d* {.importc.} = ref object of RenderingContext
    canvas: CanvasElement # read-only
    # Line styles
    lineWidth*: cdouble
    lineCap*: cstring
    lineJoin*: cstring
    miterLimit*: cdouble
    lineDashOffset*: cdouble
    # Text styles
    font*: cstring
    testAlign*: cstring
    textBaseline*: cstring
    direction*: cstring
    # Shadows
    shadowBlur*: cdouble
    shadowColor*: cstring
    shadowOffsetX*, shadowOffsetY*: cdouble
    # Compositing
    globalAlpha*: range[0.0..1.0]
    globalCompositeOperation*: cstring
    # Image smoothing
    imageSmoothingEnabled*: bool
    imageSmoothingQuality*: cstring
    # Filters
    filter*: cstring

  ImageBitmapRenderingContext* {.importc.} = ref object of RenderingContext

  ImageBitmap* {.importc.} = ref object
    width, height: culong # read-only

  TextMetrics* {.importc.} = ref object
    width: cdouble # read-only

  CanvasGradient* {.importc.} = ref object

  CanvasPattern* {.importc.} = ref object

  Path2D* {.importc.} = ref object

  DomMatrix* {.importc: "DOMMatrix".} = ref object
    is2D: bool # read-only
    isIdentity: bool # read-only
    m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44: cdouble
    a, b, c, d, e, f: cdouble

  ImageData* {.importc.} = ref object
    data: seq[uint8] # read-only
    width, height: culong # read-only

  CanvasImageSource* = ImageElement | CanvasElement | ImageBitmap

# Getters
proc canvas*(ctx: CanvasRenderingContext2d): CanvasElement = ctx.canvas
proc width*(bitmap: ImageBitmap): culong = bitmap.width
proc height*(bitmap: ImageBitmap): culong = bitmap.height
proc width*(metrics: TextMetrics): cdouble = metrics.width
proc is2D*(matrix: DomMatrix): bool = matrix.is2D
proc isIdentity*(matrix: DomMatrix): bool = matrix.isIdentity
proc data*(imagedata: ImageData): seq[uint8] = imagedata.data
proc width*(imagedata: ImageData): culong = imagedata.width
proc height*(imagedata: ImageData): culong = imagedata.height

# HTML Canvas
proc getContext2d*(canvas: CanvasElement): CanvasRenderingContext2d {.importcpp: "#.getContext('2d')"}
proc getBitmapRendererContext*(canvas: CanvasElement): ImageBitmapRenderingContext {.importcpp: "#.getContext('bitmaprenderer')"}

# Fill and stroke styles
{.push nodecl, tags: [WaqwaDrawEffect]}
proc `fillStyle=`*(ctx: CanvasRenderingContext2d; color: cstring) {.importcpp: "#.fillStyle = #".}
proc `fillStyle=`*(ctx: CanvasRenderingContext2d; gradient: CanvasGradient) {.importcpp: "#.fillStyle = #".}
proc `fillStyle=`*(ctx: CanvasRenderingContext2d; pattern: CanvasPattern) {.importcpp: "#.fillStyle = #".}
proc `strokeStyle=`*(ctx: CanvasRenderingContext2d; color: cstring) {.importcpp: "#.strokeStyle = #".}
proc `strokeStyle=`*(ctx: CanvasRenderingContext2d; gradient: CanvasGradient) {.importcpp: "#.strokeStyle = #".}
proc `strokeStyle=`*(ctx: CanvasRenderingContext2d; pattern: CanvasPattern) {.importcpp: "#.strokeStyle = #".}
{.pop.}

{.push importcpp.}
{.push tags: [WaqwaDrawEffect].}
# Drawing rectangles
proc clearRect*(ctx: CanvasRenderingContext2d; x, y, width, height: int | float)
proc fillRect*(ctx: CanvasRenderingContext2d; x, y, width, height: int | float)
proc strokeRect*(ctx: CanvasRenderingContext2d; x, y, width, height: int | float)

# Drawing text
proc fillText*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc fillText*(ctx: CanvasRenderingContext2d; x, y, maxWidth: int | float)
proc strokeText*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc strokeText*(ctx: CanvasRenderingContext2d; x, y, maxWidth: int | float)
{.pop.}
proc measureText*(ctx: CanvasRenderingContext2d; text: cstring): TextMetrics

# Line styles
proc getLineDash*(ctx: CanvasRenderingContext2d): seq[cint]
proc setLineDash*(ctx: CanvasRenderingContext2d; segment: seq[cint]) {.tags: [WaqwaDrawEffect].}

# Gradients and patterns
proc createLinearGradient*(ctx: CanvasRenderingContext2d; x0, y0, x1, y1: int | float): CanvasGradient
proc createRadialGradient*(ctx: CanvasRenderingContext2d; x0, y0, r0, x1, y1, r1: int | float): CanvasGradient
proc createPattern*(ctx: CanvasRenderingContext2d; image: CanvasImageSource; repetition: cstring): CanvasPattern
proc addColorStop*(gradient: CanvasGradient; offset: range[0.0..1.0]; color: cstring)

{.push tags: [WaqwaDrawEffect].}
# Paths
proc beginPath*(ctx: CanvasRenderingContext2d)
proc closePath*(ctx: CanvasRenderingContext2d)
proc moveTo*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc lineTo*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc bezierCurveTo*(ctx: CanvasRenderingContext2d; cp1x, cp1y, cp2x, cp2y, x, y: int | float)
proc quadraticCurveTo*(ctx: CanvasRenderingContext2d; cpx, cpy, x, y: int | float)
proc arc*(ctx: CanvasRenderingContext2d; x, y, radius, startAngle, endAngle: int | float)
proc arc*(ctx: CanvasRenderingContext2d; x, y, radius, startAngle, endAngle: int | float; anticlockwise: bool)
proc arcTo*(ctx: CanvasRenderingContext2d; x1, y1, x2, y2, radius: int | float)
proc ellipse*(ctx: CanvasRenderingContext2d; x, y, radiusX, radiusY, rotation, startAngle, endAngle: int | float)
proc ellipse*(ctx: CanvasRenderingContext2d; x, y, radiusX, radiusY, rotation, startAngle, endAngle: int | float; anticlockwise: bool)
proc rect*(ctx: CanvasRenderingContext2d; x, y, width, height: int | float)

# Drawing paths
proc fill*(ctx: CanvasRenderingContext2d)
proc fill*(ctx: CanvasRenderingContext2d; fillRule: cstring)
proc fill*(ctx: CanvasRenderingContext2d; path: Path2D)
proc fill*(ctx: CanvasRenderingContext2d; path: Path2D; fillRule: cstring)
proc stroke*(ctx: CanvasRenderingContext2d)
proc stroke*(ctx: CanvasRenderingContext2d; path: Path2D)
proc drawFocusIfNeeded*(ctx: CanvasRenderingContext2d; element: Element)
proc drawFocusIfNeeded*(ctx: CanvasRenderingContext2d; path: Path2D; element: Element)
proc clip*(ctx: CanvasRenderingContext2d)
proc clip*(ctx: CanvasRenderingContext2d; fillRule: cstring)
proc clip*(ctx: CanvasRenderingContext2d; path: Path2D)
proc clip*(ctx: CanvasRenderingContext2d; path: Path2D; fillRule: cstring)
{.pop.}
proc isPointInPath*(ctx: CanvasRenderingContext2d; x, y: int | float): bool
proc isPointInPath*(ctx: CanvasRenderingContext2d; x, y: int | float; fillRule: cstring): bool
proc isPointInPath*(ctx: CanvasRenderingContext2d; path: Path2D; x, y: int | float): bool
proc isPointInPath*(ctx: CanvasRenderingContext2d; path: Path2D; x, y: int | float; fillRule: cstring): bool
proc isPointInStroke*(ctx: CanvasRenderingContext2d; x, y: int | float): bool
proc isPointInStroke*(ctx: CanvasRenderingContext2d; path: Path2D; x, y: int | float): bool

# Transformations
proc getTransform*(ctx: CanvasRenderingContext2d): DomMatrix
{.push tags: [WaqwaDrawEffect].}
proc rotate*(ctx: CanvasRenderingContext2d; angle: int | float)
proc scale*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc translate*(ctx: CanvasRenderingContext2d; x, y: int | float)
proc transform*(ctx: CanvasRenderingContext2d; a, b, c, d, e, f: int | float)
proc setTransform*(ctx: CanvasRenderingContext2d; a, b, c, d, e, f: int | float)
proc setTransform*(ctx: CanvasRenderingContext2d; matrix: DomMatrix)
proc resetTransform*(ctx: CanvasRenderingContext2d)

# Drawing image
proc drawImage*(ctx: CanvasRenderingContext2d; image: CanvasImageSource; dx, dy: int | float)
proc drawImage*(ctx: CanvasRenderingContext2d; image: CanvasImageSource; dx, dy, dWidth, dHeight: int | float)
proc drawImage*(ctx: CanvasRenderingContext2d; image: CanvasImageSource; sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight: int | float)
{.pop.}

# Pixel manipulation
proc createImageData*(ctx: CanvasRenderingContext2d; width, height: int): ImageData
proc createImageData*(ctx: CanvasRenderingContext2d; imagedata: ImageData): ImageData
proc getImageData*(ctx: CanvasRenderingContext2d; sx, sy, sw, sh: int): ImageData
{.push tags: [WaqwaDrawEffect].}
proc putImageData*(ctx: CanvasRenderingContext2d; imagedata: ImageData; dx, dy: int)
proc putImageData*(ctx: CanvasRenderingContext2d; imagedata: ImageData; dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight: int)

# The canvas state
proc save*(ctx: CanvasRenderingContext2d)
proc restore*(ctx: CanvasRenderingContext2d)
{.pop.}

# Image bitmap
proc close*(bitmap: ImageBitmap)
proc transferFromImageBitmap*(ctx: ImageBitmapRenderingContext; bitmap: ImageBitmap) {.tags: [WaqwaDrawEffect].}

# Path 2D
proc addPath*(self, path: Path2D)
proc closePath*(ctx: Path2D)
proc moveTo*(ctx: Path2D; x, y: int | float)
proc lineTo*(ctx: Path2D; x, y: int | float)
proc bezierCurveTo*(ctx: Path2D; cp1x, cp1y, cp2x, cp2y, x, y: int | float)
proc quadraticCurveTo*(ctx: Path2D; cpx, cpy, x, y: int | float)
proc arc*(ctx: Path2D; x, y, radius, startAngle, endAngle: int | float)
proc arc*(ctx: Path2D; x, y, radius, startAngle, endAngle: int | float; anticlockwise: bool)
proc arcTo*(ctx: Path2D; x1, y1, x2, y2, radius: int | float)
proc ellipse*(ctx: Path2D; x, y, radiusX, radiusY, rotation, startAngle, endAngle: int | float)
proc ellipse*(ctx: Path2D; x, y, radiusX, radiusY, rotation, startAngle, endAngle: int | float; anticlockwise: bool)
proc rect*(ctx: Path2D; x, y, width, height: int | float)

{.pop.}

# Image data
proc newImageData*(width, height: culong): ImageData {.importcpp: "(new ImageData(@))".}
proc newImageData*(`array`: seq[uint8]; width, height: culong): ImageData {.importcpp: "(new ImageData(@))".}

# Image bitmap
proc createImageBitmap*(image: CanvasImageSource): Future[ImageBitmap] {.async, importc.}
proc createImageBitmap*(image: CanvasImageSource; sx, sy, sw, sh: int): Future[ImageBitmap] {.async, importc.}

# Path 2D
proc newPath2D*: Path2D {.importcpp: "(new Path2D())".}
proc newPath2D*(path: Path2D): Path2D {.importcpp: "(new Path2D(#))"}
