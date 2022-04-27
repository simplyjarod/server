# Disable some useless error messages:
location ~ ^/(favicon.ico|robots.txt|sitemap.xml) {
	access_log off;
	log_not_found off;
}

location = /apple-touch-icon.png { access_log off; log_not_found off; }
location = /apple-touch-icon-precomposed.png { access_log off; log_not_found off; }
location = /apple-touch-icon-120x120.png { access_log off; log_not_found off; }
location = /apple-touch-icon-120x120-precomposed.png { access_log off; log_not_found off; }
location = /apple-touch-icon-152x152.png { access_log off; log_not_found off; }
location = /apple-touch-icon-152x152-precomposed.png { access_log off; log_not_found off; }
