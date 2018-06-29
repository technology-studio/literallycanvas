React = require './React-shim'
DOM = require '../reactGUI/ReactDOMFactories-shim'
createReactClass = require '../reactGUI/createReactClass-shim'

StampListItem = React.createFactory require './StampListItem'

{_} = require '../core/localization'

StampPicker = createReactClass
  displayName: 'StampPicker'
  getState: -> {selectedStampIndex: @props.lc.selectedStampIndex}
  getInitialState: -> @getState()
  renderBody: ->
    {div, label} = DOM
    {lc, stamps, imageURLPrefix, stampTool} = @props
    (div {className: 'lc-stamp-picker-contents'},
      stamps.map((stamp, index) =>
        (
          StampListItem({
            name: stamp.name,
            images: stamp.images,
            key: index,
            isSelected: @state.selectedStampIndex == index
            onPress: () =>
              console.log lc
              lc.setTool(new stampTool(lc))
              @setState({selectedStampIndex: index})
              lc.selectedStampIndex = index

          })
        )
        # (stamp \
        #   {
        #     lc,
        #     key: index
        #   }
        # )
      )

      # (label {}, 'test'),
      # toolButtonComponents.map((component, ix) =>
      #   (component \
      #     {
      #       lc, imageURLPrefix,
      #       key: ix
      #       isSelected: ix == @state.selectedToolIndex,
      #       onSelect: (tool) =>
      #         lc.setTool(tool)
      #         @setState({selectedToolIndex: ix})
      #     }
      #   )
      # ),
      # if toolButtonComponents.length % 2 != 0
      #   (div {className: 'toolbar-button thin-button disabled'})
      # (div style: {
      #     position: 'absolute',
      #     bottom: 0,
      #     left: 0,
      #     right: 0,
      #   },
      #   LayerPickerButtons({lc})
      #   ColorPickers({lc: @props.lc})
      #   UndoRedoButtons({lc, imageURLPrefix})
      #   ZoomButtons({lc, imageURLPrefix})
      #   ClearButton({lc})
      # )
    )
  render: ->
    {div} = DOM
    (div {className: 'lc-stamp-picker'},
      this.renderBody()
    )

module.exports = StampPicker
