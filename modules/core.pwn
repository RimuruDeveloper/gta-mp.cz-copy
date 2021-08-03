stock core_MySQLConnect()
{
	new MySQLOpt:option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	handle = mysql_connect("localhost", "root", "", "gmcz", option_id);
	if(mysql_errno() != 0) SendRconCommand("exit");
}

stock core_MySQLDisconnect()
{
	mysql_close(handle);
}
