/** @jsx React.DOM */

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
        <a href={'#category_' + category.id}>
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
