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
            <a href={Routes.web_api_html_document_path(this.props.id)} data-toggle="modal" data-target={'#' + this.props.id}>
              {this.props.title}
            </a>
          </h4>
          <div>{this.props.description}</div>

          <ul className='list-inline'>{this.props.categories.map(this.createCategory)}</ul>

          <div className="modal fade" id={this.props.id} tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div className="modal-dialog modal-lg">
              <div className="modal-content">

              </div>
            </div>
          </div>
        </div>
      </li>
    );
  }
});
