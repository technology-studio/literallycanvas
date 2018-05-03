React = require './React-shim'
DOM = require '../reactGUI/ReactDOMFactories-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require './createSetStateOnEventMixin'
{classSet} = require '../core/util'

createLayerPickerButtonsComponent = (layerName) -> createReactClass
  displayName: 'LayerPickerButtons'

  getState: ->
    console.log 'getState'
    {
      currentLayer: @props.lc.currentLayer
    }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('layerChange')]

  render: ->
    console.log 'LayerPickerButtons render'
    console.log @props.lc.currentLayer
    {div, p} = DOM
    {lc, imageURLPrefix} = @props
    title = if @state.currentLayer == 'main' then '1' else '2' # TODO: use layer naming from const

    className = "lc-#{layerName} " + classSet
      'toolbar-button': true
      'thin-button': true
      'disabled': @state.currentLayer == layerName
    onClick = switch layerName
      when 'main'
        ->
          lc.currentLayer = 'main' # TODO: use layer naming from const
          lc.trigger 'layerChange', lc.currentLayer, lc.currentLayer
      when 'second'
        ->
          lc.currentLayer = 'second' # TODO: use layer naming from const
          lc.trigger 'layerChange', lc.currentLayer, lc.currentLayer
    # src = "#{imageURLPrefix}/#{activeLayer}.png"
    # style = {backgroundImage: "url(#{src})"}

    (div {className, onClick, title}, if layerName == 'main' then '1' else '2')


LayerOneButton = React.createFactory createLayerPickerButtonsComponent('main')
LayerTwoButton = React.createFactory createLayerPickerButtonsComponent('second')
LayerPickerButtons = createReactClass
  displayName: 'LayerPickerButtons'
  render: ->
    {div} = DOM
    (div {className: 'lc-layer-picker-buttons'}, LayerOneButton(@props), LayerTwoButton(@props))

module.exports = LayerPickerButtons
