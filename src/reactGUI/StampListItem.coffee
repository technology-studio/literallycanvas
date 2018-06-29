React = require './React-shim'
DOM = require '../reactGUI/ReactDOMFactories-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
{classSet} = require '../core/util'

{_} = require '../core/localization'

StampListItem = createReactClass
  displayName: 'StampListItem'
  # getInitialState: ->
  #   isSelected: @props.isSelected

  render: ->
    {div, label} = DOM
    {name} = @props
    (div \
      {
        className: classSet({
          'stamp-list-item': true,
          'selected': @props.isSelected,
        }),
        onClick: @props.onPress,
      },
      (label {}, name),
    )

module.exports = StampListItem
