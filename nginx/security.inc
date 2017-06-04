#############
# BLOCK SPAM:
#############
if ($query_string ~* (ultram|unicauca|valium|viagra|vicodin|xanax|ypxaieo|erections|hoodia|huronriveracres|impotence|levitra|libido|ambien|blue\spill|cialis|cocaine|ejaculation|erectile|lipitor|phentermin|pro[sz]ac|sandyauer|tramadol|troyhamby)) {
	return 403;
}


####################
# BLOCK USER AGENTS:
####################
if ($http_user_agent ~* (curl|wget|WordPress|Python|PycURL|Pyth|perl|libwww-perl|GetRight|GetWeb!|Go!Zilla|Go-Ahead-Got-It|TurnitinBot|GrabNet|Baiduspider|MetaURI|Widow|BlackWidow|netcrawl|npbot|malicious|Antivirx|Arian|WebWhacker|AhrefsBot)) {
	return 403;
}


#########################
# BLOCK CERTAIN REFERERS:
#########################
if ($http_referer ~* (babes|forsale|girl|jewelry|love|nude|nudit|organic|poker|porn|sex|teen|viagra)) {
	return 403;
}


########################
# BLOCK COMMON EXPLOITS:
########################
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


#######################
# BLOCK SQL INJECTIONS:
#######################
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


########################
# BLOCK FILE INJECTIONS:
########################
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
