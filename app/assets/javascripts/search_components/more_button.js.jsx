/** @jsx React.DOM */

var MoreButton = React.createClass({
  button: function(){
    return <button type="button" className="btn btn-default btn-block" onClick={this.props.handler}>Get more</button>;
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
