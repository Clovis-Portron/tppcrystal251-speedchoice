	db SUNFLORA ; 192

	db  75,  75,  55,  30, 105,  85
	;   hp  atk  def  spd  sat  sdf

	db GRASS, GRASS
	db 120 ; catch rate
	db 149 ; base exp
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	db 127 ; gender
	db 100 ; unknown
	db 20 ; step cycles to hatch
	db 5 ; unknown
	dn 6, 6 ; frontpic dimensions
	db 0, 0, 0, 0 ; padding
	db MEDIUM_SLOW ; growth rate
	dn PLANT, PLANT ; egg groups

	; tmhm
	tmhm CURSE, TOXIC, HIDDEN_POWER, EARTH_POWER, SUNNY_DAY, EARTH_POWER, HYPER_BEAM, PROTECT, GIGA_DRAIN, SOLARBEAM, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SLUDGE_BOMB, SWORDS_DANCE, REST, ATTRACT, SUBSTITUTE, CUT, FLASH,
	; end
