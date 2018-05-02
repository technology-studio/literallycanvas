React = require './React-shim'

module.exports = createSetStateOnEventMixin = (eventName) ->
  componentDidMount: ->
    @unsubscribeMixinFuncs = [
      @props.lc.on eventName, (=> @setState @getState()), 'main',
      @props.lc.on eventName, (=> @setState @getState()), 'second' # TODO: find a better solution than hardcoding layers
    ]
    @unsubscribe = =>
      for func in @unsubscribeMixinFuncs
        func()
  componentWillUnmount: -> @unsubscribe()
