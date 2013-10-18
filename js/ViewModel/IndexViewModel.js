// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function IndexViewModel() 
{
	var self = this;
    self.tituloModal = ko.observable("Janela Model");
}

// Activates knockout.js
ko.applyBindings(new IndexViewModel());