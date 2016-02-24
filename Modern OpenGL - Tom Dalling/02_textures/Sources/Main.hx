package;

import kha.System;

class Main
{
	public static function main() 
	{
		System.init('App', 800, 600, init);
	}

	static function init() 
	{
		var app = new App();		
	}
}
