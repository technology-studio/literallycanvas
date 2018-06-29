{ToolWithStroke} = require './base'
{createShape} = require '../core/shapes'

module.exports = class AdvancedPencil extends ToolWithStroke

  usesSimpleAPI: false
  name: 'AdvancedPencil'
  iconName: 'pencil'

  eventTimeThreshold: 10

  didBecomeActive: (lc) ->
    super(lc)
    unsubscribeFuncs = []
    @unsubscribe = =>
      for func in unsubscribeFuncs
        func()

    onPointerDown = ({x, y}) =>
      @color = lc.getColor('primary')
      @currentShape = @makeShape()
      @currentShape.addPoint(@makePoint(x, y, lc))
      @lastEventTime = Date.now()
      # console.log 'AdvancedPencil - onPointerDown'
      lc.setShapesInProgress([@currentShape])
      lc.repaintLayer(lc.currentLayer)

    onPointerDrag = ({x, y}) =>
      timeDiff = Date.now() - @lastEventTime
      # console.log 'AdvancedPencil - onPointerDrag'
      if timeDiff > @eventTimeThreshold
        @lastEventTime += timeDiff
        @currentShape.addPoint(@makePoint(x, y, lc))
        lc.drawShapeInProgress(@currentShape)
        lc.setShapesInProgress([@currentShape])
        lc.repaintLayer(lc.currentLayer)

    onPointerUp = ({x, y}) =>
      # console.log 'AdvancedPencil - onPointerUp'
      lc.setShapesInProgress([])
      lc.saveShape(@currentShape)
      @currentShape = undefined

    unsubscribeFuncs.push lc.on 'lc-pointerdown', onPointerDown, 'main'
    unsubscribeFuncs.push lc.on 'lc-pointerdrag', onPointerDrag, 'main'
    unsubscribeFuncs.push lc.on 'lc-pointerup', onPointerUp, 'main'

    unsubscribeFuncs.push lc.on 'lc-pointerdown', onPointerDown, 'second'
    unsubscribeFuncs.push lc.on 'lc-pointerdrag', onPointerDrag, 'second'
    unsubscribeFuncs.push lc.on 'lc-pointerup', onPointerUp, 'second'

  willBecomeInactive: (lc) ->
    super(lc)
    @unsubscribe()

  makePoint: (x, y, lc) ->
    createShape('Point', {x, y, size: @strokeWidth, @color})
  makeShape: -> createShape('LinePath')

#
#
#
  # begin: (x, y, lc) ->
  #   @color = lc.getColor('primary')
  #   @currentShape = @makeShape()
  #   @currentShape.addPoint(@makePoint(x, y, lc))
  #   @lastEventTime = Date.now()
  #
  # continue: (x, y, lc) ->
  #   timeDiff = Date.now() - @lastEventTime
  #
  #   if timeDiff > @eventTimeThreshold
  #     @lastEventTime += timeDiff
  #     @currentShape.addPoint(@makePoint(x, y, lc))
  #     lc.drawShapeInProgress(@currentShape)
  #
  # end: (x, y, lc) ->
  #   lc.saveShape(@currentShape)
  #   @currentShape = undefined
  #
  # makePoint: (x, y, lc) ->
  #   createShape('Point', {x, y, size: @strokeWidth, @color})
  # makeShape: -> createShape('LinePath')
