/** @jsx React.DOM */

var SearchForm = React.createClass({
  categories: function() {
    return window.categories.map(function(category){
      return <li><a>{category[0]}</a></li>
    }, this);
  },

  render: function() {
    return (
      <div className='search-form'>
        <form onSubmit={this.props.handleSubmit}>

          <div className="input-group form-group">
            <input className="text" className="form-control" onChange={this.props.onChange} value={this.props.query}/>
            <div className="input-group-btn">
              <button type="button" className="btn btn-default dropdown-toggle" data-toggle="dropdown">
                {this.props.scopeName} <span className="caret"/>
              </button>
              <ul className="dropdown-menu pull-right">
                <li><a href="#">All</a></li>
                <li><a href="#">Favorites</a></li>
                <li className="divider"></li>
                {this.categories()}
              </ul>
            </div>
           </div>

          <div className='form-group'>
            <input type='submit' value='Search' className='btn btn-default'/>
          </div>

        </form>
      </div>
     );
  }
});
