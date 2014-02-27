/** @jsx React.DOM */

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
    this.setState({items: [], total_count: 0}, function(){
      this.getDocuments(function(data){
        self.setState({items: data.html_documents, total_count: data.meta.total_count});
      });
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
