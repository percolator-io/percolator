/** @jsx React.DOM */

var SearchForm = React.createClass({
  render: function() {
    return (
      <div className='search-form'>
        <form onSubmit={this.props.handleSubmit}>
          <div className='form-group'>
            <input onChange={this.props.onChange} className='form-control' value={this.props.query} />
          </div>
          <input type='submit' value='Search' className='btn btn-default'/>
        </form>
      </div>
     );
  }
});
