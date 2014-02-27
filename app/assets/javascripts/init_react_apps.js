var searchApp = function() {
  var mountNode = document.getElementById("react-area");
  if (mountNode) React.renderComponent(SearchApp({}), mountNode);
};

window.onload = function() {
  searchApp();
};
