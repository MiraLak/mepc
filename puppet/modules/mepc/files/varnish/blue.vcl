backend be_front {
	.host = "10.0.3.31";
	.port = "80";
}

backend be_app {
	.host = "10.0.3.32";
	.port = "8081";
}

sub vcl_recv {
	if (req.http.host ~ "app") {
		set req.backend = be_app;
	}
	if (req.http.host ~ "front") {
		set req.backend = be_front;
	}
	return(pass);
}
