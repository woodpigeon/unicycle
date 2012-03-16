
getData = function(search_term) {
	
	// Get the initial json data to display
	$.get('/characters.json?term=' + search_term, function(data) {

			entryIndex = 0;
	    entries = data['characters'];
  
	    // compile Handlebars template
	    var source = $("#chars_template").html();
	    var template = Handlebars.compile(source);
	    var entriesList = $("ul#chars");
	    entriesList.html('');

	    for (var i in entries) {
	      entry = entries[i];
	      var newItem = template(entry);
				console.log(entry);
	      entriesList.append(newItem);
	    }
   
		});
}

$(function() {
	
	getData('');
	
	// wire up the form so not submit but use ajax
	$("#search").submit(function(a,b) {
	
		getData($("#term").val());
		return false
	});
		
	$("#term").bind('keyup', function() {
		
		getData($("#term").val());
	})
});

$(function(){
	// Lightbox
	// Hide lightbox
	$('.lightboxContainer').hide();
	// Open lightbox
	$('.activateLightbox').live('click', function (e) {
        $('.lightboxContainer').fadeIn( 400 );
        e.preventDefault();
    });
    // Close lightbox
	$('.closeLightbox, .lightboxContainer').live('click', function (e) {
        $('.lightboxContainer').fadeOut( 400 );
        e.preventDefault();
    });
});