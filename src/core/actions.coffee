# maybe add checks to these in the future to make sure you never double-undo or
# double-redo
class ClearAction

  constructor: (@lc, @oldShapes, @newShapes) ->

  do: ->
    @lc.clearCurrentLayer()
    @lc.repaintLayer(@lc.currentLayer)

  undo: ->
    @lc.setCurrentLayerShapes(@oldShapes)
    @lc.repaintLayer(@lc.currentLayer)


class MoveAction

  constructor: (@lc, @selectedShape, @previousPosition, @newPosition) ->

  do: ->
    @selectedShape.setUpperLeft {
      x: @newPosition.x,
      y: @newPosition.y
    }
    @lc.repaintAllLayers()

  undo: ->
    @selectedShape.setUpperLeft {
      x: @previousPosition.x,
      y: @previousPosition.y
    }
    @lc.repaintAllLayers()

class ChangeColorAction

  constructor: (@lc, @selectedShape, @previousColor, @newColor) ->

  do: ->
    @selectedShape.setFillColor(@newColor)
    @lc.repaintLayer('main')

  undo: ->
    @selectedShape.setFillColor(@previousColor)
    @lc.repaintLayer('main')

class AddShapeAction

  constructor: (
    @lc,
    @shape,
    @previousShapeId=null,
    @currentLayer = @lc.currentLayer,
    @shapes = if @currentLayer is 'main' then @lc.shapes else @lc.secondShapes
  ) ->

  do: ->
    # common case: just add it to the end
    if (not @shapes.length or
        @shapes[@shapes.length-1].id == @previousShapeId or
        @previousShapeId == null)
      @shapes.push(@shape)
      @lc.setCurrentLayerShapes(@shapes, @currentLayer)
    # uncommon case: insert it somewhere
    else
      newShapes = []
      found = false
      for shape in @shapes
        newShapes.push(shape)
        if shape.id == @previousShapeId
          newShapes.push(@shape)
          found = true
      unless found
        # given ID doesn't exist, just shove it on top
        newShapes.push(@shape)
      @shapes = newShapes
      @lc.setCurrentLayerShapes(@shapes, @currentLayer)
    @lc.repaintAllLayers()

  undo: ->
    # common case: it's the most recent shape
    if @shapes[@shapes.length-1].id == @shape.id
      @shapes.pop()
    # uncommon case: it's in the array somewhere
    else
      newShapes = []
      for shape in @shapes
        newShapes.push(shape) if shape.id != @shape.id
      @shapes = newShapes
      @lc.setCurrentLayerShapes(@shapes, @currentLayer)
    @lc.repaintAllLayers()


module.exports = {ClearAction, MoveAction, AddShapeAction, ChangeColorAction}
