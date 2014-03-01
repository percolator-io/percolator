/** @jsx React.DOM */

var SearchForm = React.createClass({
  scopeName: function(scope){
    var category_res = /category_(\d+)/.exec(scope);
    if (category_res) {
      var category = _.find(window.categories, function(i){
        return i.id == category_res[1];
      });
      return category.name;
    }
    if (scope == 'all') { return 'All' }
//    if (id == 'favorites') { return 'Favorites' }
    return 'No name'
  },

  categories: function() {
    return window.categories.map(function(category){
      return <li><a href={'#category_' + category.id}>{category.name}</a></li>
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
                {this.scopeName(this.props.scope)} <span className="caret"/>
              </button>
              <ul className="dropdown-menu pull-right">
                <li><a href={'#all'}>{this.scopeName('all')}</a></li>
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
