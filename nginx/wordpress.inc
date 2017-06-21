# Wordpress redirect to index:
# same as basic tipical .htaccess config
location / {
  # This is cool because no php is touched for static content.
  # include the "?$args" part so non-default permalinks doesn't break when using query string
  # Firstly attempts to serve request as file, then as directory, then fall back to index.
  try_files $uri $uri/ /index.php?$args;
}


# Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
location ~ /\. {
	deny all;
}


# Deny access to any files with a .php extension in the uploads directory
# Works in sub-directory installs and also in multisite network
location ~* /(?:uploads|files)/.*\.php$ {
	deny all;
}


# Disable access to some files:
location ~* /(license.txt|readme.html|wp-config.php|wp-config-sample.php|wp-comments-post.php) {
  deny all;
}


# Some other files that should not be accessed:
location ~* wp-admin/includes {
  deny all;
}
location ~* wp-includes/theme-compat/ {
  deny all;
}
location ~* wp-includes/js/tinymce/langs/.*.php {
  deny all;
}
location /wp-includes/ {
  internal;
}


# Block any attempted XML-RPC requests:
location = /xmlrpc.php {
  deny all;
}
