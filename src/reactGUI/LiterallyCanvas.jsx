const React = require('../reactGUI/React-shim');
const createReactClass = require('../reactGUI/createReactClass-shim');
const { findDOMNode } = require('../reactGUI/ReactDOM-shim');
const { classSet } = require('../core/util');
const Picker = require('./Picker');
const Options = require('./Options');
const StampPicker = require('./StampPicker');
const createToolButton = require('./createToolButton');
const LiterallyCanvasModel = require('../core/LiterallyCanvas');
const defaultOptions = require('../core/defaultOptions');

require('../optionsStyles/font');
require('../optionsStyles/stroke-width');
require('../optionsStyles/line-options-and-stroke-width');
require('../optionsStyles/polygon-and-stroke-width');
require('../optionsStyles/null');


const CanvasContainer = createReactClass({
  displayName: 'CanvasContainer',
  shouldComponentUpdate() {
    // Avoid React trying to control this DOM
    return false;
  },
  render() {
    return (
      <div key="literallycanvas" className="lc-drawing with-gui" />
    );
  }
})

const LiterallyCanvas = createReactClass({
  displayName: 'LiterallyCanvas',

  getDefaultProps() { return defaultOptions; },

  bindToModel() {
    const canvasContainerEl = findDOMNode(this.canvas);
    const opts = this.props;
    this.lc.bindToElement(canvasContainerEl);

    if (typeof this.lc.opts.onInit === 'function') {
      this.lc.opts.onInit(this.lc);
    }
  },

  componentWillMount() {
    if (this.lc) return;

    if (this.props.lc) {
      this.lc = this.props.lc;
    } else {
      this.lc = new LiterallyCanvasModel(this.props);
    }

    this.toolButtonComponents = this.lc.opts.tools.map(ToolClass => {
      return createToolButton(new ToolClass(this.lc));
    });
  },

  componentDidMount() {
    if (!this.lc.isBound) {
      this.bindToModel();
    }
  },

  componentWillUnmount() {
    if (this.lc) {
      this.lc._teardown();
    }
  },

  render() {
    const { lc, toolButtonComponents, props } = this;
    const { imageURLPrefix, toolbarPosition, imageSize, stamps, stampTool } = this.lc.opts;

    const pickerProps = { lc, toolButtonComponents, imageURLPrefix };
    const topOrBottomClassName = classSet({
      'toolbar-at-top': toolbarPosition === 'top',
      'toolbar-at-bottom': toolbarPosition === 'bottom',
      'toolbar-hidden': toolbarPosition === 'hidden'
    });

    const style = {}
    if (imageSize.height)
      style.height = imageSize.height

    return (
      <div className={`literally ${topOrBottomClassName}`} style={style}>
        <CanvasContainer ref={item => this.canvas = item} />
        <Picker {...pickerProps} />
        <Options lc={lc} imageURLPrefix={imageURLPrefix} />
        <StampPicker lc={lc} imageURLPrefix={imageURLPrefix} stamps={stamps} stampTool={stampTool} />
      </div>
    );
  }
});



module.exports = LiterallyCanvas
