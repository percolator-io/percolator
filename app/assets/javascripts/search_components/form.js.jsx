/** @jsx React.DOM */

var SearchForm = React.createClass({
  scopeName: function(id){
    var category_res = /category_(\d+)/.exec(id);
    if (category_res) {
      var category = _.find(window.categories, function(i){
        return i.id == category_res[1];
      });
      return category.name;
    }
    if (id == 'all') { return 'All' }
    if (id == 'favorites') { return 'Favorites' }
    return 'No name'
  },

  categoryOnClick: function(id){
    this.props.onScopeSelect('category_' + id);
  },

  allOnClick: function(){
    this.props.onScopeSelect('all');
  },

  favoritesOnClick: function(){
    this.props.onScopeSelect('favorites');
  },

  categories: function() {
    return window.categories.map(function(category){
      return <li><a onClick={this.categoryOnClick.bind(this, category.id)}>{category.name}</a></li>
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
                {this.scopeName(this.props.scopeId)} <span className="caret"/>
              </button>
              <ul className="dropdown-menu pull-right">
                <li><a onClick={this.allOnClick}>{this.scopeName('all')}</a></li>
                <li><a onClick={this.favoritesOnClick}>{this.scopeName('favorites')}</a></li>
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
