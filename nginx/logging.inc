# Disable some useless error messages:
location ~* (favicon.ico|robots.txt|sitemap.xml)$ {
	access_log off;
	log_not_found off;
	try_files $uri =404;
	return 204; # No Content
}

# apple-touch-icon, apple-touch-icon-precomposed, apple-touch-icon-120x120, apple-touch-icon-152x152...
location ~* apple-touch-ico*.png$ { 
	access_log off;
	log_not_found off;
	try_files $uri =404;
	return 204; # No Content
}
