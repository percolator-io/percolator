$(function(){
 $('#category_selections').on('cocoon:after-insert', function() {
    initSelectpicker();
  });
});
