
// pre-compile Handlebars templates
var character_template = Handlebars.compile($("#character_template").html());
var pagination_template = Handlebars.compile($("#pagination_template").html());


// if url passed use only that and ignore search_term
getData = function(search_term, url) {
	
	url = url || '/characters.json?term=' + search_term;
	
	// Get the initial json data to display
	$.get(url, function(data) {

			entryIndex = 0;
	    entries = data['characters'];
      
	    var entriesList = $("ul#chars");
	    entriesList.html('');

	    for (var i in entries) {
	      entry = entries[i];
	      var newItem = character_template(entry);
	      entriesList.append(newItem);
	    }
   
			// Pagination
			//"pagination":{"next_page":"","previous_page":"","current_page":"http://localhost:4567/characters.json?page=1&term=thaio","offset":0,"total_entries":0,"total_pages":1}
			pagination = data['pagination'];
			pagination.has_previous_page = pagination.previous_page.length > 0;
			pagination.has_next_page = pagination.next_page.length > 0;
			pagination_markup = pagination_template(pagination)
			$("#pagination").html(pagination_markup);
			
			
		});
}

$(function() {
	
	getData('');
	
	// wire up the form so not submit but use ajax
	$("#search").submit(function(a,b) {
		getData($("#term").val());
		return false
	});
	
	// live search	
	$("#term").bind('keyup', function() {
		getData($("#term").val());
	})
	
	$("#next_page, #previous_page").live('click', function(e) {
		getData('', this.href);
		e.preventDefault();
	});
	
});

$(function(){
	$('body').addClass('js');
	// Lightbox
	$('.lightboxContainer').hide();
	$('.activateLightbox').live('click', function (e) {
        $('.lightboxContainer').fadeIn(400);
        e.preventDefault();
    });    
	$('.lightboxClose').live('click', function (e) {
        $('.lightboxContainer').fadeOut(400);
        e.preventDefault();
    });
});