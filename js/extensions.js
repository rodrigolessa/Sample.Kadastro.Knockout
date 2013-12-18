function doAjx(action, data, refresh) {
	jQuery.ajax({
		url: action,
		type: "post",
		data: ko.toJSON(data),
		contentType: "application/json",
		success: function (result) { refresh(result) }
	});
}