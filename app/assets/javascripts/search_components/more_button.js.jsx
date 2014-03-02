/** @jsx React.DOM */

var MoreButton = React.createClass({
  button: function(){
    return <a className="btn btn-default btn-block" onClick={this.props.handler}>Get more</a>;
  },

  fallback: function(){
    return <span/>;
  },

  render: function(){
    if (this.props.active) {
      return this.button();
    }
    return this.fallback();
  }
});
