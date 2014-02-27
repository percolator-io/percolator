/** @jsx React.DOM */

var SearchForm = React.createClass({
  render: function() {
    return (
      <div className='search-form'>
        <form onSubmit={this.props.handleSubmit}>
          <div className='form-group'>
            <input onChange={this.props.onChange} className='form-control' value={this.props.query} />
          </div>
          <button className='btn btn-default'>Search</button>
        </form>
      </div>
     );
  }
});
