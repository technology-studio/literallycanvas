# maybe add checks to these in the future to make sure you never double-undo or
# double-redo
class ClearAction

  constructor: (
  @lc,
  @oldShapes,
  @newShapes,
  @shapes = if @lc.currentLayer is 'main' then @lc.shapes else @lc.secondShapes
  ) ->

  do: ->
    @shapes = @newShapes
    @lc.repaintLayer(@lc.currentLayer)

  undo: ->
    @shapes = @oldShapes
    @lc.repaintLayer(@lc.currentLayer)


class MoveAction

  constructor: (@lc, @selectedShape, @previousPosition, @newPosition) ->

  do: ->
    @selectedShape.setUpperLeft {
      x: @newPosition.x,
      y: @newPosition.y
    }
    @lc.repaintLayer(@lc.currentLayer)

  undo: ->
    @selectedShape.setUpperLeft {
      x: @previousPosition.x,
      y: @previousPosition.y
    }
    @lc.repaintLayer(@lc.currentLayer)


class AddShapeAction

  constructor: (
    @lc,
    @shape,
    @previousShapeId=null,
    @shapes = if @lc.currentLayer is 'main' then @lc.shapes else @lc.secondShapes
  ) ->

  do: ->
    # common case: just add it to the end
    if (not @shapes.length or
        @shapes[@shapes.length-1].id == @previousShapeId or
        @previousShapeId == null)
      @shapes.push(@shape)
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
    @lc.repaintLayer(@lc.currentLayer)

  undo: ->
    # common case: it's the most recent shape
    if @shapes[@shapes.length-1].id == @shape.id
      @shapes.pop()
    # uncommon case: it's in the array somewhere
    else
      newShapes = []
      for shape in @shapes
        newShapes.push(shape) if shape.id != @shape.id
      lc.shapes = newShapes
    @lc.repaintLayer(@lc.currentLayer)


module.exports = {ClearAction, MoveAction, AddShapeAction}
