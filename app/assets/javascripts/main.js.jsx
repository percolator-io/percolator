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

var ItemList = React.createClass({
  createItem: function(item) {
    return Item(item);
  },

  render: function(){
    return (
      <ul className='media-list search-result'>{this.props.items.map(this.createItem)}</ul>
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
          <div>{this.props.description}</div>
          <ul className='list-inline'>{this.props.categories.map(this.createCategory)}</ul>
        </div>
      </li>
    );
  }
});

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

var SearchApp = React.createClass({
  getQuery: function() {
    return window.location.hash.replace('#', '');
  },

  getInitialState: function() {
    return { items: [], total_count: 0, query: this.getQuery() };
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
    this.getDocuments(function(data){
      self.setState({items: data.html_documents, total_count: data.meta.total_count});
    });
  },

  loadMore: function(){
    if (this.isAllFetched()) {
      return;
    }

    var self = this;
    this.getDocuments(function(data){
      var items = self.state.items.concat(data.html_documents);
      self.setState({items: items});
    });
  },

  getDocuments: function(callback){
    var url = Routes.web_api_html_documents_path({q: this.state.query, offset: this.state.items.length});
    $.get(url, callback);
  },

  isAllFetched: function(){
    return this.state.items.length == this.state.total_count
  },

  render: function(){
    var createItem = function(item) {
      return <li>{item.id}</li>;
    };

    return (
      <div>
        <SearchForm query={this.state.query} handleSubmit={this.handleSubmit} onChange={this.handleQueryChange}/>
        <ItemList items={this.state.items} />
        <MoreButton handler={this.loadMore} active={! this.isAllFetched()}/>
      </div>
    );
  }
});

window.onload = function() {
  var mountNode = document.getElementById("react-area");
  React.renderComponent(SearchApp({}), mountNode);
};
