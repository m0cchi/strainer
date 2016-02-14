$(function() {
    var contentController = {
        __name: 'sample.contentController',
        '#top click': function(context, $el) {
            $.ajax({
                type: 'POST',
                url: '/api/hello',
                dataType: 'html',
                success: function(data) {
                    alert('api response->' + data);
                },
                error: function() {
                    alert('error!!!');
                }
            });
        }
    };
    
    h5.core.controller('#content', contentController );
});
