# dot dirs:
location ~* ^/\.(aws|env|git) {
	deny           all;
	access_log     off;
	log_not_found  off;
	error_log      /dev/null;
}

# dot files:
location ~* \.(htaccess|htpasswd|ini|log|sh)$ {
	deny           all;
	access_log     off;
	log_not_found  off;
	error_log      /dev/null;
}

# extensions:
location ~* (.asp|.aspx|.cgi|.cs|.esp|.jsp|.rsp)$ {
	deny           all;
	access_log     off;
	log_not_found  off;
	error_log      /dev/null;
}


# Only allow these request methods:
if ($request_method !~ ^(GET|HEAD|POST)$ ) {
	return 444;
}

# BLOCK SPAM:
if ($query_string ~* (ambien|blue\spill|cialis|cocaine|ejaculation|erectile|erections|hoodia|huronriveracres|impotence|levitra|libido|lipitor|phentermin|pro[sz]ac|sandyauer|tramadol|troyhamby|ultram|unicauca|valium|viagra|vicodin|xanax|ypxaieo)) {
	return 403;
}


# BLOCK USER AGENTS:
if ($http_user_agent ~* (AhrefsBot|Antivirx|Arian|Baiduspider|The\sBeast|BackDoorBot|BackWeb|BlackWidow|BUbiNG|ChinaClaw|curl|EmailWolf|GetRight|GetWeb!|Go!Zilla|Go-Ahead-Got-It|GrabNet|hacker|libwww-perl|malicious|MetaURI|netcrawl|NetSpider|NetZIP|Netcraft|NextGenSearchBot|NimbleCrawler|Ninja|npbot|paloaltonetworks.com|pdrlabs.net|perl|Octopus|Pyth|Python|PycURL|TurnitinBot|WebBandit|WebCopier|wget|Widow|WordPress)) {
	return 403;
}


# BLOCK CERTAIN REFERERS:
if ($http_referer ~* (babes|forsale|girl|jewelry|love|nude|nudit|organic|poker|porn|sex|teen|viagra)) {
	return 403;
}


# BLOCK COMMON EXPLOITS:
set $block_common_exploits 0;
if ($query_string ~ "(<|%3C).*script.*(>|%3E)") {
	set $block_common_exploits 1;
}
if ($query_string ~ "GLOBALS(=|\[|\%[0-9A-Z]{0,2})") {
	set $block_common_exploits 1;
}
if ($query_string ~ "_REQUEST(=|\[|\%[0-9A-Z]{0,2})") {
	set $block_common_exploits 1;
}
if ($query_string ~ "proc/self/environ") {
	set $block_common_exploits 1;
}
if ($query_string ~ "mosConfig_[a-zA-Z_]{1,21}(=|\%3D)") {
	set $block_common_exploits 1;
}
if ($query_string ~ "base64_(en|de)code\(.*\)") {
	set $block_common_exploits 1;
}
if ($block_common_exploits = 1) {
	return 403;
}


# BLOCK SQL INJECTIONS:
set $block_sql_injections 0;
if ($query_string ~ "union.*select.*\(") {
	set $block_sql_injections 1;
}
if ($query_string ~ "union.*all.*select.*") {
	set $block_sql_injections 1;
}
if ($query_string ~ "concat.*\(") {
	set $block_sql_injections 1;
}
if ($block_sql_injections = 1) {
	return 403;
}


# BLOCK FILE INJECTIONS:
set $block_file_injections 0;
#if ($query_string ~ "[a-zA-Z0-9_]=http://") {
#	set $block_file_injections 1;
#}
if ($query_string ~ "[a-zA-Z0-9_]=(\.\.//?)+") {
	set $block_file_injections 1;
}
if ($query_string ~ "[a-zA-Z0-9_]=/([a-z0-9_.]//?)+") {
	set $block_file_injections 1;
}
if ($block_file_injections = 1) {
	return 403;
}
