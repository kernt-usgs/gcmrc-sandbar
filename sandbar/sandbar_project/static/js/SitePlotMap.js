SB.SitePlotMap = function(siteLat,siteLng) {

	var map = L.map('site-loc-map-div', {
		center: latlng,
		zoom: 18,
		attributionControl: false
	});

	L.esri.dynamicMapLayer("http://arcweb.wr.usgs.gov/ArcGIS/rest/services/MapServiceImageryMay2009RGB/MapServer", {
		 opacity: 1
	 }).addTo(map);

	if (siteLat != "" && siteLng != "") {
		var latlng = L.latLng(parseFloat(siteLng), parseFloat(siteLat));
		var marker = L.marker(latlng).addTo(map);
		map.setView(latlng, 7);
	}

	//var baseLayer = L.tileLayer('https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{xda}.png').addTo(map);
	return map;
};