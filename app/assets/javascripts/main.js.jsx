/** @jsx React.DOM */

var SearchForm = React.createClass({
  render: function() {
    return (
      <form onSubmit={this.props.handleSubmit}>
        <div className='form-group'>
          <input onChange={this.props.onChange} className='form-control' value={this.props.query} />
        </div>
        <button className='btn btn-default'>Search</button>
      </form>
    );
  }
});

var ItemList = React.createClass({
  createItem: function(item) {
    return Item(item);
  },

  render: function(){
    return (
      <ul className='media-list'>{this.props.items.map(this.createItem)}</ul>
    );
  }
});

var Item = React.createClass({
  createCategory: function(category) {
    return (
      <li>
        <a href={'#' + category.name}>
          {category.name}
        </a>
      </li>
    );
  },

  createStar: function(star) {
    return (
      <li>
        {star.user.name}
      </li>
      );
  },

  render: function() {
    return (
      <li className='media'>
        <div className="media-body">
          <h4 className="media-heading">
            <a href={this.props.url}>{this.props.title}</a>
          </h4>
          <p>{this.props.description}</p>
          <ul className='list-inline'>{this.props.categories.map(this.createCategory)}</ul>
          <ul className='list-inline'>{this.props.stars.map(this.createStar)}</ul>
        </div>
      </li>
    );
  }
});

var SearchApp = React.createClass({
  getQuery: function() {
    return window.location.hash.replace('#', '');
  },

  getInitialState: function() {
    return { items: [], query: this.getQuery() };
  },

  componentDidMount: function() {
    this.fetchResults();
    window.addEventListener('hashchange', this.handleHashChange);
  },

  componentWillUnmount: function() {
    window.removeEventListener('hashchange', this.handleHashChange);
  },

  handleHashChange: function() {
    this.setState({query: this.getQuery()});
    this.fetchResults();
  },

  handleSubmit: function(e) {
    e.preventDefault();
    this.fetchResults();
  },

  handleQueryChange: function(e) {
    this.setState({query: e.target.value});
  },

  fetchResults: function(){
    var self = this;
    $.get('/web_api/search_results.json?q=' + this.state.query, function(data){
      self.setState({items: data});
    });
  },

  render: function(){
    var createItem = function(item) {
      return <li>{item.id}</li>;
    };

    return (
      <div>
        <SearchForm query={this.state.query} handleSubmit={this.handleSubmit} onChange={this.handleQueryChange}/>
        <ItemList items={this.state.items} />
      </div>
    );
  }
});

window.onload = function() {
  var mountNode = document.getElementById("react-area");
  React.renderComponent(SearchApp({}), mountNode);
};
