// modules/database.pwn

/*	Don't use 'information_schema.tables' !!
										~by Wax	*/
										
stock ChechIfTableExists() 
{
	mysql_query("SHOW TABLES LIKE '"prefix"groups'");
	mysql_store_result();
	
	if(mysql_num_rows() <= 0)
	{
		mysql_query("CREATE TABLE IF NOT EXISTS `scl_groups` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(32) NOT NULL, `tag` varchar(10) NOT NULL, `color` varchar(10) NOT NULL, `type` int(11) NOT NULL, `chat` tinyint(1) NOT NULL, PRIMARY KEY (`id`), KEY `id` (`id`), KEY `id_2` (`id`)) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;");
		mysql_store_result();
		mysql_free_result();
		
		print("@: Created not existing tables:: "prefix"groups");
	}
	
	mysql_query("SHOW TABLES LIKE '"prefix"doors'");
	mysql_store_result();
	
	if(mysql_num_rows() <= 0)
	{
		new sql[1024];
		format(sql, 1024, "CREATE TABLE IF NOT EXISTS `scl_doors` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(32) NOT NULL, `text` varchar(64) NOT NULL, `color` varchar(10) NOT NULL, `type` int(11) NOT NULL,");
		strcat(sql, "`enterVw` int(11) NOT NULL, `enterInt` int(11) NOT NULL, `enterX` float NOT NULL, `enterY`");
		strcat(sql, "float NOT NULL, `enterZ` float NOT NULL, `exitVw` int(11) NOT NULL, `exitInt` int(11) NOT NULL, `exitX` float NOT NULL, `exitY` float NOT NULL, `exitZ` float NOT NULL, ");
		strcat(sql, "`lock` int(11) NOT NULL, `fee` int(11) NOT NULL, `owner` int(11) NOT NULL, `ownertype` int(11) NOT NULL, `pickuphide` int(11) NOT NULL, `parent` int(11) NOT NULL, PRIMARY KEY (`id`), KEY `id` (`id`), KEY `id_2` (`id`)) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;");
 		mysql_query(sql);
 		mysql_store_result();
 		mysql_free_result();
		
		print("@: Created not existing tables:: "prefix"doors");
	}	
	
	mysql_query("SHOW TABLES LIKE '"prefix"groups_members2'");
	mysql_store_result();
	
	if(mysql_num_rows() <= 0)
	{
		mysql_query("CREATE TABLE IF NOT EXISTS `scl_groups_members2` (`member` int(11) NOT NULL, `group` int(11) NOT NULL, `rank` int(11) NOT NULL ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
		mysql_store_result();
		mysql_free_result();
		
		print("@: Created not existing tables:: "prefix"groups_members2");
	}
	
	mysql_query("SHOW TABLES LIKE '"prefix"settings'");
	mysql_store_result();
	
	if(mysql_num_rows() <= 0)
	{
		mysql_query("CREATE TABLE IF NOT EXISTS `scl_settings` (`spawnx` float NOT NULL, `spawny` float NOT NULL, `spawnz` float NOT NULL, `spawna` float NOT NULL, `spawnvw` int(11) NOT NULL, `spawnint` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
		mysql_store_result();
		mysql_free_result();
		
		print("@: Created not existing tables:: "prefix"settings");
	}	
	
	mysql_query("SHOW TABLES LIKE '"prefix"user_data'");
	mysql_store_result();
	
	if(mysql_num_rows() <= 0)
	{
		mysql_query("CREATE TABLE IF NOT EXISTS `scl_user_data` (`id` int(11) NOT NULL AUTO_INCREMENT, `guid` int(11) NOT NULL, `nick` varchar(24) NOT NULL, `admin` int(11) NOT NULL, `cash` int(11) NOT NULL, `skin` int(11) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;");
		mysql_store_result();
		mysql_free_result();
		
		print("@: Created not existing tables:: "prefix"user_data");
	}
}