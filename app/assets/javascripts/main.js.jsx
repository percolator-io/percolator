/** @jsx React.DOM */

var SearchForm = React.createClass({
  render: function() {
    return (
      <form onSubmit={this.props.handleSubmit}>
        <div className='form-group'>
          <input onChange={this.props.onChange} className='form-control' />
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
  createTag: function(tag) {
    return (
      <li>{tag.name}</li>
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
          <ul className='list-inline'>{this.props.tags.map(this.createTag)}</ul>
        </div>
      </li>
    );
  }
});

var SearchApp = React.createClass({
  getInitialState: function() {
    return { items: [], query: '' };
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
        <SearchForm handleSubmit={this.handleSubmit} onChange={this.handleQueryChange}/>
        <ItemList items={this.state.items} />
      </div>
    );
  }
});

window.onload = function() {
  var mountNode = document.getElementById("react-area");
  React.renderComponent(SearchApp({}), mountNode);
};
