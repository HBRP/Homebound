Config = {}

Config.Locale = 'en'

Config.serverLogo = 'https://i.imgur.com/AcgDL9f.png'

Config.font = {
	name 	= 'Montserrat',
	url 	= 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700,900&display=swap'
}

Config.date = {
	format	 	= 'default',
	AmPm		= false
}

Config.voice = {

	levels = {
		default = 5.0,
		shout = 12.0,
		whisper = 1.0,
		current = 0
	},
	
	keys = {
		distance 	= '~',
	}
}


Config.vehicle = {
	speedUnit = 'MPH',
	maxSpeed = 240,

	keys = {
		seatbelt 	= 'B',
		cruiser		= 'CAPITAL',
		signalLeft	= 'LEFT',
		signalRight	= 'RIGHT',
		signalBoth	= 'DOWN',
	}
}

Config.ui = {
	showServerLogo		= false,

	showJob		 		= false,

	showWalletMoney 	= false,
	showBankMoney 		= false,
	showBlackMoney 		= false,
	showSocietyMoney	= false,

	showDate 			= false,
	showLocation 		= true,
	showVoice	 		= false,

	showHealth			= false,
	showArmor	 		= false,
	showStamina	 		= false,
	showHunger 			= false,
	showThirst	 		= false,

	showMinimap			= false,

	showWeapons			= false,	
}