var searchApp = function() {
  console.log('begin searchApp');
  var mountNode = document.getElementById("react-area");
  console.log(mountNode);
  if (mountNode) React.renderComponent(SearchApp({}), mountNode);
  console.log('end searchApp');
};

$(function() {
  searchApp();
});
