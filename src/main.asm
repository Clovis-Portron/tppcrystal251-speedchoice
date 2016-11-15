INCLUDE "includes.asm"

SECTION "bank1", ROMX, BANK[$1]

Function4000:: ; 4000
	hlcoord 3, 10
	ld b, 1
	ld c, 11
	ld a, [wBattleMode]
	and a
	jr z, .asm_4012
	call TextBox
	jr .asm_4017

.asm_4012
	predef Function28eef
.asm_4017
	hlcoord 4, 11
	ld de, .Waiting
	call PlaceString
	ld c, 50
	jp DelayFrames
; 4025

.Waiting ; 4025
	db "Waiting...!@"
; 4031

LoadPushOAM:: ; 4031
	ld c, hPushOAM - $ff00
	ld b, PushOAMEnd - PushOAM
	ld hl, PushOAM
.loop
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop
	ret
; 403f

PushOAM: ; 403f
	ld a, Sprites / $100
	ld [rDMA], a
	ld a, $28
.loop
	dec a
	jr nz, .loop
	ret

PushOAMEnd
; 4049

INCLUDE "engine/map_objects.asm"

Function5ae8: ; 5ae8
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_MAIN_MENU
	ld a, e
	ld [wMapMusic], a
	call PlayMusic
	callba MainMenu
	jp Function6219
; 5b04

Function5b04: ; 5b04
	ret
; 5b05

Function5b05: ; 5b05
	push de
	ld hl, .Days
	ld a, b
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld de, .Day
	call PlaceString
	ret
; 5b1c

.Days ; 5b1c
	db "SUN@"
	db "MON@"
	db "TUES@"
	db "WEDNES@"
	db "THURS@"
	db "FRI@"
	db "SATUR@"
; 5b40

.Day ; 5b40
	db "DAY@"
; 5b44

Function5b44: ; 5b44
	xor a
	ld [$ffde], a
	call ClearTileMap
	call Functione5f
	call Functione51
	call Function1fbf
	ret
; 5b54

MysteryGift: ; 5b54
	call UpdateTime
	callba Function11548
	callba Function1048ba
	ret
; 5b64

OptionsMenu: ; 5b64
	callba _OptionsMenu
	ret
; 5b6b

NewGame: ; 5b6b
	xor a
	ld [wc2cc], a
	call Function5ba7
	call Function5b44
	; call Function5b8f
	call OakSpeech
	call Function5d23
	ld a, $1
	ld [wc2d8], a
	ld a, 0 ; SPAWN_HOME
	ld [wd001], a
	ld a, $f1
	ld [$ff9f], a
	ld hl, PCItems
	ld a, 1
	ld [hli], a
	ld a, POTION
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, -1
	ld [hl], a
	jp Function5e5d
; 5b8f

; Function5b8f: ; 5b8f
	; callba Function10632f
	; jr c, .asm_5b9e
	; callba SetPlayerGender
	; ret

; .asm_5b9e
	; ld c, $0
	; callba Function4802f
	; ret
; ; 5ba7

Function5ba7: ; 5ba7
	xor a
	ld [hBGMapMode], a
	call Function5bae
	ret
; 5bae

Function5bae: ; 5bae
	ld hl, Sprites
	ld bc, Options - Sprites
	xor a
	call ByteFill
	ld hl, wd000
	ld bc, PlayerID - wd000
	xor a
	call ByteFill
	ld hl, PlayerID
	ld bc, wdff5 - PlayerID
	xor a
	call ByteFill
	ld a, [rLY]
	ld [$ffe3], a
	call DelayFrame
	ld a, [hRandomSub]
	ld [PlayerID], a
	ld a, [rLY]
	ld [$ffe3], a
	call DelayFrame
	ld a, [hRandomAdd]
	ld [PlayerID + 1], a
	call Random
	ld [wd84a], a
	call DelayFrame
	call Random
	ld [wd84b], a
	ld hl, PartyCount
	call Function5ca1
	xor a
	ld [wCurBox], a
	ld [wd4b4], a
	call Function5ca6
	ld a, 1
	call GetSRAMBank
	ld hl, sBoxCount
	call Function5ca1
	call CloseSRAM

	ld hl, NumItems
	call Function5ca1
	ld hl, NumKeyItems
	call Function5ca1
	ld hl, NumBalls
	call Function5ca1
	ld hl, PCItems
	call Function5ca1
	xor a
	ld [wRoamMon1Species], a
	ld [wRoamMon2Species], a
	ld [wRoamMon3Species], a
	ld a, -1
	ld [wRoamMon1MapGroup], a
	ld [wRoamMon2MapGroup], a
	ld [wRoamMon3MapGroup], a
	ld [wRoamMon1MapNumber], a
	ld [wRoamMon2MapNumber], a
	ld [wRoamMon3MapNumber], a
	ld a, 0
	call GetSRAMBank
	ld hl, $abe2
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	call CloseSRAM
	call Function5d33
	call Function5cd3
	xor a
	ld [MonType], a
	ld [JohtoBadges], a
	ld [KantoBadges], a
	ld [Coins], a
	ld [Coins + 1], a
START_MONEY EQU 3000
IF START_MONEY / $10000
	ld a, START_MONEY / $10000
ENDC
	ld [Money], a
	ld a, START_MONEY / $100 % $100
	ld [Money + 1], a
	ld a, START_MONEY % $100
	ld [Money + 2], a
	xor a
	ld [wdc17], a
	ld hl, wdc19
	ld [hl], 2300 / $10000
	inc hl
	ld [hl], 2300 / $100 % $100
	inc hl
	ld [hl], 2300 % $100
	ld a, 1
	ld [wd959], a
	call Function5ce9
	callba Function26751
	callba Function44765
	callba Function1061c0
	call ResetGameTime
	ret
; 5ca1

Function5ca1: ; 5ca1
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret
; 5ca6

Function5ca6: ; 5ca6
	ld hl, wBoxNames
	ld c, 0
.asm_5cab
	push hl
	ld de, .Box
	call CopyName2
	dec hl
	ld a, c
	inc a
	cp 10
	jr c, .asm_5cbe
	sub 10
	ld [hl], "1"
	inc hl
.asm_5cbe
	add "0"
	ld [hli], a
	ld [hl], "@"
	pop hl
	ld de, 9
	add hl, de
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .asm_5cab
	ret

.Box
	db "BOX@"
; 5cd3

Function5cd3: ; 5cd3
	ld hl, wdfe8
	ld a, 1000 / $100
	ld [hli], a
	ld a, 1000 % $100
	ld [hli], a
	ld de, .Ralph
	call CopyName2
	ret
; 5ce3

.Ralph ; 5ce3
	db "RALPH@"
; 5ce9

Function5ce9: ; 5ce9
	ld hl, .Rival
	ld de, RivalName
	call .Copy
	ld hl, .Mom
	ld de, MomsName
	call .Copy
	ld hl, .Red
	ld de, RedsName
	call .Copy
	ld hl, .Green
	ld de, GreensName
.Copy
	ld bc, NAME_LENGTH
	call CopyBytes
	ret

.Rival  db "???@"
.Red    db "AIIIAAB@"
.Green  db "GREEN@"
.Mom    db "MOM@"
; 5d23

Function5d23: ; 5d23
	call Function610f
	callba Function8029
	callba Function113d6
	ret
; 5d33

Function5d33: ; 5d33
	ld a, $0
	call GetSRAMBank
	ld a, [CurDay]
	inc a
	ld b, a
	ld a, [$ac68]
	cp b
	ld a, [$ac6a]
	ld c, a
	ld a, [$ac69]
	jr z, .asm_5d55
	ld a, b
	ld [$ac68], a
	call Random
	ld c, a
	call Random
.asm_5d55
	ld [wdc9f], a
	ld [$ac69], a
	ld a, c
	ld [wdca0], a
	ld [$ac6a], a
	jp CloseSRAM
; 5d65

Continue: ; 5d65
	callba Function14ea5
	jr c, .asm_5dd6
	callba Function150b9
	call Function1d6e
	call Function5e85
	ld a, $1
	ld [hBGMapMode], a
	ld c, $14
	call DelayFrames
	call Function5e34
	jr nc, .asm_5d8c
	call Function1c17
	jr .asm_5dd6

.asm_5d8c
	call Function5e48
	jr nc, .asm_5d96
	call Function1c17
	jr .asm_5dd6

.asm_5d96
	ld a, $8
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	call WhiteBGMap
	call Function5df0
	call Function1c17
	call ClearTileMap
	ld c, $14
	call DelayFrames
	callba Function2a394
	callba Function105091
	callba Function140ae
	ld a, [wd4b5]
	; cp $1
	; jr z, .asm_5dd7
	; cp $2
	; jr z, .after_red
	and a
	jr nz, .asm_5dd7
	ld a, $f2
	ld [$ff9f], a
	jp Function5e5d

.asm_5dd6
	ret

; .after_red
	; call Function5de2
	; jp Function5e5d

.asm_5dd7
	ld a, $e ; SPAWN_NEW_BARK
	ld [wd001], a
	call Function5de7
	jp Function5e5d
; 5de2

Function5de2: ; 5de2
	ld a, $1a ; SPAWN_MT_SILVER
	ld [wd001], a
Function5de7: ; 5de7
	xor a
	ld [wd4b5], a
	ld a, $f1
	ld [$ff9f], a
	ret
; 5df0

Function5df0: ; 5df0
	callba Function10632f
	ret nc
	ld hl, wd479
	bit 1, [hl]
	ret nz
	ld a, $5
	ld [MusicFade], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU / $100
	ld [MusicFadeIDHi], a
	ld c, 20
	call DelayFrames
	ld c, $1
	callba Function4802f
	callba Function1509a
	ld a, $8
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld c, 35
	call DelayFrames
	ret
; 5e34

Function5e34: ; 5e34
.asm_5e34
	call DelayFrame
	call GetJoypad
	ld hl, hJoyPressed
	bit 0, [hl]
	jr nz, .asm_5e47
	bit 1, [hl]
	jr z, .asm_5e34
	scf
	ret

.asm_5e47
	ret
; 5e48

Function5e48: ; 5e48
	call Function6e3
	and $80
	jr z, .asm_5e5b
	callba Function20021
	ld a, c
	and a
	jr z, .asm_5e5b
	scf
	ret

.asm_5e5b
	xor a
	ret
; 5e5d

Function5e5d: ; 5e5d
.asm_5e5d
	xor a
	ld [wc2c1], a
	ld [wLinkMode], a
	ld hl, GameTimerPause
	set 0, [hl]
	res 7, [hl]
	ld hl, wd83e
	set 1, [hl]
	callba OverworldLoop
	ld a, [wd4b5]
	cp $2
	jr z, .asm_5e80
	jp Reset

.asm_5e80
	call Function5de2
	jr .asm_5e5d
; 5e85

Function5e85: ; 5e85
	call Function6e3
	and $80
	jr z, .asm_5e93
	ld de, $0408
	call Function5eaf
	ret

.asm_5e93
	ld de, $0408
	call Function5e9f
	ret
; 5e9a

Function5e9a: ; 5e9a
	ld de, $0400
	jr Function5e9f
; 5e9f

Function5e9f: ; 5e9f
	call Function5ebf
	call Function5f1c
	call Function5f40
	call Functione5f
	call Function1ad2
	ret
; 5eaf

Function5eaf: ; 5eaf
	call Function5ebf
	call Function5f1c
	call Function5f48
	call Functione5f
	call Function1ad2
	ret
; 5ebf

Function5ebf: ; 5ebf
	xor a
	ld [hBGMapMode], a
	ld hl, MenuDataHeader_0x5ed9
	ld a, [StatusFlags]
	bit 0, a ; pokedex
	jr nz, .asm_5ecf
	ld hl, MenuDataHeader_0x5efb
.asm_5ecf
	call Function1e35
	call Function1cbb
	call Function1c89
	ret
; 5ed9

MenuDataHeader_0x5ed9: ; 5ed9
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x5ee1
	db 1 ; default option
; 5ee1

MenuData2_0x5ee1: ; 5ee1
	db $00 ; flags
	db 4 ; items
	db "PLAYER@"
	db "BADGES@"
	db "#DEX@"
	db "TIME@"
; 5efb

MenuDataHeader_0x5efb: ; 5efb
	db $40 ; flags
	db 00, 00 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x5f03
	db 1 ; default option
; 5f03

MenuData2_0x5f03: ; 5f03
	db $00 ; flags
	db 4 ; items
	db "PLAYER ", $52, "@"
	db "BADGES@"
	db " @"
	db "TIME@"
; 5f1c

Function5f1c: ; 5f1c
	call Function1cfd ;hl = curmenu start location in tilemap
	push hl
	ld de, $005d
	add hl, de
	call Function5f58
	pop hl
	push hl
	ld de, $0084
	add hl, de
	call Function5f6b
	pop hl
	push hl
	ld de, $0030
	add hl, de
	ld de, .Player
	call PlaceString
	pop hl
	ret

.Player
	db $52, "@"
; 5f40

Function5f40: ; 5f40
	ld de, $00a8
	add hl, de
	call Function5f84
	ret
; 5f48

Function5f48: ; 5f48
	ld de, $00a9
	add hl, de
	ld de, .text_5f53
	call PlaceString
	ret

.text_5f53
	db " ???@"
; 5f58

Function5f58: ; 5f58
	push hl
	ld hl, JohtoBadges
	ld b, $2
	call CountSetBits
	pop hl
	ld de, wd265
	ld bc, $0102
	jp PrintNum
; 5f6b

Function5f6b: ; 5f6b
	ld a, [StatusFlags]
	bit 0, a
	ret z
	push hl
	ld hl, PokedexCaught
	ld b, $20
	call CountSetBits
	pop hl
	ld de, wd265
	ld bc, $0103
	jp PrintNum
; 5f84

Function5f84: ; 5f84
	ld de, GameTimeHours
	ld bc, $0204
	call PrintNum
	ld [hl], $6d
	inc hl
	ld de, GameTimeMinutes
	ld bc, $8102
	jp PrintNum
; 5f99

OakSpeech: ; 0x5f99
	callba SetTimeOfDay
	call Function4dd
	call ClearTileMap
	ld de, MUSIC_ROUTE_24
	call PlayMusic
	call Function4a3
	call Function4b6
	xor a
	ld [CurPartySpecies], a
	ld a, POKEMON_PROF
	ld [TrainerClass], a
	call Function619c
	ld b, $1c
	call GetSGBLayout
	call Function616a
	ld hl, OakText1
	call PrintText
	call Function4b6
	call ClearTileMap
	ld a, NIDORINO
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData
	hlcoord 6, 4
	call Function3786
	xor a
	ld [TempMonDVs], a
	ld [TempMonDVs + 1], a
	ld b, $1c
	call GetSGBLayout
	call Function6182
	ld hl, OakText2
	call PrintText
	ld hl, OakText4
	call PrintText
	call Function4b6
	call ClearTileMap
	xor a
	ld [CurPartySpecies], a
	ld a, POKEMON_PROF
	ld [TrainerClass], a
	call Function619c
	ld b, $1c
	call GetSGBLayout
	call Function616a
	ld hl, OakText5
	call PrintText

.SelectGender
	call Function4b6
	call ClearTileMap
	call Function616a
	ld hl, .Text_BoyOrGirl
	call PrintText
	ld hl, .MenuDataHeader
	call LoadMenuDataHeader
	call Function3200
	call Function1d81
	call Function1c17
	ld a, [wcfa9]
	dec a
	ld [PlayerGender], a
	xor a
	ld [CurPartySpecies], a
	call Function4b6
	call ClearTileMap
	callba DrawIntroPlayerPic
	ld b, $1c
	call GetSGBLayout
	call Function616a
	ld a, [PlayerGender]
	and a
	jr z, .ConfirmBoy
	ld hl, .Text_ConfirmGirl
	jr .got_gender
.ConfirmBoy
	ld hl, .Text_ConfirmBoy
.got_gender
	call PrintText
	call YesNoBox
	jr c, .SelectGender

	ld hl, OakText6
	call PrintText
	call NamePlayer
	ld a, 1
	ld [PlayerName + 8], a
	ld hl, OakText8
	call PrintText
	call Function4b6
	call ClearTileMap
	xor a
	ld [CurPartySpecies], a
	callba DrawIntroRivalPic
	ld b, $1c
	call GetSGBLayout
	call Function616a
	ld hl, OakText9
	ld a, [PlayerGender]
	bit 0, a
	jr nz, .got_text_9
	ld hl, OakText9F
.got_text_9
	call PrintText
	call NameRivalRB
	ld hl, OakText10
	ld a, [PlayerGender]
	bit 0, a
	jr nz, .got_text_10
	ld hl, OakText10F
.got_text_10
	call PrintText
	call Function4b6
	call ClearTileMap
	xor a
	ld [CurPartySpecies], a
	callba DrawIntroPlayerPic
	ld b, $1c
	call GetSGBLayout
	call Function616a
	ld hl, OakText7
	call PrintText
	ret

.MenuDataHeader: ; 0x48dfc
	db $40 ; flags
	db 04, 06 ; start coords
	db 09, 12 ; end coords
	dw .MenuData2
	db 1 ; default option
; 0x48e04

.MenuData2: ; 0x48e04
	db $a1 ; flags
	db 2 ; items
	db "Gar.@"
	db "Fil.@"
; 0x48e0f

.Text_BoyOrGirl: ; 0x48e0f
	; Are you a boy? Or are you a girl?
	text_jump UnknownText_0x1c0ca3
	db "@"
; 0x48e14
.Text_ConfirmBoy
	text_jump ConfirmBoyText
	db "@"
.Text_ConfirmGirl
	text_jump ConfirmGirlText
	db "@"

OakText1: ; 0x6045
	TX_FAR _OakText1
	db "@"
OakText2: ; 0x604a
	TX_FAR _OakText2
	start_asm
	ld a, NIDORINO
	call PlayCry
	call WaitSFX
	ld hl, OakText3
	ret

OakText3: ; 0x605b
	TX_FAR _OakText3
	db "@"
OakText4: ; 0x6060
	TX_FAR _OakText4
	db "@"
OakText5: ; 0x6065
	TX_FAR _OakText5
	db "@"
OakText6: ; 0x606a
	TX_FAR _OakText6
	db "@"
OakText7: ; 0x606f
	TX_FAR _OakText7
	db "@"
OakText8:
	TX_FAR _OakText8
	db "@"
OakText9:
	TX_FAR _OakText9
	db "@"
OakText10:
	TX_FAR _OakText10
	db "@"
OakText9F:
	TX_FAR _OakText9F
	db "@"
OakText10F:
	TX_FAR _OakText10F
	db "@"
NamePlayer: ; 0x6074
	callba MovePlayerPicRight
	callba ShowPlayerNamingChoices
	ld a, [wcfa9]
	dec a
	jr z, .NewName
	call Function60fa
	callba Function8c1d
	callba MovePlayerPicLeft
	ret

.NewName
	ld b, 1
	ld de, PlayerName
	callba NamingScreen
	call Function4b6
	call ClearTileMap
	call Functione5f
	call WaitBGMap
	xor a
	ld [CurPartySpecies], a
	callba DrawIntroPlayerPic
	ld b, $1c
	call GetSGBLayout
	call Function4f0
	ld hl, PlayerName
	ld de, .Chris
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_60cf
	ld de, .Kris
.asm_60cf
	call InitName
	ret
IF DEF(APRILFOOLS)
.Chris
.Kris
	db "OLDEN@@@@@@"
ELSE
.Chris
	db "RUST@@@@@@@"
.Kris
	db "AZURE@@@@@@"
ENDC
; 60e9

NameRivalRB: ; 0x6074
	callba MovePlayerPicRight
	callba ShowRivalRBNamingChoices
	ld a, [wcfa9]
	dec a
	jr z, .NewName
	call SaveGreensNamePreset
	callba Function8c1d
	callba MovePlayerPicLeft
	ret

.NewName
	ld b, 8
	ld de, GreensName
	callba NamingScreen
	call Function4b6
	call ClearTileMap
	call Functione5f
	call WaitBGMap
	xor a
	ld [CurPartySpecies], a
	callba DrawIntroRivalPic
	ld b, $1c
	call GetSGBLayout
	call Function4f0
	ld hl, GreensName
	ld de, .Kris
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_60cf
	ld de, .Chris
.asm_60cf
	call InitName
	ret

.Chris
	db "RUST@@@@@@@"
.Kris
	db "AZURE@@@@@@"
; 60e9

Function60e9: ; 60e9
	call LoadMenuDataHeader
	call Function1d81
	ld a, [wcfa9]
	dec a
	call Function1db8
	call Function1c17
	ret
; 60fa

Function60fa: ; 60fa
	ld a, "@"
	ld bc, NAME_LENGTH
	ld hl, PlayerName
	call ByteFill
	ld hl, PlayerName
	ld de, StringBuffer2
	call CopyName2
	ret
; 610f

SaveGreensNamePreset:
	ld a, "@"
	ld bc, NAME_LENGTH
	ld hl, GreensName
	call ByteFill
	ld hl, GreensName
	ld de, StringBuffer2
	call CopyName2
	ret

Function610f: ; 610f
	ld a, [hROMBank]
	push af
	ld a, 0 << 7 | 32 ; fade out
	ld [MusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a
	ld de, SFX_ESCAPE_ROPE
	call PlaySFX
	pop af
	rst Bankswitch
	ld c, 8
	call DelayFrames
	ld hl, Shrink1Pic
	ld b, BANK(Shrink1Pic)
	call Function61b4
	ld c, 8
	call DelayFrames
	ld hl, Shrink2Pic
	ld b, BANK(Shrink2Pic)
	call Function61b4
	ld c, 8
	call DelayFrames
	hlcoord 6, 5
	ld b, 7
	ld c, 7
	call ClearBox
	ld c, 3
	call DelayFrames
	call Function61cd
	call Functione5f
	ld c, 50
	call DelayFrames
	call Function4b6
	call ClearTileMap
	ret
; 616a

Function616a: ; 616a
	ld hl, IntroFadePalettes
	ld b, IntroFadePalettesEnd - IntroFadePalettes
.asm_616f
	ld a, [hli]
	call DmgToCgbBGPals
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .asm_616f
	ret
; 617c

IntroFadePalettes: ; 0x617c
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100
IntroFadePalettesEnd
; 6182

Function6182: ; 6182
	ld a, $77
	ld [hWX], a
	call DelayFrame
	ld a, $e4
	call DmgToCgbBGPals
.asm_618e
	call DelayFrame
	ld a, [hWX]
	sub $8
	cp $ff
	ret z
	ld [hWX], a
	jr .asm_618e
; ; 619c

; Function6182: ; 6182
; Nonworking code, attempt to make nidorino come in from the opposite side
	; ld a, $87
	; ld [hWX], a
	; call DelayFrame
	; ld a, $e4
	; call DmgToCgbBGPals
; .asm_618e
	; call DelayFrame
	; ld a, [hWX]
	; add $8
	; cp $f
	; ret z
	; ld [hWX], a
	; jr .asm_618e

Function619c: ; 619c
	ld de, VTiles2
	callba GetTrainerPic
	xor a
	ld [$ffad], a
	hlcoord 6, 4
	ld bc, $0707
	predef FillBox
	ret
; 61b4

Function61b4: ; 61b4
	ld de, VTiles2
	ld c, $31
	predef DecompressPredef
	xor a
	ld [$ffad], a
	hlcoord 6, 4
	ld bc, $0707
	predef FillBox
	ret
; 61cd

Function61cd: ; 61cd
	callba GetPlayerIcon
	ld c, $c
	ld hl, VTiles0
	call Request2bpp
	ld hl, Sprites
	ld de, .data_61fe
	ld a, [de]
	inc de
	ld c, a
.asm_61e4
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld b, 0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_61f8
	ld b, 1
.asm_61f8
	ld a, b
	ld [hli], a
	dec c
	jr nz, .asm_61e4
	ret
; 61fe

.data_61fe ; 61fe
	db 4
	db $4c, $48, $00
	db $4c, $50, $01
	db $54, $48, $02
	db $54, $50, $03
; 620b

Function620b: ; 620b
	callab GS_Copyright_Intro
	jr c, Function6219
	callab Functione4579
	jr c, Function6219
	callba Functione48ac
Function6219: ; 6219
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call TitleScreen
	call DelayFrame
.asm_6226
	call Function627b
	jr nc, .asm_6226
	call ClearSprites
	call WhiteBGMap
	pop af
	ld [rSVBK], a
	ld hl, rLCDC
	res 2, [hl]
	call ClearScreen
	call Function3200
	xor a
	ld [hLCDStatCustom], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	ld b, $8
	call GetSGBLayout
	call UpdateTimePals
	ld a, [wcf64]
	cp $5
	jr c, .asm_625e
	xor a
.asm_625e
	ld e, a
	ld d, 0
	ld hl, .data_626a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 626a

.data_626a
	dw Function5ae8
	dw Function6389
	dw Function620b
	dw Function620b
	dw Function6392
; 6274

TitleScreen: ; 6274
	callba _TitleScreen
	ret
; 627b

Function627b: ; 627b
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_6290
	call TitleScreenScene
	callba Function10eea7
	call DelayFrame
	and a
	ret

.asm_6290
	scf
	ret
; 6292

Function6292: ; 6292 ; unreferenced
	ld a, [$ff9b]
	and $7
	ret nz
	ld hl, LYOverrides + $5f
	ld a, [hl]
	dec a
	ld bc, $0028
	call ByteFill
	ret
; 62a3

TitleScreenScene: ; 62a3
	ld e, a
	ld d, 0
	ld hl, .scenes
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 62af

.scenes
	dw TitleScreenEntrance
	dw TitleScreenTimer
	dw TitleScreenMain
	dw TitleScreenEnd
; 62b7

Function62b7: ; 62b7
	ld hl, wcf63
	inc [hl]
	ret
; 62bc

TitleScreenEntrance: ; 62bc
; Animate the logo:
; Move each line by 4 pixels until our count hits 0.

	ld a, [hSCX]
	and a
	jr z, .done
	sub 4
	ld [hSCX], a
; Lay out a base (all lines scrolling together).
; the original method used ByteFill which will cause
; a race condition with the drawing routine, making
; interlaced effect fails on odd lines

	ld e, a
	ld hl, LYOverrides
	ld c, 40 ; logo height / 2
.baseloop
	ld [hli], a
	inc hl
	dec c
	jr nz, .baseloop

; The rest is the offset from title timer

	ld a, [DefaultFlypoint]
	ld hl, LYOverrides + 80
	ld bc, 64
	call ByteFill
; Reversed signage for every other line's position.
; This is responsible for the interlaced effect.

	ld a, e
	xor $ff
	inc a
	ld b, 8 * 10 / 2 ; logo height / 2
	ld hl, LYOverrides + 1
.loop
	ld [hli], a
	inc hl
	dec b
	jr nz, .loop
	callba AnimateTitleCrystal

	; wait until line 73 so it won't interfere with the title
.loop2
	ld a, [rLY]
	cp 72
	jr nz, .loop2
	jp TitleScreenTrick

.done
; Next scene

	ld hl, wcf63
	inc [hl]
	xor a
	ld [hLCDStatCustom], a

; Play the title screen music.

	ld de, MUSIC_TITLE
	call PlayMusic
	ld a, $88
	ld [hWY], a
	jp TitleScreenTrick
; 62f6

TitleScreenTimer: ; 62f6
; Next scene

	ld hl, wcf63
	inc [hl]
; Start a timer

	ld hl, wcf65
	ld de, 75*60 ; 75 seconds, according to my tracker
	ld [hl], e
	inc hl
	ld [hl], d
	xor a ; restore VBlank mode to get joypad inputs
	ld [hVBlank], a
	jp TitleScreenTrick
; 6304

TitleScreenMain: ; 6304
; Run the timer down.

	ld hl, wcf65
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, e
	or d
	jr z, .end
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
; Save data can be deleted by pressing Up + B + Select.

	call GetJoypad
	ld hl, hJoyDown
	ld a, [hl]
	and D_UP + B_BUTTON + SELECT
	cp  D_UP + B_BUTTON + SELECT
	jr z, .delete_save_data
; To bring up the clock reset dialog:
; Hold Down + B + Select to initiate the sequence.

	ld a, [$ffeb]
	cp $34
	jr z, .check_clock_reset
	ld a, [hl]
	and D_DOWN + B_BUTTON + SELECT
	cp  D_DOWN + B_BUTTON + SELECT
	jr nz, .check_start
	ld a, $34
	ld [$ffeb], a
	jr .check_start
; Keep Select pressed, and hold Left + Up.
; Then let go of Select.

.check_clock_reset
	bit 2, [hl] ; SELECT
	jr nz, .check_start
	xor a
	ld [$ffeb], a
	ld a, [hl]
	and D_LEFT + D_UP
	cp  D_LEFT + D_UP
	jr z, .clock_reset
; Press Start or A to start the game.

.check_start
	ld a, [hl]
	and START | A_BUTTON
	jr nz, .continue
	jp TitleScreenTrick

.continue
	ld a, 0
	jr .done

.delete_save_data
	ld a, 1
.done
	ld [wcf64], a
; Return to the intro sequence.

	ld hl, wcf63
	set 7, [hl]
	ret

.end
; Next scene

	ld hl, wcf63
	inc [hl]
; Fade out the title screen music

	xor a
	ld [MusicFadeIDLo], a
	ld [MusicFadeIDHi], a
	ld hl, MusicFade
	ld [hl], 8 ; 1 second
	ld hl, wcf65
	inc [hl]
	jp TitleScreenTrick

.clock_reset
	ld a, 4
	ld [wcf64], a
; Return to the intro sequence.

	ld hl, wcf63
	set 7, [hl]
	ret
; 6375

TitleScreenTrick:
; Since Twitch logo and player silhouette combined are
; more than 40 sprites limit and the ground can't be scrolled
; without scrolling Pokemon logo along so some of the
; LCD scanline tricks needs to be applied here ;)

	; don't do anything if we're too late
	ld a, [rLY]
	cp 73
	ret nc
	; let's see if we can do OAM DMA on the fly
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a
	ld a, [hLCDStatCustom]
	push af
	xor a ; disable this in order to save more cycles in HBlank
	ld [hLCDStatCustom], a
	ld a, 2 ; only LCD
	ld [rIE], a
	ld a, 73 ; according to the mockup, hosts silhouette starts at line 76
	ld [rLYC], a
	ld a, $40 ; use LYC interrupt
	ld [rSTAT], a
	ld a, TC_Sprites >> 8 ; hijack PushOAM to transfer from TC_Sprites instead
	ld [hPushOAMAddress], a
	halt
	call $ff80
	ld a, Sprites >> 8
	ld [hPushOAMAddress], a
	ld a, [DefaultFlypoint]
	ld [LYOverrides+78], a
	ld a, rSCX - rJOYP
	ld [hLCDStatCustom], a
	ld a, 78
	ld [rLYC], a
	halt
	ld a, [hMPTmp]
	ld [LYOverrides+79], a
	ld a, rSCY - rJOYP
	ld [hLCDStatCustom], a
	ld a, 79
	ld [rLYC], a
	halt
	pop af
	ld [hLCDStatCustom], a
	pop af
	ld [rSVBK], a
	ld a, $8
	ld [rSTAT], a
	ld a, $f
	ld [rIE], a
	ret

TitleScreenEnd: ; 6375
; Wait until the music is done fading.

	ld hl, wcf65
	inc [hl]
	ld a, [MusicFade]
	and a
	jp nz, TitleScreenTrick
	ld a, 2
	ld [wcf64], a
; Back to the intro.

	ld hl, wcf63
	set 7, [hl]
	ret
; 6389

Function6389: ; 6389
	callba Function4d54c
	jp Init
; 6392

Function6392: ; 6392
	callba Function4d3b1
	jp Init
; 639b

Function639b: ; 639b
	ld a, [wcf65]
	and $3
	ret nz
	ld bc, wc3a4
	ld hl, $000a
	add hl, bc
	ld l, [hl]
	ld h, 0
	add hl, hl
	add hl, hl
	ld de, Data63ca
	add hl, de
	ld a, [wcf65]
	and $4
	srl a
	srl a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	and a
	ret z
	ld e, a
	ld d, [hl]
	ld a, $1
	call Function3b2a
	ret
; 63ca

Data63ca: ; 63ca
	db $5c, $50, $00, $00
	db $5c, $68, $5c, $58
	db $5c, $68, $5c, $78
	db $5c, $88, $5c, $78
	db $00, $00, $5c, $78
	db $00, $00, $5c, $58
; 63e2

Copyright: ; 63e2
	call ClearTileMap
	call Functione5f
	ld de, CopyrightGFX
	ld hl, VTiles2 + $600 ; tile $60
	lb bc, BANK(CopyrightGFX), $1d
	call Request2bpp
	ld de, CopyrightTPPGFX
	ld hl, VTiles1 ; tile $80
	lb bc, BANK(CopyrightTPPGFX), $5
	call Request2bpp
	hlcoord 2, 6
	ld de, CopyrightString
	jp PlaceString
; 63fd

CopyrightString: ; 63fd
	; 2016 TPP
	db $7f, $80, $81, $82, $7f, $7f, $7f, $83, $84

	db $4e
	; ©1995-2001 Nintendo
	db $60, $61, $62, $63, $64, $65, $66
	db $67, $68, $69, $6a, $6b, $6c
	db $4e
	; ©1995-2001 Creatures inc.
	db $60, $61, $62, $63, $64, $65, $66, $6d
	db $6e, $6f, $70, $71, $72, $7a, $7b, $7c
	db $4e
	; ©1995-2001 GAME FREAK inc.
	db $60, $61, $62, $63, $64, $65, $66, $73, $74
	db $75, $76, $77, $78, $79, $7a, $7b, $7c
	db "@"
; 642e

GameInit:: ; 642e
	callba Function14f1c
	call Function1fbf
	call WhiteBGMap
	call ClearTileMap
	ld a, $98
	ld [$ffd7], a
	xor a
	ld [hBGMapAddress], a
	ld [hJoyDown], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	call WaitBGMap
	jp Function620b
; 6454

Function6454:: ; 6454
	call DelayFrame
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	call Function6473
	pop af
	ld [hBGMapMode], a
	pop af
	ld [hOAMUpdate], a
	ld hl, VramState
	set 6, [hl]
	ret
; 6473

Function6473: ; 6473
	xor a
	ld [hLCDStatCustom], a
	ld [hBGMapMode], a
	ld a, $90
	ld [hWY], a
	call Function2173
	ld a, $9c
	call Function64b9
	call Function2e20
	callba Function49409
	callba Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	callba Function64db
	ld a, $98
	call Function64b9
	xor a
	ld [wd152], a
	ld a, $98
	ld [wd153], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call Function5958
	ret
; 64b9

Function64b9: ; 64b9
	ld [$ffd7], a
	xor a
	ld [hBGMapAddress], a
	ret
; 64bf

Function64bf:: ; 64bf
	ld a, [hOAMUpdate]
	push af
	ld a, $1
	ld [hOAMUpdate], a
	call Function64cd
	pop af
	ld [hOAMUpdate], a
	ret
; 64cd

Function64cd: ; 64cd
	call Functione5f
	ld a, $90
	ld [hWY], a
	call Function2e31
	call Functione51
	ret
; 64db

Function64db: ; 64db
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld a, $60
	ld hl, w6_d000
	ld bc, $400
	call ByteFill
	ld a, w6_d000 / $100
	ld [rHDMA1], a
	ld a, w6_d000 % $100
	ld [rHDMA2], a
	ld a, ($9800 % $8000) / $100
	ld [rHDMA3], a
	ld a, ($9800 % $8000) % $100
	ld [rHDMA4], a
	ld a, $3f
	ld [hDMATransfer], a
	call DelayFrame
	pop af
	ld [rSVBK], a
	ret
; 6508

LearnMove: ; if b = nz, cap new move's current pp to old pp (gen 5+ TM teaching).
	push bc ;store b
	call Function309d
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call GetNick ;get mon nickname
	ld hl, StringBuffer1
	ld de, wd050 ;store nickname
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
.loop
	ld hl, PartyMon1Moves
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes ;go down to correct mon
	ld d, h
	ld e, l
	ld b, NUM_MOVES
.next
	ld a, [hl]
	and a
	jr z, .quicklearn ;check for empty slot, if so, jump to learn else continue
	inc hl
	dec b
	jr nz, .next
	push de
	call Function65d3 ;forget move
	pop de
	jp c, .cancel ;if not forgetting, cancel
	push hl
	push de
	ld [wd265], a
	ld b, a
	ld a, [wBattleMode]
	and a
	jr z, .not_disabled ;clear disabled moves
	ld a, [DisabledMove]
	cp b
	jr nz, .not_disabled
	xor a
	ld [DisabledMove], a
	ld [PlayerDisableCount], a
.not_disabled
	call GetMoveName
	ld hl, UnknownText_0x6684
	call PrintText
	pop de
	pop hl
	jr .learn
.quicklearn
	pop af
	ld a, 0 ;clear don't force renew if putting move into a empty slot
	push af
.learn
	ld a, [wd262]
	ld [hl], a
	push de
	ld d, h
	ld e, l
	ld a, PARTYMON
	ld [MonType], a
	ld bc, PartyMon1PP - PartyMon1Moves ;start PP adjustment here
	add hl, bc ;over current PP for the replaced move
	push hl
	callab CheckMoveMaxPP ;put this move's max PP in wd265
		;ld a, [wd262]
		;dec a ;dec a to line up with correct move
		;ld hl, Moves + MOVE_PP
		;ld bc, MOVE_LENGTH
		;call AddNTimes
		;ld a, BANK(Moves)
		;call GetFarByte ;get move pp, put in a
		;push af ;stack: move base PP, location of PP to replace, start of correct mon moves, whether to force PP overwrite
	pop hl
	pop de
	pop af
	and a
	ld a, [wd265] ;load in max PP of the new move
	ld b, a
	jp z, .FillPP
	ld a, [hl]
	and $3f ;filter PP
	cp b
	jr c, .DontFillPP
.FillPP
	ld a, [hl]
	and $c0 ;preserve pp ups
	or b ;load PP into PP slot
	ld [hl], a
.DontFillPP
	ld a, [wBattleMode]
	and a
	jp z, .learned
	ld a, [CurPartyMon]
	ld b, a
	ld a, [CurBattleMon]
	cp b
	jp nz, .learned
	ld a, [PlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jp nz, .learned
	ld h, d
	ld l, e
	ld de, BattleMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	ld bc, PartyMon1PP - (PartyMon1Moves + NUM_MOVES)
	add hl, bc
	ld de, BattleMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	jp .learned

.cancel
	ld hl, UnknownText_0x6675
	call PrintText
	call YesNoBox
	jp c, .loop
	ld hl, UnknownText_0x667a
	call PrintText
	pop bc
	ld b, 0
	ret

.learned
	ld hl, UnknownText_0x666b
	call PrintText
	ld b, 1
	ret
; 65d3

Function65d3: ; 65d3
	push hl
	ld hl, UnknownText_0x667f
	call PrintText
	call YesNoBox
	pop hl
	ret c
	ld bc, -NUM_MOVES
	add hl, bc
	push hl
	ld de, wd25e
	ld bc, NUM_MOVES
	call CopyBytes
	pop hl
.asm_65ee
	push hl
	ld hl, UnknownText_0x6670
	call PrintText
	hlcoord 5, 2
	ld b, NUM_MOVES * 2
	ld c, MOVE_NAME_LENGTH
	call TextBox
	hlcoord 5 + 2, 2 + 2
	ld a, SCREEN_WIDTH * 2
	ld [Buffer1], a
	predef ListMoves
	ld a, $4
	ld [wcfa1], a
	ld a, $6
	ld [wcfa2], a
	ld a, [wd0eb]
	inc a
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld [wcfa9], a
	ld [wcfaa], a
	ld a, $3
	ld [wcfa8], a
	ld a, $20
	ld [wcfa5], a
	xor a
	ld [wcfa6], a
	ld a, $20
	ld [wcfa7], a

; If we wanted to use Military to forget a move, we'd do it here.
	call Function1bc9
	push af
	call Function30b4
	pop af
	pop hl
	bit 1, a
	jr nz, .asm_6669
	push hl
	ld a, [wcfa9]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	push af
	push bc
	call IsHMMove ;If A is a HM move, set carry flag
	pop bc
	pop de
	ld a, d
	jr c, .asm_6660
	pop hl
	add hl, bc
	and a
	ret

.asm_6660
	ld hl, UnknownText_0x669a ;If HM send message that they can't be forgotton
	call PrintText
	pop hl
	jr .asm_65ee

.asm_6669
	scf
	ret
; 666b

UnknownText_0x666b: ; 666b
	text_jump UnknownText_0x1c5660
	db "@"
; 6670

UnknownText_0x6670: ; 6670
	text_jump UnknownText_0x1c5678
	db "@"
; 6675

UnknownText_0x6675: ; 6675
	text_jump UnknownText_0x1c5699
	db "@"
; 667a

UnknownText_0x667a: ; 667a
	text_jump UnknownText_0x1c56af
	db "@"
; 667f

UnknownText_0x667f: ; 667f
	text_jump UnknownText_0x1c56c9
	db "@"
; 6684

UnknownText_0x6684: ; 6684
	text_jump UnknownText_0x1c5740
	start_asm
	push de
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	pop de
	ld hl, UnknownText_0x6695
	ret
; 6695

UnknownText_0x6695: ; 6695
	text_jump UnknownText_0x1c574e
	db "@"
; 669a

UnknownText_0x669a: ; 669a
	text_jump UnknownText_0x1c5772
	db "@"
; 669f

CheckNickErrors:: ; 669f
; error-check monster nick before use
; must be a peace offering to gamesharkers
; input: de = nick location

	push bc
	push de
	ld b, PKMN_NAME_LENGTH
.checkchar
; end of nick?

	ld a, [de]
	cp "@" ; terminator
	jr z, .end
; check if this char is a text command

	ld hl, .textcommands
	dec hl
.loop
; next entry

	inc hl
; reached end of commands table?

	ld a, [hl]
	cp a, $ff
	jr z, .done
; is the current char between this value (inclusive)...

	ld a, [de]
	cp [hl]
	inc hl
	jr c, .loop
; ...and this one?

	cp [hl]
	jr nc, .loop
; replace it with a "?"

	ld a, "?"
	ld [de], a
	jr .loop

.done
; next char

	inc de
; reached end of nick without finding a terminator?

	dec b
	jr nz, .checkchar
; change nick to "?@"

	pop de
	push de
	ld a, "?"
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
.end
; if the nick has any errors at this point it's out of our hands

	pop de
	pop bc
	ret
; 66cf

.textcommands ; 66cf
; table definining which characters
; are actually text commands
; format:
;       >=   <

	db $00, $05
	db $14, $19
	db $1d, $26
	db $35, $3a
	db $3f, $40
	db $49, $5d
	db $5e, $7f
	db $ff ; end
; 66de

_Multiply:: ; 66de
; hMultiplier is one byte.
	push de
	push hl
	ld a, [hMultiplier]
	cp 1
	jr z, .skip
	and a
	jr nz, .skip2
	ld [hProduct], a
	ld [hProduct + 1], a
	ld [hProduct + 2], a
	ld [hProduct + 3], a
	jr .skip
.skip2
	ld c, a
	ld a, [hMultiplicand]
	ld e, a
	ld a, [hMultiplicand + 1]
	ld h, a
	ld a, [hMultiplicand + 2]
	ld l, a
	xor a
	ld d, a
	ld [hProduct], a
	ld [hProduct + 1], a
	ld [hProduct + 2], a
	ld [hProduct + 3], a
	ld b, 8

.loop
	srl c
	jr nc, .next

	ld a, [hProduct + 3]
	add l
	ld [hProduct + 3], a
	ld a, [hProduct + 2]
	adc h
	ld [hProduct + 2], a
	ld a, [hProduct + 1]
	adc e
	ld [hProduct + 1], a
	ld a, [hProduct]
	adc d
	ld [hProduct], a

.next
	sla l
	rl h
	rl e
	rl d
	dec b
	jr nz, .loop
.skip
	pop hl
	pop de
	ret
; 673e

_Divide:: ; 673e
	push hl
	ld a, [hDivisor]
	and a
	jp z, .div0
	ld d, a
	ld c, hDividend % $100
	ld e, 0
	ld l, e
.loop
	push bc
	ld b, 8
	ld a, [$ff00+c]
	ld h, a
	ld l, 0
.loop2
	sla h
	rl e
	ld a, e
	jr c, .carry
	cp d
	jr c, .skip
.carry
	sub d
	ld e, a
	inc l
.skip
	ld a, b
	cp 1
	jr z, .done
	sla l
	dec b
	jr .loop2
.done
	ld a, c
	add hMathBuffer - hDividend
	ld c, a
	ld a, l
	ld [$ff00+c], a
	pop bc
	inc c
	dec b
	jr nz, .loop

	xor a
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld [hDividend + 3], a
	ld a, e
	ld [hDividend + 4], a ; I believe the remainder is stored here...
	ld [hDivisor], a ; and here too...
	ld a, c
	sub hDividend % $100
	ld b, a
	ld a, c
	add hMathBuffer - hDividend - 1
	ld c, a
	ld a, [$ff00+c]
	ld [hDividend + 3], a
	dec b
	jr z, .finished
	dec c
	ld a, [$ff00+c]
	ld [hDividend + 2], a
	dec b
	jr z, .finished
	dec c
	ld a, [$ff00+c]
	ld [hDividend + 1], a
	dec b
	jr z, .finished
	dec c
	ld a, [$ff00+c]
	ld [hDividend], a
.finished
	pop hl
	ret

.div0 ; OH SHI-
	ld a, $ff
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld [hDividend + 3], a
	pop hl
	ret
; 67c1

ItemAttributes: ; 67c1
INCLUDE "items/item_attributes.asm"
; 6ec1

Function6ec1: ; 6ec1
	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 5, [hl]
	jr z, .asm_6ed9
	ld hl, OBJECT_04
	add hl, bc
	bit 4, [hl]
	push hl
	push bc
	call Function6f2c
	pop bc
	pop hl
	ret c
	jr .asm_6ee9

.asm_6ed9
	ld hl, OBJECT_04
	add hl, bc
	bit 4, [hl]
	jr nz, .asm_6ee9
	push hl
	push bc
	call Function6f07
	pop bc
	pop hl
	ret c
.asm_6ee9
	bit 6, [hl]
	jr nz, .asm_6ef5
	push hl
	push bc
	call Function7009
	pop bc
	pop hl
	ret c
.asm_6ef5
	bit 5, [hl]
	jr nz, .asm_6f05
	push hl
	call Function70a4
	pop hl
	ret c
	push hl
	call Function70ed
	pop hl
	ret c
.asm_6f05
	and a
	ret
; 6f07

Function6f07: ; 6f07
	call Function6f5f
	ret c
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld hl, OBJECT_PALETTE
	add hl, bc
	bit 7, [hl]
	jp nz, Function6fa1
	ld hl, OBJECT_STANDING_TILE
	add hl, bc
	ld a, [hl]
	ld d, a
	call GetTileCollision
	and a
	jr z, Function6f3e
	scf
	ret
; 6f2c

Function6f2c: ; 6f2c
	call Function6f5f
	ret c
	ld hl, OBJECT_STANDING_TILE
	add hl, bc
	ld a, [hl]
	call GetTileCollision
	cp $1
	jr z, Function6f3e
	scf
	ret
; 6f3e

Function6f3e: ; 6f3e
	ld hl, OBJECT_STANDING_TILE
	add hl, bc
	ld a, [hl]
	call Function6f7f
	ret nc
	push af
	ld hl, OBJECT_07
	add hl, bc
	ld a, [hl]
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_6f5b
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret
; 6f5b

.data_6f5b
	db 1, 2, 8, 4
; 6f5f

Function6f5f: ; 6f5f
	ld hl, OBJECT_NEXT_TILE
	add hl, bc
	ld a, [hl]
	call Function6f7f
	ret nc
	push af
	ld hl, OBJECT_07
	add hl, bc
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_6f7b
	add hl, de
	pop af
	and [hl]
	ret z
	scf
	ret
; 6f7b

.data_6f7b
	db 2, 1, 4, 8
; 6f7f

Function6f7f: ; 6f7f
	ld d, a
	and $f0
	cp $b0
	jr z, .asm_6f8c
	cp $c0
	jr z, .asm_6f8c
	xor a
	ret

.asm_6f8c
	ld a, d
	and 7
	ld e, a
	ld d, 0
	ld hl, .data_6f99
	add hl, de
	ld a, [hl]
	scf
	ret
; 6f99

.data_6f99
	db 8, 4, 1, 2
	db 10, 6, 9, 5
; 6fa1

Function6fa1: ; 6fa1
	ld hl, OBJECT_07
	add hl, bc
	ld a, [hl]
	and 3
	jr z, .asm_6fb2
	dec a
	jr z, .asm_6fb7
	dec a
	jr z, .asm_6fbb
	jr .asm_6fbf

.asm_6fb2
	inc e
	push de
	inc d
	jr .asm_6fc2

.asm_6fb7
	push de
	inc d
	jr .asm_6fc2

.asm_6fbb
	push de
	inc e
	jr .asm_6fc2

.asm_6fbf
	inc d
	push de
	inc e
.asm_6fc2
	call Function2a3c
	call GetTileCollision
	pop de
	and a
	jr nz, .asm_6fd7
	call Function2a3c
	call GetTileCollision
	and a
	jr nz, .asm_6fd7
	xor a
	ret

.asm_6fd7
	scf
	ret
; 6fd9

CheckFacingObject:: ; 6fd9
	call GetFacingTileCoord
; Double the distance for counter tiles.

	call CheckCounterTile
	jr nz, .asm_6ff1
	ld a, [MapX]
	sub d
	cpl
	inc a
	add d
	ld d, a
	ld a, [MapY]
	sub e
	cpl
	inc a
	add e
	ld e, a
.asm_6ff1
	ld bc, ObjectStructs ; redundant
	ld a, 0
	ld [$ffaf], a
	call Function7041
	ret nc
	ld hl, OBJECT_07
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_7007
	xor a
	ret

.asm_7007
	scf
	ret
; 7009

Function7009: ; 7009
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]
	jr Function7041
; 7015

Function7015: ; 7015
	ld a, [$ffaf]
	call Function1ae5
	call Function7021
	call Function7041
	ret

Function7021: ; 7021
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]
	call GetSpriteDirection
	and a
	jr z, .asm_703b
	cp $4
	jr z, .asm_703d
	cp $8
	jr z, .asm_703f
	inc d
	ret

.asm_703b
	inc e
	ret

.asm_703d
	dec e
	ret

.asm_703f
	dec d
	ret
; 7041

Function7041: ; 7041 ;if any object is in contact with de, ret c
	ld bc, ObjectStructs
	xor a
.asm_7045
	ld [$ffb0], a ;load loop count into connected map width
	call Function1af1 ;a = [bc]
	jr z, .asm_7093 ;if zero, loop
	ld hl, OBJECT_04
	add hl, bc ; if [bc+4] bit 7 = 1, loop
	bit 7, [hl]
	jr nz, .asm_7093
	ld hl, OBJECT_PALETTE ;if bit 7 of bc + 6 = 0, check 1 spot?
	add hl, bc
	bit 7, [hl]
	jr z, .asm_7063
	call Function7171 ;ret c if d - objectx is 0 or 1 and e - yobject is 0 or 1 (check 4 spots? snorlax?)
	jr nc, .asm_707b ;else branch
	jr .asm_7073

.asm_7063
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_707b
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_707b ;if objectxy != de, branch else fall
.asm_7073
	ld a, [$ffaf]
	ld l, a
	ld a, [$ffb0]
	cp l
	jr nz, .asm_70a2 ;ret c if strip legnth = map width, else fall through
.asm_707b
	ld hl, OBJECT_NEXT_MAP_X ;ret c if strip legnth = map width and object nextxy = de, else fall through
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_7093
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_7093
	ld a, [$ffaf]
	ld l, a
	ld a, [$ffb0]
	cp l
	jr nz, .asm_70a2
.asm_7093
	ld hl, ObjectStruct2 - ObjectStruct1 ;check next object
	add hl, bc
	ld b, h
	ld c, l
	ld a, [$ffb0] ;loop up to 12 times
	inc a
	cp $d
	jr nz, .asm_7045
	and a ;ret nc if fail
	ret

.asm_70a2
	scf
	ret
; 70a4

Function70a4: ; 70a4
	ld hl, OBJECT_22
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_70e9
	and $f
	jr z, .asm_70c7
	ld e, a
	ld d, a
	ld hl, OBJECT_20
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_70eb
	cp e
	jr z, .asm_70eb
.asm_70c7
	ld hl, OBJECT_22
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	jr z, .asm_70e9
	ld e, a
	ld d, a
	ld hl, OBJECT_21
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld a, [hl]
	add e
	ld e, a
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_70eb
	cp e
	jr z, .asm_70eb
.asm_70e9
	xor a
	ret

.asm_70eb
	scf
	ret
; 70ed

Function70ed: ; 70ed
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [XCoord]
	cp [hl]
	jr z, .asm_70fe
	jr nc, .asm_7111
	add $9
	cp [hl]
	jr c, .asm_7111
.asm_70fe
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [YCoord]
	cp [hl]
	jr z, .asm_710f
	jr nc, .asm_7111
	add $8
	cp [hl]
	jr c, .asm_7111
.asm_710f
	and a
	ret

.asm_7111
	scf
	ret
; 7113

Function7113: ; 7113
	ld a, [MapX]
	ld d, a
	ld a, [MapY]
	ld e, a
	ld bc, ObjectStructs
	xor a
.asm_711f
	ld [$ffb0], a
	call Function1af1
	jr z, .asm_7160
	ld hl, OBJECT_03
	add hl, bc
	ld a, [hl]
	cp $15
	jr nz, .asm_7136
	call Function7171
	jr c, .asm_716f
	jr .asm_7160

.asm_7136
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_714e
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_714e
	ld a, [$ffb0]
	cp $0
	jr z, .asm_7160
	jr .asm_716f

.asm_714e
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .asm_7160
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	cp d
	jr nz, .asm_7160
	jr .asm_716f

.asm_7160
	ld hl, ObjectStruct2 - ObjectStruct1
	add hl, bc
	ld b, h
	ld c, l
	ld a, [$ffb0]
	inc a
	cp $d
	jr nz, .asm_711f
	xor a
	ret

.asm_716f
	scf
	ret
; 7171

Function7171: ; 7171 ret c if d - objectx is 0 or 1 and e - yobject is 0 or 1
	ld hl, OBJECT_MAP_X ;(bc+16)
	add hl, bc
	ld a, d
	sub [hl] ;d - object x corrd
	jr c, .asm_718b ;if d < x coord, ret nc
	cp $2
	jr nc, .asm_718b ;if result >2, ret nc
	ld hl, OBJECT_MAP_Y ;same for y and e
	add hl, bc
	ld a, e
	sub [hl]
	jr c, .asm_718b
	cp $2
	jr nc, .asm_718b
	scf
	ret

.asm_718b
	and a
	ret
; 718d

Function718d: ; 718d
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	ld de, PartySpecies
.asm_7196
	ld a, [de]
	cp EGG
	jr nz, .asm_719f
	inc de
	add hl, bc
	jr .asm_7196

.asm_719f
	ld [wd265], a
	ld a, [hl]
	ld [ScriptVar], a
	call GetPokemonName
	jp Function746e
; 71ac

Function71ac: ; 71ac
	ld a, [PartySpecies]
	ld [wd265], a
	cp EGG
	ld a, $1
	jr z, .asm_71b9
	xor a
.asm_71b9
	ld [ScriptVar], a ;scriptvar = 1 if an egg
	call GetPokemonName
	jp Function746e
; 71c2

ChangeHappiness: ; 71c2
; Perform happiness action c on CurPartyMon
; Which mon are we modifying?

	ld a, [CurPartyMon]
	inc a
	ld e, a
	ld d, 0
	ld hl, PartySpecies - 1
	add hl, de
	ld a, [hl]
	cp EGG ; An Egg can't be happy.
	ret z
; Find the corresponding happiness byte.

	push bc
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
; Happiness changes at different rates depending on its current value.

	push de
	ld a, [de]
	cp 100
	ld e, 0
	jr c, .asm_71ef
	inc e
	cp 200
	jr c, .asm_71ef
	inc e
; Different actions have different effects on happiness.

.asm_71ef
	dec c
	ld b, 0
	ld hl, .Actions
	add hl, bc
	add hl, bc
	add hl, bc
	ld d, 0
	add hl, de
	ld a, [hl]
	cp 100
	pop de
	ld a, [de]
	jr nc, .negative
	add [hl]
	jr nc, .asm_720d
	ld a, $ff
	jr .asm_720d

.negative
	add [hl]
	jr c, .asm_720d
	xor a
.asm_720d
	ld [de], a
	ld a, [wBattleMode]
	and a
	ret z
	ld a, [CurPartyMon]
	ld b, a
	ld a, [wd0d8]
	cp b
	ret nz
	ld a, [de]
	ld [BattleMonHappiness], a
	ret
; 7221

.Actions
	db  +5,  +3,  +2 ; Gained a level
	db  +5,  +3,  +2 ; Used a stat-boosting item (vitamin or X-item)
	db  +1,  +1,  +0
	db  +3,  +2,  +1 ; Battled a Gym Leader
	db  +1,  +1,  +0 ; Learned a move
	db  -1,  -1,  -1 ; Lost to an enemy
	db  -5,  -5, -10 ; Survived poisoning
	db  -5,  -5, -10 ; Lost to a much weaker enemy
	db  +1,  +1,  +1
	db  +3,  +3,  +1
	db  +5,  +5,  +2
	db  +1,  +1,  +1
	db  +3,  +3,  +1
	db +10, +10,  +4
	db  -5,  -5, -10 ; Used Heal Powder or Energypowder (bitter)
	db -10, -10, -15 ; Used Energy Root (bitter)
	db -15, -15, -20 ; Used Revival Herb (bitter)
	db  +3,  +3,  +1
	db +10,  +6,  +4
; 725a

StepHappiness:: ; 725a
; Raise the party's happiness by 1 point every other step cycle.

	ld hl, wdc77
	ld a, [hl]
	inc a
	and 1
	ld [hl], a
	ret nz
	ld de, PartyCount
	ld a, [de]
	and a
	ret z
	ld c, a
	ld hl, PartyMon1Happiness
.loop
	inc de
	ld a, [de]
	cp EGG
	jr z, .next
	inc [hl]
	jr nz, .next
	ld [hl], $ff
.next
	push de
	ld de, PartyMon2 - PartyMon1
	add hl, de
	pop de
	dec c
	jr nz, .loop
	ret
; 7282

DaycareStep:: ; 7282
	ld a, [wDaycareMan]
	bit 0, a
	jr z, .asm_72a4
	ld a, [wBreedMon1Level] ; level
	cp 100
	jr nc, .asm_72a4
	ld hl, wBreedMon1Exp + 2 ; exp
	inc [hl]
	jr nz, .asm_72a4
	dec hl
	inc [hl]
	jr nz, .asm_72a4
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	jr c, .asm_72a4
	ld a, $50
	ld [hl], a
.asm_72a4
	ld a, [wDaycareLady]
	bit 0, a
	jr z, .asm_72c6
	ld a, [wBreedMon2Level] ; level
	cp 100
	jr nc, .asm_72c6
	ld hl, wBreedMon2Exp + 2 ; exp
	inc [hl]
	jr nz, .asm_72c6
	dec hl
	inc [hl]
	jr nz, .asm_72c6
	dec hl
	inc [hl]
	ld a, [hl]
	cp $50
	jr c, .asm_72c6
	ld a, $50
	ld [hl], a
.asm_72c6
	ld hl, wDaycareMan
	bit 5, [hl] ; egg
	ret z
	ld hl, wStepsToEgg
	dec [hl]
	ret nz
	call Random
	ld [hl], a
	callab Function16e1d
	ld a, [wd265]
	cp $e6
	ld b, $50
	jr nc, .asm_72f8
	ld a, [wd265]
	cp $aa
	ld b, $28
	jr nc, .asm_72f8
	ld a, [wd265]
	cp $6e
	ld b, $1e
	jr nc, .asm_72f8
	ld b, $a
.asm_72f8
	call Random
	cp b
	ret nc
	ld hl, wDaycareMan
	res 5, [hl]
	set 6, [hl]
	ret
; 7305

SpecialGiveShuckle: ; 7305
; Adding to the party.

	xor a
	ld [MonType], a
; Level 15 Shuckle.

	ld a, SHUCKLE
	ld [CurPartySpecies], a
	ld a, 50
	ld [CurPartyLevel], a
	predef Functiond88c
	jr nc, .NotGiven
; Caught data.

	ld b, 0
	callba Function4dba3
; Holding a Berry.

	ld bc, PartyMon2 - PartyMon1
	ld a, [PartyCount]
	dec a
	push af
	push bc
	ld hl, PartyMon1Item
	call AddNTimes
	ld [hl], BERRY
	pop bc
	pop af
; OT ID.

	ld hl, PartyMon1ID
	call AddNTimes
	ld a, $2
	ld [hli], a
	ld [hl], $6
; Nickname.

	ld a, [PartyCount]
	dec a
	ld hl, PartyMonNicknames
	call SkipNames
	ld de, SpecialShuckleNick
	call CopyName2
; OT.

	ld a, [PartyCount]
	dec a
	ld hl, PartyMonOT
	call SkipNames
	ld de, SpecialShuckleOT
	call CopyName2
; Engine flag for this event.

	ld hl, DailyFlags
	set 5, [hl]
	ld a, 1
	ld [ScriptVar], a
	ret

.NotGiven
	xor a
	ld [ScriptVar], a
	ret

SpecialShuckleOT:
	db "MANIA@"
SpecialShuckleNick:
	db "SHUCKIE@"
; 737e

SpecialReturnShuckle: ; 737e
	callba Function50000
	jr c, .asm_73e6
	ld a, [CurPartySpecies]
	cp SHUCKLE
	jr nz, .DontReturn
	ld a, [CurPartyMon]
	ld hl, PartyMon1ID
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
; OT ID

	ld a, [hli]
	cp $2
	jr nz, .DontReturn
	ld a, [hl]
	cp $6
	jr nz, .DontReturn
; OT

	ld a, [CurPartyMon]
	ld hl, PartyMonOT
	call SkipNames
	ld de, SpecialShuckleOT
.CheckOT
	ld a, [de]
	cp [hl]
	jr nz, .DontReturn
	cp "@"
	jr z, .asm_73bb
	inc de
	inc hl
	jr .CheckOT

.asm_73bb
	callba Functione538
	jr c, .asm_73f1
	ld a, [CurPartyMon]
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hl]
	cp 150
	ld a, $3
	jr nc, .asm_73e2
	xor a
	ld [wd10b], a
	callab Functione039
	ld a, $2
.asm_73e2
	ld [ScriptVar], a
	ret

.asm_73e6
	ld a, $1
	ld [ScriptVar], a
	ret

.DontReturn
	xor a
	ld [ScriptVar], a
	ret

.asm_73f1
	ld a, $4
	ld [ScriptVar], a
	ret
; 73f7

Function73f7: ; 73f7
	callba Function50000
	jr c, .asm_740e
	ld a, [CurPartySpecies]
	ld [ScriptVar], a
	ld [wd265], a
	call GetPokemonName
	jp Function746e

.asm_740e
	xor a
	ld [ScriptVar], a
	ret
; 7413

Function7413: ; 7413
	ld hl, Data7459
	jr Function7420

Function7418: ; 7418
	ld hl, Data7462
	jr Function7420

Function741d: ; 741d
	ld hl, Data746b
Function7420: ; 7420
	push hl
	callba Function50000
	pop hl
	jr c, .asm_744e
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_7453
	push hl
	call GetCurNick
	call Function746e
	pop hl
	call Random
.next
	cp [hl]
	jr c, .asm_7444
	jr z, .asm_7444
	inc hl
	inc hl
	inc hl
	jr .next

.asm_7444
	inc hl
	ld a, [hli]
	ld [ScriptVar], a
	ld c, [hl]
	call ChangeHappiness
	ret

.asm_744e
	xor a
	ld [ScriptVar], a
	ret

.asm_7453
	ld a, $1
	ld [ScriptVar], a
	ret
; 7459

Data7459: ; 7459
	db  30 percent, $02, $09
	db  50 percent, $03, $0a
	db 100 percent, $04, $0b
Data7462: ; 7462
	db  60 percent, $02, $0c
	db  90 percent, $03, $0d
	db 100 percent, $04, $0e
Data746b: ; 746b
	db 100 percent, $02, $12
; 746e

Function746e: ; 746e
	ld hl, StringBuffer1
	ld de, StringBuffer3
	ld bc, $000b
	jp CopyBytes
; 747a

Predef1: ; 747a
; not used

	ret
; 747b

SECTION "bank2", ROMX, BANK[$2]

Function8000: ; 8000
	call Function2ed3
	xor a
	ld [hBGMapMode], a
	call WhiteBGMap
	call ClearSprites
	hlcoord 0, 0
	ld bc, TileMapEnd - TileMap
	ld a, " "
	call ByteFill
	hlcoord 0, 0, AttrMap
	ld bc, AttrMapEnd - AttrMap
	ld a, $7
	call ByteFill
	call Function3200
	call Function32f9
	ret
; 8029

Function8029: ; 8029
	ld a, $ff
	ld [wd4cd], a
	ld [wd4ce], a
	ld a, $0
	ld hl, PlayerObjectTemplate
	call Function19a6
	ld b, $0
	call Function808f
	ld a, $0
	call GetMapObject
	ld hl, $0008
	add hl, bc
	ld e, $80
	ld a, [wd45b]
	bit 2, a
	jr nz, .asm_8059
	ld a, [wPlayerPalette] ; NEW
	and a ; NEW
	jr z, .use_gender ; NEW
	swap a ; NEW
	ld e, a ; NEW
	jr .asm_8059 ; NEW
.use_gender ; NEW
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_8059
	ld e, $90
.asm_8059
	ld [hl], e
	ld a, $0
	ld [$ffaf], a
	ld bc, MapObjects
	ld a, $0
	ld [$ffb0], a
	ld de, ObjectStructs
	call Function8116
	ld a, $0
	ld [wd4cf], a
	ret
; 8071

PlayerObjectTemplate: ; 8071
; A dummy map object used to initialize the player object.
; Shorter than the actual amount copied by two bytes.
; Said bytes seem to be unused.

	person_event SPRITE_RUST, 0, 0, $0b, 15, 15, -1, -1, 0, 0, 0, $0000, -1
; 807e

Function807e:: ; 807e
	push de
	ld a, b
	call GetMapObject
	pop de
	ld hl, $0003
	add hl, bc
	ld [hl], d
	ld hl, $0002
	add hl, bc
	ld [hl], e
	ret
; 808f

Function808f: ; 808f
	push bc
	ld a, [XCoord]
	add $4
	ld d, a
	ld a, [YCoord]
	add $4
	ld e, a
	pop bc
	call Function807e
	ret
; 80a1

Function80a1:: ; 80a1
	ld a, b
	call Function18de
	ret c
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld a, [$ffaf]
	ld b, a
	call Function807e
	and a
	ret
; 80b8

Function80b8: ; 80b8
	ld a, [XCoord]
	add $4
	ld d, a
	ld hl, MapX
	sub [hl]
	ld [hl], d
	ld hl, MapObjects + 3
	ld [hl], d
	ld hl, MapX2
	ld [hl], d
	ld d, a
	ld a, [YCoord]
	add $4
	ld e, a
	ld hl, MapY
	sub [hl]
	ld [hl], e
	ld hl, MapObjects + 2
	ld [hl], e
	ld hl, MapY2
	ld [hl], e
	ld e, a
	ld a, [wd4cd]
	cp $0
	ret nz
	ret
; 80e7

Function80e7:: ; 80e7
	call Function2707
	and a
	ret nz
	ld hl, ObjectStructs + (ObjectStruct2 - ObjectStruct1) * 1
	ld a, 1
	ld de, ObjectStruct2 - ObjectStruct1
.asm_80f4
	ld [$ffb0], a
	ld a, [hl]
	and a
	jr z, .asm_8104
	add hl, de
	ld a, [$ffb0]
	inc a
	cp $d
	jr nz, .asm_80f4
	scf
	ret

.asm_8104
	ld d, h
	ld e, l
	call Function8116
	ld hl, VramState
	bit 7, [hl]
	ret z
	ld hl, OBJECT_FLAGS
	add hl, de
	set 5, [hl]
	ret
; 8116

Function8116: ; 8116
	call Function811d
	call Function8286
	ret
; 811d

Function811d: ; 811d
	ld a, [$ffb0]
	ld hl, OBJECT_00
	add hl, bc
	ld [hl], a
	ld a, [$ffaf]
	ld [wc2f0], a
	ld hl, OBJECT_01
	add hl, bc
	ld a, [hl]
	ld [wc2f1], a
	call Function180e
	ld [wc2f2], a
	ld a, [hl]
	call GetSpritePalette
	ld [wc2f3], a
	ld hl, OBJECT_08
	add hl, bc
	ld a, [hl]
	and $f0
	jr z, .asm_814e
	swap a
	and $7
	ld [wc2f3], a
.asm_814e
	ld hl, OBJECT_04
	add hl, bc
	ld a, [hl]
	ld [wc2f4], a
	ld hl, OBJECT_09
	add hl, bc
	ld a, [hl]
	ld [wc2f5], a
	ld hl, OBJECT_03
	add hl, bc
	ld a, [hl]
	ld [wc2f6], a
	ld hl, OBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	ld [wc2f7], a
	ld hl, OBJECT_FLAGS
	add hl, bc
	ld a, [hl]
	ld [wc2f8], a
	ret
; 8177

Function8177: ; 8177
	ld bc, MapObjects + OBJECT_LENGTH
	ld a, $1
.asm_817c
	ld [$ffaf], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_81bb
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_81bb
	ld a, [XCoord]
	ld d, a
	ld a, [YCoord]
	ld e, a
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	add $1
	sub d
	jr c, .asm_81bb
	cp $c
	jr nc, .asm_81bb
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_81bb
	cp $b
	jr nc, .asm_81bb
	push bc
	call Function80e7
	pop bc
	jp c, Function81c9
.asm_81bb
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ld a, [$ffaf]
	inc a
	cp $10
	jr nz, .asm_817c
	ret
; 81c9

Function81c9: ; 81c9
	ret
; 81ca

Function81ca:: ; 81ca
	nop
	ld a, [wd151]
	cp $ff
	ret z
	ld hl, Table81d6
	rst JumpTable
	ret
; 81d6

Table81d6: ; 81d6
	dw Function81e5
	dw Function81de
	dw Function8232
	dw Function8239
; 81de

Function81de: ; 81de
	ld a, [YCoord]
	sub $1
	jr Function81ea

Function81e5: ; 81e5
	ld a, [YCoord]
	add $9
Function81ea: ; 81ea
	ld d, a
	ld a, [XCoord]
	ld e, a
	ld bc, MapObjects + OBJECT_LENGTH
	ld a, $1
.asm_81f4
	ld [$ffaf], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_8224
	ld hl, $0002
	add hl, bc
	ld a, d
	cp [hl]
	jr nz, .asm_8224
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8224
	ld hl, $0003
	add hl, bc
	ld a, [hl]
	add $1
	sub e
	jr c, .asm_8224
	cp $c
	jr nc, .asm_8224
	push de
	push bc
	call Function80e7
	pop bc
	pop de
.asm_8224
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ld a, [$ffaf]
	inc a
	cp $10
	jr nz, .asm_81f4
	ret
; 8232

Function8232: ; 8232
	ld a, [XCoord]
	sub $1
	jr Function823e

Function8239: ; 8239
	ld a, [XCoord]
	add $a
Function823e: ; 823e
	ld e, a
	ld a, [YCoord]
	ld d, a
	ld bc, MapObjects + OBJECT_LENGTH
	ld a, $1
.asm_8248
	ld [$ffaf], a
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_8278
	ld hl, $0003
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, .asm_8278
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8278
	ld hl, $0002
	add hl, bc
	ld a, [hl]
	add $1
	sub d
	jr c, .asm_8278
	cp $b
	jr nc, .asm_8278
	push de
	push bc
	call Function80e7
	pop bc
	pop de
.asm_8278
	ld hl, OBJECT_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	ld a, [$ffaf]
	inc a
	cp $10
	jr nz, .asm_8248
	ret
; 8286

Function8286: ; 8286
	ld a, [wc2f0]
	ld hl, OBJECT_01
	add hl, de
	ld [hl], a
	ld a, [wc2f4]
	call Function1a61
	ld a, [wc2f3]
	ld hl, OBJECT_PALETTE
	add hl, de
	or [hl]
	ld [hl], a
	ld a, [wc2f7]
	call Function82d5
	ld a, [wc2f6]
	call Function82f1
	ld a, [wc2f1]
	ld hl, OBJECT_00
	add hl, de
	ld [hl], a
	ld a, [wc2f2]
	ld hl, OBJECT_SPRITE
	add hl, de
	ld [hl], a
	ld hl, OBJECT_09
	add hl, de
	ld [hl], $0
	ld hl, OBJECT_FACING
	add hl, de
	ld [hl], $ff
	ld a, [wc2f8]
	call Function830d
	ld a, [wc2f5]
	ld hl, OBJECT_32
	add hl, de
	ld [hl], a
	and a
	ret
; 82d5

Function82d5: ; 82d5
	ld hl, OBJECT_21
	add hl, de
	ld [hl], a
	ld hl, OBJECT_MAP_Y
	add hl, de
	ld [hl], a
	ld hl, YCoord
	sub [hl]
	and $f
	swap a
	ld hl, wd14d
	sub [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, de
	ld [hl], a
	ret
; 82f1

Function82f1: ; 82f1
	ld hl, OBJECT_20
	add hl, de
	ld [hl], a
	ld hl, OBJECT_MAP_X
	add hl, de
	ld [hl], a
	ld hl, XCoord
	sub [hl]
	and $f
	swap a
	ld hl, wd14c
	sub [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, de
	ld [hl], a
	ret
; 830d

Function830d: ; 830d
	ld h, a
	inc a
	and $f
	ld l, a
	ld a, h
	add $10
	and $f0
	or l
	ld hl, OBJECT_22
	add hl, de
	ld [hl], a
	ret
; 831e

Function831e: ; 831e
	ld a, [$ffe0]
	call Function1b1e
	ld a, $3e
	call Function1b3f
	ld a, [wd03f]
	dec a
	jr z, Function833b
	ld a, [$ffe0]
	ld b, a
	ld c, $0
	ld d, $1
	call Function8341
	call Function1b35
Function833b
	ld a, $47
	call Function1b3f
	ret
; 8341

Function8341: ; 8341
	push de
	push bc
	ld a, c
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	call Function1ae5
	ld d, b
	ld e, c
	pop bc
	ld a, b
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	call Function1ae5
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld c, [hl]
	ld b, a
	ld hl, OBJECT_MAP_X
	add hl, de
	ld a, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, de
	ld e, [hl]
	ld d, a
	pop af
	call Function1b5f
	ret
; 8379

Function8379: ; 8379
	call Function1b1e
	call Function8388
	call Function1b3f
	ld a, $47 ; movement_step_end
	call Function1b3f
	ret
; 8388

Function8388: ; 8388
	ld a, [PlayerDirection]
	srl a
	srl a
	and 3
	ld e, a
	ld d, 0
	ld hl, .data_839a
	add hl, de
	ld a, [hl]
	ret
; 839a

.data_839a
	db $8 ; movement_slow_step_down
	db $9 ; movement_slow_step_up
	db $a ; movement_slow_step_left
	db $b ; movement_slow_step_right
; 839e

Function839e:: ; 839e
	push bc
	ld a, c
	call Function18de
	ld d, b
	ld e, c
	pop bc
	ret c
	ld a, b
	call Function18de
	ret c
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld c, [hl]
	ld b, a
	ld hl, OBJECT_MAP_X
	add hl, de
	ld a, [hl]
	cp b
	jr z, .asm_83c7
	jr c, .asm_83c4
	inc b
	jr .asm_83d5

.asm_83c4
	dec b
	jr .asm_83d5

.asm_83c7
	ld hl, OBJECT_MAP_Y
	add hl, de
	ld a, [hl]
	cp c
	jr z, .asm_83d5
	jr c, .asm_83d4
	inc c
	jr .asm_83d5

.asm_83d4
	dec c
.asm_83d5
	ld hl, OBJECT_MAP_X
	add hl, de
	ld [hl], b
	ld a, b
	ld hl, XCoord
	sub [hl]
	and $f
	swap a
	ld hl, wd14c
	sub [hl]
	ld hl, OBJECT_SPRITE_X
	add hl, de
	ld [hl], a
	ld hl, OBJECT_MAP_Y
	add hl, de
	ld [hl], c
	ld a, c
	ld hl, YCoord
	sub [hl]
	and $f
	swap a
	ld hl, wd14d
	sub [hl]
	ld hl, OBJECT_SPRITE_Y
	add hl, de
	ld [hl], a
	ld a, [$ffb0]
	ld hl, OBJECT_32
	add hl, de
	ld [hl], a
	ld hl, OBJECT_03
	add hl, de
	ld [hl], $1a
	ld hl, OBJECT_09
	add hl, de
	ld [hl], $0
	ret
; 8417

Function8417:: ; 8417
	ld a, d ;put d in a
	call GetMapObject ;get map object a
	ld hl, $0000
	add hl, bc ;put that object into bc
	ld a, [hl] ;load what's there into a
	cp $d
	jr nc, .asm_8437 ;if >= 13 return, otherwise continue
	ld d, a
	ld a, e
	call GetMapObject
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	cp $d
	jr nc, .asm_8437
	ld e, a ;same as the first augment
	call Function8439 ; = direction to face(?)
	ret

.asm_8437
	scf
	ret
; 8439

Function8439: ; 8439
	ld a, d
	call Function1ae5 ;go down object structs d times, return the found location into bc
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, [hl] ;load x coordinate into b
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld c, [hl] ;load y coordinate into c
	ld b, a
	push bc ;
	ld a, e
	call Function1ae5
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]; same as above for the second augment, but with de
	pop bc
	ld a, b; NOTE logic comments are incomplete
	sub d
	jr z, .asm_846c ;if both are on the same x axis, jump
	jr nc, .asm_8460 ;if 1.x > 2.x, jump ahead
	cpl ;invert and increment 1.x-2.x
	inc a ;increase it by 1
.asm_8460
	ld h, a ;store  1.x - 2.x in h
	ld a, c
	sub e
	jr z, .asm_847a
	jr nc, .asm_8469 ;same as above with y
	cpl
	inc a
.asm_8469
	sub h ;x difference - y difference
	jr c, .asm_847a ;If x difference > y difference, jump, else fall through
.asm_846c ; if y difference > x difference or x difference = 0. c can be y1 or y1 - y2
	ld a, c
	cp e
	jr z, .asm_8488 ;if y1 = y2
	jr c, .asm_8476 ;if y is difference OR y1 > y2
	ld d, $0 ;else d = 0
	and a
	ret

.asm_8476 ;if x is same OR y1 > y2
	ld d, $1 ;d = 1
	and a
	ret

.asm_847a ;if y1 = y2 OR x difference > y difference. b is x1 - x2
	ld a, b
	cp d
	jr z, .asm_8488 ; if b is twice d and d > y difference, d = 0 and scf
	jr c, .asm_8484 ; id 2*d > b, d = 2
	ld d, $3 ;else d = 3
	and a
	ret

.asm_8484
	ld d, $2
	and a
	ret

.asm_8488
	scf
	ret
; 848a

Function848a: ; 848a
	call Function849d
	jr c, .asm_8497
	ld [wd4d1], a
	xor a
	ld [wd4d0], a
	ret

.asm_8497
	ld a, $ff
	ld [wd4d0], a
	ret
; 849d

Function849d: ; 849d
	ld a, [wd4cd]
	call Function1ae5
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld d, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld e, [hl]
	ld a, [wd4ce]
	call Function1ae5
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld a, d
	cp [hl]
	jr z, .asm_84c5
	jr c, .asm_84c1
	and a
	ld a, $f
	ret

.asm_84c1
	and a
	ld a, $e
	ret

.asm_84c5
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld a, e
	cp [hl]
	jr z, .asm_84d7
	jr c, .asm_84d3
	and a
	ld a, $c
	ret

.asm_84d3
	and a
	ld a, $d
	ret

.asm_84d7
	scf
	ret
; 84d9

_Sine:: ; 84d9
; A simple sine function.
; Return d * sin(e) in hl.
; e is a signed 6-bit value.

	ld a, e
	and %111111
	cp  %100000
	jr nc, .negative
	call Function84ef
	ld a, h
	ret

.negative
	and %011111
	call Function84ef
	ld a, h
	xor $ff
	inc a
	ret
; 84ef

Function84ef: ; 84ef
	ld e, a
	ld a, d
	ld d, 0
	ld hl, SineWave
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
; Factor amplitude

.multiply
	srl a
	jr nc, .even
	add hl, de
.even
	sla e
	rl d
	and a
	jr nz, .multiply
	ret
; 850b

SineWave: ; 850b
; A $20-word table representing a sine wave.
; 90 degrees is index $10 at a base amplitude of $100.

	sine_wave $100
; 854b

GetPredefPointer:: ; 854b
; Return the bank and address of PredefID in a and PredefAddress.
; Save hl for later (back in Predef)

	ld a, h
	ld [PredefTemp], a
	ld a, l
	ld [PredefTemp + 1], a
	push de
	ld a, [PredefID]
	ld e, a
	ld d, 0
	ld hl, PredefPointers
	add hl, de
	add hl, de
	add hl, de
	pop de
	ld a, [hli]
	ld [PredefAddress + 1], a
	ld a, [hli]
	ld [PredefAddress], a
	ld a, [hl]
	ret
; 856b

PredefPointers:: ; 856b
; $4b Predef pointers
; address, bank

	add_predef LearnMove ; $0
	add_predef Predef1
	add_predef HealParty
	add_predef FlagPredef
	add_predef Functionc699
	add_predef FillPP
	add_predef Functiond88c
	add_predef Functionda96
	add_predef Functiondb3f ; $8
	add_predef Functionde6e
	add_predef GiveEgg
	add_predef Predef_HPBarAnim
	add_predef CalcPkmnStats
	add_predef CalcPkmnStatC
	add_predef CanLearnTMHMMove
	add_predef GetTMHMMove
	add_predef Function28eef ; $ 10
	add_predef PrintMoveDesc
	add_predef UpdatePlayerHUD
	add_predef FillBox
	add_predef CheckAnyPartyMonAlive
	add_predef UpdateEnemyHUD
	add_predef StartBattle
	add_predef FillInExpBar
	add_predef Function3f43d ; $18
	add_predef Function3f47c
	add_predef LearnLevelMoves
	add_predef FillMoves
	add_predef Function421e6
	add_predef Function28f63
	add_predef Function28f24
	add_predef Function5084a
	add_predef ListMoves ; $20
	add_predef Function50d2e
	add_predef Function50cdb
	add_predef Function50c50
	add_predef GetGender
	add_predef StatsScreenInit
	add_predef DrawPlayerHP
	add_predef DrawEnemyHP
	add_predef PrintTempMonStats ; $28
	add_predef GetTypeName
	add_predef PrintMoveType
	add_predef PrintType
	add_predef PrintMonTypes
	add_predef GetUnownLetter
	add_predef Functioncbcdd
	add_predef Predef2F
	add_predef Function9853 ; $30
	add_predef Function864c
	add_predef Function91d11
	add_predef CheckContestMon
	add_predef Function8c20f
	add_predef Function8c000
	add_predef Function8c000_2
	add_predef PlayBattleAnim
	add_predef Predef38 ; $38
	add_predef Predef39
	add_predef Functionfd1d0
	add_predef PartyMonItemName
	add_predef GetFrontpic
	add_predef GetBackpic
	add_predef Function5108b
	add_predef GetTrainerPic
	add_predef DecompressPredef ; $40
	add_predef Function347d3
	add_predef Functionfb908
	add_predef Functionfb877
	add_predef Functiond0000
	add_predef Function50d0a
	add_predef Functiond00a3
	add_predef Functiond008e
	add_predef Functiond0669 ; $48
	add_predef Functiond066e
	dwb $43ff, $2d ; ????
	; $ff432d
	; dbw $ff, Function2d43 ; ????
; 864c

INCLUDE "engine/color.asm"

SECTION "bank3", ROMX, BANK[$3]

Functionc000:: ; c000
	ld a, [TimeOfDay]
	ld hl, Datac012
	ld de, 2
	call IsInArray
	inc hl
	ld c, [hl]
	ret c
	xor a
	ld c, a
	ret
; c012

Datac012: ; c012
	db MORN, 1
	db DAY,  2
	db NITE, 4
	db NITE, 4
	db $ff
; c01b

INCLUDE "engine/specials.asm"

_PrintNum:: ; c4c7
; Print c digits of the b-byte value at hl.
; Allows 2 to 7 digits. For 1-digit numbers, add
; the value to char "0" instead of calling PrintNum.
; Some extra flags can be given in bits 5-7 of b.

	push bc
	bit 5, b
	jr z, .main ;if bit 5 of b is off, go to main
	bit 7, b
	jr nz, .bit_7 ;if bit z is on, jump
	bit 6, b
	jr z, .main
.bit_7 ;if bit 5 of b is off AND (7 is on OR 6 is off)
	ld a, $f0
	ld [hli], a ;input 240 first
	res 5, b ;reset bit 5
.main
	xor a ;a = 0
	ld [$ffb3], a ;0 out these variables
	ld [$ffb4], a
	ld [$ffb5], a
	ld a, b
	and $f ;check first 4 bits only
	cp 1
	jr z, .byte ;if bit 1 only then byte, if bit 2 only then word, else long. deterines legnth of lord to fill with
	cp 2
	jr z, .word
.long ;put a in a variable based on the legnth of the fill
	ld a, [de]
	ld [$ffb4], a
	inc de
.word
	ld a, [de]
	ld [$ffb5], a
	inc de
.byte
	ld a, [de]
	ld [$ffb6], a
	push de
	ld d, b ;d holds the length/options byte b
	ld a, c
	swap a
	and $f
	ld e, a ;back nyble of a is in front nyble of e
	ld a, c
	and $f
	ld b, a ;b = front nyble of a
	ld c, 0
	cp 2 ;jump to correct number of bytes
	jr z, .two
	cp 3
	jr z, .three
	cp 4
	jr z, .four
	cp 5
	jr z, .five
	cp 6
	jr z, .six
.seven
	ld a, 1000000 / $10000 % $100 ; = 15
	ld [$ffb7], a
	ld a, 1000000 / $100 % $100 ; = 66
	ld [$ffb8], a
	ld a, 1000000 % $100 ; = 0
	ld [$ffb9], a
	call .PrintDigit
	call .AdvancePointer
.six
	ld a, 100000 / $10000 % $100
	ld [$ffb7], a
	ld a, 100000 / $100 % $100
	ld [$ffb8], a
	ld a, 100000 % $100
	ld [$ffb9], a
	call .PrintDigit
	call .AdvancePointer
.five
	xor a
	ld [$ffb7], a
	ld a, 10000 / $100
	ld [$ffb8], a
	ld a, 10000 % $100
	ld [$ffb9], a
	call .PrintDigit
	call .AdvancePointer
.four
	xor a
	ld [$ffb7], a
	ld a, 1000 / $100
	ld [$ffb8], a
	ld a, 1000 % $100
	ld [$ffb9], a
	call .PrintDigit
	call .AdvancePointer
.three
	xor a
	ld [$ffb7], a
	xor a
	ld [$ffb8], a
	ld a, 100
	ld [$ffb9], a
	call .PrintDigit
	call .AdvancePointer
.two
	dec e
	jr nz, .asm_c583
	ld a, "0"
	ld [$ffb3], a
.asm_c583
	ld c, 0
	ld a, [$ffb6]
.mod_10
	cp 10
	jr c, .modded_10
	sub 10
	inc c
	jr .mod_10

.modded_10
	ld b, a
	ld a, [$ffb3]
	or c
	jr nz, .asm_c59b
	call .PrintLeadingZero
	jr .asm_c5ad

.asm_c59b
	call .PrintYen
	push af
	ld a, "0"
	add c
	ld [hl], a
	pop af
	ld [$ffb3], a
	inc e
	dec e
	jr nz, .asm_c5ad
	inc hl
	ld [hl], "." ; XXX
.asm_c5ad
	call .AdvancePointer
	call .PrintYen
	ld a, "0"
	add b
	ld [hli], a
	pop de
	pop bc
	ret
; c5ba

.PrintYen: ; c5ba
	push af
	ld a, [$ffb3]
	and a
	jr nz, .asm_c5c9
	bit 5, d
	jr z, .asm_c5c9
	ld a, "¥"
	ld [hli], a
	res 5, d
.asm_c5c9
	pop af
	ret
; c5cb

.PrintDigit: ; c5cb (3:45cb)
	dec e
	jr nz, .ok
	ld a, "0"
	ld [$ffb3], a ;if no remaining flags, 0 this out
.ok
	ld c, 0
.asm_c5d4
	ld a, [$ffb7] ; b =first didgit of number to fill out
	ld b, a
	ld a, [$ffb4] ;0 unless long, otherwise contents of de
	ld [$ffba], a
	cp b
	jr c, .asm_c624
	sub b
	ld [$ffb4], a
	ld a, [$ffb8]
	ld b, a
	ld a, [$ffb5]
	ld [$ffbb], a
	cp b
	jr nc, .asm_c5f6
	ld a, [$ffb4]
	or 0
	jr z, .asm_c620
	dec a
	ld [$ffb4], a
	ld a, [$ffb5]
.asm_c5f6
	sub b
	ld [$ffb5], a
	ld a, [$ffb9]
	ld b, a
	ld a, [$ffb6]
	ld [$ffbc], a
	cp b
	jr nc, .asm_c616
	ld a, [$ffb5]
	and a
	jr nz, .asm_c611
	ld a, [$ffb4]
	and a
	jr z, .asm_c61c
	dec a
	ld [$ffb4], a
	xor a
.asm_c611
	dec a
	ld [$ffb5], a
	ld a, [$ffb6]
.asm_c616
	sub b
	ld [$ffb6], a
	inc c
	jr .asm_c5d4

.asm_c61c
	ld a, [$ffbb]
	ld [$ffb5], a
.asm_c620
	ld a, [$ffba]
	ld [$ffb4], a
.asm_c624
	ld a, [$ffb3]
	or c
	jr z, .PrintLeadingZero
	ld a, [$ffb3]
	and a
	jr nz, .asm_c637
	bit 5, d
	jr z, .asm_c637
	ld a, $f0
	ld [hli], a
	res 5, d
.asm_c637
	ld a, "0"
	add c
	ld [hl], a
	ld [$ffb3], a
	inc e
	dec e
	ret nz
	inc hl
	ld [hl], $f2
	ret

.PrintLeadingZero: ; c644
; prints a leading zero unless they are turned off in the flags

	bit 7, d ; print leading zeroes?
	ret z
	ld [hl], "0"
	ret

.AdvancePointer: ; c64a
; increments the pointer unless leading zeroes are not being printed,
; the number is left-aligned, and no nonzero digits have been printed yet

	bit 7, d ; print leading zeroes?
	jr nz, .inc
	bit 6, d ; left alignment or right alignment?
	jr z, .inc
	ld a, [$ffb3]
	and a
	ret z
.inc
	inc hl
	ret
; c658

HealParty: ; c658
	xor a
	ld [CurPartyMon], a
	ld hl, PartySpecies
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp EGG
	jr z, .next
	push hl
	call Functionc677
	pop hl
.next
	ld a, [CurPartyMon]
	inc a
	ld [CurPartyMon], a
	jr .loop

.done
	ret
; c677

Functionc677: ; c677
	ld a, PartyMon1Species - PartyMon1
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld hl, PartyMon1Status - PartyMon1Species
	add hl, de
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, PartyMon1MaxHP - PartyMon1Species
	add hl, de
	; bc = PartyMon1HP - PartyMon1Species
	ld b, h
	ld c, l
	dec bc
	dec bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a
	callba Functionf8b9
	ret
; c699

Functionc699: ; c699
	ld a, b
	or c
	jr z, .asm_c6dd
	push hl
	xor a
	ld [hMultiplicand], a
	ld a, b
	ld [$ffb5], a
	ld a, c
	ld [$ffb6], a
	ld a, $30
	ld [hMultiplier], a
	call Multiply
	ld a, d
	and a
	jr z, .asm_c6cc
	srl d
	rr e
	srl d
	rr e
	ld a, [$ffb5]
	ld b, a
	ld a, [$ffb6]
	srl b
	rr a
	srl b
	rr a
	ld [$ffb6], a
	ld a, b
	ld [$ffb5], a
.asm_c6cc
	ld a, e
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [$ffb6]
	ld e, a
	pop hl
	and a
	ret nz
	ld e, $1
	ret

.asm_c6dd
	ld e, $0
	ret
; c6e0

Predef_HPBarAnim: ; c6e0
	call WaitBGMap
	call Functiond627
	call WaitBGMap
	ret
; c6ea

Functionc6ea: ; c6ea
	xor a
	ld hl, Buffer1
	ld bc, $0007
	call ByteFill
	ret
; c6f5

Functionc6f5: ; c6f5
	ld a, [Buffer1]
	rst JumpTable
	ld [Buffer1], a
	bit 7, a
	jr nz, .asm_c702
	and a
	ret

.asm_c702
	and $7f
	scf
	ret
; c706

GetPartyNick: ; c706
; write CurPartyMon nickname to StringBuffer1-3

	ld hl, PartyMonNicknames
	ld a, BOXMON
	ld [MonType], a
	ld a, [CurPartyMon]
	call GetNick
	call CopyName1
; copy text from StringBuffer2 to StringBuffer3

	ld de, StringBuffer2
	ld hl, StringBuffer3
	call CopyName2
	ret
; c721

CheckEngineFlag: ; c721
; Check engine flag de
; Return carry if flag is not set

	ld b, CHECK_FLAG
	callba EngineFlagAction
	ld a, c
	and a
	jr nz, .isset
	scf
	ret

.isset
	xor a
	ret
; c731

CheckBadge: ; c731
; Check engine flag a (ENGINE_ZEPHYRBADGE thru ENGINE_EARTHBADGE)
; Display "Badge required" text and return carry if the badge is not owned

	call CheckEngineFlag
	ret nc
	ld hl, BadgeRequiredText
	call Function1d67 ; push text to queue
	scf
	ret
; c73d

BadgeRequiredText: ; c73d
	; Sorry! A new BADGE
	; is required.
	TX_FAR _BadgeRequiredText
	db "@"
; c742

CheckPartyMove: ; c742
; Check if a monster in your party has move d.

	ld e, 0
	xor a
	ld [CurPartyMon], a
.loop
	ld c, e
	ld b, 0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	and a
	jr z, .no
	cp a, $ff
	jr z, .no
	cp a, EGG
	jr z, .next
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Moves
	ld a, e
	call AddNTimes
	ld b, NUM_MOVES
.check
	ld a, [hli]
	cp d
	jr z, .yes
	dec b
	jr nz, .check
.next
	inc e
	jr .loop

.yes
	ld a, e
	ld [CurPartyMon], a ; which mon has the move
	xor a
	ret

.no
	scf
	ret
; c779

FieldMovePokepicScript:
	copybytetovar wd1ef
	refreshscreen $0
	pokepic $0000
	cry $0000
	waitsfx
	closepokepic
	reloadmappart
	end

Functionc779: ; c779
	ld hl, UnknownText_0xc780
	call Function1d67
	ret
; c780

UnknownText_0xc780: ; 0xc780
	text_jump UnknownText_0x1c05c8
	db "@"
; 0xc785

Functionc785: ; c785
	call Functionc6ea
.loop
	ld hl, Jumptable_c796
	call Functionc6f5
	jr nc, .loop
	and $7f
	ld [wd0ec], a
	ret
; c796

Jumptable_c796: ; c796 (3:4796)
	dw Functionc79c
	dw Functionc7b2
	dw Functionc7bb

Functionc79c: ; c79c (3:479c)
	ld de, ENGINE_HIVEBADGE
	call CheckBadge
	jr c, .asm_c7ac
	call Functionc7ce
	jr c, .asm_c7af
	ld a, $1
	ret

.asm_c7ac
	ld a, $80
	ret

.asm_c7af
	ld a, $2
	ret

Functionc7b2: ; c7b2 (3:47b2)
	ld hl, UnknownScript_0xc7fe
	call QueueScript
	ld a, $81
	ret

Functionc7bb: ; c7bb (3:47bb)
	ld hl, UnknownText_0xc7c9
	call Function1d67
	ld a, $80
	ret

UnknownText_0xc7c4: ; 0xc7c4
	; used CUT!
	text_jump UnknownText_0x1c05dd
	db "@"
; 0xc7c9

UnknownText_0xc7c9: ; 0xc7c9
	; There's nothing to CUT here.
	text_jump UnknownText_0x1c05ec
	db "@"
; 0xc7ce

Functionc7ce: ; c7ce
	call GetFacingTileCoord
	ld c, a
	push de
	callba Function149f5
	pop de
	jr nc, .asm_c7fc
	call Function2a66
	ld c, [hl]
	push hl
	ld hl, Unknown_c862
	call Functionc840
	pop hl
	jr nc, .asm_c7fc
	ld a, l
	ld [wd1ec], a
	ld a, h
	ld [wd1ed], a
	ld a, b
	ld [wd1ee], a
	ld a, c
	ld [wd1f0], a
	xor a
	ret

.asm_c7fc
	scf
	ret
; c7fe

UnknownScript_0xc7fe: ; c7fe
	reloadmappart
	special UpdateTimePals
UnknownScript_0xc802: ; 0xc802 CUT
	callasm Functioncd1d
	writetext UnknownText_0xc7c4
	closetext
	copybytetovar wd1ef
	refreshscreen $0
	pokepic $0000
	cry $0000
	closepokepic
	callasm Functionc810
	closetext
	end
; 0xc810

Functionc810: ; c810
	ld hl, wd1ec
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd1ee]
	ld [hl], a
	xor a
	ld [hBGMapMode], a
	call Function2173
	call Function1ad2
	call DelayFrame
	ld a, [wd1f0]
	ld e, a
	callba Function8c940
	call Function2879
	call Function2914
	call Function1ad2
	call DelayFrame
	call Functione51
	ret
; c840

Functionc840: ; c840
	push bc
	ld a, [wd199]
	ld de, 3
	call IsInArray
	pop bc
	jr nc, .asm_c860
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, 3
	ld a, c
	call IsInArray
	jr nc, .asm_c860
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	scf
	ret

.asm_c860
	xor a
	ret
; c862

Unknown_c862: ; c862
	dbw $01, Unknown_c872
	dbw $02, Unknown_c882
	dbw $03, Unknown_c886
	dbw $19, Unknown_c899
	dbw $1f, Unknown_c8a0
	db -1
; c872

Unknown_c872: ; c872
	db $03, $02, $01
	db $5b, $3c, $00
	db $5f, $3d, $00
	db $63, $3f, $00
	db $67, $3e, $00
	db -1
; c882

Unknown_c882: ; c882
	db $03, $02, $01
	db -1
; c886

Unknown_c886: ; c886
	db $0b, $0a, $01
	db $32, $6d, $00
	db $33, $6c, $00
	db $34, $6f, $00
	db $35, $4c, $00
	db $60, $6e, $00
	db -1
; c899

Unknown_c899: ; c899
	db $13, $03, $01
	db $03, $04, $01
	db -1
; c8a0

Unknown_c8a0: ; c8a0
	db $0f, $17, $00
	db -1
; c8a4

Unknown_c8a4: ; c8a4
	dbw $01, Unknown_c8a8
	db -1
; c8a8

Unknown_c8a8: ; c8a8
	db $07, $36, $00
	db -1
; c8ac

Functionc8ac: ; c8ac
	call Functionc8b5
	and $7f
	ld [wd0ec], a
	ret
; c8b5

Functionc8b5: ; c8b5
; Flash

	ld de, ENGINE_STORMBADGE
	callba CheckBadge
	jr c, .asm_c8dd
	push hl
	callba Function8ae30
	pop hl
	jr c, .asm_c8d1
	ld a, [wd847]
	cp $ff
	jr nz, .asm_c8d7
.asm_c8d1
	call Functionc8e0
	ld a, $81
	ret

.asm_c8d7
	call Functionc779
	ld a, $80
	ret

.asm_c8dd
	ld a, $80
	ret
; c8e0

Functionc8e0: ; c8e0
	ld hl, UnknownScript_0xc8e6
	jp QueueScript
; c8e6

UnknownScript_0xc8e6: ; 0xc8e6 FLASH
	reloadmappart
	callasm Functioncd1d
	copybytetovar wd1ef
	cry $0000
	special UpdateTimePals
	loadfont
	writetext UnknownText_0xc8f3
	callasm Function8c7e1
	closetext
	end
; 0xc8f3

UnknownText_0xc8f3: ; 0xc8f3
	text_jump UnknownText_0x1c0609
	start_asm
; 0xc8f8

Functionc8f8: ; c8f8
	call WaitSFX
	ld de, SFX_FLASH
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0xc908
	ret
; c908

UnknownText_0xc908: ; 0xc908
	db "@"
; 0xc909

Functionc909: ; c909
	call Functionc6ea
.asm_c90c
	ld hl, Jumptable_c91a
	call Functionc6f5
	jr nc, .asm_c90c
	and $7f
	ld [wd0ec], a
	ret
; c91a

Jumptable_c91a: ; c91a (3:491a)
	dw Functionc922
	dw Functionc95f
	dw Functionc971
	dw Functionc97a

Functionc922: ; c922 (3:4922)
	ld de, ENGINE_FOGBADGE
	call CheckBadge
	jr c, .asm_c956
	ld hl, BikeFlags
	bit 1, [hl] ; always on bike
	jr nz, .asm_c95c
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, .asm_c959
	cp PLAYER_SURF_PIKA
	jr z, .asm_c959
	call GetFacingTileCoord
	call GetTileCollision
	cp $1
	jr nz, .asm_c95c
	call CheckDirection
	jr c, .asm_c95c
	callba CheckFacingObject
	jr c, .asm_c95c
	ld a, $1
	ret

.asm_c956
	ld a, $80
	ret

.asm_c959
	ld a, $3
	ret

.asm_c95c
	ld a, $2
	ret

Functionc95f: ; c95f (3:495f)
	call GetSurfType
	ld [Buffer2], a ; wd1eb (aliases: MovementType)
	call GetPartyNick
	ld hl, UnknownScript_0xc983
	call QueueScript
	ld a, $81
	ret

Functionc971: ; c971 (3:4971)
	ld hl, CantSurfText
	call Function1d67
	ld a, $80
	ret

Functionc97a: ; c97a (3:497a)
	ld hl, AlreadySurfingText
	call Function1d67
	ld a, $80
	ret
; c983 (3:4983)

UnknownScript_0xc983: ; c983
	special UpdateTimePals
UsedSurfScript: ; c986 SURF
	callasm Functioncd1d
	writetext UsedSurfText ; "used SURF!"
	waitbutton
	closetext
	scall FieldMovePokepicScript
	copybytetovar Buffer2
	writevarcode VAR_MOVEMENT
	pause 2
	special Functione4a
	special PlayMapMusic
	special Function8379 ; (slow_step_x, step_end)
	applymovement 0, MovementBuffer ; PLAYER, MovementBuffer
	end
; c9a2

UsedSurfText: ; c9a9
	TX_FAR _UsedSurfText
	db "@"
; c9ae

CantSurfText: ; c9ae
	TX_FAR _CantSurfText
	db "@"
; c9b3

AlreadySurfingText: ; c9b3
	TX_FAR _AlreadySurfingText
	db "@"
; c9b8

GetSurfType: ; c9b8
; Surfing on Pikachu uses an alternate sprite.
; This is done by using a separate movement type.

	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	cp PIKACHU
	ld a, PLAYER_SURF_PIKA
	ret z
	ld a, PLAYER_SURF
	ret
; c9cb

CheckDirection: ; c9cb
; Return carry if a tile permission prevents you
; from moving in the direction you're facing.
; Get player direction

	ld a, [PlayerDirection]
	and a, %00001100 ; bits 2 and 3 contain direction
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, .Directions
	add hl, de
; Can you walk in this direction?

	ld a, [TilePermissions]
	and [hl]
	jr nz, .quit
	xor a
	ret

.quit
	scf
	ret

.Directions
	db FACE_DOWN
	db FACE_UP
	db FACE_LEFT
	db FACE_RIGHT
; c9e7

TrySurfOW:: ; c9e7
; Checking a tile in the overworld.
; Return carry if surfing is allowed.
; Don't ask to surf if already surfing.

	ld a, [PlayerState]
	cp PLAYER_SURF_PIKA
	jr z, .quit
	cp PLAYER_SURF
	jr z, .quit
; Must be facing water.

	ld a, [EngineBuffer1]
	call GetTileCollision
	cp 1 ; surfable
	jr nz, .quit
; Check tile permissions.

	call CheckDirection
	jr c, .quit
	ld de, ENGINE_FOGBADGE
	call CheckEngineFlag
	jr c, .print_message
	ld d, SURF
	call CheckPartyMove
	jr c, .print_message
	ld hl, BikeFlags
	bit 1, [hl] ; always on bike (can't surf)
	jr nz, .quit
	call GetSurfType
	ld [MovementType], a
	call GetPartyNick
	; call Functioncd1d
	ld a, BANK(AskSurfScript)
	ld hl, AskSurfScript
	call CallScript
	scf
	ret
.print_message
	ld a, BANK(.LovelyWaterScript)
	ld hl, .LovelyWaterScript
	call CallScript
	scf
	ret

.quit
	xor a
	ret
; ca2c
.LovelyWaterScript
	loadfont
	writetext .LovelyWaterText
	waitbutton
	closetext
	end

.LovelyWaterText:
	TX_FAR _LovelyWaterText
	db "@"

AskSurfScript: ; ca2c
	loadfont
	writetext AskSurfText
	yesorno
	iftrue UsedSurfScript
	closetext
	end
; ca36

AskSurfText: ; ca36
	TX_FAR _AskSurfText ; The water is calm.
	db "@"              ; Want to SURF?
; ca3b

Functionca3b: ; ca3b
	call Functionc6ea
.asm_ca3e
	ld hl, .data_ca4c
	call Functionc6f5
	jr nc, .asm_ca3e
	and $7f
	ld [wd0ec], a
	ret
; ca4c

.data_ca4c
 	dw Functionca52
 	dw Functionca94
 	dw Functionca9d
; ca52

Functionca52: ; ca52
; Fly

	ld de, ENGINE_ZEPHYRBADGE
	call CheckBadge
	jr c, .asm_ca85
	call GetMapPermission
	call CheckOutdoorMap
	jr nz, .indoors
	call CheckVermilionPort
	jr c, .indoors
	xor a
	ld [$ffde], a
	call Function1d6e
	call ClearSprites
	callba Function91af3
	ld a, e
	cp -1
	jr z, .asm_ca8b
	cp $1c ; NUM_SPAWNS
	jr nc, .asm_ca8b
	ld [wd001], a
	call Function1c17
	ld a, $1
	ret

.asm_ca85
	ld a, $82
	ret

.indoors
	ld a, $2
	ret

.asm_ca8b
	call Function1c17
	call WaitBGMap
	ld a, $80
	ret
; ca94

CheckVermilionPort:
	ld a, [MapGroup]
	cp GROUP_VERMILION_PORT
	jr nz, .nope
	ld a, [MapNumber]
	cp MAP_VERMILION_PORT
	jr nz, .nope
	ld a, [VisitedSpawns]
	bit 7, a
	jr nz, .nope
	scf
	ret
.nope
	xor a
	ret

Functionca94: ; ca94
	ld hl, UnknownScript_0xcaa3
	call QueueScript
	ld a, $81
	ret
; ca9d

Functionca9d: ; ca9d
	call Functionc779
	ld a, $82
	ret
; caa3

UnknownScript_0xcaa3: ; 0xcaa3 FLY
	reloadmappart
	callasm HideSprites
	special UpdateTimePals
	callasm Functioncd1d
	scall FieldMovePokepicScript
	callasm Function8caed
	farscall UnknownScript_0x122c1
	special Function97c28
	callasm Function154f1
	writecode VAR_MOVEMENT, $0
	newloadmap $fc
	callasm Function8cb33
	special WaitSFX
	callasm Functioncacb
	end
; 0xcacb

Functioncacb: ; cacb
	callba Function561d
	call DelayFrame
	call Functione4a
	callba Function106594
	ret
; cade

Functioncade: ; cade
	call Functioncae7
	and $7f
	ld [wd0ec], a
	ret
; cae7

Functioncae7: ; cae7
; Waterfall

	ld de, ENGINE_RISINGBADGE
	callba CheckBadge
	ld a, $80
	ret c
	call Functioncb07
	jr c, .asm_cb01
	ld hl, UnknownScript_0xcb1c
	call QueueScript
	ld a, $81
	ret

.asm_cb01
	call Functionc779
	ld a, $80
	ret
; cb07

Functioncb07: ; cb07
	ld a, [PlayerDirection]
	and $c
	cp FACE_UP
	jr nz, .asm_cb1a
	ld a, [TileUp]
	call CheckWaterfallTile
	jr nz, .asm_cb1a
	xor a
	ret

.asm_cb1a
	scf
	ret
; cb1c

UnknownScript_0xcb1c: ; 0xcb1c
	reloadmappart
	special UpdateTimePals
UnknownScript_0xcb20: ; 0xcb20 WATERFALL
	callasm Functioncd1d
	writetext UnknownText_0xcb51
	waitbutton
	closetext
	scall FieldMovePokepicScript
	playsound SFX_BUBBLEBEAM
.loop
	applymovement $0, WaterfallStep
	callasm Functioncb38
	iffalse .loop
	end
; 0xcb38

Functioncb38: ; cb38
	xor a
	ld [ScriptVar], a
	ld a, [StandingTile]
	call CheckWaterfallTile
	ret z
	callba Function1060c1
	ld a, $1
	ld [ScriptVar], a
	ret
; cb4f

WaterfallStep: ; cb4f
	turn_waterfall_up
	step_end
; cb51

UnknownText_0xcb51: ; 0xcb51
	text_jump UnknownText_0x1c068e
	db "@"
; 0xcb56

TryWaterfallOW:: ; cb56
	ld d, WATERFALL
	call CheckPartyMove
	jr c, .asm_cb74
	ld de, ENGINE_RISINGBADGE
	call CheckEngineFlag
	jr c, .asm_cb74
	call Functioncb07
	jr c, .asm_cb74
	ld a, BANK(UnknownScript_0xcb86)
	ld hl, UnknownScript_0xcb86
	call CallScript
	scf
	ret

.asm_cb74
	ld a, BANK(UnknownScript_0xcb7e)
	ld hl, UnknownScript_0xcb7e
	call CallScript
	scf
	ret
; cb7e

UnknownScript_0xcb7e: ; 0xcb7e
	jumptext UnknownText_0xcb81
; 0xcb81

UnknownText_0xcb81: ; 0xcb81
	text_jump UnknownText_0x1c06a3
	db "@"
; 0xcb86

UnknownScript_0xcb86: ; 0xcb86
	loadfont
	writetext UnknownText_0xcb90
	yesorno
	iftrue UnknownScript_0xcb20
	closetext
	end
; 0xcb90

UnknownText_0xcb90: ; 0xcb90
	text_jump UnknownText_0x1c06bf
	db "@"
; 0xcb95

Functioncb95: ; cb95
	call Functionc6ea
	ld a, $1
	jr asm_cba1

Functioncb9c: ; cb9c
	call Functionc6ea
	ld a, $2
asm_cba1
	ld [Buffer2], a
.asm_cba4
	ld hl, Tablecbb2
	call Functionc6f5
	jr nc, .asm_cba4
	and $7f
	ld [wd0ec], a
	ret
; cbb2

Tablecbb2: ; cbb2
	dw Functioncbb8
	dw Functioncbd8
	dw Functioncc06
; cbb8

Functioncbb8: ; cbb8
	call GetMapPermission
	cp $4
	jr z, .asm_cbc6
	cp $7
	jr z, .asm_cbc6
.asm_cbc3
	ld a, $2
	ret

.asm_cbc6
	ld hl, wdca9
	ld a, [hli]
	and a
	jr z, .asm_cbc3
	ld a, [hli]
	and a
	jr z, .asm_cbc3
	ld a, [hl]
	and a
	jr z, .asm_cbc3
	ld a, $1
	ret
; cbd8

Functioncbd8: ; cbd8
	ld hl, wdca9
	ld de, wd146
	ld bc, $0003
	call CopyBytes
	call GetPartyNick
	ld a, [Buffer2]
	cp $2
	jr nz, .asm_cbf7
	ld hl, UnknownScript_0xcc35
	call QueueScript
	ld a, $81
	ret

.asm_cbf7
	callba Function8ae4e
	ld hl, UnknownScript_0xcc2b
	call QueueScript
	ld a, $81
	ret
; cc06

Functioncc06: ; cc06
	ld a, [Buffer2]
	cp $2
	jr nz, .asm_cc19
	ld hl, UnknownText_0xcc26
	call Function1d4f
	call Functiona80
	call Function1c17
.asm_cc19
	ld a, $80
	ret
; cc1c

UnknownText_0xcc1c: ; 0xcc1c
	; used DIG!
	text_jump UnknownText_0x1c06de
	db "@"
; 0xcc21

UnknownText_0xcc21: ; 0xcc21
	; used an ESCAPE ROPE.
	text_jump UnknownText_0x1c06ed
	db "@"
; 0xcc26

UnknownText_0xcc26: ; 0xcc26
	; Can't use that here.
	text_jump UnknownText_0x1c0705
	db "@"
; 0xcc2b

UnknownScript_0xcc2b: ; 0xcc2b
	reloadmappart
	special UpdateTimePals
	writetext UnknownText_0xcc21
	waitbutton
	closetext
	jump UnknownScript_0xcc3c
; 0xcc35

UnknownScript_0xcc35: ; 0xcc35 DIG
	reloadmappart
	special UpdateTimePals
	callasm Functioncd1d
	writetext UnknownText_0xcc1c
	waitbutton
	closetext
	scall FieldMovePokepicScript
UnknownScript_0xcc3c: ; 0xcc3c
	playsound SFX_WARP_TO
	applymovement $0, MovementData_0xcc59
	farscall UnknownScript_0x122c1
	special Function97c28
	writecode VAR_MOVEMENT, $0
	newloadmap $f5
	playsound SFX_WARP_FROM
	applymovement $0, MovementData_0xcc5d
	end
; 0xcc59

MovementData_0xcc59: ; 0xcc59
	step_wait5
	turn_away_down
	hide_person
	step_end
; 0xcc5d

MovementData_0xcc5d: ; 0xcc5d
	db $3c, $58
	turn_away_down
	step_end
; 0xcc61

Functioncc61: ; cc61
; Teleport
	call Functionc6ea
.asm_cc64
	ld hl, Tablecc72
	call Functionc6f5
	jr nc, .asm_cc64
	and $7f
	ld [wd0ec], a
	ret
; cc72

Tablecc72: ; cc72
	dw Functioncc78
	dw Functioncc9c
	dw Functioncca8
; cc78

Functioncc78: ; cc78
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .asm_cc82 ; outdoors
	jr .asm_cc99

.asm_cc82
	ld a, [wdcb2]
	ld d, a
	ld a, [wdcb3]
	ld e, a
	callba IsSpawnPoint
	jr nc, .asm_cc99
	ld a, c
	ld [wd001], a
	ld a, $1
	ret

.asm_cc99
	ld a, $2
	ret
; cc9c

Functioncc9c: ; cc9c
	call GetPartyNick
	ld hl, UnknownScript_0xccbb
	call QueueScript
	ld a, $81
	ret
; cca8

Functioncca8: ; cca8
	ld hl, UnknownText_0xccb6
	call Function1d67
	ld a, $80
	ret
; ccb1

UnknownText_0xccb1: ; 0xccb1
	; Return to the last #MON CENTER.
	text_jump UnknownText_0x1c071a
	db "@"
; 0xccb6

UnknownText_0xccb6: ; 0xccb6
	; Can't use that here.
	text_jump UnknownText_0x1c073b
	db "@"
; 0xccbb

UnknownScript_0xccbb: ; 0xccbb
	reloadmappart
	special UpdateTimePals
	writetext UnknownText_0xccb1
	pause 60
	reloadmappart
	closetext
	playsound SFX_WARP_TO
	applymovement $0, MovementData_0xcce1
	farscall UnknownScript_0x122c1
	special Function97c28
	writecode VAR_MOVEMENT, $0
	newloadmap $f4
	playsound SFX_WARP_FROM
	applymovement $0, MovementData_0xcce3
	end
; 0xcce1

MovementData_0xcce1: ; cce1
	teleport_from
	step_end
; cce3

MovementData_0xcce3: ; cce3
	teleport_to
	step_end
; cce5

Functioncce5: ; cce5
	call Functionccee
	and $7f
	ld [wd0ec], a
	ret
; ccee

Functionccee: ; ccee
; Strength

	ld de, ENGINE_PLAINBADGE
	call CheckBadge
	jr c, Functioncd06
	jr Functioncd09
; ccf8

Functionccf8: ; ccf8
	ld hl, UnknownText_0xcd01
	call Function1d67
	ld a, $80
	ret
; cd01

UnknownText_0xcd01: ; 0xcd01
	text_jump UnknownText_0x1c0751
	db "@"
; 0xcd06

Functioncd06: ; cd06
	ld a, $80
	ret
; cd09

Functioncd09: ; cd09
	ld hl, UnknownScript_0xcd29
	call QueueScript
	ld a, $81
	ret
; cd12

Functioncd12: ; cd12
	ld hl, BikeFlags
	set 0, [hl]
Functioncd1d: ; cd1d
	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	ld [wd1ef], a
	call GetPartyNick
	ret
; cd29

UnknownScript_0xcd29: ; 0xcd29
	reloadmappart
	special UpdateTimePals
UnknownScript_0xcd2d: ; 0xcd2d STRENGTH
	callasm Functioncd12
	writetext UnknownText_0xcd41
	waitbutton
	closetext
	scall FieldMovePokepicScript
	loadfont
	writetext UnknownText_0xcd46
	closetext
	end
; 0xcd41

UnknownText_0xcd41: ; 0xcd41
	text_jump UnknownText_0x1c0774
	db $50
; 0xcd46

UnknownText_0xcd46: ; 0xcd46
	text_jump UnknownText_0x1c0788
	db $50
; 0xcd4b

UnknownScript_0xcd4b: ; 0xcd4b
	callasm Functioncd78
	iffalse UnknownScript_0xcd5f
	if_equal $1, UnknownScript_0xcd59
	jump UnknownScript_0xcd5c
; 0xcd59

UnknownScript_0xcd59: ; 0xcd59
	jumptext UnknownText_0xcd73
; 0xcd5c

UnknownScript_0xcd5c: ; 0xcd5c
	jumptext UnknownText_0xcd6e
; 0xcd5f

UnknownScript_0xcd5f: ; 0xcd5f
	loadfont
	writetext UnknownText_0xcd69
	yesorno
	iftrue UnknownScript_0xcd2d
	closetext
	end
; 0xcd69

UnknownText_0xcd69: ; 0xcd69
	; A #MON may be able to move this. Want to use STRENGTH?
	text_jump UnknownText_0x1c07a0
	db "@"
; 0xcd6e

UnknownText_0xcd6e: ; 0xcd6e
	; Boulders may now be moved!
	text_jump UnknownText_0x1c07d8
	db "@"
; 0xcd73

UnknownText_0xcd73: ; 0xcd73
	; A #MON may be able to move this.
	text_jump UnknownText_0x1c07f4
	db "@"
; 0xcd78

Functioncd78: ; cd78
	ld d, STRENGTH
	call CheckPartyMove
	jr c, .asm_cd92
	ld de, ENGINE_PLAINBADGE
	call CheckEngineFlag
	jr c, .asm_cd92
	ld hl, BikeFlags
	bit 0, [hl]
	jr z, .asm_cd96
	ld a, 2
	jr .asm_cd99

.asm_cd92
	ld a, 1
	jr .asm_cd99

.asm_cd96
	xor a
	jr .asm_cd99

.asm_cd99
	ld [ScriptVar], a
	ret
; cd9d

Functioncd9d: ; cd9d
	call Functionc6ea
.asm_cda0
	ld hl, Jumptable_cdae
	call Functionc6f5
	jr nc, .asm_cda0
	and $7f
	ld [wd0ec], a
	ret
; cdae

Jumptable_cdae: ; cdae
	dw Functioncdb4
	dw Functioncdca
	dw Functioncdd3
; cdb4

Functioncdb4: ; cdb4
	ld de, ENGINE_GLACIERBADGE
	call CheckBadge
	jr c, .asm_cdc7
	call Functioncdde
	jr c, .asm_cdc4
	ld a, $1
	ret

.asm_cdc4
	ld a, $2
	ret

.asm_cdc7
	ld a, $80
	ret
; cdca

Functioncdca: ; cdca
	ld hl, UnknownScript_0xce0b
	call QueueScript
	ld a, $81
	ret
; cdd3

Functioncdd3: ; cdd3
	call Functionc779
	ld a, $80
	ret
; cdd9

UnknownText_0xcdd9: ; 0xcdd9
	; used WHIRLPOOL!
	text_jump UnknownText_0x1c0816
	db "@"
; 0xcdde

Functioncdde: ; cdde
	call GetFacingTileCoord
	ld c, a
	push de
	call CheckWhirlpoolTile
	pop de
	jr c, .asm_ce09
	call Function2a66
	ld c, [hl]
	push hl
	ld hl, Unknown_c8a4
	call Functionc840
	pop hl
	jr nc, .asm_ce09
	ld a, l
	ld [wd1ec], a
	ld a, h
	ld [wd1ed], a
	ld a, b
	ld [wd1ee], a
	ld a, c
	ld [wd1ef], a
	xor a
	ret

.asm_ce09
	scf
	ret
; ce0b

UnknownScript_0xce0b: ; 0xce0b
	reloadmappart
	special UpdateTimePals
UnknownScript_0xce0f: ; 0xce0f WHIRLPOOL
	callasm Functioncd1d
	writetext UnknownText_0xcdd9
	closetext
	scall FieldMovePokepicScript
	callasm Functionce1d
	closetext
	end
; 0xce1d

Functionce1d: ; ce1d
	ld hl, wd1ec
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd1ee]
	ld [hl], a
	xor a
	ld [hBGMapMode], a
	call Function2173
	ld a, [wd1ef]
	ld e, a
	callba Function8c7d4
	call Function2879
	call Function2914
	ret
; ce3e

TryWhirlpoolOW:: ; ce3e
	ld d, WHIRLPOOL
	call CheckPartyMove
	jr c, .asm_ce5c
	ld de, ENGINE_GLACIERBADGE
	call CheckEngineFlag
	jr c, .asm_ce5c
	call Functioncdde
	jr c, .asm_ce5c
	ld a, BANK(UnknownScript_0xce6e)
	ld hl, UnknownScript_0xce6e
	call CallScript
	scf
	ret

.asm_ce5c
	ld a, BANK(UnknownScript_0xce66)
	ld hl, UnknownScript_0xce66
	call CallScript
	scf
	ret
; ce66

UnknownScript_0xce66: ; 0xce66
	jumptext UnknownText_0xce69
; 0xce69

UnknownText_0xce69: ; 0xce69
	text_jump UnknownText_0x1c082b
	db "@"
; 0xce6e

UnknownScript_0xce6e: ; 0xce6e
	loadfont
	writetext UnknownText_0xce78
	yesorno
	iftrue UnknownScript_0xce0f
	closetext
	end
; 0xce78

UnknownText_0xce78: ; 0xce78
	text_jump UnknownText_0x1c0864
	db "@"
; 0xce7d

Functionce7d: ; ce7d
	call Functionce86
	and $7f
	ld [wd0ec], a
	ret
; ce86

Functionce86: ; ce86
	call GetFacingTileCoord
	call CheckHeadbuttTreeTile
	jr nz, .no_tree
	ld hl, HeadbuttFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_tree
	call Functionc779
	ld a, $80
	ret
; ce9d

UnknownText_0xce9d: ; 0xce9d
	; did a HEADBUTT!
	text_jump UnknownText_0x1c0897
	db "@"
; 0xcea2

UnknownText_0xcea2: ; 0xcea2
	; Nope. Nothing<...>
	text_jump UnknownText_0x1c08ac
	db "@"
; 0xcea7

HeadbuttFromMenuScript: ; 0xcea7
	reloadmappart
	special UpdateTimePals
HeadbuttScript: ; 0xceab HEADBUTT
	callasm Functioncd1d
	writetext UnknownText_0xce9d
	closetext
	scall FieldMovePokepicScript
	callasm ShakeHeadbuttTree
	callasm TreeMonEncounter
	iffalse .no_battle
	battlecheck
	startbattle
	returnafterbattle
	end
.no_battle
	loadfont
	writetext UnknownText_0xcea2
	waitbutton
	closetext
	end
; 0xcec9

TryHeadbuttOW:: ; cec9
	ld d, HEADBUTT
	call CheckPartyMove
	jr nc, .yes
	ld d, ZEN_HEADBUTT
	call CheckPartyMove
	jr c, .no
.yes
	ld a, BANK(AskHeadbuttScript)
	ld hl, AskHeadbuttScript
	call CallScript
	scf
	ret

.no
	xor a
	ret
; cedc

AskHeadbuttScript: ; 0xcedc
	loadfont
	writetext UnknownText_0xcee6
	yesorno
	iftrue HeadbuttScript
	closetext
	end
; 0xcee6

UnknownText_0xcee6: ; 0xcee6
	; A #MON could be in this tree. Want to HEADBUTT it?
	text_jump UnknownText_0x1c08bc
	db "@"
; 0xceeb

Functionceeb: ; ceeb
	call Functioncef4
	and $7f
	ld [wd0ec], a
	ret
; cef4

Functioncef4: ; cef4
	call Functioncf0d
	jr c, .no_rock
	ld a, d
	cp $18
	jr nz, .no_rock
	ld hl, RockSmashFromMenuScript
	call QueueScript
	ld a, $81
	ret

.no_rock
	call Functionc779
	ld a, $80
	ret
; cf0d

Functioncf0d: ; cf0d
	callba CheckFacingObject
	jr nc, .asm_cf2c
	ld a, [$ffb0]
	call Function1ae5
	ld hl, $0001
	add hl, bc
	ld a, [hl]
	ld [$ffe0], a
	call GetMapObject
	ld hl, $0004
	add hl, bc
	ld a, [hl]
	ld d, a
	and a
	ret

.asm_cf2c
	scf
	ret
; cf2e

RockSmashFromMenuScript: ; 0xcf2e
	reloadmappart
	special UpdateTimePals
RockSmashScript: ; cf32 ROCK SMASH
	callasm Functioncd1d
	writetext UnknownText_0xcf58
	closetext
	scall FieldMovePokepicScript
	playsound SFX_STRENGTH
	earthquake 84
	applymovement2 MovementData_0xcf55
	disappear $fe
	callasm RockMonEncounter
	copybytetovar wd22e
	iffalse .done
	battlecheck
	startbattle
	returnafterbattle
.done
	end
; 0xcf55

MovementData_0xcf55: ; 0xcf55
	db $57, $0a
	step_end
UnknownText_0xcf58: ; 0xcf58
	text_jump UnknownText_0x1c08f0
	db "@"
; 0xcf5d

AskRockSmashScript: ; 0xcf5d
	callasm HasRockSmash
	if_equal 1, .no
	loadfont
	writetext UnknownText_0xcf77
	yesorno
	iftrue RockSmashScript
	closetext
	end
.no
	jumptext UnknownText_0xcf72
; 0xcf72

UnknownText_0xcf72: ; 0xcf72
	; Maybe a #MON can break this.
	text_jump UnknownText_0x1c0906
	db "@"
; 0xcf77

UnknownText_0xcf77: ; 0xcf77
	; This rock looks breakable. Want to use ROCK SMASH?
	text_jump UnknownText_0x1c0924
	db "@"
; 0xcf7c

HasRockSmash: ; cf7c
	ld d, ROCK_SMASH
	call CheckPartyMove
	jr nc, .yes
.no
	ld a, 1
	jr .done

.yes
	xor a
	jr .done

.done
	ld [ScriptVar], a
	ret

Functioncf8e: ; cf8e
	ld a, e
	push af
	call Functionc6ea
	pop af
	ld [Buffer2], a
.asm_cf97
	ld hl, Jumptable_cfa5
	call Functionc6f5
	jr nc, .asm_cf97
	and $7f
	ld [wd0ec], a
	ret
; cfa5

Jumptable_cfa5: ; cfa5
	dw Functioncfaf
	dw Functiond002
	dw Functioncff4
	dw Functioncff1
	dw Functiond010
; cfaf

Functioncfaf: ; cfaf
	ld a, [PlayerState]
	cp PLAYER_SURF
	jr z, .asm_cfc4
	cp PLAYER_SURF_PIKA
	jr z, .asm_cfc4
	callba CheckAlivePartyMon
	jr nc, .asm_cfc4
	call GetFacingTileCoord
	call GetTileCollision
	cp $1
	jr z, .asm_cfc7
.asm_cfc4
	ld a, $3
	ret

.asm_cfc7
	call Function2d19  ;put fish group into a
	and a ;if encounter group is not zero, continue
	jr nz, .asm_cfd0
	ld a, $4
	ret

.asm_cfd0
	ld d, a ;d = encounter group
	ld a, [Buffer2]
	ld e, a ; e = rod type
	callba FishAction ;load mon nto d and level into e. 0 in both if fail to fish
	ld a, d
	and a
	jr z, .asm_cfee
	ld [wd22e], a
	ld a, e
	ld [CurPartyLevel], a
	ld a, BATTLETYPE_FISH
	ld [BattleType], a
	ld a, $2
	ret

.asm_cfee
	ld a, $1
	ret
; cff1

Functioncff1: ; cff1
	ld a, $80
	ret
; cff4

Functioncff4: ; cff4
	ld a, $1
	ld [wd1ef], a
	ld hl, UnknownScript_0xd035
	call QueueScript
	ld a, $81
	ret
; d002

Functiond002: ; d002
	ld a, $2
	ld [wd1ef], a
	ld hl, UnknownScript_0xd01e
	call QueueScript
	ld a, $81
	ret
; d010

Functiond010: ; d010
	ld a, $0
	ld [wd1ef], a
	ld hl, UnknownScript_0xd027
	call QueueScript
	ld a, $81
	ret
; d01e

UnknownScript_0xd01e: ; 0xd01e
	scall UnknownScript_0xd07c
	writetext UnknownText_0xd0a9
	jump UnknownScript_0xd02d
; 0xd027

UnknownScript_0xd027: ; 0xd027
	scall UnknownScript_0xd07c
	writetext UnknownText_0xd0a9
UnknownScript_0xd02d: ; 0xd02d
	loademote $8
	callasm Functiond095
	closetext
	end
; 0xd035

UnknownScript_0xd035: ; 0xd035
	scall UnknownScript_0xd07c
	callasm Functiond06c
	iffalse UnknownScript_0xd046
	applymovement $0, MovementData_0xd062
	jump UnknownScript_0xd04a
; 0xd046

UnknownScript_0xd046: ; 0xd046
	applymovement $0, MovementData_0xd05c
UnknownScript_0xd04a: ; 0xd04a
	pause 40
	applymovement $0, MovementData_0xd069
	writetext UnknownText_0xd0a4
	callasm Functiond095
	closetext
	battlecheck
	startbattle
	returnafterbattle
	end
; 0xd05c

MovementData_0xd05c: ; d05c
	db $51
	db $51
	db $51
	db $51
	show_emote
	step_end
; d062

MovementData_0xd062: ; d062
	db $51
	db $51
	db $51
	db $51
	show_person
	show_emote
	step_end
; d069

MovementData_0xd069: ; d069
	hide_emote
	db $52
	step_end
; d06c

Functiond06c: ; d06c
	ld a, [PlayerDirection]
	and $c
	cp $4
	ld a, $1
	jr z, .asm_d078
	xor a
.asm_d078
	ld [ScriptVar], a
	ret
; d07c

UnknownScript_0xd07c: ; 0xd07c
	reloadmappart
	loadvar $ffd4, $0
	special UpdateTimePals
	loademote $9
	callasm Functionb84b3
	loademote $0
	applymovement $0, MovementData_0xd093
	pause 40
	end
; 0xd093

MovementData_0xd093: ; d093
	db $52
	step_end
; d095

Functiond095: ; d095
	xor a
	ld [hBGMapMode], a
	ld a, $1
	ld [PlayerAction], a
	call Function1ad2
	call Functione4a
	ret
; d0a4

UnknownText_0xd0a4: ; 0xd0a4
	; Oh! A bite!
	text_jump UnknownText_0x1c0958
	db "@"
; 0xd0a9

UnknownText_0xd0a9: ; 0xd0a9
	; Not even a nibble!
	text_jump UnknownText_0x1c0965
	db "@"
; 0xd0ae

UnknownText_0xd0ae: ; 0xd0ae
	; Looks like there's nothing here.
	text_jump UnknownText_0x1c0979
	db "@"
; 0xd0b3

Functiond0b3: ; d0b3
	call Functiond0bc
	and $7f
	ld [wd0ec], a
	ret
; d0bc

Functiond0bc: ; d0bc
	call Functiond121
	jr c, .asm_d110
	ld a, [PlayerState]
	cp PLAYER_NORMAL
	jr z, .asm_d0ce
	cp PLAYER_BIKE
	jr z, .asm_d0f7
	jr .asm_d110

.asm_d0ce
	ld hl, UnknownScript_0xd13e
	ld de, UnknownScript_0xd14e
	call Functiond119
	call QueueScript
	ld a, [wMapMusic]
	cp MUSIC_VICTORY_ROAD
	jr z, .done
	xor a
	ld [MusicFade], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call MaxVolume
	ld de, MUSIC_BICYCLE
	ld a, e
	ld [wMapMusic], a
	call PlayMusic
.done
	ld a, $1
	ret

.asm_d0f7
	ld hl, BikeFlags
	bit 1, [hl]
	jr nz, .asm_d10b
	ld hl, UnknownScript_0xd158
	ld de, UnknownScript_0xd16b
	call Functiond119
	ld a, $3
	jr .asm_d113

.asm_d10b
	ld hl, UnknownScript_0xd171
	jr .asm_d113

.asm_d110
	ld a, $0
	ret

.asm_d113
	call QueueScript
	ld a, $1
	ret
; d119

Functiond119: ; d119
	ld a, [wd0ef]
	and a
	ret z
	ld h, d
	ld l, e
	ret
; d121

Functiond121: ; d121
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .asm_d133
	cp CAVE
	jr z, .asm_d133
	cp GATE
	jr z, .asm_d133
	jr .asm_d13c

.asm_d133
	call Function184a
	and $f
	jr nz, .asm_d13c
	xor a
	ret

.asm_d13c
	scf
	ret
; d13e

UnknownScript_0xd13e: ; 0xd13e
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, $1
	writetext UnknownText_0xd17c
	waitbutton
	closetext
	special Functione4a
	end
; 0xd14e

UnknownScript_0xd14e: ; 0xd14e
	writecode VAR_MOVEMENT, $1
	closetext
	special Functione4a
	end
; 0xd156

Functiond156: ; unreferenced
	nop
	ret

UnknownScript_0xd158: ; 0xd158
	reloadmappart
	special UpdateTimePals
	writecode VAR_MOVEMENT, $0
	writetext UnknownText_0xd181
	waitbutton
UnknownScript_0xd163:
	closetext
	special Functione4a
	special PlayMapMusic
	end
; 0xd16b

UnknownScript_0xd16b: ; 0xd16b
	writecode VAR_MOVEMENT, $0
	jump UnknownScript_0xd163
; 0xd171

UnknownScript_0xd171: ; 0xd171
	writetext UnknownText_0xd177
	waitbutton
	closetext
	end
; 0xd177

UnknownText_0xd177: ; 0xd177
	; You can't get off here!
	text_jump UnknownText_0x1c099a
	db "@"
; 0xd17c

UnknownText_0xd17c: ; 0xd17c
	; got on the @ .
	text_jump UnknownText_0x1c09b2
	db "@"
; 0xd181

UnknownText_0xd181: ; 0xd181
	; got off the @ .
	text_jump UnknownText_0x1c09c7
	db "@"
; 0xd186

TryCutOW:: ; d186
	ld d, CUT
	call CheckPartyMove
	jr c, .cant_cut
	ld de, ENGINE_HIVEBADGE
	call CheckEngineFlag
	jr c, .cant_cut
	ld a, BANK(AskCutScript)
	ld hl, AskCutScript
	call CallScript
	scf
	ret

.cant_cut
	ld a, BANK(CantCutScript)
	ld hl, CantCutScript
	call CallScript
	scf
	ret
; d1a9

AskCutScript: ; 0xd1a9
	loadfont
	writetext UnknownText_0xd1c8
	yesorno
	iffalse .script_d1b8
	callasm Functiond1ba
	iftrue UnknownScript_0xc802
.script_d1b8
	closetext
	end
; 0xd1ba

Functiond1ba: ; d1ba
	xor a
	ld [ScriptVar], a
	call Functionc7ce
	ret c
	ld a, 1
	ld [ScriptVar], a
	ret
; d1c8

UnknownText_0xd1c8: ; 0xd1c8
	text_jump UnknownText_0x1c09dd
	db "@"
; 0xd1cd

CantCutScript: ; 0xd1cd
	jumptext UnknownText_0xd1d0
; 0xd1d0

UnknownText_0xd1d0: ; 0xd1d0
	text_jump UnknownText_0x1c0a05
	db "@"
; 0xd1d5

_ReceiveItem:: ; d1d5
	call Functiond27b ;if hl = numitems, run additem function for main bag
	jp nz, Functiond29c ;insert item into main bag, ret c if succsessful
	push hl
	call CheckItemPocket ;poket to place in = wd142
	pop de
	ld a, [wd142]
	dec a
	ld hl, Tabled1e9
	rst JumpTable ;run function for appropriote pocket
	ret
; d1e9

Tabled1e9: ; d1e9
	dw Functiond1f1
	dw Functiond1f6
	dw Functiond1fb
	dw Functiond201
; d1f1

Functiond1f1: ; d1f1
	ld h, d
	ld l, e
	jp Functiond29c
; d1f6

Functiond1f6: ; d1f6
	ld h, d
	ld l, e
	jp Functiond35a
; d1fb

Functiond1fb: ; d1fb
	ld hl, NumBalls
	jp Functiond29c
; d201

Functiond201: ; d201
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3c4
; d20d

_TossItem:: ; d20d
	call Functiond27b
	jr nz, .asm_d241
	push hl
	call CheckItemPocket
	pop de
	ld a, [wd142]
	dec a
	ld hl, .data_d220
	rst JumpTable
	ret

.data_d220
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM
; d228

.Ball ; d228
	ld hl, NumBalls
	jp Functiond2ff
; d22e

.TMHM ; d22e
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3d8
; d23a

.KeyItem ; d23a
	ld h, d
	ld l, e
	jp Functiond374
; d23f

.Item ; d23f
	ld h, d
	ld l, e
; d241

.asm_d241
	jp Functiond2ff
; d244

_CheckItem:: ; d244
	call Functiond27b
	jr nz, .asm_d278
	push hl
	call CheckItemPocket ;poket to place in = wd142
	pop de
	ld a, [wd142]
	dec a
	ld hl, .data_d257
	rst JumpTable
	ret

.data_d257
	dw .Item
	dw .KeyItem
	dw .Ball
	dw .TMHM
; d25f

.Ball ; d25f
	ld hl, NumBalls
	jp Functiond349
; d265

.TMHM ; d265
	ld h, d
	ld l, e
	ld a, [CurItem]
	ld c, a
	call GetTMHMNumber
	jp Functiond3fb
; d271

.KeyItem ; d271
	ld h, d
	ld l, e
	jp Functiond3b1
; d276

.Item ; d276
	ld h, d
	ld l, e
; d278

.asm_d278
	jp Functiond349
; d27b

Functiond27b: ; d27b
	ld a, l
	cp NumItems % $100 ;if not equal to numitems / 256
	ret nz
	ld a, h
	cp NumItems / $100 ;num items / 256 instead
	ret
; d283

GetPocketCapacity: ; d283 c = max items in main bag if de = numItems, max item slots in PC if equal to PCItems, max item slots in ball bag otherwise
	ld c, MAX_ITEMS
	ld a, e
	cp NumItems % $100
	jr nz, .asm_d28e
	ld a, d
	cp NumItems / $100
	ret z
.asm_d28e
	ld c, MAX_PC_ITEMS
	ld a, e
	cp PCItems % $100
	jr nz, .asm_d299
	ld a, d
	cp PCItems / $100
	ret z
.asm_d299
	ld c, MAX_BALLS
	ret
; d29c

Functiond29c: ; d29c insert item curitem of quantity wd10c into bag hl, return c if succsessful
	ld d, h
	ld e, l
	inc hl ;hl = first item slot?
	ld a, [CurItem] ;c = item
	ld c, a
	ld b, 0
.asm_d2a5
	ld a, [hli] ;load item in that slot into a
	cp $ff
	jr z, .asm_d2bd ;if ff end of list, jump to check number of slots left in bag
	cp c ;if not same as item to place, next slot and try again
	jr nz, .asm_d2ba
	ld a, 99
	sub [hl] ;sub current quantity from 99 to make space left
	add b ; add previous space of this item type
	ld b, a ;load total space into b
	ld a, [wd10c] ;load in quantity to add
	cp b ;if quantity to add is less then or equal to space left, end loop
	jr z, .asm_d2c6 ;if space without taking up slots, skip slot checking
	jr c, .asm_d2c6
.asm_d2ba
	inc hl ;to next item and loop
	jr .asm_d2a5

.asm_d2bd
	call GetPocketCapacity ;get max item slots, put in c
	ld a, [de] ;load current item slots used into a
	cp c
	jr c, .asm_d2c6 ; proceed if bag not full, else ret nc
	and a
	ret

.asm_d2c6
	ld h, d ;put top of bag in hl, item to place in a, quantity in another variable
	ld l, e
	ld a, [CurItem]
	ld c, a
	ld a, [wd10c]
	ld [wd10d], a
.asm_d2d2
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_d2ef ;if end of bag, place in new bag slot
	cp c
	jr nz, .asm_d2d2 ;if not same item, jump
	ld a, [wd10d]
	add [hl] ;add hl to remaining(?) items to place
	cp $64
	jr nc, .asm_d2e6 ;if total amount is >= 100, jump
	ld [hl], a ;else load into bag and ret c
	jr .asm_d2fd

.asm_d2e6
	ld [hl], 99 ;load 99 into bag, then reduce the ammount to add by the amount added to the bag this way
	sub 99
	ld [wd10d], a
	jr .asm_d2d2 ;loop
.asm_d2ef
	dec hl
	ld a, [CurItem] ;load item into new bag slot
	ld [hli], a
	ld a, [wd10d]
	ld [hli], a
	ld [hl], $ff
	ld h, d
	ld l, e
	inc [hl]
.asm_d2fd
	scf
	ret
; d2ff

Functiond2ff: ; d2ff
	ld d, h
	ld e, l
	ld a, [hli]
	ld c, a
	ld a, [wd107]
	cp c
	jr nc, .asm_d318
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [CurItem]
	cp [hl]
	inc hl
	jr z, .asm_d327
	ld h, d
	ld l, e
	inc hl
.asm_d318
	ld a, [CurItem]
	ld b, a
.asm_d31c
	ld a, [hli]
	cp b
	jr z, .asm_d327
	cp $ff
	jr z, .asm_d347
	inc hl
	jr .asm_d31c

.asm_d327
	ld a, [wd10c]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .asm_d347
	ld [hl], a
	ld [wd10d], a
	and a
	jr nz, .asm_d345
	dec hl
	ld b, h
	ld c, l
	inc hl
	inc hl
.asm_d33b
	ld a, [hli]
	ld [bc], a
	inc bc
	cp $ff
	jr nz, .asm_d33b
	ld h, d
	ld l, e
	dec [hl]
.asm_d345
	scf
	ret

.asm_d347
	and a
	ret
; d349

Functiond349: ; d349
	ld a, [CurItem]
	ld c, a
.asm_d34d
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_d358
	cp c
	jr nz, .asm_d34d
	scf
	ret

.asm_d358
	and a
	ret
; d35a

Functiond35a: ; d35a
	ld hl, NumKeyItems
	ld a, [hli]
	cp $19
	jr nc, .asm_d372
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [CurItem]
	ld [hli], a
	ld [hl], $ff
	ld hl, NumKeyItems
	inc [hl]
	scf
	ret

.asm_d372
	and a
	ret
; d374

Functiond374: ; d374
	ld a, [wd107]
	ld e, a
	ld d, $0
	ld hl, NumKeyItems
	ld a, [hl]
	cp e
	jr nc, .asm_d387
	call Functiond396
	ret nc
	jr .asm_d38a

.asm_d387
	dec [hl]
	inc hl
	add hl, de
.asm_d38a
	ld d, h
	ld e, l
	inc hl
.asm_d38d
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .asm_d38d
	scf
	ret
; d396

Functiond396: ; d396
	ld hl, NumKeyItems
	ld a, [CurItem]
	ld c, a
.asm_d39d
	inc hl
	ld a, [hl]
	cp c
	jr z, .asm_d3a8
	cp $ff
	jr nz, .asm_d39d
	xor a
	ret

.asm_d3a8
	ld a, [NumKeyItems]
	dec a
	ld [NumKeyItems], a
	scf
	ret
; d3b1

Functiond3b1: ; d3b1
	ld a, [CurItem]
	ld c, a
	ld hl, KeyItems
.asm_d3b8
	ld a, [hli]
	cp c
	jr z, .asm_d3c2
	cp $ff
	jr nz, .asm_d3b8
	and a
	ret

.asm_d3c2
	scf
	ret
; d3c4

Functiond3c4: ; d3c4
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [wd10c]
	add [hl]
	cp 2
	jr nc, .asm_d3d6
	ld [hl], a
	scf
	ret

.asm_d3d6
	and a
	ret
; d3d8

Functiond3d8: ; d3d8
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [wd10c]
	ld b, a
	ld a, [hl]
	sub b
	jr c, .asm_d3f9
	ld [hl], a
	ld [wd10d], a
	jr nz, .asm_d3f7
	ld a, [wd0e2]
	and a
	jr z, .asm_d3f7
	dec a
	ld [wd0e2], a
.asm_d3f7
	scf
	ret

.asm_d3f9
	and a
	ret
; d3fb

Functiond3fb: ; d3fb
	dec c
	ld b, $0
	ld hl, TMsHMs
	add hl, bc
	ld a, [hl]
	and a
	ret z
	scf
	ret
; d407

GetTMHMNumber:: ; d407
; Return the number of a TM/HM by item id c.

	ld a, c
; Skip any dummy items.

	cp ITEM_C3 ; TM04-05
	jr c, .done
	cp ITEM_DC ; TM28-29
	jr c, .skip
	dec a
.skip
	dec a
.done
	sub TM01
	inc a
	ld c, a
	ret
; d417

GetNumberedTMHM: ; d417
; Return the item id of a TM/HM by number c.

	ld a, c
; Skip any gaps.

	cp ITEM_C3 - (TM01 - 1)
	jr c, .done
	cp ITEM_DC - (TM01 - 1) - 1
	jr c, .skip_one
.skip_two
	inc a
.skip_one
	inc a
.done
	add TM01
	dec a
	ld c, a
	ret
; d427

_CheckTossableItem:: ; d427
; Return 1 in wd142 and carry if CurItem can't be removed from the bag.

	ld a, 4
	call GetItemAttr
	bit 7, a
	jr nz, Functiond47f
	and a
	ret
; d432

CheckSelectableItem: ; d432
; Return 1 in wd142 and carry if CurItem can't be selected.

	ld a, 4
	call GetItemAttr
	bit 6, a
	jr nz, Functiond47f
	and a
	ret
; d43d

CheckItemPocket:: ; d43d
; Return the pocket for CurItem in wd142.

	ld a, 5
	call GetItemAttr
	and $f
	ld [wd142], a
	ret
; d448

CheckItemContext: ; d448
; Return the context for CurItem in wd142.

	ld a, 6
	call GetItemAttr
	and $f
	ld [wd142], a
	ret
; d453

CheckItemMenu: ; d453
; Return the menu for CurItem in wd142.

	ld a, 6
	call GetItemAttr
	swap a
	and $f
	ld [wd142], a
	ret
; d460

GetItemAttr: ; d460
; Get attribute a of CurItem.

	push hl
	push bc
	ld hl, ItemAttributes
	ld c, a
	ld b, 0
	add hl, bc
	xor a
	ld [wd142], a
	ld a, [CurItem]
	dec a
	ld c, a
	ld a, 7
	call AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarByte
	pop bc
	pop hl
	ret
; d47f

Functiond47f: ; d47f
	ld a, 1
	ld [wd142], a
	scf
	ret
; d486

GetItemPrice: ; d486
; Return the price of CurItem in de.

	push hl
	push bc
	ld a, $0
	call GetItemAttr
	ld e, a
	ld a, $1
	call GetItemAttr
	ld d, a
	pop bc
	pop hl
	ret
; d497

Functiond497:: ; d497 (3:5497)
	ld a, [wd150]
	and a
	ret z
	bit 7, a
	jr nz, .asm_d4a9
	bit 6, a
	jr nz, .asm_d4b3
	bit 5, a
	jr nz, .asm_d4b8
	ret

.asm_d4a9
	ld a, $4
	ld [wd13f], a
	call Functiond536
	jr .asm_d4b8

.asm_d4b3
	call Functiond511
	jr .asm_d4b8

.asm_d4b8
	call Functiond4e5
	ld a, [wd14e]
	ld d, a
	ld a, [wd14f]
	ld e, a
	ld a, [wd14c]
	sub d
	ld [wd14c], a
	ld a, [wd14d]
	sub e
	ld [wd14d], a
	ret

Functiond4d2:: ; d4d2 (3:54d2)
	ld a, [wd14e]
	ld d, a
	ld a, [wd14f]
	ld e, a
	ld a, [hSCX] ; $ff00+$cf
	add d
	ld [hSCX], a ; $ff00+$cf
	ld a, [hSCY] ; $ff00+$d0
	add e
	ld [hSCY], a ; $ff00+$d0
	ret

Functiond4e5: ; d4e5 (3:54e5)
	ld hl, wd13f
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ld a, [hl]
	ld hl, Jumptable_d4f2
	rst JumpTable
	ret

Jumptable_d4f2: ; d4f2 (3:54f2)
	dw Function2914
	dw Function2879
	dw Functiond509
	dw Functiond510
	dw Functiond508
	dw Functiond508
	dw Functiond508
	dw Functiond508
	dw Functiond508
	dw Functiond508
	dw Functiond508

Functiond508: ; d508 (3:5508)
	ret

Functiond509: ; d509 (3:5509)
	callba Function10602e
	ret

Functiond510: ; d510 (3:5510)
	ret

Functiond511: ; d511 (3:5511)
	ld a, [wd151]
	and a
	jr nz, .asm_d51c
	ld hl, YCoord
	inc [hl]
	ret

.asm_d51c
	cp $1
	jr nz, .asm_d525
	ld hl, YCoord
	dec [hl]
	ret

.asm_d525
	cp $2
	jr nz, .asm_d52e
	ld hl, XCoord
	dec [hl]
	ret

.asm_d52e
	cp $3
	ret nz
	ld hl, XCoord
	inc [hl]
	ret

Functiond536: ; d536 (3:5536)
	ld a, [wd151]
	and a
	jr z, .asm_d549
	cp $1
	jr z, .asm_d553
	cp $2
	jr z, .asm_d55d
	cp $3
	jr z, .asm_d567
	ret

.asm_d549
	call Functiond571
	call Function217a
	call Function2748
	ret

.asm_d553
	call Functiond5a2
	call Function217a
	call Function272a
	ret

.asm_d55d
	call Functiond5d5
	call Function217a
	call Function2771
	ret

.asm_d567
	call Functiond5fe
	call Function217a
	call Function278f
	ret

Functiond571: ; d571 (3:5571)
	ld a, [wd152]
	add $40
	ld [wd152], a
	jr nc, .asm_d586
	ld a, [wd153]
	inc a
	and $3
	or $98
	ld [wd153], a
.asm_d586
	ld hl, wd196
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_d594
	ld [hl], $0
	call Functiond595
.asm_d594
	ret

Functiond595: ; d595 (3:5595)
	ld hl, wd194
	ld a, [MapWidth]
	add $6
	add [hl]
	ld [hli], a
	ret nc
	inc [hl]
	ret

Functiond5a2: ; d5a2 (3:55a2)
	ld a, [wd152]
	sub $40
	ld [wd152], a
	jr nc, .asm_d5b7
	ld a, [wd153]
	dec a
	and $3
	or $98
	ld [wd153], a
.asm_d5b7
	ld hl, wd196
	dec [hl]
	ld a, [hl]
	cp $ff
	jr nz, .asm_d5c5
	ld [hl], $1
	call Functiond5c6
.asm_d5c5
	ret

Functiond5c6: ; d5c6 (3:55c6)
	ld hl, wd194
	ld a, [MapWidth]
	add $6
	ld b, a
	ld a, [hl]
	sub b
	ld [hli], a
	ret nc
	dec [hl]
	ret

Functiond5d5: ; d5d5 (3:55d5)
	ld a, [wd152]
	ld e, a
	and $e0
	ld d, a
	ld a, e
	sub $2
	and $1f
	or d
	ld [wd152], a
	ld hl, wd197
	dec [hl]
	ld a, [hl]
	cp $ff
	jr nz, .asm_d5f3
	ld [hl], $1
	call Functiond5f4
.asm_d5f3
	ret

Functiond5f4: ; d5f4 (3:55f4)
	ld hl, wd194
	ld a, [hl]
	sub $1
	ld [hli], a
	ret nc
	dec [hl]
	ret

Functiond5fe: ; d5fe (3:55fe)
	ld a, [wd152]
	ld e, a
	and $e0
	ld d, a
	ld a, e
	add $2
	and $1f
	or d
	ld [wd152], a
	ld hl, wd197
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_d61c
	ld [hl], $0
	call Functiond61d
.asm_d61c
	ret

Functiond61d: ; d61d (3:561d)
	ld hl, wd194
	ld a, [hl]
	add $1
	ld [hli], a
	ret nc
	inc [hl]
	ret

INCLUDE "engine/anim_hp_bar.asm"

BadgeBoostStatXP: ;hl = stat xp given by badge boosts, no effect in egk
	xor a
	ld hl, StatusFlags ;if egk,stat xp = 0
	bit 5, [hl]
	ld h, a
	ld l, a
	ret z
	push bc
	ld hl, JohtoBadges
	ld b, 2
	push de
	call CountSetBits
	pop de
	ld b, 0
	ld hl, BadgeStatXpTable
	add hl, bc
	ld a, [hl]
	ld h, a
	ld l, 0
	pop bc
	ret

BadgeStatXpTable:
	db $00 ;0
	db $06
	db $0b
	db $10
	db $14 ;4
	db $18
	db $20
	db $28
	db $30 ;8
	db $40
	db $46
	db $4b
	db $55 ;12
	db $60
	db $68
	db $70
	db $80



Functiond88c: ; d88c if montype is non-zero, load mon into enemy trainer. else load mon into party if space. ret c if succsessful.
;species = curpartyspecies, $ffae = placed in slot
	ld de, PartyCount
	ld a, [MonType]
	and $f
	jr z, .asm_d899 ;if montype first nyble is zero load into player party, else load into opposing trainer
	ld de, OTPartyCount
.asm_d899
	ld a, [de] ;if mons in party 6 or more, ret
	inc a
	cp PARTY_LENGTH + 1
	ret nc
	ld [de], a ;inc party count
	;ld a, [de] ;??? seems very useless
	ld [$ffae], a ;store for later
	add e ;go to appropriote species slot
	ld e, a
	jr nc, .asm_d8a7
	inc d
.asm_d8a7
	ld a, [CurPartySpecies]
	ld [de], a ;load species into party
	inc de
	ld a, $ff
	ld [de], a ;put an empty slot after it
	ld hl, PartyMonOT ;hl = original trainer location
	ld a, [MonType]
	and $f
	jr z, .asm_d8bc
	ld hl, OTPartyMonOT
.asm_d8bc
	ld a, [$ffae] ;reload target party slot
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, PlayerName
	ld bc, NAME_LENGTH
	call CopyBytes ;load playername into structure as original trainer
	ld a, [MonType]
	and a
	jr nz, .asm_d8f0 ;if montype nz, skip nickname
	ld a, [CurPartySpecies] ;load species into var to get mon name
	ld [wd265], a
	call GetPokemonName ;put name in nicknames
	ld hl, PartyMonNicknames
	ld a, [$ffae] ;reload slot to go down in list
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, StringBuffer1
	ld bc, PKMN_NAME_LENGTH ;enter mon name into nickname list
	call CopyBytes
.asm_d8f0
	ld hl, PartyMon1Species ;load species location
	ld a, [MonType]
	and $f
	jr z, .asm_d8fd
	ld hl, OTPartyMon1Species
.asm_d8fd
	ld a, [$ffae]
	dec a
	ld bc, PartyMon2 - PartyMon1 ;go to correct party slot
	call AddNTimes
Functiond906: ; d906
	ld e, l
	ld d, h
	push hl ;load loc into de and the stack
	ld a, [CurPartySpecies]
	ld [CurSpecies], a ;put species into curspecies
	call GetBaseData ;curbasedata holds mon base stats
	ld a, [BaseDexNo]
	ld [de], a ;load in dex number as species
	inc de
	ld a, [wBattleMode]
	and a
	ld a, $0 ;if in battle, load enemy mon item, else load no item
	jr z, .asm_d922
	ld a, [EnemyMonItem]
.asm_d922
	ld [de], a ;load item in
	inc de
	push de ;remember start of moves
	ld h, d
	ld l, e
	ld a, [wBattleMode]
	and a
	jr z, .asm_d943 ;if not in battle, jump
	ld a, [MonType]
	and a
	jr nz, .asm_d943 ;jump if not opposing mon
	ld de, EnemyMonMoves
	rept NUM_MOVES + -1 ;repeat 3 times
	ld a, [de] ;copy enemymonmoves into mon moves
	inc de
	ld [hli], a
	endr
	ld a, [de]
	ld [hl], a
	jr .asm_d950 ;jump ahead
.asm_d943
	xor a
	rept NUM_MOVES + -1
	ld [hli], a ;load zero into all moves and a buffer
	endr
	ld [hl], a
	ld [Buffer1], a
	predef FillMoves ;fill moves from movepool
.asm_d950
	pop de ;start of moves
	inc de
	inc de
	inc de
	inc de ;move past moves
	ld a, [PlayerID]
	ld [de], a ;load in ID no
	inc de
	ld a, [PlayerID + 1]
	ld [de], a
	inc de
	push de ;save mon xp location
	ld a, [CurPartyLevel]
	ld d, a ;load level into d
	callab Function50e47 ;get xp for level and growth rate
	pop de
	ld a, [hMultiplicand]
	ld [de], a ;load current XP into mon (takes 3 bytes)
	inc de
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	ld a, [MonType]
	cp 1
	jr nz, .yours
	ld a, [CurPartyLevel] ;a = level
	call TrainerStatExp ;load trainer stat xp into hl depending on level
	jr .okay
.yours
	call BadgeBoostStatXP
.okay
	ld b, 5 ;repeat 5 times (once a stat)
.asm_d97a
	ld a, h
	ld [de], a ;load in stat xp
	inc de
	ld a, l
	ld [de], a
	inc de
	dec b
	jr nz, .asm_d97a
	pop hl ;start of mon data
	push hl
	ld a, [MonType] ;if montype = z, jump and random dvs, else call trainer dvs and put in bc
	and $f
	jr z, .asm_d992
	push hl
	callba GetTrainerDVs
	pop hl
	jr .asm_d9b5

.asm_d992
	ld a, [CurPartySpecies]
	ld [wd265], a ;load species
	dec a
	push de ;start of dvs
	call CheckCaughtMon ;what does this do here, code clears a and the flags and a nigh immediatly and SetSeenAndCaughtMon loads over c
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon ;set dex flags
	pop de ;start of dvs
	pop hl ;start of mon data
	push hl
	ld a, [wBattleMode]
	and a
	jr nz, .asm_d9f3 ;if in battle, jump, else random bc
	call Random
	ld b, a
	call Random
	ld c, a
.asm_d9b5
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a ;put DVs into the mon
	inc de
	push hl;start of mon data
	push de; before PP
	inc hl
	inc hl ;move over mon moves
	call FillPP ;fill pp slots
	pop de
	pop hl ;start of mon data
	inc de
	inc de
	inc de
	inc de ;de = happiness
	ld b, $ff
	ld a, [MonType]
	cp 1
	jr z, .MaxHappiness
	ld b, BASE_HAPPINESS
.MaxHappiness
	ld a, b
	ld [de], a ;load base happiness if not a trainer, else load max happiness
	inc de
	xor a
	ld [de], a ;load 0 into pokerus and caught data
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, [CurPartyLevel]
	ld [de], a ;load level
	inc de
	xor a
	ld [de], a ;load 0 into status and unused
	inc de
	ld [de], a
	inc de
	ld bc, $000a
	add hl, bc ;move hl down 10 to start of stat xp
	ld a, $1
	ld c, a ;get hp
	ld b, 1 ;stat xp on
	predef CalcPkmnStatC ; calc hp, put HP into in $ffb5 and $ffb6.
	ld a, [$ffb5] ;load hp
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	jr .asm_da29

.asm_d9f3 ;if in battle
	ld a, [EnemyMonDVs] ;load dvs from enemy
	ld [de], a
	inc de
	ld a, [EnemyMonDVs + 1]
	ld [de], a
	inc de
	push hl
	push de
	ld hl, -13 ;start of statxp
	add hl, de
	push hl
	ld b, 0
	ld c, 26
	add hl, bc ;start of stat clock
	ld d,h
	ld e,l
	pop hl
	push de ;start of stat block, over second byte of cur HP
	ld b, 1
	call CalcPkmnStats ;update stats for badge boost stat xp

	pop de
	inc de ;over low byte of new max hp
	ld a, [EnemyMonMaxHP]
	ld h, a
	ld a, [EnemyMonMaxHP+1] ; hl = old max hp
	ld l, a

	ld a, [de] ;sub new max hp by old to get differnce, store in bc
	sub l
	ld c, a ; store difference in HP
	dec de
	ld a, [de]
	sbc h
	ld b, a

	pop de
	push bc ;holds difference between old max and new max HP
	ld hl, EnemyMonPP ;load pp from enemy mon
	ld b, NUM_MOVES
.asm_da03
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_da03 ;end of pp
	pop bc ;load in HP diff for later
	pop hl
	ld a, BASE_HAPPINESS
	ld [de], a ;load in happiness
	inc de
	xor a
	ld [de], a ;pokerus
	inc de
	ld [de], a ;catching stats
	inc de
	ld [de], a;load 0 into mon pokerus and catching stats
	inc de
	ld a, [CurPartyLevel]
	ld [de], a; load level
	inc de
	ld hl, EnemyMonStatus
	ld a, [hli] ;load status
	ld [de], a
	inc de
	ld a, [hli] ;load ???
	ld [de], a
	inc de
	inc de ;skip 1 to allow for adc use
	inc hl
	ld a, [hld] ;load HP, adding difference between new max and old max HP to current
	add c
	ld [de], a
	ld a, [hl]
	adc b
	dec de
	ld [de], a
	inc de
	inc de
.asm_da29 ;
	ld a, [wBattleMode]
	dec a
	jr nz, .asm_da3b ;if trainer battle, get mon stats from battle mon
	;ld hl, EnemyMonMaxHP
	;ld bc, $000c
	;call CopyBytes
	pop hl ;start of mon data
	jr .asm_da45

.asm_da3b
	pop hl ;start of mon data
	ld bc, $000a
	add hl, bc ;stat xp location
	ld b, 1
	ld a, [MonType]
	cp $1
	jr z, .okay2
	ld b, 1
.okay2
	call CalcPkmnStats ;fill rest of stats
.asm_da45
	ld a, [MonType]
	and $f
	jr nz, .asm_da6b ;if mon type not yours, skip unown check
	ld a, [CurPartySpecies]
	cp UNOWN
	jr nz, .asm_da6b ;if unown
	ld hl, PartyMon1DVs ;load unown letter
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	predef GetUnownLetter
	callab Functionfba18
.asm_da6b
	scf ; When this function returns, the carry flag indicates success vs failure.
	ret
; da6d

TrainerStatExp:
	; Level stored in a.  Return stat exp in hl.
	cp 5 + 1
	ld hl, 0
	ret c
	;cp 100
	;jr nc, .max
	sub 5 ;6-20 ;reduce by last catagory
	ld bc, 150 ;load in amount to add per level
	cp 16 ;if in this box, add loop, else next group
	jr c, .add
	sub 15 ;21-35
	ld bc, 250
	ld hl, 2250
	cp 16
	jr c, .add
	sub 15 ;36-55
	ld bc, 400
	ld hl, 6000
	cp 21
	jr c, .add
	sub 20 ;56-75
	ld bc, 400
	ld hl, 14000
	cp 21
	jr c, .add
	sub 20 ;75-100
	ld bc, 600
	ld hl, 22000
.add
	and a
	ret z
.loop
	add hl, bc
	dec a
	jr nz, .loop
	ret
;.max
;	ld hl, 63500
;	ret


FillPP: ; da6d hl = start of moves, de = start of place to put pp
	push bc
	ld b, NUM_MOVES
.asm_da70
	ld a, [hli] ;load move
	and a
	jr z, .asm_da8f;if no move, are done
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes ;go down to correct move
	ld de, StringBuffer1 ;load into stringbuffer(roundabout way to do that compared to just moving hl)
	ld a, BANK(Moves)
	call FarCopyBytes
	pop bc
	pop de
	pop hl
	ld a, [StringBuffer1 + MOVE_PP] ;a = slot in string buffer that holds PP
.asm_da8f
	ld [de], a ;load pp into slot
	inc de ;move to next slot
	dec b
	jr nz, .asm_da70 ; loop until out of moves
	pop bc
	ret
; da96

Functionda96: ; da96
	ld hl, PartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [CurPartySpecies]
	ld [hli], a
	ld [hl], $ff
	ld hl, PartyMon1Species
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, TempMonSpecies
	call CopyBytes
	ld hl, PartyMonOT
	ld a, [PartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, OTPartyMonOT
	ld a, [CurPartyMon]
	call SkipNames
	ld bc, NAME_LENGTH
	call CopyBytes
	ld hl, PartyMonNicknames
	ld a, [PartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	ld hl, OTPartyMonNicknames
	ld a, [CurPartyMon]
	call SkipNames
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	ld a, [CurPartySpecies]
	ld [wd265], a
	cp EGG
	jr z, .owned
	dec a
	call SetSeenAndCaughtMon
	ld hl, PartyMon1Happiness
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld [hl], BASE_HAPPINESS
.owned
	ld a, [CurPartySpecies]
	cp UNOWN
	jr nz, .done
	ld hl, PartyMon1DVs
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	predef GetUnownLetter
	callab Functionfba18
	ld a, [wdef4]
	and a
	jr nz, .done
	ld a, [UnownLetter]
	ld [wdef4], a
.done
	and a
	ret
; db3f

Functiondb3f: ; db3f
	ld a, $1
	call GetSRAMBank
	ld a, [wd10b]
	and a
	jr z, .asm_db60
	cp $2
	jr z, .asm_db60
	cp $3
	ld hl, wBreedMon1Species
	jr z, .asm_db9b
	ld hl, sBoxCount
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .asm_db69
	jp Functiondcb1

.asm_db60
	ld hl, PartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jp z, Functiondcb1
.asm_db69
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wd10b]
	cp $2
	ld a, [wBreedMon1Species]
	jr z, .asm_db7c
	ld a, [CurPartySpecies]
.asm_db7c
	ld [hli], a
	ld [hl], $ff
	ld a, [wd10b]
	dec a
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	ld a, [PartyCount]
	jr nz, .asm_db97
	ld hl, sBoxMon1Species
	ld bc, sBoxMon1End - sBoxMon1
	ld a, [sBoxCount]
.asm_db97
	dec a
	call AddNTimes
.asm_db9b
	push hl
	ld e, l
	ld d, h
	ld a, [wd10b]
	and a
	ld hl, sBoxMon1Species
	ld bc, sBoxMon1End - sBoxMon1
	jr z, .asm_dbb7
	cp $2
	ld hl, wBreedMon1Species
	jr z, .asm_dbbd
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
.asm_dbb7
	ld a, [CurPartyMon]
	call AddNTimes
.asm_dbbd
	ld bc, sBoxMon1End - sBoxMon1
	call CopyBytes
	ld a, [wd10b]
	cp $3
	ld de, wBreedMon1OT
	jr z, .asm_dbe2
	dec a
	ld hl, PartyMonOT
	ld a, [PartyCount]
	jr nz, .asm_dbdc
	ld hl, sBoxMonOT
	ld a, [sBoxCount]
.asm_dbdc
	dec a
	call SkipNames
	ld d, h
	ld e, l
.asm_dbe2
	ld hl, sBoxMonOT
	ld a, [wd10b]
	and a
	jr z, .asm_dbf5
	ld hl, wBreedMon1OT
	cp $2
	jr z, .asm_dbfb
	ld hl, PartyMonOT
.asm_dbf5
	ld a, [CurPartyMon]
	call SkipNames
.asm_dbfb
	ld bc, NAME_LENGTH
	call CopyBytes
	ld a, [wd10b]
	cp $3
	ld de, wBreedMon1Nick
	jr z, .asm_dc20
	dec a
	ld hl, PartyMonNicknames
	ld a, [PartyCount]
	jr nz, .asm_dc1a
	ld hl, sBoxMonNicknames
	ld a, [sBoxCount]
.asm_dc1a
	dec a
	call SkipNames
	ld d, h
	ld e, l
.asm_dc20
	ld hl, sBoxMonNicknames
	ld a, [wd10b]
	and a
	jr z, .asm_dc33
	ld hl, wBreedMon1Nick
	cp $2
	jr z, .asm_dc39
	ld hl, PartyMonNicknames
.asm_dc33
	ld a, [CurPartyMon]
	call SkipNames
.asm_dc39
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	pop hl
	ld a, [wd10b]
	cp $1
	jr z, .asm_dca4
	cp $3
	jp z, .asm_dcac
	push hl
	srl a
	add $2
	ld [MonType], a
	predef Function5084a
	callab Function50e1b
	ld a, d
	ld [CurPartyLevel], a
	pop hl
	ld b, h
	ld c, l
	ld hl, $001f
	add hl, bc
	ld [hl], a
	ld hl, $0024
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000a
	add hl, bc
	push bc
	ld b, $1
	call CalcPkmnStats
	pop bc
	ld a, [wd10b]
	and a
	jr nz, .asm_dcac
	ld hl, $0020
	add hl, bc
	xor a
	ld [hl], a
	ld hl, $0022
	add hl, bc
	ld d, h
	ld e, l
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_dc9e
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
	ld a, [hl]
	inc de
	ld [de], a
	jr .asm_dcac

.asm_dc9e
	xor a
	ld [de], a
	inc de
	ld [de], a
	jr .asm_dcac

.asm_dca4
	ld a, [sBoxCount]
	dec a
	ld b, a
	call Functiondcb6
.asm_dcac
	call CloseSRAM
	and a
	ret
; dcb1

Functiondcb1: ; dcb1
	call CloseSRAM
	scf
	ret
; dcb6

Functiondcb6: ; dcb6 store box mon moves and PP
	ld a, b
	ld hl, sBoxMons
	ld bc, sBoxMon1End - sBoxMon1 ;size of a box mon
	call AddNTimes ;go down to slot a
	ld b, h ;store new location in bc
	ld c, l
	ld hl, sBoxMon1PP - sBoxMon1 ;space between PP and head of block
	add hl, bc ; go to correct slot's pp
	push hl ;store PP location
	push bc ;store start of correct block
	ld de, TempMonPP
	ld bc, NUM_MOVES
	call CopyBytes ;copy PP into mon
	pop bc ; = start of correct block
	ld hl, sBoxMon1Moves - sBoxMon1 ;find moves
	add hl, bc
	push hl ;store moves location
	ld de, TempMonMoves
	ld bc, NUM_MOVES
	call CopyBytes ;copy moves into correct slot
	pop hl ;moves loc
	pop de ;pp loc
	ld a, [wcfa9] ;preserve variables
	push af
	ld a, [MonType]
	push af
	ld b, 0
.asm_dcec
	ld a, [hli]; a = top move
	and a
	jr z, .asm_dd18 ;jump if 0
	ld [TempMonMoves+0], a ;load the move into temp moves
	ld a, BOXMON ;put 2 in montype
	ld [MonType], a
	ld a, b
	ld [wcfa9], a ;put move slot in variable
	push bc
	push hl
	push de
	callba Functionf8ec ;get max pp of moveslot wcfa9 in move list hl, put result in wd265
	pop de
	pop hl
	ld a, [wd265]
	ld b, a ;put max PP in b
	ld a, [de]
	and $c0 ;a = pp ups used on move
	add b ;a = full pp data
	ld [de], a ;load into PP
	pop bc
	inc de ;move to next slot
	inc b
	ld a, b
	cp NUM_MOVES ;loop until all slots done, or move = 0(no move)
	jr c, .asm_dcec
.asm_dd18
	pop af
	ld [MonType], a
	pop af
	ld [wcfa9], a
	ret
; dd21

Functiondd21: ; dd21
	ld a, [wBreedMon1Species]
	ld [CurPartySpecies], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	call Functione698
	ld a, b
	ld [DefaultFlypoint], a
	ld a, e
	ld [CurPartyLevel], a
	xor a
	ld [wd10b], a
	jp Functiondd64
; dd42

Functiondd42: ; dd42
	ld a, [wBreedMon2Species]
	ld [CurPartySpecies], a
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	call Functione6b3
	ld a, b
	ld [DefaultFlypoint], a
	ld a, e
	ld [CurPartyLevel], a
	ld a, $1
	ld [wd10b], a
	jp Functiondd64
; dd64

Functiondd64: ; dd64
	ld hl, PartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .asm_dd6e
	scf
	ret

.asm_dd6e
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wd10b]
	and a
	ld a, [wBreedMon1Species]
	ld de, wBreedMon1Nick
	jr z, .asm_dd86
	ld a, [wBreedMon2Species]
	ld de, wBreedMon2Nick
.asm_dd86
	ld [hli], a
	ld [CurSpecies], a
	ld a, $ff
	ld [hl], a
	ld hl, PartyMonNicknames
	ld a, [PartyCount]
	dec a
	call SkipNames
	push hl
	ld h, d
	ld l, e
	pop de
	call CopyBytes
	push hl
	ld hl, PartyMonOT
	ld a, [PartyCount]
	dec a
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	call CopyBytes
	push hl
	call Functionde1a
	pop hl
	ld bc, $0020
	call CopyBytes
	call GetBaseData
	call Functionde1a
	ld b, d
	ld c, e
	ld hl, $001f
	add hl, bc
	ld a, [CurPartyLevel]
	ld [hl], a
	ld hl, $0024
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000a
	add hl, bc
	push bc
	ld b, $1
	call CalcPkmnStats
	ld hl, PartyMon1Moves
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld a, $1
	ld [Buffer1], a
	predef FillMoves
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	callba Functionc677
	ld a, [CurPartyLevel]
	ld d, a
	callab Function50e47
	pop bc
	ld hl, $0008
	add hl, bc
	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hl], a
	and a
	ret
; de1a

Functionde1a: ; de1a
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ret
; de2a

Functionde2a: ; de2a
	ld de, wBreedMon1Nick
	call Functionde44
	xor a
	ld [wd10b], a
	jp Functione039
; de37

Functionde37: ; de37
	ld de, wBreedMon2Nick
	call Functionde44
	xor a
	ld [wd10b], a
	jp Functione039
; de44

Functionde44: ; de44
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call SkipNames
	call CopyBytes
	ld a, [CurPartyMon]
	ld hl, PartyMonOT
	call SkipNames
	call CopyBytes
	ld a, [CurPartyMon]
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld bc, sBoxMon1End - sBoxMon1
	jp CopyBytes
; de6e

Functionde6e: ; de6e
	ld a, 1 ; BANK(sBoxCount)
	call GetSRAMBank ;open box
	ld de, sBoxCount
	ld a, [de]
	cp MONS_PER_BOX
	jp nc, Functiondf42 ;if box full, jump
	inc a
	ld [de], a ;increment box mons by 1
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	ld c, a ;c = species
.asm_de85 ;insert species into top slot, move others down
	inc de
	ld a, [de] ;load first mon species into c
	ld b, a
	ld a, c
	ld c, b
	ld [de], a ;put current mon into old slot
	inc a
	jr nz, .asm_de85 ;loop until end of box
	call GetBaseData ;load base stats for newly added species
	call ShiftBoxMon ;move all box mons down 1 slot
	ld hl, PlayerName
	ld de, sBoxMonOT
	ld bc, NAME_LENGTH
	call CopyBytes ;copy in OT
	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	ld de, sBoxMonNicknames
	ld hl, StringBuffer1
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes ;copy in nickname
	ld hl, EnemyMon
	ld de, sBoxMon1
	ld bc, 1 + 1 + NUM_MOVES ; species + item + moves
	call CopyBytes
	ld hl, PlayerID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	push de
	ld a, [CurPartyLevel]
	ld d, a
	callab Function50e47
	pop de
	ld a, [hMultiplicand]
	ld [de], a
	inc de
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	call BadgeBoostStatXP
	ld b, 5 ;repeat 5 times (once a stat)
.statxploop
	ld a, h
	ld [de], a ;load in stat xp
	inc de
	ld a, l
	ld [de], a
	inc de
	dec b
	jr nz, .statxploop
	ld hl, EnemyMonDVs
	ld b, 2 + NUM_MOVES ; DVs and PP ; EnemyMonHappiness - EnemyMonDVs
.asm_deef
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_deef
	ld a, BASE_HAPPINESS
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, [CurPartyLevel]
	ld [de], a
	ld a, [CurPartySpecies]
	dec a
	call SetSeenAndCaughtMon
	ld a, [CurPartySpecies]
	cp UNOWN
	jr nz, .asm_df20
	ld hl, sBoxMon1DVs
	predef GetUnownLetter
	callab Functionfba18
.asm_df20
	ld hl, sBoxMon1Moves
	ld de, TempMonMoves
	ld bc, NUM_MOVES
	call CopyBytes
	ld hl, sBoxMon1PP
	ld de, TempMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	ld b, 0
	call Functiondcb6
	call CloseSRAM
	scf
	ret
; df42

Functiondf42: ; df42
	call CloseSRAM
	and a
	ret
; df47

ShiftBoxMon: ; df47
	ld hl, sBoxMonOT
	ld bc, NAME_LENGTH
	call .asm_df5f
	ld hl, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call .asm_df5f
	ld hl, sBoxMons
	ld bc, sBoxMon1End - sBoxMon1
.asm_df5f
	ld a, [sBoxCount]
	cp 2
	ret c ;ret if boxcount is 0 or 1
	push hl
	call AddNTimes ;go down to end of first open slot, put in de
	dec hl
	ld e, l
	ld d, h
	pop hl
	ld a, [sBoxCount]
	dec a
	call AddNTimes ;go down to end of last full slot, put in hl
	dec hl
	push hl
	ld a, [sBoxCount]
	dec a
	ld hl, 0
	call AddNTimes ;find distance between start and first open slot, place in bc
	ld c, l
	ld b, h
	pop hl
.loop
	ld a, [hld] ;place contents of hl in de bc times
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret
; df8c

GiveEgg:: ; df8c
	ld a, [CurPartySpecies]
	push af
	callab GetPreEvolution
	callab GetPreEvolution
	ld a, [CurPartySpecies]
	dec a
	push af
	call CheckCaughtMon
	pop af
	push bc
	call CheckSeenMon
	push bc
	call Functiond88c ;load in mon
	pop bc
	ld a, c
	and a
	jr nz, .asm_dfc3
	ld a, [CurPartySpecies]
	dec a
	ld c, a
	ld d, $0
	ld hl, PokedexCaught
	ld b, $0
	predef FlagPredef
.asm_dfc3
	pop bc
	ld a, c
	and a
	jr nz, .asm_dfd9
	ld a, [CurPartySpecies]
	dec a
	ld c, a
	ld d, $0
	ld hl, PokedexSeen
	ld b, $0
	predef FlagPredef
.asm_dfd9
	pop af
	ld [CurPartySpecies], a
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Species
	call AddNTimes
	ld a, [CurPartySpecies]
	ld [hl], a
	ld hl, PartyCount
	ld a, [hl]
	ld b, 0
	ld c, a
	add hl, bc
	ld a, EGG
	ld [hl], a
	ld a, [PartyCount]
	dec a
	ld hl, PartyMonNicknames
	call SkipNames
	ld de, Stringe035
	call CopyName2
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Happiness
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [wc2cc]
	bit 1, a
	ld a, $1
	jr nz, .asm_e022
	ld a, [BaseEggSteps]
.asm_e022
	ld [hl], a
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1HP
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret
; e035

Stringe035: ; e035
	db "EGG@"
; e039

Functione039: ; e039
	ld hl, PartyCount
	ld a, [wd10b]
	and a
	jr z, .asm_e04a
	ld a, 1 ; BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
.asm_e04a
	ld a, [hl]
	dec a
	ld [hli], a
	ld a, [CurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld e, l
	ld d, h
	inc de
.asm_e057
	ld a, [de]
	inc de
	ld [hli], a
	inc a
	jr nz, .asm_e057
	ld hl, PartyMonOT
	ld d, PARTY_LENGTH - 1
	ld a, [wd10b]
	and a
	jr z, .asm_e06d
	ld hl, sBoxMonOT
	ld d, MONS_PER_BOX - 1
.asm_e06d
	ld a, [CurPartyMon]
	call SkipNames
	ld a, [CurPartyMon]
	cp d
	jr nz, .asm_e07e
	ld [hl], $ff
	jp .asm_60f0

.asm_e07e
	ld d, h
	ld e, l
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld bc, PartyMonNicknames
	ld a, [wd10b]
	and a
	jr z, .asm_e090
	ld bc, sBoxMonNicknames
.asm_e090
	call CopyDataUntil
	ld hl, PartyMons
	ld bc, PartyMon2 - PartyMon1
	ld a, [wd10b]
	and a
	jr z, .asm_e0a5
	ld hl, sBoxMons
	ld bc, sBoxMon1End - sBoxMon1
.asm_e0a5
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [wd10b]
	and a
	jr z, .asm_e0bc
	ld bc, sBoxMon1End - sBoxMon1
	add hl, bc
	ld bc, sBoxMonOT
	jr .asm_e0c3

.asm_e0bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	ld bc, PartyMonOT
.asm_e0c3
	call CopyDataUntil
	ld hl, PartyMonNicknames
	ld a, [wd10b]
	and a
	jr z, .asm_e0d2
	ld hl, sBoxMonNicknames
.asm_e0d2
	ld bc, PKMN_NAME_LENGTH
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, PKMN_NAME_LENGTH
	add hl, bc
	ld bc, PartyMonNicknamesEnd
	ld a, [wd10b]
	and a
	jr z, .asm_e0ed
	ld bc, sBoxMonNicknamesEnd
.asm_e0ed
	call CopyDataUntil
.asm_60f0
	ld a, [wd10b]
	and a
	jp nz, CloseSRAM
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, $0
	call GetSRAMBank
	ld hl, PartyCount
	ld a, [CurPartyMon]
	cp [hl]
	jr z, .asm_e131
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	push hl
	add hl, bc
	pop de
	ld a, [CurPartyMon]
	ld b, a
.asm_e11a
	push bc
	push hl
	ld bc, $002f
	call CopyBytes
	pop hl
	push hl
	ld bc, $002f
	add hl, bc
	pop de
	pop bc
	inc b
	ld a, [PartyCount]
	cp b
	jr nz, .asm_e11a
.asm_e131
	jp CloseSRAM
; e134

Functione134: ; e134
	ld a, PartyMon1Level - PartyMon1
	call GetPartyParamLocation
	ld a, [hl]
	ld [PartyMon1Level - PartyMon1], a ; wow
	ld a, PartyMon1Species - PartyMon1
	call GetPartyParamLocation
	ld a, [hl]
	ld [CurSpecies], a
	call GetBaseData
	ld a, PartyMon1MaxHP - PartyMon1
	call GetPartyParamLocation
	ld d, h
	ld e, l
	push de
	ld a, PartyMon1Exp + 2 - PartyMon1
	call GetPartyParamLocation
	ld b, $1
	call CalcPkmnStats
	pop de
	ld a, PartyMon1HP - PartyMon1
	call GetPartyParamLocation
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret

CalcPkmnStats: ; e167
; Calculates all 6 Stats of a Pkmn
; b: Take into account stat EXP if TRUE
; 'c' counts from 1-6 and points with 'BaseStats' to the base value
; hl is the path to the Stat EXP
; results in $ffb5 and $ffb6 are saved in [de]

	ld c, 0
.loop
	inc c
	call CalcPkmnStatC
	ld a, [hMultiplicand + 1]
	ld [de], a
	inc de
	ld a, [hMultiplicand + 2]
	ld [de], a
	inc de
	ld a, c
	cp STAT_SDEF
	jr nz, .loop
	ret
; e17b

CalcPkmnStatC: ; e17b
; 'c' is 1-6 and points to the BaseStat
; 1: HP
; 2: Attack
; 3: Defense
; 4: Speed
; 5: SpAtk
; 6: SpDef
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, BaseStats
	dec hl ; has to be decreased, because 'c' begins with 1
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	ld a, c
	cp STAT_SDEF
	jr nz, .not_spdef
	dec hl
	dec hl

.not_spdef
	sla c
	ld a, d
	and a
	jr z, .no_stat_exp
	add hl, bc
	push de
	ld a, [hld]
	ld e, a
	ld d, [hl]
	ld l, c
	push hl
	callba GetSquareRoot
	pop hl
	pop de
	ld c, l

.no_stat_exp
	srl c
	pop hl
	push bc
	ld bc, MON_DVS - MON_HP_EXP + 1
	add hl, bc
	pop bc
	ld a, c
	cp STAT_ATK
	jr z, .Attack
	cp STAT_DEF
	jr z, .Defense
	cp STAT_SPD
	jr z, .Speed
	cp STAT_SATK
	jr z, .Special
	cp STAT_SDEF
	jr z, .Special
; DV_HP = (DV_ATK & 1) << 3 + (DV_DEF & 1) << 2 + (DV_SPD & 1) << 1 + (DV_SPC & 1)
	push bc
	ld a, [hl]
	swap a
	and $1
	add a
	add a
	add a
	ld b, a
	ld a, [hli]
	and $1
	add a
	add a
	add b
	ld b, a
	ld a, [hl]
	swap a
	and $1
	add a
	add b
	ld b, a
	ld a, [hl]
	and $1
	add b
	pop bc
	jr .GotDV

.Attack:
	ld a, [hl]
	swap a
	and $f
	jr .GotDV

.Defense:
	ld a, [hl]
	and $f
	jr .GotDV

.Speed:
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .GotDV

.Special:
	inc hl
	ld a, [hl]
	and $f

.GotDV:
	ld d, 0
	add e
	ld e, a
	jr nc, .no_overflow_1
	inc d

.no_overflow_1
	sla e
	rl d
	srl b
	srl b
	ld a, b
	add e
	jr nc, .no_overflow_2
	inc d

.no_overflow_2
	ld [hMultiplicand + 2], a
	ld a, d
	ld [hMultiplicand + 1], a
	xor a
	ld [hMultiplicand + 0], a
	ld a, [CurPartyLevel]
	ld [hMultiplier], a
	call Multiply
	ld a, [hProduct + 1]
	ld [hDividend + 0], a
	ld a, [hProduct + 2]
	ld [hDividend + 1], a
	ld a, [hProduct + 3]
	ld [hDividend + 2], a
	ld a, 100
	ld [hDivisor], a
	ld a, 3
	ld b, a
	call Divide
	ld a, c
	cp STAT_HP
	ld a, 5
	jr nz, .not_hp
	ld a, [CurPartyLevel]
	ld b, a
	ld a, [hQuotient + 2]
	add b
	ld [hMultiplicand + 2], a
	jr nc, .no_overflow_3
	ld a, [hQuotient + 1]
	inc a
	ld [hMultiplicand + 1], a

.no_overflow_3
	ld a, 10

.not_hp
	ld b, a
	ld a, [hQuotient + 2]
	add b
	ld [hMultiplicand + 2], a
	jr nc, .no_overflow_4
	ld a, [hQuotient + 1]
	inc a
	ld [hMultiplicand + 1], a

.no_overflow_4
	ld a, [hQuotient + 1]
	cp (1000 / $100) + 1
	jr nc, .max_stat
	cp 1000 / $100
	jr c, .stat_value_okay
	ld a, [hQuotient + 2]
	cp 1000 % $100
	jr c, .stat_value_okay

.max_stat
	ld a, 999 / $100
	ld [hMultiplicand + 1], a
	ld a, 999 % $100
	ld [hMultiplicand + 2], a

.stat_value_okay
	pop bc
	pop de
	pop hl
	ret
; e277

GivePoke:: ; e277
	push de
	push bc
	xor a
	ld [MonType], a ;montype = 0(puts mon in party)
	call Functiond88c ;create mon in party
	jr nc, .asm_e2b0 ;if failed, add to PC instead
	ld hl, PartyMonNicknames
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	call SkipNames
	ld d, h
	ld e, l ;put nickname slot in de
	pop bc
	ld a, b
	ld b, $0
	push bc
	push de ; nicknme slot
	push af ; a = b
	ld a, [CurItem]
	and a
	jr z, .asm_e2e1 ;if item = 0, skip ahead
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item ;else add item
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [CurItem]
	ld [hl], a
	jr .asm_e2e1

.asm_e2b0
	ld a, [CurPartySpecies]
	ld [TempEnemyMonSpecies], a ;put species in enemy species
	callab LoadEnemyMon ;place mon in enemy mon
	ld a, [CurItem]
	ld [EnemyMonItem], a
	call Functionde6e ;load enemy mon into PC
	jp nc, Functione3d4 ;if failed, ret b = 2
	ld a, $2
	ld [MonType], a
	xor a
	ld [CurPartyMon], a
	ld de, wd050
	pop bc
	ld a, b
	ld b, $1
	push bc
	push de
	push af
	; ld a, [CurItem]
	; and a
	; jr z, .asm_e2e1
	; ld a, 1
	; call GetSRAMBank
	; ld a, [CurItem]
	; ld [sBoxMon1Item], a
	; call CloseSRAM
	; ; jr .asm_e2e1

; .patchJunkDataItems
	; call GetSRAMBank
	; ld a, 0
	; ld [sBoxMon1Item], a
	; call CloseSRAM
	; jr .asm_e2e1
.asm_e2e1
	ld a, [CurPartySpecies]
	ld [wd265], a
	ld [TempEnemyMonSpecies], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, wd050
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes ;d050 = mon name
	pop af
	and a ;jump if
	jp z, .asm_e390
	pop de
	pop bc
	pop hl
	push bc
	push hl
	ld a, [ScriptBank]
	call GetFarHalfword
	ld bc, PKMN_NAME_LENGTH
	ld a, [ScriptBank]
	call FarCopyBytes
	pop hl
	inc hl
	inc hl
	ld a, [ScriptBank]
	call GetFarHalfword
	pop bc
	ld a, b
	and a
	push de
	push bc
	jr nz, .asm_e35e
	push hl
	ld a, [CurPartyMon]
	ld hl, PartyMonOT
	call SkipNames
	ld d, h
	ld e, l
	pop hl
.asm_e32f
	ld a, [ScriptBank]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $50
	jr nz, .asm_e32f
	ld a, [ScriptBank]
	call GetFarByte
	ld b, a
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMon1ID
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, $3
	ld [hli], a
	ld [hl], $e9
	pop bc
	callba Function4dba3
	jr .asm_e3b2

.asm_e35e
	ld a, $1
	call GetSRAMBank
	ld de, sBoxMonOT
.asm_e366
	ld a, [ScriptBank]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $50
	jr nz, .asm_e366
	ld a, [ScriptBank]
	call GetFarByte
	ld b, a
	ld hl, sBoxMon1ID
	call Random
	ld [hli], a
	call Random
	ld [hl], a
	call CloseSRAM
	callba Function4db92
	jr .asm_e3b2

.asm_e390
	pop de
	pop bc
	push bc
	push de
	ld a, b
	and a
	jr z, .asm_e3a0
	callba Function4db83
	jr .asm_e3a6

.asm_e3a0
	callba Function4db49
.asm_e3a6
	pop de
	call Functione3de ;InitNickname
.asm_e3b2
	pop bc
	pop de
	ld a, b
	and a
	ret z
	ld hl, UnknownText_0xe3d9
	call PrintText
	ld a, $1
	call GetSRAMBank
	ld hl, wd050
	ld de, sBoxMonNicknames
	ld bc, $000b
	call CopyBytes
	call CloseSRAM
	ld b, $1
	ret
; e3d4

Functione3d4: ; e3d4
	pop bc
	pop de
	ld b, $2
	ret
; e3d9

UnknownText_0xe3d9: ; 0xe3d9
	; was sent to BILL's PC.
	text_jump UnknownText_0x1c0feb
	db "@"
; 0xe3de

Functione3de: ; e3de InitNickname
	push de
	call Function1d6e ; LoadStandardMenuDataHeader
	call Function2ed3 ; DisableSpriteUpdates
	pop de
	push de
	ld b, $0
	callba NamingScreen ;NamingScreen
	pop hl
	ld de, StringBuffer1
	call InitName
	jp Function2b4d
; e3fd

Functione3fd: ; e3fd bill's pc
	call Functione40a ;ret c if no mon in party
	ret c
	call Functione41c
	call Functione443
	jp Functione43f

Functione40a: ; e40a (3:640a)
	ld a, [PartyCount]
	and a
	ret nz
	ld hl, UnknownText_0xe417
	call Function1d67
	scf
	ret
; e417 (3:6417)

UnknownText_0xe417: ; 0xe417
	; You gotta have #MON to call!
	text_jump UnknownText_0x1c1006
	db "@"
; 0xe41c

Functione41c: ; e41c (3:641c)
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function1d6e ;load a menu
	call ClearPCItemScreen
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl] ;set instatext
	ld hl, UnknownText_0xe43a
	call PrintText
	pop af
	ld [Options], a
	call Functione58
	ret
; e43a (3:643a)

UnknownText_0xe43a: ; 0xe43a
	; What?
	text_jump UnknownText_0x1c1024
	db "@"
; 0xe43f

Functione43f: ; e43f (3:643f)
	call Function2b3c
	ret

Functione443: ; e443 (3:6443) bills pc related
	ld hl, MenuDataHeader_0xe46f
	call LoadMenuDataHeader
	ld a, $1
.asm_e44b
	ld [wcf88], a
	call Function32f9
	xor a
	ld [wcf76], a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function1e5d ;set up and process PC menu, ret c if going back
	jr c, .asm_e46b
	ld a, [wcf88]
	push af
	ld a, [MenuSelection]
	ld hl, Jumptable_e4ba
	rst JumpTable ;run appropriote function
	pop bc
	ld a, b
	jr nc, .asm_e44b
.asm_e46b
	call Function1c17
	ret
; e46f (3:646f)

MenuDataHeader_0xe46f: ; 0xe46f
	db $40 ; flags
	db 00, 00 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0xe477
	db 1 ; default option
; 0xe477

MenuData2_0xe477: ; 0xe477
	db $80 ; flags
	db 0 ; items
	dw MenuItems_e4c4
	dw Function1f79
	dw Strings_e47f
; 0xe47f

Strings_e47f: ; e47f
	db "WITHDRAW ", $e1, $e2, "@"
	db "DEPOSIT ", $e1, $e2, "@"
	db "CHANGE BOX@"
	db "MOVE ", $e1, $e2, " W/O MAIL@"
	db "SEE YA!@"
Jumptable_e4ba: ; e4ba (3:64ba)
	dw Functione559
	dw Functione4fe
	dw Functione583
	dw Functione4cd
	dw Functione4cb
; e4c4

MenuItems_e4c4: ; e4c4
	db 5
	db 0 ; WITHDRAW
	db 1;  DEPOSIT
	db 2 ; CHANGE BOX
	db 3 ; MOVE PKMN
	db 4 ; SEE YA!
	db -1
; e4cb

Functione4cb: ; e4cb
	scf
	ret
; e4cd

Functione4cd: ; e4cd
	call Function1d6e
	callba Function44781
	jr nc, .asm_e4e0
	ld hl, UnknownText_0xe4f9
	call PrintText
	jr .asm_e4f4

.asm_e4e0
	callba Function14b34
	jr c, .asm_e4f4
	callba Functione2759
	call Function222a
	call ClearPCItemScreen
.asm_e4f4
	call Function1c17
	and a
	ret
; e4f9

UnknownText_0xe4f9: ; 0xe4f9
	; There is a #MON holding MAIL. Please remove the MAIL.
	text_jump UnknownText_0x1c102b
	db "@"
; 0xe4fe

Functione4fe: ; e4fe (3:64fe)
	call Function1d6e
	callba Functione2391
	call Function222a
	call ClearPCItemScreen
	call Function1c17
	and a
	ret
; e512 (3:6512)

Functione512: ; e512
	ld a, [PartyCount]
	and a
	jr z, .asm_e51e
	cp 2
	jr c, .asm_e526
	and a
	ret

.asm_e51e
	ld hl, UnknownText_0xe52e
	call Function1d67
	scf
	ret

.asm_e526
	ld hl, UnknownText_0xe533
	call Function1d67
	scf
	ret
; e52e

UnknownText_0xe52e: ; 0xe52e
	; You don't have a single #MON!
	text_jump UnknownText_0x1c1062
	db "@"
; 0xe533

UnknownText_0xe533: ; 0xe533
	; You can't deposit your last #MON!
	text_jump UnknownText_0x1c1080
	db "@"
; 0xe538

Functione538: ; check party mons, return carry if it finds a mon other then current with non-0 HP.
	ld hl, PartyMon1HP ;load the location of the first mon in party's HP
	ld de, PartyMon2 - PartyMon1 ;find size of pokemon
	ld b, $0
.asm_e540
	ld a, [CurPartyMon]
	cp b
	jr z, .asm_e54b ;if on current mon then jump, this avoid checking if current mon is not fnt
	ld a, [hli]
	or [hl]
	jr nz, .asm_e557 ;if current HP is not zero, ret
	dec hl ;back to mon hp
.asm_e54b
	inc b
	ld a, [PartyCount]
	cp b
	jr z, .asm_e555 ;if party count = count, scf and jump out
	add hl, de ;to next mon
	jr .asm_e540 ;loop
.asm_e555
	scf
	ret

.asm_e557
	and a
	ret
; e559

Functione559: ; e559 (3:6559)
	call Function1d6e
	callba Functione2583
	call Function222a
	call ClearPCItemScreen
	call Function1c17
	and a
	ret
; e56d (3:656d)

Functione56d: ; e56d
	ld a, [PartyCount]
	cp PARTY_LENGTH
	jr nc, .asm_e576
	and a
	ret

.asm_e576
	ld hl, UnknownText_0xe57e
	call Function1d67
	scf
	ret
; e57e

UnknownText_0xe57e: ; 0xe57e
	; You can't take any more #MON.
	text_jump UnknownText_0x1c10a2
	db "@"
; 0xe583

Functione583: ; e583 (3:6583)
	callba Functione35aa
	and a
	ret

ClearPCItemScreen: ; e58b
	call Function2ed3 ;disables overworld sprite updating?
	xor a
	ld [hBGMapMode], a
	call WhiteBGMap
	call ClearSprites
	hlcoord 0, 0
	ld bc, 18 * 20 ;clear the screen exept for bottom 2 rows
	ld a, " "
	call ByteFill
	hlcoord 0,0
	ld bc, $0a12
	call TextBox
	hlcoord 0,12
	ld bc, $0412
	call TextBox
	call Function3200
	call Function32f9 ; load regular palettes?
	ret
; 0xe5bb

Functione5bb: ; e5bb
	ld a, [CurPartyMon]
	ld hl, sBoxMon1Species
	ld bc, $0020
	call AddNTimes
	ld de, TempMonSpecies
	ld bc, $0020
	ld a, $1
	call GetSRAMBank
	call CopyBytes
	call CloseSRAM
	ret
; e5d9

Functione5d9: ; e5d9
	ld a, [wCurBox]
	cp b
	jr z, .asm_e5f1
	ld a, b
	ld hl, Unknown_e66e
	ld bc, $0003
	call AddNTimes
	ld a, [hli]
	push af
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	jr .asm_e5f6

.asm_e5f1
	ld a, $1
	ld hl, sBoxCount
.asm_e5f6
	call GetSRAMBank
	ld a, [hl]
	ld bc, $0016
	add hl, bc
	ld b, a
	ld c, $0
	ld de, wc608
	ld a, b
	and a
	jr z, .asm_e66a
.asm_e608
	push hl
	push bc
	ld a, c
	ld bc, $0000
	add hl, bc
	ld bc, $0020
	call AddNTimes
	ld a, [hl]
	ld [de], a
	inc de
	ld [CurSpecies], a
	call GetBaseData
	pop bc
	pop hl
	push hl
	push bc
	ld a, c
	ld bc, $035c
	add hl, bc
	call SkipNames
	call CopyBytes
	pop bc
	pop hl
	push hl
	push bc
	ld a, c
	ld bc, $001f
	add hl, bc
	ld bc, $0020
	call AddNTimes
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	pop hl
	push hl
	push bc
	ld a, c
	ld bc, $0015
	add hl, bc
	ld bc, $0020
	call AddNTimes
	ld a, [hli]
	and $f0
	ld b, a
	ld a, [hl]
	and $f0
	swap a
	or b
	ld b, a
	ld a, [BaseGender]
	cp b
	ld a, $1
	jr c, .asm_e662
	xor a
.asm_e662
	ld [de], a
	inc de
	pop bc
	pop hl
	inc c
	dec b
	jr nz, .asm_e608
.asm_e66a
	call CloseSRAM
	ret
; e66e

Unknown_e66e: ; e66e
	dbw 2, $a000
	dbw 2, $a450
	dbw 2, $a8a0
	dbw 2, $acf0
	dbw 2, $b140
	dbw 2, $b590
	dbw 2, $b9e0
	dbw 3, $a000
	dbw 3, $a450
	dbw 3, $a8a0
	dbw 3, $acf0
	dbw 3, $b140
	dbw 3, $b590
	dbw 3, $b9e0
; e698

Functione698: ; e698
	ld hl, wBreedMon1Stats
	ld de, TempMon
	ld bc, $0020
	call CopyBytes
	callab Function50e1b
	ld a, [wBreedMon1Level]
	ld b, a
	ld a, d
	ld e, a
	sub b
	ld d, a
	ret
; e6b3

Functione6b3: ; e6b3
	ld hl, wBreedMon2Stats
	ld de, TempMon
	ld bc, $0020
	call CopyBytes
	callab Function50e1b
	ld a, [wBreedMon2Level]
	ld b, a
	ld a, d
	ld e, a
	sub b
	ld d, a
	ret
; e6ce

Functione6ce: ; e6ce
	ld a, [wdf9c]
	and a
	jr z, .asm_e6ea
	ld [wd265], a
	callba Functioncc0c7
	callba Functioncc000
	lb bc, 14, 7
	call PlaceYesNoBox
	ret c
.asm_e6ea
	call Functione6fd
	ld a, [TempEnemyMonSpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0xe71d
	call PrintText
	ret
; e6fd

Functione6fd: ; e6fd
	ld a, [TempEnemyMonSpecies]
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	call GetBaseData
	xor a
	ld bc, PartyMon2 - PartyMon1
	ld hl, wdf9c
	call ByteFill
	xor a
	ld [MonType], a
	ld hl, wdf9c
	jp Functiond906
; e71d

UnknownText_0xe71d: ; 0xe71d
	; Caught @ !
	text_jump UnknownText_0x1c10c0
	db "@"
; 0xe722

INCLUDE "items/item_effects.asm"

GetPokeBallWobble: ; f971 (3:7971)
; Returns whether a Poke Ball will wobble in the catch animation.
; Whether a Pokemon is caught is determined beforehand.

	push de
	ld a, [rSVBK]
	ld d, a
	push de
	ld a, 1 ; BANK(Buffer2)
	ld [rSVBK], a
	ld a, [Buffer2]
	inc a
	ld [Buffer2], a
; Wobble up to 3 times.

	cp 3 + 1
	jr z, .finished
	ld a, [wc64e]
	and a
	ld c, 0 ; next
	jr nz, .done
	ld hl, WobbleChances
	ld a, [Buffer1]
	ld b, a
.loop
	ld a, [hli]
	cp b
	jr nc, .checkwobble
	inc hl
	jr .loop

.checkwobble
	ld b, [hl]
	call Random
	cp b
	ld c, 0 ; next
	jr c, .done
	ld c, 2 ; escaped
	jr .done

.finished
	ld a, [wc64e]
	and a
	ld c, 1 ; caught
	jr nz, .done
	ld c, 2 ; escaped
.done
	pop de
	ld e, a
	ld a, d
	ld [rSVBK], a
	ld a, e
	pop de
	ret
; f9ba (3:79ba)

WobbleChances: ; f9ba
; catch rate, chance of wobbling / 255

	db   1,  63
	db   2,  75
	db   3,  84
	db   4,  90
	db   5,  95
	db   7, 103
	db  10, 113
	db  15, 126
	db  20, 134
	db  30, 149
	db  40, 160
	db  50, 169
	db  60, 177
	db  80, 191
	db 100, 201
	db 120, 211
	db 140, 220
	db 160, 227
	db 180, 234
	db 200, 240
	db 220, 246
	db 240, 251
	db 254, 253
	db 255, 255
; f9ea

KnowsMove: ; f9ea
	ld a, PartyMon1Moves - PartyMon1
	call GetPartyParamLocation
	ld a, [wd262]
	ld b, a
	ld c, NUM_MOVES
.asm_f9f5
	ld a, [hli]
	cp b
	jr z, .asm_f9fe
	dec c
	jr nz, .asm_f9f5
	and a
	ret

.asm_f9fe
	ld hl, UnknownText_0xfa06
	call PrintText
	scf
	ret
; fa06

UnknownText_0xfa06: ; 0xfa06
	; knows @ .
	text_jump UnknownText_0x1c5ea8
	db "@"
; 0xfa0b

SECTION "alive_party_mon", ROMX

CheckAlivePartyMon::
	push hl
	push de
	push bc
	ld a, [PartyCount]
	and a
	jr z, .nope
	ld e, a
	ld hl, PartyMon1HP
	ld bc, PartyMon2 - PartyMon1 - 1
.loop
	ld a, [hli]
	or [hl]
	jr nz, .yep
	add hl, bc
	dec e
	jr nz, .loop
.nope
	pop bc
	pop de
	pop hl
	and a
	ret
.yep
	pop bc
	pop de
	pop hl
	scf
	ret

SECTION "bank4", ROMX, BANK[$4]

INCLUDE "engine/pack.asm"

Function113d6: ; 113d6
	call Function114dd
	ret
; 113da

ResetDailyTimers: ; 113da
	xor a
	ld [wdc2d], a
	ld [wSSAnneTimerDaysLeft], a
	ld [wdc1c], a
	ret
; 113e5

Function113e5:: ; 113e5 ;set time until next phone call to 20 minutes
	xor a
	ld [wd464], a ;time since last call = 0
Function113e9: ; 113e9
	ld a, [wd464]
	cp 3
	jr c, .asm_113f2 ;if time since last call > 3, a equals 3, else a = time since last call
	ld a, 3
.asm_113f2
	ld e, a
	ld d, 0
	ld hl, .data_113fd
	add hl, de ;set
	ld a, [hl]
	jp Function1142e  ;load a into time until next call, and set last call to now
; 113fd

.data_113fd
	db 20, 10, 5, 3
; 11401

Function11401: ; 11401
	call Function1143c
	ret nc
	ld hl, wd464
	ld a, [hl]
	cp 3
	jr nc, .asm_1140e
	inc [hl]
.asm_1140e
	call Function113e9
	scf
	ret
; 11413

Function11413: ; 11413
	ld a, 1
Function11415: ; 11415
	ld [hl], a
	push hl
	call UpdateTime
	pop hl
	inc hl
	call Function11621
	ret
; 11420

Function11420: ; 11420
	inc hl
	push hl
	call Function115cf
	call Function115c8
	pop hl
	dec hl
	call Function11586
	ret
; 1142e

Function1142e: ; 1142e load a into time until next call, and set last call to now
	ld hl, wd465
	ld [hl], a ;time until next call
	call UpdateTime
	ld hl, wd466 ;hl = call delay start time
	call Function1162e ;load current time into it
	ret
; 1143c

Function1143c: ; 1143c
	ld hl, wd466
	call Function115d6
	call Function115ae
	ld hl, wd465
	call Function11586
	ret
; 1144c

Function1144c: ; 1144c
	ld hl, wdc1c
	jp Function11413
; 11452

Function11452:: ; 11452
	ld hl, wdc1c
	call Function11420
	ret nc
	callba DailyRoamMonUpdate
	xor a
	ld hl, DailyFlags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wdc4c
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wdc50
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wdc54
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wdc58
	ld a, [hl]
	and a
	jr z, .asm_11480
	dec [hl]
	jr nz, .asm_11483
.asm_11480
	call Function11485
.asm_11483
	jr Function1144c
; 11485

Function11485: ; 11485
	call Random
	and 3
	add 3
	ld [wdc58], a
	ret
; 11490

Function11490: ; 11490
	ld a, 20
	ld [wd46c], a ;load in bug catching timer
	ld a, $0
	ld [wd46d], a
	call UpdateTime
	ld hl, wdc35
	call Function11613 ;store the time in a variable
	ret
; 114a4

Function114a4:: ; 114a4 (4:54a4)
	ld hl, wdc35
	call Function115db
	ld a, [wcfd7]
	and a
	jr nz, .asm_114d4
	ld a, [wcfd6]
	and a
	jr nz, .asm_114d4
	ld a, [wcfd4]
	ld b, a
	ld a, [wd46d]
	sub b
	jr nc, .asm_114c2
	add $3c
.asm_114c2
	ld [wd46d], a
	ld a, [wcfd5]
	ld b, a
	ld a, [wd46c]
	sbc b
	ld [wd46c], a
	jr c, .asm_114d4
	and a
	ret

.asm_114d4
	xor a
	ld [wd46c], a
	ld [wd46d], a
	scf
	ret

Function114dd: ; 114dd
	call UpdateTime
	ld hl, wdc23
	call Function11621
	ret
; 114e7

Function114e7:: ; 114e7
	ld hl, wdc23
	call Function115cf
	call Function115c8
	and a
	jr z, .asm_114fa
	ld b, a
	callba ApplyPokerusTick
.asm_114fa
	xor a
	ret
; 114fc

StartSSAnneTimer:: ; 114fc
	ld hl, DailyFlags
	res 1, [hl]
	ld a, 1
	ld hl, wSSAnneTimerDaysLeft
	ld [hl], a
	call UpdateTime
	ld hl, wSSAnneTimerStartDay
	call Function11621
	ret
; 1150c

CheckSSAnneTimer:: ; 1150c
	ld hl, wSSAnneTimerStartDay
	call Function115cf
	call Function115c8
	ld hl, wSSAnneTimerDaysLeft
	call Function11586
	ret
; 1151c

DecrementSSAnneTimer::
	call CheckSSAnneTimer
	ret c
	ld hl, wSSAnneTimerDaysLeft
	dec [hl]
	ret nz
ExpireSSAnneTimer:: ; 1151c
	ld hl, DailyFlags
	set 1, [hl]
	ret
; 11522

CheckSSAnneTimerExpired: ; 11522
	and a
	ld hl, DailyFlags
	bit 1, [hl]
	ret nz
	scf
	ret
; 1152b

Function1152b: ; 1152b
	call Function11534
	ld hl, wdc2d
	jp Function11415
; 11534

Function11534: ; 11534
	call GetWeekday
	ld c, a
	ld a, $5
	sub c
	jr z, .asm_1153f
	jr nc, .asm_11541
.asm_1153f
	add $7
.asm_11541
	ret
; 11542

Function11542: ; 11542
	ld hl, wdc2d
	jp Function11420
; 11548

Function11548: ; 11548
	ld a, $0
	call GetSRAMBank
	ld hl, $abfa
	ld a, [hli]
	ld [Buffer1], a
	ld a, [hl]
	ld [Buffer2], a
	call CloseSRAM
	ld hl, Buffer1
	call Function11420
	jr nc, .asm_11572
	ld hl, Buffer1
	call Function11413
	call CloseSRAM
	callba Function1050c8
.asm_11572
	ld a, $0
	call GetSRAMBank
	ld hl, Buffer1
	ld a, [hli]
	ld [$abfa], a
	ld a, [hl]
	ld [$abfb], a
	call CloseSRAM
	ret
; 11586

Function11586: ; 11586
	cp $ff
	jr z, .asm_11595
	ld c, a
	ld a, [hl]
	sub c
	jr nc, .asm_11590
	xor a
.asm_11590
	ld [hl], a
	jr z, .asm_11595
	xor a
	ret

.asm_11595
	xor a
	ld [hl], a
	scf
	ret
; 11599

Function11599: ; 11599
	ld a, [wcfd7]
	and a
	jr nz, Function115cc
	ld a, [wcfd6]
	and a
	jr nz, Function115cc
	ld a, [wcfd5]
	jr nz, Function115cc
	ld a, [wcfd4]
	ret
; 115ae

Function115ae: ; 115ae
	ld a, [wcfd7]
	and a
	jr nz, Function115cc
	ld a, [wcfd6]
	and a
	jr nz, Function115cc
	ld a, [wcfd5]
	ret
; 115be

Function115be: ; 115be
	ld a, [wcfd7]
	and a
	jr nz, Function115cc
	ld a, [wcfd6]
	ret
; 115c8

Function115c8: ; 115c8
	ld a, [wcfd7]
	ret
; 115cc

Function115cc: ; 115cc
	ld a, $ff
	ret
; 115cf

Function115cf: ; 115cf
	xor a ;why, the very next line puts something in a
	jr Function11605
; 115d2

Function115d2: ; 115d2
	inc hl
	xor a
	jr Function115f8
; 115d6

Function115d6: ; 115d6
	inc hl
	inc hl
	xor a
	jr Function115eb
; 115db

Function115db: ; 115db
	inc hl
	inc hl
	inc hl
	ld a, [hSeconds]
	ld c, a
	sub [hl]
	jr nc, .asm_115e6
	add 60
.asm_115e6
	ld [hl], c
	dec hl
	ld [wcfd4], a
Function115eb: ; 115eb
	ld a, [hMinutes]
	ld c, a
	sbc [hl]
	jr nc, .asm_115f3
	add 60
.asm_115f3
	ld [hl], c
	dec hl
	ld [wcfd5], a
Function115f8: ; 115f8
	ld a, [hHours]
	ld c, a
	sbc [hl]
	jr nc, .asm_11600
	add 24
.asm_11600
	ld [hl], c
	dec hl
	ld [wcfd6], a
Function11605
	ld a, [CurDay]
	ld c, a ;load current day?
	sbc [hl]
	jr nc, .asm_1160e
	add 140 ; 20 weeks
.asm_1160e
	ld [hl], c
	ld [wcfd7], a
	ret
; 11613

Function11613: ; 11613
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ld a, [hSeconds]
	ld [hli], a
	ret
; 11621

Function11621: ; 11621
	ld a, [CurDay]
	ld [hl], a
	ret
; 11626

Function11626: ; 11626
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ret
; 1162e

Function1162e: ; 1162e
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ret
; 11639

CanLearnTMHMMove: ; 11639
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld hl, BaseTMHM
	push hl
	ld a, [wd262]
	ld b, a
	ld c, 0
	ld hl, TMHMMoves
.loop
	ld a, [hli]
	and a
	jr z, .end
	cp b
	jr z, .asm_11659
	inc c
	jr .loop

.asm_11659
	pop hl
	ld b, CHECK_FLAG
	push de
	ld d, 0
	predef FlagPredef
	pop de
	ret

.end
	pop hl
	ld c, 0
	ret
; 1166a

GetTMHMMove: ; 1166a
	ld a, [wd265]
	dec a
	ld hl, TMHMMoves
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	ret
; 1167a

TMHMMoves: ; 1167a
	db DYNAMICPUNCH
	db ZEN_HEADBUTT
	db CURSE
	db BODY_SLAM
	db DAZZLINGLEAM
	db TOXIC
	db ZAP_CANNON
	db ROCK_SMASH
	db FOCUS_BLAST
	db HIDDEN_POWER
	db SUNNY_DAY
	db EARTH_POWER
	db WILLOWISP
	db BLIZZARD
	db HYPER_BEAM
	db ICY_WIND
	db PROTECT
	db RAIN_DANCE
	db GIGA_DRAIN
	db FLARE_BLITZ
	db WILD_CHARGE
	db SOLARBEAM
	db FLASH_CANNON
	db DRAGON_PULSE
	db THUNDER
	db EARTHQUAKE
	db RETURN
	db DIG
	db PSYCHIC_M
	db SHADOW_BALL
	db SKY_ATTACK
	db DOUBLE_TEAM
	db SHADOW_CLAW
	db SWAGGER
	db SLEEP_TALK
	db SLUDGE_BOMB
	db SANDSTORM
	db FIRE_BLAST
	db GUNK_SHOT
	db SEISMIC_TOSS
	db SWORDS_DANCE
	db STRING_SHOT
	db DARK_PULSE
	db REST
	db ATTRACT
	db THIEF
	db THUNDER_WAVE
	db ROCK_SLIDE
	db FURY_CUTTER
	db SUBSTITUTE
	db CUT
	db FLY
	db SURF
	db STRENGTH
	db FLASH
	db WHIRLPOOL
	db WATERFALL
; Move tutor

	db FLAMETHROWER
	db THUNDERBOLT
	db ICE_BEAM
	db ICE_PUNCH
	db THUNDERPUNCH
	db FIRE_PUNCH
	db FALSE_SWIPE
	db 0 ; end
; 116b7

Function116b7: ; 0x116b7
	call Function2ed3
	call NamingScreen
	call Function2b74
	ret
; 0x116c1

NamingScreen: ; 116c1
	ld hl, wc6d0
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wc6d4
	ld [hl], b
	xor a
	ld [wc6da], a
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call Function116f8
	call DelayFrame
.asm_116e5
	call Function11915
	jr nc, .asm_116e5
	pop af
	ld [$ffaa], a
	pop af
	ld [$ffde], a
	pop af
	ld [Options], a
	call ClearJoypad
	ret
; 116f8

Function116f8: ; 116f8
	call WhiteBGMap
	ld b, $8
	call GetSGBLayout
	call DisableLCD
	call Function11c51
	call Function118a8
	ld a, $e3
	ld [rLCDC], a
	call Function1171d
	call WaitBGMap
	call WaitTop
	call Function32f9
	call Function11be0
	ret
; 1171d

Function1171d: ; 1171d
	ld a, [wc6d4]
	and 15
	cp 10
	jr c, .ok
	xor a
.ok
	ld e, a
	ld d, 0
	ld hl, Jumptable_1172e
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 1172e

Jumptable_1172e: ; 1172e (4:572e)
	dw Function1173e
	dw Function1178d
	dw Function117ae
	dw Function117d1
	dw Function117f5
	dw Function1182c
	dw Function1173e
	dw Function1173e
	dw RivalNamingScreenRB
	dw DistCodeEntry

Function1173e: ; 1173e (4:573e)
	ld a, [CurPartySpecies]
	ld [wd265], a
	ld hl, Function8e83f
	ld a, BANK(Function8e83f)
	ld e, $1
	rst FarCall ;  ; indirect jump to Function8e83f (8e83f (23:683f))
	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	hlcoord 5, 2
	call PlaceString
	ld l, c
	ld h, b
	ld de, Strings_11780
	call PlaceString
	inc de
	hlcoord 5, 4
	call PlaceString
	callba GetGender
	jr c, .asm_1177c
	ld a, $ef
	jr nz, .asm_11778
	ld a, $f5
.asm_11778
	hlcoord 1, 2
	ld [hl], a
.asm_1177c
	call Function1187b
	ret
; 11780 (4:5780)

Strings_11780: ; 11780
	db "'S@"
	db "NICKNAME?@"
; 1178d

Function1178d: ; 1178d (4:578d)
	callba GetPlayerIcon
	call Function11847
	hlcoord 5, 2
	ld de, String_117a3
	call PlaceString
	call Function11882
	ret
; 117a3 (4:57a3)

String_117a3: ; 117a3
	db "YOUR NAME?@"
; 117ae

Function117ae: ; 117ae (4:57ae)
	ld de, SilverSpriteGFX
	ld b, BANK(SilverSpriteGFX)
	call Function11847
	hlcoord 5, 2
	ld de, String_117c3
	call PlaceString
	call Function11882
	ret
; 117c3 (4:57c3)

RivalNamingScreenRB: ; 117ae (4:57ae)
	callba GetRivalRBIcon
	call Function11847
	hlcoord 5, 2
	ld de, String_117c3
	call PlaceString
	call Function11882
	ret

String_117c3: ; 117c3
	db "RIVAL'S NAME?@"
; 117d1

DistCodeEntry:
	hlcoord 5, 2
	ld de, .String
	call PlaceString
	call StoreDistCodeEntryParams
	ret
.String:
	db "ENTER CODE@"

Function117d1: ; 117d1 (4:57d1)
	ld de, MomSpriteGFX
	ld b, BANK(MomSpriteGFX)
	call Function11847
	hlcoord 5, 2
	ld de, String_117e6
	call PlaceString
	call Function11882
	ret
; 117e6 (4:57e6)

String_117e6: ; 117e6
	db "MOTHER'S NAME?@"
; 117f5

Function117f5: ; 117f5 (4:57f5)
	ld de, PokeBallSpriteGFX
	ld hl, $8000
	lb bc, BANK(PokeBallSpriteGFX), $4
	call Request2bpp
	xor a
	ld hl, wc300
	ld [hli], a
	ld [hl], a
	ld de, $2420
	ld a, $a
	call Function3b2a
	ld hl, $1
	add hl, bc
	ld [hl], $0
	hlcoord 5, 2
	ld de, String_11822
	call PlaceString
	call Function11889
	ret
; 11822 (4:5822)

String_11822: ; 11822
	db "BOX NAME?@"
; 1182c

Function1182c: ; 1182c (4:582c)
	hlcoord 3, 2
	ld de, String_11839
	call PlaceString
	call Function11882
	ret
; 11839 (4:5839)

String_11839: ; 11839
	db "FRIEND'S NAME?@"
; 11847

Function11847: ; 11847 (4:5847)
	push de
	ld hl, $8000
	ld c, $4
	push bc
	call Request2bpp
	pop bc
	ld hl, $c0
	add hl, de
	ld e, l
	ld d, h
	ld hl, $8040
	call Request2bpp
	xor a
	ld hl, wc300
	ld [hli], a
	ld [hl], a
	pop de
	ld b, $a
	ld a, d
	cp KrisSpriteGFX / $100
	jr nz, .asm_11873
	ld a, e
	cp KrisSpriteGFX % $100
	jr nz, .asm_11873
	ld b, $1e
.asm_11873
	ld a, b
	ld de, $2420
	call Function3b2a
	ret

Function1187b: ; 1187b (4:587b)
	ld a, $a
	hlcoord 5, 6
	jr Function11890

StoreDistCodeEntryParams:
	ld a, $8
	hlcoord 5, 4
	jr Function11890

Function11882: ; 11882 (4:5882)
	ld a, $7
	hlcoord 5, 6
	jr Function11890

Function11889: ; 11889 (4:5889)
	ld a, $8
	hlcoord 5, 4
Function11890: ; 11890 (4:5890)
	ld [wc6d3], a
	ld a, l
	ld [wc6d8], a
	ld a, h
	ld [wc6d9], a
	ret

NamingScreen_IsTargetBox: ; 1189c
	push bc
	push af
	ld a, [wc6d4]
	sub $3
	ld b, a
	pop af
	dec b
	jr z, .boxscreen
	push af
	ld a, [wc6d4]
	sub $8
	ld b, a
	pop af
	dec b
.boxscreen
	pop bc
	ret
; 118a8

Function118a8: ; 118a8
	call WaitTop
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $60
	call ByteFill
	hlcoord 1, 1
	ld bc, $0612
	call NamingScreen_IsTargetBox
	jr nz, .asm_118c4
	ld bc, $0412
.asm_118c4
	call ClearBox
	ld de, NameInputUpper
NamingScreen_ApplyTextInputMode: ; 118ca
	call NamingScreen_IsTargetBox
	jr nz, .asm_118d5
	ld hl, BoxNameInputLower - NameInputLower
	add hl, de
	ld d, h
	ld e, l
.asm_118d5
	push de
	hlcoord 1, 8
	ld bc, $0712
	call NamingScreen_IsTargetBox
	jr nz, .asm_118e7
	hlcoord 1, 6
	ld bc, $0912
.asm_118e7
	call ClearBox
	hlcoord 1, 16
	ld bc, $0112
	call ClearBox
	pop de
	hlcoord 2, 8
	ld b, $5
	call NamingScreen_IsTargetBox
	jr nz, .asm_11903
	hlcoord 2, 6
	ld b, $6
.asm_11903
	ld c, $11
.asm_11905
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_11905
	push de
	ld de, $0017
	add hl, de
	pop de
	dec b
	jr nz, .asm_11903
	ret
; 11915

Function11915: ; 11915
	call Functiona57
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_11930
	call Function11968
	callba Function8cf62
	call Function11940
	call DelayFrame
	and a
	ret

.asm_11930
	callab Function8cf53
	call ClearSprites
	xor a
	ld [hSCX], a
	ld [hSCY], a
	scf
	ret
; 11940

Function11940: ; 11940
	xor a
	ld [hBGMapMode], a
	hlcoord 1, 5
	call NamingScreen_IsTargetBox
	jr nz, .asm_1194e
	hlcoord 1, 3
.asm_1194e
	ld bc, $0112
	call ClearBox
	ld hl, wc6d0
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wc6d8
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	ret
; 11968

Function11968: ; 11968
	ld a, [wcf63]
	ld e, a
	ld d, $0
	ld hl, Jumptable_11977
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 11977

Jumptable_11977: ; 11977 (4:5977)
	dw .InitCursor
	dw .ReadButtons

.InitCursor: ; 1197b (4:597b)
	lb de, $50, $18
	call NamingScreen_IsTargetBox
	jr nz, .asm_11985
	ld d, $40
.asm_11985
	ld a, $2
	call Function3b2a
	ld a, c
	ld [wc6d5], a
	ld a, b
	ld [wc6d6], a
	ld hl, $1
	add hl, bc
	ld a, [hl]
	ld hl, $e
	add hl, bc
	ld [hl], a
	ld hl, wcf63
	inc [hl]
	ret

.ReadButtons: ; 119a1 (4:59a1)
	ld hl, hJoyPressed ; $ffa7
	ld a, [hl]
	and A_BUTTON
	jr nz, .a
	ld a, [hl]
	and B_BUTTON
	jr nz, .b
	ld a, [hl]
	and START
	jr nz, .start
	ld a, [hl]
	and SELECT
	jr nz, .select
	ret

.a
	call .GetCursorPosition
	cp $1
	jr z, .select
	cp $2
	jr z, .b
	cp $3
	jr z, .end
	call NamingScreen_GetLastCharacer
	call NamingScreen_TryAddCharacer
	ret nc
	
.start
	ld hl, wc6d5
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $c
	add hl, bc
	ld [hl], $8
	ld hl, $d
	add hl, bc
	ld [hl], $4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

.b
	call NamingScreen_DeleteCharacter
	ret

.end
	call NamingScreen_StoreEntry
	ld hl, wcf63
	set 7, [hl]
	ret

.select
	; ld hl, wc6da
	; bit 0, [hl]
	; res 0, [hl]
	ld hl, wcf64
	; jr nz, .bit0
	ld a, [hl]
	xor 1
	ld [hl], a
	jr z, .set_upper
	; jr .set_lower
; .bit0
	; ld a, [hl]
	; and a
	; jr z, .set_upper

; .set_lower
	ld de, NameInputLower
	call NamingScreen_ApplyTextInputMode
	ret

.set_upper
	ld de, NameInputUpper
	call NamingScreen_ApplyTextInputMode
	ret


.upper_str
	db $61, "UPPER@"

.GetCursorPosition: ; 11a0b (4:5a0b)
	ld hl, wc6d5
	ld c, [hl]
	inc hl
	ld b, [hl]
NamingScreen_GetCursorPosition: ; 11a11 (4:5a11)
	ld hl, $d
	add hl, bc
	ld a, [hl]
	push bc
	ld b, $4
	call NamingScreen_IsTargetBox
	jr nz, .not_box
	inc b
.not_box
	cp b
	pop bc
	jr nz, .not_bottom_row
	ld hl, $c
	add hl, bc
	ld a, [hl]
	cp $3
	jr c, .case_switch
	cp $6
	jr c, .delete
	ld a, $3
	ret

.case_switch
	ld a, $1
	ret

.delete
	ld a, $2
	ret

.not_bottom_row
	xor a
	ret

Function11a3b: ; 11a3b (4:5a3b)
	call Function11a8b
	ld hl, $d
	add hl, bc
	ld a, [hl]
	ld e, a
	swap e
	ld hl, $7
	add hl, bc
	ld [hl], e
	ld d, $4
	call NamingScreen_IsTargetBox
	jr nz, .asm_11a53
	inc d
.asm_11a53
	cp d
	ld de, Unknown_11a79
	ld a, $0
	jr nz, .asm_11a60
	ld de, Unknown_11a82
	ld a, $1
.asm_11a60
	ld hl, $e
	add hl, bc
	add [hl]
	ld hl, $1
	add hl, bc
	ld [hl], a
	ld hl, $c
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, de
	ld a, [hl]
	ld hl, $6
	add hl, bc
	ld [hl], a
	ret
; 11a79 (4:5a79)

Unknown_11a79: ; 11a79
	db $00, $10, $20, $30, $40, $50, $60, $70, $80
Unknown_11a82: ; 11a82
	db $00, $00, $00, $30, $30, $30, $60, $60, $60
; 11a8b

Function11a8b: ; 11a8b (4:5a8b)
	ld hl, $ffa9
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	ld a, [hl]
	and D_LEFT
	jr nz, .left
	ld a, [hl]
	and D_RIGHT
	jr nz, .right
	ret

.right
	call NamingScreen_GetCursorPosition
	and a
	jr nz, .asm_11ab7
	ld hl, $c
	add hl, bc
	ld a, [hl]
	cp $8
	jr nc, .asm_11ab4
	inc [hl]
	ret

.asm_11ab4
	ld [hl], $0
	ret

.asm_11ab7
	cp $3
	jr nz, .asm_11abc
	xor a
.asm_11abc
	ld e, a
	add a
	add e
	ld hl, $c
	add hl, bc
	ld [hl], a
	ret

.left
	call NamingScreen_GetCursorPosition
	and a
	jr nz, .asm_11ad8
	ld hl, $c
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_11ad5
	dec [hl]
	ret

.asm_11ad5
	ld [hl], $8
	ret

.asm_11ad8
	cp $1
	jr nz, .asm_11ade
	ld a, $4
.asm_11ade
	dec a
	dec a
	ld e, a
	add a
	add e
	ld hl, $c
	add hl, bc
	ld [hl], a
	ret

.down
	ld hl, $d
	add hl, bc
	ld a, [hl]
	call NamingScreen_IsTargetBox
	jr nz, .asm_11af9
	cp $5
	jr nc, .asm_11aff
	inc [hl]
	ret

.asm_11af9
	cp $4
	jr nc, .asm_11aff
	inc [hl]
	ret

.asm_11aff
	ld [hl], $0
	ret

.up
	ld hl, $d
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_11b0c
	dec [hl]
	ret

.asm_11b0c
	ld [hl], $4
	call NamingScreen_IsTargetBox
	ret nz
	inc [hl]
	ret

NamingScreen_TryAddCharacer: ; 11b14 (4:5b14)
	ld a, [wc6d7]
Function11b17: ; 11b17 (4:5b17)
	ld a, [wc6d3]
	ld c, a
	ld a, [wc6d2]
	cp c
	ret nc
	ld a, [wc6d7]
Function11b23: ; 11b23
	call Function11bd0
	ld [hl], a
Function11b27: ; 11b27
	ld hl, wc6d2
	inc [hl]
	call Function11bd0
	ld a, [hl]
	cp $50
	jr z, .asm_11b37
	ld [hl], $f2
	and a
	ret

.asm_11b37
	scf
	ret
; 11b39 (4:5b39)

Function11b39: ; 11b39
	ld a, [wc6d2]
	and a
	ret z
	push hl
	ld hl, wc6d2
	dec [hl]
	call Function11bd0
	ld c, [hl]
	pop hl
.asm_11b48
	ld a, [hli]
	cp $ff
	jr z, Function11b27
	cp c
	jr z, .asm_11b53
	inc hl
	jr .asm_11b48

.asm_11b53
	ld a, [hl]
	jr Function11b23
; 11b56

Dakutens: ; 11b56
	db "かが", "きぎ", "くぐ", "けげ", "こご"
	db "さざ", "しじ", "すず", "せぜ", "そぞ"
	db "ただ", "ちぢ", "つづ", "てで", "とど"
	db "はば", "ひび", "ふぶ", "へべ", "ほぼ"
	db "カガ", "キギ", "クグ", "ケゲ", "コゴ"
	db "サザ", "シジ", "スズ", "セゼ", "ソゾ"
	db "タダ", "チヂ", "ツヅ", "テデ", "トド"
	db "ハバ", "ヒビ", "フブ", "へべ", "ホボ"
	db $ff
Handakutens: ; 11ba7
	db "はぱ", "ひぴ", "ふぷ", "へぺ", "ほぽ"
	db "ハパ", "ヒピ", "フプ", "へぺ", "ホポ"
	db $ff
; 11bbc

NamingScreen_DeleteCharacter: ; 11bbc (4:5bbc)
	ld hl, wc6d2
	ld a, [hl]
	and a
	ret z
	dec [hl]
	call Function11bd0
	ld [hl], $f2
	inc hl
	ld a, [hl]
	cp $f2
	ret nz
	ld [hl], $eb
	ret

Function11bd0: ; 11bd0 (4:5bd0)
	push af
	ld hl, wc6d0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wc6d2]
	ld e, a
	ld d, 0
	add hl, de
	pop af
	ret
; 11be0

Function11be0: ; 11be0
	ld hl, wc6d0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $f2
	inc hl
	ld a, [wc6d3]
	dec a
	ld c, a
	ld a, $eb
.asm_11bf0
	ld [hli], a
	dec c
	jr nz, .asm_11bf0
	ld [hl], $50
	ret
; 11bf7

NamingScreen_StoreEntry: ; 11bf7 (4:5bf7)
	ld hl, wc6d0
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wc6d3]
	ld c, a
.asm_11c01
	ld a, [hl]
	cp $eb
	jr z, .asm_11c0a
	cp $f2
	jr nz, .asm_11c0c
.asm_11c0a
	ld [hl], $50
.asm_11c0c
	inc hl
	dec c
	jr nz, .asm_11c01
	ret

NamingScreen_GetLastCharacer: ; 11c11 (4:5c11)
	ld hl, wc6d5
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $6
	add hl, bc
	ld a, [hl]
	ld hl, $4
	add hl, bc
	add [hl]
	sub $8
	srl a
	srl a
	srl a
	ld e, a
	ld hl, $7
	add hl, bc
	ld a, [hl]
	ld hl, $5
	add hl, bc
	add [hl]
	sub $10
	srl a
	srl a
	srl a
	ld d, a
	hlcoord 0, 0
	ld bc, $14
.asm_11c43
	ld a, d
	and a
	jr z, .asm_11c4b
	add hl, bc
	dec d
	jr .asm_11c43

.asm_11c4b
	add hl, de
	ld a, [hl]
	ld [wc6d7], a
	ret

Function11c51: ; 11c51
	call ClearSprites
	callab Function8cf53
	call Functione51
	call Functione5f
	ld de, GFX_11e65
	ld hl, $8eb0
	lb bc, BANK(GFX_11e65), 1
	call Get1bpp
	ld de, GFX_11e6d
	ld hl, $8f20
	lb bc, BANK(GFX_11e6d), 1
	call Get1bpp
	ld de, $9600
	ld hl, GFX_11cb7
	ld bc, $10
	ld a, BANK(GFX_11cb7)
	call FarCopyBytes
	ld de, $87e0
	ld hl, GFX_11cc7
	ld bc, $20
	ld a, BANK(GFX_11cc7)
	call FarCopyBytes
	ld a, $5
	ld hl, wc312
	ld [hli], a
	ld [hl], $7e
	xor a
	ld [hSCY], a
	ld [wc3bf], a
	ld [hSCX], a
	ld [wc3c0], a
	ld [wcf63], a
	ld [wcf64], a
	ld [hBGMapMode], a
	ld [wc6d2], a
	ld a, $7
	ld [hWX], a
	ret
; 11cb7

GFX_11cb7: ; 11cb7
INCBIN "gfx/unknown/011cb7.2bpp"
; 11cc7

GFX_11cc7: ; 11cc7
INCBIN "gfx/unknown/011cc7.2bpp"
; 11ce7

NameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "× ( ) : ; [ ] ", $e1, " ", $e2
	db "UPPER  DEL   END "
BoxNameInputLower:
	db "a b c d e f g h i"
	db "j k l m n o p q r"
	db "s t u v w x y z  "
	db "é 'd 'l 'm 'r 's 't 'v 0"
	db "1 2 3 4 5 6 7 8 9"
	db "UPPER  DEL   END "
NameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "- ? ! / . ,      "
	db "lower  DEL   END "
BoxNameInputUpper:
	db "A B C D E F G H I"
	db "J K L M N O P Q R"
	db "S T U V W X Y Z  "
	db "× ( ) : ; [ ] ", $e1, " ", $e2
	db "- ? ! ♂ ♀ / . , &"
	db "lower  DEL   END "
; 11e5d

GFX_11e5d: ; 11e5d
INCBIN "gfx/unknown/011e5d.2bpp"
; 11e6d

GFX_11e65:
INCBIN "gfx/unknown/011e65.2bpp"
; 11e6d

GFX_11e6d: ; 11e6d
INCBIN "gfx/unknown/011e6d.2bpp"
; 11e75

Function11e75: ; 11e75 (4:5e75)
	ld hl, wc6d0
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call Function11e9a
	call DelayFrame
.asm_11e8e
	call Function11fc0
	jr nc, .asm_11e8e
	pop af
	ld [$ffaa], a
	pop af
	ld [$ffde], a
	ret

Function11e9a: ; 11e9a (4:5e9a)
	call WhiteBGMap
	call DisableLCD
	call Function11c51
	ld de, $8000
	ld hl, GFX_11ef4
	ld bc, $80
	ld a, BANK(GFX_11ef4)
	call FarCopyBytes
	xor a
	ld hl, wc300
	ld [hli], a
	ld [hl], a
	ld de, $1810
	ld a, $0
	call Function3b2a
	ld hl, $2
	add hl, bc
	ld [hl], $0
	call Function11f84
	ld a, $e3
	ld [rLCDC], a ; $ff00+$40
	call Function11f74
	ld b, $8
	call GetSGBLayout
	call WaitBGMap
	call WaitTop
	ld a, $e4
	call DmgToCgbBGPals
	ld a, $e4
	call Functioncf8
	call Function11be0
	ld hl, wc6d0
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $10
	add hl, de
	ld [hl], $4e
	ret
; 11ef4 (4:5ef4)

GFX_11ef4: ; 11ef4
INCBIN "gfx/unknown/011ef4.2bpp"
; 11f74

Function11f74: ; 11f74 (4:5f74)
	ld a, $21
	ld [wc6d3], a
	ret
; 11f7a (4:5f7a)

String_11f7a: ; 11f7a
	db "メールを かいてね@"
; 11f84

Function11f84: ; 11f84 (4:5f84)
	call WaitTop
	hlcoord 0, 0
	ld bc, $78
	ld a, $60
	call ByteFill
	hlcoord 0, 6
	ld bc, $f0
	ld a, $7f
	call ByteFill
	hlcoord 1, 1
	ld bc, $412
	call ClearBox
	ld de, String_121dd
Function11fa9: ; 11fa9 (4:5fa9)
	hlcoord 1, 7
	ld b, $6
.asm_11fae
	ld c, $13
.asm_11fb0
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_11fb0
	push de
	ld de, $15
	add hl, de
	pop de
	dec b
	jr nz, .asm_11fae
	ret

Function11fc0: ; 11fc0 (4:5fc0)
	call Functiona57
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_11fdb
	call Function12008
	callba Function8cf62
	call Function11feb
	call DelayFrame
	and a
	ret

.asm_11fdb
	callab Function8cf53
	call ClearSprites
	xor a
	ld [hSCX], a ; $ff00+$cf
	ld [hSCY], a ; $ff00+$d0
	scf
	ret

Function11feb: ; 11feb (4:5feb)
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	hlcoord 1, 1
	ld bc, $412
	call ClearBox
	ld hl, wc6d0
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 2, 2
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	ret

Function12008: ; 12008 (4:6008)
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_12017
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_12017: ; 12017 (4:6017)
	dw Function1201b
	dw Function1203a

Function1201b: ; 1201b (4:601b)
	lb de, $48, $10
	ld a, $9
	call Function3b2a
	ld a, c
	ld [wc6d5], a
	ld a, b
	ld [wc6d6], a
	ld hl, $1
	add hl, bc
	ld a, [hl]
	ld hl, $e
	add hl, bc
	ld [hl], a
	call MailRandomizeCursor
	ld hl, wcf63
	inc [hl]
	ret

Function1203a: ; 1203a (4:603a)
	ld hl, hJoyPressed ; $ffa7
	ld a, [hl]
	and A_BUTTON
	jr nz, .a
	ld a, [hl]
	and B_BUTTON
	jr nz, .b
	; ld a, [hl]
	; and START
	; jr nz, .start
	ld a, [hl]
	and SELECT
	jr nz, .select
	ret

.a
	call Function12185
	cp $1
	jr z, .select
	cp $2
	jr z, .b
	cp $3
	jr z, .asm_120a1
	call NamingScreen_GetLastCharacer
	call Function121ac
	jr c, .start
	ld hl, wc6d2
	ld a, [hl]
	cp $10
	ret nz
	inc [hl]
	call Function11bd0
	ld [hl], $f2
	dec hl
	ld [hl], $4e
	ret

.start
	ld hl, wc6d5
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $c
	add hl, bc
	ld [hl], $9
	ld hl, $d
	add hl, bc
	ld [hl], $5
	ret

.b
	call NamingScreen_DeleteCharacter
	ld hl, wc6d2
	ld a, [hl]
	cp $10
	ret nz
	dec [hl]
	call Function11bd0
	ld [hl], $f2
	inc hl
	ld [hl], $4e
	ret

.asm_120a1
	call NamingScreen_StoreEntry
	ld hl, wcf63
	set 7, [hl]
	ret

.select
	ld hl, wcf64
	ld a, [hl]
	xor $1
	ld [hl], a
	jr nz, .asm_120ba
	ld de, String_121dd
	call Function11fa9
	ret

.asm_120ba
	ld de, String_1224f
	call Function11fa9
	ret

Function120c1: ; 120c1 (4:60c1)
	call Function1210c
	ld hl, $d
	add hl, bc
	ld a, [hl]
	ld e, a
	swap e
	ld hl, $7
	add hl, bc
	ld [hl], e
	cp $5
	ld de, Unknown_120f8
	ld a, $0
	jr nz, .asm_120df
	ld de, Unknown_12102
	ld a, $1
.asm_120df
	ld hl, $e
	add hl, bc
	add [hl]
	ld hl, $1
	add hl, bc
	ld [hl], a
	ld hl, $c
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, de
	ld a, [hl]
	ld hl, $6
	add hl, bc
	ld [hl], a
	ret
; 120f8 (4:60f8)

Unknown_120f8: ; 120f8
	db $00, $10, $20, $30, $40, $50, $60, $70, $80, $90
Unknown_12102: ; 12102
	db $00, $00, $00, $30, $30, $30, $60, $60, $60, $60
; 1210c

Function1210c: ; 1210c (4:610c)
	ld hl, $ffa9
	ld a, [hl]
	and D_UP
	jr nz, .up
	ld a, [hl]
	and D_DOWN
	jr nz, .down
	ld a, [hl]
	and D_LEFT
	jr nz, .left
	ld a, [hl]
	and D_RIGHT
	jr nz, .right
	ret

.right
	call Function1218b
	and a
	jr nz, .asm_12138
	ld hl, $c
	add hl, bc
	ld a, [hl]
	cp $9
	jr nc, .asm_12135
	inc [hl]
	ret

.asm_12135
	ld [hl], $0
	ret

.asm_12138
	cp $3
	jr nz, .asm_1213d
	xor a
.asm_1213d
	ld e, a
	add a
	add e
	ld hl, $c
	add hl, bc
	ld [hl], a
	ret

.left
	call Function1218b
	and a
	jr nz, .asm_12159
	ld hl, $c
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_12156
	dec [hl]
	ret

.asm_12156
	ld [hl], $9
	ret

.asm_12159
	cp $1
	jr nz, .asm_1215f
	ld a, $4
.asm_1215f
	dec a
	dec a
	ld e, a
	add a
	add e
	ld hl, $c
	add hl, bc
	ld [hl], a
	ret

.down
	ld hl, $d
	add hl, bc
	ld a, [hl]
	cp $5
	jr nc, .asm_12175
	inc [hl]
	ret

.asm_12175
	ld [hl], $0
	ret

.up
	ld hl, $d
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_12182
	dec [hl]
	ret

.asm_12182
	ld [hl], $5
	ret

Function12185: ; 12185 (4:6185)
	ld hl, wc6d5
	ld c, [hl]
	inc hl
	ld b, [hl]
Function1218b: ; 1218b (4:618b)
	ld hl, $d
	add hl, bc
	ld a, [hl]
	cp $5
	jr nz, .asm_121aa
	ld hl, $c
	add hl, bc
	ld a, [hl]
	cp $3
	jr c, .asm_121a4
	cp $6
	jr c, .asm_121a7
	ld a, $3
	ret

.asm_121a4
	ld a, $1
	ret

.asm_121a7
	ld a, $2
	ret

.asm_121aa
	xor a
	ret

Function121ac: ; 121ac (4:61ac)
	ld a, [wc6d7]
	jp Function11b17
; 121b2 (4:61b2)

Function121b2: ; 121b2
	ld a, [wc6d2]
	and a
	ret z
	cp $11
	jr nz, .asm_121c3
	push hl
	ld hl, wc6d2
	dec [hl]
	dec [hl]
	jr .asm_121c8

.asm_121c3
	push hl
	ld hl, wc6d2
	dec [hl]
.asm_121c8
	call Function11bd0
	ld c, [hl]
	pop hl
.asm_121cd
	ld a, [hli]
	cp $ff
	jp z, Function11b27
	cp c
	jr z, .asm_121d9
	inc hl
	jr .asm_121cd

.asm_121d9
	ld a, [hl]
	jp Function11b23
; 121dd

String_121dd: ; 122dd
	db "A B C D E F G H I J"
	db "K L M N O P Q R S T"
	db "U V W X Y Z , ? !  "
	db "1 2 3 4 5 6 7 8 9 0"
	db "<PK> <MN> <PO> <KE> é ♂ ♀ ¥ <...> ×"
	db "lower  DEL   END   "
; 1224f

String_1224f: ; 1224f
	db "a b c d e f g h i j"
	db "k l m n o p q r s t"
	db "u v w x y z   . - /"
	db "'d 'l 'm 'r 's 't 'v & ( )"
	db "<``> <''> [ ] ' : ;      "
	db "UPPER  DEL   END   "
; 122c1

MailRandomizeCursor:
.row_loop
	call Random
	and $7
	cp 5
	jr nc, .row_loop
	ld hl, $d
	add hl, bc
	ld [hl], a
	swap a
	ld hl, $7
	add hl, bc
	ld [hl], a
.col_loop
	call Random
	and $f
	cp 9
	jr nc, .col_loop
	ld hl, $c
	add hl, bc
	ld [hl], a
	swap a
	ld hl, $6
	add hl, bc
	ld [hl], a
	ret

UnknownScript_0x122c1: ; 0x122c1
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .script_122cd
	setflag ENGINE_51
	special Function13a31
.script_122cd
	end
; 0x122ce

UnknownScript_0x122ce:: ; 0x122ce
	callasm Function122f8
	iffalse UnknownScript_0x122e3
	disappear $fe
	loadfont
	copybytetovar wd10c
	if_greater_than 1, .GetMultipleItems
	writetext UnknownText_0x122ee
	playsound SFX_ITEM
	pause 60
	itemnotify
	closetext
	end
; 0x122e3

.GetMultipleItems
	writetext FoundMultipleText
	playsound SFX_ITEM
	pause 60
	itemnotify
	closetext
	end

UnknownScript_0x122e3: ; 0x122e3
	loadfont
	copybytetovar wd10c
	if_greater_than 1, .DontGetMultipleItems
	writetext UnknownText_0x122ee
	waitbutton
	writetext UnknownText_0x122f3
	waitbutton
	closetext
	end
; 0x122ee

.DontGetMultipleItems
	writetext FoundMultipleText
	waitbutton
	writetext UnknownText_0x122f3
	waitbutton
	closetext
	end

UnknownText_0x122ee: ; 0x122ee
	; found @ !
	text_jump UnknownText_0x1c0a1c
	db "@"
; 0x122f3

FoundMultipleText:
	;found # @S!
	text_jump MultipleGetItemBallText
	db "@"

UnknownText_0x122f3: ; 0x122f3
	; But   can't carry any more items.
	text_jump UnknownText_0x1c0a2c
	db "@"
; 0x122f8

Function122f8: ; 122f8
	xor a
	ld [ScriptVar], a
	ld a, [EngineBuffer1]
	ld [wd265], a
	call GetItemName
	ld hl, StringBuffer3
	call CopyName2
	ld a, [EngineBuffer1]
	ld [CurItem], a
	ld a, [CurFruit]
	ld [wd10c], a
	ld hl, NumItems
	call ReceiveItem
	ret nc
	ld a, $1
	ld [ScriptVar], a
	ret
; 12324

HealMachineAnim: ; 12324
	ld a, [PartyCount]
	and a
	ret z
	ld a, [ScriptVar]
	ld [Buffer1], a
	ld a, [rOBP1]
	ld [Buffer2], a
	call Function1233e
	ld a, [Buffer2]
	call Functiond24
	ret
; 1233e

Function1233e: ; 1233e
	xor a
	ld [wd1ec], a
.asm_12342
	ld a, [Buffer1]
	ld e, a
	ld d, 0
	ld hl, Unknown_12365
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd1ec]
	ld e, a
	inc a
	ld [wd1ec], a
	add hl, de
	ld a, [hl]
	cp 5
	jr z, .asm_12364
	ld hl, Jumptable_12377
	rst JumpTable
	jr .asm_12342

.asm_12364
	ret
; 12365

Unknown_12365: ; 12365
	dw Unknown_1236b
	dw Unknown_1236f
	dw Unknown_12373
; 1236b

Unknown_1236b: ; 1236b
	db 0, 1, 3, 5
Unknown_1236f: ; 1236f
	db 0, 1, 3, 5
Unknown_12373: ; 12373
	db 0, 2, 4, 5
; 12377

Jumptable_12377: ; 12377
	dw Function12383
	dw Function12393
	dw Function123a1
	dw Function123bf
	dw Function123c8
	dw Function123db
; 12383

Function12383: ; 12383
	call Function12434
	ld de, GFX_123fc
	ld hl, $87c0
	lb bc, BANK(GFX_123fc), $2
	call Request2bpp
	ret
; 12393

Function12393: ; 12393
	ld hl, Sprites + $80
	ld de, Unknown_123dc
	call Function124a3
	call Function124a3
	jr Function123a7

Function123a1: ; 123a1
	ld hl, Sprites + $80
	ld de, Unknown_1241c
Function123a7: ; 123a7
	ld a, [PartyCount]
	cp 6
	jr c, .okay
	ld a, 6
.okay
	ld b, a
	call .SubtractEggs
.asm_123ab
	call Function124a3
	push de
	ld de, SFX_SECOND_PART_OF_ITEMFINDER
	call PlaySFX
	pop de
	ld c, 30
	call DelayFrames
	dec b
	jr nz, .asm_123ab
	ret
; 123bf

.SubtractEggs
	push hl
	ld hl, PartySpecies
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp EGG
	jr nz, .loop
	dec b
	jr .loop

.done
	pop hl
	ret

Function123bf: ; 123bf
	ld de, MUSIC_HEAL
	call PlayMusic
	jp Function12459
; 123c8

Function123c8: ; 123c8
	ld de, SFX_GAME_FREAK_LOGO_GS
	call PlaySFX
	call Function12459
	call WaitSFX
	ld de, SFX_BOOT_PC
	call PlaySFX
	ret
; 123db

Function123db: ; 123db
	ret
; 123dc

Unknown_123dc: ; 123dc
	db $20, $22, $7c, $16
	db $20, $26, $7c, $16
	db $26, $20, $7d, $16
	db $26, $28, $7d, $36
	db $2b, $20, $7d, $16
	db $2b, $28, $7d, $36
	db $30, $20, $7d, $16
	db $30, $28, $7d, $36
; 123fc

GFX_123fc: ; 123fc
INCBIN "gfx/unknown/0123fc.2bpp"
; 1241c

Unknown_1241c: ; 1241c
	db $3c, $51, $7d, $16
	db $3c, $56, $7d, $16
	db $3b, $4d, $7d, $16
	db $3b, $5a, $7d, $16
	db $39, $49, $7d, $16
	db $39, $5d, $7d, $16
; 12434

Function12434: ; 12434
	call Function3218
	jr nz, .asm_1243e
	ld a, $e0
	ld [rOBP1], a
	ret

.asm_1243e
	ld hl, Palette_12451
	ld de, OBPals + 8 * 6
	ld bc, 8
	ld a, $5
	call FarCopyWRAM
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 12451

Palette_12451: ; 12451
	RGB 31, 31, 31
	RGB 31, 19, 10
	RGB 31, 07, 01
	RGB 00, 00, 00
; 12459

Function12459: ; 12459
	ld c, $8
.asm_1245b
	push bc
	call Function12469
	ld c, $a
	call DelayFrames
	pop bc
	dec c
	jr nz, .asm_1245b
	ret
; 12469

Function12469: ; 12469
	call Function3218
	jr nz, .asm_12475
	ld a, [rOBP1]
	xor $28
	ld [rOBP1], a
	ret

.asm_12475
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, OBPals + 8 * 6
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	ld c, $3
.asm_12486
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	dec hl
	ld a, d
	ld [hld], a
	ld a, e
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_12486
	pop de
	dec hl
	ld a, d
	ld [hld], a
	ld a, e
	ld [hl], a
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 124a3

Function124a3: ; 124a3
	push bc
	ld a, [Buffer1]
	lb bc, $10, $20
	cp $1
	jr z, .asm_124b1
	lb bc, $00, $00
.asm_124b1
	ld a, [de]
	add c
	inc de
	ld [hli], a
	ld a, [de]
	add b
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	pop bc
	ret
; 124c1

UnknownScript_0x124c1:: ; 0x124c1
	callasm Function1250a
	jump UnknownScript_0x124ce
; 0x124c8

UnknownScript_0x124c8:: ; 0x124c8
	refreshscreen $0
	callasm Function124fa
UnknownScript_0x124ce: ; 0x124ce
	callasm DetermineMoneyLostToBlackout
	iffalse .normal_text
	callasm DetermineWildBattlePanic
	iffalse .WildBattlePanic
	writetext UnknownText_0x124f5_3
	jump .done_text
.WildBattlePanic
	writetext UnknownText_0x124f5_2
	jump .done_text
.normal_text
	writetext UnknownText_0x124f5
.done_text
	waitbutton
	special Function8c084
	pause 40
	special HealParty
	checkflag ENGINE_EARLY_GAME_KANTO
	iftrue .skip_egk_reset
	domaptrigger GROUP_VERMILION_CITY_RB, MAP_VERMILION_CITY_RB, 0
.skip_egk_reset
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue .script_64f2
	callasm Function12527
	farscall UnknownScript_0x122c1
	special Function97c28
	newloadmap $f1
	resetfuncs
.script_64f2
	jumpstd bugcontestresultswarp
; 0x124f5

UnknownText_0x124f5:
	text_jump UnknownText_0x1c0a4e
	db "@"

UnknownText_0x124f5_3: ; 0x124f5
	; is out of useable #MON!  whited out!
	text_jump UnknownText_0x1c0a4e_3
	db "@"
; 0x124fa

UnknownText_0x124f5_2:
	text_jump UnknownText_0x1c0a4e_2
	db "@"

Function124fa: ; 124fa
	call ClearPalettes
	call ClearScreen
	call Function3200
	call HideSprites
	call Function4f0
	ret
; 1250a

Function1250a: ; 1250a
	ld b, $0
	call GetSGBLayout
	call Function32f9
	ret
; 12513

DetermineMoneyLostToBlackout: ; 12513
	; If you already have no money,
	; do nothing here.
	xor a
	ld [wSpinning], a
	ld hl, Money
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ld a, 0
	jr z, .load
	ld hl, Badges
	ld b, 2
	call CountSetBits
	cp 8 + 1
	jr c, .okay
	ld c, 8
.okay
	ld b, 0
	ld hl, .BaseMoneys
	add hl, bc
	ld a, [hl]
	ld [hMultiplier], a
	ld a, [PartyCount]
	ld c, a
	ld b, 0
	ld hl, PartyMon1Level
	ld de, $30
.loop
	ld a, [hl]
	cp b
	jr c, .next
	ld b, a
.next
	add hl, de
	dec c
	jr nz, .loop
	xor a
	ld [hMultiplicand], a
	ld [hMultiplicand + 1], a
	ld a, b
	ld [hMultiplicand + 2], a
	call Multiply
	ld de, $ffc3
	ld hl, hProduct + 1
	call .Copy
	ld de, Money
	ld bc, $ffc3
	push bc
	push de
	callba Function1600b
	jr nc, .nonzero
	ld hl, Money
	ld de, $ffc3
	call .Copy
.nonzero
	pop de
	pop bc
	callba Function15ffa
	ld a, 1
.load
	ld [ScriptVar], a
	ret

.Copy
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

.BaseMoneys
	db 8
	db 16
	db 24
	db 36
	db 48
	db 64
	db 80
	db 100
	db 120

DetermineWildBattlePanic:
	ld hl, wWildBattlePanic
	ld a, [hl]
	and $1
	ld [ScriptVar], a
	xor a
	ld [hl], a
	ret

Function12527: ; 12527
	ld a, [wdcb2]
	ld d, a
	ld a, [wdcb3]
	ld e, a
	callba IsSpawnPoint
	ld a, c
	jr c, .asm_12539
	xor a
.asm_12539
	ld [wd001], a
	ret
; 1253d

UnknownScript_0x1253d:: ; 0x1253d
	checkcode VAR_FACING
	if_equal $0, UnknownScript_0x12555
	if_equal $1, UnknownScript_0x12550
	if_equal $2, UnknownScript_0x1255f
	if_equal $3, UnknownScript_0x1255a
	end
; 0x12550

UnknownScript_0x12550: ; 0x12550
	applymovement $0, MovementData_0x12564
	end
; 0x12555

UnknownScript_0x12555: ; 0x12555
	applymovement $0, MovementData_0x1256b
	end
; 0x1255a

UnknownScript_0x1255a: ; 0x1255a
	applymovement $0, MovementData_0x12572
	end
; 0x1255f

UnknownScript_0x1255f: ; 0x1255f
	applymovement $0, MovementData_0x12579
	end
; 0x12564

MovementData_0x12564: ; 0x12564
	step_wait5
	big_step_down
	turn_in_down
	step_wait5
	big_step_down
	turn_head_down
	step_end
; 0x1256b

MovementData_0x1256b: ; 0x1256b
	step_wait5
	big_step_down
	turn_in_up
	step_wait5
	big_step_down
	turn_head_up
	step_end
; 0x12572

MovementData_0x12572: ; 0x12572
	step_wait5
	big_step_down
	turn_in_left
	step_wait5
	big_step_down
	turn_head_left
	step_end
; 0x12579

MovementData_0x12579: ; 0x12579
	step_wait5
	big_step_down
	turn_in_right
	step_wait5
	big_step_down
	turn_head_right
	step_end
; 0x12580

Function12580: ; 12580
	callba Functionb8172
	jr c, .asm_1258d
	ld hl, UnknownScript_0x125ba
	jr .asm_12590

.asm_1258d
	ld hl, UnknownScript_0x125ad
.asm_12590
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret
; 12599

Function12599: ; 12599
	ld c, $4
.asm_1259b
	push bc
	ld de, SFX_SECOND_PART_OF_ITEMFINDER
	call WaitPlaySFX
	ld de, SFX_TRANSACTION
	call WaitPlaySFX
	pop bc
	dec c
	jr nz, .asm_1259b
	ret
; 125ad

UnknownScript_0x125ad: ; 0x125ad
	reloadmappart
	special UpdateTimePals
	callasm Function12599
	writetext UnknownText_0x125c3
	closetext
	end
; 0x125ba

UnknownScript_0x125ba: ; 0x125ba
	reloadmappart
	special UpdateTimePals
	writetext UnknownText_0x125c8
	closetext
	end
; 0x125c3

UnknownText_0x125c3: ; 0x125c3
	; Yes! ITEMFINDER indicates there's an item nearby.
	text_jump UnknownText_0x1c0a77
	db "@"
; 0x125c8

UnknownText_0x125c8: ; 0x125c8
	; Nope! ITEMFINDER isn't responding.
	text_jump UnknownText_0x1c0aa9
	db "@"
; 0x125cd

StartMenu:: ; 125cd
	call Function1fbf
	ld de, SFX_MENU
	call PlaySFX
	callba Function6454
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ld hl, .MenuDataHeader
	jr z, .GotMenuData
	ld hl, .ContestMenuDataHeader
.GotMenuData
	call LoadMenuDataHeader
	call .SetUpMenuItems
	ld a, [wd0d2]
	ld [wcf88], a
	call .DrawMenuAccount_
	call MenuFunc_1e7f
	call .DrawBugContestStatusBox
	call Function2e31
	call Function2e20
	callba Function64bf
	call .DrawBugContestStatus
	call UpdateTimePals
	jr .Select

.Reopen
	call Function1ad2
	call UpdateTimePals
	call .SetUpMenuItems
	ld a, [wd0d2]
	ld [wcf88], a
.Select
	call .GetInput
	jr c, .Exit
	call .DrawMenuAccount
	ld a, [wcf88]
	ld [wd0d2], a
	call PlayClickSFX
	call Function1bee
	call .OpenMenu
; Menu items have different return functions.
; For example, saving exits the menu.

	ld hl, .MenuReturns
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.MenuReturns
	dw .Reopen
	dw .Exit
	dw .ReturnTwo
	dw .ReturnThree
	dw .ReturnFour
	dw .ReturnEnd
	dw .ReturnRedraw

.Exit
	ld a, [hOAMUpdate]
	push af
	ld a, 1
	ld [hOAMUpdate], a
	call Functione5f
	pop af
	ld [hOAMUpdate], a
.ReturnEnd
	call Function1c07
.ReturnEnd2
	call Function2dcf
	call UpdateTimePals
	ret

.GetInput
; Return carry on exit, and no-carry on selection.

	xor a
	ld [hBGMapMode], a
	call .DrawMenuAccount
	call SetUpMenu
	ld a, $ff
	ld [MenuSelection], a
.loop
	call .PrintMenuAccount
	call Function1f1a
	ld a, [wcf73]
	cp B_BUTTON
	jr z, .b
	cp A_BUTTON
	jr z, .a
	jr .loop

.a
	call PlayClickSFX
	and a
	ret

.b
	scf
	ret
; 12691

.ReturnFour ; 12691
	call Function1c07
	ld a, $80
	ld [$ffa0], a
	ret
; 12699

.ReturnThree ; 12699
	call Function1c07
	ld a, $80
	ld [$ffa0], a
	jr .ReturnEnd2
; 126a2

.ReturnTwo ; 126a2
	call Function1c07
	ld hl, wd0e9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd0e8]
	rst FarCall
	jr .ReturnEnd2
; 126b1

.ReturnRedraw ; 126b1
	call .Clear
	jp .Reopen
; 126b7

.Clear ; 126b7
	call WhiteBGMap
	call Function1d7d
	call Function2bae
	call .DrawMenuAccount_
	call MenuFunc_1e7f
	call .DrawBugContestStatus
	call Function1ad2
	call Functiond90
	call Function2b5c
	ret
; 126d3

.MenuDataHeader
	db $40 ; tile backup
	db 0, 10 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection
.ContestMenuDataHeader
	db $40 ; tile backup
	db 2, 10 ; start coords
	db 17, 19 ; end coords
	dw .MenuData
	db 1 ; default selection
.MenuData
	db %10101000 ; x padding, wrap around, start can close
	dn 0, 0 ; rows, columns
	dw MenuItemsList
	dw .MenuString
	dw .Items

.Items
	dw StartMenu_Pokedex,  .PokedexString,  .PokedexDesc
	dw StartMenu_Pokemon,  .PartyString,    .PartyDesc
	dw StartMenu_Pack,     .PackString,     .PackDesc
	dw StartMenu_Status,   .StatusString,   .StatusDesc
	dw StartMenu_Save,     .SaveString,     .SaveDesc
	dw StartMenu_Option,   .OptionString,   .OptionDesc
	dw StartMenu_Exit,     .ExitString,     .ExitDesc
	dw StartMenu_Pokegear, .PokegearString, .PokegearDesc
	dw StartMenu_Quit,     .QuitString,     .QuitDesc
.PokedexString 	db "#DEX@"
.PartyString   	db "#MON@"
.PackString    	db "PACK@"
.StatusString  	db $52, "@"
.SaveString    	db "SAVE@"
.OptionString  	db "OPTION@"
.ExitString    	db "EXIT@"
.PokegearString	db $24, "GEAR@"
.QuitString    	db "QUIT@"
.PokedexDesc 	db "#MON", $4e, "database@"
.PartyDesc   	db "Party ", $4a, $4e, "status@"
.PackDesc    	db "Contains", $4e, "items@"
.PokegearDesc	db "Trainer's", $4e, "key device@"
.StatusDesc  	db "Your own", $4e, "status@"
.SaveDesc    	db "Save your", $4e, "progress@"
.OptionDesc  	db "Change", $4e, "settings@"
.ExitDesc    	db "Close this", $4e, "menu@"
.QuitDesc    	db "Quit and", $4e, "be judged.@"
.OpenMenu ; 127e5
	ld a, [MenuSelection]
	call .GetMenuAccountTextPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 127ef

.MenuString ; 127ef
	push de
	ld a, [MenuSelection]
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret
; 12800

.MenuDesc ; 12800
	push de
	ld a, [MenuSelection]
	cp $ff
	jr z, .none
	call .GetMenuAccountTextPointer
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret

.none
	pop de
	ret
; 12819

.GetMenuAccountTextPointer ; 12819
	ld e, a
	ld d, 0
	ld hl, wcf97
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ret
; 12829

.SetUpMenuItems ; 12829
	xor a
	ld [wcf76], a
	call .FillMenuList
	ld hl, StatusFlags
	bit 0, [hl]
	jr z, .no_pokedex
	ld a, 0 ; pokedex
	call .AppendMenuList
.no_pokedex
	ld a, [PartyCount]
	and a
	jr z, .no_pokemon
	ld a, 1 ; pokemon
	call .AppendMenuList
.no_pokemon
	ld a, [wLinkMode]
	and a
	jr nz, .no_pack
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	jr nz, .no_pack
	ld a, 2 ; pack
	call .AppendMenuList
.no_pack
	ld hl, wd957
	bit 7, [hl]
	jr z, .no_pokegear
	ld a, 7 ; pokegear
	call .AppendMenuList
.no_pokegear
	ld a, 3 ; status
	call .AppendMenuList
	ld a, [wLinkMode]
	and a
	jr nz, .no_save
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ld a, 8 ; quit
	jr nz, .write
	ld a, 4 ; save
.write
	call .AppendMenuList
.no_save
	ld a, 5 ; option
	call .AppendMenuList
	ld a, 6 ; exit
	call .AppendMenuList
	ld a, c
	ld [MenuItemsList], a
	ret
; 1288d

.FillMenuList ; 1288d
	xor a
	ld hl, MenuItemsList
	ld [hli], a
	ld a, $ff
	ld bc, $000f
	call ByteFill
	ld de, MenuItemsList + 1
	ld c, 0
	ret
; 128a0

.AppendMenuList ; 128a0
	ld [de], a
	inc de
	inc c
	ret
; 128a4

.DrawMenuAccount_ ; 128a4
	jp .DrawMenuAccount
; 128a7

.PrintMenuAccount ; 128a7
	call .IsMenuAccountOn
	ret z
	call .DrawMenuAccount
	decoord 0, 14
	jp .MenuDesc
; 128b4

.DrawMenuAccount ; 128b4
	call .IsMenuAccountOn
	ret z
	hlcoord 0, 13
	ld bc, $050a
	call ClearBox
	hlcoord 0, 13
	ld b, 3
	ld c, 8
	jp TextBoxPalette
; 128cb

.IsMenuAccountOn ; 128cb
	ld a, [Options2]
	bit 1, a
	ret
; 128d1

.DrawBugContestStatusBox ; 128d1
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	ret z
	callba Function24bdc
	ret
; 128de

.DrawBugContestStatus ; 128de
	ld hl, StatusFlags2
	bit 2, [hl] ; bug catching contest
	jr nz, .contest
	ret

.contest
	callba Function24be7
	ret
; 128ed

StartMenu_Exit: ; 128ed
; Exit the menu.

	ld a, 1
	ret
; 128f0

StartMenu_Quit: ; 128f0
; Retire from the bug catching contest.

	ld hl, .EndTheContestText
	call Function12cf5
	jr c, .asm_12903
	ld a, BANK(UnknownScript_0x1360b)
	ld hl, UnknownScript_0x1360b
	call FarQueueScript
	ld a, 4
	ret

.asm_12903
	ld a, 0
	ret

.EndTheContestText
	text_jump UnknownText_0x1c1a6c
	db "@"
; 1290b

StartMenu_Save: ; 1290b
; Save the game.

	call Function2879
	callba Function14a1a
	jr nc, .asm_12919
	ld a, 0
	ret

.asm_12919
	ld a, 1
	ret
; 1291c

StartMenu_Option: ; 1291c
; Game options.

	call FadeToMenu
	callba OptionsMenu
	ld a, 6
	ret
; 12928

StartMenu_Status: ; 12928
; Player status.

	call FadeToMenu
	callba Function25105
	call Function2b3c
	ld a, 0
	ret
; 12937

StartMenu_Pokedex: ; 12937
	ld a, [PartyCount]
	and a
	jr z, .asm_12949
	call FadeToMenu
	callba Pokedex
	call Function2b3c
.asm_12949
	ld a, 0
	ret
; 1294c

StartMenu_Pokegear: ; 1294c
	call FadeToMenu
	callba Function90b8d
	call Function2b3c
	ld a, 0
	ret
; 1295b

StartMenu_Pack: ; 1295b
	call FadeToMenu
	callba Pack
	ld a, [wcf66]
	and a
	jr nz, .asm_12970
	call Function2b3c
	ld a, 0
	ret

.asm_12970
	call Function2b4d
	ld a, 4
	ret
; 12976

StartMenu_Pokemon: ; 12976
	ld a, [PartyCount]
	and a
	jp z, PokeMenuReturn
	call FadeToMenu
Pokechoosemenu:
	xor a
	ld [PartyMenuActionText], a ; Choose a POKéMON.
	call WhiteBGMap
Pokemenu:
	callba Function5004f
	callba Function50405 ;SELECTADD
	callba Function503e0
Pokemenunoreload:
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9 ; load regular palettes?
	call DelayFrame
	callba PartyMenuSelect ;make menu selection and set curpartymon and curspecies
	jr c, PokeMenuReturn ; if cancelled or pressed B, back out
	ld a, [$ffa9] ;handle select button to switch
	bit 0, a
	jr z, SelectSwitch
	call PokemonActionSubmenu ;handle pokemon menu and run selected action
	jr SkipSelect
SelectSwitch
	call SwitchPartyMons
SkipSelect
	cp 3
	jr z, Pokemenu
	cp 0
	jr z, Pokechoosemenu
	cp 1
	jr z, Pokemenunoreload
	cp 2
	jr z, PokeMenuquit
PokeMenuReturn:
	call Function2b3c
	ld a, 0
	ret

PokeMenuquit
	ld a, b
	push af
	call Function2b4d
	pop af
	ret
; 129d5

Function129d5: ; 129d5
	ld a, [NumItems]
	and a
	ret nz
	ld a, [NumKeyItems]
	and a
	ret nz
	ld a, [NumBalls]
	and a
	ret nz
	ld hl, TMsHMs
	ld b, $39
.asm_129e9
	ld a, [hli]
	and a
	jr nz, .asm_129f2
	dec b
	jr nz, .asm_129e9
	scf
	ret

.asm_129f2
	and a
	ret

Function129f4: ; 129f4
	push de
	call PartyMonItemName
	callba _CheckTossableItem
	ld a, [wd142]
	and a
	jr nz, .asm_12a3f
	ld hl, UnknownText_0x12a45
	call Function1d4f
	callba Function24fbf
	push af
	call Function1c17
	call Function1c07
	pop af
	jr c, .asm_12a42
	ld hl, UnknownText_0x12a4a
	call Function1d4f
	call YesNoBox
	push af
	call Function1c07
	pop af
	jr c, .asm_12a42
	pop hl
	ld a, [wd107]
	call TossItem
	call PartyMonItemName
	ld hl, UnknownText_0x12a4f
	call Function1d4f
	call Function1c07
	and a
	ret

.asm_12a3f
	call Function12a54
.asm_12a42
	pop hl
	scf
	ret
; 12a45 (4:6a45)

UnknownText_0x12a45: ; 0x12a45
	; Toss out how many @ (S)?
	text_jump UnknownText_0x1c1a90
	db "@"
; 0x12a4a

UnknownText_0x12a4a: ; 0x12a4a
	; Throw away @ @ (S)?
	text_jump UnknownText_0x1c1aad
	db "@"
; 0x12a4f

UnknownText_0x12a4f: ; 0x12a4f
	; Discarded @ (S).
	text_jump UnknownText_0x1c1aca
	db "@"
; 0x12a54

Function12a54: ; 12a54 (4:6a54)
	ld hl, UnknownText_0x12a5b
	call Function1d67
	ret
; 12a5b (4:6a5b)

UnknownText_0x12a5b: ; 0x12a5b
	; That's too impor- tant to toss out!
	text_jump UnknownText_0x1c1adf
	db "@"
; 0x12a60

CantUseItem: ; 12a60
	ld hl, CantUseItemText
	call Function2012
	ret
; 12a67

CantUseItemText: ; 12a67
	text_jump UnknownText_0x1c1b03
	db "@"
; 12a6c

PartyMonItemName: ; 12a6c
	ld a, [CurItem]
	ld [wd265], a
	call GetItemName
	call CopyName1
	ret
; 12a79

CancelPokemonAction: ; 12a79
	callba Function50405
	callba Function8ea71
	ld a, 1
	ret
; 12a88

PokemonActionSubmenu: ; 12a88
	hlcoord 1, 15
	ld bc, $0212 ; box size
	call ClearBox ;fill with whitespace?
	callba Function24d19 ;load monsubmenu, ret thing to run in menu selection
	call GetCurNick
	ld a, [MenuSelection]
	ld hl, .Actions
	ld de, 3
	call IsInArray
	jr nc, .nothing
	inc hl
	ld a, [hli] ;if something found, load location into hl and jump to run
	ld h, [hl]
	ld l, a
	jp [hl]

.nothing
	ld a, 0
	ret

.Actions
	dbw  1, Function12e1b ; Cut
	dbw  2, Function12e30 ; Fly
	dbw  3, Function12ebd ; Surf
	dbw  4, Function12e6a ; Strength
	dbw  6, Function12e55 ; Flash
	dbw  7, Function12e7f ; Whirlpool
	dbw  8, Function12ed1 ; Dig
	dbw  9, Function12ea9 ; Teleport
	dbw 10, Function12ee6 ; Softboiled
	dbw 13, Function12ee6 ; MilkDrink
	dbw 11, Function12f26 ; Headbutt
	dbw  5, Function12e94 ; Waterfall
	dbw 12, Function12f3b ; RockSmash
	dbw 14, Function12f26 ; SweetScent, replaced by zen headbutt which copies headbutt
	dbw 15, OpenPartyStats
	dbw 16, SwitchPartyMons
	dbw 17, GiveTakePartyMonItem
	dbw 18, CancelPokemonAction
	dbw 19, Function12fba ; move
	dbw 20, Function12d45 ; mail
; 12aec

SwitchPartyMons: ; 12aec
; Don't try if there's nothing to switch!

	ld a, [PartyCount]
	cp 2
	jr c, .DontSwitch
	ld a, [CurPartyMon] ;load selected mon
	inc a
	ld [wd0e3], a ;load into ???
	callba Function8ea8c ;load 2 into wc316,wc326,wc336,wc346,wc356 and wc366 if corrisponding slot matches current, else load 3
	callba Function5042d ;load menu data for party switch and set cursor up
	ld a, 4
	ld [PartyMenuActionText], a ;actiontext = 4
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	hlcoord 0, 1
	ld bc, 20 * 2
	ld a, [wd0e3] ;party mon+1
	dec a
	call AddNTimes ;Put white cursor into  place
	ld [hl], "▷"
	call WaitBGMap
	call Function32f9
	call DelayFrame
	callba PartyMenuSelect ;make menu selection, ret c if cancelling, set curpartymon and curspecies if not
	bit 1, b
	jr c, .DontSwitch
	callba Function50f12
	xor a
	ld [PartyMenuActionText], a
	callba Function5004f
	callba Function50405
	callba Function503e0
	ld a, 1
	ret

.DontSwitch
	xor a
	ld [PartyMenuActionText], a
	call CancelPokemonAction
	ret
; 12b60

GiveTakePartyMonItem: ; 12b60
; Eggs can't hold items!

	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_12ba6
	ld hl, GiveTakeItemMenuData
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07
	jr c, .asm_12ba6
	call GetCurNick
	ld hl, StringBuffer1
	ld de, wd050
	ld bc, $b
	call CopyBytes
	ld a, [wcfa9]
	cp 1
	jr nz, .asm_12ba0
	call Function1d6e
	call ClearPalettes
	call Function12ba9
	call ClearPalettes
	call Functione58
	call Function1c07
	ld a, 0
	ret

.asm_12ba0
	call TakePartyItem
	ld a, 3
	ret

.asm_12ba6
	ld a, 3
	ret
; 12ba9

Function12ba9: ; 12ba9
	callba Function106a5
.loop
	callba Function106be
	ld a, [wcf66]
	and a
	jr z, .quit
	ld a, [wcf65]
	cp 2
	jr z, .next
	call CheckTossableItem
	ld a, [wd142]
	and a
	jr nz, .next
	call Function12bd9
	jr .quit

.next
	ld hl, CantBeHeldText
	call Function1d67
	jr .loop

.quit
	ret
; 12bd9

Function12bd9: ; 12bd9
	call SpeechTextBox
	call PartyMonItemName
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .asm_12bf4
	push hl
	ld d, a
	callba ItemIsMail
	pop hl
	jr c, .asm_12c01
	ld a, [hl]
	jr .asm_12c08

.asm_12bf4
	call Function12cea
	ld hl, MadeHoldText
	call Function1d67
	call GivePartyItem
	ret

.asm_12c01
	ld hl, PleaseRemoveMailText
	call Function1d67
	ret

.asm_12c08
	ld [wd265], a
	call GetItemName
	ld hl, SwitchAlreadyHoldingText
	call Function12cf5
	jr c, .asm_12c4b
	call Function12cea
	ld a, [wd265]
	push af
	ld a, [CurItem]
	ld [wd265], a
	pop af
	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12c3c
	ld hl, TookAndMadeHoldText
	call Function1d67
	ld a, [wd265]
	ld [CurItem], a
	call GivePartyItem
	ret

.asm_12c3c
	ld a, [wd265]
	ld [CurItem], a
	call Function12cdf
	ld hl, ItemStorageIsFullText
	call Function1d67
.asm_12c4b
	ret
; 12c4c

GivePartyItem: ; 12c4c
	call GetPartyItemLocation
	ld a, [CurItem]
	ld [hl], a
	ld d, a
	callba ItemIsMail
	jr nc, .asm_12c5f
	call Function12cfe
.asm_12c5f
	ret
; 12c60

TakePartyItem: ; 12c60
	call SpeechTextBox
	call GetPartyItemLocation
	ld a, [hl]
	and a
	jr z, .asm_12c8c
	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12c94
	callba ItemIsMail
	call GetPartyItemLocation
	ld a, [hl]
	ld [wd265], a
	ld [hl], NO_ITEM
	call GetItemName
	ld hl, TookFromText
	call Function1d67
	jr .asm_12c9a

.asm_12c8c
	ld hl, IsntHoldingAnythingText
	call Function1d67
	jr .asm_12c9a

.asm_12c94
	ld hl, ItemStorageIsFullText
	call Function1d67
.asm_12c9a
	ret
; 12c9b

GiveTakeItemMenuData: ; 12c9b
	db %01010000
	db 12, 12 ; start coords
	db 17, 19 ; end coords
	dw .Items
	db 1 ; default option
.Items
	db %10000000 ; x padding
	db 2 ; # items
	db "GIVE@"
	db "TAKE@"
; 12caf

TookAndMadeHoldText: ; 12caf
	text_jump UnknownText_0x1c1b2c
	db "@"
; 12cb4

MadeHoldText: ; 12cb4
	text_jump UnknownText_0x1c1b57
	db "@"
; 12cb9

PleaseRemoveMailText: ; 12cb9
	text_jump UnknownText_0x1c1b6f
	db "@"
; 12cbe

IsntHoldingAnythingText: ; 12cbe
	text_jump UnknownText_0x1c1b8e
	db "@"
; 12cc3

ItemStorageIsFullText: ; 12cc3
	text_jump UnknownText_0x1c1baa
	db "@"
; 12cc8

TookFromText: ; 12cc8
	text_jump UnknownText_0x1c1bc4
	db "@"
; 12ccd

SwitchAlreadyHoldingText: ; 12ccd
	text_jump UnknownText_0x1c1bdc
	db "@"
; 12cd2

CantBeHeldText: ; 12cd2
	text_jump UnknownText_0x1c1c09
	db "@"
; 12cd7

GetPartyItemLocation: ; 12cd7
	push af
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	pop af
	ret
; 12cdf

Function12cdf: ; 12cdf
	ld a, $1
	ld [wd10c], a
	ld hl, NumItems
	jp ReceiveItem
; 12cea

Function12cea: ; 12cea (4:6cea)
	ld a, $1
	ld [wd10c], a
	ld hl, NumItems
	jp TossItem

Function12cf5: ; 12cf5
	call Function1d4f
	call YesNoBox
	jp Function1c07
; 12cfe

Function12cfe: ; 12cfe (4:6cfe)
	ld de, DefaultFlypoint
	callba Function11e75
	ld hl, PlayerName
	ld de, wd023
	ld bc, $a
	call CopyBytes
	ld hl, PlayerID
	ld bc, $2
	call CopyBytes
	ld a, [CurPartySpecies]
	ld [de], a
	inc de
	ld a, [CurItem]
	ld [de], a
	ld a, [CurPartyMon]
	ld hl, $a600
	ld bc, $2f
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, DefaultFlypoint
	ld bc, $2f
	ld a, $0
	call GetSRAMBank
	call CopyBytes
	call CloseSRAM
	ret

Function12d45: ; 12d45
	ld a, [wLinkMode]
	cp $1
	jr z, .asm_12d6d
	cp $2
	jr z, .asm_12d6d
	ld hl, MenuDataHeader_0x12dc9
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07
	jp c, .asm_12dc6
	ld a, [wcfa9]
	cp $1
	jr z, .asm_12d6d
	cp $2
	jr z, .asm_12d76
	jp .asm_12dc6

.asm_12d6d
	callba Functionb9229
	ld a, $0
	ret

.asm_12d76
	ld hl, UnknownText_0x12df1
	call Function12cf5
	jr c, .asm_12d9a
	ld a, [CurPartyMon]
	ld b, a
	callba Function4456e
	jr c, .asm_12d92
	ld hl, UnknownText_0x12dfb
	call Function1d67
	jr .asm_12dc6

.asm_12d92
	ld hl, UnknownText_0x12df6
	call Function1d67
	jr .asm_12dc6

.asm_12d9a
	ld hl, UnknownText_0x12de2
	call Function12cf5
	jr c, .asm_12dc6
	call GetPartyItemLocation
	ld a, [hl]
	ld [CurItem], a
	call Function12cdf
	jr nc, .asm_12dbe
	call GetPartyItemLocation
	ld [hl], $0
	call GetCurNick
	ld hl, UnknownText_0x12de7
	call Function1d67
	jr .asm_12dc6

.asm_12dbe
	ld hl, UnknownText_0x12dec
	call Function1d67
	jr .asm_12dc6

.asm_12dc6
	ld a, $3
	ret
; 12dc9

MenuDataHeader_0x12dc9: ; 0x12dc9
	db $40 ; flags
	db 10, 12 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0x12dd1
	db 1 ; default option
; 0x12dd1

MenuData2_0x12dd1: ; 0x12dd1
	db $80 ; flags
	db 3 ; items
	db "READ@"
	db "TAKE@"
	db "QUIT@"
; 0x12de2

UnknownText_0x12de2: ; 0x12de2
	text_jump UnknownText_0x1c1c22
	db "@"
; 0x12de7

UnknownText_0x12de7: ; 0x12de7
	text_jump UnknownText_0x1c1c47
	db "@"
; 0x12dec

UnknownText_0x12dec: ; 0x12dec
	text_jump UnknownText_0x1c1c62
	db "@"
; 0x12df1

UnknownText_0x12df1: ; 0x12df1
	text_jump UnknownText_0x1c1c86
	db "@"
; 0x12df6

UnknownText_0x12df6: ; 0x12df6
	text_jump UnknownText_0x1c1ca9
	db "@"
; 0x12dfb

UnknownText_0x12dfb: ; 0x12dfb
	text_jump UnknownText_0x1c1cc4
	db "@"
; 0x12e00

OpenPartyStats: ; 12e00
	call Function1d6e
	call ClearSprites
; PartyMon

	xor a
	ld [MonType], a
	call LowVolume
	predef StatsScreenInit
	call MaxVolume
	call Function1d7d
	ld a, 0
	ret
; 12e1b

Function12e1b: ; 12e1b
	callba Functionc785
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12e2d
	ld b, $4
	ld a, $2
	ret

.asm_12e2d
	ld a, $3
	ret
; 12e30

Function12e30: ; 12e30
	callba Functionca3b
	ld a, [wd0ec]
	cp $2
	jr z, .asm_12e4c
	cp $0
	jr z, .asm_12e4f
	callba Function1060b5
	ld b, $4
	ld a, $2
	ret

.asm_12e4c
	ld a, $3
	ret

.asm_12e4f
	ld a, $0
	ret

.asm_12e52
	ld a, $1
	ret
; 12e55

Function12e55: ; 12e55
	callba Functionc8ac
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12e67
	ld b, $4
	ld a, $2
	ret

.asm_12e67
	ld a, $3
	ret
; 12e6a

Function12e6a: ; 12e6a
	callba Functioncce5
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12e7c
	ld b, $4
	ld a, $2
	ret

.asm_12e7c
	ld a, $3
	ret
; 12e7f

Function12e7f: ; 12e7f
	callba Functioncd9d
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12e91
	ld b, $4
	ld a, $2
	ret

.asm_12e91
	ld a, $3
	ret
; 12e94

Function12e94: ; 12e94
	callba Functioncade
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12ea6
	ld b, $4
	ld a, $2
	ret

.asm_12ea6
	ld a, $3
	ret
; 12ea9

Function12ea9: ; 12ea9
	callba Functioncc61
	ld a, [wd0ec]
	and a
	jr z, .asm_12eba
	ld b, $4
	ld a, $2
	ret

.asm_12eba
	ld a, $3
	ret
; 12ebd

Function12ebd: ; 12ebd
	callba Functionc909
	ld a, [wd0ec]
	and a
	jr z, .asm_12ece
	ld b, $4
	ld a, $2
	ret

.asm_12ece
	ld a, $3
	ret
; 12ed1

Function12ed1: ; 12ed1
	callba Functioncb9c
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12ee3
	ld b, $4
	ld a, $2
	ret

.asm_12ee3
	ld a, $3
	ret
; 12ee6

Function12ee6: ; 12ee6
	call Function12f05
	jr nc, .asm_12ef3
	callba Functionf3df
	jr .asm_12ef9

.asm_12ef3
	ld hl, UnknownText_0x12f00
	call PrintText
.asm_12ef9
	xor a
	ld [PartyMenuActionText], a
	ld a, $3
	ret
; 12f00

UnknownText_0x12f00: ; 0x12f00
	; Not enough HP!
	text_jump UnknownText_0x1c1ce3
	db "@"
; 0x12f05

Function12f05: ; 12f05
	ld a, PartyMon1MaxHP - PartyMon1
	call GetPartyParamLocation
	ld a, [hli]
	ld [hProduct], a
	ld a, [hl]
	ld [hMultiplicand], a
	ld a, $5
	ld [hMultiplier], a
	ld b, $2
	call Divide
	ld a, PartyMon1HP + 1 - PartyMon1
	call GetPartyParamLocation
	ld a, [$ffb6]
	sub [hl]
	dec hl
	ld a, [$ffb5]
	sbc [hl]
	ret
; 12f26

Function12f26: ; 12f26
	callba Functionce7d
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12f38
	ld b, $4
	ld a, $2
	ret

.asm_12f38
	ld a, $3
	ret
; 12f3b

Function12f3b: ; 12f3b
	callba Functionceeb
	ld a, [wd0ec]
	cp $1
	jr nz, .asm_12f4d
	ld b, $4
	ld a, $2
	ret

.asm_12f4d
	ld a, $3
	ret
; 12f50

Function12f50: ; 12f50
	callba Function506bc
	ld b, $4
	ld a, $2
	ret
; 12f5b

Function12f5b: ; 12f5b
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Functione58
	call Function12f73
	pop bc
	ld a, b
	ld [Options], a
	push af
	call WhiteBGMap
	pop af
	ret
; 12f73

Function12f73: ; 12f73
	call Function13172
	ld de, Unknown_12fb2
	call Function1bb1
	call Function131ef
	ld hl, wcfa5
	set 6, [hl]
	jr Function12f93

Function12f86: ; 12f86
	call Function1bd3
	bit 1, a
	jp nz, Function12f9f
	bit 0, a
	jp nz, Function12f9c
Function12f93: ; 12f93
	call Function13235
	call Function13256
	jp Function12f86
; 12f9c

Function12f9c: ; 12f9c
	and a
	jr Function12fa0

Function12f9f: ; 12f9f
	scf
Function12fa0: ; 12fa0
	push af
	xor a
	ld [wd0e3], a
	ld hl, wcfa5
	res 6, [hl]
	call ClearSprites
	call ClearTileMap
	pop af
	ret
; 12fb2

Unknown_12fb2: ; 12fb2
	db $03, $01, $03, $01, $40, $00, $20, $c3
; 12fba

Function12fba: ; 12fba
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_12fd2
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function12fd5
	pop af
	ld [Options], a
	call WhiteBGMap
.asm_12fd2
	ld a, $0
	ret
; 12fd5

Function12fd5: ; 12fd5
	ld a, [CurPartyMon]
	inc a
	ld [wd0d8], a
	call Function13172
	call Function132d3
	ld de, Unknown_13163
	call Function1bb1
.asm_12fe8
	call Function131ef
	ld hl, wcfa5
	set 6, [hl]
	jr .asm_13009

.asm_12ff2
	call Function1bd3
	bit 1, a
	jp nz, .asm_13038
	bit 0, a
	jp nz, .asm_130c6
	bit 4, a
	jp nz, .asm_1305b
	bit 5, a
	jp nz, .asm_13075
.asm_13009
	call Function13235
	ld a, [wd0e3]
	and a
	jr nz, .asm_13018
	call Function13256
	jp .asm_12ff2

.asm_13018
	ld a, $7f
	hlcoord 1, 11
	ld bc, $0005
	call ByteFill
	hlcoord 1, 12
	ld bc, $0512
	call ClearBox
	hlcoord 1, 12
	ld de, String_1316b
	call PlaceString
	jp .asm_12ff2

.asm_13038: ; 13038
	call PlayClickSFX
	call WaitSFX
	ld a, [wd0e3]
	and a
	jp z, Function13154
	ld a, [wd0e3]
	ld [wcfa9], a
	xor a
	ld [wd0e3], a
	hlcoord 1, 2
	ld bc, $0812
	call ClearBox
	jp .asm_12fe8
; 1305b

.asm_1305b: ; 1305b
	ld a, [wd0e3]
	and a
	jp nz, .asm_12ff2
	ld a, [CurPartyMon]
	ld b, a
	push bc
	call .asm_1308f
	pop bc
	ld a, [CurPartyMon]
	cp b
	jp z, .asm_12ff2
	jp Function12fd5

.asm_13075: ; 13075
	ld a, [wd0e3]
	and a
	jp nz, .asm_12ff2
	ld a, [CurPartyMon]
	ld b, a
	push bc
	call .asm_130a7
	pop bc
	ld a, [CurPartyMon]
	cp b
	jp z, .asm_12ff2
	jp Function12fd5

.asm_1308f
	ld a, [CurPartyMon]
	inc a
	ld [CurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .asm_130a7
	cp EGG
	ret nz
	jr .asm_1308f

.asm_130a7
	ld a, [CurPartyMon]
	and a
	ret z
.asm_130ac
	ld a, [CurPartyMon]
	dec a
	ld [CurPartyMon], a
	ld c, a
	ld b, 0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	cp EGG
	ret nz
	ld a, [CurPartyMon]
	and a
	jr z, .asm_1308f
	jr .asm_130ac
; 130c6

.asm_130c6: ; 130c6
	call PlayClickSFX
	call WaitSFX
	ld a, [wd0e3]
	and a
	jr nz, .asm_130de
	ld a, [wcfa9]
	ld [wd0e3], a
	call Function1bee
	jp .asm_13018

.asm_130de
	ld hl, PartyMon1Moves
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes
	push hl
	call Function1313a
	pop hl
	ld bc, $0015
	add hl, bc
	call Function1313a
	ld a, [wBattleMode]
	jr z, .asm_13113
	ld hl, BattleMonMoves
	ld bc, $0020
	ld a, [CurPartyMon]
	call AddNTimes
	push hl
	call Function1313a
	pop hl
	ld bc, $0006
	add hl, bc
	call Function1313a
.asm_13113
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	call WaitSFX
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	call WaitSFX
	hlcoord 1, 2
	ld bc, $0812
	call ClearBox
	hlcoord 10, 10
	ld bc, $0109
	call ClearBox
	jp .asm_12fe8
; 1313a

Function1313a: ; 1313a
	push hl
	ld a, [wcfa9]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wd0e3]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret
; 13154

Function13154: ; 13154
	xor a
	ld [wd0e3], a
	ld hl, wcfa5
	res 6, [hl]
	call ClearSprites
	jp ClearTileMap
; 13163

Unknown_13163: ; 13163
	db $03, $01, $03, $01, $40, $00, $20, $f3
; 1316b

String_1316b: ; 1316b
	db "Where?@"
; 13172

Function13172: ; 13172
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	xor a
	ld [hBGMapMode], a
	callba Functionfb571
	callba Function8e814
	ld a, [CurPartyMon]
	ld e, a
	ld d, $0
	ld hl, PartySpecies
	add hl, de
	ld a, [hl]
	ld [wd265], a
	ld e, $2
	callba Function8e83f
	hlcoord 0, 1
	ld b, $9
	ld c, $12
	call TextBox
	hlcoord 0, 11
	ld b, $5
	ld c, $12
	call TextBox
	hlcoord 2, 0
	ld bc, $0203
	call ClearBox
	xor a
	ld [MonType], a
	ld hl, PartyMonNicknames
	ld a, [CurPartyMon]
	call GetNick
	hlcoord 5, 1
	call PlaceString
	push bc
	callba Function5084a
	pop hl
	call PrintLevel
	ld hl, PlayerHPPal
	call SetHPPal
	ld b, $e
	call GetSGBLayout
	hlcoord 16, 0
	ld bc, $0103
	jp ClearBox
; 131ef

Function131ef: ; 131ef
	xor a
	ld [hBGMapMode], a
	ld [wd0e3], a
	ld [MonType], a
	predef Function5084a
	ld hl, TempMonMoves
	ld de, wd25e
	ld bc, NUM_MOVES
	call CopyBytes
	ld a, SCREEN_WIDTH * 2
	ld [Buffer1], a
	hlcoord 2, 3
	predef ListMoves
	hlcoord 10, 4
	predef Function50c50
	call WaitBGMap
	call Function32f9
	ld a, [wd0eb]
	inc a
	ld [wcfa3], a
	hlcoord 0, 11
	ld b, 5
	ld c, 18
	jp TextBox
; 13235

Function13235: ; 13235
	ld hl, PartyMon1Moves
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes
	ld a, [wcfa9]
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [CurSpecies], a
	hlcoord 1, 12
	lb bc, 5, 18
	jp ClearBox
; 13256

Function13256: ; 13256
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 10
	ld de, String_132ba
	call PlaceString
	hlcoord 0, 11
	ld de, String_132c2
	call PlaceString
	hlcoord 12, 12
	ld de, String_132ca
	call PlaceString
	ld a, [CurSpecies]
	ld b, a
	hlcoord 2, 12
	predef PrintMoveType
	ld a, [CurSpecies]
	dec a
	ld hl, Moves + MOVE_POWER
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	hlcoord 16, 12
	cp $2
	jr c, .asm_132a7
	ld [wd265], a
	ld de, wd265
	ld bc, $0103
	call PrintNum
	jr .asm_132ad

.asm_132a7
	ld de, String_132cf
	call PlaceString
.asm_132ad
	hlcoord 1, 14
	predef PrintMoveDesc
	ld a, $1
	ld [hBGMapMode], a
	ret
; 132ba

String_132ba: ; 132ba
	db "┌─────┐@"
; 132c2

String_132c2: ; 132c2
	db "│TYPE/└@"
; 132ca

String_132ca: ; 132ca
	db "ATK/@"
; 132cf

String_132cf: ; 132cf
	db "---@"
; 132d3

Function132d3: ; 132d3
	call Function132da
	call Function132fe
	ret
; 132da

Function132da: ; 132da
	ld a, [CurPartyMon]
	and a
	ret z
	ld c, a
	ld e, a
	ld d, 0
	ld hl, PartyCount
	add hl, de
.asm_132e7
	ld a, [hl]
	and a
	jr z, .asm_132f3
	cp EGG
	jr z, .asm_132f3
	cp NUM_POKEMON + 1
	jr c, .asm_132f8
.asm_132f3
	dec hl
	dec c
	jr nz, .asm_132e7
	ret

.asm_132f8
	hlcoord 16, 0
	ld [hl], $71
	ret
; 132fe

Function132fe: ; 132fe
	ld a, [CurPartyMon]
	inc a
	ld c, a
	ld a, [PartyCount]
	cp c
	ret z
	ld e, c
	ld d, 0
	ld hl, PartySpecies
	add hl, de
.asm_1330f
	ld a, [hl]
	cp $ff
	ret z
	and a
	jr z, .asm_1331e
	cp EGG
	jr z, .asm_1331e
	cp NUM_POKEMON + 1
	jr c, .asm_13321
.asm_1331e
	inc hl
	jr .asm_1330f

.asm_13321
	hlcoord 18, 0
	ld [hl], "▶"
	ret
; 13327

SelectMenu:: ; 13327
	call CheckRegisteredItem
	jr c, .NotRegistered
	jp UseRegisteredItem

.NotRegistered
	call Function2e08
	ld b, BANK(ItemMayBeRegisteredText)
	ld hl, ItemMayBeRegisteredText
	call Function269a
	call Functiona46
	jp Function2dcf
; 13340

ItemMayBeRegisteredText: ; 13340
	text_jump UnknownText_0x1c1cf3
	db "@"
; 13345

CheckRegisteredItem: ; 13345
	ld a, [WhichRegisteredItem]
	and a
	jr z, .NoRegisteredItem
	and REGISTERED_POCKET
	rlca
	rlca
	ld hl, .Pockets
	rst JumpTable
	ret

.Pockets
	dw .CheckItem
	dw .CheckBall
	dw .CheckKeyItem
	dw .CheckTMHM

.CheckItem
	ld hl, NumItems
	call .CheckRegisteredNo
	jr c, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	and a
	ret

.CheckKeyItem
	ld a, [RegisteredItem]
	ld hl, KeyItems
	ld de, 1
	call IsInArray
	jr nc, .NoRegisteredItem
	ld a, [RegisteredItem]
	ld [CurItem], a
	and a
	ret

.CheckBall
	ld hl, NumBalls
	call .CheckRegisteredNo
	jr nc, .NoRegisteredItem
	inc hl
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	call .IsSameItem
	jr c, .NoRegisteredItem
	ret

.CheckTMHM
	jr .NoRegisteredItem

.NoRegisteredItem
	xor a
	ld [WhichRegisteredItem], a
	ld [RegisteredItem], a
	scf
	ret
; 133a6

.CheckRegisteredNo ; 133a6
	ld a, [WhichRegisteredItem]
	and REGISTERED_NUMBER
	dec a
	cp [hl]
	jr nc, .NotEnoughItems
	ld [wd107], a
	and a
	ret

.NotEnoughItems
	scf
	ret
; 133b6

.IsSameItem ; 133b6
	ld a, [RegisteredItem]
	cp [hl]
	jr nz, .NotSameItem
	ld [CurItem], a
	and a
	ret

.NotSameItem
	scf
	ret
; 133c3

UseRegisteredItem: ; 133c3
	callba CheckItemMenu
	ld a, [wd142]
	ld hl, .SwitchTo
	rst JumpTable
	ret

.SwitchTo
	dw .CantUse
	dw .NoFunction
	dw .NoFunction
	dw .NoFunction
	dw .Current
	dw .Party
	dw .Overworld
; 133df

.NoFunction ; 133df
	call Function2e08
	call CantUseItem
	call Function2dcf
	and a
	ret
; 133ea

.Current ; 133ea
	call Function2e08
	call DoItemEffect
	call Function2dcf
	and a
	ret
; 133f5

.Party ; 133f5
	call ResetWindow
	call FadeToMenu
	call DoItemEffect
	call Function2b3c
	call Function2dcf
	and a
	ret
; 13406

.Overworld ; 13406
	call ResetWindow
	ld a, 1
	ld [wd0ef], a
	call DoItemEffect
	xor a
	ld [wd0ef], a
	ld a, [wd0ec]
	cp 1
	jr nz, .asm_13425
	scf
	ld a, $80
	ld [$ffa0], a
	ret
; 13422

.CantUse ; 13422
	call ResetWindow
.asm_13425
	call CantUseItem
	call Function2dcf
	and a
	ret
; 1342d

Function1342d:: ; 1342d
	call Function1344a
	call Function1347d
	jr c, .asm_13448
	ld [wd041], a
	call Function134dd
	jr c, .asm_13448
	ld hl, wd041
	cp [hl]
	jr z, .asm_13448
	call Function134c0
	and a
	ret

.asm_13448
	scf
	ret
; 1344a

Function1344a: ; 1344a
	ld a, b
	ld [EngineBuffer1], a
	ld a, e
	ld [wd03f], a
	ld a, d
	ld [wd040], a
	call Function1345a
	ret
; 1345a

Function1345a: ; 1345a
	ld de, OBPals + 8 * 6
	ld bc, $0004
	ld hl, wd03f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [EngineBuffer1]
	call GetFarByte2
	ld [de], a
	inc de
.asm_1346f
	ld a, [EngineBuffer1]
	call GetFarByte
	ld [de], a
	inc de
	add hl, bc
	cp $ff
	jr nz, .asm_1346f
	ret
; 1347d

Function1347d: ; 1347d
	ld hl, wd03f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [EngineBuffer1]
	call GetFarByte
	ld c, a
	inc hl
	ld a, [BackupMapGroup]
	ld d, a
	ld a, [BackupMapNumber]
	ld e, a
	ld b, $0
.asm_13495
	ld a, [EngineBuffer1]
	call GetFarByte
	cp $ff
	jr z, .asm_134be
	inc hl
	inc hl
	ld a, [EngineBuffer1]
	call GetFarByte2
	cp d
	jr nz, .asm_134b7
	ld a, [EngineBuffer1]
	call GetFarByte2
	cp e
	jr nz, .asm_134b8
	jr .asm_134bb

.asm_134b7
	inc hl
.asm_134b8
	inc b
	jr .asm_13495

.asm_134bb
	xor a
	ld a, b
	ret

.asm_134be
	scf
	ret
; 134c0

Function134c0: ; 134c0
	push af
	ld hl, wd03f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	pop af
	ld bc, $0004
	call AddNTimes
	inc hl
	ld de, wdcac
	ld a, [EngineBuffer1]
	ld bc, $0003
	call FarCopyBytes
	ret
; 134dd

Function134dd: ; 134dd
	call Function1d6e
	ld hl, UnknownText_0x1350d
	call PrintText
	call Function13512
	ld hl, MenuDataHeader_0x13550
	call Function1d3c
	call Function352f
	call Function1ad2
	xor a
	ld [wd0e4], a
	call Function350c
	call Function1c17
	ld a, [wcf73]
	cp $2
	jr z, .asm_1350b
	xor a
	ld a, [wcf77]
	ret

.asm_1350b
	scf
	ret
; 1350d

UnknownText_0x1350d: ; 0x1350d
	; Which floor?
	text_jump UnknownText_0x1bd2bc
	db "@"
; 0x13512

Function13512: ; 13512
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	hlcoord 0, 0
	ld b, $4
	ld c, $8
	call TextBox
	hlcoord 1, 2
	ld de, String_13537
	call PlaceString
	hlcoord 4, 4
	call Function1353f
	pop af
	ld [Options], a
	ret
; 13537

String_13537: ; 13537
	db "Now on:@"
; 1353f

Function1353f: ; 1353f
	push hl
	ld a, [wd041]
	ld e, a
	ld d, 0
	ld hl, wd0f1
	add hl, de
	ld a, [hl]
	pop de
	call Function1356b
	ret
; 13550

MenuDataHeader_0x13550: ; 0x13550
	db $40 ; flags
	db 01, 12 ; start coords
	db 09, 18 ; end coords
	dw MenuData2_0x13558
	db 1 ; default option
; 0x13558

MenuData2_0x13558: ; 0x13558
	db $10 ; flags
	db 4, 0 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, OBPals + 8 * 6
	dbw BANK(Function13568), Function13568
	dbw BANK(NULL), NULL
	dbw BANK(NULL), NULL
; 13568

Function13568: ; 13568
	ld a, [MenuSelection]
Function1356b: ; 1356b
	push de
	call Function13575
	ld d, h
	ld e, l
	pop hl
	jp PlaceString
; 13575

Function13575: ; 13575
	push de
	ld e, a
	ld d, 0
	ld hl, .floors
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ret
; 13583

.floors
	dw .b4f
	dw .b3f
	dw .b2f
	dw .b1f
	dw ._1f
	dw ._2f
	dw ._3f
	dw ._4f
	dw ._5f
	dw ._6f
	dw ._7f
	dw ._8f
	dw ._9f
	dw ._10f
	dw ._11f
	dw .roof

.b4f
	db "B4F@"
.b3f
	db "B3F@"
.b2f
	db "B2F@"
.b1f
	db "B1F@"
._1f
	db "1F@"
._2f
	db "2F@"
._3f
	db "3F@"
._4f
	db "4F@"
._5f
	db "5F@"
._6f
	db "6F@"
._7f
	db "7F@"
._8f
	db "8F@"
._9f
	db "9F@"
._10f
	db "10F@"
._11f
	db "11F@"
.roof
	db "ROOF@"
; 135db

Function135db: ; 135db
	xor a
	ld [wdf9c], a ;clear contest mon
	ld a, $14
	ld [wdc79], a ;put 20 into number of spawns
	callba Function11490
	ret
; 135eb

UnknownScript_0x135eb:: ; 0x135eb
	writecode VAR_BATTLETYPE, BATTLETYPE_CONTEST
	battlecheck
	startbattle
	returnafterbattle
	copybytetovar wdc79
	iffalse UnknownScript_0x13603
	end
; 0x135f8

UnknownScript_0x135f8:: ; 0x135f8
	playsound SFX_ELEVATOR_END
	loadfont
	writetext UnknownText_0x1360f
	waitbutton
	jump UnknownScript_0x1360b
; 0x13603

UnknownScript_0x13603: ; 0x13603
	playsound SFX_ELEVATOR_END
	loadfont
	writetext UnknownText_0x13614
	waitbutton
UnknownScript_0x1360b: ; 0x1360b
	closetext
	jumpstd bugcontestresultswarp
; 0x1360f

UnknownText_0x1360f: ; 0x1360f
	; ANNOUNCER: BEEEP! Time's up!
	text_jump UnknownText_0x1bd2ca
	db "@"
; 0x13614

UnknownText_0x13614: ; 0x13614
	; ANNOUNCER: The Contest is over!
	text_jump UnknownText_0x1bd2e7
	db "@"
; 0x13619

UnknownScript_0x13619:: ; 0x13619
	loadfont
	writetext UnknownText_0x13620
	waitbutton
	closetext
	end
; 0x13620

UnknownText_0x13620: ; 0x13620
	; REPEL's effect wore off.
	text_jump UnknownText_0x1bd308
	db "@"
; 0x13625

UseAnotherRepelScript::
	loadfont
	writetext UseAnotherRepelText
	yesorno
	iffalse .quit
	callasm DoItemEffect
.quit
	closetext
	end

UseAnotherRepelText:
	text_jump _UseAnotherRepelText
	db "@"

UnknownScript_0x13625:: ; 0x13625
	loadfont
	copybytetovar Unkn2Pals
	itemtotext $0, $0
	writetext UnknownText_0x13645
	giveitem $ff, $1
	iffalse UnknownScript_0x1363e
	callasm Function1364f
	specialsound
	itemnotify
	jump UnknownScript_0x13643
; 0x1363e

UnknownScript_0x1363e: ; 0x1363e
	buttonsound
	writetext UnknownText_0x1364a
	waitbutton
UnknownScript_0x13643: ; 13643
	closetext
	end
; 0x13645

UnknownText_0x13645: ; 0x13645
	; found @ !
	text_jump UnknownText_0x1bd321
	db "@"
; 0x1364a

UnknownText_0x1364a: ; 0x1364a
	; But   has no space left<...>
	text_jump UnknownText_0x1bd331
	db "@"
; 0x1364f

Function1364f: ; 1364f
	ld hl, EngineBuffer1 ; wd03e (aliases: MenuItemsList, CurFruitTree, CurInput)
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld b, $1
	call EventFlagAction
	ret

Function1365b:: ; 1365b
	ld a, c
	ld de, 3
	ld hl, .table1
	call IsInArray
	jr nc, .asm_1367f
	ld a, $c ; jumpstd
	ld [wd03f], a
	inc hl
	ld a, [hli]
	ld [wd03f + 1], a
	ld a, [hli]
	ld [wd03f + 2], a
	ld a, BANK(UnknownScript_0x1369a)
	ld hl, UnknownScript_0x1369a
	call CallScript
	scf
	ret

.asm_1367f
	xor a
	ret
; 13681

.table1
	dbw $91, magazinebookshelf
	dbw $93, pcscript
	dbw $94, radio1
	dbw $95, townmap
	dbw $96, merchandiseshelf
	dbw $97, tv
	dbw $99, leaguestatues1
	dbw $9a, leaguestatues2
	dbw $9d, window
	dbw $9f, incenseburner
	db $ff ; end
; 1369a

UnknownScript_0x1369a: ; 0x1369a
	jump wd03f
; 0x1369d

Function1369d: ; 1369d
	call ContestScore ;calculate score and put it in hMultiplicand and hProduct
	callba Function105f79 ;save high score if new high score(?)
	call Function13819 ;input NPC and player scores and sort by who wins in d002 through d011
	ld a, [wd00a] ;third place trainer number (1 is player, 2 and up is NPC)
	call Function13730
	ld a, [wd00b] ;third place trainer mon
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0x13719 ;show third place text
	call PrintText
	ld a, [EndFlypoint]
	call Function13730
	ld a, [MovementBuffer]
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0x13702 ;same for second
	call PrintText
	ld a, [DefaultFlypoint]
	call Function13730
	ld a, [wd003]
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0x136eb ; and first
	call PrintText
	jp Function13807
; 136eb

UnknownText_0x136eb: ; 0x136eb
	text_jump UnknownText_0x1c10fa
	start_asm
; 0x136f0

Function136f0: ; 136f0
	ld de, SFX_1ST_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0x136fd
	ret
; 136fd

UnknownText_0x136fd: ; 0x136fd
	; The winning score was @  points!
	text_jump UnknownText_0x1c113f
	db "@"
; 0x13702

UnknownText_0x13702: ; 0x13702
	; Placing second was @, who caught a @ !@ @
	text_jump UnknownText_0x1c1166
	start_asm
; 0x13707

Function13707: ; 13707
	ld de, SFX_2ND_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0x13714
	ret
; 13714

UnknownText_0x13714: ; 0x13714
	; The score was @  points!
	text_jump UnknownText_0x1c1196
	db "@"
; 0x13719

UnknownText_0x13719: ; 0x13719
	; Placing third was @, who caught a @ !@ @
	text_jump UnknownText_0x1c11b5
	start_asm
; 0x1371e

Function1371e: ; 1371e
	ld de, SFX_3RD_PLACE
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0x1372b
	ret
; 1372b

UnknownText_0x1372b: ; 0x1372b
	; The score was @  points!
	text_jump UnknownText_0x1c11e4
	db "@"
; 0x13730

Function13730: ; 13730
	dec a
	jr z, .asm_13777 ;if player, jump
	ld c, a ;bc = contestent num -1
	ld b, 0
	ld hl, Unknown_13783
	add hl, bc
	add hl, bc ;jump to contestent address, put in hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli] ;put triner class in c
	ld c, a
	push hl ;name address
	push bc
	callab Function3952d ;stringbuffer 1 holds trainer class text
	ld hl, StringBuffer1
	ld de, wd016 ;inset into a variable
	ld bc, $000d
	call CopyBytes
	ld hl, wd016
.asm_13757
	ld a, [hli] ;load first letter into a
	cp $50
	jr nz, .asm_13757 ;if not end of string check next letter
	dec hl ;go back 1 to end of string
	ld [hl], $7f ;load text box border into string in place of end of string
	inc hl ;go back up
	ld d, h ;load location into de
	ld e, l
	pop bc ;c is trainer class
	pop hl ;is now name address
	push de ;de is location of last char before end of string
	ld a, [hl] ;load name address into b
	ld b, a
	callab Function3994c ;put trainer name in stringbuffer1
	ld hl, StringBuffer1
	pop de
	ld bc, $000a
	jp CopyBytes ; put name after trainer class, then ret

.asm_13777
	ld hl, PlayerName ;load playername into string instead, then ret
	ld de, wd016
	ld bc, $000b
	jp CopyBytes
; 13783

Unknown_13783: ; 13783
	dw Unknown_13799 ;repeated as never chosen?
	dw Unknown_13799
	dw Unknown_137a4
	dw Unknown_137af
	dw Unknown_137ba
	dw Unknown_137c5
	dw Unknown_137d0
	dw Unknown_137db
	dw Unknown_137e6
	dw Unknown_137f1
	dw Unknown_137fc
; 13799

Unknown_13799:
	db BUG_CATCHER, DON
	dbw KAKUNA,     403 ;
	dbw METAPOD,    413 ;
	dbw CATERPIE,   384 ;
Unknown_137a4:
	db BUG_CATCHER, ED
	dbw BUTTERFREE, 548 ;
	dbw VENOMOTH,  687 ;
	dbw LEDYBA,   465 ;
Unknown_137af:
	db COOLTRAINERM, NICK
	dbw SCYTHER,    621 ;
	dbw YANMA,      614 ;
	dbw PINSIR,     615 ;
Unknown_137ba:
	db POKEFANM, WILLIAM
	dbw SCIZOR,     667 ;
	dbw LEDIAN,     598 ;
	dbw VENONAT,    465 ;
Unknown_137c5:
	db BUG_CATCHER, BUG_CATCHER_BENNY
	dbw BEEDRILL,  698 ;
	dbw SPINARAK,   399 ;
	dbw CATERPIE,   373  ;
Unknown_137d0:
	db CAMPER, BARRY
	dbw HERACROSS,  637 ;
	dbw VENONAT,    454 ;
	dbw KAKUNA,     388 ;
Unknown_137db:
	db PICNICKER, CINDY
	dbw BUTTERFREE, 534 ;
	dbw METAPOD,    393 ;
	dbw CATERPIE,   369 ;
Unknown_137e6:
	db BUG_CATCHER, JOSH
	dbw PARASECT,   723 ;
	dbw ARIADOS,    665 ;
	dbw METAPOD,    388 ;
Unknown_137f1:
	db YOUNGSTER, SAMUEL
	dbw WEEDLE,     383 ;
	dbw HERACROSS,  625 ;
	dbw CATERPIE,   371 ;
Unknown_137fc:
	db SCHOOLBOY, KIPP
	dbw VENONAT,    456 ;
	dbw PARAS,      482 ;
	dbw KAKUNA,     498 ;
; 13807

Function13807: ; 13807
	ld hl, wd00a ;third place trainer number
	ld de, $fffc
	ld b, $3
.asm_1380f
	ld a, [hl]
	cp $1
	jr z, .asm_13818 ;if player, ret with b = place
	add hl, de ; add -4 to try next place
	dec b ; dec 1
	jr nz, .asm_1380f ;loop until 0 (which shows player is not in top 3)
.asm_13818
	ret ;b = players place
; 13819

Function13819: ; 13819
	call Function13833 ;clear flypoint and what's after it
	call Function138b0 ;put top 3 NPC contestents, mons and scores into variables wd002 through wd200d
	ld hl, wd00e ;slot to compare with other contestents
	ld a, $1
	ld [hli], a ;load player data into d00e through d011
	ld a, [wdf9c] ;caught mon species
	ld [hli], a
	ld a, [hProduct]
	ld [hli], a
	ld a, [hMultiplicand]
	ld [hl], a
	call Function1383e ;sort player score amongst AI to find players place
	ret
; 13833

Function13833: ; 13833
	ld hl, DefaultFlypoint
	ld b, $c ;loop 12 times
	xor a
.asm_13839
	ld [hli], a ;0 out default flypoint and 11 places after
	dec b
	jr nz, .asm_13839
	ret
; 1383e

Function1383e: ; 1383e
	ld de, wd010 ; score for to sort
	ld hl, wd004 ; current high score
	ld c, $2 ;legnth 2
	call StringCmp ;compare scores
	jr c, .asm_1386b ;if current high score > score to sort, jump
	ld hl, EndFlypoint ;d006 > d009 else moves others up the line and insert in the front
	ld de, wd00a ;d00a > d00d
	ld bc, $0004
	call CopyBytes
	ld hl, DefaultFlypoint ;d002 > d005
	ld de, EndFlypoint
	ld bc, $0004
	call CopyBytes
	ld hl, DefaultFlypoint
	call Function138a0 ;place [d00e] through [d011] in hl(02) through hl+3(05)
	jr .asm_1389f

.asm_1386b
	ld de, wd010
	ld hl, wd008 ;second place score
	ld c, $2
	call StringCmp
	jr c, .asm_1388c ;if current second score > score to test, jump
	ld hl, EndFlypoint ;else move others up and put it second
	ld de, wd00a
	ld bc, $0004
	call CopyBytes
	ld hl, EndFlypoint
	call Function138a0 ;place [d00e] through [d011] in hl(06) through hl+3(09)
	jr .asm_1389f

.asm_1388c
	ld de, wd010
	ld hl, wd00c
	ld c, $2
	call StringCmp ;if better then third, replace third
	jr c, .asm_1389f
	ld hl, wd00a
	call Function138a0 ;place [d00e] through [d011] in hl(0a) through hl+3(0d)
.asm_1389f ;? could just ret insteal of jumping here
	ret
; 138a0

Function138a0: ; 138a0
	ld de, wd00e
	ld a, [de]
	inc de
	ld [hli], a ;place [de] through [de+a] in hl through hl+3
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	ret
; 138b0

Function138b0: ; 138b0
	ld e, $0
.asm_138b2
	push de
	call Function139ed ;check flag 0 in contestent flag, a = 0 is flag not set, else flag is set
	pop de
	jr nz, .asm_138f9 ;if set, jump
	ld a, e
	inc a
	inc a
	ld [wd00e], a ;put e+2 in variable
	dec a
	ld c, a ;put e+1 in bc
	ld b, 0
	ld hl, Unknown_13783 ;load jump table towards bug catching AI scores and mons
	add hl, bc
	add hl, bc ;hl = correct table
	ld a, [hli]
	ld h, [hl]
	ld l, a ;put table to use in hl and move to position for mon search
	inc hl
	inc hl
.asm_138cd
	call Random
	and $3
	cp $3
	jr z, .asm_138cd ;load random  1-3
	ld c, a
	ld b, $0
	add hl, bc ;jump to correct slot
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wd00f], a ;store mon in ram
	ld a, [hli]; store score in HL
	ld h, [hl]
	ld l, a
	call Random
	and $7 ;rand 0-7
	ld c, a
	ld b, $0
	add hl, bc ;add score variace of up to +7
	ld a, h
	ld [wd010], a ;save it in variables
	ld a, l
	ld [wd011], a
	push de
	call Function1383e ;place new score amongsed other NPC scores
	pop de
.asm_138f9
	inc e ;next contestent?
	ld a, e
	cp $a ;if contestents left, loop. else ret
	jr nz, .asm_138b2
	ret
; 13900

ContestScore: ; 13900
; Determine the player's score in the Bug Catching Contest.

	xor a
	ld [hProduct], a
	ld [hMultiplicand], a ;holds score
	ld a, [wContestMonSpecies] ; Species
	and a
	jr z, .done ;if none, return zero
	; Tally the following:
	; Max HP * 4
	ld a, [wContestMonMaxHP + 1]
	call .AddContestStat
	ld a, [wContestMonMaxHP + 1]
	call .AddContestStat
	ld a, [wContestMonMaxHP + 1]
	call .AddContestStat
	ld a, [wContestMonMaxHP + 1]
	call .AddContestStat
	; Stats
	ld a, [wContestMonAttack  + 1]
	call .AddContestStat
	ld a, [wContestMonDefense + 1]
	call .AddContestStat
	ld a, [wContestMonSpeed   + 1]
	call .AddContestStat
	ld a, [wContestMonSpclAtk + 1]
	call .AddContestStat
	ld a, [wContestMonSpclDef + 1]
	call .AddContestStat
	; DVs
	ld a, [wContestMonDVs + 0]
	ld b, a
	and 2
	add a
	add a
	ld c, a
	swap b
	ld a, b
	and 2
	add a
	add c
	ld d, a
	ld a, [wContestMonDVs + 1]
	ld b, a
	and 2
	ld c, a
	swap b
	ld a, b
	and 2
	srl a
	add c
	add c
	add d
	add d
	call .AddContestStat
	; Remaining HP / 8
	ld a, [wContestMonHP + 1]
	srl a
	srl a
	srl a
	call .AddContestStat
	; Whether it's holding an item
	ld a, [wContestMonItem]
	and a
	jr z, .done
	ld a, 1
	call .AddContestStat
.done
	ret
; 1397f

.AddContestStat: ; 1397f
	ld hl, hMultiplicand
	add [hl]
	ld [hl], a
	ret nc
	dec hl
	inc [hl]
	ret
; 13988
; decreases all pokemon's pokerus counter by b. if the lower nybble reaches zero, the pokerus is cured.

ApplyPokerusTick: ; 13988
	ld hl, PartyMon1PokerusStatus
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
.asm_13991
	ld a, [hl]
	and $f
	jr z, .asm_139a0
	sub b
	jr nc, .asm_1399a
	xor a
.asm_1399a
	ld d, a
	ld a, [hl]
	and $f0
	add d
	ld [hl], a
.asm_139a0
	ld de, PartyMon2 - PartyMon1
	add hl, de
	dec c
	jr nz, .asm_13991
	ret
; 139a8

Function139a8: ; 139a8
	ld c, $a
	ld hl, Unknown_139fe
.asm_139ad
	push bc
	push hl
	ld e, [hl] ;load current contestent flag into de
	inc hl
	ld d, [hl]
	ld b, $0 ;clear that flag
	call EventFlagAction
	pop hl
	inc hl
	inc hl ;go to next slot
	pop bc
	dec c
	jr nz, .asm_139ad ;loop through whole table, clearing all flags
	ld c, $5
.asm_139c0
	push bc
.asm_139c1
	call Random
	cp $fa
	jr nc, .asm_139c1 ;rand 0-249
	ld c, $19
	call SimpleDivide ;rand / 25, answer in e
	ld e, b
	ld d, 0
	ld hl, Unknown_139fe ;go to contestent table
	add hl, de
	add hl, de ;go down that many slots
	ld e, [hl] ;load into de
	inc hl
	ld d, [hl]
	push de
	ld b, $2
	call EventFlagAction ;check that flag
	pop de
	ld a, c
	and a
	jr nz, .asm_139c1 ;jump if flag already set
	ld b, $1
	call EventFlagAction ;set flag
	pop bc
	dec c
	jr nz, .asm_139c0 ;loop 5 times
	ret
; 139ed

Function139ed: ; 139ed
	ld hl, Unknown_139fe
	ld e, a
	ld d, 0
	add hl, de
	add hl, de ;go to slot e in contestent table
	ld e, [hl] ;put address into de
	inc hl
	ld d, [hl]
	ld b, $2
	call EventFlagAction ;check that flag, a = 0 is flag not set, else flag is set
	ret
; 139fe

Unknown_139fe: ; 139fe refernces to contestent flags
	dw $0716
	dw $0717
	dw $0718
	dw $0719
	dw $071a
	dw $071b
	dw $071c
	dw $071d
	dw $071e
	dw $071f
; 13a12

Function13a12: ; 13a12
	ld hl, PartyMon1HP
	ld a, [hli]
	or [hl]
	jr z, .asm_13a2b ;if lead mon is fainted
	ld hl, PartyCount
	ld a, 1
	ld [hli], a ;set party to 1
	inc hl
	ld a, [hl] ;get species of second mon in party
	ld [wdf9b], a ;load into var
	ld [hl], $ff ;load fake end in it's place'
	xor a ;return 0
	ld [ScriptVar], a
	ret

.asm_13a2b
	ld a, $1
	ld [ScriptVar], a
	ret
; 13a31

Function13a31: ; 13a31
	ld hl, PartySpecies + 1
	ld a, [wdf9b] ;reload second mon name from variable
	ld [hl], a ;put back over fake end char
	ld b, $1
.asm_13a3a ;find size of party and set partyCount
	ld a, [hli]
	cp $ff
	jr z, .asm_13a42
	inc b
	jr .asm_13a3a

.asm_13a42
	ld a, b
	ld [PartyCount], a
	ret
; 13a47

Function13a47: ; 13a47
	ld hl, PartyCount
	ld a, [hl]
	and a
	ret z
	cp PARTY_LENGTH + 1
	jr c, .asm_13a54
	ld a, PARTY_LENGTH
	ld [hl], a
.asm_13a54
	inc hl
	ld b, a
	ld c, 0
.asm_13a58
	ld a, [hl]
	and a
	jr z, .asm_13a64
	cp $fc
	jr z, .asm_13a64
	cp $fe
	jr c, .asm_13a73
.asm_13a64
	ld [hl], SMEARGLE
	push hl
	push bc
	ld a, c
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld [hl], SMEARGLE
	pop bc
	pop hl
.asm_13a73
	inc hl
	inc c
	dec b
	jr nz, .asm_13a58
	ld [hl], $ff
	ld hl, PartyMon1
	ld a, [PartyCount]
	ld d, a
	ld e, 0
.asm_13a83
	push de
	push hl
	ld b, h
	ld c, l
	ld a, [hl]
	and a
	jr z, .asm_13a8f
	cp NUM_POKEMON + 1
	jr c, .asm_13a9c
.asm_13a8f
	ld [hl], SMEARGLE
	push de
	ld d, 0
	ld hl, PartySpecies
	add hl, de
	pop de
	ld a, SMEARGLE
	ld [hl], a
.asm_13a9c
	ld [CurSpecies], a
	call GetBaseData
	ld hl, PartyMon1Level - PartyMon1
	add hl, bc
	ld a, [hl]
	cp MIN_LEVEL
	ld a, MIN_LEVEL
	jr c, .asm_13ab4
	ld a, [hl]
	cp MAX_LEVEL
	jr c, .asm_13ab5
	ld a, MAX_LEVEL
.asm_13ab4
	ld [hl], a
.asm_13ab5
	ld [CurPartyLevel], a
	ld hl, PartyMon1MaxHP - PartyMon1
	add hl, bc
	ld d, h
	ld e, l
	ld hl, PartyMon1Exp + 2 - PartyMon1
	add hl, bc
	ld b, $1
	predef CalcPkmnStats
	pop hl
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop de
	inc e
	dec d
	jr nz, .asm_13a83
	ld de, PartyMonNicknames
	ld a, [PartyCount]
	ld b, a
	ld c, 0
.asm_13adc
	push bc
	call Function13b71
	push de
	callba Function17d073
	pop hl
	pop bc
	jr nc, .asm_13b0e
	push bc
	push hl
	ld hl, PartySpecies
	push bc
	ld b, 0
	add hl, bc
	pop bc
	ld a, [hl]
	cp EGG
	ld hl, String_13b6b
	jr z, .asm_13b06
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
.asm_13b06
	pop de
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	pop bc
.asm_13b0e
	inc c
	dec b
	jr nz, .asm_13adc
	ld de, PartyMonOT
	ld a, [PartyCount]
	ld b, a
	ld c, 0
.asm_13b1b
	push bc
	call Function13b71
	push de
	callba Function17d073
	pop hl
	jr nc, .asm_13b34
	ld d, h
	ld e, l
	ld hl, PlayerName
	ld bc, $000b
	call CopyBytes
.asm_13b34
	pop bc
	inc c
	dec b
	jr nz, .asm_13b1b
	ld hl, PartyMon1Moves
	ld a, [PartyCount]
	ld b, a
.asm_13b40
	push hl
	ld c, NUM_MOVES
	ld a, [hl]
	and a
	jr z, .asm_13b4b
	cp NUM_ATTACKS + 1
	jr c, .asm_13b4d
.asm_13b4b
	ld [hl], POUND
.asm_13b4d
	ld a, [hl]
	and a
	jr z, .asm_13b55
	cp NUM_ATTACKS + 1
	jr c, .asm_13b5c
.asm_13b55
	xor a
	ld [hli], a
	dec c
	jr nz, .asm_13b55
	jr .asm_13b60

.asm_13b5c
	inc hl
	dec c
	jr nz, .asm_13b4d
.asm_13b60
	pop hl
	push bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_13b40
	ret
; 13b6b

String_13b6b: ; 13b6b
	db "タマゴ@@@"
; 13b71

Function13b71: ; 13b71
	push de
	ld c, 1
	ld b, 6
.asm_13b76
	ld a, [de]
	cp "@"
	jr z, .asm_13b85
	inc de
	inc c
	dec b
	jr nz, .asm_13b76
	dec c
	dec de
	ld a, "@"
	ld [de], a
.asm_13b85
	pop de
	ret
; 13b87

GetSquareRoot: ; 13b87
; b = min(⌈√de⌉,255)
	ld a, d
	or e
	jr z, .zero
	ld hl, 0
	ld bc, 1 << 14
.loop1
	ld a, b
	cp d
	jr c, .loop2
	jr nz, .gt1
	ld a, c
	cp e
	jr c, .loop2
.gt1
	srl b
	rr c
	srl b
	rr c
	jr .loop1
.loop2
	push hl
	add hl, bc
	ld a, h
	cp d
	jr c, .lt2
	jr nz, .gt2
	ld a, e
	cp l
	jr nc, .lt2
.gt2
	pop hl
	srl h
	rr l
	jr .check0
.lt2
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	pop hl
	srl h
	rr l
	add hl, bc
.check0
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .loop2
	ld a, d
	or e
	jr z, .noadd
	inc hl
.noadd
	ld a, h
	and a
	jr nz, .ld255
	ld b, l
	ret
.ld255
	ld b, $ff
	ret
.zero
	ld b, 0
	ret

SECTION "bank5", ROMX, BANK[$5]

StopRTC: ; 14000
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	call LatchClock
	ld a, RTC_DH
	ld [MBC3SRamBank], a
	ld a, [MBC3RTC]
	set 6, a ; halt
	ld [MBC3RTC], a
	call CloseSRAM
	ret
; 14019

StartRTC: ; 14019
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	call LatchClock
	ld a, RTC_DH
	ld [MBC3SRamBank], a
	ld a, [MBC3RTC]
	res 6, a ; halt
	ld [MBC3RTC], a
	call CloseSRAM
	ret
; 14032

GetTimeOfDay:: ; 14032
; get time of day based on the current hour

	ld a, [hHours] ; hour
	ld hl, TimesOfDay

.check
; if we're within the given time period,
; get the corresponding time of day

	cp [hl]
	jr c, .match
; else, get the next entry

	inc hl
	inc hl
; try again

	jr .check

.match
; get time of day

	inc hl
	ld a, [hl]
	ld [TimeOfDay], a
	ret
; 14044

TimesOfDay: ; 14044
; hours for the time of day
; 04-09 morn | 10-17 day | 18-03 nite

	db 04, NITE
	db 10, MORN
	db 18, DAY
	db 24, NITE
	db -1, MORN
; 1404e

Unknown_1404e: ; 1404e
	db 20, 2
	db 40, 0
	db 60, 1
	db -1, 0
; 14056

Function14056: ; 14056
	call UpdateTime
	ld hl, wRTC
	ld a, [CurDay]
	ld [hli], a
	ld a, [hHours]
	ld [hli], a
	ld a, [hMinutes]
	ld [hli], a
	ld a, [hSeconds]
	ld [hli], a
	ret
; 1406a

Function1406a: ; 1406a
	ld a, $a
	ld [MBC3SRamEnable], a
	call LatchClock
	ld hl, MBC3RTC
	ld a, $c
	ld [MBC3SRamBank], a
	res 7, [hl]
	ld a, $0
	ld [MBC3SRamBank], a
	xor a
	ld [$ac60], a
	call CloseSRAM
	ret
; 14089

StartClock:: ; 14089
	call GetClock
	call Function1409b
	call FixDays
	jr nc, .asm_14097
	call Function6d3
.asm_14097
	call StartRTC
	ret
; 1409b

Function1409b: ; 1409b
	ld hl, hRTCDayHi
	bit 7, [hl]
	jr nz, .asm_140a8
	bit 6, [hl]
	jr nz, .asm_140a8
	xor a
	ret

.asm_140a8
	ld a, $80
	call Function6d3
	ret
; 140ae

Function140ae: ; 140ae
	call Function6e3
	ld c, a
	and $c0
	jr nz, .asm_140c8
	ld a, c
	and $20
	jr z, .asm_140eb
	call UpdateTime
	ld a, [wRTC + 0]
	ld b, a
	ld a, [CurDay]
	cp b
	jr c, .asm_140eb
.asm_140c8
	callba ResetDailyTimers
	callba Function170923
	ld a, $5
	call GetSRAMBank
	ld a, [$aa8c]
	inc a
	ld [$aa8c], a
	ld a, [$b2fa]
	inc a
	ld [$b2fa], a
	call CloseSRAM
	ret

.asm_140eb
	xor a
	ret
; 140ed

Function140ed:: ; 140ed
	call GetClock
	call FixDays
	ld hl, hRTCSeconds
	ld de, StartSecond
	ld a, [StringBuffer2 + 3]
	sub [hl]
	dec hl
	jr nc, .asm_14102
	add 60
.asm_14102
	ld [de], a
	dec de
	ld a, [StringBuffer2 + 2]
	sbc [hl]
	dec hl
	jr nc, .asm_1410d
	add 60
.asm_1410d
	ld [de], a
	dec de
	ld a, [StringBuffer2 + 1]
	sbc [hl]
	dec hl
	jr nc, .asm_14118
	add 24
.asm_14118
	ld [de], a
	dec de
	ld a, [StringBuffer2]
	sbc [hl]
	dec hl
	jr nc, .asm_14128
	add 140
	ld c, 7
	call SimpleDivide
.asm_14128
	ld [de], a
	ret
; 1412a

Function1412a: ; 1412a
	ld a, $1
	ld [rVBK], a
	call Get2bpp
	xor a
	ld [rVBK], a
	ret
; 14135

Function14135:: ; 14135
	call GetPlayerSprite
	ld a, [UsedSprites]
	ld [$ffbd], a
	ld a, [UsedSprites + 1]
	ld [$ffbe], a
	call Function143c8
	ret
; 14146

Function14146: ; 14146
	ld hl, wd13e
	ld a, [hl]
	push af
	res 7, [hl]
	set 6, [hl]
	call Function14209
	pop af
	ld [wd13e], a
	ret
; 14157

Function14157: ; 14157
	ld hl, wd13e
	ld a, [hl]
	push af
	set 7, [hl]
	res 6, [hl]
	call Function14209
	pop af
	ld [wd13e], a
	ret
; 14168

Function14168:: ; 14168
	call Function1416f
	call Function14209
	ret
; 1416f

Function1416f: ; 1416f
	xor a
	ld bc, $0040
	ld hl, UsedSprites
	call ByteFill
	call GetPlayerSprite
	call AddMapSprites
	call Function142db
	ret
; 14183

GetPlayerSprite: ; 14183
; Get Chris or Kris's sprite.

	ld hl, .Chris
	ld a, [wd45b]
	bit 2, a
	jr nz, .go
	ld a, [PlayerGender]
	bit 0, a
	jr z, .go
	ld hl, .Kris
.go
	ld a, [PlayerState]
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr z, .asm_141ac
	inc hl
	cp $ff
	jr nz, .loop
; Any player state not in the array defaults to Chris's sprite.

	xor a ; ld a, PLAYER_NORMAL
	ld [PlayerState], a
	ld a, SPRITE_RUST
	jr .asm_141ad

.asm_141ac
	ld a, [hl]
.asm_141ad
	ld [UsedSprites + 0], a
	ld [PlayerStruct + 0], a
	ld [MapObjects + OBJECT_LENGTH * 0 + 1], a
	ret

.Chris
	db PLAYER_NORMAL,    SPRITE_RUST
	db PLAYER_BIKE,      SPRITE_RUST_BIKE
	db PLAYER_SURF,      SPRITE_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff
.Kris
	db PLAYER_NORMAL,    SPRITE_AZURE
	db PLAYER_BIKE,      SPRITE_AZURE_BIKE
	db PLAYER_SURF,      SPRITE_SURF
	db PLAYER_SURF_PIKA, SPRITE_SURFING_PIKACHU
	db $ff
; 141c9

AddMapSprites: ; 141c9
	call GetMapPermission
	call CheckOutdoorMap
	jr z, .outdoor
	call AddIndoorSprites
	ret

.outdoor
	call AddOutdoorSprites
	ret
; 141d9

AddIndoorSprites: ; 141d9
	ld hl, MapObjects + 1 * OBJECT_LENGTH + 1 ; sprite
	ld a, 1
.loop
	push af
	ld a, [hl]
	call AddSpriteGFX
	ld de, OBJECT_LENGTH
	add hl, de
	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	ret
; 141ee

AddOutdoorSprites: ; 141ee
	ld a, [MapGroup]
	dec a
	ld c, a
	ld b, 0
	ld hl, OutdoorSprites
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $17
.loop
	push bc
	ld a, [hli]
	call AddSpriteGFX
	pop bc
	dec c
	jr nz, .loop
	ret
; 14209

Function14209: ; 14209
	ld a, $4
	call Function263b
	call Function1439b
	call Function14215
	ret
; 14215

Function14215: ; 14215
	ld a, [wd13e]
	bit 6, a
	ret nz
	ld c, $8
	callba Function1442f
	call GetMapPermission
	call CheckOutdoorMap
	ld c, $b
	jr z, .asm_1422f
	ld c, $a
.asm_1422f
	callba Function1442f
	ret
; 14236

SafeGetSprite: ; 14236
	push hl
	call GetSprite
	pop hl
	ret
; 1423c

GetSprite: ; 1423c
	call GetMonSprite
	ret c
	ld hl, SpriteHeaders
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	swap a
	ld c, a
	ld b, [hl]
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ret
; 14259

GetMonSprite: ; 14259
; Return carry if a monster sprite was loaded.

	cp SPRITE_POKEMON
	jr c, .Normal
	cp SPRITE_DAYCARE_MON_1
	jr z, .wBreedMon1
	cp SPRITE_DAYCARE_MON_2
	jr z, .wBreedMon2
	cp SPRITE_VARS
	jr nc, .Variable
	jr .Icon

.Normal
	and a
	ret

.Icon
	sub SPRITE_POKEMON
	ld e, a
	ld d, 0
	ld hl, SpriteMons
	add hl, de
	ld a, [hl]
	jr .Mon

.wBreedMon1
	ld a, [wBreedMon1Species]
	jr .Mon

.wBreedMon2
	ld a, [wBreedMon2Species]
.Mon
	ld e, a
	and a
	jr z, .asm_1429f
	callba Function8e82b
	ld l, 1
	ld h, 0
	scf
	ret

.Variable
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, VariableSprites
	add hl, de
	ld a, [hl]
	and a
	jp nz, GetMonSprite
.asm_1429f
	ld a, 1
	ld l, 1
	ld h, 0
	and a
	ret
; 142a7

Function142a7:: ; 142a7
	cp SPRITE_POKEMON
	jr nc, .asm_142c2
	push hl
	push bc
	ld hl, SpriteHeaders + 4
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld a, [hl]
	pop bc
	pop hl
	cp 3
	jr nz, .asm_142c2
	scf
	ret

.asm_142c2
	and a
	ret
; 142c4

_GetSpritePalette:: ; 142c4
	ld a, c
	call GetMonSprite
	jr c, .asm_142d8
	ld hl, SpriteHeaders + 5 ; palette
	dec a
	ld c, a
	ld b, 0
	ld a, 6
	call AddNTimes
	ld c, [hl]
	ret

.asm_142d8
	xor a
	ld c, a
	ret
; 142db

Function142db: ; 142db
	call LoadSpriteGFX
	call SortUsedSprites
	call ArrangeUsedSprites
	ret
; 142e5

AddSpriteGFX: ; 142e5
; Add any new sprite ids to a list of graphics to be loaded.
; Return carry if the list is full.

	push hl
	push bc
	ld b, a
	ld hl, UsedSprites + 2
	ld c, $1f
.loop
	ld a, [hl]
	cp b
	jr z, .exists
	and a
	jr z, .new
	inc hl
	inc hl
	dec c
	jr nz, .loop
	pop bc
	pop hl
	scf
	ret

.exists
	pop bc
	pop hl
	and a
	ret

.new
	ld [hl], b
	pop bc
	pop hl
	and a
	ret
; 14306

LoadSpriteGFX: ; 14306
; Bug: b is not preserved, so
; it's useless as a loop count.

	ld hl, UsedSprites
	ld b, $20
.loop
	push bc
	ld a, [hli]
	and a
	jr z, .done
	push hl
	call .LoadSprite
	pop hl
	ld [hli], a
	pop bc
	dec b
	jr nz, .loop
.done
	pop bc
	ret

.LoadSprite
	call GetSprite
	ld a, l
	ret
; 1431e

SortUsedSprites: ; 1431e
; Bubble-sort sprites by type.
; Run backwards through UsedSprites to find the last one.

	ld c, $20
	ld de, UsedSprites + ($20 - 1) * 2
.FindLastSprite
	ld a, [de]
	and a
	jr nz, .FoundLastSprite
	dec de
	dec de
	dec c
	jr nz, .FindLastSprite
.FoundLastSprite
	dec c
	jr z, .quit
; If the length of the current sprite is
; higher than a later one, swap them.

	inc de
	ld hl, UsedSprites + 1
.CheckSprite
	push bc
	push de
	push hl
.CheckFollowing
	ld a, [de]
	cp [hl]
	jr nc, .next
; Swap the two sprites.

	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	dec de
	dec hl
	ld a, [de]
	ld b, a
	ld a, [hl]
	ld [hl], b
	ld [de], a
	inc de
	inc hl
; Keep doing this until everything's in order.

.next
	dec de
	dec de
	dec c
	jr nz, .CheckFollowing
	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, .CheckSprite
.quit
	ret
; 14355

ArrangeUsedSprites: ; 14355
; Get the length of each sprite and space them out in VRAM.
; Crystal introduces a second table in VRAM bank 0.

	ld hl, UsedSprites
	ld c, $20
	ld b, 0
.FirstTableLength
; Keep going until the end of the list.

	ld a, [hli]
	and a
	jr z, .quit
	ld a, [hl]
	call GetSpriteLength
; Spill over into the second table after $80 tiles.

	add b
	cp $80
	jr z, .next
	jr nc, .SecondTable
.next
	ld [hl], b
	inc hl
	ld b, a
; Assumes the next table will be reached before c hits 0.

	dec c
	jr nz, .FirstTableLength
.SecondTable
; The second tile table starts at tile $80.

	ld b, $80
	dec hl
.SecondTableLength
; Keep going until the end of the list.

	ld a, [hli]
	and a
	jr z, .quit
	ld a, [hl]
	call GetSpriteLength
; There are only two tables, so don't go any further than that.

	add b
	jr c, .quit
	ld [hl], b
	ld b, a
	inc hl
	dec c
	jr nz, .SecondTableLength
.quit
	ret
; 14386

GetSpriteLength: ; 14386
; Return the length of sprite type a in tiles.

	cp WALKING_SPRITE
	jr z, .AnyDirection
	cp STANDING_SPRITE
	jr z, .AnyDirection
	cp STILL_SPRITE
	jr z, .OneDirection
	ld a, 12
	ret

.AnyDirection
	ld a, 12
	ret

.OneDirection
	ld a, 4
	ret
; 1439b

Function1439b: ; 1439b
	ld hl, UsedSprites
	ld c, $20
.asm_143a0
	ld a, [wd13e]
	res 5, a
	ld [wd13e], a
	ld a, [hli]
	and a
	jr z, .asm_143c7
	ld [$ffbd], a
	ld a, [hli]
	ld [$ffbe], a
	bit 7, a
	jr z, .asm_143bd
	ld a, [wd13e]
	set 5, a
	ld [wd13e], a
.asm_143bd
	push bc
	push hl
	call Function143c8
	pop hl
	pop bc
	dec c
	jr nz, .asm_143a0
.asm_143c7
	ret
; 143c8

Function143c8: ; 143c8
	ld a, [$ffbd]
	call SafeGetSprite
	ld a, [$ffbe]
	call Function14406
	push hl
	push de
	push bc
	ld a, [wd13e]
	bit 7, a
	jr nz, .asm_143df
	call Function14418
.asm_143df
	pop bc
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	pop de
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, [wd13e]
	bit 5, a
	jr nz, .asm_14405
	bit 6, a
	jr nz, .asm_14405
	ld a, [$ffbd]
	call Function142a7
	jr c, .asm_14405
	ld a, h
	add $8
	ld h, a
	call Function14418
.asm_14405
	ret
; 14406

Function14406: ; 14406
	swap a
	push af
	and $f0
	ld l, a
	pop af
	and $7
	or $80
	ld h, a
	ret
; 14418

Function14418: ; 14418
	ld a, [rVBK]
	push af
	ld a, [wd13e]
	bit 5, a
	ld a, $1
	jr z, .asm_14426
	ld a, $0
.asm_14426
	ld [rVBK], a
	call Get2bpp
	pop af
	ld [rVBK], a
	ret
; 1442f

Function1442f:: ; 1442f
	ld a, c
	ld bc, 6
	ld hl, EmotesPointers
	call AddNTimes
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	swap c
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	and a
	ret z
	call Function1412a
	ret
; 1444d

EmotesPointers: ; 144d
; dw source address
; db length, bank
; dw dest address

	dw ShockEmote
	db $40, BANK(ShockEmote)
	dw $8f80
	dw QuestionEmote
	db $40, BANK(QuestionEmote)
	dw $8f80
	dw HappyEmote
	db $40, BANK(HappyEmote)
	dw $8f80
	dw SadEmote
	db $40, BANK(SadEmote)
	dw $8f80
	dw HeartEmote
	db $40, BANK(HeartEmote)
	dw $8f80
	dw BoltEmote
	db $40, BANK(BoltEmote)
	dw $8f80
	dw SleepEmote
	db $40, BANK(SleepEmote)
	dw $8f80
	dw FishEmote
	db $40, BANK(FishEmote)
	dw $8f80
	dw FishingRodGFX + $00
	db $10, BANK(FishingRodGFX)
	dw $8fc0
	dw FishingRodGFX + $10
	db $20, BANK(FishingRodGFX)
	dw $8fc0
	dw FishingRodGFX + $30
	db $20, BANK(FishingRodGFX)
	dw $8fe0
	dw FishingRodGFX + $50
	db $10, BANK(FishingRodGFX)
	dw $8fe0
; 14495

SpriteMons: ; 14495
	db UNOWN
	db GEODUDE
	db GROWLITHE
	db WEEDLE
	db SHELLDER
	db ODDISH
	db GENGAR
	db ZUBAT
	db MAGIKARP
	db SQUIRTLE
	db TOGEPI
	db BUTTERFREE
	db DIGLETT
	db POLIWAG
	db PIKACHU
	db CLEFAIRY
	db CHARMANDER
	db JYNX
	db STARMIE
	db BULBASAUR
	db JIGGLYPUFF
	db GRIMER
	db EKANS
	db PARAS
	db TENTACOOL
	db TAUROS
	db MACHOP
	db VOLTORB
	db LAPRAS
	db RHYDON
	db SPEAROW
	db SNORLAX
	db GYARADOS
	db LUGIA
	db HO_OH
	db ARTICUNO
	db ZAPDOS
	db MOLTRES
	db EGG
; 144b8


OutdoorSprites: ; 144b8
; Valid sprite IDs for each map group.

	dw Group1Sprites
	dw Group2Sprites
	dw Group3Sprites
	dw Group4Sprites
	dw Group5Sprites
	dw Group6Sprites
	dw Group7Sprites
	dw Group8Sprites
	dw Group9Sprites
	dw Group10Sprites
	dw Group11Sprites
	dw Group12Sprites
	dw Group13Sprites
	dw Group14Sprites
	dw Group15Sprites
	dw Group16Sprites
	dw Group17Sprites
	dw Group18Sprites
	dw Group19Sprites
	dw Group20Sprites
	dw Group21Sprites
	dw Group22Sprites
	dw Group23Sprites
	dw Group24Sprites
	dw Group25Sprites
	dw Group26Sprites
	dw Group27Sprites
	dw Group28Sprites
	dw Group29Sprites
	dw Group30Sprites
	dw Group31Sprites
	dw Group32Sprites
	dw Group33Sprites
	dw Group34Sprites
	dw Group35Sprites
; 144ec

Group1Sprites: ; 146a1
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BUENA
	db SPRITE_AZALEA_ROCKET
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK ; 23
; 146b8

Group2Sprites: ; 146cf
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_M
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL ; 23
; 146e6

Group3Sprites: ; 146fd
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_GAMEBOY_KID
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LASS
	db SPRITE_POKEFAN_F
	db SPRITE_TEACHER
	db SPRITE_YOUNGSTER
	db SPRITE_GROWLITHE
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKER
	db SPRITE_FISHER
	db SPRITE_SCIENTIST
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER ; 23
; 14714

Group4Sprites: ; 14645
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 1465c

Group5Sprites: ; 146e6
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS ;
	db SPRITE_YOUNGSTER ;
	db SPRITE_LASS ;
	db SPRITE_SUPER_NERD ;
	db SPRITE_COOLTRAINER_M ;
	db SPRITE_POKEFAN_M ;
	db SPRITE_BLACK_BELT ;
	db SPRITE_COOLTRAINER_F ;
	db SPRITE_FISHER
	db SPRITE_FRUIT_TREE ;
	db SPRITE_POKE_BALL ; 23
; 146fd

Group6Sprites: ; 14531
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14548

Group7Sprites: ; 14548
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_MISTY
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE ; 23
; 1455f

Group8Sprites: ; 1465c
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_KURT_OUTSIDE
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_BLACK_BELT
	db SPRITE_TEACHER
	db SPRITE_AZALEA_ROCKET
	db SPRITE_LASS
	db SPRITE_SILVER
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE ; 23
; 14673

Group9Sprites: ; 146b8
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_LANCE
	db SPRITE_GRAMPS
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_LASS
	db SPRITE_YOUNGSTER
	db SPRITE_GYARADOS
	db SPRITE_FRUIT_TREE
	db SPRITE_POKE_BALL ; 23
; 146cf

Group10Sprites: ; 1462e
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_WEIRD_TREE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14645

Group11Sprites: ; 14673
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_EGG
	; db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_OFFICER
	db SPRITE_POKEFAN_M
	db SPRITE_DAYCARE_MON_1
	db SPRITE_COOLTRAINER_F
	db SPRITE_ROCKET
	db SPRITE_LASS
	db SPRITE_DAYCARE_MON_2
	db SPRITE_FRUIT_TREE
	db SPRITE_SLOWPOKE ; 23
; 1468a

Group12Sprites: ; 145a4
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_PHARMACIST
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	; db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 145bb

Group13Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_SIDEWAYS_GRAMPS
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14503

Group14Sprites: ; 1451a
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_PHARMACIST
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	; db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14531

Group15Sprites: ; 14714
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SAILOR
	db SPRITE_FISHING_GURU
	db SPRITE_GENTLEMAN
	db SPRITE_SUPER_NERD
	db SPRITE_HO_OH
	db SPRITE_TEACHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_YOUNGSTER
	db SPRITE_FAIRY
	db SPRITE_POKE_BALL
	db SPRITE_ROCK ; 23
; 1472b

Group16Sprites: ; 145d2
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_BUENA
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_EGK_RIVAL
	db SPRITE_SUPER_NERD
	db SPRITE_MACHOP
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_BOULDER ; 23
; 145e9

Group17Sprites: ; 145bb
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 145d2

Group18Sprites: ; 1458d
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_MACHOP
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_SUPER_NERD
	db SPRITE_BIG_SNORLAX
	db SPRITE_BIKER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 145a4

Group19Sprites: ; 14617
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_RED
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 1462e

Group20Sprites: ; 1472b
	db SPRITE_OAK
	db SPRITE_FISHER
	db SPRITE_TEACHER
	db SPRITE_TWIN
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_FAIRY
	db SPRITE_SILVER
	db SPRITE_FISHING_GURU
	db SPRITE_POKE_BALL
	db SPRITE_POKEDEX ; 11
; 1451a

Group21Sprites: ; 14576
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_FISHER
	db SPRITE_POLIWAG
	db SPRITE_TEACHER
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_BIKER
	db SPRITE_SILVER
	db SPRITE_BLUE
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 1458d

Group22Sprites: ; 1468a
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_STANDING_YOUNGSTER
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_OLIVINE_RIVAL
	db SPRITE_POKEFAN_M
	db SPRITE_LASS
	db SPRITE_BUENA
	db SPRITE_AZALEA_ROCKET
	db SPRITE_SAILOR
	db SPRITE_POKEFAN_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_TAUROS
	db SPRITE_FRUIT_TREE
	db SPRITE_ROCK ; 23
; 146a1

Group23Sprites: ; 14503
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_SIDEWAYS_GRAMPS
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_BLUE
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_SWIMMER_GIRL
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 1451a

Group24Sprites: ; 145e9
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14600

Group25Sprites: ; 1455f
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_COOLTRAINER_M
	db SPRITE_SUPER_NERD
	db SPRITE_COOLTRAINER_F
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_LASS
	db SPRITE_POKEFAN_M
	db SPRITE_ROCKET
	db SPRITE_MISTY
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE ; 23
; 14576

Group26Sprites: ; 14600
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_SILVER
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_COOLTRAINER_M
	db SPRITE_YOUNGSTER
	db SPRITE_MONSTER
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23
; 14617

Group27Sprites:
Group28Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_BUG_CATCHER
	db SPRITE_SAILOR
	db SPRITE_BILL
	db SPRITE_BOULDER
	db SPRITE_BIRD
	db SPRITE_PHARMACIST
	db SPRITE_SUPER_NERD
	db SPRITE_MONSTER
	db SPRITE_BABA
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 22

Group29Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_SIDEWAYS_GRAMPS
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_EGK_RIVAL
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_COOLTRAINER_F
	db SPRITE_OAK
	db SPRITE_SWIMMER_GUY
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23

Group30Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_SIDEWAYS_GRAMPS
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_EGK_RIVAL
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_LASS
	db SPRITE_OFFICER
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23

Group31Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_FISHER
	db SPRITE_YOUNGSTER
	db SPRITE_EGK_RIVAL
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_LASS
	db SPRITE_ROCKET
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23

Group34Sprites: ; 144ec
Group32Sprites: ; 144ec
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_POKEFAN_M
	db SPRITE_GRAMPS
	db SPRITE_YOUNGSTER
	db SPRITE_EGK_RIVAL
	db SPRITE_COOLTRAINER_M
	db SPRITE_BUG_CATCHER
	db SPRITE_SUPER_NERD
	db SPRITE_LASS
	db SPRITE_ROCKET
	db SPRITE_POKE_BALL
	db SPRITE_SLOWPOKE

Group33Sprites: ; 144ec
Group35Sprites:
	db SPRITE_SUICUNE
	db SPRITE_SILVER_TROPHY
	db SPRITE_FAMICOM
	db SPRITE_POKEDEX
	db SPRITE_WILL
	db SPRITE_KAREN
	db SPRITE_NURSE
	db SPRITE_OLD_LINK_RECEPTIONIST
	db SPRITE_BIG_LAPRAS
	db SPRITE_BIG_ONIX
	db SPRITE_SUDOWOODO
	db SPRITE_BIG_SNORLAX
	db SPRITE_TEACHER
	db SPRITE_GENTLEMAN
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_M
	db SPRITE_GRAMPS
	db SPRITE_BUG_CATCHER
	db SPRITE_MACHOP
	db SPRITE_SAILOR
	db SPRITE_LASS
	db SPRITE_POKE_BALL
	db SPRITE_FRUIT_TREE ; 23

; 14503

SpriteHeaders: ; 14736
INCLUDE "gfx/overworld/sprite_headers.asm"
; 1499a

Function1499a:: ; 1499a
	ld a, [StandingTile]
	cp $60
	jr z, .asm_149ad
	cp $68
	jr z, .asm_149ad
	and $f0
	cp $70
	jr z, .asm_149ad
	and a
	ret

.asm_149ad
	scf
	ret
; 149af

Function149af:: ; 149af
	ld a, [StandingTile]
	cp $70
	jr z, .asm_149c4
	cp $76
	jr z, .asm_149c4
	cp $78
	jr z, .asm_149c4
	cp $7e
	jr z, .asm_149c4
	scf
	ret

.asm_149c4
	xor a
	ret
; 149c6

Function149c6: ; 149c6
	ld de, 1
	ld hl, Unknown_149d3
	ld a, [StandingTile]
	call IsInArray
	ret
; 149d3

Unknown_149d3: ; 149d3
	db $71 ; door
	db $79
	db $7a ; stairs
	db $73
	db $7b ; cave entrance
	db $74
	db $7c ; warp pad
	db $75
	db $7d
	db -1
; 149dd

Function149dd:: ; 149dd
	ld a, [StandingTile]
	ld hl, Unknown_149ea
	ld de, 1
	call IsInArray
	ret
; 149ea

Unknown_149ea: ; 149ea
	db $08
	db $18 ; tall grass
	db $14 ; tall grass
	db $28
	db $29
	db $48
	db $49
	db $4a
	db $4b
	db $4c
	db -1
; 149f5

Function149f5: ; 149f5
	ld a, c
	ld hl, Unknown_14a00
	ld de, 1
	call IsInArray
	ret
; 14a00

Unknown_14a00: ; 14a00
	db $12 ; cut tree
	db $1a ; cut tree
	db $10 ; tall grass
	db $18 ; tall grass
	db $14 ; tall grass
	db $1c ; tall grass
	db -1
; 14a07

Function14a07:: ; 14a07
	ld a, [StandingTile]
	ld de, $001f
	cp $71 ; door
	ret z
	ld de, $0013
	cp $7c ; warp pad
	ret z
	ld de, $0023
	ret
; 14a1a

Function14a1a: ; 14a1a
	call Function1d6e
	callba Function5e9a
	call SpeechTextBox
	call Function1ad2
	callba Function4cf45
	ld hl, UnknownText_0x15283
	call Function14baf
	jr nz, .asm_14a4a
	call Function14b89
	jr c, .asm_14a4a
	call Function14b54
	call Function14be3
	call Function14b5a
	call Function1c07
	and a
	ret

.asm_14a4a
	call Function1c07
	call Functiond90
	callba Function4cf45
	scf
	ret

Function14a58: ; 14a58
	call Function14b54
	callba Function14056
	callba Function1050d9
	call Function14df7
	call Function14e13
	call Function14e76
	call Function14e8b
	callba Function44725
	callba Function1406a
	call Function14b5a
	ret
; 14a83

Special_BillChangeBox:
	push de
	jr SaveAndChangeBox

Function14a83: ; 14a83 (5:4a83) boxchangesave, saves with new active box e
	push de
	ld hl, UnknownText_0x152a1
	call Function1d4f
	call YesNoBox
	call Function1c07 ;unload menu
	jr c, .asm_14ab0
	call Function14b89
	jr nc, SaveAndChangeBox
.asm_14ab0
	pop de
	ret

SaveAndChangeBox:
	call Function14b54
	call Function14c99
	call Function14e0c
	pop de
	ld a, e
	ld [wCurBox], a
	call Function15021
	call Function14be6
	call Function14b5a
	and a
	ret

DeleteBox: ; 14a83 (5:4a83)
	push de
	ld hl, Text_DeleteBox
	call Function1d4f
	call YesNoBox
	call Function1c07
	jr c, .asm_14ab0
	call Function14b89
	jr c, .asm_14ab0
	call Function14b54
	call Function14c99
	pop de
	call EmptyBox
	call Function14be6
	call Function14b5a
	and a
	ret

.asm_14ab0
	pop de
	ret

Function14ab2: ; 14ab2  ask if save, if yes save and ret nc
	call Function14b89 ; ask if save, if yes erase save and ret nc
	ret c ;ret c if refused
Save_NoPrompt:
	call Function14b54
	call Function14be3
	call Function14b5a
	and a
	ret
; 14ac2

Function14ac2: ; 14ac2
	call Function14b54
	push de
	call Function14e0c
	pop de
	ld a, e
	ld [wCurBox], a
	call Function15021
	call Function14b5a
	ret
; 14ad5

Function14ad5: ; 14ad5
	call Function14b54
	push de
	call Function14e0c
	pop de
	ld a, e
	ld [wCurBox], a
	ld a, $1
	ld [wcfcd], a
	callba Function14056
	callba Function1050d9
	call Function14da9
	call Function14dbb
	call Function14dd7
	call Function14df7
	call Function14e13
	call Function14e2d
	call Function14e40
	call Function14e55
	call Function14e76
	call Function14e8b
	callba Function44725
	callba Function106187
	callba Function1406a
	call Function15021
	call Function14b5a
	ld de, SFX_SAVE
	call PlaySFX
	ld c, $18
	call DelayFrames
	ret
; 14b34

Function14b34: ; 14b34
	ld hl, UnknownText_0x152a6
	call Function1d4f
	call YesNoBox
	call Function1c07
	jr c, .asm_14b52
	call Function14b89
	jr c, .asm_14b52
	call Function14b54
	call Function14be3
	call Function14b5a
	and a
	ret

.asm_14b52
	scf
	ret
; 14b54

Function14b54: ; 14b54
	ld a, $1
	ld [wc2cd], a
	ret
; 14b5a

Function14b5a: ; 14b5a
	xor a
	ld [wc2cd], a
	ret
; 14b5f

Function14b5f: ; 14b5f
	ld a, $1
	call GetSRAMBank
	ld hl, $bdd9
	ld de, $be3b
	ld bc, $0b1a
.asm_14b6d
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, c
	or b
	jr nz, .asm_14b6d
	ld hl, OverworldMap
	ld de, $b2c0
	ld bc, $0062
	call CopyBytes
	call CloseSRAM
	ret
; 14b85

Function14b85: ; 14b85
	call Function14c10
	ret
; 14b89

Function14b89: ; 14b89 ask if save, if yes erase save and ret nc
	ld a, [wcfcd]
	and a
	jr z, .asm_14ba8 ;don't ask if blank file
	call Function14bcb ;if current playerid is the same as saved id, jump
	jr z, .asm_14b9e
	ld hl, UnknownText_0x15297 ;ask if can overwrite
	call Function14baf ;ask if want to save
	jr nz, .asm_14bad ;if no skip
	jr .asm_14ba8 ;else erase save

.asm_14b9e
	;ld hl, UnknownText_0x15292 ;ask if can overwrite
	;call Function14baf ;ask if want to save
	;jr nz, .asm_14bad
	jr .asm_14bab ;ret nc

.asm_14ba8
	call Function14cbb ;erase save

.asm_14bab
	and a
	ret

.asm_14bad
	scf
	ret
; 14baf

Function14baf: ; 14baf ask if want to save
	ld b, BANK(UnknownText_0x15283);would you like to save
	call Function269a ;print text box
	call Function1d58 ;load menu MenuDataHeader_0x1d5f
	lb bc, 0, 7
	call PlaceYesNoBox ; Return nc (yes) or c (no).
	ld a, [wcfa9] ;load cursor position
	dec a
	call Function1c17 ;unload menu
	;push af
	;call Functiond90 does nothing
	;pop af
	and a
	ret
; 14bcb

Function14bcb: ; 14bcb check if current playerid is the same as saved id
	ld a, $1
	call GetSRAMBank
	ld hl, $a009 ;load saved player id into bc
	ld a, [hli]
	ld c, [hl]
	ld b, a
	call CloseSRAM
	ld a, [PlayerID]
	cp b
	ret nz
	ld a, [PlayerID + 1]
	cp c
	ret
; 14be3

Function14be3: ; 14be3
	call Function14c99
Function14be6: ; 14be6
	call Function14c10
	ld c, $20
	call DelayFrames
	ld a, [Options]
	push af
	ld a, $3
	ld [Options], a
	ld hl, UnknownText_0x1528d
	call PrintText
	pop af
	ld [Options], a
	ld de, SFX_SAVE
	call WaitPlaySFX
	call WaitSFX
	ld c, $1e
	call DelayFrames
	ret
; 14c10

Function14c10: ; 14c10
	ld a, $1
	ld [wcfcd], a
	callba Function14056
	callba Function1050d9
	call Function14da9
	call Function14dbb
	call Function14dd7
	call Function14df7
	call Function14e0c
	call Function14e13
	call Function14e2d
	call Function14e40
	call Function14e55
	call Function14e76
	call Function14e8b
	call Function14c6b
	callba Function44725
	callba Function106187
	callba Function1406a
	ld a, $1
	call GetSRAMBank
	ld a, [$be45]
	cp $4
	jr nz, .asm_14c67
	xor a
	ld [$be45], a
.asm_14c67
	call CloseSRAM
	ret
; 14c6b

Function14c6b: ; 14c6b
	call Function14c90
	ld a, $0
	call GetSRAMBank
	ld a, [$bf10]
	ld e, a
	ld a, [$bf11]
	ld d, a
	or e
	jr z, .asm_14c84
	ld a, e
	sub l
	ld a, d
	sbc h
	jr c, .asm_14c8c
.asm_14c84
	ld a, l
	ld [$bf10], a
	ld a, h
	ld [$bf11], a
.asm_14c8c
	call CloseSRAM
	ret
; 14c90

Function14c90: ; 14c90
	ld hl, wc000
.asm_14c93
	ld a, [hl]
	or a
	ret nz
	inc hl
	jr .asm_14c93
; 14c99

Function14c99: ; 14c99
	xor a
	ld [hJoypadReleased], a
	ld [hJoypadPressed], a
	ld [hJoypadSum], a
	ld [hJoypadDown], a
	ld a, [Options]
	push af
	ld a, $3
	ld [Options], a
	ld hl, UnknownText_0x15288
	call PrintText
	pop af
	ld [Options], a
	ld c, $10
	call DelayFrames
	ret
; 14cbb

Function14cbb: ; 14cbb
	call Function151fb
	call Function14d06
	call Function14ce2
	call Function14cf4
	call Function14d68
	call Function14d5c
	ld a, BANK(sStackTop)
	call GetSRAMBank
	xor a
	ld [sStackTop], a
	ld [sStackTop + 1], a
	call CloseSRAM
	ld a, $1
	ld [wd4b4], a
	ret
; 14ce2

Function14ce2: ; 14ce2
	ld a, BANK(sLinkBattleStats)
	call GetSRAMBank
	ld hl, sLinkBattleStats
	ld bc, sLinkBattleStatsEnd - sLinkBattleStats
	jr FillSRAMWithZeros
; 14cf4

Function14cf4: ; 14cf4
	ld a, BANK(sBackupMysteryGiftItem)
	call GetSRAMBank
	ld hl, sBackupMysteryGiftItem
	ld bc, sBackupMysteryGiftItemEnd - sBackupMysteryGiftItem
	jr FillSRAMWithZeros
; 14d06

Function14d06: ; 14d06
	ld a, BANK(sHallOfFame)
	call GetSRAMBank
	ld hl, sHallOfFame
	ld bc, sHallOfFameEnd - sHallOfFame ; $0b7c
FillSRAMWithZeros:
	xor a
	call ByteFill
	jp CloseSRAM
; 14d18

Unknown_14d2c: ; 14d2c
	db $0d, $02, $00, $05, $00, $00
	db $22, $02, $01, $05, $00, $00
	db $03, $04, $05, $08, $03, $05
	db $0e, $06, $03, $02, $00, $00
	db $39, $07, $07, $04, $00, $05
	db $04, $07, $01, $05, $00, $00
	db $0f, $05, $14, $07, $05, $05
	db $11, $0c, $0c, $06, $06, $04
; 14d5c

Function14d5c: ; 14d5c
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	xor a
	ld [sBattleTowerChallengeState], a
	jp CloseSRAM
; 14d68

Function14d68: ; 14d68
	call Function1509a
	ret
; 14d6c

Function14d6c: ; 14d6c
	ld a, $4
	call GetSRAMBank
	ld a, [$a60b]
	ld b, $0
	and a
	jr z, .asm_14d7b
	ld b, $2
.asm_14d7b
	ld a, b
	ld [$a60b], a
	call CloseSRAM
	ret
; 14d83

Function14d83: ; 14d83
	ld a, $4
	call GetSRAMBank
	xor a
	ld [$a60c], a
	ld [$a60d], a
	call CloseSRAM
	ret
; 14d93

Function14d93: ; 14d93
	ld a, $7
	call GetSRAMBank
	xor a
	ld [$a000], a
	call CloseSRAM
	ret
; 14da0

Function14da0: ; 14da0
	ld a, [wd4b4]
	and a
	ret nz
	call Function14cbb
	ret
; 14da9

Function14da9: ; 14da9
	ld a, $1
	call GetSRAMBank
	ld a, $63
	ld [$a008], a
	ld a, $7f
	ld [$ad0f], a
	jp CloseSRAM
; 14dbb

Function14dbb: ; 14dbb
	ld a, $1
	call GetSRAMBank
	ld hl, Options
	ld de, $a000
	ld bc, $0008
	call CopyBytes ;copy 8 bytes from options to $a000, resetting no text delay
	ld a, [Options]
	and $ef
	ld [$a000], a
	jp CloseSRAM
; 14dd7

Function14dd7: ; 14dd7
	ld a, $1
	call GetSRAMBank
	ld hl, PlayerID
	ld de, $a009
	ld bc, $082a
	call CopyBytes
	ld hl, VisitedSpawns
	ld de, $a833
	ld bc, $0032
	call CopyBytes
	jp CloseSRAM
; 14df7

Function14df7: ; 14df7
	ld a, $1
	call GetSRAMBank
	ld hl, PartyCount
	ld de, $a865
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 14e0c

Function14e0c: ; 14e0c
	call Function150d8
	call Function150f9
	ret
; 14e13

Function14e13: ; 14e13
	ld hl, $a009
	ld bc, $0b7a
	ld a, $1
	call GetSRAMBank
	call Function15273
	ld a, e
	ld [$ad0d], a
	ld a, d
	ld [$ad0e], a
	call CloseSRAM
	ret
; 14e2d

Function14e2d: ; 14e2d
	ld a, $0
	call GetSRAMBank
	ld a, $63
	ld [$b208], a
	ld a, $7f
	ld [$bf0f], a
	call CloseSRAM
	ret
; 14e40

Function14e40: ; 14e40
	ld a, $0
	call GetSRAMBank
	ld hl, Options
	ld de, $b200
	ld bc, $0008
	call CopyBytes
	call CloseSRAM
	ret
; 14e55

Function14e55: ; 14e55
	ld a, $0
	call GetSRAMBank
	ld hl, PlayerID
	ld de, $b209
	ld bc, $082a
	call CopyBytes
	ld hl, VisitedSpawns
	ld de, $ba33
	ld bc, $0032
	call CopyBytes
	call CloseSRAM
	ret
; 14e76

Function14e76: ; 14e76
	ld a, $0
	call GetSRAMBank
	ld hl, PartyCount
	ld de, $ba65
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 14e8b

Function14e8b: ; 14e8b
	ld hl, $b209
	ld bc, $0b7a
	ld a, $0
	call GetSRAMBank
	call Function15273
	ld a, e
	ld [$bf0d], a
	ld a, d
	ld [$bf0e], a
	call CloseSRAM
	ret
; 14ea5

Function14ea5: ; 14ea5 (5:4ea5)
	call Function15028
	jr nz, .asm_14ed6
	call Function14fd7
	call Function1500c
	call Function15021
	callba Function44745
	callba Function10619d
	callba Function1050ea
	call Function14e2d
	call Function14e40
	call Function14e55
	call Function14e76
	call Function14e8b
	and a
	ret

.asm_14ed6
	call Function1507c
	jr nz, .asm_14f07
	call Function15046
	call Function15067
	call Function15021
	callba Function44745
	callba Function10619d
	callba Function1050ea
	call Function14da9
	call Function14dbb
	call Function14dd7
	call Function14df7
	call Function14e13
	and a
	ret

.asm_14f07
	ld a, [Options]
	push af
	set 4, a
	ld [Options], a
	ld hl, UnknownText_0x1529c
	call PrintText
	pop af
	ld [Options], a
	scf
	ret

Function14f1c: ; 14f1c
	xor a
	ld [wcfcd], a
	call Function14f84
	ld a, [wcfcd]
	and a
	jr z, .asm_14f46
	ld a, $1
	call GetSRAMBank
	ld hl, $a044
	ld de, StartDay
	ld bc, $0008
	call CopyBytes
	ld hl, $a3da
	ld de, StatusFlags
	ld a, [hl]
	ld [de], a
	call CloseSRAM
	ret

.asm_14f46
	call Function14faf
	ld a, [wcfcd]
	and a
	jr z, .asm_14f6c
	ld a, $0
	call GetSRAMBank
	ld hl, $b244
	ld de, StartDay
	ld bc, $0008
	call CopyBytes
	ld hl, $b5da
	ld de, StatusFlags
	ld a, [hl]
	ld [de], a
	call CloseSRAM
	ret

.asm_14f6c
	ld hl, DefaultOptions
	ld de, Options
	ld bc, $0008
	call CopyBytes
	call Function67e
	ret
; 14f7c

DefaultOptions: ; 14f7c
	db $21 ; fast text speed, stereo
	db $00
	db $00 ; frame 0
	db $01
	db $40 ; gb printer: normal brightness
	db $00 ; menu account off
	db $00
	db $00
; 14f84

Function14f84: ; 14f84
	ld a, $1
	call GetSRAMBank
	ld a, [$a008]
	cp $63
	jr nz, .asm_14fab
	ld a, [$ad0f]
	cp $7f
	jr nz, .asm_14fab
	ld hl, $a000
	ld de, Options
	ld bc, $0008
	call CopyBytes
	call CloseSRAM
	ld a, $1
	ld [wcfcd], a
.asm_14fab
	call CloseSRAM
	ret
; 14faf

Function14faf: ; 14faf
	ld a, $0
	call GetSRAMBank
	ld a, [$b208]
	cp $63
	jr nz, .asm_14fd3
	ld a, [$bf0f]
	cp $7f
	jr nz, .asm_14fd3
	ld hl, $b200
	ld de, Options
	ld bc, $0008
	call CopyBytes
	ld a, $2
	ld [wcfcd], a
.asm_14fd3
	call CloseSRAM
	ret
; 14fd7

Function14fd7: ; 14fd7 (5:4fd7)
	ld a, $1
	call GetSRAMBank
	ld hl, $a009
	ld de, PlayerID
	ld bc, $82a
	call CopyBytes
	ld hl, $a833
	ld de, VisitedSpawns
	ld bc, $32
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld a, [$be45]
	cp $4
	jr nz, .asm_15008
	ld a, $3
	ld [$be45], a
.asm_15008
	call CloseSRAM
	ret

Function1500c: ; 1500c copy 798 bytes from a865 to partycount
	ld a, $1
	call GetSRAMBank
	ld hl, $a865
	ld de, PartyCount
	ld bc, $031e
	call CopyBytes
	call CloseSRAM
	ret
; 15021

Function15021: ; 15021 (5:5021)
	call Function150d8
	call Function1517d
	ret

EmptyBox:
	ld a, [MenuSelection]
	dec a
	ld e, a
	ld a, [wCurBox]
	push af
	ld a, e
	ld [wCurBox], a
	push de
	call Function150d8
	call DeleteBoxAddress
	pop de
	pop af
	ld [wCurBox], a
	cp e
	ret nz
	ld de, sBox
	ld a, BANK(sBox)
	call DeleteBoxAddress
	ret

Function15028: ; 15028 (5:5028)
	ld hl, $a009
	ld bc, $b7a
	ld a, $1
	call GetSRAMBank
	call Function15273
	ld a, [$ad0d]
	cp e
	jr nz, .asm_15040
	ld a, [$ad0e]
	cp d
.asm_15040
	push af
	call CloseSRAM
	pop af
	ret

Function15046: ; 15046 (5:5046)
	ld a, $0
	call GetSRAMBank
	ld hl, $b209
	ld de, PlayerID
	ld bc, $82a
	call CopyBytes
	ld hl, $ba33
	ld de, VisitedSpawns
	ld bc, $32
	call CopyBytes
	call CloseSRAM
	ret

Function15067: ; 15067 (5:5067)
	ld a, $0
	call GetSRAMBank
	ld hl, $ba65
	ld de, PartyCount
	ld bc, $31e
	call CopyBytes
	call CloseSRAM
	ret

Function1507c: ; 1507c (5:507c)
	ld hl, $b209
	ld bc, $b7a
	ld a, $0
	call GetSRAMBank
	call Function15273
	ld a, [$bf0d]
	cp e
	jr nz, .asm_15094
	ld a, [$bf0e]
	cp d
.asm_15094
	push af
	call CloseSRAM
	pop af
	ret

Function1509a: ; 1509a
	ld a, $1
	call GetSRAMBank
	ld hl, PlayerGender
	ld de, $be3d
	ld bc, $0007
	call CopyBytes
	ld hl, wd479
	ld a, [hli]
	ld [$a60e], a
	ld a, [hli]
	ld [$a60f], a
	jp CloseSRAM
; 150b9

Function150b9: ; 150b9 (5:50b9)
	ld a, $1
	call GetSRAMBank
	ld hl, $be3d
	ld de, PlayerGender
	ld bc, $7
	call CopyBytes
	ld hl, wd479
	ld a, [$a60e]
	ld [hli], a
	ld a, [$a60f]
	ld [hli], a
	jp CloseSRAM

Function150d8: ; 150d8
	ld a, [wCurBox]
	cp NUM_BOXES
	jr c, .asm_150e3
	xor a
	ld [wCurBox], a
.asm_150e3
	ld e, a
	ld d, 0
	ld hl, Unknown_1522d
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ret
; 150f9

Function150f9: ; 150f9
	push hl
	push af
	push de
	ld a, $1
	call GetSRAMBank
	ld hl, sBoxCount
	ld de, wc608
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	push af
	push de
	call GetSRAMBank
	ld hl, wc608
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, $aef0
	ld de, wc608
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	ld hl, $01e0
	add hl, de
	ld e, l
	ld d, h
	push af
	push de
	call GetSRAMBank
	ld hl, wc608
	ld bc, $01e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, $b0d0
	ld de, wc608
	ld bc, $008e
	call CopyBytes
	call CloseSRAM
	pop de
	pop af
	ld hl, $01e0
	add hl, de
	ld e, l
	ld d, h
	call GetSRAMBank
	ld hl, wc608
	ld bc, $008e
	call CopyBytes
	call CloseSRAM
	pop hl
	ret
; 1517d

DeleteBoxAddress:
	ld h, d
	ld l, e
	call GetSRAMBank
	push hl
	inc hl
	ld b, MONS_PER_BOX
.loop
	push bc
	ld a, [hli]
	cp ENTEI
	ld c, 1
	jr z, .init
	cp RAIKOU
	ld c, 2
	jr z, .init
	cp SUICUNE
	jr nz, .next
	ld c, 4
.init
	ld a, c
	ld [ScriptVar], a
	callba InitRoamMons
.next
	pop bc
	dec b
	jr nz, .loop
	pop hl
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld bc, MONS_PER_BOX
	add hl, bc
	ld bc, sBoxEnd - sBoxMons
	xor a
	call ByteFill
	call CloseSRAM
	ret

Function1517d: ; 1517d (5:517d)
	push hl
	ld l, e
	ld h, d
	push af
	push hl
	call GetSRAMBank
	ld de, wc608
	ld bc, $1e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, wc608
	ld de, $ad10
	ld bc, $1e0
	call CopyBytes
	call CloseSRAM
	pop hl
	pop af
	ld de, $1e0
	add hl, de
	push af
	push hl
	call GetSRAMBank
	ld de, wc608
	ld bc, $1e0
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, wc608
	ld de, $aef0
	ld bc, $1e0
	call CopyBytes
	call CloseSRAM
	pop hl
	pop af
	ld de, $1e0
	add hl, de
	call GetSRAMBank
	ld de, wc608
	ld bc, $8e
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank
	ld hl, wc608
	ld de, $b0d0
	ld bc, $8e
	call CopyBytes
	call CloseSRAM
	pop hl
	ret

Function151fb: ; 151fb
	ld hl, Unknown_1522d
	ld c, $e
.asm_15200
	push bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	xor a
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	inc de
	ld bc, $044c
.asm_15213
	xor a
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .asm_15213
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, $ff
	ld [de], a
	inc de
	xor a
	ld [de], a
	call CloseSRAM
	pop bc
	dec c
	jr nz, .asm_15200
	ret
; 1522d

Unknown_1522d: ; 1522d
; dbww bank, address, address

	db $02, $00, $a0, $4e, $a4 ; 2, $a000, $a44e
	db $02, $50, $a4, $9e, $a8 ; 2, $a450, $a89e
	db $02, $a0, $a8, $ee, $ac ; 2, $a8a0, $acee
	db $02, $f0, $ac, $3e, $b1 ; 2, $acf0, $b13e
	db $02, $40, $b1, $8e, $b5 ; 2, $b140, $b5de
	db $02, $90, $b5, $de, $b9 ; 2, $b590, $b9de
	db $02, $e0, $b9, $2e, $be ; 2, $b9e0, $be2e
	db $03, $00, $a0, $4e, $a4 ; 3, $a000, $a44e
	db $03, $50, $a4, $9e, $a8 ; 3, $a450, $a89e
	db $03, $a0, $a8, $ee, $ac ; 3, $a8a0, $acee
	db $03, $f0, $ac, $3e, $b1 ; 3, $acf0, $b13e
	db $03, $40, $b1, $8e, $b5 ; 3, $b140, $b58e
	db $03, $90, $b5, $de, $b9 ; 3, $b590, $b9de
	db $03, $e0, $b9, $2e, $be ; 3, $b9e0, $be2e
; 15273

Function15273: ; 15273
	ld de, $0000
.asm_15276
	ld a, [hli]
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .asm_15276
	ret
; 15283

UnknownText_0x15283: ; 0x15283
	; Would you like to save the game?
	text_jump UnknownText_0x1c454b
	db "@"
; 0x15288

UnknownText_0x15288: ; 0x15288
	; SAVING<...> DON'T TURN OFF THE POWER.
	text_jump UnknownText_0x1c456d
	db "@"
; 0x1528d

UnknownText_0x1528d: ; 0x1528d
	; saved the game.
	text_jump UnknownText_0x1c4590
	db "@"
; 0x15292

UnknownText_0x15292: ; 0x15292
	; There is already a save file. Is it OK to overwrite?
	text_jump UnknownText_0x1c45a3
	db "@"
; 0x15297

UnknownText_0x15297: ; 0x15297
	; There is another save file. Is it OK to overwrite?
	text_jump UnknownText_0x1c45d9
	db "@"
; 0x1529c

UnknownText_0x1529c: ; 0x1529c
	; The save file is corrupted!
	text_jump UnknownText_0x1c460d
	db "@"
; 0x152a1

UnknownText_0x152a1: ; 0x152a1
	; When you change a #MON BOX, data will be saved. OK?
	text_jump UnknownText_0x1c462a
	db "@"
; 0x152a6

UnknownText_0x152a6: ; 0x152a6
	; Each time you move a #MON, data will be saved. OK?
	text_jump UnknownText_0x1c465f
	db "@"
; 0x152ab
Text_DeleteBox:
	text_jump _Text_DeleteBox
	db "@"

INCLUDE "engine/spawn_points.asm"

INCLUDE "engine/map_setup.asm"

Function1559a: ; 1559a PC here
	call Function15650 ;if party is zero, cannot use
	ret c
	call Function156b3 ;play soundFX
	ld hl, UnknownText_0x15a27 ;turned on the PC
	call Function15a20 ;draw a text box with text from HL
	ld hl, UnknownText_0x15a2c ;whose PC?
	call Function157bb ;load a menu, draw a text box and fill it with text at hl with instatext
	ld hl, MenuDataHeader_0x155d6
	call LoadMenuDataHeader ;load a menu
.asm_155b3
	xor a
	ld [hBGMapMode], a ;mapmode = 0
	call Function1563e ;dex check. ret a=0 if no dex, 1 if hall of fame count = 0 and dex and 2 otherwise
	ld [wcf76], a ;load into ??
	call Function1e5d ;set up and process PC menu, ret c if going back
	jr c, .asm_155cc ;if going back a menu, jump
	ld a, [MenuSelection] ;redundent
	ld hl, Unknown_155e6 ;also redundent?
	call Function1fa7 ;starting at Unknown_155e6, go down to menu selection row and run the function pointed to by that
	jr nc, .asm_155b3
.asm_155cc
	call Function156b8 ;play sound fx
	call Function1c07 ;unload top menu on the stack, replacing the menu with what's behind it
	call Function1c17
	ret
; 155d6

MenuDataHeader_0x155d6: ; 0x155d6
	db $48 ; flags
	db 00, 00 ; start coords
	db 12, 15 ; end coords
	dw MenuData2_0x155de
	db 1 ; default option
; 0x155de

MenuData2_0x155de: ; 0x155de
	db $a0 ; flags
	db 0 ; items
	dw Unknown_1562c ;location of menu options
	dw Function1f8d
	dw Unknown_155e6
; 0x155e6

Unknown_155e6: ; 155e6
	dw Function15679, String_155fa
	dw Function15668, String_15600
	dw Function15689, String_15609
	dw Function1569a, String_15616
	dw Function156ab, String_15623
	dw Function15668_2, String_SomeonesPC
; 155fa

String_155fa:	db "<PLAYER>'s PC@"
String_15600:	db "BILL's PC@"
String_15609:	db "PROF.OAK's PC@"
String_15616:	db "HALL OF FAME@"
String_15623:	db "TURN OFF@"
String_SomeonesPC: db "SOMEONE's PC@"
; 1562c

Unknown_1562c: ; 1562c
	db 3
	db 5, 0, 4, $ff
	db 4
	db 5, 0, 2, 4, $ff
	db 4
	db 1, 0, 2, 4, $ff
	db 5
	db 1, 0, 2, 3, 4, $ff
; 1563e

Function1563e: ; 1563e ;dex check. ret a=0 if no dex, 1 if wd95e = 0 and dex and 2 otherwise
	call Function2ead ;check if dex, return in a
	jr nz, .asm_15646 ;if dex, jump, else retern zero in a
	ld a, $0
	ret

.asm_15646
	ld de, EVENT_HELPED_BILL_RB
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	ld a, $1
	ret z
	ld a, [wd95e]
	and a ;if ?? = 0, a = 1. else a = 2
	ld a, $2
	ret z
	ld a, $3
	ret
; 15650

Function15650: ; 15650
	ld a, [PartyCount]
	and a
	ret nz ;if party is zero, cannot use
	ld de, SFX_CHOOSE_PC_OPTION
	call PlaySFX
	ld hl, UnknownText_0x15663
	call Function15a20
	scf
	ret
; 15663

UnknownText_0x15663: ; 0x15663
	; Bzzzzt! You must have a #MON to use this!
	text_jump UnknownText_0x1c1328
	db "@"
; 0x15668

Function15668: ; 15668
	call Function156c2 ;play PC sfx
	ld hl, UnknownText_0x15a31 ;bills PC accsessed
	call Function15a20 ; draw a text box with text from HL
	callba Functione3fd
	and a
	ret
; 15679 (5:5679)

Function15668_2:
	call Function156c2 ;play PC sfx
	ld hl, UnknownText_0x15a31_2 ;bills PC accsessed
	call Function15a20 ; draw a text box with text from HL
	callba Functione3fd
	and a
	ret

Function15679: ; 15679
	call Function156c2
	ld hl, UnknownText_0x15a36
	call Function15a20
	ld b, $0
	call Function15704
	and a
	ret
; 15689

Function15689: ; 15689
	call Function156c2
	ld hl, UnknownText_0x15a3b
	call Function15a20
	callba ProfOaksPC
	and a
	ret
; 1569a

Function1569a: ; 1569a
	call Function156c2
	call FadeToMenu
	callba Function86650
	call Function2b3c
	and a
	ret
; 156ab

Function156ab: ; 156ab
	ld hl, UnknownText_0x15a40
	call PrintText
	scf
	ret
; 156b3

Function156b3: ; 156b3
	ld de, SFX_BOOT_PC
	jr Function156d0

Function156b8: ; 156b8
	ld de, SFX_SHUT_DOWN_PC
	call Function156d0 ;play sound fx
	call WaitSFX
	ret

Function156c2: ; 156c2 play PC sfx
	ld de, SFX_CHOOSE_PC_OPTION
	jr Function156d0

Function156c7: ; 156c7
	ld de, SFX_SWITCH_POKEMON
	call Function156d0
	ld de, SFX_SWITCH_POKEMON
Function156d0: ; 156d0
	push de
	call WaitSFX
	pop de
	call PlaySFX
	ret
; 156d9

Function156d9: ; 156d9
	call Function156b3
	ld hl, UnknownText_0x156ff
	call Function15a20
	ld b, $1
	ld a, [StatusFlags]
	bit 5, a
	jr nz, .okay
	dec b
.okay
	call Function15704
	and a
	jr nz, .asm_156f9
	call Function2173
	call Function321c
	call Function1ad2
	call Function156b8 ;play sound fx
	ld c, $0
	ret

.asm_156f9
	call WhiteBGMap
	ld c, $1
	ret
; 156ff

UnknownText_0x156ff: ; 0x156ff
	; turned on the PC.
	text_jump UnknownText_0x1c1353
	db "@"
; 0x15704

Function15704: ; 15704
	ld a, b
	ld [wcf76], a
	ld hl, UnknownText_0x157cc
	call Function157bb
	call Function15715
	call Function1c07
	ret
; 15715

Function15715: ; 15715
	xor a
	ld [wd0d7], a
	ld [wd0dd], a
	ld hl, KrissPCMenuData
	call LoadMenuDataHeader
.asm_15722
	call UpdateTimePals
	call Function1e5d
	jr c, .asm_15731
	call Function1fa7
	jr nc, .asm_15722
	jr .asm_15732

.asm_15731
	xor a
.asm_15732
	call Function1c07
	ret
; 15736

KrissPCMenuData: ; 0x15736
	db %01000000
	db  0,  0 ; top left corner coords (y, x)
	db 12, 15 ; bottom right corner coords (y, x)
	dw .KrissPCMenuData2
	db 1 ; default selected option
.KrissPCMenuData2
	db %10100000 ; bit7
	db 0 ; # items?
	dw .KrissPCMenuList1
	dw Function1f8d
	dw .KrissPCMenuPointers

.KrissPCMenuPointers ; 0x15746
	dw KrisWithdrawItemMenu, .WithdrawItem
	dw KrisDepositItemMenu,  .DepositItem
	dw KrisTossItemMenu,     .TossItem
	dw KrisMailBoxMenu,      .MailBox
	dw KrisDecorationMenu,   .Decoration
	dw KrisLogOffMenu,       .LogOff
	dw KrisLogOffMenu,       .TurnOff
.WithdrawItem db "WITHDRAW ITEM@"
.DepositItem  db "DEPOSIT ITEM@"
.TossItem     db "TOSS ITEM@"
.MailBox      db "MAIL BOX@"
.Decoration   db "DECORATION@"
.TurnOff      db "TURN OFF@"
.LogOff       db "LOG OFF@"
WITHDRAW_ITEM EQU 0
DEPOSIT_ITEM  EQU 1
TOSS_ITEM     EQU 2
MAIL_BOX      EQU 3
DECORATION    EQU 4
TURN_OFF      EQU 5
LOG_OFF       EQU 6
.KrissPCMenuList1
	db 5
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db MAIL_BOX
	db TURN_OFF
	db $ff
.KrissPCMenuList2
	db 6
	db WITHDRAW_ITEM
	db DEPOSIT_ITEM
	db TOSS_ITEM
	db MAIL_BOX
	db DECORATION
	db LOG_OFF
	db $ff
Function157bb: ; 157bb ;load a menu, draw a text box and fill it with text at hl with instatext
	ld a, [Options] ;set instatext
	push af
	set 4, a
	ld [Options], a
	call Function1d4f ;load a menu, draw a text box and fill it with text at hl
	pop af
	ld [Options], a ;reset instatext
	ret
; 157cc

UnknownText_0x157cc: ; 0x157cc
	; What do you want to do?
	text_jump UnknownText_0x1c1368
	db "@"
; 0x157d1

KrisWithdrawItemMenu: ; 0x157d1
	call Function1d6e
	callba ClearPCItemScreen
.asm_157da
	call Function15985
	jr c, .asm_157e4
	call Function157e9
	jr .asm_157da

.asm_157e4
	call Function2b3c
	xor a
	ret
; 0x157e9

Function157e9: ; 0x157e9
	; check if the item has a quantity
	callba _CheckTossableItem
	ld a, [wd142]
	and a
	jr z, .askquantity
	; items without quantity are always ×1
	ld a, 1
	ld [wd10c], a
	jr .withdraw

.askquantity
	ld hl, .HowManyText
	call Function1d4f
	callba Function24fbf
	call Function1c07
	call Function1c07
	jr c, .done
.withdraw
	ld a, [wd10c]
	ld [Buffer1], a ; quantity
	ld a, [wd107]
	ld [Buffer2], a
	ld hl, NumItems
	call ReceiveItem
	jr nc, .PackFull
	ld a, [Buffer1]
	ld [wd10c], a
	ld a, [Buffer2]
	ld [wd107], a
	ld hl, PCItems
	call TossItem
	predef PartyMonItemName
	ld hl, .WithdrewText
	call Function1d4f
	xor a
	ld [hBGMapMode], a
	call Function1c07
	ret

.PackFull
	ld hl, .NoRoomText
	call Function1d67
	ret

.done
	ret
; 0x15850

.HowManyText ; 0x15850
	TX_FAR _KrissPCHowManyWithdrawText
	db "@"
.WithdrewText ; 0x15855
	TX_FAR _KrissPCWithdrewItemsText
	db "@"
.NoRoomText ; 0x1585a
	TX_FAR _KrissPCNoRoomWithdrawText
	db "@"
KrisTossItemMenu: ; 0x1585f
	call Function1d6e
	callba ClearPCItemScreen
.asm_15868
	call Function15985
	jr c, .asm_15878
	ld de, PCItems
	callba Function129f4
	jr .asm_15868

.asm_15878
	call Function2b3c
	xor a
	ret
; 0x1587d

KrisDecorationMenu: ; 0x1587d
	callba _KrisDecorationMenu
	ld a, c
	and a
	ret z
	scf
	ret
; 0x15888

KrisLogOffMenu: ; 0x15888
	xor a
	scf
	ret
; 0x1588b

KrisDepositItemMenu: ; 0x1588b
	call Function158b8
	jr c, .asm_158b6
	call Function2ed3
	call Function1d6e
	callba Function106a5
.asm_1589c
	callba Function106be
	ld a, [wcf66]
	and a
	jr z, .asm_158b3
	call Function158cc
	callba CheckRegisteredItem
	jr .asm_1589c

.asm_158b3
	call Function2b3c
.asm_158b6
	xor a
	ret
; 0x158b8

Function158b8: ; 0x158b8
	callba Function129d5
	ret nc
	ld hl, UnknownText_0x158c7
	call Function1d67
	scf
	ret
; 0x158c7

UnknownText_0x158c7: ; 0x158c7
	; No items here!
	text_jump UnknownText_0x1c13df
	db "@"
; 0x158cc

Function158cc: ; 0x158cc
	callba CheckItemPocket
	ld a, [wd142]
	cp TM_HM
	jr z, .nope
	ld a, [wc2ce]
	push af
	ld a, $0
	ld [wc2ce], a
	callba CheckItemMenu
	ld a, [wd142]
	ld hl, .Jumptable
	rst JumpTable
	pop af
	ld [wc2ce], a
	ret
; 0x158e7

.Jumptable: ; 0x158e7
	dw .jump2
	dw .nope
	dw .nope
	dw .nope
	dw .jump2
	dw .jump2
	dw .jump2

.nope:
	ld hl, .NopeText
	call PrintText
	ret

.NopeText:
	text "Can't deposit that"
	line "in the PC!"
	prompt

.jump2:
	ld a, [Buffer1]
	push af
	ld a, [Buffer2]
	push af
	call Function1590a
	pop af
	ld [Buffer2], a
	pop af
	ld [Buffer1], a
	ret
; 0x1590a

Function1590a: ; 0x1590a
	callba _CheckTossableItem
	ld a, [wd142]
	and a
	jr z, .asm_1591d
	ld a, $1
	ld [wd10c], a
	jr .asm_15933

.asm_1591d
	ld hl, .HowManyText
	call Function1d4f
	callba Function24fbf
	push af
	call Function1c07
	call Function1c07
	pop af
	jr c, .asm_1596c
.asm_15933
	ld a, [wd10c]
	ld [Buffer1], a
	ld a, [wd107]
	ld [Buffer2], a
	ld hl, PCItems
	call ReceiveItem
	jr nc, .asm_15965
	ld a, [Buffer1]
	ld [wd10c], a
	ld a, [Buffer2]
	ld [wd107], a
	ld hl, NumItems
	call TossItem
	predef PartyMonItemName
	ld hl, .DepositText
	call PrintText
	ret

.asm_15965
	ld hl, .NoRoomText
	call PrintText
	ret

.asm_1596c
	and a
	ret
; 0x1596e

.HowManyText ; 0x1596e
	TX_FAR _KrissPCHowManyDepositText
	db "@"
.DepositText ; 0x15973
	TX_FAR _KrissPCDepositItemsText
	db "@"
.NoRoomText ; 0x15978
	TX_FAR _KrissPCNoRoomDepositText
	db "@"
KrisMailBoxMenu: ; 0x1597d
	callba _KrisMailBoxMenu
	xor a
	ret
; 0x15985

Function15985: ; 0x15985
	xor a
	ld [wd0e3], a
.asm_15989
	ld a, [wc2ce]
	push af
	ld a, $0
	ld [wc2ce], a
	ld hl, MenuData15a08
	call Function1d3c
	hlcoord 0, 0
	ld b, $a
	ld c, $12
	call TextBox
	ld a, [wd0d7]
	ld [wcf88], a
	ld a, [wd0dd]
	ld [wd0e4], a
	call Function350c
	ld a, [wd0e4]
	ld [wd0dd], a
	ld a, [wcfa9]
	ld [wd0d7], a
	pop af
	ld [wc2ce], a
	ld a, [wd0e3]
	and a
	jr nz, .asm_159d8
	ld a, [wcf73]
	cp $2
	jr z, .asm_15a06
	cp $1
	jr z, .asm_159fb
	cp $4
	jr z, .asm_159f2
	jr .asm_159f8

.asm_159d8
	ld a, [wcf73]
	cp $2
	jr z, .asm_159e9
	cp $1
	jr z, .asm_159ef
	cp $4
	jr z, .asm_159ef
	jr .asm_159f8

.asm_159e9
	xor a
	ld [wd0e3], a
	jr .asm_159f8

.asm_159ef
	call Function156c7
.asm_159f2
	callba Function2490c
.asm_159f8
	jp .asm_15989

.asm_159fb
	callba Function24706
	call Function1bee
	and a
	ret

.asm_15a06
	scf
	ret
; 0x15a08

MenuData15a08: ; 0x15a08
	db %01000000
	db  1,  4 ; start coords
	db 10, 18 ; end coords
	dw .MenuData2
	db 1 ; default option
.MenuData2
	db %10110000
	db 4, 8 ; rows/cols?
	db 2 ; horizontal spacing?
	dbw 0, PCItems
	dbw BANK(Function24ab4), Function24ab4
	dbw BANK(Function24ac3), Function24ac3
	dbw BANK(Function244c3), Function244c3
Function15a20: ; 15a20 draw a text box with text from HL
	call Function1d4f ;create a menu and draw text box
	call Function1c07 ;unload top menu added by 1d4f
	ret
; 15a27

UnknownText_0x15a27: ; 0x15a27
	; turned on the PC.
	text_jump UnknownText_0x1c144d
	db "@"
; 0x15a2c

UnknownText_0x15a2c: ; 0x15a2c
	; Access whose PC?
	text_jump UnknownText_0x1c1462
	db "@"
; 0x15a31

UnknownText_0x15a31: ; 0x15a31
	; BILL's PC accessed. #MON Storage System opened.
	text_jump UnknownText_0x1c1474
	db "@"
; 0x15a36
UnknownText_0x15a31_2: ; 0x15a31
	; BILL's PC accessed. #MON Storage System opened.
	text_jump UnknownText_0x1c1474_2
	db "@"
; 0x15a36

UnknownText_0x15a36: ; 0x15a36
	; Accessed own PC. Item Storage System opened.
	text_jump UnknownText_0x1c14a4
	db "@"
; 0x15a3b

UnknownText_0x15a3b: ; 0x15a3b
	; PROF.OAK's PC accessed. #DEX Rating System opened.
	text_jump UnknownText_0x1c14d2
	db "@"
; 0x15a40

UnknownText_0x15a40: ; 0x15a40
	; <...> Link closed<...>
	text_jump UnknownText_0x1c1505
	db "@"
; 0x15a45

OpenMartDialog:: ; 15a45
	call GetMart
	ld a, c
	ld [EngineBuffer1], a
	call Function15b10
	ld a, [EngineBuffer1]
	ld hl, .dialogs
	rst JumpTable
	ret
; 15a57

.dialogs
	dw MartDialog
	dw HerbShop
	dw BargainShop
	dw Pharmacist
	dw VendingMachine
; 15a61

MartDialog: ; 15a61
	ld a, 0
	ld [EngineBuffer1], a
	xor a
	ld [MovementAnimation], a
	call Function15b47
	ret
; 15a6e

HerbShop: ; 15a6e
	call ReadMart
	call Function1d6e
	ld hl, UnknownText_0x15e4a
	call Function15fcd
	call Function15c62
	ld hl, UnknownText_0x15e68
	call Function15fcd
	ret
; 15a84

BargainShop: ; 15a84
	ld b, BANK(Unknown_15c51)
	ld de, Unknown_15c51
	call Function15b10
	call Function15c25
	call Function1d6e
	ld hl, UnknownText_0x15e6d
	call Function15fcd
	call Function15c62
	ld hl, WalkingDirection
	ld a, [hli]
	or [hl]
	jr z, .asm_15aa7
	ld hl, DailyFlags
	set 6, [hl]
.asm_15aa7
	ld hl, UnknownText_0x15e8b
	call Function15fcd
	ret
; 15aae

Pharmacist: ; 15aae
	call ReadMart
	call Function1d6e
	ld hl, UnknownText_0x15e90
	call Function15fcd
	call Function15c62
	ld hl, UnknownText_0x15eae
	call Function15fcd
	ret
; 15ac4

VendingMachine: ; 15ac4
	ld b, BANK(Unknown_15aee)
	ld de, Unknown_15aee
	ld hl, StatusFlags
	bit 6, [hl]
	jr z, .asm_15ad5
	ld b, BANK(Unknown_15aff)
	ld de, Unknown_15aff
.asm_15ad5
	call Function15b10
	call Function15c25
	call Function1d6e
	ld hl, UnknownText_0x15f83
	call Function15fcd
	call Function15c62
	ld hl, UnknownText_0x15fb4
	call Function15fcd
	ret
; 15aee

Unknown_15aee: ; 15aee
	db 5
	dbw POKE_BALL,     150
	dbw GREAT_BALL,    500
	dbw SUPER_POTION,  500
	dbw FULL_HEAL,     500
	dbw REVIVE,       1200
	db -1
Unknown_15aff: ; 15aff
	db 5
	dbw HYPER_POTION, 1000
	dbw FULL_RESTORE, 2000
	dbw FULL_HEAL,     500
	dbw ULTRA_BALL,   1000
	dbw PROTEIN,      7800
	db -1
; 15b10

Function15b10: ; 15b10
	ld a, b
	ld [wd03f], a
	ld a, e
	ld [MartPointer], a
	ld a, d
	ld [MartPointer + 1], a
	ld hl, CurMart
	xor a
	ld bc, 16
	call ByteFill
	xor a
	ld [MovementAnimation], a
	ld [WalkingDirection], a
	ld [FacingDirection], a
	ret
; 15b31

GetMart: ; 15b31
	ld a, e
	cp (MartsEnd - Marts) / 2
	jr c, .IsAMart
	ld b, $5
	ld de, DefaultMart
	ret

.IsAMart
	ld hl, Marts
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, $5
	ret
; 15b47

Function15b47: ; 15b47
.asm_15b47
	ld a, [MovementAnimation]
	ld hl, .table_15b56
	rst JumpTable
	ld [MovementAnimation], a
	cp $ff
	jr nz, .asm_15b47
	ret

.table_15b56
	dw Function15b62
	dw Function15b6e
	dw Function15b8d
	dw Function15b9a
	dw Function15ba3
	dw Function15baf
; 15b62

Function15b62: ; 15b62
	call Function1d6e
	ld hl, UnknownText_0x15f83
	call PrintText
	ld a, $1
	ret
; 15b6e

Function15b6e: ; 15b6e
	ld hl, MenuDataHeader_0x15f88
	call Function1d3c
	call Function1d81
	jr c, .asm_15b84
	ld a, [wcfa9]
	cp $1
	jr z, .asm_15b87
	cp $2
	jr z, .asm_15b8a
.asm_15b84
	ld a, $4
	ret

.asm_15b87
	ld a, $2
	ret

.asm_15b8a
	ld a, $3
	ret
; 15b8d

Function15b8d: ; 15b8d
	call Function1c07
	call ReadMart
	call Function15c62
	and a
	ld a, $5
	ret
; 15b9a

Function15b9a: ; 15b9a
	call Function1c07
	call Function15eb3
	ld a, $5
	ret
; 15ba3

Function15ba3: ; 15ba3
	call Function1c07
	ld hl, UnknownText_0x15fb4
	call Function15fcd
	ld a, $ff
	ret
; 15baf

Function15baf: ; 15baf
	call Function1d6e
	ld hl, UnknownText_0x15fb9
	call PrintText
	ld a, $1
	ret
; 15bbb

ReadMart: ; 15bbb
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CurMart
.CopyMart
	ld a, [wd03f]
	call GetFarByte
	ld [de], a
	inc hl
	inc de
	cp $ff
	jr nz, .CopyMart
	ld hl, DefaultFlypoint
	ld de, CurMart + 1
.ReadMartItem
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_15be4
	push de
	call GetMartItemPrice
	pop de
	jr .ReadMartItem

.asm_15be4
	ret
; 15be5

GetMartItemPrice: ; 15be5
; Return the price of item a in BCD at hl and in tiles at StringBuffer1.

	push hl
	ld [CurItem], a
	callba GetItemPrice
	pop hl
GetMartPrice: ; 15bf0
; Return price de in BCD at hl and in tiles at StringBuffer1.

	push hl
	ld a, d
	ld [StringBuffer2], a
	ld a, e
	ld [StringBuffer2 + 1], a
	ld hl, StringBuffer1
	ld de, StringBuffer2
	ld bc, $82 << 8 + 6 ; 6 digits
	call PrintNum
	pop hl
	ld de, StringBuffer1
	ld c, 6 / 2 ; 6 digits
.asm_15c0b
	call .TileToNum
	swap a
	ld b, a
	call .TileToNum
	or b
	ld [hli], a
	dec c
	jr nz, .asm_15c0b
	ret
; 15c1a

.TileToNum ; 15c1a
	ld a, [de]
	inc de
	cp " "
	jr nz, .asm_15c22
	ld a, "0"
.asm_15c22
	sub "0"
	ret
; 15c25

Function15c25: ; 15c25
	ld hl, MartPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	inc hl
	ld bc, wd002
	ld de, CurMart + 1
.asm_15c33
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr z, .asm_15c4b
	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call GetMartPrice
	ld b, h
	ld c, l
	pop hl
	pop de
	jr .asm_15c33

.asm_15c4b
	pop hl
	ld a, [hl]
	ld [CurMart], a
	ret
; 15c51

Unknown_15c51: ; 15c51
	db 6
	dbw NUGGET,     4500
	dbw PEARL,       650
	dbw BIG_PEARL,  3500
	dbw STARDUST,    900
	dbw STAR_PIECE, 4600
	dbw EXP_SHARE,  2100
	db -1
; 15c62

Function15c62: ; 15c62
	call FadeToMenu
	callba Function8000
	xor a
	ld [WalkingY], a
	ld a, 1
	ld [WalkingX], a
.asm_15c74
	call Function15cef
	jr nc, .asm_15c74
	call Function2b3c
	ret
; 15c7d

Function15c7d: ; 15c7d
	push af
	call Function15ca3
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ret
; 15c91

Function15c91: ; 15c91
	callba CheckItemPocket
	ld a, [wd142]
	cp TM_HM
	jr z, .okay
	call Function15ca3
	inc hl
	inc hl
	ld a, [hl]
	and a
	jp z, Function15d83
	cp 1
	jp z, Function15da5
	jp Function15de2
; 15ca3
.okay
	ld hl, NumItems
	call CheckItem
	jr c, .already_have_tmhm
	ld a, 1
	ld [wd10c], a
	callba GetItemPrice
	xor a
	ld [$ffc3], a
	ld a, d
	ld [$ffc4], a
	ld a, e
	ld [$ffc5], a
	and a
	ret
.already_have_tmhm
	ld hl, .already_have_txt
	call PrintText
	call Functiona36
	scf
	ret
.already_have_txt
	text "You can't carry"
	line "any more."
	done

Function15ca3: ; 15ca3
	ld a, [EngineBuffer1]
	ld e, a
	ld d, 0
	ld hl, .data_15cb0
	add hl, de
	add hl, de
	add hl, de
	ret
; 15cb0

.data_15cb0 ; 15cb0
	dwb Unknown_15cbf, 0
	dwb Unknown_15ccb, 0
	dwb Unknown_15cd7, 1
	dwb Unknown_15ce3, 0
	dwb Unknown_15cbf, 2
; 15cbf

Unknown_15cbf: ; 15cbf
	dw UnknownText_0x15e0e
	dw UnknownText_0x15e13
	dw UnknownText_0x15fa5
	dw UnknownText_0x15faa
	dw UnknownText_0x15fa0
	dw Function15cef
	dw Text_PremierBallBonus

Unknown_15ccb: ; 15ccb
	dw UnknownText_0x15e4f
	dw UnknownText_0x15e54
	dw UnknownText_0x15e63
	dw UnknownText_0x15e5e
	dw UnknownText_0x15e59
	dw Function15cef
	dw Text_PremierBallBonus

Unknown_15cd7: ; 15cd7
	dw Function15cef
	dw UnknownText_0x15e72
	dw UnknownText_0x15e86
	dw UnknownText_0x15e7c
	dw UnknownText_0x15e77
	dw UnknownText_0x15e81
	dw Text_PremierBallBonus

Unknown_15ce3: ; 15ce3
	dw UnknownText_0x15e95
	dw UnknownText_0x15e9a
	dw UnknownText_0x15ea9
	dw UnknownText_0x15ea4
	dw UnknownText_0x15e9f
	dw Function15cef
	dw Text_PremierBallBonus
; 15cef

Function15cef: ; 15cef
	callba Function24ae8
	call Function1ad2
	ld hl, MenuDataHeader_0x15e18
	call Function1d3c
	ld a, [WalkingX]
	ld [wcf88], a
	ld a, [WalkingY]
	ld [wd0e4], a
	call Function350c
	ld a, [wd0e4]
	ld [WalkingY], a
	ld a, [wcfa9]
	ld [WalkingX], a
	call SpeechTextBox
	ld a, [wcf73]
	cp $2
	jr z, .asm_15d6d
	call Function15c91
	jr c, .asm_15d68
	jp z, .asm_15d79
	call Function15d97
	jr c, .asm_15d68
	ld de, Money
	ld bc, $ffc3
	ld a, $3
	call Function1600b
	jr c, .asm_15d79
	ld hl, NumItems
	call ReceiveItem
	jr nc, .asm_15d6f
	ld a, [wd107]
	ld e, a
	ld d, $0
	ld b, $1
	ld hl, WalkingDirection
	call FlagAction
	call Function15fc3
	ld de, Money
	ld bc, $ffc3
	call Function15ffa
	ld a, $4
	call Function15c7d
	call Functiona36
	callba CheckItemPocket
	ld a, [wd142]
	cp BALL
	jr nz, .asm_15d68
	ld a, [wd10c]
	cp 10
	jr c, .asm_15d68
	ld a, PREMIER_BALL
	ld [CurItem], a
	ld a, [wd10c]
	ld c, 10
	call SimpleDivide
	ld a, b
	ld [wd10c], a
	ld hl, NumItems
	call ReceiveItem
	jr nc, .asm_15d68
	ld a, $6
	call Function15c7d
	call Functiona36
.asm_15d68
	call SpeechTextBox
	and a
	ret

.asm_15d6d
	scf
	ret

.asm_15d6f
	ld a, $3
	call Function15c7d
	call Functiona36
	and a
	ret

.asm_15d79
	ld a, $2
	call Function15c7d
	call Functiona36
	and a
	ret
; 15d83

Function15d83: ; 15d83
	; ld a, 99
	call GetMaxYouCanBuy
	and a
	ret z
	ld [wd10d], a
	ld a, $0
	call Function15c7d
	callba Function24fc9
	call Function1c07
	ret
; 15d97

Function15d97: ; 15d97
	predef PartyMonItemName
	ld a, $1
	call Function15c7d
	call YesNoBox
	ret
; 15da5
GetMaxYouCanBuy:
	xor a
	ld [$ffc3], a
	ld [$ffc4], a
	ld [$ffc5], a
	ld a, [EngineBuffer1]
	cp $4
	jr z, .discount
	callba GetItemPrice
	jr .okay
.discount
	call Function15df9
.okay
	ld b, -1
	jr .start
.loop
	ld a, b
	cp 99
	jr nc, .done
.start
	ld a, [$ffc5]
	add e
	ld [$ffc5], a
	ld a, [$ffc4]
	adc d
	ld [$ffc4], a
	ld a, [$ffc3]
	adc 0
	ld [$ffc3], a
	inc b
	push de
	push bc

	ld bc, $ffc3
	ld de, Money
	callba Function1600b

	pop bc
	pop de
	jr nc, .loop
	ld a, b
	cp 100
	ret c
.done
	ld a, 99
	ret

Function15da5: ; 15da5
	ld a, $1
	ld [wd10c], a
	ld a, [wd107]
	ld e, a
	ld d, $0
	ld b, $2
	ld hl, WalkingDirection
	call FlagAction
	ld a, c
	and a
	jr nz, .asm_15dd8
	ld a, [wd107]
	ld e, a
	ld d, $0
	ld hl, wd040
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld a, [hli]
	ld [$ffc5], a
	ld a, [hl]
	ld [$ffc4], a
	xor a
	ld [$ffc3], a
	and a
	ret

.asm_15dd8
	ld a, $5
	call Function15c7d
	call Functiona36
	scf
	ret
; 15de2

Function15de2: ; 15de2
	ld a, $0
	call Function15c7d
	; call Function15df9
	; ld a, 99
	call GetMaxYouCanBuy
	and a
	ret z
	ld [wd10d], a
	callba Function24fcf
	call Function1c07
	ret
; 15df9

Function15df9: ; 15df9
	ld a, [wd107]
	ld e, a
	ld d, 0
	ld hl, wd040
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	add hl, de
	add hl, de
	add hl, de
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
; 15e0e

UnknownText_0x15e0e: ; 0x15e0e
	; How many?
	text_jump UnknownText_0x1c4bfd
	db "@"
; 0x15e13

UnknownText_0x15e13: ; 0x15e13
	; @ (S) will be ¥@ .
	text_jump UnknownText_0x1c4c08
	db "@"
; 0x15e18

MenuDataHeader_0x15e18: ; 0x15e18
	db $40 ; flags
	db 03, 01 ; start coords
	db 11, 19 ; end coords
	dw MenuData2_0x15e20
	db 1 ; default option
; 0x15e20

MenuData2_0x15e20: ; 0x15e20
	db $30 ; flags
	db 4, 8 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, OBPals + 8 * 6
	dbw BANK(Function24ab4), Function24ab4
	dbw BANK(Function15e30), Function15e30
	dbw BANK(Function244c3), Function244c3
; 15e30

Function15e30: ; 15e30
	ld a, [wcf77]
	ld c, a
	ld b, 0
	ld hl, DefaultFlypoint
	add hl, bc
	add hl, bc
	add hl, bc
	push de
	ld d, h
	ld e, l
	pop hl
	ld bc, $14
	add hl, bc
	ld c, $a3
	call PrintBCDNumber
	ret
; 15e4a (5:5e4a)

UnknownText_0x15e4a: ; 0x15e4a
	; Hello, dear. I sell inexpensive herbal medicine. They're good, but a trifle bitter. Your #MON may not like them. Hehehehe<...>
	text_jump UnknownText_0x1c4c28
	db "@"
; 0x15e4f

UnknownText_0x15e4f: ; 0x15e4f
	; How many?
	text_jump UnknownText_0x1c4ca3
	db "@"
; 0x15e54

UnknownText_0x15e54: ; 0x15e54
	; @ (S) will be ¥@ .
	text_jump UnknownText_0x1c4cae
	db "@"
; 0x15e59

UnknownText_0x15e59: ; 0x15e59
	; Thank you, dear. Hehehehe<...>
	text_jump UnknownText_0x1c4cce
	db "@"
; 0x15e5e

UnknownText_0x15e5e: ; 0x15e5e
	; Oh? Your PACK is full, dear.
	text_jump UnknownText_0x1c4cea
	db "@"
; 0x15e63

UnknownText_0x15e63: ; 0x15e63
	; Hehehe<...> You don't have the money.
	text_jump UnknownText_0x1c4d08
	db "@"
; 0x15e68

UnknownText_0x15e68: ; 0x15e68
	; Come again, dear. Hehehehe<...>
	text_jump UnknownText_0x1c4d2a
	db "@"
; 0x15e6d

UnknownText_0x15e6d: ; 0x15e6d
	; Hiya! Care to see some bargains? I sell rare items that nobody else carries--but only one of each item.
	text_jump UnknownText_0x1c4d47
	db "@"
; 0x15e72

UnknownText_0x15e72: ; 0x15e72
	; costs ¥@ . Want it?
	text_jump UnknownText_0x1c4db0
	db "@"
; 0x15e77

UnknownText_0x15e77: ; 0x15e77
	; Thanks.
	text_jump UnknownText_0x1c4dcd
	db "@"
; 0x15e7c

UnknownText_0x15e7c: ; 0x15e7c
	; Uh-oh, your PACK is chock-full.
	text_jump UnknownText_0x1c4dd6
	db "@"
; 0x15e81

UnknownText_0x15e81: ; 0x15e81
	; You bought that already. I'm all sold out of it.
	text_jump UnknownText_0x1c4df7
	db "@"
; 0x15e86

UnknownText_0x15e86: ; 0x15e86
	; Uh-oh, you're short on funds.
	text_jump UnknownText_0x1c4e28
	db "@"
; 0x15e8b

UnknownText_0x15e8b: ; 0x15e8b
	; Come by again sometime.
	text_jump UnknownText_0x1c4e46
	db "@"
; 0x15e90

UnknownText_0x15e90: ; 0x15e90
	; What's up? Need some medicine?
	text_jump UnknownText_0x1c4e5f
	db "@"
; 0x15e95

UnknownText_0x15e95: ; 0x15e95
	; How many?
	text_jump UnknownText_0x1c4e7e
	db "@"
; 0x15e9a

UnknownText_0x15e9a: ; 0x15e9a
	; @ (S) will cost ¥@ .
	text_jump UnknownText_0x1c4e89
	db "@"
; 0x15e9f

UnknownText_0x15e9f: ; 0x15e9f
	; Thanks much!
	text_jump UnknownText_0x1c4eab
	db "@"
; 0x15ea4

UnknownText_0x15ea4: ; 0x15ea4
	; You don't have any more space.
	text_jump UnknownText_0x1c4eb9
	db "@"
; 0x15ea9

UnknownText_0x15ea9: ; 0x15ea9
	; Huh? That's not enough money.
	text_jump UnknownText_0x1c4ed8
	db "@"
; 0x15eae

UnknownText_0x15eae: ; 0x15eae
	; All right. See you around.
	text_jump UnknownText_0x1c4ef6
	db "@"
; 0x15eb3
Text_PremierBallBonus:
	text_jump _Text_PremierBallBonus
	db "@"

Function15eb3: ; 15eb3
	call Function2ed3
	callba Function106a5
.asm_15ebc
	callba Function106be
	ld a, [wcf66]
	and a
	jp z, Function15ece
	call Function15ee0
	jr .asm_15ebc
; 15ece

Function15ece: ; 15ece
	call Function2b74
	and a
	ret
; 15ed3

Function15ed3: ; 15ed3
	ld hl, UnknownText_0x15edb
	call Function1d67
	and a
	ret
; 15edb

UnknownText_0x15edb: ; 0x15edb
	; You don't have anything to sell.
	text_jump UnknownText_0x1c4f12
	db "@"
; 0x15ee0

Function15ee0: ; 15ee0
	callba CheckItemMenu
	ld a, [wd142]
	ld hl, Jumptable_15eee
	rst JumpTable
	ret
; 15eee

Jumptable_15eee: ; 15eee
	dw Function15efd
	dw Function15efc
	dw Function15efc
	dw Function15efc
	dw Function15efd
	dw Function15efd
	dw Function15efd
; 15efc

Function15efc: ; 15efc
	ret
; 15efd

Function15efd: ; 15efd
	callba _CheckTossableItem
	ld a, [wd142]
	and a
	jr z, .asm_15f11
	ld hl, UnknownText_0x15faf
	call PrintText
	and a
	ret

.asm_15f11
	ld hl, UnknownText_0x15f73
	call PrintText
	callba Function24af8
	callba Function24fe1
	call Function1c07
	jr c, .asm_15f6e
	hlcoord 1, 14
	ld bc, $0312
	call ClearBox
	ld hl, UnknownText_0x15f78
	call PrintTextBoxText
	call YesNoBox
	jr c, .asm_15f6e
	ld de, Money
	ld bc, $ffc3
	call Function15fd7
	ld a, [wd107]
	ld hl, NumItems
	call TossItem
	predef PartyMonItemName
	hlcoord 1, 14
	ld bc, $0312
	call ClearBox
	ld hl, UnknownText_0x15fbe
	call PrintTextBoxText
	call Function15fc3
	callba Function24af0
	call Functiona36
.asm_15f6e
	call Function1c07
	and a
	ret
; 15f73

UnknownText_0x15f73: ; 0x15f73
	; How many?
	text_jump UnknownText_0x1c4f33
	db "@"
; 0x15f78

UnknownText_0x15f78: ; 0x15f78
	; I can pay you ¥@ . Is that OK?
	text_jump UnknownText_0x1c4f3e
	db "@"
; 0x15f7d

String15f7d: ; 15f7d
	db "!ダミー!@"
UnknownText_0x15f83: ; 0x15f83
	; Welcome! How may I help you?
	text_jump UnknownText_0x1c4f62
	db "@"
; 0x15f88

MenuDataHeader_0x15f88: ; 0x15f88
	db $40 ; flags
	db 00, 00 ; start coords
	db 08, 07 ; end coords
	dw MenuData2_0x15f90
	db 1 ; default option
; 0x15f90

MenuData2_0x15f90: ; 0x15f90
	db $80 ; flags
	db 3 ; items
	db "BUY@"
	db "SELL@"
	db "QUIT@"
; 0x15f96

UnknownText_0x15fa0: ; 0x15fa0
	; Here you are. Thank you!
	text_jump UnknownText_0x1c4f80
	db "@"
; 0x15fa5

UnknownText_0x15fa5: ; 0x15fa5
	; You don't have enough money.
	text_jump UnknownText_0x1c4f9a
	db "@"
; 0x15faa

UnknownText_0x15faa: ; 0x15faa
	; You can't carry any more items.
	text_jump UnknownText_0x1c4fb7
	db "@"
; 0x15faf

UnknownText_0x15faf: ; 0x15faf
	; Sorry, I can't buy that from you.
	text_jump UnknownText_0x1c4fd7
	db "@"
; 0x15fb4

UnknownText_0x15fb4: ; 0x15fb4
	; Please come again!
	text_jump UnknownText_0x1c4ff9
	db "@"
; 0x15fb9

UnknownText_0x15fb9: ; 0x15fb9
	text_jump UnknownText_0x1c500d
	db "@"
; 0x15fbe

UnknownText_0x15fbe: ; 0x15fbe
	text_jump UnknownText_0x1c502e
	db "@"
; 0x15fc3

Function15fc3: ; 15fc3
	call WaitSFX
	ld de, SFX_TRANSACTION
	call PlaySFX
	ret
; 15fcd

Function15fcd: ; 15fcd
	call Function1d4f
	call Functiona36
	call Function1c07
	ret
; 15fd7

Function15fd7:: ; 15fd7
	ld a, $3
	call Function16053
	ld bc, Unknown_15ff7
	ld a, $3
	call Function1600b
	jr z, .asm_15ff5
	jr c, .asm_15ff5
	ld hl, Unknown_15ff7
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	scf
	ret

.asm_15ff5
	and a
	ret
; 15ff7

Unknown_15ff7: ; 15ff7
	dt 999999
; 15ffa

Function15ffa:: ; 15ffa
	ld a, $3
	call Function16035
	jr nc, .asm_16009
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	scf
	ret

.asm_16009
	and a
	ret
; 1600b

Function1600b:: ; 1600b
	ld a, 3
Function1600d: ; 1600d
; a: number of bytes
; bc: start addr of amount (big-endian)
; de: start addr of account (big-endian)
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld c, 0
	ld b, a
; Go to the end of both amounts
.loop1
	dec a
	jr z, .done
	inc de
	inc hl
	jr .loop1
; Clear flags
.done
	and a
; Compare
.loop2
	ld a, [de]
	sbc [hl]
	jr z, .okay
	inc c ; c counts the number of bytes that are not equal
.okay
	dec de
	dec hl
	dec b
	jr nz, .loop2
	jr c, .set_carry ; Clear z flag if set, and set the carry flag, if the amount is greater than the account.
	ld a, c ; If c is zero, the two amounts are exactly equal.
	and a
	jr .skip_carry

.set_carry
	ld a, 1
	and a
	scf
.skip_carry
	pop bc
	pop de
	pop hl
	ret
; 16035

Function16035: ; 16035
	ld a, $3
Function16037: ; 16037
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld b, a
	ld c, $0
.asm_1603f
	dec a
	jr z, .asm_16046
	inc de
	inc hl
	jr .asm_1603f

.asm_16046
	and a
.asm_16047
	ld a, [de]
	sbc [hl]
	ld [de], a
	dec de
	dec hl
	dec b
	jr nz, .asm_16047
	pop bc
	pop de
	pop hl
	ret
; 16053

Function16053: ; 16053
	ld a, $3
Function16055: ; 16055
	push hl
	push de
	push bc
	ld h, b
	ld l, c
	ld b, a
.asm_1605b
	dec a
	jr z, .asm_16062
	inc de
	inc hl
	jr .asm_1605b

.asm_16062
	and a
.asm_16063
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec b
	jr nz, .asm_16063
	pop bc
	pop de
	pop hl
	ret
; 1606f

Function1606f:: ; 1606f
	ld a, $2
	ld de, Coins
	call Function16055
	ld a, $2
	ld bc, Unknown_1608d
	call Function1600d
	jr c, .asm_1608b
	ld hl, Unknown_1608d
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	scf
	ret

.asm_1608b
	and a
	ret
; 1608d

Unknown_1608d: ; 1608d
	bigdw 50000
; 1608f

Function1608f:: ; 1608f
	ld a, $2
	ld de, Coins
	call Function16037
	jr nc, .asm_1609f
	xor a
	ld [de], a
	inc de
	ld [de], a
	scf
	ret

.asm_1609f
	and a
	ret
; 160a1

Function160a1:: ; 160a1
	ld a, $2
	ld de, Coins
	jp Function1600d
; 160a9

INCLUDE "items/marts.asm"

Function16218: ; 16218
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	xor a
	ld [wcf63], a
.asm_16223
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_1622f
	call Function16233
	jr .asm_16223

.asm_1622f
	pop af
	ld [$ffaa], a
	ret
; 16233

Function16233: ; 16233
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_16242
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 16242

Jumptable_16242: ; 16242
	dw Function16254
	dw Function1626a
	dw Function16290
	dw Function162a8
	dw Function162e0
	dw Function16373
	dw Function16406
	dw Function1642d
	dw Function16433
; 16254

Function16254: ; 16254
	ld a, [wd854]
	bit 7, a
	jr nz, .asm_16264
	set 7, a
	ld [wd854], a
	ld a, $1
	jr .asm_16266

.asm_16264
	ld a, $2
.asm_16266
	ld [wcf63], a
	ret
; 1626a

Function1626a: ; 1626a
	ld hl, UnknownText_0x16649
	call PrintText
	call YesNoBox
	jr c, .asm_1627f
	ld hl, UnknownText_0x1664e
	call PrintText
	ld a, $81
	jr .asm_16281

.asm_1627f
	ld a, $80
.asm_16281
	ld [wd854], a
	ld hl, UnknownText_0x16653
	call PrintText
	ld a, $8
	ld [wcf63], a
	ret
; 16290

Function16290: ; 16290
	ld hl, UnknownText_0x16658
	call PrintText
	call YesNoBox
	jr c, .asm_1629f
	ld a, $3
	jr .asm_162a4

.asm_1629f
	call DSTChecks
	ld a, $7
.asm_162a4
	ld [wcf63], a
	ret
; 162a8

Function162a8: ; 162a8
	ld hl, UnknownText_0x1665d
	call PrintText
	call Function1d6e
	ld hl, MenuDataHeader_0x166b5
	call Function1d3c
	call Function1d81
	call Function1c17
	jr c, .asm_162ce
	ld a, [wcfa9]
	cp $1
	jr z, .asm_162d2
	cp $2
	jr z, .asm_162d6
	cp $3
	jr z, .asm_162da
.asm_162ce
	ld a, $7
	jr .asm_162dc

.asm_162d2
	ld a, $5
	jr .asm_162dc

.asm_162d6
	ld a, $4
	jr .asm_162dc

.asm_162da
	ld a, $6
.asm_162dc
	ld [wcf63], a
	ret
; 162e0

Function162e0: ; 162e0
	ld hl, UnknownText_0x16662
	call PrintText
	xor a
	ld hl, StringBuffer2
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $5
	ld [wcf64], a
	call Function1d6e
	call Function16517
	call Function1656b
	call Function16571
	call Function1c17
	jr c, .asm_1636d
	ld hl, StringBuffer2
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, .asm_1636d
	ld de, Money
	ld bc, StringBuffer2
	callba Function1600b
	jr c, .asm_1635f
	ld hl, StringBuffer2
	ld de, StringBuffer2 + 3
	ld bc, $0003
	call CopyBytes
	ld bc, wd851
	ld de, StringBuffer2
	callba Function15fd7
	jr c, .asm_16366
	ld bc, StringBuffer2 + 3
	ld de, Money
	callba Function15ffa
	ld hl, StringBuffer2
	ld de, wd851
	ld bc, $0003
	call CopyBytes
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0x1668a
	call PrintText
	ld a, $8
	jr .asm_1636f

.asm_1635f
	ld hl, UnknownText_0x1667b
	call PrintText
	ret

.asm_16366
	ld hl, UnknownText_0x16680
	call PrintText
	ret

.asm_1636d
	ld a, $7
.asm_1636f
	ld [wcf63], a
	ret
; 16373

Function16373: ; 16373
	ld hl, UnknownText_0x16667
	call PrintText
	xor a
	ld hl, StringBuffer2
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $5
	ld [wcf64], a
	call Function1d6e
	call Function16512
	call Function1656b
	call Function16571
	call Function1c17
	jr c, .asm_16400
	ld hl, StringBuffer2
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	jr z, .asm_16400
	ld hl, StringBuffer2
	ld de, StringBuffer2 + 3
	ld bc, $0003
	call CopyBytes
	ld de, wd851
	ld bc, StringBuffer2
	callba Function1600b
	jr c, .asm_163f2
	ld bc, Money
	ld de, StringBuffer2
	callba Function15fd7
	jr c, .asm_163f9
	ld bc, StringBuffer2 + 3
	ld de, wd851
	callba Function15ffa
	ld hl, StringBuffer2
	ld de, Money
	ld bc, $0003
	call CopyBytes
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	ld hl, UnknownText_0x1668f
	call PrintText
	ld a, $8
	jr .asm_16402

.asm_163f2
	ld hl, UnknownText_0x16671
	call PrintText
	ret

.asm_163f9
	ld hl, UnknownText_0x16676
	call PrintText
	ret

.asm_16400
	ld a, $7
.asm_16402
	ld [wcf63], a
	ret
; 16406

Function16406: ; 16406
	ld hl, UnknownText_0x1666c
	call PrintText
	call YesNoBox
	jr c, .asm_16422
	ld a, $81
	ld [wd854], a
	ld hl, UnknownText_0x16685
	call PrintText
	ld a, $8
	ld [wcf63], a
	ret

.asm_16422
	ld a, $80
	ld [wd854], a
	ld a, $7
	ld [wcf63], a
	ret
; 1642d

Function1642d: ; 1642d
	ld hl, UnknownText_0x16694
	call PrintText
Function16433: ; 16433
	ld hl, wcf63
	set 7, [hl]
	ret
; 16439

DSTChecks: ; 16439
; check the time; avoid changing DST if doing so would change the current day

	ld a, [wDST]
	bit 7, a
	ld a, [hHours]
	jr z, .asm_16447
	and a ; within one hour of 00:00?
	jr z, .LostBooklet
	jr .next

.asm_16447
	cp 23 ; within one hour of 23:00?
	jr nz, .next
	; fallthrough
.LostBooklet
	call Function164ea
	bccoord 1, 14
	ld hl, UnknownText_0x164f4
	call Function13e5
	call YesNoBox
	ret c
	call Function164ea
	bccoord 1, 14
	ld hl, LostInstructionBookletText
	call Function13e5
	ret

.next
	call Function164ea
	bccoord 1, 14
	ld a, [wDST]
	bit 7, a
	jr z, .asm_16497
	ld hl, UnknownText_0x16508
	call Function13e5
	call YesNoBox
	ret c
	ld a, [wDST]
	res 7, a
	ld [wDST], a
	call Function164d1
	call Function164ea
	bccoord 1, 14
	ld hl, UnknownText_0x1650d
	call Function13e5
	ret

.asm_16497
	ld hl, UnknownText_0x164fe
	call Function13e5
	call YesNoBox
	ret c
	ld a, [wDST]
	set 7, a
	ld [wDST], a
	call Function164b9
	call Function164ea
	bccoord 1, 14
	ld hl, UnknownText_0x16503
	call Function13e5
	ret
; 164b9

Function164b9: ; 164b9
	ld a, [StartHour]
	add 1
	sub 24
	jr nc, .asm_164c4
	add 24
.asm_164c4
	ld [StartHour], a
	ccf
	ld a, [StartDay]
	adc 0
	ld [StartDay], a
	ret
; 164d1

Function164d1: ; 164d1
	ld a, [StartHour]
	sub 1
	jr nc, .asm_164da
	add 24
.asm_164da
	ld [StartHour], a
	ld a, [StartDay]
	sbc 0
	jr nc, .asm_164e6
	add 7
.asm_164e6
	ld [StartDay], a
	ret
; 164ea

Function164ea: ; 164ea
	hlcoord 1, 14
	ld bc, $0312
	call ClearBox
	ret
; 164f4

UnknownText_0x164f4: ; 0x164f4
	; Do you want to adjust your clock for Daylight Saving Time?
	text_jump UnknownText_0x1c6095
	db "@"
; 0x164f9

LostInstructionBookletText: ; 0x164f9
	; I lost the instruction booklet for the POKéGEAR.
	; Come back again in a while.
	text_jump UnknownText_0x1c60d1
	db "@"
; 0x164fe

UnknownText_0x164fe: ; 0x164fe
	; Do you want to switch to Daylight Saving Time?
	text_jump UnknownText_0x1c6000
	db "@"
; 0x16503

UnknownText_0x16503: ; 0x16503
	; I set the clock forward by one hour.
	text_jump UnknownText_0x1c6030
	db "@"
; 0x16508

UnknownText_0x16508: ; 0x16508
	; Is Daylight Saving Time over?
	text_jump UnknownText_0x1c6056
	db "@"
; 0x1650d

UnknownText_0x1650d: ; 0x1650d
	; I put the clock back one hour.
	text_jump UnknownText_0x1c6075
	db "@"
; 0x16512

Function16512: ; 16512
	ld de, String_1669f
	jr Function1651a

Function16517: ; 16517
	ld de, String_166a8
Function1651a: ; 1651a
	push de
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, $0612
	call TextBox
	hlcoord 1, 2
	ld de, String_16699
	call PlaceString
	hlcoord 12, 2
	ld de, wd851
	ld bc, $2306
	call PrintNum
	hlcoord 1, 4
	ld de, String_166b0
	call PlaceString
	hlcoord 12, 4
	ld de, Money
	ld bc, $2306
	call PrintNum
	hlcoord 1, 6
	pop de
	call PlaceString
	hlcoord 12, 6
	ld de, StringBuffer2
	ld bc, $a306
	call PrintNum
	call Function1ad2
	call Function3238
	ret
; 1656b

Function1656b: ; 1656b
	ld c, $a
	call DelayFrames
	ret
; 16571

Function16571: ; 16571
.asm_16571
	call Functiona57
	ld hl, hJoyPressed
	ld a, [hl]
	and $2
	jr nz, .asm_165b5
	ld a, [hl]
	and $1
	jr nz, .asm_165b7
	call Function165b9
	xor a
	ld [hBGMapMode], a
	hlcoord 12, 6
	ld bc, $0007
	ld a, $7f
	call ByteFill
	hlcoord 12, 6
	ld de, StringBuffer2
	ld bc, $a306
	call PrintNum
	ld a, [$ff9b]
	and $10
	jr nz, .asm_165b0
	hlcoord 13, 6
	ld a, [wcf64]
	ld c, a
	ld b, $0
	add hl, bc
	ld [hl], $7f
.asm_165b0
	call WaitBGMap
	jr .asm_16571

.asm_165b5
	scf
	ret

.asm_165b7
	and a
	ret
; 165b9

Function165b9: ; 165b9
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, .asm_165e3
	ld a, [hl]
	and $80
	jr nz, .asm_165f5
	ld a, [hl]
	and $20
	jr nz, .asm_165d2
	ld a, [hl]
	and $10
	jr nz, .asm_165da
	and a
	ret

.asm_165d2
	ld hl, wcf64
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

.asm_165da
	ld hl, wcf64
	ld a, [hl]
	cp $5
	ret nc
	inc [hl]
	ret

.asm_165e3
	ld hl, Unknown_16613
	call Function16607
	ld c, l
	ld b, h
	ld de, StringBuffer2
	callba Function15fd7
	ret

.asm_165f5
	ld hl, Unknown_16613
	call Function16607
	ld c, l
	ld b, h
	ld de, StringBuffer2
	callba Function15ffa
	ret
; 16607

Function16607: ; 16607
	ld a, [wcf64]
	push de
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	add hl, de
	pop de
	ret
; 16613

Unknown_16613: ; 16613
	dt 100000
	dt 10000
	dt 1000
	dt 100
	dt 10
	dt 1
	dt 100000
	dt 10000
	dt 1000
	dt 100
	dt 10
	dt 1
	dt 900000
	dt 90000
	dt 9000
	dt 900
	dt 90
	dt 9
; 16649

UnknownText_0x16649: ; 0x16649
	; Wow, that's a cute #MON. Where did you get it? <...> So, you're leaving on an adventure<...> OK! I'll help too. But what can I do for you? I know! I'll save money for you. On a long journey, money's important. Do you want me to save your money?
	text_jump UnknownText_0x1bd77f
	db "@"
; 0x1664e

UnknownText_0x1664e: ; 0x1664e
	; OK, I'll take care of your money.
	text_jump UnknownText_0x1bd868
	db "@"
; 0x16653

UnknownText_0x16653: ; 0x16653
	; Be careful. #MON are your friends. You need to work as a team. Now, go on!
	text_jump UnknownText_0x1bd88e
	db "@"
; 0x16658

UnknownText_0x16658: ; 0x16658
	; Hi! Welcome home! You're trying very hard, I see. I've kept your room tidy. Or is this about your money?
	text_jump UnknownText_0x1bd8da
	db "@"
; 0x1665d

UnknownText_0x1665d: ; 0x1665d
	; What do you want to do?
	text_jump UnknownText_0x1bd942
	db "@"
; 0x16662

UnknownText_0x16662: ; 0x16662
	; How much do you want to save?
	text_jump UnknownText_0x1bd95b
	db "@"
; 0x16667

UnknownText_0x16667: ; 0x16667
	; How much do you want to take?
	text_jump UnknownText_0x1bd97a
	db "@"
; 0x1666c

UnknownText_0x1666c: ; 0x1666c
	; Do you want to save some money?
	text_jump UnknownText_0x1bd999
	db "@"
; 0x16671

UnknownText_0x16671: ; 0x16671
	; You haven't saved that much.
	text_jump UnknownText_0x1bd9ba
	db "@"
; 0x16676

UnknownText_0x16676: ; 0x16676
	; You can't take that much.
	text_jump UnknownText_0x1bd9d7
	db "@"
; 0x1667b

UnknownText_0x1667b: ; 0x1667b
	; You don't have that much.
	text_jump UnknownText_0x1bd9f1
	db "@"
; 0x16680

UnknownText_0x16680: ; 0x16680
	; You can't save that much.
	text_jump UnknownText_0x1bda0b
	db "@"
; 0x16685

UnknownText_0x16685: ; 0x16685
	; OK, I'll save your money. Trust me!, stick with it!
	text_jump UnknownText_0x1bda25
	db "@"
; 0x1668a

UnknownText_0x1668a: ; 0x1668a
	; Your money's safe here! Get going!
	text_jump UnknownText_0x1bda5b
	db "@"
; 0x1668f

UnknownText_0x1668f: ; 0x1668f
	;, don't give up!
	text_jump UnknownText_0x1bda7e
	db "@"
; 0x16694

UnknownText_0x16694: ; 0x16694
	; Just do what you can.
	text_jump UnknownText_0x1bda90
	db "@"
; 0x16699

String_16699: ; 16699
	db "SAVED@"
; 1669f

String_1669f: ; 1669f
	db "WITHDRAW@"
; 166a8

String_166a8: ; 166a8
	db "DEPOSIT@"
; 166b0

String_166b0: ; 166b0
	db "HELD@"
; 166b5

MenuDataHeader_0x166b5: ; 0x166b5
	db $40 ; flags
	db 00, 00 ; start coords
	db 10, 10 ; end coords
	dw MenuData2_0x166bd
	db 1 ; default option
; 0x166bd

MenuData2_0x166bd: ; 0x166bd
	db $80 ; flags
	db 4 ; items
	db "GET@"
	db "SAVE@"
	db "CHANGE@"
	db "CANCEL@"
; 0x166d6

Function166d6: ; 166d6
	ld hl, wDaycareMan
	bit 0, [hl]
	jr nz, .asm_166fe
	ld hl, wDaycareMan
	ld a, $0
	call Function1678f
	jr c, .asm_16724
	call Function16798
	jr c, .asm_16721
	callba Functionde2a
	ld hl, wDaycareMan
	set 0, [hl]
	call Function167f6
	call Function16a3b
	ret

.asm_166fe
	callba Functione698
	ld hl, wBreedMon1Nick
	call Function1686d
	call Function16807
	jr c, .asm_16721
	callba Functiondd21
	call Function16850
	ld hl, wDaycareMan
	res 0, [hl]
	res 5, [hl]
	jr .asm_16724

.asm_16721
	call Function1689b
.asm_16724
	ld a, $13
	call Function1689b
	ret
; 1672a

Function1672a: ; 1672a
	ld hl, wDaycareLady
	bit 0, [hl]
	jr nz, .asm_16752
	ld hl, wDaycareLady
	ld a, $2
	call Function16781
	jr c, .asm_1677b
	call Function16798
	jr c, .asm_16778
	callba Functionde37
	ld hl, wDaycareLady
	set 0, [hl]
	call Function167f6
	call Function16a3b
	ret

.asm_16752
	callba Functione6b3
	ld hl, wBreedMon2Nick
	call Function1686d
	call Function16807
	jr c, .asm_16778
	callba Functiondd42
	call Function16850
	ld hl, wDaycareLady
	res 0, [hl]
	ld hl, wDaycareMan
	res 5, [hl]
	jr .asm_1677b

.asm_16778
	call Function1689b
.asm_1677b
	ld a, $13
	call Function1689b
	ret
; 16781

Function16781: ; 16781
	bit 7, [hl]
	jr nz, .asm_16788
	set 7, [hl]
	inc a
.asm_16788
	call Function1689b
	call YesNoBox
	ret
; 1678f

Function1678f: ; 1678f
	set 7, [hl]
	call Function1689b
	call YesNoBox
	ret
; 16798

Function16798: ; 16798
	ld a, [PartyCount]
	cp $2
	jr c, .asm_167e5
	ld a, $4
	call Function1689b
	ld b, $6
	callba Function5001d
	jr c, .asm_167dd
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_167e1
	callba Functione538
	jr c, .asm_167e9
	ld hl, PartyMon1Item
	ld bc, PartyMon2 - PartyMon1
	ld a, [CurPartyMon]
	call AddNTimes
	ld d, [hl]
	callba ItemIsMail
	jr c, .asm_167ed
	ld hl, PartyMonNicknames
	ld a, [CurPartyMon]
	call GetNick
	and a
	ret

.asm_167dd
	ld a, $12
	scf
	ret

.asm_167e1
	ld a, $6
	scf
	ret

.asm_167e5
	ld a, $7
	scf
	ret

.asm_167e9
	ld a, $8
	scf
	ret

.asm_167ed
	ld a, $a
	scf
	ret
; 167f1

UnknownText_0x167f1: ; 0x167f1
	;
	text_jump UnknownText_0x1bdaa7
	db "@"
; 0x167f6

Function167f6: ; 167f6
	ld a, $5
	call Function1689b
	ld a, [CurPartySpecies]
	call PlayCry
	ld a, $9
	call Function1689b
	ret
; 16807

Function16807: ; 16807
	ld a, [StringBuffer2 + 1]
	and a
	jr nz, .asm_16819
	ld a, $f
	call Function1689b
	call YesNoBox
	jr c, .asm_16844
	jr .asm_1682d

.asm_16819
	ld a, $b
	call Function1689b
	call YesNoBox
	jr c, .asm_16844
	ld a, $c
	call Function1689b
	call YesNoBox
	jr c, .asm_16844
.asm_1682d
	ld de, Money
	ld bc, StringBuffer2 + 2
	callba Function1600b
	jr c, .asm_16848
	ld a, [PartyCount]
	cp $6
	jr nc, .asm_1684c
	and a
	ret

.asm_16844
	ld a, $12
	scf
	ret

.asm_16848
	ld a, $11
	scf
	ret

.asm_1684c
	ld a, $10
	scf
	ret
; 16850

Function16850: ; 16850
	ld bc, StringBuffer2 + 2
	ld de, Money
	callba Function15ffa
	ld a, $d
	call Function1689b
	ld a, [CurPartySpecies]
	call PlayCry
	ld a, $e
	call Function1689b
	ret
; 1686d

Function1686d: ; 1686d
	ld a, b
	ld [StringBuffer2], a
	ld a, d
	ld [StringBuffer2 + 1], a
	ld de, StringBuffer1
	ld bc, $000b
	call CopyBytes
	ld hl, $0000
	ld bc, $0064
	ld a, [StringBuffer2 + 1]
	call AddNTimes
	ld de, $0064
	add hl, de
	xor a
	ld [StringBuffer2 + 2], a
	ld a, h
	ld [StringBuffer2 + 3], a
	ld a, l
	ld [StringBuffer2 + 4], a
	ret
; 1689b

Function1689b: ; 1689b
	ld e, a
	ld d, 0
	ld hl, TextTable_168aa
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ret
; 168aa

TextTable_168aa: ; 168aa
	dw UnknownText_0x168d2
	dw UnknownText_0x168d7
	dw UnknownText_0x168dc
	dw UnknownText_0x168e1
	dw UnknownText_0x168e6
	dw UnknownText_0x168ff
	dw UnknownText_0x168f0
	dw UnknownText_0x168eb
	dw UnknownText_0x168fa
	dw UnknownText_0x16904
	dw UnknownText_0x168f5
	dw UnknownText_0x16909
	dw UnknownText_0x1690e
	dw UnknownText_0x16913
	dw UnknownText_0x16918
	dw UnknownText_0x1691d
	dw UnknownText_0x16922
	dw UnknownText_0x16927
	dw UnknownText_0x1692c
	dw UnknownText_0x16931
; 168d2

UnknownText_0x168d2: ; 0x168d2
	; I'm the DAY-CARE MAN. Want me to raise a #MON?
	text_jump UnknownText_0x1bdaa9
	db "@"
; 0x168d7

UnknownText_0x168d7: ; 0x168d7
	; I'm the DAY-CARE MAN. Do you know about EGGS? I was raising #MON with my wife, you see. We were shocked to find an EGG! How incredible is that? So, want me to raise a #MON?
	text_jump UnknownText_0x1bdad8
	db "@"
; 0x168dc

UnknownText_0x168dc: ; 0x168dc
	; I'm the DAY-CARE LADY. Should I raise a #MON for you?
	text_jump UnknownText_0x1bdb85
	db "@"
; 0x168e1

UnknownText_0x168e1: ; 0x168e1
	; I'm the DAY-CARE LADY. Do you know about EGGS? My husband and I were raising some #MON, you see. We were shocked to find an EGG! How incredible could that be? Should I raise a #MON for you?
	text_jump UnknownText_0x1bdbbb
	db "@"
; 0x168e6

UnknownText_0x168e6: ; 0x168e6
	; What should I raise for you?
	text_jump UnknownText_0x1bdc79
	db "@"
; 0x168eb

UnknownText_0x168eb: ; 0x168eb
	; Oh? But you have just one #MON.
	text_jump UnknownText_0x1bdc97
	db "@"
; 0x168f0

UnknownText_0x168f0: ; 0x168f0
	; Sorry, but I can't accept an EGG.
	text_jump UnknownText_0x1bdcb8
	db "@"
; 0x168f5

UnknownText_0x168f5: ; 0x168f5
	; Remove MAIL before you come see me.
	text_jump UnknownText_0x1bdcda
	db "@"
; 0x168fa

UnknownText_0x168fa: ; 0x168fa
	; If you give me that, what will you battle with?
	text_jump UnknownText_0x1bdcff
	db "@"
; 0x168ff

UnknownText_0x168ff: ; 0x168ff
	; OK. I'll raise your @ .
	text_jump UnknownText_0x1bdd30
	db "@"
; 0x16904

UnknownText_0x16904: ; 0x16904
	; Come back for it later.
	text_jump UnknownText_0x1bdd4b
	db "@"
; 0x16909

UnknownText_0x16909: ; 0x16909
	; Are we geniuses or what? Want to see your @ ?
	text_jump UnknownText_0x1bdd64
	db "@"
; 0x1690e

UnknownText_0x1690e: ; 0x1690e
	; Your @ has grown a lot. By level, it's grown by @ . If you want your #MON back, it will cost ¥@ .
	text_jump UnknownText_0x1bdd96
	db "@"
; 0x16913

UnknownText_0x16913: ; 0x16913
	; Perfect! Here's your #MON.
	text_jump UnknownText_0x1bde04
	db "@"
; 0x16918

UnknownText_0x16918: ; 0x16918
	; got back @ .
	text_jump UnknownText_0x1bde1f
	db "@"
; 0x1691d

UnknownText_0x1691d: ; 0x1691d
	; Huh? Back already? Your @ needs a little more time with us. If you want your #MON back, it will cost ¥100.
	text_jump UnknownText_0x1bde32
	db "@"
; 0x16922

UnknownText_0x16922: ; 0x16922
	; You have no room for it.
	text_jump UnknownText_0x1bdea2
	db "@"
; 0x16927

UnknownText_0x16927: ; 0x16927
	; You don't have enough money.
	text_jump UnknownText_0x1bdebc
	db "@"
; 0x1692c

UnknownText_0x1692c: ; 0x1692c
	; Oh, fine then.
	text_jump UnknownText_0x1bded9
	db "@"
; 0x16931

UnknownText_0x16931: ; 0x16931
	; Come again.
	text_jump UnknownText_0x1bdee9
	db "@"
; 0x16936

Function16936: ; 16936
	ld hl, wDaycareMan
	bit 6, [hl]
	jr nz, Function16949
	ld hl, UnknownText_0x16944
	call PrintText
	ret

UnknownText_0x16944: ; 0x16944
	; Not yet<...>
	text_jump UnknownText_0x1bdef6
	db "@"
; 0x16949

Function16949: ; 16949
	ld hl, UnknownText_0x16993
	call PrintText
	call YesNoBox
	jr c, .asm_1697c
	ld a, [PartyCount]
	cp PARTY_LENGTH
	jr nc, .asm_16987
	call Function169ac
	ld hl, wDaycareMan
	res 6, [hl]
	call Function16a3b
	ld hl, UnknownText_0x16998
	call PrintText
	ld de, SFX_GET_EGG_FROM_DAYCARE_LADY
	call PlaySFX
	ld c, $78
	call DelayFrames
	ld hl, UnknownText_0x1699d
	jr .asm_1697f

.asm_1697c
	ld hl, UnknownText_0x169a2
.asm_1697f
	call PrintText
	xor a
	ld [ScriptVar], a
	ret

.asm_16987
	ld hl, UnknownText_0x169a7
	call PrintText
	ld a, $1
	ld [ScriptVar], a
	ret
; 16993

UnknownText_0x16993: ; 0x16993
	; Ah, it's you! We were raising your #MON, and my goodness, were we surprised! Your #MON had an EGG! We don't know how it got there, but your #MON had it. You want it?
	text_jump UnknownText_0x1bdf00
	db "@"
; 0x16998

UnknownText_0x16998: ; 0x16998
	; received the EGG!
	text_jump UnknownText_0x1bdfa5
	db "@"
; 0x1699d

UnknownText_0x1699d: ; 0x1699d
	; Take good care of it.
	text_jump UnknownText_0x1bdfba
	db "@"
; 0x169a2

UnknownText_0x169a2: ; 0x169a2
	; Well then, I'll keep it. Thanks!
	text_jump UnknownText_0x1bdfd1
	db "@"
; 0x169a7

UnknownText_0x169a7: ; 0x169a7
	; You have no room in your party. Come back later.
	text_jump UnknownText_0x1bdff2
	db "@"
; 0x169ac

Function169ac: ; 169ac
	ld a, [wEggMonLevel]
	ld [CurPartyLevel], a
	ld hl, PartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nc, .asm_16a2f
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, EGG
	ld [hli], a
	ld a, [wEggMonSpecies]
	ld [CurSpecies], a
	ld [CurPartySpecies], a
	ld a, $ff
	ld [hl], a
	ld hl, PartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call Function16a31
	ld hl, wEggNick
	call CopyBytes
	ld hl, PartyMonOT
	ld bc, $000b
	call Function16a31
	ld hl, wEggOT
	call CopyBytes
	ld hl, PartyMon1
	ld bc, PartyMon2 - PartyMon1
	call Function16a31
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	call CopyBytes
	call GetBaseData
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld b, h
	ld c, l
	ld hl, PartyMon1ID + 1 - PartyMon1
	add hl, bc
	push hl
	ld hl, PartyMon1MaxHP - PartyMon1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push bc
	ld b, $0
	predef CalcPkmnStats
	pop bc
	ld hl, PartyMon1HP - PartyMon1
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	and a
	ret

.asm_16a2f
	scf
	ret
; 16a31

Function16a31: ; 16a31
	ld a, [PartyCount]
	dec a
	call AddNTimes
	ld d, h
	ld e, l
	ret
; 16a3b

Function16a3b: ; 16a3b
	ld a, [wDaycareLady]
	bit 0, a
	ret z
	ld a, [wDaycareMan]
	bit 0, a
	ret z
	callab Function16e1d ;find egg comatability
	ld a, [wd265]
	and a
	ret z
	inc a
	ret z ;if 0 or ff, ret
	ld hl, wDaycareMan
	set 5, [hl]
.asm_16a59
	call Random
	cp 150
	jr c, .asm_16a59
	ld [wStepsToEgg], a
	xor a
	ld hl, wEggMon
	ld bc, wEggMonEnd - wEggMon
	call ByteFill
	ld hl, wEggNick
	ld bc, PKMN_NAME_LENGTH
	call ByteFill
	ld hl, wEggOT
	ld bc, NAME_LENGTH
	call ByteFill
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, [wBreedMon1Species]
	ld [CurPartySpecies], a
	ld a, $3
	ld [MonType], a
	ld a, [wBreedMon1Species]
	cp DITTO
	ld a, $1
	jr z, .asm_16ab6
	ld a, [wBreedMon2Species]
	cp DITTO
	ld a, $0
	jr z, .asm_16ab6
	callba GetGender
	ld a, $0
	jr z, .asm_16ab6
	inc a
.asm_16ab6
	ld [wDittoInDaycare], a ;set slot with mother or ditto. 0 if slot 1 else 1
	and a
	ld a, [wBreedMon1Species]
	jr z, .asm_16ac2
	ld a, [wBreedMon2Species]
.asm_16ac2
	ld [CurPartySpecies], a
	callab GetPreEvolution
	callab GetPreEvolution
	ld a, EGG_LEVEL
	ld [CurPartyLevel], a
	ld a, [CurPartySpecies]
	cp NIDORAN_F
	jr nz, .asm_16ae8
	call Random
	cp $80
	ld a, NIDORAN_F
	jr c, .asm_16ae8
	ld a, NIDORAN_M
.asm_16ae8
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	ld [wEggMonSpecies], a
	call GetBaseData
	ld hl, wEggNick
	ld de, String_16be0
	call CopyName2
	ld hl, PlayerName
	ld de, wEggOT
	ld bc, NAME_LENGTH
	call CopyBytes
	xor a
	ld [wEggMonItem], a
	ld de, wEggMonMoves
	xor a
	ld [Buffer1], a
	predef FillMoves ;fill in basic moves
	callba Function170bf ;fill in egg moves
	ld hl, wEggMonID
	ld a, [PlayerID]
	ld [hli], a
	ld a, [PlayerID + 1]
	ld [hl], a
	ld a, [CurPartyLevel]
	ld d, a
	callab Function50e47
	ld hl, wEggMonExp
	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hl], a
	xor a
	ld b, $a
	ld hl, wEggMonStatExp
.asm_16b46
	ld [hli], a
	dec b
	jr nz, .asm_16b46
	ld hl, wEggMonDVs
	call Random
	ld [hli], a
	ld [TempMonDVs], a
	call Random
	ld [hld], a
	ld [TempMonDVs + 1], a
	ld de, wBreedMon1DVs
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .asm_16b98
	ld de, wBreedMon2DVs
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .asm_16b98
	ld a, $3
	ld [MonType], a
	push hl
	callba GetGender
	pop hl
	ld de, wBreedMon1DVs
	ld bc, wBreedMon2DVs
	jr c, .asm_16bab
	jr z, .asm_16b90
	ld a, [wDittoInDaycare]
	and a
	jr z, .asm_16b98
	ld d, b
	ld e, c
	jr .asm_16b98

.asm_16b90
	ld a, [wDittoInDaycare]
	and a
	jr nz, .asm_16b98
	ld d, b
	ld e, c
.asm_16b98
	ld a, [de]
	inc de
	and $f
	ld b, a
	ld a, [hl]
	and $f0
	add b
	ld [hli], a
	ld a, [de]
	and $7
	ld b, a
	ld a, [hl]
	and $f8
	add b
	ld [hl], a
.asm_16bab
	ld hl, StringBuffer1
	ld de, wd050
	ld bc, $000b
	call CopyBytes
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	ld hl, wd050
	ld de, StringBuffer1
	ld bc, $000b
	call CopyBytes
	ld a, [BaseEggSteps]
	ld hl, wEggMonHappiness
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, [CurPartyLevel]
	ld [wEggMonLevel], a
	ret
; 16be0

String_16be0: ; 16be0
	db "EGG@"
; 16be4

Function16be4: ; 16be4
	ld a, [UnownDex]
	and a
	ret z
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	ld a, [Options]
	push af
	set 4, a
	ld [Options], a
	call WhiteBGMap
	call ClearTileMap
	ld de, UnownDexATile
	ld hl, $8ef0
	lb bc, BANK(UnownDexBTile), 1
	call Request1bpp
	ld de, UnownDexBTile
	ld hl, $8f50
	lb bc, BANK(UnownDexBTile), 1
	call Request1bpp
	hlcoord 0, 0
	ld bc, $0312
	call TextBox
	hlcoord 0, 5
	ld bc, $0707
	call TextBox
	hlcoord 0, 14
	ld bc, $0212
	call TextBox
	hlcoord 1, 2
	ld de, AlphRuinsStampString
	call PlaceString
	hlcoord 1, 16
	ld de, UnownDexDoWhatString
	call PlaceString
	hlcoord 10, 6
	ld de, UnownDexMenuString
	call PlaceString
	xor a
	ld [wcf63], a
	call Function16cc8
	call WaitBGMap
	ld a, UNOWN
	ld [CurPartySpecies], a
	xor a
	ld [TempMonDVs], a
	ld [TempMonDVs + 1], a
	ld b, $1c
	call GetSGBLayout
	call Function32f9
.asm_16c6b
	call Functiona57
	ld a, [hJoyPressed]
	and B_BUTTON
	jr nz, .asm_16c95
	ld a, [hJoyPressed]
	and A_BUTTON
	jr nz, .asm_16c82
	call Function16ca0
	call DelayFrame
	jr .asm_16c6b

.asm_16c82
	ld a, [wcf63]
	push af
	callba Function84560
	call RestartMapMusic
	pop af
	ld [wcf63], a
	jr .asm_16c6b

.asm_16c95
	pop af
	ld [Options], a
	pop af
	ld [$ffaa], a
	call Function222a
	ret
; 16ca0

Function16ca0: ; 16ca0
	ld a, [$ffa9]
	and $10
	jr nz, .asm_16cb9
	ld a, [$ffa9]
	and $20
	jr nz, .asm_16cad
	ret

.asm_16cad
	ld hl, wcf63
	ld a, [hl]
	and a
	jr nz, .asm_16cb6
	ld [hl], $1b
.asm_16cb6
	dec [hl]
	jr .asm_16cc4

.asm_16cb9
	ld hl, wcf63
	ld a, [hl]
	cp $1a
	jr c, .asm_16cc3
	ld [hl], $ff
.asm_16cc3
	inc [hl]
.asm_16cc4
	call Function16cc8
	ret
; 16cc8

Function16cc8: ; 16cc8
	ld a, [wcf63]
	cp 26
	jr z, Function16d20
	inc a
	ld [UnownLetter], a
	ld a, UNOWN
	ld [CurPartySpecies], a
	xor a
	ld [wc2c6], a
	ld de, VTiles2
	predef GetFrontpic
	call Function16cff
	hlcoord 1, 6
	xor a
	ld [$ffad], a
	ld bc, $0707
	predef FillBox
	ld de, $9310
	callba Functione0000
	ret
; 16cff

Function16cff: ; 16cff
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld a, $0
	call GetSRAMBank
	ld de, w6_d000
	ld hl, $a000
	ld a, [hROMBank]
	ld b, a
	ld c, $31
	call Get2bpp
	call CloseSRAM
	pop af
	ld [rSVBK], a
	ret
; 16d20

Function16d20: ; 16d20
	hlcoord 1, 6
	ld bc, $0707
	call ClearBox
	hlcoord 1, 9
	ld de, UnownDexVacantString
	call PlaceString
	xor a
	call GetSRAMBank
	ld hl, $a000
	ld bc, $0310
	xor a
	call ByteFill
	ld hl, $9310
	ld de, $a000
	ld c, $31
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	call CloseSRAM
	ld c, $14
	call DelayFrames
	ret
; 16d57

AlphRuinsStampString:
	db " ALPH RUINS STAMP@"
UnownDexDoWhatString:
	db "Do what?@"
UnownDexMenuString:
	db $ef, " PRINT", $4e
	db $f5, " CANCEL", $4e
	db $df, " PREVIOUS", $4e
	db $eb, " NEXT@"
UnownDexVacantString:
	db "VACANT@"
; 16d9c

UnownDexATile: ; 16d9c
INCBIN "gfx/unknown/016d9c.1bpp"

UnownDexBTile: ; 16da4
INCBIN "gfx/unknown/016da4.1bpp"
; 16dac

Function16dac: ; 16dac
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	hlcoord 7, 11
	ld a, $31
	ld [$ffad], a
	ld bc, $0707
	predef FillBox
	ret
; 16dc7

Function16dc7: ; 16dc7
	ld hl, UnknownText_0x16e04
	call PrintText
	callba Function50000
	jr c, .asm_16df8
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_16dfd
	ld hl, UnknownText_0x16e09
	call PrintText
	call Function2ed3
	callba Function8461a
	call Function2b74
	ld a, [$ffac]
	and a
	jr nz, .asm_16df8
	ld hl, UnknownText_0x16e0e
	jr .asm_16e00

.asm_16df8
	ld hl, UnknownText_0x16e13
	jr .asm_16e00

.asm_16dfd
	ld hl, UnknownText_0x16e18
.asm_16e00
	call PrintText
	ret
; 16e04

UnknownText_0x16e04: ; 0x16e04
	; Which #MON should I photo- graph?
	text_jump UnknownText_0x1be024
	db "@"
; 0x16e09

UnknownText_0x16e09: ; 0x16e09
	; All righty. Hold still for a bit.
	text_jump UnknownText_0x1be047
	db "@"
; 0x16e0e

UnknownText_0x16e0e: ; 0x16e0e
	; Presto! All done. Come again, OK?
	text_jump UnknownText_0x1be06a
	db "@"
; 0x16e13

UnknownText_0x16e13: ; 0x16e13
	; Oh, no picture? Come again, OK?
	text_jump UnknownText_0x1c0000
	db "@"
; 0x16e18

UnknownText_0x16e18: ; 0x16e18
	; An EGG? My talent is worth more<...>
	text_jump UnknownText_0x1c0021
	db "@"
; 0x16e1d

Function16e1d: ; 16e1d
	call Function16ed6 ;check compatability, ret c if yes
	ld c, $0
	jp nc, .asm_16eb7 ;ret 0 if not compatible
	ld a, [wBreedMon1Species]
	ld [CurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, $3
	ld [MonType], a
	predef GetGender
	jr c, .asm_16e70 ;if genderless, skip
	ld b, $1
	jr nz, .asm_16e48 ;if male, b = 1, else b = 2
	inc b
.asm_16e48
	push bc
	ld a, [wBreedMon2Species]
	ld [CurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, $3
	ld [MonType], a
	predef GetGender
	pop bc
	jr c, .asm_16e70
	ld a, $1
	jr nz, .asm_16e6d
	inc a
.asm_16e6d
	cp b
	jr nz, .asm_16e89 ;if genders not the same, skip
.asm_16e70
	ld c, $0
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .asm_16e82 ;if ditto, allow
	ld a, [wBreedMon2Species]
	cp DITTO
	jr nz, .asm_16eb7 ;If not ditto, reject
	jr .asm_16e89

.asm_16e82
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .asm_16eb7 ;if both ditto, reject
.asm_16e89
	call Function16ebc
	ld c, $ff
	jp z, .asm_16eb7 ;if most DV' are the same,pass FF
	ld a, [wBreedMon2Species]
	ld b, a
	ld a, [wBreedMon1Species]
	cp b
	ld c, $fe
	jr z, .asm_16e9f ;if species is the same, fe, else 80
	ld c, $80
.asm_16e9f
	ld a, [wBreedMon1ID]
	ld b, a
	ld a, [wBreedMon2ID]
	cp b
	jr nz, .asm_16eb7 
	ld a, [wBreedMon1ID + 1]
	ld b, a
	ld a, [wBreedMon2ID + 1]
	cp b
	jr nz, .asm_16eb7
	ld a, c
	sub $4d ;reduce rate if same trainer ID
	ld c, a
.asm_16eb7
	ld a, c
	ld [wd265], a
	ret
; 16ebc

Function16ebc: ; 16ebc (5:6ebc)
	ld a, [wBreedMon1DVs]
	and $f
	ld b, a
	ld a, [wBreedMon2DVs]
	and $f
	cp b
	ret nz
	ld a, [wBreedMon1DVs + 1]
	and $7
	ld b, a
	ld a, [wBreedMon2DVs + 1]
	and $7
	cp b
	ret
; 16ed6

Function16ed6: ; 16ed6 ret c if compatible
	ld a, [wBreedMon2Species]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp $ff
	jr z, .asm_16f3a ;if no egg for either mon,ret nc
	ld a, [wBreedMon1Species]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	cp $ff
	jr z, .asm_16f3a
	ld a, [wBreedMon2Species]
	cp DITTO ;If ditto, compatible
	jr z, .asm_16f3c
	ld [CurSpecies], a
	call GetBaseData
	ld a, [BaseEggGroups]
	push af ;push egg group
	and $f ;front nyble into b
	ld b, a
	pop af
	and $f0 ;back nyble into c
	swap a
	ld c, a
	ld a, [wBreedMon1Species]
	cp DITTO ;If ditto, compatible
	jr z, .asm_16f3c
	ld [CurSpecies], a
	push bc
	call GetBaseData
	pop bc
	ld a, [BaseEggGroups]
	push af
	and $f
	ld d, a
	pop af
	and $f0
	swap a
	ld e, a ;mon 1's groups are in bc, mon 2's are in de
	ld a, d
	cp b
	jr z, .asm_16f3c
	cp c
	jr z, .asm_16f3c
	ld a, e
	cp b
	jr z, .asm_16f3c
	cp c
	jr z, .asm_16f3c
.asm_16f3a
	and a
	ret

.asm_16f3c
	scf
	ret
; 16f3e

Function16f3e:: ; 16f3e
	ld de, PartySpecies
	ld hl, PartyMon1Happiness
	ld c, 0
.loop
	ld a, [de]
	inc de
	cp $ff
	ret z
	cp EGG
	jr nz, .next
	dec [hl]
	jr nz, .next
	ld a, 1
	and a
	ret

.next
	push de
	ld de, PartyMon2 - PartyMon1
	add hl, de
	pop de
	jr .loop
; 16f5e

Function16f5e:: ; 16f5e
	call ResetWindow
	call Function1d6e
	call Function16f70
	call Function2b4d
	call RestartMapMusic
	jp Function2dcf
; 16f70

Function16f70: ; 16f70 (5:6f70)
	ld de, PartySpecies
	ld hl, PartyMon1Happiness
	xor a
	ld [CurPartyMon], a
Function16f7a: ; 16f7a (5:6f7a)
	ld a, [de]
	inc de
	cp $ff
	jp z, Function1708a
	push de
	push hl
	cp EGG
	jp nz, Function1707d
	ld a, [hl]
	and a
	jp nz, Function1707d
	ld [hl], $78
	push de
	callba Function4dbb8
	callba Function10608d
	ld a, [CurPartyMon]
	ld hl, PartyMons ; wdcdf (aliases: PartyMon1, PartyMon1Species)
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hl]
	ld [CurPartySpecies], a
	dec a
	call SetSeenAndCaughtMon
	ld a, [CurPartySpecies]
	cp TOGEPI
	jr nz, .asm_16fbf
	ld de, $54
	ld b, $1
	call EventFlagAction
.asm_16fbf
	pop de
	ld a, [CurPartySpecies]
	dec de
	ld [de], a
	ld [wd265], a
	ld [CurSpecies], a
	call GetPokemonName
	xor a
	ld [wd26b], a
	call GetBaseData
	ld a, [CurPartyMon]
	ld hl, PartyMons ; wdcdf (aliases: PartyMon1, PartyMon1Species)
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	push hl
	ld bc, PartyMon1MaxHP - PartyMon1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	push hl
	ld bc, PartyMon1Level - PartyMon1
	add hl, bc
	ld a, [hl]
	ld [CurPartyLevel], a
	pop hl
	push hl
	ld bc, PartyMon1Status - PartyMon1
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	push hl
	ld bc, PartyMon1Exp + 2 - PartyMon1
	add hl, bc
	ld b, $0
	predef CalcPkmnStats
	pop bc
	ld hl, PartyMon1MaxHP - PartyMon1
	add hl, bc
	ld d, h
	ld e, l
	ld hl, PartyMon1HP - PartyMon1
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld hl, PartyMon1ID - PartyMon1
	add hl, bc
	ld a, [PlayerID]
	ld [hli], a
	ld a, [PlayerID + 1]
	ld [hl], a
	ld a, [CurPartyMon]
	ld hl, PartyMonOT ; wddff (aliases: PartyMonOT)
	ld bc, $b
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, PlayerName
	call CopyBytes
	ld hl, UnknownText_0x1708b
	call PrintText
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld a, $1
	ld [wd26b], a
	xor a
	ld [MonType], a
	push de
	ld b, $0
	callba NamingScreen
	pop hl
	ld de, StringBuffer1
	call InitName
	jr Function1707d
	ld hl, StringBuffer1
	ld bc, $b
	call CopyBytes
Function1707d: ; 1707d (5:707d)
	ld hl, CurPartyMon
	inc [hl]
	pop hl
	ld de, PartyMon2 - PartyMon1
	add hl, de
	pop de
	jp Function16f7a

Function1708a: ; 1708a (5:708a)
	ret
; 1708b (5:708b)

UnknownText_0x1708b: ; 0x1708b
	; Huh? @ @
	text_jump UnknownText_0x1c0db0
	start_asm
; 0x17090

Function17090: ; 17090
	ld hl, VramState
	res 0, [hl]
	push hl
	push de
	push bc
	ld a, [CurPartySpecies]
	push af
	call Function1728f
	ld hl, UnknownText_0x170b0
	call PrintText
	pop af
	ld [CurPartySpecies], a
	pop bc
	pop de
	pop hl
	ld hl, UnknownText_0x170b5
	ret
; 170b0 (5:70b0)

UnknownText_0x170b0: ; 0x170b0
	;
	text_jump UnknownText_0x1c0db8
	db "@"
; 0x170b5

UnknownText_0x170b5: ; 0x170b5
	; came out of its EGG!@ @
	text_jump UnknownText_0x1c0dba
	db "@"
; 0x170ba

Function170bf: ; 170bf
	call Function17197 ;ret mon whose moves to inherit from in hl and the other in de
	ld a,[wDittoInDaycare] ;set that we are on mon 1
	set 7, a
	ld [wDittoInDaycare], a
	push de ;hold other mon's move loc
	ld d, h
	ld e, l ;store in de
	ld b, NUM_MOVES ;for each move
.asm_170c6
	ld a, [de] ;place move into a
	and a
	jr z, .noMove ;if no move, done
	ld hl, wEggMonMoves
	ld c, NUM_MOVES ;for each move
.asm_170cf
	ld a, [de]
	cp [hl]
	jr z, .asm_170df ;if move matches existing move, skip
	inc hl
	dec c
	jr nz, .asm_170cf ;loop
	call Function170e4 ;ret c if move matches a move to be passed on
	jr nc, .asm_170df
	call Function17169
.asm_170df
	inc de
	dec b
	jr nz, .asm_170c6
.noMove
	ld a,[wDittoInDaycare] ;if mon 1, loop for mon 2, else done
	bit 7, a
	ret z
	res 7, a
	ld [wDittoInDaycare], a
	pop de
	ld b, NUM_MOVES
	jr .asm_170c6
; 170e4

Function170e4: ; 170e4
GLOBAL EggMoves
	push bc
	ld a, [wEggMonSpecies] ;get the location of the egg moves
	dec a
	ld c, a
	ld b, 0
	ld hl, EggMovePointers
	add hl, bc
	add hl, bc
	ld a, BANK(EggMovePointers)
	call GetFarHalfword
.asm_170f6
	ld a, BANK(EggMoves)
	call GetFarByte
	cp $ff
	jr z, .asm_17107 ;if FF, jump
	ld b, a ;else compare to the move being checked
	ld a, [de] 
	cp b
	jr z, .asm_17163 ;if a match, ret c
	inc hl ;move to next slot
	jr .asm_170f6

.asm_17107
	call Function1720b ;if mon 1 is ditto, ret hl = breedmon1 moves, else ret breedmon2
	ld a, [wDittoInDaycare]
	bit 7, a
	jp z, .asm_17166
	ld b, NUM_MOVES
.asm_1710c
	ld a, [de]
	cp [hl]
	jr z, .asm_17116 
	inc hl
	dec b
	jr z, .asm_17166
	jr .asm_1710c

.asm_17116
	ld a, [wEggMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
.asm_17127
	ld a, BANK(EvosAttacks)
	call GetFarByte2
	and a
	jr nz, .asm_17127
.asm_17130
	ld a, BANK(EvosAttacks)
	call GetFarByte
	and a
	jr z, .asm_17166
	inc hl
	ld a, BANK(EvosAttacks)
	call GetFarByte
	ld b, a
	ld a, [de]
	cp b
	jr z, .asm_17163
	inc hl
	jr .asm_17130

;.asm_17146
	;ld hl, TMHMMoves
;.asm_17149
	;ld a, BANK(TMHMMoves)
	;call GetFarByte2
	;and a
	;jr z, .asm_17166
	;ld b, a
	;ld a, [de]
	;cp b
	;jr nz, .asm_17149
	;ld [wd262], a
	;predef CanLearnTMHMMove
	;ld a, c
	;and a
	;jr z, .asm_17166
.asm_17163
	pop bc
	scf
	ret

.asm_17166
	pop bc
	and a
	ret
; 17169

Function17169: ; 17169
	push de
	push bc
	ld a, [de]
	ld b, a
	ld hl, wEggMonMoves
	ld c, NUM_MOVES
.asm_17172
	ld a, [hli]
	and a
	jr z, .asm_17187 ;if empty slot, insert
	dec c
	jr nz, .asm_17172 ;test all 4 slots
	ld de, wEggMonMoves ;if none empty, move all other moves up 1, inserting moe in last slot
	ld hl, wEggMonMoves + 1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
.asm_17187
	dec hl
	ld [hl], b
	ld hl, wEggMonMoves
	ld de, wEggMonPP
	predef FillPP
	pop bc
	pop de
	ret
; 17197

Function17197: ; 17197 ;ret mon whose moves to inherit from in hl and the other in de
	ld hl, wBreedMon2Moves
	ld de, wBreedMon1Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	jr z, .asm_171b1 ;if mon 1 is ditto, skip
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .asm_171d7 ;if mon 2 is ditto, branch
	ld a, [wDittoInDaycare] ;if ditto or mother is in slot 1, ret with mon 1, else ret with mon 2
	and a
	ret z 
	ld hl, wBreedMon1Moves
	ld de, wBreedMon2Moves
	ret

.asm_171b1
	ld a, [CurPartySpecies]
	push af ;store cur secies
	ld a, [wBreedMon2Species]
	ld [CurPartySpecies], a
	ld a, [wBreedMon2DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon2DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, $3
	ld [MonType], a
	predef GetGender ;get mon 2 gender
	jr c, .asm_171fb ;if genderless or male, ret mon 2, else ret mon 1
	jr nz, .asm_171fb
	jr .asm_17203

.asm_171d7
	ld a, [CurPartySpecies]
	push af
	ld a, [wBreedMon1Species]
	ld [CurPartySpecies], a
	ld a, [wBreedMon1DVs]
	ld [TempMonDVs], a
	ld a, [wBreedMon1DVs + 1]
	ld [TempMonDVs + 1], a
	ld a, $3
	ld [MonType], a
	predef GetGender
	jr c, .asm_17203
	jr nz, .asm_17203
.asm_171fb
	ld hl, wBreedMon2Moves
	ld de, wBreedMon1Moves
	pop af
	ld [CurPartySpecies], a
	ret

.asm_17203
	ld hl, wBreedMon1Moves
	ld de, wBreedMon2Moves
	pop af
	ld [CurPartySpecies], a
	ret
; 1720b

Function1720b: ; 1720b if mon 1 is ditto, ret hl = breedmon1 moves, else red breedmon2
	ld hl, wBreedMon1Moves
	ld a, [wBreedMon1Species]
	cp DITTO
	ret z
	ld a, [wBreedMon2Species]
	cp DITTO
	jr z, .asm_17220
	ld a, [wDittoInDaycare] ;ret mon 1 id slot 1 is mother or ditto, else ret slot 2
	and 1
	ret z
.asm_17220
	ld hl, wBreedMon2Moves
	ret
; 17224

Function17224: ; 17224 (5:7224)
	push de
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	ld hl, BattleMonDVs
	predef GetUnownLetter
	pop de
	predef_jump GetFrontpic
Function1723c: ; 1723c (5:723c)
	push de
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	ld hl, BattleMonDVs
	predef GetUnownLetter
	pop de
	predef_jump Function5108b
Function17254: ; 17254 (5:7254)
	push af
	call WaitTop
	push hl
	push bc
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	pop bc
	pop hl
	ld a, b
	ld [$ffd7], a
	ld a, c
	ld [$ffad], a
	ld bc, $707
	predef FillBox
	pop af
	call Function17363
	call Function32f9
	jp WaitBGMap

Function1727f: ; 1727f (5:727f)
	push hl
	push de
	push bc
	callab Function8cf69
	call DelayFrame
	pop bc
	pop de
	pop hl
	ret

Function1728f: ; 1728f (5:728f)
	ld a, [wd265]
	ld [wcf63], a
	ld a, [CurSpecies]
	push af
	ld de, MUSIC_NONE
	call PlayMusic
	callba Function8000
	call DisableLCD
	ld hl, EggHatchGFX
	ld de, $8000
	ld bc, $20
	ld a, BANK(EggHatchGFX)
	call FarCopyBytes
	callba Function8cf53
	ld de, $9000
	ld a, [wcf63]
	call Function1723c
	ld de, $9310
	ld a, EGG
	call Function17224
	ld de, MUSIC_EVOLUTION
	call PlayMusic
	call EnableLCD
	hlcoord 7, 4
	ld b, $98
	ld c, $31
	ld a, EGG
	call Function17254
	ld c, $50
	call DelayFrames
	xor a
	ld [wcf64], a
	ld a, [hSCX] ; $ff00+$cf
	ld b, a
.asm_172ee
	ld hl, wcf64
	ld a, [hl]
	inc [hl]
	cp $8
	jr nc, .asm_17327
	ld e, [hl]
.asm_172f8
	ld a, $2
	ld [hSCX], a ; $ff00+$cf
	ld a, $fe
	ld [wc3c0], a
	call Function1727f
	ld c, $2
	call DelayFrames
	ld a, $fe
	ld [hSCX], a ; $ff00+$cf
	ld a, $2
	ld [wc3c0], a
	call Function1727f
	ld c, $2
	call DelayFrames
	dec e
	jr nz, .asm_172f8
	ld c, $10
	call DelayFrames
	call Function1736d
	jr .asm_172ee

.asm_17327
	ld de, SFX_EGG_HATCH
	call PlaySFX
	xor a
	ld [hSCX], a ; $ff00+$cf
	ld [wc3c0], a
	call ClearSprites
	call Function173b3
	hlcoord 6, 3
	ld b, $98
	ld c, $0
	ld a, [wcf63]
	call Function17254
	call Function17418
	call WaitSFX
	ld a, [wcf63]
	ld [CurPartySpecies], a
	hlcoord 6, 3
	ld d, $0
	ld e, $5
	predef Functiond008e
	pop af
	ld [CurSpecies], a
	ret

Function17363: ; 17363 (5:7363)
	ld [PlayerHPPal], a
	ld b, $b
	ld c, $0
	jp GetSGBLayout

Function1736d: ; 1736d (5:736d)
	ld a, [wcf64]
	dec a
	and $7
	cp $7
	ret z
	srl a
	ret nc
	swap a
	srl a
	add $4c
	ld d, a
	ld e, $58
	ld a, $19
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $0
	ld de, SFX_EGG_CRACK
	jp PlaySFX
; 17393 (5:7393)

EggHatchGFX: ; 17393
INCBIN "gfx/unknown/017393.2bpp"
; 173b3

Function173b3: ; 173b3 (5:73b3)
	callba Function8cf53
	ld hl, Unknown_173ef
.asm_173bc
	ld a, [hli]
	cp $ff
	jr z, .asm_173e5
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	push bc
	ld a, $1c
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $0
	pop de
	ld a, e
	ld hl, $1
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $b
	add hl, bc
	ld [hl], d
	pop hl
	jr .asm_173bc

.asm_173e5
	ld de, SFX_EGG_HATCH
	call PlaySFX
	call Function1727f
	ret
; 173ef (5:73ef)

Unknown_173ef: ; 173ef
; Probably OAM.

	db $54, $48, $00, $3c
	db $5c, $48, $01, $04
	db $54, $50, $00, $30
	db $5c, $50, $01, $10
	db $54, $58, $02, $24
	db $5c, $58, $03, $1c
	db $50, $4c, $00, $36
	db $60, $4c, $01, $0a
	db $50, $54, $02, $2a
	db $60, $54, $03, $16
	db $ff
; 17418

Function17418: ; 17418 (5:7418)
	ld c, $81
.asm_1741a
	call Function1727f
	dec c
	jr nz, .asm_1741a
	ret

Function17421: ; 17421
	ld hl, UnknownText_0x17467
	call PrintText
	ld a, [wBreedMon1Species]
	call PlayCry
	ld a, [wDaycareLady]
	bit 0, a
	jr z, Function1745f
	call Functionaaf
	ld hl, wBreedMon2Nick
	call Function1746c
	jp PrintText

Function17440: ; 17440
	ld hl, UnknownText_0x17462
	call PrintText
	ld a, [wBreedMon2Species]
	call PlayCry
	ld a, [wDaycareMan]
	bit 0, a
	jr z, Function1745f
	call Functionaaf
	ld hl, wBreedMon1Nick
	call Function1746c
	jp PrintText

Function1745f: ; 1745f
	jp Functiona80
; 17462

UnknownText_0x17462: ; 0x17462
	; It's @ that was left with the DAY-CARE LADY.
	text_jump UnknownText_0x1c0df3
	db "@"
; 0x17467

UnknownText_0x17467: ; 0x17467
	; It's @ that was left with the DAY-CARE MAN.
	text_jump UnknownText_0x1c0e24
	db "@"
; 0x1746c

Function1746c: ; 1746c
	push bc
	ld de, StringBuffer1
	ld bc, $000b
	call CopyBytes
	call Function16e1d
	pop bc
	ld a, [wd265]
	ld hl, UnknownText_0x1749c
	cp $ff
	jr z, .asm_1749b
	ld hl, UnknownText_0x174a1
	and a
	jr z, .asm_1749b
	ld hl, UnknownText_0x174a6
	cp 230
	jr nc, .asm_1749b
	cp 70
	ld hl, UnknownText_0x174ab
	jr nc, .asm_1749b
	ld hl, UnknownText_0x174b0
.asm_1749b
	ret
; 1749c

UnknownText_0x1749c: ; 0x1749c
	; It's brimming with energy.
	text_jump UnknownText_0x1c0e54
	db "@"
; 0x174a1

UnknownText_0x174a1: ; 0x174a1
	; It has no interest in @ .
	text_jump UnknownText_0x1c0e6f
	db "@"
; 0x174a6

UnknownText_0x174a6: ; 0x174a6
	; It appears to care for @ .
	text_jump UnknownText_0x1c0e8d
	db "@"
; 0x174ab

UnknownText_0x174ab: ; 0x174ab
	; It's friendly with @ .
	text_jump UnknownText_0x1c0eac
	db "@"
; 0x174b0

UnknownText_0x174b0: ; 0x174b0
	; It shows interest in @ .
	text_jump UnknownText_0x1c0ec6
	db "@"
; 0x174b5

Function_174b5: ; 174b5
	ld hl, String_174b9
	ret
; 174b9

String_174b9: ; 174b9
	db "@"
; 174ba

SECTION "Tileset Data 1", ROMX, BANK[TILESETS_1]

INCLUDE "tilesets/data_1.asm"

SECTION "Roofs", ROMX, BANK[ROOFS]

INCLUDE "tilesets/roofs.asm"

SECTION "Tileset Data 2", ROMX, BANK[TILESETS_2]

INCLUDE "tilesets/data_2.asm"

SECTION "bank8", ROMX, BANK[$8]

Function20000: ; 20000 (8:4000)
	push hl
	dec a
	ld e, a
	ld d, 0
	ld a, [Options2]
	bit 2, a
	ld hl, Unknown_20015
	jr z, .h24
	ld hl, Unknown_20015_2
.h24
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	pop hl
	ret
; 20015 (8:4015)

Unknown_20015: ; 20015
	dw wd1ed
	db $07, $04
	dw wd1ee
	db $18, $0f
	dw wd1ef
	db $3c, $12
; 20021

Unknown_20015_2: ; 20015
	dw wd1ed
	db $07, $04
	dw wd1ee
	db $18, $0c
	dw wd1ef
	db $3c, $0f
; 20021

Function20021: ; 20021 (8:4021)
	ld hl, UnknownText_0x20047
	call PrintText
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function1d6e
	call ClearTileMap
	ld hl, UnknownText_0x2004c
	call PrintText
	call Function20051
	call Function1c07 ;unload top menu on menu stack
	pop bc
	ld hl, Options
	ld [hl], b
	ld c, a
	ret
; 20047 (8:4047)

UnknownText_0x20047: ; 0x20047
	; The clock's time may be wrong. Please reset the time.
	text_jump UnknownText_0x1c40e6
	db "@"
; 0x2004c

UnknownText_0x2004c: ; 0x2004c
	; Set with the Control Pad. Confirm: A Button Cancel:  B Button
	text_jump UnknownText_0x1c411c
	db "@"
; 0x20051

Function20051: ; 20051 (8:4051)
	ld a, $1
	ld [Buffer1], a ; wd1ea (aliases: MagikarpLength)
	ld [Buffer2], a ; wd1eb (aliases: MovementType)
	ld a, $8
	ld [wd1ec], a
	call UpdateTime
	call GetWeekday
	ld [wd1ed], a
	ld a, [hHours] ; $ff00+$94
	ld [wd1ee], a
	ld a, [hMinutes] ; $ff00+$96
	ld [wd1ef], a
.asm_20071
	call Function200ba
	jr nc, .asm_20071
	and a
	ret nz
	call Function2011f
	ld hl, UnknownText_0x200b0
	call PrintText
	call YesNoBox
	jr c, .asm_200ad
	ld a, [wd1ed]
	ld [StringBuffer2], a
	ld a, [wd1ee]
	ld [StringBuffer2 + 1], a
	ld a, [wd1ef]
	ld [StringBuffer2 + 2], a
	xor a
	ld [StringBuffer2 + 3], a
	call Function677
	call Function2011f
	ld hl, UnknownText_0x200b5
	call PrintText
	call Functiona80
	xor a
	ret

.asm_200ad
	ld a, $1
	ret
; 200b0 (8:40b0)

UnknownText_0x200b0: ; 0x200b0
	; Is this OK?
	text_jump UnknownText_0x1c415b
	db "@"
; 0x200b5

UnknownText_0x200b5: ; 0x200b5
	; The clock has been reset.
	text_jump UnknownText_0x1c4168
	db "@"
; 0x200ba

Function200ba: ; 200ba (8:40ba)
	call Function354b
	ld c, a
	push af
	call Function2011f
	pop af
	bit 0, a
	jr nz, .asm_200dd
	bit 1, a
	jr nz, .asm_200e1
	bit 6, a
	jr nz, .asm_200e5
	bit 7, a
	jr nz, .asm_200f6
	bit 5, a
	jr nz, .asm_20108
	bit 4, a
	jr nz, .asm_20112
	jr Function200ba

.asm_200dd
	ld a, $0
	scf
	ret

.asm_200e1
	ld a, $1
	scf
	ret

.asm_200e5
	ld a, [Buffer1] ; wd1ea (aliases: MagikarpLength)
	call Function20000
	ld a, [de]
	inc a
	ld [de], a
	cp b
	jr c, .asm_2011d
	ld a, $0
	ld [de], a
	jr .asm_2011d

.asm_200f6
	ld a, [Buffer1] ; wd1ea (aliases: MagikarpLength)
	call Function20000
	ld a, [de]
	dec a
	ld [de], a
	cp $ff
	jr nz, .asm_2011d
	ld a, b
	dec a
	ld [de], a
	jr .asm_2011d

.asm_20108
	ld hl, Buffer1 ; wd1ea (aliases: MagikarpLength)
	dec [hl]
	jr nz, .asm_2011d
	ld [hl], $3
	jr .asm_2011d

.asm_20112
	ld hl, Buffer1 ; wd1ea (aliases: MagikarpLength)
	inc [hl]
	ld a, [hl]
	cp $4
	jr c, .asm_2011d
	ld [hl], $1
.asm_2011d
	xor a
	ret

Function2011f: ; 2011f (8:411f)
	hlcoord 0, 5
	ld b, $5
	ld c, $12
	call TextBox
	decoord 1, 8
	ld a, [wd1ed]
	ld b, a
	callba Function5b05
	ld a, [wd1ee]
	ld b, a
	ld a, [wd1ef]
	ld c, a
	ld a, [Options2]
	bit 2, a
	decoord 14, 8
	jr z, .h24
	decoord 11, 8
.h24
	callba Function1dd6bb
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	lb de, $7f, $7f
	call Function20168
	ld a, [Buffer1] ; wd1ea (aliases: MagikarpLength)
	lb de, $61, $ee
	call Function20168
	ld a, [Buffer1] ; wd1ea (aliases: MagikarpLength)
	ld [Buffer2], a ; wd1eb (aliases: MovementType)
	ret
; 20160 (8:4160)

Function20160: ; 20160
	ld a, [wd1ec]
	ld b, a
	call GetTileCoord
	ret
; 20168

Function20168: ; 20168 (8:4168)
	push de
	call Function20000
	ld a, [wd1ec]
	dec a
	ld b, a
	call GetTileCoord
	pop de
	ld [hl], d
	ld bc, $28
	add hl, bc
	ld [hl], e
	ret
; 2017c (8:417c)

String_2017c: ; 2017c
	db "じ@" ; HR
; 2017e

String_2017e: ; 2017e
	db "ふん@" ; MIN
; 20181

SECTION "Tileset Data 3", ROMX, BANK[TILESETS_3]

INCLUDE "tilesets/data_3.asm"

SECTION "bank9", ROMX, BANK[$9]

Unknown_24000:: ; 24000
	dw StringBuffer3
	dw StringBuffer4
	dw StringBuffer5
	dw StringBuffer2
	dw StringBuffer1
	dw EnemyMonNick
	dw BattleMonNick
; 2400e

Function2400e:: ; 2400e
	ld hl, Function1c66
	ld a, [wcf94]
	rst FarCall
	call Function24085
	call Function1ad2
	call Function321c
	call Function2408f
	ret
; 24022

Function24022:: ; 24022
	ld hl, Function1c66
	ld a, [wcf94]
	rst FarCall
	call Function24085
	;callba MobileTextBorder
	call Function1ad2
	call Function321c
	call Function2408f
	ret
; 2403c

Function2403c:: ; 2403c
	ld hl, Function1c66
	ld a, [wcf94]
	rst FarCall
	call Function24085
	;callba MobileTextBorder
	call Function1ad2
	call Function321c
	call Function2411a
	ld hl, wcfa5
	set 7, [hl]
.asm_2405a
	call DelayFrame
	callba Function10032e
	ld a, [wcd2b]
	and a
	jr nz, .asm_24076
	call Function241ba
	ld a, [wcfa8]
	and c
	jr z, .asm_2405a
	call Function24098
	ret

.asm_24076
	ld a, [wcfa4]
	ld c, a
	ld a, [wcfa3]
	call SimpleMultiply
	ld [wcf88], a
	and a
	ret
; 24085

Function24085: ; 24085
	xor a
	ld [hBGMapMode], a
	call Function1cbb ;put a textbox in menu area
	call Function240db
	ret
; 2408f

Function2408f: ; 2408f
	call Function2411a
	call Function1bc9
	call Function1ff8 ;if a or b pressed and start diabled, play sound

Function24098: ; 24098
	ld a, [wcf91]
	bit 1, a
	jr z, .asm_240a6
	call Function1bdd
	bit 2, a
	jr nz, .asm_240c9
.asm_240a6
	ld a, [wcf91]
	bit 0, a
	jr nz, .asm_240b4
	call Function1bdd
	bit 1, a
	jr nz, .asm_240cb
.asm_240b4
	ld a, [wcfa4]
	ld c, a
	ld a, [wcfa9]
	dec a
	call SimpleMultiply
	ld c, a
	ld a, [wcfaa]
	add c
	ld [wcf88], a
	and a
	ret

.asm_240c9
	scf
	ret

.asm_240cb
	scf
	ret
; 240cd

Function240cd: ; 240cd
	ld a, [wcf92]
	and $f
	ret
; 240d3

Function240d3: ; 240d3
	ld a, [wcf92]
	swap a
	and $f
	ret
; 240db

Function240db: ; 240db
	ld hl, wcf95
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Function1cc6
	call GetTileCoord
	call Function240d3
	ld b, a
.asm_240eb
	push bc
	push hl
	call Function240cd
	ld c, a
.asm_240f1
	push bc
	ld a, [wcf94]
	call Function201c
	inc de
	ld a, [wcf93]
	ld c, a
	ld b, $0
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_240f1
	pop hl
	ld bc, $0028
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_240eb
	ld hl, wcf98
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, [wcf97]
	rst FarCall
	ret
; 2411a

Function2411a: ; 2411a (9:411a)
	call Function1cc6
	ld a, b
	ld [wcfa1], a
	dec c
	ld a, c
	ld [wcfa2], a
	call Function240d3
	ld [wcfa3], a
	call Function240cd
	ld [wcfa4], a
	call Function24179
	call Function2418a
	call Function24193
	ld a, [wcfa4]
	ld e, a
	ld a, [wcf88]
	ld b, a
	xor a
	ld d, $0
.asm_24146
	inc d
	add e
	cp b
	jr c, .asm_24146
	sub e
	ld c, a
	ld a, b
	sub c
	and a
	jr z, .asm_24157
	cp e
	jr z, .asm_24159
	jr c, .asm_24159
.asm_24157
	ld a, $1
.asm_24159
	ld [wcfaa], a
	ld a, [wcfa3]
	ld e, a
	ld a, d
	and a
	jr z, .asm_24169
	cp e
	jr z, .asm_2416b
	jr c, .asm_2416b
.asm_24169
	ld a, $1
.asm_2416b
	ld [wcfa9], a
	xor a
	ld [wcfab], a
	ld [wcfac], a
	ld [wcfad], a
	ret
; 24179

Function24179: ; 24179
	xor a
	ld hl, wcfa5
	ld [hli], a
	ld [hld], a
	ld a, [wcf91]
	bit 5, a
	ret z
	set 5, [hl]
	set 4, [hl]
	ret
; 2418a

Function2418a: ; 2418a
	ld a, [wcf93]
	or $20
	ld [wcfa7], a
	ret
; 24193

Function24193: ; 24193
	ld hl, wcf91
	ld a, $1
	bit 0, [hl]
	jr nz, .asm_2419e
	or $2
.asm_2419e
	bit 1, [hl]
	jr z, .asm_241a4
	or $4
.asm_241a4
	ld [wcfa8], a
	ret
; 241a8

Function241a8:: ; 241a8 ;place and update cursor, loop valid input is pressed
	call Function24329 ;Place cursor in tilemap
Function241ab:: ; 241ab
	ld hl, wcfa6 ;reset bit 7 of ???
	res 7, [hl]
	ld a, [hBGMapMode]
	push af
	call Function24216 ;update cursor, loop until valid input (depending on wcfa8)
	pop af
	ld [hBGMapMode], a
	ret
; 241ba

Function241ba: ; 241ba
	ld hl, wcfa6
	res 7, [hl]
	ld a, [hBGMapMode]
	push af
	call Function2431a
	call Function24249
	jr nc, .asm_241cd
	call Function24270
.asm_241cd
	pop af
	ld [hBGMapMode], a
	call Function1bdd
	ld c, a
	ret
; 241d5

Function241d5: ; 241d5
	call Function24329 ;Place cursor in tilemap
.asm_241d8
	call Function2431a
	callba Function10402d ; BUG: This function is in another bank.
	call Function241fa
	jr nc, .asm_241f9
	call Function24270
	jr c, .asm_241f9
	ld a, [wcfa5]
	bit 7, a
	jr nz, .asm_241f9
	call Function1bdd
	ld c, a
	ld a, [wcfa8]
	and c
	jr z, .asm_241d8
.asm_241f9
	ret
; 241fa

Function241fa: ; 241fa
.asm_241fa
	call Function24259
	ret c
	ld c, $1
	ld b, $3
	callba Function10062d ; BUG: This function is in another bank.
	ret c
	callba Function100337
	ret c
	ld a, [wcfa5]
	bit 7, a
	jr z, .asm_241fa
	and a
	ret
; 24216

Function24216: ; 24216 update cursor, loop until valid input (depending on wcfa8) and return those buttons in a
.asm_24216
	call Function2431a ;refresh cursor location
	call Function24238 ;??? (refresh screen?)
	call Function24249 ;update joypad, possibly busyloop to wait. ret c if anything pressed in a, ret nc otherwise
	ret nc; jr nc, .asm_24237 saves a jump, ret if nothing pressed
	call Function24270 ;process direction buttons, a = 0
	jr c, .asm_24237 ;impossible? (no possibility returns carry)
	ld a, [wcfa5] ;if bit 7 of ?? is on, quit without looping
	bit 7, a
	ret nz	;jr nz, .asm_24237
	call Function1bdd ;upate joypad
	ld b, a
	ld a, [wcfa8] ;load allowed buttons
	and b
	jr z, .asm_24216 ;loop until either allowed button is pressed
.asm_24237
	ret
; 24238

Function24238: ; 24238
	ld a, [hOAMUpdate] ;load ??
	push af
	ld a, $1
	ld [hOAMUpdate], a ;place 1 in ???
	call WaitBGMap
	pop af
	ld [hOAMUpdate], a
	xor a
	ld [hBGMapMode], a
	ret
; 24249

Function24249: ; 24249 ;update joypad, possibly busyloop to wait. ret c if anything pressed in a, ret nc otherwise
.asm_24249
	call RTC ;update time
	call Function24259 ; update joypad,ret c if anything pressed in joylast
	ret c ;ret if buttons pressed
	ld a, [wcfa5]
	bit 7, a
	jr z, .asm_24249 ;try again is bit 7 is on and nothing is pressed
	and a
	ret
; 24259

Function24259: ; 24259 update joypad,ret c if anything pressed in joylast
	ld a, [wcfa5] ;a = ??
	bit 6, a ;if bit 4 of tile backup was on?
	jr z, .asm_24266 ;skip
	callab Function8cf62 ;something sprite related
.asm_24266
	call Functiona57 ;update joypad
	call Function1bdd ;1bdd a = back nyble of JoyLast and front nyble of joy pressed
	and a
	ret z ;if anything pressed,  ret c
	scf
	ret
; 24270

Function24270: ; 24270 process direction buttons, a = 0
	call Function1bdd ;a = back nyble of JoyLast and front nyble of joy pressed
	bit 0, a
	jp nz, Function24318 ;ret a = 0
	bit 1, a
	jp nz, Function24318
	bit 2, a
	jp nz, Function24318
	bit 3, a
	jp nz, Function24318
	bit 4, a
	jr nz, .asm_242fa ;if right, increment horizotal cursor positon if possible
	bit 5, a
	jr nz, .asm_242dc ; if left, dec horizontal position of cursor
	bit 6, a
	jr nz, .asm_242be ;if up, dec vertical cursor position
	bit 7, a
	jr nz, .asm_242a0
	and a ;if nothing pressed, a = 0 and ret
	ret

.asm_24299: ; 24299
	ld hl, wcfa6
	set 7, [hl]
	scf
	ret

.asm_242a0
	ld hl, wcfa9
	ld a, [wcfa3]
	cp [hl]
	jr z, .asm_242ac
	inc [hl]
	xor a
	ret

.asm_242ac
	ld a, [wcfa5]
	bit 5, a
	jr nz, .asm_242ba
	bit 3, a
	jp nz, .asm_24299
	xor a
	ret

.asm_242ba
	ld [hl], $1
	xor a
	ret

.asm_242be ;dec vertical cursor position
	ld hl, wcfa9
	ld a, [hl]
	dec a
	jr z, .asm_242c8
	ld [hl], a
	xor a
	ret

.asm_242c8
	ld a, [wcfa5]
	bit 5, a
	jr nz, .asm_242d6
	bit 2, a
	jp nz, .asm_24299
	xor a
	ret

.asm_242d6
	ld a, [wcfa3]
	ld [hl], a
	xor a
	ret

.asm_242dc ;dec horizontal position of cursor
	ld hl, wcfaa
	ld a, [hl]
	dec a
	jr z, .asm_242e6
	ld [hl], a
	xor a
	ret

.asm_242e6
	ld a, [wcfa5]
	bit 4, a
	jr nz, .asm_242f4
	bit 1, a
	jp nz, .asm_24299
	xor a
	ret

.asm_242f4
	ld a, [wcfa4]
	ld [hl], a
	xor a
	ret

.asm_242fa ;if right is pressed
	ld hl, wcfaa
	ld a, [wcfa4] ;(1)??
	cp [hl] ;if horizontal cursor position is not equal to ??(max horizontal position?) inc it
	jr z, .asm_24306
	inc [hl]
	xor a
	ret

.asm_24306
	ld a, [wcfa5]
	bit 4, a
	jr nz, .asm_24314
	bit 0, a
	jp nz, .asm_24299
	xor a
	ret

.asm_24314
	ld [hl], $1
	xor a
	ret
; 24318

Function24318: ; 24318
	xor a
	ret
; 2431a

Function2431a: ; 2431a refresh cursor location
	ld hl, wcfac ;load cursor location
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ;load contents into a
	cp $ed ;if cursor, load what it covered up in it's place. regardless, place new cursor
	jr nz, Function24329
	ld a, [wcfab]
	ld [hl], a
Function24329: ; 24329 Place cursor in tilemap
	ld a, [wcfa1] ;load start coords +1/2
	ld b, a
	ld a, [wcfa2]
	ld c, a
	call GetTileCoord ;get that location in tilemap
	ld a, [wcfa7] ;
	swap a
	and $f ;load space between rows
	ld c, a
	ld a, [wcfa9] ;load cursor location
	ld b, a
	xor a
	dec b
	jr z, .asm_24348 ;a = c*(cursor -1)
.asm_24344
	add c
	dec b
	jr nz, .asm_24344
.asm_24348
	ld c, $14
	call AddNTimes ;add number of rows to go down
	ld a, [wcfa7]
	and $f ;load colomns difference into c
	ld c, a
	ld a, [wcfaa] ;horizontal cursor position?
	ld b, a
	xor a
	dec b
	jr z, .asm_2435f ; c = colomns difference * (cursor selection -1)
.asm_2435b
	add c
	dec b
	jr nz, .asm_2435b
.asm_2435f
	ld c, a
	add hl, bc ;add horizontal distance
	ld a, [hl] ;load contents
	cp $ed ;if already the cursor, skip
	jr z, .asm_2436b
	ld [wcfab], a ;load what's behind the cursor spot into a var
	ld [hl], $ed ;load in the cursor
.asm_2436b
	ld a, l
	ld [wcfac], a
	ld a, h
	ld [wcfad], a
	ret
; 24374

Function24374:: ; 24374 ;load current tile backup onto backup stack
	ld a, [rSVBK]
	push af
	ld a, $7
	ld [rSVBK], a
	ld hl, wcf71 ;load previous menu in stack into de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de ;holds previous menu in stack
	ld b, $10
	ld hl, wcf81 ;curmenudata
.asm_24387
	ld a, [hli]
	ld [de], a
	dec de ;load menu header into de backwards
	dec b
	jr nz, .asm_24387
	ld a, [wcf81] ;load first menu header tile backup into a
	bit 6, a
	jr nz, .asm_24398 ;if bit 6 is on or bit 7 is, load current tile data onto previous menu stack. set top of previous stack bit 0(?)
	bit 7, a
	jr z, .asm_243ae ;if bit 6 is off and bit 7 is off, skip. reset top of previous stack bit 0(?)
.asm_24398
	ld hl, wcf71 ;load the pointer
	ld a, [hli] ; put the location there into hl
	ld h, [hl]
	ld l, a
	set 0, [hl] ;set that bit 0 to 1
	call Function1cfd ;hl = curmenu start location in tilemap
	call Function243cd ;put tilemap to be taken up by menu into de (backwards)
	call Function1d19 ;same as 1cfd but for AttrMap
	call Function243cd
	jr .asm_243b5

.asm_243ae
	pop hl
	push hl ;holds previous entry top byte
	ld a, [hld]
	ld l, [hl]
	ld h, a ;put it in hl
	res 0, [hl] ;reset it's bit 0
.asm_243b5
	pop hl ;holds previous entry top byte
	; call Function243e7 immediatly rets
	ld a, h
	ld [de], a ;load that pointer in de
	dec de
	ld a, l
	ld [de], a
	dec de
	ld hl, wcf71 ;load the "top" of the new entry tile data into wcf71,
	ld [hl], e
	inc hl
	ld [hl], d
	pop af
	ld [rSVBK], a
	ld hl, wcf78
	inc [hl]
	ret
; 243cd

Function243cd: ; 243cd ;move the current data in the area covered by the curmenu from grid hl into de backwards
	call Function1c53 ;sub 1 set of menu coords from another, leave result in bc
	inc b
	inc c
	;call Function243e7 immediatly rets
.asm_243d5
	push bc
	push hl
.asm_243d7
	ld a, [hli] ;move something from HL to grid DE, filling a space in
	ld [de], a
	dec de
	dec c
	jr nz, .asm_243d7
	pop hl
	ld bc, $0014 ;go to new line
	add hl, bc
	pop bc ;b, the other coord, is loop counter
	dec b
	jr nz, .asm_243d5
	ret
; 243e7

Function243e7: ; 243e7
	ret
; 243e8

Function243e8:: ; 243e8 unload top menu on the stack
	xor a
	ld [hBGMapMode], a ;reset BG map mode
	ld a, [rSVBK]
	push af
	ld a, $7
	ld [rSVBK], a ;switch to wram bank 7
	call Function1c7e ;load top bit of the second highest menu in menu stack
	ld a, l
	or h
	jp z, Function2445d ;if zero, error message
	ld a, l
	ld [wcf71], a ;load hl into wcf71
	ld a, h
	ld [wcf72], a
	call Function1c47 ;load the menu data of the highest thing in menu stack into curmenu
	ld a, [wcf81]
	bit 0, a ;if tiles were loaded in, unload them
	jr z, .asm_24411
	ld d, h
	ld e, l
	call Function1c23 ;fill tilemap and attrimap with menu data from hl using loaded menu data's coords
.asm_24411
	call Function1c7e ;load contents of ((the contents of wcf71) +1) into hl
	ld a, h
	or l
	jr z, .asm_2441b ;skip if zero
	call Function1c47 ;load the menu stored above hl(in reverse) into RAM
.asm_2441b
	pop af
	ld [rSVBK], a
	ld hl, wcf78
	dec [hl]
	ret
; 24423

Function24423: ; 24423
	ld a, [VramState]
	bit 0, a
	ret z
	xor a
	call GetSRAMBank
	hlcoord 0, 0
	ld de, $a000
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyBytes
	call CloseSRAM
	call Function2173
	xor a
	call GetSRAMBank
	ld hl, $a000
	ld de, TileMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
.asm_2444c
	ld a, [hl]
	cp $61
	jr c, .asm_24452
	ld [de], a
.asm_24452
	inc hl
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .asm_2444c
	call CloseSRAM
	ret
; 2445d

Function2445d: ; 2445d
	ld hl, UnknownText_0x24468 ;error message
	call PrintText
	call WaitBGMap
.asm_24466
	jr .asm_24466 ;busywait?
; 24468

UnknownText_0x24468: ; 24468
	text_jump UnknownText_0x1c46b7
	db "@"
; 2446d

Function2446d:: ; 2446d fill rest of menu data?
	ld a, [wcf91] ;load vtiles byte 1 into b
	ld b, a
	ld hl, wcfa1
	ld a, [wcf82] ;load cur menu start x coord
	inc a
	bit 6, b ;if bit 6 of b = is off, inc a by 2, else by 1
	jr nz, .asm_2447d
	inc a
.asm_2447d
	ld [hli], a ;put curmenu start corrds +1/2 into wcfa1 and wcfa2
	ld a, [wcf83]
	inc a
	ld [hli], a
	ld a, [wcf92] ;load ?? into max cursor position
	ld [hli], a
	ld a, $1
	ld [hli], a ;load 1 into wcfa4 and 0 into wcfa5
	ld [hl], $0
	bit 5, b ;if bit 5 of b is on, set bit 5 of wcfa5
	jr z, .asm_24492
	set 5, [hl]
.asm_24492
	ld a, [wcf81]
	bit 4, a ;if bit 4 of cur menu tile backup is on, set bit 6 of wcfa5
	jr z, .asm_2449b
	set 6, [hl]
.asm_2449b
	inc hl
	xor a
	ld [hli], a ;wcfa6 = 0
	ld a, $20
	ld [hli], a ;wcfa7 = 32
	ld a, $1
	bit 0, b
	jr nz, .asm_244a9 ;if bit 0 of b is on,exit on a only, else  exit on a or b. load it into wcfa8
	add $2
.asm_244a9
	ld [hli], a
	ld a, [wcf88]
	and a
	jr z, .asm_244b7 ;if default option is 0 or is more then wcf92, then c = default option, else c = 1
	ld c, a
	ld a, [wcf92]
	cp c
	jr nc, .asm_244b9
.asm_244b7
	ld c, $1
.asm_244b9
	ld [hl], c ;load c into wcfa9 (cur menu selection?/vertical cursor)
	inc hl
	ld a, $1
	ld [hli], a ;load 1 into horizontal cursor position?, 0 into "whats behind cursor" and cursor location
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret
; 244c3

Function244c3: ; 0x244c3
	ld a, [MenuSelection]
	ld [CurSpecies], a
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld a, [MenuSelection]
	cp $ff
	ret z
	decoord 1, 14
	callba PrintItemDescription
	ret
; 0x244e3

Function244e3:: ; 244e3
	ld hl, MenuDataHeader_0x24547
	call Function1d3c
	call Function1cbb ;put a textbox in menu area
	call Function1ad2
	call Function321c
	ld b, $12
	call GetSGBLayout
	xor a
	ld [hBGMapMode], a
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld de, VTiles1
	predef GetFrontpic
	ld a, [wcf82]
	inc a
	ld b, a
	ld a, [wcf83]
	inc a
	ld c, a
	call GetTileCoord
	ld a, $80
	ld [$ffad], a
	ld bc, $0707
	predef FillBox
	call WaitBGMap
	ret
; 24528

FossilPic:: ; 244e3
	push bc
	ld hl, MenuDataHeader_0x24547
	call Function1d3c
	call Function1cbb ;put a textbox in menu area
	call Function1ad2
	call Function321c
	ld b, $1f
	call GetSGBLayout
	xor a
	ld [hBGMapMode], a
	ld de, VTiles1
	pop bc
	callba GetFossilPic
	ld a, [wcf82]
	inc a
	ld b, a
	ld a, [wcf83]
	inc a
	ld c, a
	call GetTileCoord
	ld a, $80
	ld de, $14
	ld b, 7
.loop
	ld c, 7
	push hl
.loop2
	ld [hli], a
	inc a
	dec c
	jr nz, .loop2
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	call WaitBGMap
	ret
; 24528

Function24528:: ; 24528
	ld hl, MenuDataHeader_0x24547
	call Function1d3c
	call Function1ce1
	call WaitBGMap
	call ClearSGB
	xor a
	ld [hBGMapMode], a
	call Function2173
	call Function321c
	call Function1ad2
	call Functione51
	ret
; 24547

MenuDataHeader_0x24547: ; 0x24547
	db $40 ; flags
	db 04, 06 ; start coords
	db 13, 14 ; end coords
	dw NULL
	db 1 ; default option
; 0x2454f

Function2454f: ; 2454f
	ld hl, wd81e
	xor a
	ld bc, $10
	call ByteFill
	nop
	ld bc, MapObjects
	ld de, wd81e
	xor a
.asm_24561
	push af
	push bc
	push de
	call Function245a7
	jr c, .asm_2456c
	call Function2457d
.asm_2456c
	pop de
	ld [de], a
	inc de
	pop bc
	ld hl, $10
	add hl, bc
	ld b, h
	ld c, l
	pop af
	inc a
	cp $10
	jr nz, .asm_24561
	ret

Function2457d: ; 2457d (9:457d)
	ld hl, $1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_245a3
	ld hl, $c
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	cp $ff
	jr nz, .asm_24598
	ld a, e
	cp $ff
	jr z, .asm_245a1
	jr .asm_245a3

.asm_24598
	ld b, $2
	call EventFlagAction
	ld a, c
	and a
	jr nz, .asm_245a3
.asm_245a1
	xor a
	ret

.asm_245a3
	ld a, $ff
	scf
	ret

Function245a7: ; 245a7 (9:45a7)
	call Function18f5
	ld a, $ff
	ret c
	xor a
	ret

Function245af:: ; 245af
	xor a
	ld [wcf73], a
	ld [hBGMapMode], a
	inc a
	ld [$ffaa], a
	call Function2471a
	call Function24764
	call Function247dd
	call Function245f1
	call Function321c
	xor a
	ld [hBGMapMode], a
	ret
; 245cb

Function245cb:: ; 245cb
.asm_245cb
	call Function24609
	jp c, Function245d6
	call z, Function245e1
	jr .asm_245cb
; 245d6

Function245d6: ; 245d6
	call Function1ff8
	ld [wcf73], a
	ld a, $0
	ld [$ffaa], a
	ret
; 245e1

Function245e1: ; 245e1
	call Function245f1
	ld a, $1
	ld [hBGMapMode], a
	ld c, $3
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	ret
; 245f1

Function245f1: ; 245f1
	xor a
	ld [hBGMapMode], a
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function247f0
	call Function2488b
	call Function248b8
	pop af
	ld [Options], a
	ret
; 24609

Function24609: ; 24609
.asm_24609
	call Function1bd3
	ld a, [$ffa9]
	and $f0
	ld b, a
	ld a, [hJoyPressed]
	and $f
	or b
	bit 0, a
	jp nz, Function24644
	bit 1, a
	jp nz, Function2466f
	bit 2, a
	jp nz, Function24673
	bit 3, a
	jp nz, Function24695
	bit 4, a
	jp nz, Function246b5
	bit 5, a
	jp nz, Function246a1
	bit 6, a
	jp nz, Function246c9
	bit 7, a
	jp nz, Function246df
	jr .asm_24609
; 24640

Function24640: ; 24640
	ld a, $ff
	and a
	ret
; 24644

Function24644: ; 24644
	call Function1bee
	ld a, [wcfa9]
	dec a
	call Function248d5
	ld a, [MenuSelection]
	ld [CurItem], a
	ld a, [wcf75]
	ld [wd10d], a
	call Function246fc
	dec a
	ld [wcf77], a
	ld [wd107], a
	ld a, [MenuSelection]
	cp $ff
	jr z, Function2466f
	ld a, $1
	scf
	ret
; 2466f

Function2466f: ; 2466f
	ld a, $2
	scf
	ret
; 24673

Function24673: ; 24673
	ld a, [wcf91]
	bit 7, a
	jp z, Function2ec8
	ld a, [wcfa9]
	dec a
	call Function248d5
	ld a, [MenuSelection]
	cp $ff
	jp z, Function2ec8
	call Function246fc
	dec a
	ld [wcf77], a
	ld a, $4
	scf
	ret
; 24695

Function24695: ; 24695
	ld a, [wcf91]
	bit 6, a
	jp z, Function2ec8
	ld a, $8
	scf
	ret
; 246a1

Function246a1: ; 246a1
	ld hl, wcfa6
	bit 7, [hl]
	jp z, Function2ec8
	ld a, [wcf91]
	bit 3, a
	jp z, Function2ec8
	ld a, $20
	scf
	ret
; 246b5

Function246b5: ; 246b5
	ld hl, wcfa6
	bit 7, [hl]
	jp z, Function2ec8
	ld a, [wcf91]
	bit 2, a
	jp z, Function2ec8
	ld a, $10
	scf
	ret
; 246c9

Function246c9: ; 246c9
	ld hl, wcfa6
	bit 7, [hl]
	jp z, Function2ec6
	ld hl, wd0e4
	ld a, [hl]
	and a
	jr z, .asm_246dc
	dec [hl]
	jp Function2ec6

.asm_246dc
	jp Function2ec8
; 246df

Function246df: ; 246df
	ld hl, wcfa6
	bit 7, [hl]
	jp z, Function2ec6
	ld hl, wd0e4
	ld a, [wcf92]
	add [hl]
	ld b, a
	ld a, [wd144]
	cp b
	jr c, .asm_246f9
	inc [hl]
	jp Function2ec6

.asm_246f9
	jp Function2ec8
; 246fc

Function246fc: ; 246fc
	ld a, [wd0e4]
	ld c, a
	ld a, [wcfa9]
	add c
	ld c, a
	ret
; 24706

Function24706: ; 24706 (9:4706)
	call Function1cfd ;hl = curmenu start location in tilemap
	ld de, $14
	add hl, de
	ld de, $28
	ld a, [wcf92]
.asm_24713
	ld [hl], $7f
	add hl, de
	dec a
	jr nz, .asm_24713
	ret

Function2471a: ; 2471a
	ld hl, wcf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wcf95]
	call GetFarByte
	ld [wd144], a
	ld a, [wcf92]
	ld c, a
	ld a, [wd0e4]
	add c
	ld c, a
	ld a, [wd144]
	inc a
	cp c
	jr nc, .asm_24748
	ld a, [wcf92]
	ld c, a
	ld a, [wd144]
	inc a
	sub c
	jr nc, .asm_24745
	xor a
.asm_24745
	ld [wd0e4], a
.asm_24748
	ld a, [wd0e4]
	ld c, a
	ld a, [wcf88]
	add c
	ld b, a
	ld a, [wd144]
	inc a
	cp b
	jr c, .asm_2475a
	jr nc, .asm_24763
.asm_2475a
	xor a
	ld [wd0e4], a
	ld a, $1
	ld [wcf88], a
.asm_24763
	ret
; 24764

Function24764: ; 24764
	ld a, [wcf91]
	ld c, a
	ld a, [wd144]
	ld b, a
	ld a, [wcf82]
	add $1
	ld [wcfa1], a
	ld a, [wcf83]
	add $0
	ld [wcfa2], a
	ld a, [wcf92]
	cp b
	jr c, .asm_24786
	jr z, .asm_24786
	ld a, b
	inc a
.asm_24786
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld a, $8c
	bit 2, c
	jr z, .asm_24796
	set 0, a
.asm_24796
	bit 3, c
	jr z, .asm_2479c
	set 1, a
.asm_2479c
	ld [wcfa5], a
	xor a
	ld [wcfa6], a
	ld a, $20
	ld [wcfa7], a
	ld a, $c3
	bit 7, c
	jr z, .asm_247b0
	add $4
.asm_247b0
	bit 6, c
	jr z, .asm_247b6
	add $8
.asm_247b6
	ld [wcfa8], a
	ld a, [wcfa3]
	ld b, a
	ld a, [wcf88]
	and a
	jr z, .asm_247c8
	cp b
	jr z, .asm_247ca
	jr c, .asm_247ca
.asm_247c8
	ld a, $1
.asm_247ca
	ld [wcfa9], a
	ld a, $1
	ld [wcfaa], a
	xor a
	ld [wcfac], a
	ld [wcfad], a
	ld [wcfab], a
	ret
; 247dd

Function247dd: ; 247dd
	ld a, [wd144]
	ld c, a
	ld a, [wd0e3]
	and a
	jr z, .asm_247ef
	dec a
	cp c
	jr c, .asm_247ef
	xor a
	ld [wd0e3], a
.asm_247ef
	ret
; 247f0

Function247f0: ; 247f0
	call Function1cf1
	ld a, [wcf91]
	bit 4, a
	jr z, .asm_2480d
	ld a, [wd0e4]
	and a
	jr z, .asm_2480d
	ld a, [wcf82]
	ld b, a
	ld a, [wcf85]
	ld c, a
	call GetTileCoord
	ld [hl], $61
.asm_2480d
	call Function1cfd ;hl = curmenu start location in tilemap
	ld bc, $0015
	add hl, bc
	ld a, [wcf92]
	ld b, a
	ld c, $0
.asm_2481a
	ld a, [wd0e4]
	add c
	ld [wcf77], a
	ld a, c
	call Function248d5
	ld a, [MenuSelection]
	cp $ff
	jr z, .asm_24851
	push bc
	push hl
	call Function2486e
	pop hl
	ld bc, $0028
	add hl, bc
	pop bc
	inc c
	ld a, c
	cp b
	jr nz, .asm_2481a
	ld a, [wcf91]
	bit 4, a
	jr z, .asm_24850
	ld a, [wcf84]
	ld b, a
	ld a, [wcf85]
	ld c, a
	call GetTileCoord
	ld [hl], $ee
.asm_24850
	ret

.asm_24851
	ld a, [wcf91]
	bit 0, a
	jr nz, .asm_24866
	ld de, .string_2485f
	call PlaceString
	ret

.string_2485f
	db "CANCEL@"
.asm_24866
	ld d, h
	ld e, l
	ld hl, wcf98
	jp CallPointerAt
; 2486e

Function2486e: ; 2486e
	push hl
	ld d, h
	ld e, l
	ld hl, wcf98
	call CallPointerAt
	pop hl
	ld a, [wcf93]
	and a
	jr z, .asm_2488a
	ld e, a
	ld d, $0
	add hl, de
	ld d, h
	ld e, l
	ld hl, wcf9b
	call CallPointerAt
.asm_2488a
	ret
; 2488b

Function2488b: ; 2488b
	ld a, [wd0e3]
	and a
	jr z, .asm_248b7
	ld b, a
	ld a, [wd0e4]
	cp b
	jr nc, .asm_248b7
	ld c, a
	ld a, [wcf92]
	add c
	cp b
	jr c, .asm_248b7
	ld a, b
	sub c
	dec a
	add a
	add $1
	ld c, a
	ld a, [wcf82]
	add c
	ld b, a
	ld a, [wcf83]
	add $0
	ld c, a
	call GetTileCoord
	ld [hl], $ec
.asm_248b7
	ret
; 248b8

Function248b8: ; 248b8
	ld a, [wcf91]
	bit 5, a
	ret z
	bit 1, a
	jr z, .asm_248c7
	ld a, [wd0e3]
	and a
	ret nz
.asm_248c7
	ld a, [wcfa9]
	dec a
	call Function248d5
	ld hl, wcf9e
	call CallPointerAt
	ret
; 248d5

Function248d5: ; 248d5
	push de
	push hl
	ld e, a
	ld a, [wd0e4]
	add e
	ld e, a
	ld d, $0
	ld hl, wcf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [wcf94]
	cp $1
	jr z, .asm_248f2
	cp $2
	jr z, .asm_248f1
.asm_248f1
	add hl, de
.asm_248f2
	add hl, de
	ld a, [wcf95]
	call GetFarByte
	ld [MenuSelection], a
	ld [CurItem], a
	inc hl
	ld a, [wcf95]
	call GetFarByte
	ld [wcf75], a
	pop hl
	pop de
	ret
; 2490c

Function2490c: ; 2490c (9:490c)
	ld a, [wd0e3]
	and a
	jr z, .asm_2493d
	ld b, a
	ld a, [wcf77]
	inc a
	cp b
	jr z, .asm_24945
	ld a, [wcf77]
	call Function24a5c
	ld a, [hl]
	cp $ff
	ret z
	ld a, [wd0e3]
	dec a
	ld [wd0e3], a
	call Function249a7
	jp c, Function249d1
	ld a, [wcf77]
	ld c, a
	ld a, [wd0e3]
	cp c
	jr c, .asm_2497a
	jr .asm_2494a

.asm_2493d
	ld a, [wcf77]
	inc a
	ld [wd0e3], a
	ret

.asm_24945
	xor a
	ld [wd0e3], a
	ret

.asm_2494a
	ld a, [wd0e3]
	call Function24a40
	ld a, [wcf77]
	ld d, a
	ld a, [wd0e3]
	ld e, a
	call Function24a6c
	push bc
	ld a, [wd0e3]
	call Function24a5c
	dec hl
	push hl
	ld a, [wcf94]
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	call Function24aab
	ld a, [wcf77]
	call Function24a4d
	xor a
	ld [wd0e3], a
	ret

.asm_2497a
	ld a, [wd0e3]
	call Function24a40
	ld a, [wcf77]
	ld d, a
	ld a, [wd0e3]
	ld e, a
	call Function24a6c
	push bc
	ld a, [wd0e3]
	call Function24a5c
	ld d, h
	ld e, l
	ld a, [wcf94]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	call CopyBytes
	ld a, [wcf77]
	call Function24a4d
	xor a
	ld [wd0e3], a
	ret

Function249a7: ; 249a7 (9:49a7)
	ld a, [wd0e3]
	call Function24a5c
	ld d, h
	ld e, l
	ld a, [wcf77]
	call Function24a5c
	ld a, [de]
	cp [hl]
	jr nz, .asm_249cd
	ld a, [wcf77]
	call Function24a97
	cp $63
	jr z, .asm_249cd
	ld a, [wd0e3]
	call Function24a97
	cp $63
	jr nz, .asm_249cf
.asm_249cd
	and a
	ret

.asm_249cf
	scf
	ret

Function249d1: ; 249d1 (9:49d1)
	ld a, [wd0e3]
	call Function24a5c
	inc hl
	push hl
	ld a, [wcf77]
	call Function24a5c
	inc hl
	ld a, [hl]
	pop hl
	add [hl]
	cp $64
	jr c, .asm_24a01
	sub $63
	push af
	ld a, [wcf77]
	call Function24a5c
	inc hl
	ld [hl], $63
	ld a, [wd0e3]
	call Function24a5c
	inc hl
	pop af
	ld [hl], a
	xor a
	ld [wd0e3], a
	ret

.asm_24a01
	push af
	ld a, [wcf77]
	call Function24a5c
	inc hl
	pop af
	ld [hl], a
	ld hl, wcf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd0e3]
	cp [hl]
	jr nz, .asm_24a25
	dec [hl]
	ld a, [wd0e3]
	call Function24a5c
	ld [hl], $ff
	xor a
	ld [wd0e3], a
	ret

.asm_24a25
	dec [hl]
	ld a, [wcf94]
	ld c, a
	ld b, 0
	push bc
	ld a, [wd0e3]
	call Function24a5c
	pop bc
	push hl
	add hl, bc
	pop de
.asm_24a34
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .asm_24a34
	xor a
	ld [wd0e3], a
	ret

Function24a40: ; 24a40 (9:4a40)
	call Function24a5c
	ld de, DefaultFlypoint
	ld a, [wcf94]
	ld c, a
	ld b, 0
	call CopyBytes
	ret

Function24a4d: ; 24a4d (9:4a4d)
	call Function24a5c
	ld d, h
	ld e, l
	ld hl, DefaultFlypoint
	ld a, [wcf94]
	ld c, a
	ld b, 0
	call CopyBytes
	ret

Function24a5c: ; 24a5c (9:4a5c)
	push af
	ld a, [wcf94]
	ld c, a
	ld b, 0
	ld hl, wcf96
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	pop af
	call AddNTimes
	ret

Function24a6c: ; 24a6c (9:4a6c)
	push hl
	ld a, [wcf94]
	ld c, a
	ld b, 0
	ld a, d
	sub e
	jr nc, .asm_24a76
	dec a
	cpl
.asm_24a76
	ld hl, $0
	call AddNTimes
	ld b, h
	ld c, l
	pop hl
	ret

Function24a97: ; 24a97 (9:4a97)
	push af
	ld a, [wcf94]
	ld c, a
	ld b, 0
	ld a, c
	cp $2
	jr nz, .asm_24aa7
	pop af
	call Function24a5c
	inc hl
	ld a, [hl]
	ret

.asm_24aa7
	pop af
	ld a, $1
	ret

Function24aab: ; 24aab (9:4aab)
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, b
	or c
	jr nz, Function24aab
	ret

Function24ab4: ; 0x24ab4
	push de
	ld a, [MenuSelection]
	ld [wd265], a
	call GetItemName
	pop hl
	call PlaceString
	ret
; 0x24ac3

Function24ac3: ; 0x24ac3
	push de
	ld a, [MenuSelection]
	ld [CurItem], a
	callba _CheckTossableItem
	ld a, [wd142]
	pop hl
	and a
	jr nz, .done
	ld de, $0015
	add hl, de
	ld [hl], $f1
	inc hl
	ld de, wcf75
	ld bc, $0102
	call PrintNum
.done
	ret
; 0x24ae8

Function24ae8: ; 24ae8
	ld hl, MenuDataHeader_0x24b15
	call Function1d3c
	jr Function24b01

Function24af0: ; 24af0
	ld hl, MenuDataHeader_0x24b1d
	call Function1d3c
	jr Function24b01

Function24af8: ; 24af8
	ld hl, MenuDataHeader_0x24b15
	ld de, $000b
	call Function1e2e
Function24b01: ; 24b01
	call Function1cbb ;put a textbox in menu area
	call Function1cfd ;hl = curmenu start location in tilemap
	ld de, $0015
	add hl, de
	ld de, Money
	ld bc, $2306
	call PrintNum
	ret
; 24b15

MenuDataHeader_0x24b15: ; 0x24b15
	db $40 ; flags
	db 00, 11 ; start coords
	db 02, 19 ; end coords
	dw NULL
	db 1 ; default option
; 0x24b1d

MenuDataHeader_0x24b1d: ; 0x24b1d
	db $40 ; flags
	db 11, 00 ; start coords
	db 13, 08 ; end coords
	dw NULL
	db 1 ; default option
; 0x24b25

Function24b25: ; 24b25
	hlcoord 11, 0
	ld b, $1
	ld c, $7
	call TextBox
	hlcoord 12, 0
	ld de, CoinString
	call PlaceString
	hlcoord 17, 1
	ld de, String24b8e
	call PlaceString
	ld de, Coins
	ld bc, $0205
	hlcoord 12, 1
	call PrintNum
	ret
; 24b4e

Function24b4e: ; 24b4e
	hlcoord 5, 0
	ld b, $3
	ld c, $d
	call TextBox
	hlcoord 6, 1
	ld de, MoneyString
	call PlaceString
	hlcoord 12, 1
	ld de, Money
	ld bc, $2306
	call PrintNum
	hlcoord 6, 3
	ld de, CoinString
	call PlaceString
	hlcoord 14, 3
	ld de, Coins
	ld bc, $0205
	call PrintNum
	ret
; 24b83

MoneyString: ; 24b83
	db "MONEY@"
CoinString: ; 24b89
	db "COIN@"
String24b8e: ; 24b8e
	db "@"
; 24b8f

Function24b8f: ; 24b8f
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	hlcoord 0, 0
	ld b, $3
	ld c, $7
	call TextBox
	hlcoord 1, 1
	ld de, wdc7a
	ld bc, $0203
	call PrintNum
	hlcoord 4, 1
	ld de, String24bcf
	call PlaceString
	hlcoord 1, 3
	ld de, String24bd4
	call PlaceString
	hlcoord 5, 3
	ld de, wdc79
	ld bc, $0102
	call PrintNum
	pop af
	ld [Options], a
	ret
; 24bcf

String24bcf: ; 24bcf
	db "/500@"
String24bd4: ; 24bd4
	db "ボール   こ@"
; 24bdc

Function24bdc: ; 24bdc
	hlcoord 0, 0
	ld b, $5
	ld c, $11
	call TextBox
	ret
; 24be7

Function24be7: ; 24be7
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function24bdc
	hlcoord 1, 5
	ld de, String24c52
	call PlaceString
	hlcoord 8, 5
	ld de, wdc79
	ld bc, $4102
	call PrintNum
	hlcoord 1, 1
	ld de, String24c4b
	call PlaceString
	ld a, [wdf9c]
	and a
	ld de, String24c59
	jr z, .asm_24c1e
	ld [wd265], a
	call GetPokemonName
.asm_24c1e
	hlcoord 8, 1
	call PlaceString
	ld a, [wdf9c]
	and a
	jr z, .asm_24c3e
	hlcoord 1, 3
	ld de, String24c5e
	call PlaceString
	ld a, [wContestMonLevel]
	ld h, b
	ld l, c
	inc hl
	ld c, $3
	call Function3842
.asm_24c3e
	pop af
	ld [Options], a
	ret
; 24c43

String24c43: ; 24c43
	db "ボール   こ@"
String24c4b: ; 24c4b
	db "CAUGHT@"
String24c52: ; 24c52
	db "BALLS:@"
String24c59: ; 24c59
	db "None@"
String24c5e: ; 24c5e
	db "LEVEL@"
; 24c64

Function24c64: ; 24c64
	ld hl, Buffer1
	xor a
	ld [hli], a
	dec a
	ld bc, $000a
	call ByteFill
	ld hl, ApricornBalls
.asm_24c73
	ld a, [hl]
	cp $ff
	jr z, .asm_24c8d
	push hl
	ld [CurItem], a
	ld hl, NumItems
	call CheckItem
	pop hl
	jr nc, .asm_24c89
	ld a, [hl]
	call Function24c94
.asm_24c89
	inc hl
	inc hl
	jr .asm_24c73

.asm_24c8d
	ld a, [Buffer1]
	and a
	ret nz
	scf
	ret
; 24c94

Function24c94: ; 24c94
	push hl
	ld hl, Buffer1
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld [hl], a
	pop hl
	ret
; 24ca0

ApricornBalls: ; 24ca0
	db RED_APRICORN, LEVEL_BALL
	db BLU_APRICORN, LURE_BALL
	db YLW_APRICORN, MOON_BALL
	db GRN_APRICORN, FRIEND_BALL
	db WHT_APRICORN, FAST_BALL
	db BLK_APRICORN, HEAVY_BALL
	db PNK_APRICORN, LOVE_BALL
	db $ff
; 24caf

MonMenuOptionStrings: ; 24caf
	db "STATS@"
	db "SWITCH@"
	db "ITEM@"
	db "CANCEL@"
	db "MOVE@"
	db "MAIL@"
	db "ERROR!@"
; 24cd9

MonMenuOptions: ; 24cd9
; Moves

	db 0,  1, CUT
	db 0,  2, FLY
	db 0,  3, SURF
	db 0,  4, STRENGTH
	db 0,  6, FLASH
	db 0,  5, WATERFALL
	db 0,  7, WHIRLPOOL
	db 0,  8, DIG
	db 0,  9, TELEPORT
	db 0, 10, SOFTBOILED
	db 0, 11, HEADBUTT
	db 0, 12, ROCK_SMASH
	db 0, 13, MILK_DRINK
	db 0, 14, ZEN_HEADBUTT
; Options

	db 1, 15, 1 ; STATS
	db 1, 16, 2 ; SWITCH
	db 1, 17, 3 ; ITEM
	db 1, 18, 4 ; CANCEL
	db 1, 19, 5 ; MOVE
	db 1, 20, 6 ; MAIL
	db 1, 21, 7 ; ERROR!
	db $ff
; 24d19

Function24d19: ; 24d19 MonSubMenu load, process, then unload the mon sub menu. put selection in MenuSelection
	xor a
	ld [hBGMapMode], a
	call Function24dd4 ;populate buffer 2 with curpartymon's menu options
	callba Function8ea4a ;hl = wc314 + 96. load 2 into the third byte of each 16 byte blockif the first byte is equal to wcfa9, otherwise 0 if the first byte is not 0
	ld hl, MenuDataHeader_0x24d3f
	call LoadMenuDataHeader ;new menu, store tiles it covers on stack
	call Function24d47 ;draw a text box to hold mon options menu
	call Function24d91 ;load menu options text into tilemap
	ld a, 1
	ld [hBGMapMode], a ;BGmapmode = 1
	call Function24d59 ;process monsubmenu, put the command to execute in a
	ld [MenuSelection], a
	call Function1c07 ;unload monsubmenu
	ret
; 24d3f

MenuDataHeader_0x24d3f: ; 24d3f
	db $40 ; tile backup
	db 00, 05 ; start coords
	db 17, 19 ; end coords
	dw $0000
	db 1 ; default option
; 24d47

Function24d47: ; 24d47 draw a text box to hold mon options menu
	ld a, [Buffer1]
	inc a
	add a
	ld b, a
	ld a, [wcf84] ;sub items in menu +1*2 and add 1 to end y coord, put result in start y coord
	sub b
	inc a
	ld [wcf82], a
	call Function1cbb ;put a textbox in menu area
	ret
; 24d59

Function24d59: ; 24d59 ;process monsubmenu, return the command to execute in a
.asm_24d59
	ld a, $a0
	ld [wcf91], a ;load 160 into ??
	ld a, [Buffer1] ;load mon list legnth into number of vertical options
	ld [wcf92], a
	call Function1c10 ;fill rest of menu data
	ld hl, wcfa5
	set 6, [hl] ;set flag 6 of wcfa5
	call Function1bc9 ;place and update cursor, loop until a (or b if allowed) is pressed, update joylast
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	ld a, [hJoyPressed] ;branch based on button press, loop if niether
	bit 0, a ; A
	jr nz, .asm_24d84 ;return a = correct menu option
	bit 1, a ; B
	jr nz, .asm_24d81 ;ret a = 18
	jr .asm_24d59

.asm_24d81
	ld a, 18 ; CANCEL
	ret

.asm_24d84
	ld a, [wcfa9]
	dec a
	ld c, a
	ld b, 0
	ld hl, Buffer2
	add hl, bc
	ld a, [hl]
	ret
; 24d91

Function24d91: ; 24d91 ;load menu options text into tilemap
	call Function1cfd ;hl = curmenu start location in tilemap
	ld bc, $002a ;go down 42 (2 rows and 2 colomns)
	add hl, bc
	ld de, Buffer2 ;load menu options
.asm_24d9b
	ld a, [de] ;load menu option
	inc de
	cp $ff
	ret z ;if $ff, ret
	push de
	push hl
	call Function24db0 ;put string for move whose listing is in a in de (stringbuffer 1)
	pop hl
	call PlaceString ;fill menu with the string
	ld bc, $0028
	add hl, bc ;go down 2 rows
	pop de
	jr .asm_24d9b ;loop
; 24db0

Function24db0: ; 24db0 ;put string for move whose listing is in a in stringbuffer 1
	ld hl, MonMenuOptions + 1 ;move over listings
	ld de, $0003
	call IsInArray ;put that move loc in hl
	dec hl ;check if it's a move
	ld a, [hli]
	cp $1
	jr z, .asm_24dc8 ;if it isn't, get it
	inc hl
	ld a, [hl]
	ld [wd265], a
	call GetMoveName ;put name of the move in stringbuffer 1
	ret

.asm_24dc8
	inc hl
	ld a, [hl]
	dec a
	ld hl, MonMenuOptionStrings
	call GetNthString
	ld d, h
	ld e, l
	ret
; 24dd4

Function24dd4: ; 24dd4 ;populate buffer 2 with curpartymon's menu options
	call Function24e68 ;clear buffer1 and 9 bytes of buffer2
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_24e3f ;if egg, branch off
	ld a, [wLinkMode]
	and a
	jr nz, .asm_24e03 ;if in link battle, skip adding moves to list
	ld a, PartyMon1Moves - PartyMon1 ;a = space till moves in party data
	call GetPartyParamLocation
	ld d, h ;de = curpartymon's moves
	ld e, l
	ld c, NUM_MOVES
.asm_24ded
	push bc
	push de
	ld a, [de]
	and a
	jr z, .asm_24dfd ;if slot is empty, next move and loop or continue
	push hl ;else
	call Function24e52 ;get menu isting for out of battle move, put it in a. else ret nc
	pop hl
	jr nc, .asm_24dfd ;loop until succsessful
	call Function24e83 ; load a into slot buffer1 in buffer 2, then inc buffer 1
.asm_24dfd
	pop de
	inc de
	pop bc
	dec c
	jr nz, .asm_24ded
.asm_24e03
	ld a, $f
	call Function24e83 ;add 15,16 and 19 to buffer2
	ld a, $10
	call Function24e83
	ld a, $13
	call Function24e83
	ld a, [wLinkMode]
	and a
	jr nz, .asm_24e2f ;if in link battle branch
	push hl
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	ld d, [hl] ;put mon item in d
	callba ItemIsMail ;check if it is mail, ret c if it is
	pop hl
	ld a, $14
	jr c, .asm_24e2c ; if is mail, add 20 to buffer 2, else add 17
	ld a, $11
.asm_24e2c
	call Function24e83
.asm_24e2f
	ld a, [Buffer1]
	cp $8
	jr z, .asm_24e3b ;if not 8 items have been added, add 18 to buffer 2
	ld a, $12
	call Function24e83
.asm_24e3b
	call Function24e76 ;load $FF into buffer2 in last slot
	ret

.asm_24e3f ;if egg, only add 15, 16, 18 and ff
	ld a, $f
	call Function24e83
	ld a, $10
	call Function24e83
	ld a, $12
	call Function24e83
	call Function24e76
	ret
; 24e52

Function24e52: ; 24e52 get menu isting for out of battle move, else ret nc
	ld b, a
	ld hl, MonMenuOptions
.asm_24e56
	ld a, [hli]
	cp $ff ;if end of table or non-move options, ret nc
	ret z;, .asm_24e67
	cp $1
	ret z;, .asm_24e67
	ld d, [hl] ;put listing number in d
	inc hl
	ld a, [hli]
	cp b ;if move doesn't match, loop
	jr nz, .asm_24e56
	ld a, d ;else put move listing in a
	scf
.asm_24e67
	ret
; 24e68

Function24e68: ; 24e68 ;clear buffer1 and 9 bytes of buffer2
	xor a
	ld [Buffer1], a
	ld hl, Buffer2
	ld bc, $0009
	call ByteFill
	ret
; 24e76

Function24e76: ; 24e76
	ld a, [Buffer1]
	ld e, a
	ld d, $0
	ld hl, Buffer2
	add hl, de
	ld [hl], $ff
	ret
; 24e83

Function24e83: ; 24e83
	push hl
	push de
	push af
	ld a, [Buffer1] ; load a into slot buffer1 in buffer 2, then inc buffer 1
	ld e, a
	inc a
	ld [Buffer1], a
	ld d, $0
	ld hl, Buffer2
	add hl, de
	pop af
	ld [hl], a
	pop de
	pop hl
	ret
; 24e99

Function24e99: ; 24e99
; BattleMonMenu

	ld hl, MenuDataHeader_0x24ed4
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function1ad2
	call Function1c89
	call WaitBGMap
	call Function1c66
	ld a, [wcf91]
	bit 7, a
	jr z, .asm_24ed0
	call Function1c10
	ld hl, wcfa5
	set 6, [hl]
	call Function1bc9
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	ld a, [hJoyPressed]
	bit 1, a
	jr z, .asm_24ed2
	ret z
.asm_24ed0
	scf
	ret

.asm_24ed2
	and a
	ret
; 24ed4

MenuDataHeader_0x24ed4: ; 24ed4
	db $00 ; flags
	db 11, 11 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0x24edc
	db 1 ; default option
; 24edc

MenuData2_0x24edc: ; 24edc
	db $c0 ; flags
	db 3 ; items
	db "SWITCH@"
	db "STATS@"
	db "CANCEL@"
; 24ef2

LoadBattleMenu: ; 24ef2
	ld hl, BattleMenuDataHeader
	call LoadMenuDataHeader
	ld a, [wd0d2]
	ld [wcf88], a
	call Function2039
	ld a, [wcf88]
	ld [wd0d2], a
	call Function1c07
	ret
; 24f0b

SafariBattleMenu: ; 24f0b
; untranslated

	ld hl, MenuDataHeader_0x24f4e
	call LoadMenuDataHeader
	jr Function24f19
; 24f13

ContestBattleMenu: ; 24f13
	ld hl, MenuDataHeader_0x24f89
	call LoadMenuDataHeader
; 24f19

Function24f19: ; 24f19
	ld a, [wd0d2]
	ld [wcf88], a
	call Function202a
	ld a, [wcf88]
	ld [wd0d2], a
	call Function1c07 ;unload top menu on menu stack
	ret
; 24f2c

BattleMenuDataHeader: ; 24f2c
	db $40 ; flags
	db 12, 08 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f34
	db 1 ; default option
; 24f34

MenuData_0x24f34: ; 0x24f34
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 6 ; spacing
	dbw BANK(Strings24f3d), Strings24f3d
	dbw $09, $0000
; 0x24f3d

Strings24f3d: ; 0x24f3d
	db "FIGHT@"
	db $4a, "@"
	db "PACK@"
	db "RUN@"
; 24f4e

MenuDataHeader_0x24f4e: ; 24f4e
	db $40 ; flags
	db 12, 00 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f56
	db 1 ; default option
; 24f56

MenuData_0x24f56: ; 24f56
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 11 ; spacing
	dbw BANK(Strings24f5f), Strings24f5f
	dbw BANK(Function24f7c), Function24f7c
; 24f5f

Strings24f5f: ; 24f5f
	db "SAFARI BALL@" ; "SAFARI BALL×  @"
	db "BAIT@" ; "THROW BAIT"
	db "ROCK@" ; "THROW ROCK"
	db "RUN@" ; "RUN"
; 24f7c

Function24f7c: ; 24f7c
	hlcoord 17, 13
	ld de, wdc79
	ld bc, $8102
	call PrintNum
	ret
; 24f89

MenuDataHeader_0x24f89: ; 24f89
	db $40 ; flags
	db 12, 02 ; start coords
	db 17, 19 ; end coords
	dw MenuData_0x24f91
	db 1 ; default option
; 24f91

MenuData_0x24f91: ; 24f91
	db $81 ; flags
	dn 2, 2 ; rows, columns
	db 12 ; spacing
	dbw BANK(Strings24f9a), Strings24f9a
	dbw BANK(Function24fb2), Function24fb2
; 24f9a

Strings24f9a: ; 24f9a
	db "FIGHT@"
	db $4a, "@"
	db "PARKBALL×  @"
	db "RUN@"
; 24fb2

Function24fb2: ; 24fb2
	hlcoord 13, 16
	ld de, wdc79
	ld bc, $8102
	call PrintNum
	ret
; 24fbf

Function24fbf: ; 24fbf
	ld hl, MenuDataHeader_0x250ed
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24fc9

Function24fc9: ; 24fc9
	callba GetItemPrice
Function24fcf: ; 24fcf
	ld a, d
	ld [Buffer1], a
	ld a, e
	ld [Buffer2], a
	ld hl, MenuDataHeader_0x250f5
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24fe1

Function24fe1: ; 24fe1
	callba GetItemPrice
	ld a, d
	ld [Buffer1], a
	ld a, e
	ld [Buffer2], a
	ld hl, MenuDataHeader_0x250fd
	call LoadMenuDataHeader
	call Function24ff9
	ret
; 24ff9

Function24ff9: ; 24ff9
	ld a, $1
	ld [wd10c], a
.loop
	call Function25072
	call Function2500e
	jr nc, .loop
	cp $ff
	jr nz, .pressed_a
	scf
	ret

.pressed_a
	ld a, 1
	and a
	ret
; 2500e

Function2500e: ; 2500e
	call Function354b
	bit 1, c
	jr nz, .b_button
	bit 0, c
	jr nz, .a_button
	bit 7, c
	jr nz, .d_down
	bit 6, c
	jr nz, .d_up
	bit 5, c
	jr nz, .d_left
	bit 4, c
	jr nz, .d_right
	and a
	ret

.b_button
	ld a, $ff
	scf
	ret

.a_button
	ld a, $0
	scf
	ret

.d_down
	ld hl, wd10c
	dec [hl]
	jr nz, .asm_2503d
	ld a, [wd10d]
	ld [hl], a
.asm_2503d
	and a
	ret

.d_up
	ld hl, wd10c
	inc [hl]
	ld a, [wd10d]
	cp [hl]
	jr nc, .asm_2504b
	ld [hl], $1
.asm_2504b
	and a
	ret

.d_left
	ld a, [wd10c]
	sub $a
	jr c, .asm_25058
	jr z, .asm_25058
	jr .asm_2505a

.asm_25058
	ld a, $1
.asm_2505a
	ld [wd10c], a
	and a
	ret

.d_right
	ld a, [wd10c]
	add $a
	ld b, a
	ld a, [wd10d]
	cp b
	jr nc, .asm_2506c
	ld b, a
.asm_2506c
	ld a, b
	ld [wd10c], a
	and a
	ret
; 25072

Function25072: ; 25072
	call Function1cbb
	call Function1cfd ;hl = curmenu start location in tilemap
	ld de, $0015
	add hl, de
	ld [hl], $f1
	inc hl
	ld de, wd10c
	ld bc, $8102
	call PrintNum
	ld a, [wcf86]
	ld e, a
	ld a, [wcf87]
	ld d, a
	ld a, [wcf8a]
	call FarCall_de
	ret
; 25097

Function25097: ; 25097
	ret
; 25098

Function25098: ; 25098
	call Function250a9
	call Function250d1
	ret
; 2509f

Function2509f: ; 2509f
	call Function250a9
	call Function250c1
	call Function250d1
	ret
; 250a9

Function250a9: ; 250a9
	xor a
	ld [hMultiplicand], a
	ld a, [Buffer1]
	ld [$ffb5], a
	ld a, [Buffer2]
	ld [$ffb6], a
	ld a, [wd10c]
	ld [hMultiplier], a
	push hl
	call Multiply
	pop hl
	ret
; 250c1

Function250c1: ; 250c1
	push hl
	ld hl, hMultiplicand
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hli], a
	ld a, [hl]
	rra
	ld [hl], a
	pop hl
	ret
; 250d1

Function250d1: ; 250d1
	push hl
	ld hl, $ffc3
	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hl], a
	pop hl
	inc hl
	ld de, $ffc3
	ld bc, $2306
	call PrintNum
	call WaitBGMap
	ret
; 250ed

MenuDataHeader_0x250ed: ; 0x250ed
	db $40 ; flags
	db 09, 15 ; start coords
	db 11, 19 ; end coords
	dw Function25097
	db 0 ; default option
; 0x250f5

MenuDataHeader_0x250f5: ; 0x250f5
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw Function25098
	db -1 ; default option
; 0x250fd

MenuDataHeader_0x250fd: ; 0x250fd
	db $40 ; flags
	db 15, 07 ; start coords
	db 17, 19 ; end coords
	dw Function2509f
	db 0 ; default option
; 0x25105

; SECTION "Trainer Card", ROMX

Function25105: ; 25105
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function2513b
.asm_25117
	call UpdateTime
	call Functiona57
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_25132
	ld a, [$ffa9]
	and $2
	jr nz, .asm_25132
	call Function2518e
	call DelayFrame
	jr .asm_25117

.asm_25132
	pop af
	ld [Options], a
	pop af
	ld [VramState], a
	ret

Function2513b: ; 2513b (9:513b)
	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	call DisableLCD
	callba Function8833e
	ld hl, CardRightCornerGFX
	ld de, $91c0
	ld bc, $10
	ld a, BANK(CardRightCornerGFX)
	call FarCopyBytes
	ld hl, CardStatusGFX
	ld de, $9290
	ld bc, $60 + $500
	ld a, BANK(CardStatusGFX)
	call FarCopyBytes
	call Function25299
	hlcoord 0, 8
	ld d, $6
	call Function253b0
	call EnableLCD
	call WaitBGMap
	ld b, $15
	call GetSGBLayout
	call Function32f9
	call WaitBGMap
	ld hl, wcf63
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

Function2518e: ; 2518e (9:518e)
	ld a, [wcf63]
	ld e, a
	ld d, $0
	ld hl, Jumptable_2519d
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_2519d: ; 2519d (9:519d)
	dw TrainerCardPage1_LoadGFX
	dw TrainerCardPage1_WaitJoypad
	dw TrainerCardPage2_LoadGFX
	dw TrainerCardPage2_WaitJoypad
	dw TrainerCardPage3_LoadGFX
	dw TrainerCardPage3_WaitJoypad
	dw TrainerCardExit

TrainerCardNext: ; 251ab (9:51ab)
	ld hl, wcf63
	inc [hl]
	ret

TrainerCardExit: ; 251b0 (9:51b0)
	ld hl, wcf63
	set 7, [hl]
	ret

TrainerCardPage1_LoadGFX: ; 251b6 (9:51b6)
	call ClearSprites
	hlcoord 0, 8
	ld d, $6
	call Function253b0
	call WaitBGMap
	ld de, CardStatusGFX
	ld hl, $9290
	lb bc, BANK(CardStatusGFX), $6 + $50
	call Request2bpp
	call Function2530a
	call TrainerCardNext
	ret

TrainerCardPage1_WaitJoypad: ; 251d7 (9:51d7)
	call Function25415
	ld hl, $ffa9
	ld a, [hl]
	and $11
	jr nz, .asm_251e3
	ld a, [hl]
	and $20
	jr nz, .left
	ret

.asm_251e3
	ld hl, StatusFlags
	bit 5, [hl]
	jr z, .kanto
.johto
	ld a, $2
	ld [wcf63], a
	ret
; 251e9 (9:51e9)

.left: ; 251e9
	ld hl, StatusFlags
	bit 5, [hl]
	jr nz, .johto
.kanto
	ld a, $4
	ld [wcf63], a
	ret
; 251f4

TrainerCardPage2_LoadGFX: ; 251f4 (9:51f4)
	call ClearSprites
	hlcoord 0, 8
	ld d, $6
	call Function253b0
	call WaitBGMap
	ld de, LeaderGFX
	ld hl, $9290
	lb bc, BANK(LeaderGFX), $56
	call Request2bpp
	ld de, BadgeGFX
	ld hl, $8000
	lb bc, BANK(BadgeGFX), $2c
	call Request2bpp
	call Function2536c
	call TrainerCardNext
	ret

TrainerCardPage2_WaitJoypad: ; 25221 (9:5221)
	ld hl, Unknown_254c9
	call Function25438
	ld hl, $ffa9
	ld a, [hl]
	and $1
	jr nz, .cancel
	ld a, [hl]
	and $20
	jr nz, .left
	ld a, [hl]
	and $10
	jr nz, .right
	jr .dotrick

.left
	ld a, $0
	ld [wcf63], a
	jr .dotrick

.right
	ld hl, StatusFlags
	bit 6, [hl]
	jr z, .left
.kanto
	ld a, $4
	ld [wcf63], a
	jr .dotrick

.cancel
	ld hl, StatusFlags
	bit 6, [hl]
	jr nz, .kanto
	ld a, $6
	ld [wcf63], a
.dotrick
	ld hl, $d700
	jp TrainerCardTrick

TrainerCardPage3_LoadGFX: ; 2524c (9:524c)
	call ClearSprites
	hlcoord 0, 8
	ld d, $6
	call Function253b0
	call WaitBGMap
	ld de, LeaderGFX2
	ld hl, $9290
	lb bc, BANK(LeaderGFX2), $56
	; ld a, [StatusFlags]
	; bit 5, a
	; jr nz, .okay
	; ld de, LeaderGFX3
; .okay
	call Request2bpp
	ld a, [StatusFlags]
	bit 5, a
	call z, LoadBadgeNumberIcons_EarlyGameKanto
	ld de, BadgeGFX2
	ld hl, $8000
	lb bc, BANK(BadgeGFX2), $2c
	call Request2bpp
	call Function2536c
	call TrainerCardNext
	ret

TrainerCardPage3_WaitJoypad: ; 25279 (9:5279)
	ld hl, KantoBadgesOAM
	call Function25438
	ld hl, $ffa9
	ld a, [hl]
	and $20
	jr nz, .left
	ld a, [hl]
	and $10
	jr nz, .right
	ld a, [hl]
	and $1
	jr nz, .quit
	jr .dotrick

.left
	ld hl, StatusFlags
	bit 5, [hl]
	jr z, .right
	ld a, $2
	ld [wcf63], a
	jr .dotrick

; .asm_25293
	; ld hl, StatusFlags
	; bit 5, [hl]
	; jr z, .dotrick
.right
	ld a, $0
	ld [wcf63], a
	jr .dotrick

.quit
	ld a, $6
	ld [wcf63], a
.dotrick
	ld hl, $d720

TrainerCardTrick:
; Since there were 8 gym leaders displayed in the card and
; all of them have their unique palettes, it's not possible
; to have all of them at once normally due to palette memory limit
; so some of the LCD scanline tricks needs to be applied here ;)

cardtrick: MACRO
; wait until line transfer state
.wait\@
	ld a, [rSTAT]
	and 3
	cp 3
	jr nz, .wait\@
	; wait until HBlank of the next line
	rept 4
	push af
	pop af
	endr
	and a
	; time to copy the palettes
	ld a, (\1 * 8) + $82
	ld [rBGPI], a
	rept 4
	ld a, [hli]
	ld [$ff00+c], a
	endr
ENDM

	ld a, 1 ; VBlank only
	ld [rIE], a
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a
	ld c, rBGPD - rJOYP
; wait until line 80
.wait80
	ld a, [rLY]
	cp 80
	jr nz, .wait80
	cardtrick 4
	cardtrick 5
	cardtrick 6
	cardtrick 7
; wait until line 104
.wait104
	ld a, [rLY]
	cp 104
	jr nz, .wait104
	cardtrick 4
	cardtrick 5
	cardtrick 6
	cardtrick 7
	pop af
	ld [rSVBK], a
	ld a, $f
	ld [rIE], a
	ret

Function25299: ; 25299 (9:5299)
	hlcoord 0, 0
	ld d, $5
	call Function253b0
	hlcoord 2, 2
	ld de, String_252ec
	call PlaceString
	hlcoord 2, 4
	ld de, Tilemap_252f9
	call Function253a8
	hlcoord 7, 2
	ld de, PlayerName
	call PlaceString
	hlcoord 5, 4
	ld de, PlayerID
	ld bc, $8205
	call PrintNum
	hlcoord 7, 6
	ld de, Money
	ld bc, $2306
	call PrintNum
	hlcoord 1, 3
	ld de, Tilemap_252fc
	call Function253a8
	hlcoord 14, 1
	ld bc, $507
	xor a
	ld [$ffad], a
	predef FillBox
	ret
; 252ec (9:52ec)

String_252ec: ; 252ec
	db "NAME/", $4e
	db $4e
	db "MONEY@"
Tilemap_252f9: ; 252f9
	db $27, $28, $ff ; ID NO
Tilemap_252fc: ; 252fc
	db $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $25, $26, $ff ; ____________>
; 2530a

Function2530a: ; 2530a (9:530a)
	hlcoord 2, 10
	ld de, String_2534c
	call PlaceString
	hlcoord 10, 15
	ld de, String_2535c
	call PlaceString
	ld hl, PokedexCaught
	ld b, $20
	call CountSetBits
	ld de, wd265
	hlcoord 15, 10
	ld bc, $103
	call PrintNum
	call Function25415
	hlcoord 2, 8
	ld de, Tilemap_25366
	call Function253a8
	ld a, [StatusFlags]
	bit 0, a
	ret nz
	hlcoord 1, 9
	ld bc, $211
	call ClearBox
	ret
; 2534c (9:534c)

String_2534c: ; 2534c
	db "#DEX", $4e
	db "PLAY TIME@"
String_2535b: ; 2535b
	db "@"
String_2535c: ; 2535c
	db "  BADGES▶@"
Tilemap_25366: ; 25366
	db $29, $2a, $2b, $2c, $2d, $ff
; 2536c

Function2536c: ; 2536c (9:536c)
	hlcoord 2, 8
	ld de, Tilemap_253a2
	call Function253a8
	hlcoord 2, 10
	ld a, $29
	ld c, $4
.asm_2537c
	call Function253f4
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_2537c
	hlcoord 2, 13
	ld a, $51
	ld c, $4
.asm_2538d
	call Function253f4
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_2538d
	xor a
	ld [wcf64], a
	ld a, [wcf63]
	cp $5
	ld hl, KantoBadgesOAM
	jr c, .Johto
	ld hl, Unknown_254c9
.Johto
	call Function25448
	ret
; 253a2 (9:53a2)

Tilemap_253a2: ; 253a2
	db $79, $7a, $7b, $7c, $7d, $ff ; "BADGES"
; 253a8

Function253a8: ; 253a8 (9:53a8)
	ld a, [de]
	cp $ff
	ret z
	ld [hli], a
	inc de
	jr Function253a8

Function253b0: ; 253b0 (9:53b0)
	ld e, $14
.asm_253b2
	ld a, $23
	ld [hli], a
	dec e
	jr nz, .asm_253b2
	ld a, $23
	ld [hli], a
	ld e, $11
	ld a, $7f
.asm_253bf
	ld [hli], a
	dec e
	jr nz, .asm_253bf
	ld a, $1c
	ld [hli], a
	ld a, $23
	ld [hli], a
.asm_253c9
	ld a, $23
	ld [hli], a
	ld e, $12
	ld a, $7f
.asm_253d0
	ld [hli], a
	dec e
	jr nz, .asm_253d0
	ld a, $23
	ld [hli], a
	dec d
	jr nz, .asm_253c9
	ld a, $23
	ld [hli], a
	ld a, $24
	ld [hli], a
	ld e, $11
	ld a, $7f
.asm_253e4
	ld [hli], a
	dec e
	jr nz, .asm_253e4
	ld a, $23
	ld [hli], a
	ld e, $14
.asm_253ed
	ld a, $23
	ld [hli], a
	dec e
	jr nz, .asm_253ed
	ret

Function253f4: ; 253f4 (9:53f4)
	push de
	push hl
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld de, $11
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld de, $11
	add hl, de
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	pop hl
	pop de
	ret

Function25415: ; 25415 (9:5415)
	hlcoord 8, 13
	ld de, GameTimeHours
	ld bc, $204
	call PrintNum
	ld a, $2e
	ld [hli], a
	ld de, GameTimeMinutes
	ld bc, $8102
	call PrintNum
	ld a, $2e
	ld [hli], a
	ld de, GameTimeSeconds
	ld bc, $8102
	jp PrintNum

Function25438: ; 25438 (9:5438)
	ld a, [$ff9b]
	and $7
	ret nz
	ld a, [wcf64]
	inc a
	and $7
	ld [wcf64], a
	jr Function25448

Function25448: ; 25448 (9:5448)
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	ld c, a
	ld de, Sprites
	ld b, 8
.asm_25453
	srl c
	push bc
	jr nc, .asm_25472
	push hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push bc
	push de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr z, .norematch
	ld a, 1
.norematch
	ld [wcf66], a
	pop hl
	pop de
	pop bc
	ld a, [wcf64]
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hl]
	ld [wcf65], a
	call Function2547b
	pop hl
.asm_25472
	ld bc, $c
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_25453
	ret
; a hacky method to get rid of unanimated badges
	ld h, d
	ld l, e
.loop
	ld a, l
	cp $80
	ret z
	xor a
	ld [hli], a
	jr .loop


Function2547b: ; 2547b (9:547b)
	ld a, [wcf65]
	and $80
	jr nz, .asm_25487
	ld hl, Unknown_254a7
	jr .asm_2548a

.asm_25487
	ld hl, Unknown_254b8
.asm_2548a
	ld a, [hli]
	cp $ff
	ret z
	add b
	ld [de], a
	inc de
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [wcf65]
	and $7f
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [wcf66]
	add [hl]
	ld [de], a
	inc hl
	inc de
	jr .asm_2548a
; 254a7 (9:54a7)

Unknown_254a7: ; 254a7
	db $00, $00, $00, $00
	db $00, $08, $01, $00
	db $08, $00, $02, $00
	db $08, $08, $03, $00
	db $ff
Unknown_254b8: ; 254b8
	db $00, $00, $01, $20
	db $00, $08, $00, $20
	db $08, $00, $03, $20
	db $08, $08, $02, $20
	db $ff
Unknown_254c9: ; 254c9
; Template OAM data for each badge on the trainer card.
; Format:

	; y, x
	; rematch event flag
	; cycle 1: face tile, in1 tile, in2 tile, in3 tile
	; cycle 2: face tile, in1 tile, in2 tile, in3 tile
	dw JohtoBadges
	; Zephyrbadge
	db $68, $18
	dw EVENT_FALKNER_REMATCH
	db $00, $20, $24, $20 | $80
	db $00, $20, $24, $20 | $80

	; Hivebadge
	db $68, $38
	dw EVENT_BUGSY_REMATCH
	db $04, $20, $24, $20 | $80
	db $04, $20, $24, $20 | $80

	; Plainbadge
	db $68, $58
	dw EVENT_WHITNEY_REMATCH
	db $08, $20, $24, $20 | $80
	db $08, $20, $24, $20 | $80

	; Fogbadge
	db $68, $78
	dw EVENT_MORTY_REMATCH
	db $0c, $20, $24, $20 | $80
	db $0c, $20, $24, $20 | $80

	; Mineralbadge
	db $80, $58
	dw EVENT_JASMINE_REMATCH
	db $14, $20, $24, $20 | $80
	db $14, $20, $24, $20 | $80

	; Stormbadge
	db $80, $38
	dw EVENT_CHUCK_REMATCH
	db $10, $20, $24, $20 | $80
	db $10, $20, $24, $20 | $80

	; Glacierbadge
	db $80, $18
	dw EVENT_PRYCE_REMATCH
	db $18, $20, $24, $20 | $80
	db $18, $20, $24, $20 | $80

	; Risingbadge
	; X-flips on alternate cycles.
	db $80, $78
	dw EVENT_CLAIR_REMATCH
	db $1c, $20, $24, $20 | $80
	db $1c | $80, $20, $24, $20 | $80
; 25523

KantoBadgesOAM:
	dw KantoBadges
	; Boulderbadge
	db $68, $18
	dw EVENT_BROCK_REMATCH
	db $00, $20, $24, $20 | $80
	db $00, $20, $24, $20 | $80
	; Cascadebadge
	db $68, $38
	dw EVENT_MISTY_REMATCH
	db $04, $20, $24, $20 | $80
	db $04, $20, $24, $20 | $80
	; Thunderbadge
	db $68, $58
	dw EVENT_SURGE_REMATCH
	db $08, $20, $24, $20 | $80
	db $08, $20, $24, $20 | $80
	; Rainbowbadge
	db $68, $78
	dw EVENT_ERIKA_REMATCH
	db $0c, $20, $24, $20 | $80
	db $0c, $20, $24, $20 | $80
	; Soulbadge
	; X-flips on alternate cycles.
	db $80, $18
	dw EVENT_JANINE_REMATCH
	db $10, $20, $24, $20 | $80
	db $10 | $80, $20, $24, $20 | $80
	; Marshbadge
	db $80, $38
	dw EVENT_SABRINA_REMATCH
	db $14, $20, $24, $20 | $80
	db $14, $20, $24, $20 | $80
	; Volcanobadge
	db $80, $58
	dw EVENT_BLAINE_REMATCH
	db $18, $20, $24, $20 | $80
	db $18, $20, $24, $20 | $80
	; Earthbadge
	; X-flips on alternate cycles.
	db $80, $78
	dw EVENT_BLUE_REMATCH
	db $1c, $20, $24, $20 | $80
	db $1c | $80, $20, $24, $20 | $80
; 25523

LoadBadgeNumberIcons_EarlyGameKanto:
	ld a, 8
	ld de, LeaderGFX
	ld hl, $9290
.loop
	push af
	push hl
	push de
	lb bc, BANK(LeaderGFX), 1
	call Request2bpp
	ld bc, $a0
	pop hl
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	add hl, bc
	pop af
	dec a
	jr nz, .loop
	ld de, LeaderGFX3
	ld hl, $9520
	lb bc, BANK(LeaderGFX3), 9
	call Request2bpp
	ld de, LeaderGFX3 + $90
	ld hl, $9700
	lb bc, BANK(LeaderGFX3), 9
	call Request2bpp
	ret

CardStatusGFX: INCBIN "gfx/misc/card_status.2bpp"

LeaderGFX:  INCLUDE "gfx/misc/johto_leaders.asm"
LeaderGFX2: INCLUDE "gfx/misc/kanto_leaders.asm"
LeaderGFX3: INCLUDE "gfx/misc/egk_leaders.asm"

BadgeGFX:   INCBIN "gfx/misc/badges.w16.2bpp"

BadgeGFX2:  INCBIN "gfx/misc/kantobadges.w16.2bpp"

CardRightCornerGFX: INCBIN "gfx/misc/card_right_corner.2bpp"

; SECTION "Oak's PC", ROMX

ProfOaksPC: ; 0x265d3
	ld hl, OakPCText1
	call Function1d4f
	call YesNoBox
	jr c, .shutdown
	call ProfOaksPCBoot ; player chose "yes"?
.shutdown
	ld hl, OakPCText4
	call PrintText
	call Functiona36
	call Function1c07 ;unload top menu on menu stack
	ret
; 0x265ee

ProfOaksPCBoot: ; 0x265ee
	ld hl, OakPCText2
	call PrintText
	call Rate
	call PlaySFX ; sfx loaded by previous Rate function call
	call Functiona36
	call WaitSFX
	ret
; 0x26601

Function26601: ; 0x26601
	call Rate
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	pop de
	call PlaySFX
	call Functiona36
	call WaitSFX
	ret
; 0x26616

Rate: ; 0x26616
; calculate Seen/Owned

	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	call CountSetBits
	ld [DefaultFlypoint], a
	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	ld [wd003], a
; print appropriate rating

	call ClearOakRatingBuffers
	ld hl, OakPCText3
	call PrintText
	call Functiona36
	ld a, [wd003]
	ld hl, OakRatings
	call FindOakRating
	push de
	call PrintText
	pop de
	ret
; 0x26647

ClearOakRatingBuffers: ; 0x26647
	ld hl, StringBuffer3
	ld de, DefaultFlypoint
	call ClearOakRatingBuffer
	ld hl, StringBuffer4
	ld de, wd003
	call ClearOakRatingBuffer
	ret
; 0x2665a

ClearOakRatingBuffer: ; 0x2665a
	push hl
	ld a, "@"
	ld bc, $000d
	call ByteFill
	pop hl
	ld bc, $4103
	call PrintNum
	ret
; 0x2666b

FindOakRating: ; 0x2666b
; return sound effect in de
; return text pointer in hl

	nop
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr nc, .match
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop

.match
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 0x2667f

OakRatings: ; 0x2667f
; db count (if number caught ≤ this number, then this entry is used)
; dw sound effect
; dw text pointer

	db 9
	dw SFX_DEX_FANFARE_LESS_THAN_20
	dw OakRating01
	db 19
	dw SFX_DEX_FANFARE_LESS_THAN_20
	dw OakRating02
	db 34
	dw SFX_DEX_FANFARE_20_49
	dw OakRating03
	db 49
	dw SFX_DEX_FANFARE_20_49
	dw OakRating04
	db 64
	dw SFX_DEX_FANFARE_50_79
	dw OakRating05
	db 79
	dw SFX_DEX_FANFARE_50_79
	dw OakRating06
	db 94
	dw SFX_DEX_FANFARE_80_109
	dw OakRating07
	db 109
	dw SFX_DEX_FANFARE_80_109
	dw OakRating08
	db 124
	dw SFX_CAUGHT_MON
	dw OakRating09
	db 139
	dw SFX_CAUGHT_MON
	dw OakRating10
	db 154
	dw SFX_DEX_FANFARE_140_169
	dw OakRating11
	db 169
	dw SFX_DEX_FANFARE_140_169
	dw OakRating12
	db 184
	dw SFX_DEX_FANFARE_170_199
	dw OakRating13
	db 199
	dw SFX_DEX_FANFARE_170_199
	dw OakRating14
	db 214
	dw SFX_DEX_FANFARE_200_229
	dw OakRating15
	db 229
	dw SFX_DEX_FANFARE_200_229
	dw OakRating16
	db 239
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating17
	db 248
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating18
	db 250
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRatingNearlyThere
	db 251
	dw SFX_DEX_FANFARE_230_PLUS
	dw OakRating19

OakPCText1: ; 0x266de
	TX_FAR _OakPCText1
	db "@"
OakPCText2: ; 0x266e3
	TX_FAR _OakPCText2
	db "@"
OakPCText3: ; 0x266e8
	TX_FAR _OakPCText3
	db "@"
OakRating01:
	TX_FAR _OakRating01
	db "@"
OakRating02:
	TX_FAR _OakRating02
	db "@"
OakRating03:
	TX_FAR _OakRating03
	db "@"
OakRating04:
	TX_FAR _OakRating04
	db "@"
OakRating05:
	TX_FAR _OakRating05
	db "@"
OakRating06:
	TX_FAR _OakRating06
	db "@"
OakRating07:
	TX_FAR _OakRating07
	db "@"
OakRating08:
	TX_FAR _OakRating08
	db "@"
OakRating09:
	TX_FAR _OakRating09
	db "@"
OakRating10:
	TX_FAR _OakRating10
	db "@"
OakRating11:
	TX_FAR _OakRating11
	db "@"
OakRating12:
	TX_FAR _OakRating12
	db "@"
OakRating13:
	TX_FAR _OakRating13
	db "@"
OakRating14:
	TX_FAR _OakRating14
	db "@"
OakRating15:
	TX_FAR _OakRating15
	db "@"
OakRating16:
	TX_FAR _OakRating16
	db "@"
OakRating17:
	TX_FAR _OakRating17
	db "@"
OakRating18:
	TX_FAR _OakRating18
	db "@"
OakRatingNearlyThere:
	TX_FAR _OakRatingNearlyThere
	db "@"
OakRating19:
	TX_FAR _OakRating19
	db "@"
OakPCText4: ; 0x2674c
	TX_FAR _OakPCText4
	db "@"
Function26751: ; 26751 (9:6751)
	ld a, $2
	ld [wdc0f], a
	ld a, $10
	ld [wdc12], a
	ret

_KrisDecorationMenu: ; 0x2675c
	ld a, [wcf76]
	push af
	ld hl, MenuDataHeader_0x2679a
	call LoadMenuDataHeader
	xor a
	ld [wd1ee], a
	ld a, $1
	ld [wd1ef], a
.asm_2676f
	ld a, [wd1ef]
	ld [wcf88], a
	call Function26806
	call Function1e5d
	ld a, [wcfa9]
	ld [wd1ef], a
	jr c, .asm_2678e
	ld a, [MenuSelection]
	ld hl, Unknown_267aa
	call Function1fa7
	jr nc, .asm_2676f
.asm_2678e
	call Function1c07 ;unload top menu on menu stack
	pop af
	ld [wcf76], a
	ld a, [wd1ee]
	ld c, a
	ret
; 0x2679a

MenuDataHeader_0x2679a: ; 0x2679a
	db $40 ; flags
	db 00, 05 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0x267a2
	db 1 ; default option
; 0x267a2

MenuData2_0x267a2: ; 0x267a2
	db $a0 ; flags
	db 0 ; items
	dw wd002
	dw Function1f8d
	dw Unknown_267aa
; 0x267aa

Unknown_267aa: ; 267aa
	dw Function268b5, .bed
	dw Function268ca, .carpet
	dw Function268df, .plant
	dw Function268f3, .poster
	dw Function26908, .game
	dw Function2691d, .ornament
	dw Function26945, .big_doll
	dw Function26959, .exit
.bed      db "BED@"
.carpet   db "CARPET@"
.plant    db "PLANT@"
.poster   db "POSTER@"
.game     db "GAME CONSOLE@"
.ornament db "ORNAMENT@"
.big_doll db "BIG DOLL@"
.exit     db "EXIT@"
; 26806

Function26806: ; 26806
	xor a
	ld [wcf76], a
	call Function26822
	call Function2683a
	ld a, $7
	call Function26830
	ld hl, StringBuffer2
	ld de, DefaultFlypoint
	ld bc, $d
	call CopyBytes
	ret

Function26822: ; 26822 (9:6822)
	ld hl, StringBuffer2
	xor a
	ld [hli], a
	ld bc, $c
	ld a, $ff
	call ByteFill
	ret

Function26830: ; 26830 (9:6830)
	ld hl, StringBuffer2
	inc [hl]
	ld e, [hl]
	ld d, 0
	add hl, de
	ld [hl], a
	ret

Function2683a: ; 2683a (9:683a)
	ld hl, Jumptable_26855
.asm_2683d
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	jr z, .asm_26854
	push hl
	call _de_
	pop hl
	jr nc, .asm_26851
	ld a, [hl]
	push hl
	call Function26830
	pop hl
.asm_26851
	inc hl
	jr .asm_2683d

.asm_26854
	ret
; 26855 (9:6855)

Jumptable_26855: ; 26855
	dwb Function268bd, 0 ; bed
	dwb Function268d2, 1 ; carpet
	dwb Function268e7, 2 ; plant
	dwb Function268fb, 3 ; poster
	dwb Function26910, 4 ; game console
	dwb Function26925, 5 ; ornament
	dwb Function2694d, 6 ; big doll
	dw 0 ; end
; 2686c

Function2686c: ; 2686c
	xor a
	ld hl, DefaultFlypoint
	ld [hli], a
	ld a, $ff
	ld bc, $0010
	call ByteFill
	ret
; 2687a

Function2687a: ; 2687a
.asm_2687a
	ld a, [hli]
	cp $ff
	jr z, .asm_26890
	push hl
	push af
	ld b, $2
	call Function26a3b
	ld a, c
	and a
	pop bc
	ld a, b
	call nz, Function26891
	pop hl
	jr .asm_2687a

.asm_26890
	ret
; 26891

Function26891: ; 26891
	ld hl, DefaultFlypoint
	inc [hl]
	ld e, [hl]
	ld d, $0
	add hl, de
	ld [hl], a
	ret
; 2689b

Function2689b: ; 2689b
	push bc
	push hl
	call Function2686c
	pop hl
	call Function2687a
	pop bc
	ld a, [DefaultFlypoint]
	and a
	ret z
	ld a, c
	call Function26891
	ld a, $0
	call Function26891
	scf
	ret
; 268b5

Function268b5: ; 268b5
	call Function268bd
	call Function2695b
	xor a
	ret
; 268bd

Function268bd: ; 268bd
	ld hl, Unknown_268c5
	ld c, 1
	jp Function2689b
; 268c5

Unknown_268c5: ; 268c5
	db 2, 3, 4, 5, $ff
; 268ca

Function268ca: ; 268ca
	call Function268d2
	call Function2695b
	xor a
	ret
; 268d2

Function268d2: ; 268d2
	ld hl, Unknown_268da
	ld c, 6
	jp Function2689b
; 268da

Unknown_268da: ; 268da
	db 7, 8, 9, 10, $ff
; 268df

Function268df: ; 268df
	call Function268e7
	call Function2695b
	xor a
	ret
; 268e7

Function268e7: ; 268e7
	ld hl, Unknown_268ef
	ld c, 11
	jp Function2689b
; 268ef

Unknown_268ef: ; 268ef
	db 12, 13, 14, $ff
; 268f3

Function268f3: ; 268f3
	call Function268fb
	call Function2695b
	xor a
	ret
; 268fb

Function268fb: ; 268fb
	ld hl, Unknown_26903
	ld c, 15
	jp Function2689b
; 26903

Unknown_26903: ; 26903
	db 16, 17, 18, 19, $ff
; 26908

Function26908: ; 26908
	call Function26910
	call Function2695b
	xor a
	ret
; 26910

Function26910: ; 26910
	ld hl, Unknown_26918
	ld c, 20
	jp Function2689b
; 26918

Unknown_26918: ; 26918
	db 21, 22, 23, 24, $ff
; 2691d

Function2691d: ; 2691d
	call Function26925
	call Function2695b
	xor a
	ret
; 26925

Function26925: ; 26925
	ld hl, Unknown_2692d
	ld c, 29
	jp Function2689b
; 2692d

Unknown_2692d: ; 2692d
	db 30, 31, 32, 33, 34, 35, 36, 37, 38, 39
	db 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
	db 50, 51, 52, $ff
; 26945

Function26945: ; 26945
	call Function2694d
	call Function2695b
	xor a
	ret
; 2694d

Function2694d: ; 2694d
	ld hl, Unknown_26955
	ld c, 25
	jp Function2689b
; 26955

Unknown_26955: ; 26955
	db 26, 27, 28, $ff
; 26959

Function26959: ; 26959
	scf
	ret
; 2695b

Function2695b: ; 2695b
	ld a, [DefaultFlypoint]
	and a
	jr z, .asm_269a9
	cp $8
	jr nc, .asm_2697b
	xor a
	ld [wcf76], a
	ld hl, MenuDataHeader_0x269b5
	call LoadMenuDataHeader
	call Function1e5d
	jr c, .asm_26977
	call Function26a02
.asm_26977
	call Function1c07 ;unload top menu on menu stack
	ret

.asm_2697b
	ld hl, DefaultFlypoint
	ld e, [hl]
	dec [hl]
	ld d, $0
	add hl, de
	ld [hl], $ff
	call Function1d6e
	ld hl, MenuDataHeader_0x269c5
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function352f
	xor a
	ld [wd0e4], a
	call Function350c
	ld a, [wcf73]
	cp $2
	jr z, .asm_269a5
	call Function26a02
.asm_269a5
	call Function1c07
	ret

.asm_269a9
	ld hl, UnknownText_0x269b0
	call Function1d67
	ret
; 269b0

UnknownText_0x269b0: ; 0x269b0
	; There's nothing to choose.
	text_jump UnknownText_0x1bc471
	db "@"
; 0x269b5

MenuDataHeader_0x269b5: ; 0x269b5
	db $40 ; flags
	db 00, 00 ; start coords
	db 17, 19 ; end coords
	dw MenuData2_0x269bd
	db 1 ; default option
; 0x269bd

MenuData2_0x269bd: ; 0x269bd
	db $a0 ; flags
	db 0 ; items
	dw wd002
	dw Function269f3
	dw DecorationAttributes
; 0x269c5

MenuDataHeader_0x269c5: ; 0x269c5
	db $40 ; flags
	db 01, 01 ; start coords
	db 16, 18 ; end coords
	dw MenuData2_0x269cd
	db 1 ; default option
; 0x269cd

MenuData2_0x269cd: ; 0x269cd
	db $10 ; flags
	db 8, 0 ; rows, columns
	db 1 ; horizontal spacing
	dbw 0, wd002 ; text pointer
	dbw BANK(Function269f3), Function269f3
	dbw 0, 0
	dbw 0, 0
; 269dd

Function269dd: ; 269dd
	ld hl, DecorationAttributes
	ld bc, $0006
	call AddNTimes
	ret
; 269e7

Function269e7: ; 269e7
	push hl
	call Function269dd
	call Function26c72
	pop hl
	call CopyName2
	ret
; 269f3

Function269f3: ; 269f3
	ld a, [MenuSelection]
	push de
	call Function269dd
	call Function26c72
	pop hl
	call PlaceString
	ret
; 26a02

Function26a02: ; 26a02
	ld a, [MenuSelection]
	call Function269dd
	ld de, $0002
	add hl, de
	ld a, [hl]
	ld hl, Jumptable_26a12
	rst JumpTable
	ret
; 26a12

Jumptable_26a12: ; 26a12
	dw Function26ce3
	dw Function26ce5
	dw Function26ceb
	dw Function26cf1
	dw Function26cf7
	dw Function26cfd
	dw Function26d03
	dw Function26d09
	dw Function26d0f
	dw Function26d15
	dw Function26d1b
	dw Function26d21
	dw Function26d27
	dw Function26db3
	dw Function26dc9
; 26a30

Function26a30: ; 26a30
	call Function269dd
	ld de, $0003
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret
; 26a3b

Function26a3b: ; 26a3b
	push bc
	call Function26a30
	pop bc
	call EventFlagAction
	ret
; 26a44

Function26a44: ; 26a44
	ld a, c
	call Function269dd
	ld de, $0005
	add hl, de
	ld a, [hl]
	ld c, a
	ret
; 26a4f

DecorationAttributes: ; 26a4f
	db $01, $00, $00, $00, $00, $00
	db $01, $01, $02, $00, $00, $00
	db $02, $12, $01, $a4, $02, $1b
	db $02, $14, $01, $a5, $02, $1c
	db $02, $15, $01, $a6, $02, $1d
	db $02, $13, $01, $a7, $02, $1e
	db $01, $01, $04, $00, $00, $00
	db $03, $16, $03, $a8, $02, $08
	db $03, $17, $03, $a9, $02, $0b
	db $03, $18, $03, $aa, $02, $0e
	db $03, $19, $03, $ab, $02, $11
	db $01, $01, $06, $00, $00, $00
	db $01, $02, $05, $ac, $02, $20
	db $01, $03, $05, $ad, $02, $21
	db $01, $04, $05, $ae, $02, $22
	db $01, $01, $08, $00, $00, $00
	db $01, $05, $07, $af, $02, $1f
	db $04, $19, $07, $b0, $02, $23
	db $04, $23, $07, $b1, $02, $24
	db $04, $27, $07, $b2, $02, $25
	db $01, $01, $0a, $00, $00, $00
	db $01, $06, $09, $b3, $02, $5c
	db $01, $07, $09, $b4, $02, $5b
	db $01, $08, $09, $b5, $02, $51
	db $01, $09, $09, $b6, $02, $57
	db $01, $01, $0c, $00, $00, $00
	db $06, $8f, $0b, $cf, $02, $33
	db $06, $5f, $0b, $d0, $02, $50
	db $06, $83, $0b, $d1, $02, $47
	db $01, $01, $0e, $00, $00, $00
	db $05, $19, $0d, $b7, $02, $8e
	db $01, $0c, $0d, $b8, $02, $34
	db $05, $23, $0d, $b9, $02, $8f
	db $05, $27, $0d, $ba, $02, $94
	db $05, $01, $0d, $bb, $02, $93
	db $05, $04, $0d, $bc, $02, $90
	db $05, $07, $0d, $bd, $02, $89
	db $05, $3c, $0d, $be, $02, $8d
	db $05, $32, $0d, $bf, $02, $8c
	db $05, $78, $0d, $c0, $02, $92
	db $05, $81, $0d, $c1, $02, $88
	db $05, $2b, $0d, $c2, $02, $85
	db $05, $5e, $0d, $c3, $02, $86
	db $05, $5a, $0d, $c4, $02, $84
	db $05, $58, $0d, $c5, $02, $95
	db $05, $64, $0d, $c6, $02, $9b
	db $05, $0d, $0d, $c7, $02, $83
	db $05, $c9, $0d, $c8, $02, $80
	db $05, $4a, $0d, $c9, $02, $81
	db $05, $42, $0d, $ca, $02, $9a
	db $05, $48, $0d, $cb, $02, $98
	db $01, $0a, $0d, $cd, $02, $5e
	db $01, $0b, $0d, $ce, $02, $5f
; 26b8d

DecorationNames: ; 26b8d
	db "CANCEL@"
	db "PUT IT AWAY@"
	db "MAGNAPLANT@"
	db "TROPICPLANT@"
	db "JUMBOPLANT@"
	db "TOWN MAP@"
	db "NES@"
	db "SUPER NES@"
	db "NINTENDO 64@"
	db "VIRTUAL BOY@"
	db "GOLD TROPHY@"
	db "SILVER TROPHY@"
	db "SURF PIKACHU DOLL@"
	db " BED@"
	db " CARPET@"
	db " POSTER@"
	db " DOLL@"
	db "BIG @"
	db "FEATHERY@"
	db "PIKACHU@"
	db "PINK@"
	db "POLKADOT@"
	db "RED@"
	db "BLUE@"
	db "YELLOW@"
	db "GREEN@"
; 26c72

Function26c72: ; 26c72
	ld a, [hli]
	ld e, [hl]
	ld bc, StringBuffer2
	push bc
	ld hl, Table26c7e
	rst JumpTable
	pop de
	ret
; 26c7e

Table26c7e: ; 26c7e
	dw Function26c8c
	dw Function26c8d
	dw Function26c90
	dw Function26c97
	dw Function26c9e
	dw Function26ca6
	dw Function26cae
; 26c8c

Function26c8c: ; 26c8c
	ret
; 26c8d

Function26c8d: ; 26c8d
	ld a, e
	jr Function26cca

Function26c90: ; 26c90
	call Function26c8d
	ld a, $d
	jr Function26cca

Function26c97: ; 26c97
	call Function26c8d
	ld a, $e
	jr Function26cca

Function26c9e: ; 26c9e
	ld a, e
	call Function26cc0
	ld a, $f
	jr Function26cca

Function26ca6: ; 26ca6
	ld a, e
	call Function26cc0
	ld a, $10
	jr Function26cca

Function26cae: ; 26cae
	push de
	ld a, $11
	call Function26cca
	pop de
	ld a, e
	jr Function26cc0

Function26cb8: ; 26cb8
	push de
	call Function26cca
	pop de
	ld a, e
	jr Function26cca

Function26cc0: ; 26cc0
	push bc
	ld [wd265], a
	call GetPokemonName
	pop bc
	jr Function26cda

Function26cca: ; 26cca
	call Function26ccf
	jr Function26cda

Function26ccf: ; 26ccf
	push bc
	ld hl, DecorationNames
	call GetNthString
	ld d, h
	ld e, l
	pop bc
	ret

Function26cda: ; 26cda
	ld h, b
	ld l, c
	call CopyName2
	dec hl
	ld b, h
	ld c, l
	ret
; 26ce3

Function26ce3: ; 26ce3
	scf
	ret
; 26ce5

Function26ce5: ; 26ce5
	ld hl, Bed
	jp Function26d2d
; 26ceb

Function26ceb: ; 26ceb
	ld hl, Bed
	jp Function26d86
; 26cf1

Function26cf1: ; 26cf1
	ld hl, Carpet
	jp Function26d2d
; 26cf7

Function26cf7: ; 26cf7
	ld hl, Carpet
	jp Function26d86
; 26cfd

Function26cfd: ; 26cfd
	ld hl, Plant
	jp Function26d2d
; 26d03

Function26d03: ; 26d03
	ld hl, Plant
	jp Function26d86
; 26d09

Function26d09: ; 26d09
	ld hl, Poster
	jp Function26d2d
; 26d0f

Function26d0f: ; 26d0f
	ld hl, Poster
	jp Function26d86
; 26d15

Function26d15: ; 26d15
	ld hl, Console
	jp Function26d2d
; 26d1b

Function26d1b: ; 26d1b
	ld hl, Console
	jp Function26d86
; 26d21

Function26d21: ; 26d21
	ld hl, BigDoll
	jp Function26d2d
; 26d27

Function26d27: ; 26d27
	ld hl, BigDoll
	jp Function26d86
; 26d2d

Function26d2d: ; 26d2d
	ld a, [hl]
	ld [Buffer1], a
	push hl
	call Function26d46
	jr c, .asm_26d43
	ld a, $1
	ld [wd1ee], a
	pop hl
	ld a, [MenuSelection]
	ld [hl], a
	xor a
	ret

.asm_26d43
	pop hl
	xor a
	ret
; 26d46

Function26d46: ; 26d46
	ld a, [Buffer1]
	and a
	jr z, .asm_26d6d
	ld b, a
	ld a, [MenuSelection]
	cp b
	jr z, .asm_26d7e
	ld a, [MenuSelection]
	ld hl, StringBuffer4
	call Function269e7
	ld a, [Buffer1]
	ld hl, StringBuffer3
	call Function269e7
	ld hl, UnknownText_0x26ee0
	call Function1d67
	xor a
	ret

.asm_26d6d
	ld a, [MenuSelection]
	ld hl, StringBuffer3
	call Function269e7
	ld hl, UnknownText_0x26edb
	call Function1d67
	xor a
	ret

.asm_26d7e
	ld hl, UnknownText_0x26ee5
	call Function1d67
	scf
	ret
; 26d86

Function26d86: ; 26d86
	ld a, [hl]
	ld [Buffer1], a
	xor a
	ld [hl], a
	ld a, [Buffer1]
	and a
	jr z, .asm_26dab
	ld a, $1
	ld [wd1ee], a
	ld a, [Buffer1]
	ld [MenuSelection], a
	ld hl, StringBuffer3
	call Function269e7
	ld hl, UnknownText_0x26ed1
	call Function1d67
	xor a
	ret

.asm_26dab
	ld hl, UnknownText_0x26ed6
	call Function1d67
	xor a
	ret
; 26db3

Function26db3: ; 26db3
	ld hl, UnknownText_0x26e41
	call Function26e70
	jr c, .asm_26dc7
	call Function26de3
	jr c, .asm_26dc7
	ld a, $1
	ld [wd1ee], a
	jr Function26dd6

.asm_26dc7
	xor a
	ret

Function26dc9: ; 26dc9
	ld hl, UnknownText_0x26e6b
	call Function26e70
	jr nc, .asm_26dd3
	xor a
	ret

.asm_26dd3
	call Function26e46
Function26dd6: ; 26dd6
	call Function26e9a
	ld a, [wd1ec]
	ld [hl], a
	ld a, [wd1ed]
	ld [de], a
	xor a
	ret
; 26de3

Function26de3: ; 26de3
	ld a, [wd1ec]
	and a
	jr z, .asm_26e11
	ld b, a
	ld a, [MenuSelection]
	cp b
	jr z, .asm_26e2b
	ld a, b
	ld hl, StringBuffer3
	call Function269e7
	ld a, [MenuSelection]
	ld hl, StringBuffer4
	call Function269e7
	ld a, [MenuSelection]
	ld [wd1ec], a
	call Function26e33
	ld hl, UnknownText_0x26ee0
	call Function1d67
	xor a
	ret

.asm_26e11
	ld a, [MenuSelection]
	ld [wd1ec], a
	call Function26e33
	ld a, [MenuSelection]
	ld hl, StringBuffer3
	call Function269e7
	ld hl, UnknownText_0x26edb
	call Function1d67
	xor a
	ret

.asm_26e2b
	ld hl, UnknownText_0x26ee5
	call Function1d67
	scf
	ret
; 26e33

Function26e33: ; 26e33
	ld a, [MenuSelection]
	ld b, a
	ld a, [wd1ed]
	cp b
	ret nz
	xor a
	ld [wd1ed], a
	ret
; 26e41

UnknownText_0x26e41: ; 0x26e41
	; Which side do you want to put it on?
	text_jump UnknownText_0x1bc48c
	db "@"
; 0x26e46

Function26e46: ; 26e46
	ld a, [wd1ec]
	and a
	jr z, .asm_26e63
	ld hl, StringBuffer3
	call Function269e7
	ld a, $1
	ld [wd1ee], a
	xor a
	ld [wd1ec], a
	ld hl, UnknownText_0x26ed1
	call Function1d67
	xor a
	ret

.asm_26e63
	ld hl, UnknownText_0x26ed6
	call Function1d67
	xor a
	ret
; 26e6b

UnknownText_0x26e6b: ; 0x26e6b
	; Which side do you want to put away?
	text_jump UnknownText_0x1bc4b2
	db "@"
; 0x26e70

Function26e70: ; 26e70
	call Function1d4f
	ld hl, MenuDataHeader_0x26eab
	call Function1dab
	call Function1c07 ;unload top menu on menu stack
	call Function1c66
	jr c, .asm_26e98
	ld a, [wcfa9]
	cp $3
	jr z, .asm_26e98
	ld [Buffer2], a
	call Function26e9a
	ld a, [hl]
	ld [wd1ec], a
	ld a, [de]
	ld [wd1ed], a
	xor a
	ret

.asm_26e98
	scf
	ret
; 26e9a

Function26e9a: ; 26e9a
	ld hl, RightOrnament
	ld de, LeftOrnament
	ld a, [Buffer2]
	cp $1
	ret z
	push hl
	ld h, d
	ld l, e
	pop de
	ret
; 26eab

MenuDataHeader_0x26eab: ; 0x26eab
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 13 ; end coords
	dw MenuData2_0x26eb3
	db 1 ; default option
; 0x26eb3

MenuData2_0x26eb3: ; 0x26eb3
	db $80 ; flags
	db 3 ; items
	db "RIGHT SIDE@"
	db "LEFT SIDE@"
	db "CANCEL@"
; 0x26ed1

UnknownText_0x26ed1: ; 0x26ed1
	; Put away the @ .
	text_jump UnknownText_0x1bc4d7
	db "@"
; 0x26ed6

UnknownText_0x26ed6: ; 0x26ed6
	; There's nothing to put away.
	text_jump UnknownText_0x1bc4ec
	db "@"
; 0x26edb

UnknownText_0x26edb: ; 0x26edb
	; Set up the @ .
	text_jump UnknownText_0x1bc509
	db "@"
; 0x26ee0

UnknownText_0x26ee0: ; 0x26ee0
	; Put away the @ and set up the @ .
	text_jump UnknownText_0x1bc51c
	db "@"
; 0x26ee5

UnknownText_0x26ee5: ; 0x26ee5
	; That's already set up.
	text_jump UnknownText_0x1bc546
	db "@"
; 0x26eea

Function26eea: ; 26eea
	ld a, c
	ld h, d
	ld l, e
	call Function269e7
	ret
; 26ef1

Function26ef1: ; 26ef1
	ld a, c
	jp Function26a3b
; 26ef5

Function26ef5: ; 26ef5 (9:6ef5)
	ld a, c
	call Function26f0c
	ld hl, StringBuffer1
	push hl
	call Function269e7
	pop de
	ret

Function26f02: ; 26f02
	ld a, c
	call Function26f0c
	ld b, $1
	call Function26a3b
	ret
; 26f0c

Function26f0c: ; 26f0c
	push hl
	push de
	ld e, a
	ld d, 0
	ld hl, Unknown_26f2b
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret
; 26f19

Function26f19: ; 26f19
	ld hl, Unknown_26f2b
.asm_26f1c
	ld a, [hli]
	cp $ff
	jr z, .asm_26f2a
	push hl
	ld b, $1
	call Function26a3b
	pop hl
	jr .asm_26f1c

.asm_26f2a
	ret
; 26f2b

Unknown_26f2b: ; 26f2b
	db $02, $03, $04, $05, $07
	db $08, $09, $0a, $0c, $0d
	db $0e, $10, $11, $12, $13
	db $15, $16, $17, $18, $1e
	db $1f, $20, $21, $22, $23
	db $24, $25, $26, $27, $28
	db $29, $2a, $2b, $2c, $2d
	db $2e, $2f, $30, $31, $32
	db $1a, $1b, $1c, $33, $34
	db $ff
; 26f59

Function26f59:: ; 26f59
	ld a, b
	ld hl, Table26f5f
	rst JumpTable
	ret
; 26f5f

Table26f5f: ; 26f5f
	dw Function26f69
	dw Function26fb9
	dw Function26fbe
	dw Function26fdd
	dw Function26fc3
; 26f69

Function26f69: ; 26f69
	ld a, [Poster]
	ld hl, Unknown_26f84
	ld de, 3
	call IsInArray
	jr c, .asm_26f7d
	ld de, UnknownScript_0x26fb8
	ld b, BANK(UnknownScript_0x26fb8)
	ret

.asm_26f7d
	ld b, BANK(UnknownScript_0x26f91)
	inc hl
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ret
; 26f84

Unknown_26f84: ; 26f84
	dbw $10, UnknownScript_0x26f91
	dbw $11, UnknownScript_0x26fa0
	dbw $12, UnknownScript_0x26fa8
	dbw $13, UnknownScript_0x26fb0
	db $ff
; 26f91

UnknownScript_0x26f91: ; 0x26f91
	loadfont
	writetext UnknownText_0x26f9b
	waitbutton
	special Functionc2c0
	closetext
	end
; 0x26f9b

UnknownText_0x26f9b: ; 0x26f9b
	; It's the TOWN MAP.
	text_jump UnknownText_0x1bc55d
	db "@"
; 0x26fa0

UnknownScript_0x26fa0: ; 0x26fa0
	jumptext UnknownText_0x26fa3
; 0x26fa3

UnknownText_0x26fa3: ; 0x26fa3
	; It's a poster of a cute PIKACHU.
	text_jump UnknownText_0x1bc570
	db "@"
; 0x26fa8

UnknownScript_0x26fa8: ; 0x26fa8
	jumptext UnknownText_0x26fab
; 0x26fab

UnknownText_0x26fab: ; 0x26fab
	; It's a poster of a cute CLEFAIRY.
	text_jump UnknownText_0x1bc591
	db "@"
; 0x26fb0

UnknownScript_0x26fb0: ; 0x26fb0
	jumptext UnknownText_0x26fb3
; 0x26fb3

UnknownText_0x26fb3: ; 0x26fb3
	; It's a poster of a cute JIGGLYPUFF.
	text_jump UnknownText_0x1bc5b3
	db "@"
; 0x26fb8

UnknownScript_0x26fb8: ; 26fb8
	end
; 26fb9

Function26fb9: ; 26fb9
	ld a, [LeftOrnament]
	jr Function26fc8

Function26fbe: ; 26fbe
	ld a, [RightOrnament]
	jr Function26fc8

Function26fc3: ; 26fc3
	ld a, [Console]
	jr Function26fc8

Function26fc8: ; 26fc8
	ld c, a
	ld de, StringBuffer3
	call Function26eea
	ld b, BANK(Unknown_26fd5)
	ld de, Unknown_26fd5
	ret
; 26fd5

Unknown_26fd5: ; 26fd5
	dbw $53, UnknownText_0x26fd8
; 26fd8

UnknownText_0x26fd8: ; 0x26fd8
	; It's an adorable @ .
	text_jump UnknownText_0x1bc5d7
	db "@"
; 0x26fdd

Function26fdd: ; 26fdd
	ld b, BANK(Unknown_26fe3)
	ld de, Unknown_26fe3
	ret
; 26fe3

Unknown_26fe3: ; 26fe3
	dbw $53, UnknownText_0x26fe6
; 26fe6

UnknownText_0x26fe6: ; 0x26fe6
	; A giant doll! It's fluffy and cuddly.
	text_jump UnknownText_0x1bc5ef
	db "@"
; 0x26feb

Function26feb: ; 26feb
	ld de, $0004
	ld a, [Bed]
	call Function27037
	ld de, $0704
	ld a, [Plant]
	call Function27037
	ld de, $0600
	ld a, [Poster]
	call Function27037
	call Function27027
	ld de, $0000
	call Function27092
	ld a, [Carpet]
	and a
	ret z
	call Function27085
	ld [hl], a
	push af
	ld de, $0002
	call Function27092
	pop af
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	dec a
	ld [hl], a
	ret
; 27027

Function27027: ; 27027
	ld b, $1
	ld a, [Poster]
	and a
	jr nz, .asm_27031
	ld b, $0
.asm_27031
	ld de, $02cc
	jp EventFlagAction
; 27037

Function27037: ; 27037
	push af
	call Function27092
	pop af
	and a
	ret z
	call Function27085
	ld [hl], a
	ret
; 27043

Function27043: ; 27043
	ld de, $0741
	ld hl, VariableSprites
	ld a, [Console]
	call Function27074
	ld de, $0742
	ld hl, VariableSprites + 1
	ld a, [LeftOrnament]
	call Function27074
	ld de, $0743
	ld hl, VariableSprites + 2
	ld a, [RightOrnament]
	call Function27074
	ld de, $0744
	ld hl, VariableSprites + 3
	ld a, [BigDoll]
	call Function27074
	ret
; 27074

Function27074: ; 27074
	and a
	jr z, .asm_27080
	call Function27085
	ld [hl], a
	ld b, $0
	jp EventFlagAction

.asm_27080
	ld b, $1
	jp EventFlagAction
; 27085

Function27085: ; 27085
	ld c, a
	push de
	push hl
	callba Function26a44
	pop hl
	pop de
	ld a, c
	ret
; 27092

Function27092: ; 27092
	ld a, d
	add $4
	ld d, a
	ld a, e
	add $4
	ld e, a
	call Function2a66
	ret
; 2709e

Function2709e: ; 2709e
	ld a, [CurPartyMon]
	ld hl, PartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and $7f
	ld d, a
	ld a, [MapGroup]
	ld b, a
	ld a, [MapNumber]
	ld c, a
	call GetWorldMapLocation
	cp d
	ld c, $1
	jr nz, .asm_270bd
	ld c, $13
.asm_270bd
	callab ChangeHappiness
	ret
; 270c4

INCLUDE "trainers/dvs.asm"

Function2715c: ; 2715c
	call WhiteBGMap
	call ClearTileMap
	ld a, [BattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .asm_27171
	callba Function3f43d
	jr .asm_27177

.asm_27171
	callba GetBattleBackpic
.asm_27177
	callba Function3f47c
	callba Function3ed9f
	call ClearSGB
	call Function1c17
	call Function1d6e
	call WaitBGMap
	jp Function32f9
; 27192

Function27192: ; 27192
	push hl
	push de
	push bc
	ld a, [hBattleTurn]
	and a
	ld hl, OTPartyMon1Item
	ld de, EnemyMonItem
	ld a, [CurOTMon]
	jr z, .asm_271ac
	ld hl, PartyMon1Item
	ld de, BattleMonItem
	ld a, [CurBattleMon]
.asm_271ac
	push hl
	push af
	ld a, [de]
	ld b, a
	callba GetItem
	ld hl, Unknown_271de
.asm_271b9
	ld a, [hli]
	cp b
	jr z, .asm_271c6
	inc a
	jr nz, .asm_271b9
	pop af
	pop hl
	pop bc
	pop de
	pop hl
	ret

.asm_271c6
	xor a
	ld [de], a
	pop af
	pop hl
	call GetPartyLocation
	ld a, [hBattleTurn]
	and a
	jr nz, .asm_271d8
	ld a, [wBattleMode]
	dec a
	jr z, .asm_271da
.asm_271d8
	ld [hl], $0
.asm_271da
	pop bc
	pop de
	pop hl
	ret
; 271de

Unknown_271de: ; 271de
; Consumable items?

	db HELD_BERRY
	db $02
	db $05
	db HELD_HEAL_POISON
	db HELD_HEAL_FREEZE
	db HELD_HEAL_BURN
	db HELD_HEAL_SLEEP
	db HELD_HEAL_PARALYZE
	db HELD_HEAL_STATUS
	db $1e
	db HELD_ATTACK_UP
	db HELD_DEFENSE_UP
	db HELD_SPEED_UP
	db HELD_SP_ATTACK_UP
	db HELD_SP_DEFENSE_UP
	db HELD_ACCURACY_UP
	db HELD_EVASION_UP
	db $26
	db $47
	db HELD_ESCAPE
	db HELD_CRITICAL_UP
	db $ff
; 271f4

MoveEffectsPointers: ; 271f4
INCLUDE "battle/moves/move_effects_pointers.asm"

MoveEffects: ; 2732e
INCLUDE "battle/moves/move_effects.asm"

Function27a28: ; 27a28
	call Function2500e
	ld b, a
	ret
; 27a2d

SECTION "bankA", ROMX, BANK[$A]

Function28000: ; 28000
	call WhiteBGMap
	ld c, $50
	call DelayFrames
	call ClearScreen
	call ClearSprites
	call Function1ad2
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld c, $50
	call DelayFrames
	call ClearScreen
	call Function1ad2
	call Functione51
	call Functione58
	callba Function16d69a
	call Function3200
	hlcoord 3, 8
	ld b, $2
	ld c, $c
	ld d, h
	ld e, l
	callba Function4d35b
	hlcoord 4, 10
	ld de, String28419
	call PlaceString
	call Function28eff
	call Function3200
	ld hl, wcf5d
	xor a
	ld [hli], a
	ld [hl], $50
	ld a, [wLinkMode]
	cp $1
	jp nz, Function28177
Function2805d: ; 2805d
	call Function28426
	call Function28499
	call Function28434
	xor a
	ld [wcf56], a
	call Function87d
	ld a, [hLinkPlayer]
	cp $2
	jr nz, .asm_28091
	ld c, $3
	call DelayFrames
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_28091
	ld de, MUSIC_NONE
	call PlayMusic
	ld c, $3
	call DelayFrames
	xor a
	ld [rIF], a
	ld a, $8
	ld [rIE], a
	ld hl, wd1f3
	ld de, EnemyMonSpecies
	ld bc, $0011
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, OverworldMap
	ld de, wd26b
	ld bc, $01a8
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wc608
	ld de, wc6d0
	ld bc, $00c8
	call Function75f
	xor a
	ld [rIF], a
	ld a, $1d
	ld [rIE], a
	call Function287ab
	ld hl, wd26b
	call Function287ca
	push hl
	ld bc, $000b
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jp z, Function28b22
	cp $7
	jp nc, Function28b22
	ld de, OverworldMap
	ld bc, $01a2
	call Function2879e
	ld de, wc6d0
	ld hl, wc813
	ld c, $2
.asm_280fe
	ld a, [de]
	inc de
	and a
	jr z, .asm_280fe
	cp $fd
	jr z, .asm_280fe
	cp $fe
	jr z, .asm_280fe
	cp $ff
	jr z, .asm_2811d
	push hl
	push bc
	ld b, $0
	dec a
	ld c, a
	add hl, bc
	ld a, $fe
	ld [hl], a
	pop bc
	pop hl
	jr .asm_280fe

.asm_2811d
	ld hl, wc90f
	dec c
	jr nz, .asm_280fe
	ld hl, OverworldMap
	ld de, wd26b
	ld bc, $000b
	call CopyBytes
	ld de, OTPartyCount
	ld a, [hli]
	ld [de], a
	inc de
.asm_28135
	ld a, [hli]
	cp $ff
	jr z, .asm_2814e
	ld [wd265], a
	push hl
	push de
	callab Functionfb908
	pop de
	pop hl
	ld a, [wd265]
	ld [de], a
	inc de
	jr .asm_28135

.asm_2814e
	ld [de], a
	ld hl, wc813
	call Function2868a
	ld a, OTPartyMonOT % $100
	ld [wd102], a
	ld a, OTPartyMonOT / $100
	ld [wd103], a
	ld de, MUSIC_NONE
	call PlayMusic
	ld a, [hLinkPlayer]
	cp $2
	ld c, 66
	call z, DelayFrames
	call GoodMoveCheck
	jr nc, .moveFailure

	ld de, MUSIC_ROUTE_30
	call PlayMusic
	jp Function287e3
; 28177

.moveFailure
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	ld d, h
	ld e, l
	callba Function4d35b
	ld hl, StringMoveIncompatible
	bccoord 1, 14
	call Function13e5
	ld c, $40
	jp DelayFrames
	
GoodMoveCheckYourTeam:
	push af
	push bc
	push de
	push hl
	
	ld a, 1
	ld [wcc62], a ;Setting your team flag
	
	ld a, [OverworldMap + $8]
	cp $1 ;Is it TPP or not? If true, we can skip the checks.
	jp z, EndCompatibleMoveCheck
	
	ld hl, PartyMon1Moves ;Get move
	ld de, TPPNewMoves ;Moves that will end the trade
	ld c, $4 ;Total moves per Pokemon
	ld a, [PartyCount] ;Your party size
	jp MoveCheckProcess
	
;c: Success
;nc: Failure
GoodMoveCheck:
	push af
	push bc
	push de
	push hl
	
	ld a, 0
	ld [wcc62], a ;Setting linked team flag

	ld a, [OverworldMap + $8]
	cp $1 ;Is it TPP or not? If true, we can skip the checks.
	jp z, EndCompatibleMoveCheck

	ld hl, OverworldMap + $17 ;Get move from linked
	
	ld de, TPPNewMoves ;Moves that will end the trade
	ld c, $4 ;Total moves per Pokemon
	ld a, [OverworldMap + $b] ;Linked party size
MoveCheckProcess: 
	push af

;a: Disqualifying move
;b: Move to compare
.checkLinkedMoveGroup
	ld a, [hli] ;a: Move of linked Pokemon
	ld b, a ;b: Move of linked Pokemon

.checkLinkedMoveGroupLoop
	ld a, [de]
	cp $ff
	jr z, .endLinkedMoveGroup
	cp b
	jr z, .badMoveLink
	inc de ;Increase move to check
	jr .checkLinkedMoveGroupLoop

.endLinkedMoveGroup
	ld de, TPPNewMoves ;Moves that will end the trade
	dec c ; Decrease the checks
	ld a, c
	cp $0 ;Check if it's the end
	jr nz, .checkLinkedMoveGroup ;Continue with loop
	ld c, $4
	pop af ;Get party size
	dec a ;Decrease by 1
	cp $0
	jp z, EndCompatibleMoveCheck ;If it's the end, then end the checks

;We're not at the end so let's continue the check
	push af
	ld de, $002c
	add hl, de
	ld de, TPPNewMoves
	jr .checkLinkedMoveGroup

.badMoveLink
	ld a, b
	ld [wcc60], a ;Storing bad move
	ld hl, OverworldMap + $b
	ld a, [wcc62]
	cp $0
	jr z, .linkedTeam
	ld hl, PartySpecies
	
.linkedTeam
	pop af
	ld c, a
	ld a, 6
	sub c
	
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wcc61], a ;Storing pokemon name
	
	pop hl
	pop de
	pop bc
	pop af
	xor a ; Failure (nc)
	ret

EndCompatibleMoveCheck:
	pop hl
	pop de
	pop bc
	pop af
	scf ;Success! (c)
	ret

GoodItemCheck:
	push af
	push bc
	push de
	push hl

	ld a, [OverworldMap + $8]
	cp $1 ;Is it TPP or not? If true, we can skip the checks.
	jr z, .endCompatibleItemCheck

	ld hl, PartyMon1 + $1 ;Get item from your party
	ld de, TPPNewItems ;Items that will end the trade
	ld a, [PartyCount] ;Linked party size
	ld c, a

.checkItemLoop
	ld a, [de]
	cp $ff
	jr z, .checkItemLoopExit ;End of new item list
	ld b, a
	ld a, [hl]
	cp b
	jr z, .badItemLink
	inc de
	jr .checkItemLoop

.checkItemLoopExit
	dec c
	ld a, c
	cp $0 ;Check if it's the end
	jr z, .endCompatibleItemCheck ;End of Pokemon to check

;Not the end
	ld de, $0030
	add hl, de
	ld de, TPPNewItems
	jr .checkItemLoop

.badItemLink
	pop hl
	pop de
	pop bc
	pop af
	xor a ; Failure (nc)
	ret

.endCompatibleItemCheck
	pop hl
	pop de
	pop bc
	pop af
	scf ;Success! (c)
	ret
;;;;

Function28177: ; 28177
	call Function28426
	call Function28595
	call Function28434
	call Function29dba
	ld a, [ScriptVar]
	and a
	jp z, Function283b2
	ld a, [hLinkPlayer]
	cp $2
	jr nz, .asm_281ae
	ld c, $3
	call DelayFrames
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	xor a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_281ae
	ld de, MUSIC_NONE
	call PlayMusic
	ld c, $3
	call DelayFrames
	xor a
	ld [rIF], a
	ld a, $8
	ld [rIE], a
	ld hl, wd1f3
	ld de, EnemyMonSpecies
	ld bc, $0011
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, OverworldMap
	ld de, wd26b
	ld bc, $01c2
	call Function75f
	ld a, $fe
	ld [de], a
	ld hl, wc608
	ld de, wc6d0
	ld bc, $00c8
	call Function75f
	ld a, [wLinkMode]
	cp $2
	jr nz, .asm_281fd
	ld hl, wc9f4
	ld de, wcb84
	ld bc, $0186
	call Function283f2
.asm_281fd
	xor a
	ld [rIF], a
	ld a, $1d
	ld [rIE], a
	ld de, MUSIC_NONE
	call PlayMusic
	call Function287ab
	ld hl, wd26b
	call Function287ca
	ld de, OverworldMap
	ld bc, $01b9
	call Function2879e
	ld de, wc6d0
	ld hl, wc813
	ld c, $2
.asm_28224
	ld a, [de]
	inc de
	and a
	jr z, .asm_28224
	cp $fd
	jr z, .asm_28224
	cp $fe
	jr z, .asm_28224
	cp $ff
	jr z, .asm_28243
	push hl
	push bc
	ld b, $0
	dec a
	ld c, a
	add hl, bc
	ld a, $fe
	ld [hl], a
	pop bc
	pop hl
	jr .asm_28224

.asm_28243
	ld hl, wc90f
	dec c
	jr nz, .asm_28224
	ld a, [wLinkMode]
	cp $2
	jp nz, .asm_282fe
	ld hl, wcb84
.asm_28254
	ld a, [hli]
	cp $20
	jr nz, .asm_28254
.asm_28259
	ld a, [hli]
	cp $fe
	jr z, .asm_28259
	cp $20
	jr z, .asm_28259
	dec hl
	ld de, wcb84
	ld bc, $0190
	call CopyBytes
	ld hl, wcb84
	ld bc, $00c6
.asm_28272
	ld a, [hl]
	cp $21
	jr nz, .asm_28279
	ld [hl], $fe
.asm_28279
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .asm_28272
	ld de, wcc9e
.asm_28282
	ld a, [de]
	inc de
	cp $ff
	jr z, .asm_28294
	ld hl, wcc4a
	dec a
	ld b, $0
	ld c, a
	add hl, bc
	ld [hl], $fe
	jr .asm_28282

.asm_28294
	ld hl, wcb84
	ld de, wc9f4
	ld b, $6
.asm_2829c
	push bc
	ld bc, $0021
	call CopyBytes
	ld a, $e
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	pop bc
	dec b
	jr nz, .asm_2829c
	ld de, wc9f4
	ld b, $6
.asm_282b4
	push bc
	ld a, $21
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld bc, $000e
	call CopyBytes
	pop bc
	dec b
	jr nz, .asm_282b4
	ld b, $6
	ld de, wc9f4
.asm_282cc
	push bc
	push de
	callba Function1de5c8
	ld a, c
	or a
	jr z, .asm_282ee
	sub $3
	jr nc, .asm_282e4
	callba Function1df203
	jr .asm_282ee

.asm_282e4
	cp $2
	jr nc, .asm_282ee
	callba Function1df220
.asm_282ee
	pop de
	ld hl, $002f
	add hl, de
	ld d, h
	ld e, l
	pop bc
	dec b
	jr nz, .asm_282cc
	ld de, wcb0e
	xor a
	ld [de], a
.asm_282fe
	ld hl, OverworldMap
	ld de, wd26b
	ld bc, $000b
	call CopyBytes

BattleTest:
	ld a, [OverworldMap + $8]
	cp $1 ;Is it TPP or not? If not, then don't battle
	jp nz, BattleCheck

LinkOK:
	ld de, OTPartyCount
	ld bc, $0008
	call CopyBytes
	ld de, wd276
	ld bc, $0002
	call CopyBytes
	ld de, OTPartyMon1Species
	ld bc, $01a4
	call CopyBytes
	ld a, $a8
	ld [wd102], a
	ld a, $d3
	ld [wd103], a
	ld de, MUSIC_NONE
	call PlayMusic
	ld a, [hLinkPlayer]
	cp $2
	ld c, 66
	call z, DelayFrames
	ld a, [wLinkMode]
	cp $3
	jr nz, .asm_283a9
	ld a, CAL
	ld [OtherTrainerClass], a
	call ClearScreen
	callba Function4d354
	ld hl, Options
	ld a, [hl]
	push af
	and $20
	or $3
	ld [hl], a
	ld hl, wd26b
	ld de, OTClassName
	ld bc, $000b
	call CopyBytes
	call Function222a
	ld a, [wc2d7]
	push af
	ld a, $1
	ld [wc2d7], a
	ld a, [rIE]
	push af
	ld a, [rIF]
	push af
	xor a
	ld [rIF], a
	ld a, [rIE]
	set 1, a
	ld [rIE], a
	pop af
	ld [rIF], a
	predef StartBattle
	ld a, [rIF]
	ld h, a
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	ld a, h
	ld [rIF], a
	pop af
	ld [wc2d7], a
	pop af
	ld [Options], a
	callba Function1500c
	jp Function28b22

.asm_283a9
	call GoodMoveCheck
	jr nc, .moveFailure
	
	call GoodMoveCheckYourTeam
	jr nc, .moveFailureYou

	call GoodItemCheck
	jr nc, .itemFailure

	ld de, MUSIC_ROUTE_30
	call PlayMusic
	jp Function287e3
; 283b2

.moveFailure
	ld a, [wcc61]
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, StringBuffer3
	ld bc, $000b
	call CopyBytes

	hlcoord 0, 12
	ld b, $4
	ld c, $12
	ld d, h
	ld e, l
	callba Function4d35b
	ld hl, StringMoveIncompatible
	bccoord 1, 14
	call Function13e5
	ld c, $40
	jp DelayFrames
	
.moveFailureYou
	ld a, [wcc61]
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, StringBuffer3
	ld bc, $000b
	call CopyBytes
	
	ld a, [wcc60]
	ld [wd265], a
	call GetMoveName

	hlcoord 0, 12
	ld b, $4
	ld c, $12
	ld d, h
	ld e, l
	callba Function4d35b
	ld hl, StringMoveIncompatibleYou
	bccoord 1, 14
	call Function13e5
	ld c, $40
	jp DelayFrames

.itemFailure
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	ld d, h
	ld e, l
	callba Function4d35b
	ld hl, StringItemIncompatible
	bccoord 1, 14
	call Function13e5
	ld c, $40
	jp DelayFrames

BattleCheck: ;If mode is battle & linked game isn't TPP, then cancel.
	ld a, [wLinkMode]
	cp $3
	jp nz, LinkOK
	
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	ld d, h
	ld e, l
	callba Function4d35b
	ld hl, StringCantBattle
	bccoord 1, 14
	call Function13e5
	ld c, $40
	jp DelayFrames
	
StringCantBattle: ; 0x4d3fe
	text_jump StringCantBattleText
	db "@"

StringCantBattleText: ; 28ece
	text "A TPP game can"
	next "only battle with"
	cont "another TPP game."
	done
	
StringItemIncompatible: ; 0x4d3fe
	text_jump StringItemIncompatibleText
	db "@"

StringItemIncompatibleText: ; 28ece
	text "A #mon in your"
	next "party is holding"
	cont "an item that is"
	cont "a TPP exclusive."
	done


Function283b2: ; 283b2
	ld de, UnknownText_0x283ed
	ld b, $a
.asm_283b7
	call DelayFrame
	call Function908
	dec b
	jr nz, .asm_283b7
	xor a
	ld [hld], a
	ld [hl], a
	ld [hVBlank], a
	push de
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	push de
	ld d, h
	ld e, l
	callba Function4d35b
	pop de
	pop hl
	bccoord 1, 14
	call Function13e5
	call Function4b6
	call ClearScreen
	ld b, $8
	call GetSGBLayout
	call Function3200
	ret
; 283ed

UnknownText_0x283ed: ; 0x283ed
	; Too much time has elapsed. Please try again.
	text_jump UnknownText_0x1c4183
	db "@"
; 0x283f2

Function283f2: ; 283f2
	ld a, $1
	ld [$ffcc], a
.asm_283f6
	ld a, [hl]
	ld [hSerialSend], a
	call Function78a
	push bc
	ld b, a
	inc hl
	ld a, $30
.asm_28401
	dec a
	jr nz, .asm_28401
	ld a, [$ffcc]
	and a
	ld a, b
	pop bc
	jr z, .asm_28411
	dec hl
	xor a
	ld [$ffcc], a
	jr .asm_283f6

.asm_28411
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .asm_283f6
	ret
; 28419

String28419: ; 28419
	db "PLEASE WAIT!@"
; 28426

Function28426: ; 28426
	ld hl, OverworldMap
	ld bc, $0514
.asm_2842c
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_2842c
	ret
; 28434

Function28434: ; 28434
	ld hl, wd1f3
	ld a, $fd
	ld b, $7
.asm_2843b
	ld [hli], a
	dec b
	jr nz, .asm_2843b
	ld b, $a
.asm_28441
	call Random
	cp $fd
	jr nc, .asm_28441
	ld [hli], a
	dec b
	jr nz, .asm_28441
	ld hl, wc608
	ld a, $fd
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld b, $c8
	xor a
.asm_28457
	ld [hli], a
	dec b
	jr nz, .asm_28457
	ld hl, wc818
	ld de, wc608 + 10
	ld bc, $0000
.asm_28464
	inc c
	ld a, c
	cp $fd
	jr z, .asm_2848c
	ld a, b
	dec a
	jr nz, .asm_2847f
	push bc
	ld a, [wLinkMode]
	cp $1
	ld b, $d
	jr z, .asm_2847a
	ld b, $27
.asm_2847a
	ld a, c
	cp b
	pop bc
	jr z, .asm_28495
.asm_2847f
	inc hl
	ld a, [hl]
	cp $fe
	jr nz, .asm_28464
	ld a, c
	ld [de], a
	inc de
	ld [hl], $ff
	jr .asm_28464

.asm_2848c
	ld a, $ff
	ld [de], a
	inc de
	ld bc, $100
	jr .asm_28464

.asm_28495
	ld a, $ff
	ld [de], a
	ret
; 28499

Function28499: ; 28499
	ld de, OverworldMap
	ld a, $fd
	ld b, $6
.asm_284a0
	ld [de], a
	inc de
	dec b
	jr nz, .asm_284a0
	ld hl, PlayerName
	ld bc, $000b
	call CopyBytes
	push de
	ld hl, PartyCount
	ld a, [hli]
	ld [de], a
	inc de
.asm_284b5
	ld a, [hli]
	cp $ff
	jr z, .asm_284ce
	ld [wd265], a
	push hl
	push de
	callab Functionfb8f1
	pop de
	pop hl
	ld a, [wd265]
	ld [de], a
	inc de
	jr .asm_284b5

.asm_284ce
	ld [de], a
	pop de
	ld hl, $0008
	add hl, de
	ld d, h
	ld e, l
	ld hl, PartyMon1Species
	ld c, $6
.asm_284db
	push bc
	call Function284f6
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_284db
	ld hl, PartyMonOT
	call .asm_284f0
	ld hl, PartyMonNicknames
.asm_284f0
	ld bc, $0042
	jp CopyBytes
; 284f6

Function284f6: ; 284f6
	ld b, h
	ld c, l
	push de
	push bc
	ld a, [hl]
	ld [wd265], a
	callab Functionfb8f1
	pop bc
	pop de
	ld a, [wd265]
	ld [de], a
	inc de
	ld hl, $0022
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld a, [bc]
	cp MAGNEMITE
	jr z, .asm_28528
	cp MAGNETON
	jr nz, .asm_28530
.asm_28528
	ld a, $17
	ld [de], a
	inc de
	ld [de], a
	inc de
	jr .asm_28544

.asm_28530
	push bc
	dec a
	ld hl, BaseData + 7 ; type
	ld bc, BaseData1 - BaseData0
	call AddNTimes
	ld bc, 2
	ld a, BANK(BaseData)
	call FarCopyBytes
	pop bc
.asm_28544
	push bc
	ld hl, $0001
	add hl, bc
	ld bc, $1a
	call CopyBytes
	pop bc
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	ld [de], a
	ld [CurPartyLevel], a
	inc de
	push bc
	ld hl, $0024
	add hl, bc
	ld bc, $0008
	call CopyBytes
	pop bc
	push de
	push bc
	ld a, [bc]
	dec a
	push bc
	ld b, 0
	ld c, a
	ld hl, KantoMonSpecials
	add hl, bc
	ld a, BANK(KantoMonSpecials)
	call GetFarByte
	ld [BaseSpecialAttack], a
	pop bc
	ld hl, $000a
	add hl, bc
	ld c, $5
	ld b, $1
	predef CalcPkmnStatC
	pop bc
	pop de
	ld a, [$ffb5]
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	ld h, b
	ld l, c
	ret
; 28595

Function28595: ; 28595
	ld de, OverworldMap
	ld a, $fd
	ld b, $6
.asm_2859c
	ld [de], a
	inc de
	dec b
	jr nz, .asm_2859c
	ld hl, PlayerName
	ld bc, $000b
	call CopyBytes
	ld hl, PartyCount
	ld bc, $0008
	call CopyBytes
	ld hl, PlayerID
	ld bc, $0002
	call CopyBytes
	ld hl, PartyMon1Species
	ld bc, $0120
	call CopyBytes
	ld hl, PartyMonOT
	ld bc, $0042
	call CopyBytes
	ld hl, PartyMonNicknames
	ld bc, $0042
	call CopyBytes
	ld a, [wLinkMode]
	cp $2
	ret nz
	ld de, wc9f4
	ld a, $20
	call Function28682
	ld a, $0
	call GetSRAMBank
	ld hl, $a600
	ld b, $6
.asm_285ef
	push bc
	ld bc, $0021
	call CopyBytes
	ld bc, $000e
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_285ef
	ld hl, $a600
	ld b, $6
.asm_28603
	push bc
	ld bc, $0021
	add hl, bc
	ld bc, $000e
	call CopyBytes
	pop bc
	dec b
	jr nz, .asm_28603
	ld b, $6
	ld de, $a600
	ld hl, wc9f9
.asm_2861a
	push bc
	push hl
	push de
	push hl
	callba Function1de5c8
	pop de
	ld a, c
	or a
	jr z, .asm_2863f
	sub $3
	jr nc, .asm_28635
	callba Function1df1e6
	jr .asm_2863f

.asm_28635
	cp $2
	jr nc, .asm_2863f
	callba Function1df220
.asm_2863f
	pop de
	ld hl, $002f
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, $0021
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_2861a
	call CloseSRAM
	ld hl, wc9f9
	ld bc, $00c6
.asm_28658
	ld a, [hl]
	cp $fe
	jr nz, .asm_2865f
	ld [hl], $21
.asm_2865f
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .asm_28658
	ld hl, wcabf
	ld de, wcb13
	ld b, $54
	ld c, $0
.asm_2866f
	inc c
	ld a, [hl]
	cp $fe
	jr nz, .asm_2867a
	ld [hl], $ff
	ld a, c
	ld [de], a
	inc de
.asm_2867a
	inc hl
	dec b
	jr nz, .asm_2866f
	ld a, $ff
	ld [de], a
	ret
; 28682

Function28682: ; 28682
	ld c, $5
.asm_28684
	ld [de], a
	inc de
	dec c
	jr nz, .asm_28684
	ret
; 2868a

Function2868a: ; 2868a
	push hl
	ld d, h
	ld e, l
	ld bc, wcbea
	ld hl, wcbe8
	ld a, c
	ld [hli], a
	ld [hl], b
	ld hl, OTPartyMon1Species
	ld c, $6
.asm_2869b
	push bc
	call Function286ba
	pop bc
	dec c
	jr nz, .asm_2869b
	pop hl
	ld bc, $0108
	add hl, bc
	ld de, OTPartyMonOT
	ld bc, $0042
	call CopyBytes
	ld de, OTPartyMonNicknames
	ld bc, $0042
	jp CopyBytes
; 286ba

Function286ba: ; 286ba
	ld b, h
	ld c, l
	ld a, [de]
	inc de
	push bc
	push de
	ld [wd265], a
	callab Functionfb908
	pop de
	pop bc
	ld a, [wd265]
	ld [bc], a
	ld [CurSpecies], a
	ld hl, $0022
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	inc de
	ld hl, $0020
	add hl, bc
	ld a, [de]
	inc de
	ld [hl], a
	ld hl, wcbe8
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, l
	ld [wcbe8], a
	ld a, h
	ld [wcbe9], a
	push bc
	ld hl, $0001
	add hl, bc
	push hl
	ld h, d
	ld l, e
	pop de
	push bc
	ld a, [hli]
	ld b, a
	call Function28771
	ld a, b
	ld [de], a
	inc de
	pop bc
	ld bc, $0019
	call CopyBytes
	pop bc
	ld d, h
	ld e, l
	ld hl, $001f
	add hl, bc
	ld a, [de]
	inc de
	ld [hl], a
	ld [CurPartyLevel], a
	push bc
	ld hl, $0024
	add hl, bc
	push hl
	ld h, d
	ld l, e
	pop de
	ld bc, $0008
	call CopyBytes
	pop bc
	call GetBaseData
	push de
	push bc
	ld d, h
	ld e, l
	ld hl, $000a
	add hl, bc
	ld c, $5
	ld b, $1
	predef CalcPkmnStatC
	pop bc
	pop hl
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hli], a
	push hl
	push bc
	ld hl, $000a
	add hl, bc
	ld c, $6
	ld b, $1
	predef CalcPkmnStatC
	pop bc
	pop hl
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hli], a
	push hl
	ld hl, $001b
	add hl, bc
	ld a, $46
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	inc de
	inc de
	ret
; 28771

Function28771: ; 28771
	ld a, b
	and a
	ret z
	push hl
	ld hl, .TimeCapsuleAlt
.asm_28778
	ld a, [hli]
	and a
	jr z, .asm_28783
	cp b
	jr z, .asm_28782
	inc hl
	jr .asm_28778

.asm_28782
	ld b, [hl]
.asm_28783
	pop hl
	ret

.TimeCapsuleAlt ; 28785
; Pokémon traded from RBY do not have held items, so GSC usually interprets the
; catch rate as an item. However, if the catch rate appears in this table, the
; item associated with the table entry is used instead.

	; db $19, LEFTOVERS
	; db $2D, BITTER_BERRY
	; db $32, GOLD_BERRY
	; db $5A, BERRY
	; db $64, BERRY
	; db $78, BERRY
	; db $87, BERRY
	db $BE, BERRY
	db $C3, BERRY
	db $DC, BERRY
	db $FA, BERRY
	db $ff, BERRY
	db $00
; 2879e

Function2879e: ; 2879e
.asm_2879e
	ld a, [hli]
	cp $fe
	jr z, .asm_2879e
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .asm_2879e
	ret
; 287ab

Function287ab: ; 287ab
	ld a, [hLinkPlayer]
	cp $2
	ret z
	ld hl, EnemyMonSpecies
	call Function287d8
	ld de, LinkBattleRNs
	ld c, $a
.asm_287bb
	ld a, [hli]
	cp $fe
	jr z, .asm_287bb
	cp $fd
	jr z, .asm_287bb
	ld [de], a
	inc de
	dec c
	jr nz, .asm_287bb
	ret
; 287ca

Function287ca: ; 287ca
.asm_287ca
	ld a, [hli]
	and a
	jr z, .asm_287ca
	cp $fd
	jr z, .asm_287ca
	cp $fe
	jr z, .asm_287ca
	dec hl
	ret
; 287d8

Function287d8: ; 287d8
.asm_287d8
	ld a, [hli]
	cp $fd
	jr z, .asm_287d8
	cp $fe
	jr z, .asm_287d8
	dec hl
	ret
; 287e3

Function287e3: ; 287e3
	call ClearScreen
	call Function28ef8
	callba Function16d673
	xor a
	ld hl, wcf51
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	ld [wcfa9], a
	inc a
	ld [wcf56], a
	jp Function2888b
; 28803

Function28803: ; 28803
	ld a, $1
	ld [MonType], a
	ld a, $c1
	ld [wcfa8], a
	ld a, [OTPartyCount]
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld a, $9
	ld [wcfa1], a
	ld a, $6
	ld [wcfa2], a
	ld a, $1
	ld [wcfaa], a
	ld a, $10
	ld [wcfa7], a
	ld a, $20
	ld [wcfa5], a
	xor a
	ld [wcfa6], a
Function28835: ; 28835
	callba Function16d70c
	ld a, d
	and a
	jp z, Function2891c
	bit 0, a
	jr z, .asm_2885b
	ld a, $1
	ld [wd263], a
	callab Function50db9
	ld hl, OTPartyMon1Species
	callba Function4d319
	jp Function2891c

.asm_2885b
	bit 6, a
	jr z, .asm_28883
	ld a, [wcfa9]
	ld b, a
	ld a, [OTPartyCount]
	cp b
	jp nz, Function2891c
	xor a
	ld [MonType], a
	call Function1bf7
	push hl
	push bc
	ld bc, $000b
	add hl, bc
	ld [hl], $7f
	pop bc
	pop hl
	ld a, [PartyCount]
	ld [wcfa9], a
	jr Function2888b

.asm_28883
	bit 7, a
	jp z, Function2891c
	jp Function28ac9
; 2888b

Function2888b: ; 2888b
	callba Function49856
	xor a
	ld [MonType], a
	ld a, $c1
	ld [wcfa8], a
	ld a, [PartyCount]
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld a, $1
	ld [wcfa1], a
	ld a, $6
	ld [wcfa2], a
	ld a, $1
	ld [wcfaa], a
	ld a, $10
	ld [wcfa7], a
	ld a, $20
	ld [wcfa5], a
	xor a
	ld [wcfa6], a
	call Function3200
Function288c5: ; 288c5
	callba Function16d70c
	ld a, d
	and a
	jr nz, .asm_288d2
	jp Function2891c

.asm_288d2
	bit 0, a
	jr z, .asm_288d9
	jp Function28926

.asm_288d9
	bit 7, a
	jr z, .asm_288fe
	ld a, [wcfa9]
	dec a
	jp nz, Function2891c
	ld a, $1
	ld [MonType], a
	call Function1bf7
	push hl
	push bc
	ld bc, $000b
	add hl, bc
	ld [hl], $7f
	pop bc
	pop hl
	ld a, $1
	ld [wcfa9], a
	jp Function28803

.asm_288fe
	bit 6, a
	jr z, Function2891c
	ld a, [wcfa9]
	ld b, a
	ld a, [PartyCount]
	cp b
	jr nz, Function2891c
	call Function1bf7
	push hl
	push bc
	ld bc, $000b
	add hl, bc
	ld [hl], $7f
	pop bc
	pop hl
	jp Function28ade
; 2891c

Function2891c: ; 2891c
	ld a, [MonType]
	and a
	jp z, Function288c5
	jp Function28835
; 28926

Function28926: ; 28926
	call Function309d
	ld a, [wcfa9]
	push af
	hlcoord 0, 15
	ld b, $1
	ld c, $12
	call Function28eef
	hlcoord 2, 16
	ld de, String28ab4
	call PlaceString
	callba Function4d354
.asm_28946
	ld a, $7f
	ld [TileMap + 11 + 16 * SCREEN_WIDTH], a
	ld a, $13
	ld [wcfa8], a
	ld a, $1
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld a, $10
	ld [wcfa1], a
	ld a, $1
	ld [wcfa2], a
	ld a, $1
	ld [wcfa9], a
	ld [wcfaa], a
	ld a, $20
	ld [wcfa7], a
	xor a
	ld [wcfa5], a
	ld [wcfa6], a
	call Function1bd3
	bit 4, a
	jr nz, .asm_2898d
	bit 1, a
	jr z, .asm_289cd
.asm_28983
	pop af
	ld [wcfa9], a
	call Function30b4
	jp Function2888b

.asm_2898d
	ld a, $7f
	ld [TileMap + 1 + 16 * SCREEN_WIDTH], a
	ld a, $23
	ld [wcfa8], a
	ld a, $1
	ld [wcfa3], a
	ld a, $1
	ld [wcfa4], a
	ld a, $10
	ld [wcfa1], a
	ld a, $b
	ld [wcfa2], a
	ld a, $1
	ld [wcfa9], a
	ld [wcfaa], a
	ld a, $20
	ld [wcfa7], a
	xor a
	ld [wcfa5], a
	ld [wcfa6], a
	call Function1bd3
	bit 5, a
	jp nz, .asm_28946
	bit 1, a
	jr nz, .asm_28983
	jr .asm_289fe

.asm_289cd
	pop af
	ld [wcfa9], a
	ld a, $4
	ld [wd263], a
	callab Function50db9
	callba Function4d319
	call Function30b4
	hlcoord 6, 1
	ld bc, $0601
	ld a, $7f
	call Function28b77
	hlcoord 17, 1
	ld bc, $0601
	ld a, $7f
	call Function28b77
	jp Function2888b

.asm_289fe
	call Function1bee
	pop af
	ld [wcfa9], a
	dec a
	ld [DefaultFlypoint], a
	ld [wcf56], a
	callba Function16d6ce
	ld a, [wcf51]
	cp $f
	jp z, Function287e3
	ld [wd003], a
	call Function28b68
	ld c, $64
	call DelayFrames
	callba Functionfb57e
	jr c, .asm_28a58
	callba Functionfb5dd
	jp nc, Function28b87
	xor a
	ld [wcf57], a
	ld [wcf52], a
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	callba Function4d354
	ld hl, UnknownText_0x28aaf
	bccoord 1, 14
	call Function13e5
	jr .asm_28a89

.asm_28a58
	xor a
	ld [wcf57], a
	ld [wcf52], a
	ld a, [wd003]
	ld hl, OTPartySpecies
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	callba Function4d354
	ld hl, UnknownText_0x28ac4
	bccoord 1, 14
	call Function13e5
.asm_28a89
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	hlcoord 1, 14
	ld de, String28ece
	call PlaceString
	ld a, $1
	ld [wcf56], a
	callba Function16d6ce
	ld c, $64
	call DelayFrames
	jp Function287e3
; 28aaf

UnknownText_0x28aaf: ; 0x28aaf
	; If you trade that #MON, you won't be able to battle.
	text_jump UnknownText_0x1c41b1
	db "@"
; 0x28ab4

String28ab4: ; 28ab4
	db "STATS     TRADE@"
UnknownText_0x28ac4: ; 0x28ac4
	; Your friend's @  appears to be abnormal!
	text_jump UnknownText_0x1c41e6
	db "@"
; 0x28ac9

Function28ac9: ; 28ac9
	ld a, [wcfa9]
	cp $1
	jp nz, Function2891c
	call Function1bf7
	push hl
	push bc
	ld bc, $000b
	add hl, bc
	ld [hl], $7f
	pop bc
	pop hl
Function28ade: ; 28ade
.asm_28ade
	ld a, $ed
	ld [TileMap + 9 + 17 * SCREEN_WIDTH], a
.asm_28ae3
	call Functiona57
	ld a, [$ffa9]
	and a
	jr z, .asm_28ae3
	bit 0, a
	jr nz, .asm_28b0b
	push af
	ld a, $7f
	ld [TileMap + 9 + 17 * SCREEN_WIDTH], a
	pop af
	bit 6, a
	jr z, .asm_28b03
	ld a, [OTPartyCount]
	ld [wcfa9], a
	jp Function28803

.asm_28b03
	ld a, $1
	ld [wcfa9], a
	jp Function2888b

.asm_28b0b
	ld a, $ec
	ld [TileMap + 9 + 17 * SCREEN_WIDTH], a
	ld a, $f
	ld [wcf56], a
	callba Function16d6ce
	ld a, [wcf51]
	cp $f
	jr nz, .asm_28ade
Function28b22: ; 28b22
	call Function4b6
	call ClearScreen
	ld b, $8
	call GetSGBLayout
	call Function3200
	xor a
	ld [wcfbb], a
	xor a
	ld [rSB], a
	ld [hSerialSend], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret
; 28b42

Function28b42: ; 28b42
	hlcoord 0, 16
	ld a, $7e
	ld bc, $0028
	call ByteFill
	hlcoord 1, 16
	ld a, $7f
	ld bc, $0012
	call ByteFill
	hlcoord 2, 16
	ld de, String_28b61
	jp PlaceString
; 28b61

String_28b61: ; 28b61
	db "CANCEL@"
; 28b68

Function28b68: ; 28b68
	ld a, [wcf51]
	hlcoord 6, 9
	ld bc, $0014
	call AddNTimes
	ld [hl], $ec
	ret
; 28b77

Function28b77: ; 28b77
.asm_28b77
	push bc
	push hl
.asm_28b79
	ld [hli], a
	dec c
	jr nz, .asm_28b79
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_28b77
	ret
; 28b87

Function28b87: ; 28b87
	xor a
	ld [wcf57], a
	ld [wcf52], a
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	callba Function4d354
	ld a, [DefaultFlypoint]
	ld hl, PartySpecies
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, wd004
	ld bc, $000b
	call CopyBytes
	ld a, [wd003]
	ld hl, OTPartySpecies
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0x28eb8
	bccoord 1, 14
	call Function13e5
	call Function1d6e
	hlcoord 10, 7
	ld b, $3
	ld c, $7
	call Function28eef
	ld de, String28eab
	hlcoord 12, 8
	call PlaceString
	ld a, $8
	ld [wcfa1], a
	ld a, $b
	ld [wcfa2], a
	ld a, $1
	ld [wcfa4], a
	ld a, $2
	ld [wcfa3], a
	xor a
	ld [wcfa5], a
	ld [wcfa6], a
	ld a, $20
	ld [wcfa7], a
	ld a, $3
	ld [wcfa8], a
	ld a, $1
	ld [wcfa9], a
	ld [wcfaa], a
	callba Function4d354
	call Function1bd3
	push af
	call Function1d7d
	call Function3200
	pop af
	bit 1, a
	jr nz, .asm_28c33
	ld a, [wcfa9]
	dec a
	jr z, .asm_28c54
.asm_28c33
	ld a, $1
	ld [wcf56], a
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	hlcoord 1, 14
	ld de, String28ece
	call PlaceString
	callba Function16d6ce
	jp Function28ea3

.asm_28c54
	ld a, $2
	ld [wcf56], a
	callba Function16d6ce
	ld a, [wcf51]
	dec a
	jr nz, .asm_28c7b
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	hlcoord 1, 14
	ld de, String28ece
	call PlaceString
	jp Function28ea3

.asm_28c7b
	ld hl, $a600
	ld a, [DefaultFlypoint]
	ld bc, $002f
	call AddNTimes
	ld a, $0
	call GetSRAMBank
	ld d, h
	ld e, l
	ld bc, $002f
	add hl, bc
	ld a, [DefaultFlypoint]
	ld c, a
.asm_28c96
	inc c
	ld a, c
	cp $6
	jr z, .asm_28ca6
	push bc
	ld bc, $002f
	call CopyBytes
	pop bc
	jr .asm_28c96

.asm_28ca6
	ld hl, $a600
	ld a, [PartyCount]
	dec a
	ld bc, $002f
	call AddNTimes
	push hl
	ld hl, wc9f4
	ld a, [wd003]
	ld bc, $002f
	call AddNTimes
	pop de
	ld bc, $002f
	call CopyBytes
	call CloseSRAM
	ld hl, PlayerName
	ld de, wc6e7
	ld bc, $000b
	call CopyBytes
	ld a, [DefaultFlypoint]
	ld hl, PartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wc6d0], a
	push af
	ld a, [DefaultFlypoint]
	ld hl, PartyMonOT
	call SkipNames
	ld de, wc6f2
	ld bc, $000b
	call CopyBytes
	ld hl, PartyMon1ID
	ld a, [DefaultFlypoint]
	call GetPartyLocation
	ld a, [hli]
	ld [PlayerScreens], a
	ld a, [hl]
	ld [EnemyScreens], a
	ld hl, PartyMon1DVs
	ld a, [DefaultFlypoint]
	call GetPartyLocation
	ld a, [hli]
	ld [wc6fd], a
	ld a, [hl]
	ld [wc6fe], a
	ld a, [DefaultFlypoint]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wc701], a
	ld hl, wd26b
	ld de, wc719
	ld bc, $000b
	call CopyBytes
	ld a, [wd003]
	ld hl, OTPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wc702], a
	ld a, [wd003]
	ld hl, OTPartyMonOT
	call SkipNames
	ld de, wc724
	ld bc, $000b
	call CopyBytes
	ld hl, OTPartyMon1ID
	ld a, [wd003]
	call GetPartyLocation
	ld a, [hli]
	ld [wc731], a
	ld a, [hl]
	ld [wc732], a
	ld hl, OTPartyMon1DVs
	ld a, [wd003]
	call GetPartyLocation
	ld a, [hli]
	ld [wc72f], a
	ld a, [hl]
	ld [wc730], a
	ld a, [wd003]
	ld hl, OTPartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	callba GetCaughtGender
	ld a, c
	ld [wc733], a
	ld a, [DefaultFlypoint]
	ld [CurPartyMon], a
	ld hl, PartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [DefaultFlypoint], a
	xor a
	ld [wd10b], a
	callab Functione039
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	ld a, $1
	ld [wd1e9], a
	ld a, [wd003]
	push af
	ld hl, OTPartySpecies
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd003], a
	ld c, $64
	call DelayFrames
	call ClearTileMap
	call Functione58
	ld b, $8
	call GetSGBLayout
	ld a, [hLinkPlayer]
	cp $1
	jr z, .asm_28de4
	predef Function28f24
	jr .asm_28de9

.asm_28de4
	predef Function28f63
.asm_28de9
	pop af
	ld c, a
	ld [CurPartyMon], a
	ld hl, OTPartySpecies
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [CurPartySpecies], a
	ld hl, OTPartyMon1Species
	ld a, c
	call GetPartyLocation
	ld de, TempMonSpecies
	ld bc, PartyMon2 - PartyMon1
	call CopyBytes
	predef Functionda96
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a
	callab Function421d8
	call ClearScreen
	call Function28ef8
	call Function28eff
	callba Function4d354
	ld b, $1
	pop af
	ld c, a
	cp MEW
	jr z, .asm_28e49
	ld a, [CurPartySpecies]
	cp MEW
	jr z, .asm_28e49
	ld b, $2
	ld a, c
	cp CELEBI
	jr z, .asm_28e49
	ld a, [CurPartySpecies]
	cp CELEBI
	jr z, .asm_28e49
	ld b, $0
.asm_28e49
	ld a, b
	ld [wcf56], a
	push bc
	call Function862
	pop bc
	ld a, [wLinkMode]
	cp $1
	jr z, .asm_28e63
	ld a, b
	and a
	jr z, .asm_28e63
	ld a, [wcf52]
	cp b
	jr nz, .asm_28e49
.asm_28e63
	callba Function14a58
	callba Function1060af
	callba Function106187
	ld c, $28
	call DelayFrames
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call Function28eef
	hlcoord 1, 14
	ld de, String28ebd
	call PlaceString
	callba Function4d354
	ld c, $32
	call DelayFrames
	ld a, [wLinkMode]
	cp $1
	jp z, Function2805d
	jp Function28177
; 28ea3

Function28ea3: ; 28ea3
	ld c, 100
	call DelayFrames
	jp Function287e3
; 28eab

String28eab: ; 28eab
	db   "TRADE"
	next "CANCEL@"
UnknownText_0x28eb8: ; 0x28eb8
	; Trade @ for @ ?
	text_jump UnknownText_0x1c4212
	db "@"
; 0x28ebd

String28ebd: ; 28ebd
	db   "Trade completed!@"
String28ece: ; 28ece
	db   "Too bad! The trade"
	next "was canceled!@"
	
StringMoveIncompatible: ; 0x4d3fe
	text_jump StringMoveIncompatibleText
	db "@"
	
StringMoveIncompatibleText: ; 28ece
	text "Your friend's"
	line "@"
	text_from_ram StringBuffer3
	text ""
	cont "knows a move"
	cont "that can't be"
	cont "traded over"
	done

StringMoveIncompatibleYou: ; 0x4d3fe
	text_jump StringMoveIncompatibleYouText
	db "@"

StringMoveIncompatibleYouText: ; 28ece
	text "@"
	text_from_ram StringBuffer3
	text ""
	line "knows the move"
	cont "@"
	text_from_ram StringBuffer1
	text ""
	cont "which can't be"
	cont "traded over to"
	cont "an official game."
	done

Function28eef: ; 28eef
	ld d, h
	ld e, l
	callba Function16d6ca
	ret
; 28ef8

Function28ef8: ; 28ef8
	callba Function16d696
	ret
; 28eff

Function28eff: ; 28eff
	callba Function16d6a7
	call Function32f9
	ret
; 28f09

Function28f09: ; 28f09
	hlcoord 0, 0
	ld b, 6
	ld c, 18
	call Function28eef
	hlcoord 0, 8
	ld b, 6
	ld c, 18
	call Function28eef
	callba Functionfb60d
	ret
; 28f24

Function28f24: ; 28f24
	xor a
	ld [wcf66], a
	ld hl, wc6e7
	ld de, wc719
	call Function297ff
	ld hl, wc6d0
	ld de, wc702
	call Function29814
	ld de, .data_28f3f
	jr Function28fa1

.data_28f3f
	db $1b
	db $1
	db $1c
	db $21
	db $2d
	db $27
	db $23
	db $3
	db $25
	db $28
	db $25
	db $1e
	db $29
	db $6
	db $16
	db $1f
	db $19
	db $17
	db $22
	db $1f
	db $2a
	db $e
	db $3
	db $24
	db $5
	db $25
	db $2
	db $27
	db $25
	db $1d
	db $2c
	db $2e
	db $1e
	db $18
	db $1f
	db $2b
Function28f63: ; 28f63
	xor a
	ld [wcf66], a
	ld hl, wc719
	ld de, wc6e7
	call Function297ff
	ld hl, wc702
	ld de, wc6d0
	call Function29814
	ld de, .data_28f7e
	jr Function28fa1

.data_28f7e
	db $1a
	db $17
	db $22
	db $1f
	db $2a
	db $6
	db $3
	db $24
	db $5
	db $25
	db $2
	db $27
	db $25
	db $1d
	db $2c
	db $2f
	db $1e
	db $18
	db $1f
	db $1b
	db $1
	db $1c
	db $22
	db $27
	db $23
	db $3
	db $25
	db $28
	db $25
	db $1e
	db $29
	db $e
	db $16
	db $1f
	db $2b
Function28fa1: ; 28fa1
	ld hl, BattleEnded
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
	ld hl, VramState
	ld a, [hl]
	push af
	res 0, [hl]
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function28fdb
	ld a, [wcf66]
	and a
	jr nz, .asm_28fca
	ld de, MUSIC_EVOLUTION
	call PlayMusic2
.asm_28fca
	call Function29082
	jr nc, .asm_28fca
	pop af
	ld [Options], a
	pop af
	ld [VramState], a
	pop af
	ld [$ffde], a
	ret
; 28fdb

Function28fdb: ; 28fdb
	xor a
	ld [wcf63], a
	call WhiteBGMap
	call ClearSprites
	call ClearTileMap
	call DisableLCD
	call Functione58
	callab Function8cf53
	ld a, [hCGB]
	and a
	jr z, .asm_2900b
	ld a, $1
	ld [rVBK], a
	ld hl, VTiles0
	ld bc, $2000
	xor a
	call ByteFill
	ld a, $0
	ld [rVBK], a
.asm_2900b
	ld hl, VBGMap0
	ld bc, $0800
	ld a, $7f
	call ByteFill
	ld hl, TradeGameBoyLZ
	ld de, $9310
	call Decompress
	ld hl, TradeArrowGFX
	ld de, $8ed0
	ld bc, $0010
	ld a, BANK(TradeArrowGFX)
	call FarCopyBytes
	ld hl, TradeArrowGFX + $10
	ld de, $8ee0
	ld bc, $0010
	ld a, BANK(TradeArrowGFX)
	call FarCopyBytes
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	callba Function4d7fd
	call EnableLCD
	call Function2982b
	ld a, [wc6d0]
	ld hl, wc6fd
	ld de, VTiles0
	call Function29491
	ld a, [wc702]
	ld hl, wc72f
	ld de, $8310
	call Function29491
	ld a, [wc6d0]
	ld de, wc6d1
	call Function294a9
	ld a, [wc702]
	ld de, wc703
	call Function294a9
	call Function297ed
	ret
; 29082

Function29082: ; 29082
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_2909b
	call Function290a0
	callab Function8cf69
	ld hl, wcf65
	inc [hl]
	call DelayFrame
	and a
	ret

.asm_2909b
	call Functione51
	scf
	ret
; 290a0

Function290a0: ; 290a0
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, JumpTable290af
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 290af

JumpTable290af: ; 290af
	dw Function29114
	dw Function2942e
	dw Function29461
	dw Function29348
	dw Function2937e
	dw Function29391
	dw Function29129
	dw Function291af
	dw Function291c4
	dw Function291d9
	dw Function2925d
	dw Function29220
	dw Function2925d
	dw Function29229
	dw Function2913c
	dw Function2925d
	dw Function291e8
	dw Function291fd
	dw Function29211
	dw Function29220
	dw Function2925d
	dw Function29229
	dw Function29701
	dw Function2973c
	dw Function2975c
	dw Function2977f
	dw Function297a4
	dw Function293a6
	dw Function293b6
	dw Function293d2
	dw Function293de
	dw Function293ea
	dw Function2940c
	dw Function294e7
	dw Function294f0
	dw Function2961b
	dw Function2962c
	dw Function29879
	dw Function29886
	dw Function29649
	dw Function29660
	dw Function2926d
	dw Function29277
	dw Function29123
	dw Function29487
	dw Function294f9
	dw Function29502
	dw Function2950c
; 2910f

Function2910f: ; 2910f
	ld hl, wcf63
	inc [hl]
	ret
; 29114

Function29114: ; 29114
	ld hl, BattleEnded
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld [wcf63], a
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret
; 29123

Function29123: ; 29123
	ld hl, wcf63
	set 7, [hl]
	ret
; 29129

Function29129: ; 29129
	ld a, $ed
	call Function292f6
	ld a, [wc74c]
	ld [wd265], a
	xor a
	ld de, $2c58
	ld b, $0
	jr Function2914e

Function2913c: ; 2913c
	ld a, $ee
	call Function292f6
	ld a, [wc74d]
	ld [wd265], a
	ld a, $2
	lb de, $4c, $94
	ld b, $4
Function2914e: ; 2914e
	push bc
	push de
	push bc
	push de
	push af
	call DisableLCD
	callab Function8cf53
	ld hl, $9874
	ld bc, $000c
	ld a, $60
	call ByteFill
	pop af
	call Function29281
	xor a
	ld [hSCX], a
	ld a, $7
	ld [hWX], a
	ld a, $70
	ld [hWY], a
	call EnableLCD
	call Function2985a
	pop de
	ld a, $11
	call Function3b2a
	ld hl, $000b
	add hl, bc
	pop bc
	ld [hl], b
	pop de
	ld a, $12
	call Function3b2a
	ld hl, $000b
	add hl, bc
	pop bc
	ld [hl], b
	call WaitBGMap
	ld b, $1b
	call GetSGBLayout
	ld a, $e4
	call DmgToCgbBGPals
	ld a, $d0
	call Functioncf8
	call Function2910f
	ld a, $5c
	ld [wcf64], a
	ret
; 291af

Function291af: ; 291af
	call Function2981d
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	cp $50
	ret nz
	ld a, $1
	call Function29281
	call Function2910f
	ret
; 291c4

Function291c4: ; 291c4
	call Function2981d
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	cp $a0
	ret nz
	ld a, $2
	call Function29281
	call Function2910f
	ret
; 291d9

Function291d9: ; 291d9
	call Function2981d
	ld a, [hSCX]
	add $2
	ld [hSCX], a
	and a
	ret nz
	call Function2910f
	ret
; 291e8

Function291e8: ; 291e8
	call Function2981d
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	cp $b0
	ret nz
	ld a, $1
	call Function29281
	call Function2910f
	ret
; 291fd

Function291fd: ; 291fd
	call Function2981d
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	cp $60
	ret nz
	xor a
	call Function29281
	call Function2910f
	ret
; 29211

Function29211: ; 29211
	call Function2981d
	ld a, [hSCX]
	sub $2
	ld [hSCX], a
	and a
	ret nz
	call Function2910f
	ret
; 29220

Function29220: ; 29220
	ld a, $80
	ld [wcf64], a
	call Function2910f
	ret
; 29229

Function29229: ; 29229
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	callab Function8cf53
	ld hl, VBGMap0
	ld bc, $0800
	ld a, $7f
	call ByteFill
	xor a
	ld [hSCX], a
	ld a, $90
	ld [hWY], a
	call EnableLCD
	call Function2982b
	call WaitBGMap
	call Function297ed
	call Function29114
	ret
; 2925d

Function2925d: ; 2925d
	call Function2981d
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_29269
	dec [hl]
	ret

.asm_29269
	call Function2910f
	ret
; 2926d

Function2926d: ; 2926d
	call Function29114
	ld de, SFX_GIVE_TRADEMON
	call PlaySFX
	ret
; 29277

Function29277: ; 29277
	call Function29114
	ld de, SFX_GET_TRADEMON
	call PlaySFX
	ret
; 29281

Function29281: ; 29281
	and 3
	ld e, a
	ld d, 0
	ld hl, Jumptable_2928f
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 2928f

Jumptable_2928f: ; 2928f
	dw Function29297
	dw Function292af
	dw Function292be
	dw Function29297
; 29297

Function29297: ; 29297
	call Function297cf
	hlcoord 9, 3
	ld [hl], $5b
	inc hl
	ld bc, $000a
	ld a, $60
	call ByteFill
	hlcoord 3, 2
	call Function292ec
	ret
; 292af

Function292af: ; 292af
	call Function297cf
	hlcoord 0, 3
	ld bc, $0014
	ld a, $60
	call ByteFill
	ret
; 292be

Function292be: ; 292be
	call Function297cf
	hlcoord 0, 3
	ld bc, $0011
	ld a, $60
	call ByteFill
	hlcoord 17, 3
	ld a, $5d
	ld [hl], a
	ld a, $61
	ld de, $0014
	ld c, $3
.asm_292d9
	add hl, de
	ld [hl], a
	dec c
	jr nz, .asm_292d9
	add hl, de
	ld a, $5f
	ld [hld], a
	ld a, $5b
	ld [hl], a
	hlcoord 10, 6
	call Function292ec
	ret
; 292ec

Function292ec: ; 292ec
	ld de, TradeGameBoyTilemap
	lb bc, 8, 6
	call Function297db
	ret
; 292f6

Function292f6: ; 292f6
	push af
	call WhiteBGMap
	call WaitTop
	ld a, $9c
	ld [$ffd7], a
	call ClearTileMap
	hlcoord 0, 0
	ld bc, $0014
	ld a, $7a
	call ByteFill
	hlcoord 0, 1
	ld de, wc736
	call PlaceString
	ld hl, wc741
	ld de, 0
.asm_2931e
	ld a, [hli]
	cp $50
	jr z, .asm_29326
	dec de
	jr .asm_2931e

.asm_29326
	hlcoord 0, 4
	add hl, de
	ld de, wc741
	call PlaceString
	hlcoord 7, 2
	ld bc, $0006
	pop af
	call ByteFill
	call WaitBGMap
	call WaitTop
	ld a, $98
	ld [$ffd7], a
	call ClearTileMap
	ret
; 29348

Function29348: ; 29348
	call ClearTileMap
	call WaitTop
	ld a, $a0
	ld [hSCX], a
	call DelayFrame
	hlcoord 8, 2
	ld de, Tilemap_298f7
	lb bc, 3, 12
	call Function297db
	call WaitBGMap
	ld b, $1b
	call GetSGBLayout
	ld a, $e4
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	ld de, SFX_POTION
	call PlaySFX
	call Function2910f
	ret
; 2937e

Function2937e: ; 2937e
	ld a, [hSCX]
	and a
	jr z, .asm_29388
	add $4
	ld [hSCX], a
	ret

.asm_29388
	ld c, $50
	call DelayFrames
	call Function29114
	ret
; 29391

Function29391: ; 29391
	ld a, [hSCX]
	cp $a0
	jr z, .asm_2939c
	sub $4
	ld [hSCX], a
	ret

.asm_2939c
	call ClearTileMap
	xor a
	ld [hSCX], a
	call Function29114
	ret
; 293a6

Function293a6: ; 293a6
	ld a, $8f
	ld [hWX], a
	ld a, $88
	ld [hSCX], a
	ld a, $50
	ld [hWY], a
	call Function29114
	ret
; 293b6

Function293b6: ; 293b6
	ld a, [hWX]
	cp $7
	jr z, .asm_293c7
	sub $4
	ld [hWX], a
	ld a, [hSCX]
	sub $4
	ld [hSCX], a
	ret

.asm_293c7
	ld a, $7
	ld [hWX], a
	xor a
	ld [hSCX], a
	call Function29114
	ret
; 293d2

Function293d2: ; 293d2
	ld a, $7
	ld [hWX], a
	ld a, $50
	ld [hWY], a
	call Function29114
	ret
; 293de

Function293de: ; 293de
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	call Function29114
	ret
; 293ea

Function293ea: ; 293ea
	call WaitTop
	ld a, $9c
	ld [$ffd7], a
	call WaitBGMap
	ld a, $7
	ld [hWX], a
	xor a
	ld [hWY], a
	call DelayFrame
	call WaitTop
	ld a, $98
	ld [$ffd7], a
	call ClearTileMap
	call Function2910f
	ret
; 2940c

Function2940c: ; 2940c
	ld a, [hWX]
	cp $a1
	jr nc, .asm_29417
	add $4
	ld [hWX], a
	ret

.asm_29417
	ld a, $9c
	ld [$ffd7], a
	call WaitBGMap
	ld a, $7
	ld [hWX], a
	ld a, $90
	ld [hWY], a
	ld a, $98
	ld [$ffd7], a
	call Function29114
	ret
; 2942e

Function2942e: ; 2942e
	call Function2951f
	ld a, [wc6d0]
	ld [CurPartySpecies], a
	ld a, [wc6fd]
	ld [TempMonDVs], a
	ld a, [wc6fe]
	ld [TempMonDVs + 1], a
	ld b, $1a
	call GetSGBLayout
	ld a, $e4
	call DmgToCgbBGPals
	call Function294bb
	ld a, [wc6d0]
	call GetCryIndex
	jr c, .asm_2945d
	ld e, c
	ld d, b
	call PlayCryHeader
.asm_2945d
	call Function29114
	ret
; 29461

Function29461: ; 29461
	call Function29549
	ld a, [wc702]
	ld [CurPartySpecies], a
	ld a, [wc72f]
	ld [TempMonDVs], a
	ld a, [wc730]
	ld [TempMonDVs + 1], a
	ld b, $1a
	call GetSGBLayout
	ld a, $e4
	call DmgToCgbBGPals
	call Function294c0
	call Function29114
	ret
; 29487

Function29487: ; 29487
	callba Function4d81e
	call Function29114
	ret
; 29491

Function29491: ; 29491
	push de
	push af
	predef GetUnownLetter
	pop af
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	pop de
	predef GetFrontpic
	ret
; 294a9

Function294a9: ; 294a9
	push de
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	pop de
	ld bc, $000b
	call CopyBytes
	ret
; 294bb

Function294bb: ; 294bb
	ld de, VTiles0
	jr Function294c3

Function294c0: ; 294c0
	ld de, $8310
Function294c3: ; 294c3
	call DelayFrame
	ld hl, VTiles2
	ld bc, $0a31
	call Request2bpp
	call WaitTop
	call Function297cf
	hlcoord 7, 2
	xor a
	ld [$ffad], a
	ld bc, $0707
	predef FillBox
	call WaitBGMap
	ret
; 294e7

Function294e7: ; 294e7
	ld c, $50
	call DelayFrames
	call Function29114
	ret
; 294f0

Function294f0: ; 294f0
	ld c, $28
	call DelayFrames
	call Function29114
	ret
; 294f9

Function294f9: ; 294f9
	ld c, $60
	call DelayFrames
	call Function29114
	ret
; 29502

Function29502: ; 29502
	call Function29516
	ret nz
	ld c, $50
	call DelayFrames
	ret
; 2950c

Function2950c: ; 2950c
	call Function29516
	ret nz
	ld c, $b4
	call DelayFrames
	ret
; 29516

Function29516: ; 29516
	call Function29114
	ld a, [wc702]
	cp $fd
	ret
; 2951f

Function2951f: ; 2951f
	ld de, wc6d0
	ld a, [de]
	cp $fd
	jr z, Function295a1
	call Function29573
	ld de, wc6d0
	call Function295e3
	ld de, wc6d1
	call Function295ef
	ld a, [wc701]
	ld de, wc6f2
	call Function295f6
	ld de, PlayerScreens
	call Function29611
	call Function295d8
	ret
; 29549

Function29549: ; 29549
	ld de, wc702
	ld a, [de]
	cp $fd
	jr z, Function295a1
	call Function29573
	ld de, wc702
	call Function295e3
	ld de, wc703
	call Function295ef
	ld a, [wc733]
	ld de, wc724
	call Function295f6
	ld de, wc731
	call Function29611
	call Function295d8
	ret
; 29573

Function29573: ; 29573
	call WaitTop
	call Function297cf
	ld a, $9c
	ld [$ffd7], a
	hlcoord 3, 0
	ld b, $6
	ld c, $d
	call TextBox
	hlcoord 4, 0
	ld de, String29591
	call PlaceString
	ret
; 29591

String29591: ; 29591
	db "─── №.", $4e
	db $4e
	db "OT/", $4e
	db $73, "№.@"
; 295a1

Function295a1: ; 295a1
	call WaitTop
	call Function297cf
	ld a, $9c
	ld [$ffd7], a
	hlcoord 3, 0
	ld b, $6
	ld c, $d
	call TextBox
	hlcoord 4, 2
	ld de, String295c2
	call PlaceString
	call Function295d8
	ret
; 295c2

String295c2: ; 295c2
	db "EGG", $4e
	db "OT/?????", $4e
	db $73, "№.?????@"
; 295d8

Function295d8: ; 295d8
	call WaitBGMap
	call WaitTop
	ld a, $98
	ld [$ffd7], a
	ret
; 295e3

Function295e3: ; 295e3
	hlcoord 10, 0
	ld bc, $8103
	call PrintNum
	ld [hl], $7f
	ret
; 295ef

Function295ef: ; 295ef
	hlcoord 4, 2
	call PlaceString
	ret
; 295f6

Function295f6: ; 295f6
	cp 3
	jr c, .asm_295fb
	xor a
.asm_295fb
	push af
	hlcoord 7, 4
	call PlaceString
	inc bc
	pop af
	ld hl, Unknown_2960e
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [bc], a
	ret
; 2960e

Unknown_2960e: ; 2960e
	db " ", "♂", "♀"
; 29611

Function29611: ; 29611
	hlcoord 7, 6
	ld bc, $8205
	call PrintNum
	ret
; 2961b

Function2961b: ; 2961b
	lb de, $54, $58
	ld a, $e
	call Function3b2a
	call Function29114
	ld a, $20
	ld [wcf64], a
	ret
; 2962c

Function2962c: ; 2962c
	lb de, $54, $58
	ld a, $e
	call Function3b2a
	ld hl, $000b
	add hl, bc
	ld [hl], $1
	ld hl, $0007
	add hl, bc
	ld [hl], $dc
	call Function29114
	ld a, $38
	ld [wcf64], a
	ret
; 29649

Function29649: ; 29649
	lb de, $54, $58
	ld a, $f
	call Function3b2a
	call Function29114
	ld a, $10
	ld [wcf64], a
	ld de, SFX_BALL_POOF
	call PlaySFX
	ret
; 29660

Function29660: ; 29660
	ld a, $e4
	call Functioncf8
	lb de, $28, $58
	ld a, $10
	call Function3b2a
	call Function29114
	ld a, $40
	ld [wcf64], a
	ret
; 29676

Function29676: ; 29676 (a:5676)
	ld hl, $b
	add hl, bc
	ld e, [hl]
	ld d, 0
	ld hl, Jumptable_29686
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 29686

Jumptable_29686: ; 29686 (a:5686)
	dw Function2969a
	dw Function296a4
	dw Function296af
	dw Function296bd
	dw Function296cf
	dw Function296dd
	dw Function296f2
; 2969a

Function29694: ; 29694 (a:5694)
	ld hl, $b
	add hl, bc
	inc [hl]
	ret

Function2969a: ; 2969a (a:569a)
	call Function29694
	ld hl, $c
	add hl, bc
	ld [hl], $80
	ret

Function296a4: ; 296a4 (a:56a4)
	ld hl, $c
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	call Function29694
Function296af: ; 296af (a:56af)
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $94
	jr nc, .asm_296ba
	inc [hl]
	ret

.asm_296ba
	call Function29694
Function296bd: ; 296bd (a:56bd)
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $4c
	jr nc, .asm_296c8
	inc [hl]
	ret

.asm_296c8
	ld hl, $0
	add hl, bc
	ld [hl], $0
	ret

Function296cf: ; 296cf (a:56cf)
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $2c
	jr z, .asm_296da
	dec [hl]
	ret

.asm_296da
	call Function29694
Function296dd: ; 296dd (a:56dd)
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_296e8
	dec [hl]
	ret

.asm_296e8
	call Function29694
	ld hl, $c
	add hl, bc
	ld [hl], $80
	ret

Function296f2: ; 296f2 (a:56f2)
	ld hl, $c
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	ret nz
	ld hl, $0
	add hl, bc
	ld [hl], $0
	ret
; 29701 (a:5701)

Function29701: ; 29701
	ld a, [wLinkMode]
	cp $1
	jr z, .asm_29725
	ld hl, UnknownText_0x29737
	call PrintText
	ld c, $bd
	call DelayFrames
	ld hl, UnknownText_0x29732
	call PrintText
	call Function297c9
	ld c, $80
	call DelayFrames
	call Function29114
	ret

.asm_29725
	ld hl, UnknownText_0x29732
	call PrintText
	call Function297c9
	call Function29114
	ret
; 29732

UnknownText_0x29732: ; 0x29732
	; was sent to @ .
	text_jump UnknownText_0x1bc6e9
	db "@"
; 0x29737

UnknownText_0x29737: ; 0x29737
	;
	text_jump UnknownText_0x1bc701
	db "@"
; 0x2973c

Function2973c: ; 2973c
	ld hl, UnknownText_0x29752
	call PrintText
	call Function297c9
	ld hl, UnknownText_0x29757
	call PrintText
	call Function297c9
	call Function29114
	ret
; 29752

UnknownText_0x29752: ; 0x29752
	; bids farewell to
	text_jump UnknownText_0x1bc703
	db "@"
; 0x29757

UnknownText_0x29757: ; 0x29757
	; .
	text_jump UnknownText_0x1bc719
	db "@"
; 0x2975c

Function2975c: ; 2975c
	call WaitTop
	hlcoord 0, 10
	ld bc, $00a0
	ld a, $7f
	call ByteFill
	call WaitBGMap
	ld hl, UnknownText_0x2977a
	call PrintText
	call Function297c9
	call Function29114
	ret
; 2977a

UnknownText_0x2977a: ; 0x2977a
	; Take good care of @ .
	text_jump UnknownText_0x1bc71f
	db "@"
; 0x2977f

Function2977f: ; 2977f
	ld hl, UnknownText_0x2979a
	call PrintText
	call Function297c9
	ld hl, UnknownText_0x2979f
	call PrintText
	call Function297c9
	ld c, $e
	call DelayFrames
	call Function29114
	ret
; 2979a

UnknownText_0x2979a: ; 0x2979a
	; For @ 's @,
	text_jump UnknownText_0x1bc739
	db "@"
; 0x2979f

UnknownText_0x2979f: ; 0x2979f
	; sends @ .
	text_jump UnknownText_0x1bc74c
	db "@"
; 0x297a4

Function297a4: ; 297a4
	ld hl, UnknownText_0x297bf
	call PrintText
	call Function297c9
	ld hl, UnknownText_0x297c4
	call PrintText
	call Function297c9
	ld c, $e
	call DelayFrames
	call Function29114
	ret
; 297bf

UnknownText_0x297bf: ; 0x297bf
	; will trade @ @
	text_jump UnknownText_0x1bc75e
	db "@"
; 0x297c4

UnknownText_0x297c4: ; 0x297c4
	; for @ 's @ .
	text_jump UnknownText_0x1bc774
	db "@"
; 0x297c9

Function297c9: ; 297c9
	ld c, $50
	call DelayFrames
	ret
; 297cf

Function297cf: ; 297cf
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	ret
; 297db

Function297db: ; 297db
.asm_297db
	push bc
	push hl
.asm_297dd
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_297dd
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_297db
	ret
; 297ed

Function297ed: ; 297ed
	ld a, [hSGB]
	and a
	ld a, $e4
	jr z, .asm_297f6
	ld a, $f0
.asm_297f6
	call Functioncf8
	ld a, $e4
	call DmgToCgbBGPals
	ret
; 297ff

Function297ff: ; 297ff
	push de
	ld de, wc736
	ld bc, $000b
	call CopyBytes
	pop hl
	ld de, wc741
	ld bc, $000b
	call CopyBytes
	ret
; 29814

Function29814: ; 29814
	ld a, [hl]
	ld [wc74c], a
	ld a, [de]
	ld [wc74d], a
	ret
; 2981d

Function2981d: ; 2981d
	ld a, [wcf65]
	and $7
	ret nz
	ld a, [rBGP]
	xor $3c
	call DmgToCgbBGPals
	ret
; 2982b

Function2982b: ; 2982b
	call DelayFrame
	ld de, TradeBallGFX
	ld hl, $8620
	lb bc, BANK(TradeBallGFX), $6
	call Request2bpp
	ld de, TradePoofGFX
	ld hl, $8680
	lb bc, BANK(TradePoofGFX), $c
	call Request2bpp
	ld de, TradeCableGFX
	ld hl, $8740
	lb bc, BANK(TradeCableGFX), $4
	call Request2bpp
	xor a
	ld hl, wc300
	ld [hli], a
	ld [hl], $62
	ret
; 2985a

Function2985a: ; 2985a
	call DelayFrame
	ld e, $3
	callab Function8e83f
	ld de, TradeBubbleGFX
	ld hl, $8720
	lb bc, BANK(TradeBubbleGFX), $4
	call Request2bpp
	xor a
	ld hl, wc300
	ld [hli], a
	ld [hl], $62
	ret
; 29879

Function29879: ; 29879
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_29882
	dec [hl]
	ret

.asm_29882
	call Function29114
	ret
; 29886

Function29886: ; 29886
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_2988f
	dec [hl]
	ret

.asm_2988f
	call Function29114
	ret
; 29893

Function29893: ; 29893
; This function is unreferenced.
; It was meant for use in Japanese versions, so the
; constant used for copy length was changed by accident.

	ld hl, Unknown_298b5
	ld a, [hli]
	ld [wc6d0], a
	ld de, wc6e7
	ld c, 13 ; jp: 8
.asm_2989f
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2989f
	ld a, [hli]
	ld [wc702], a
	ld de, wc719
	ld c, 13 ; jp: 8
.asm_298ae
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_298ae
	ret
; 298b5

Unknown_298b5: ; 298b5
	db $03, "ゲーフり@@", $23, $01 ; GAME FREAK
	db $06, "クりーチャ@", $56, $04 ; Creatures Inc.
; 298c7

TradeGameBoyTilemap: ; 298c7
; 6x8

	db $31, $32, $32, $32, $32, $33
	db $34, $35, $36, $36, $37, $38
	db $34, $39, $3a, $3a, $3b, $38
	db $3c, $3d, $3e, $3e, $3f, $40
	db $41, $42, $43, $43, $44, $45
	db $46, $47, $43, $48, $49, $4a
	db $41, $43, $4b, $4c, $4d, $4e
	db $4f, $50, $50, $50, $51, $52
; 297f7

Tilemap_298f7: ; 297f7
; 12x3

	db $43, $55, $56, $53, $53, $53, $53, $53, $53, $53, $53, $53
	db $43, $57, $58, $54, $54, $54, $54, $54, $54, $54, $54, $54
	db $43, $59, $5a, $43, $43, $43, $43, $43, $43, $43, $43, $43
; 2991b

TradeArrowGFX:  INCBIN "gfx/trade/arrow.2bpp"

TradeCableGFX:  INCBIN "gfx/trade/cable.2bpp"

TradeBubbleGFX: INCBIN "gfx/trade/bubble.2bpp"

TradeGameBoyLZ: INCBIN "gfx/trade/game_boy.2bpp.lz"

TradeBallGFX:   INCBIN "gfx/trade/ball.2bpp"

TradePoofGFX:   INCBIN "gfx/trade/poof.2bpp"

TPPNewItems:
	db PREMIER_BALL
	db POISON_GUARD
	db BURN_GUARD
	db FREEZE_GUARD
	db SLEEP_GUARD
	db PARLYZ_GUARD
	db CONFUSEGUARD
	db POWER_HERB
	db FRIEND_CHARM
	db $ff

TPPNewMoves:
	db POISON_JAB
	db FLASH_CANNON
	db ZEN_HEADBUTT
	db AIR_SLASH
	db BUG_BUZZ
	db DRILL_RUN
	db DAZZLINGLEAM
	db SHADOW_CLAW
	db ZEN_HEADBUTT
	db IRON_DEFENSE
	db DARK_PULSE
	db HEAT_WAVE
	db X_SCISSOR
	db SEED_BOMB
	db GUNK_SHOT
	db FAIRY_WIND
	db NASTY_PLOT
	db IRON_HEAD
	db METAL_SOUND
	db WILD_CHARGE
	db DRAGON_PULSE
	db MOONBLAST
	db PLAY_ROUGH
	db SHEER_COLD
	db WILLOWISP
	db EARTH_POWER
	db FOCUS_BLAST
	db AQUA_JET
	db FLARE_BLITZ
	db ROCK_POLISH
	db NASTY_PLOT
	db $ff

Function29bfb: ; 29bfb
	ld hl, PartySpecies
	ld b, PARTY_LENGTH
.asm_29c00
	ld a, [hli]
	cp $ff
	jr z, .asm_29c0c
	cp 151 + 1
	jr nc, .asm_29c42
	dec b
	jr nz, .asm_29c00
.asm_29c0c
	ld a, [PartyCount]
	ld b, a
	ld hl, PartyMon1Item
.asm_29c13
	push hl
	push bc
	ld d, [hl]
	callba ItemIsMail
	pop bc
	pop hl
	jr c, .asm_29c5e
	ld de, PartyMon2 - PartyMon1
	add hl, de
	dec b
	jr nz, .asm_29c13
	ld hl, PartyMon1Moves
	ld a, [PartyCount]
	ld b, a
.asm_29c2e
	ld c, NUM_MOVES
.asm_29c30
	ld a, [hli]

	push bc
	push hl
	push af
	ld hl, TPPNewMoves
	ld b, a

.goodMoveInRedLoop
	ld a, [hli]
	cp $ff
	jr z, .goodMoveInRedLoopExit
	cp b
	jr z, .badMovePop
	jr .goodMoveInRedLoop

.goodMoveInRedLoopExit
	pop af
	pop hl
	pop bc

	cp STRUGGLE + 1
	jr nc, .asm_29c4c
	dec c
	jr nz, .asm_29c30
	ld de, PartyMon2 - (PartyMon1 + NUM_MOVES)
	add hl, de
	dec b
	jr nz, .asm_29c2e
	xor a
	jr .asm_29c63

.asm_29c42
	ld [wd265], a
	call GetPokemonName
	ld a, $1
	jr .asm_29c63

.badMovePop
	pop af
	pop hl
	pop bc

.asm_29c4c
	push bc
	ld [wd265], a
	call GetMoveName
	call CopyName1
	pop bc
	call Function29c67
	ld a, $2
	jr .asm_29c63

.asm_29c5e
	call Function29c67
	ld a, $3
.asm_29c63
	ld [ScriptVar], a
	ret
; 29c67

Function29c67: ; 29c67
	ld a, [PartyCount]
	sub b
	ld c, a
	inc c
	ld b, $0
	ld hl, PartyCount
	add hl, bc
	ld a, [hl]
	ld [wd265], a
	call GetPokemonName
	ret
; 29c7b

Function29c7b: ; 29c7b
	ld c, $a
	call DelayFrames
	ld a, $4
	call Function29f17
	ld c, $28
	call DelayFrames
	xor a
	ld [hVBlank], a
	inc a
	ld [wLinkMode], a
	ret
; 29c92

Function29c92: ; 29c92
	ld c, $3
	call DelayFrames
	ld a, $ff
	ld [hLinkPlayer], a
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld c, $3
	call DelayFrames
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	ld c, $3
	call DelayFrames
	xor a
	ld [rSB], a
	ld [hSerialReceive], a
	ld [rSC], a
	ld c, $3
	call DelayFrames
	ld a, $ff
	ld [hLinkPlayer], a
	ld a, [rIF]
	push af
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	pop af
	ld [rIF], a
	ld hl, wcf5b
	xor a
	ld [hli], a
	ld [hl], a
	ld [hVBlank], a
	ld [wLinkMode], a
	ret
; 29ce8

Function29ce8: ; 29ce8
	ld a, $1
	ld [wcf56], a
	ld [wd265], a
	ret
; 29cf1

Function29cf1: ; 29cf1
	ld a, $2
	ld [wcf56], a
	ld [wd265], a
	ret
; 29cfa

Function29cfa: ; 29cfa
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	xor a
	ld [wcf56], a
	ld [wd265], a
	ret
; 29d11

Function29d11: ; 29d11
	call EnsureTPPBytes
	ld a, [wcf56]
	and a
	jr z, .asm_29d2f
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
.asm_29d2f
	ld a, $2
	ld [wcf5c], a
	ld a, $ff
	ld [wcf5b], a
.asm_29d39
	ld a, [hLinkPlayer]
	cp $2
	jr z, .asm_29d79
	cp $1
	jr z, .asm_29d79
	ld a, $ff
	ld [hLinkPlayer], a
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld a, $0
	ld [rSC], a
	ld a, $80
	ld [rSC], a
	ld a, [wcf5b]
	dec a
	ld [wcf5b], a
	jr nz, .asm_29d68
	ld a, [wcf5c]
	dec a
	ld [wcf5c], a
	jr z, .asm_29d8d
.asm_29d68
	ld a, $1
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	call DelayFrame
	jr .asm_29d39

.asm_29d79
	call Function908
	call DelayFrame
	call Function908
	ld c, $32
	call DelayFrames
	ld a, $1
	ld [ScriptVar], a
	ret

.asm_29d8d
	xor a
	ld [ScriptVar], a
	ret
; 29d92

EnsureTPPBytes:
	ld hl, PlayerName + 8
	ld a, 1
	cp [hl]
	ret z
	ld [hl], a
	ld a, [PartyCount]
	ld e, a
	xor a
.party_loop
	ld [CurPartyMon], a
	push de
	ld a, PartyMon1ID - PartyMon1
	call GetPartyParamLocation
	call .CheckID
	jr nz, .next
	ld hl, PartyMonOT
	ld bc, NAME_LENGTH
	ld a, [CurPartyMon]
	call AddNTimes
	call .CheckOTName
.next
	pop de
	dec e
	jr z, .done_party
	ld a, [CurPartyMon]
	inc a
	jr .party_loop

.done_party
	ld hl, .BoxAddrs
.boxes_loop
	ld a, [hli]
	cp -1
	ret z
	call GetSRAMBank
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	push hl
	ld a, [bc]
	ld e, a
	xor a
.box_loop
	ld [CurPartyMon], a
	push de
	ld hl, sBoxMon1ID - sBox
	add hl, bc
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	ld a, [CurPartyMon]
	call AddNTimes
	call .CheckID
	pop bc
	jr nz, .box_next
	ld hl, sBoxMonOT - sBox
	add hl, bc
	push bc
	ld bc, NAME_LENGTH
	ld a, [CurPartyMon]
	call AddNTimes
	call .CheckOTName
	pop bc
.box_next
	pop de
	dec e
	jr z, .done_box
	ld a, [CurPartyMon]
	inc a
	jr .box_loop

.done_box
	call CloseSRAM
	pop hl
	jr .boxes_loop

.CheckID:
	ld de, PlayerID
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	ret

.CheckOTName:
	ld c, 8
	ld de, PlayerName
.name_loop
	ld a, [de]
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, .name_loop
	ld [hl], 1
	ret

.BoxAddrs:
	dba sBox
	dba sBox1
	dba sBox2
	dba sBox3
	dba sBox4
	dba sBox5
	dba sBox6
	dba sBox7
	dba sBox8
	dba sBox9
	dba sBox10
	dba sBox11
	dba sBox12
	dba sBox13
	dba sBox14
	db -1

Function29d92: ; 29d92 (5D8F)
	ld a, $1
	ld [wcf56], a ;(91)
	ld hl, wcf5b
	ld a, $3
	ld [hli], a ;(9b)
	xor a
	ld [hl], a
	call WaitBGMap
	ld a, $2
	ld [hVBlank], a ;(a1)
	call DelayFrame
	call DelayFrame
	call Function29e0c
	xor a
	ld [hVBlank], a
	ld a, [ScriptVar]
	and a ;(b2)
	ret nz
	jp Function29f04
; 29dba

Function29dba: ; 29dba
	ld a, $5; (b7)
	ld [wcf56], a
	ld hl, wcf5b
	ld a, $3
	ld [hli], a ;(c1)
	xor a
	ld [hl], a
	call WaitBGMap ;(c4)
	ld a, $2
	ld [hVBlank], a
	call DelayFrame ;(cb)
	call DelayFrame
	call Function29e0c  ;trace 4
	ld a, [ScriptVar]
	and a
	jr z, .asm_29e08
	ld bc, rIE
.asm_29de0
	dec bc
	ld a, b
	or c
	jr nz, .asm_29de0
	ld a, [wcf51]
	cp $5
	jr nz, .asm_29e03
	ld a, $6
	ld [wcf56], a
	ld hl, wcf5b
	ld a, $1
	ld [hli], a
	ld [hl], $32
	call Function29e0c
	ld a, [wcf51]
	cp $6
	jr z, .asm_29e08
.asm_29e03
	xor a
	ld [ScriptVar], a
	ret

.asm_29e08
	xor a
	ld [hVBlank], a
	ret
; 29e0c

Function29e0c: ; 29e0c
	xor a
	ld [$ffca], a
	ld a, [wcf5b]
	ld h, a
	ld a, [wcf5c]
	ld l, a
	push hl ;trace 3
	call Function29e3b ;trace 2
	pop hl
	jr nz, .asm_29e2f
	call Function29e47
	call Function29e53
	call Function29e3b
	jr nz, .asm_29e2f
	call Function29e47
	xor a
	jr .asm_29e31

.asm_29e2f
	ld a, $1
.asm_29e31
	ld [ScriptVar], a
	ld hl, wcf5b
	xor a
	ld [hli], a
	ld [hl], a
	ret
; 29e3b

Function29e3b: ; 29e3b
	call Function87d ;trace 1
	ld hl, wcf5b
	ld a, [hli]
	inc a
	ret nz
	ld a, [hl]
	inc a
	ret
; 29e47

Function29e47: ; 29e47
	ld b, $a
.asm_29e49
	call DelayFrame
	call Function908
	dec b
	jr nz, .asm_29e49
	ret
; 29e53

Function29e53: ; 29e53
	dec h
	srl h
	rr l
	srl h
	rr l
	inc h
	ld a, h
	ld [wcf5b], a
	ld a, l
	ld [wcf5c], a
	ret
; 29e66

Function29e66: ; 29e66 ;ask if save, if yes save and ret scriptvar = 1
	ld a, [wd265] ;a = ??
	push af
	callba Function14ab2 ;ask if save, if yes save and ret nc
	ld a, $1
	jr nc, .asm_29e75 ;if saved, scriptvar = 1, else it = 0
	xor a
.asm_29e75
	ld [ScriptVar], a
	ld c, 30
	call DelayFrames
	pop af
	ld [wd265], a ;load into ??
	ret
; 29e82

Function29e82: ; 29e82
	ld a, [wd265]
	call Function29f17
	push af
	call Function908
	call DelayFrame
	call Function908
	pop af
	ld b, a
	ld a, [wd265]
	cp b
	jr nz, .asm_29eaa
	ld a, [wd265]
	inc a
	ld [wLinkMode], a
	xor a
	ld [hVBlank], a
	ld a, $1
	ld [ScriptVar], a
	ret

.asm_29eaa
	xor a
	ld [ScriptVar], a
	ret
; 29eaf

Function29eaf: ; 29eaf
	ld a, $1
	ld [wLinkMode], a
	call Function2ed3
	callab Function28000
	call Function2ee4
	xor a
	ld [hVBlank], a
	ret
; 29ec4

Function29ec4: ; 29ec4
	ld a, $2
	ld [wLinkMode], a
	call Function2ed3
	callab Function28000
	call Function2ee4
	xor a
	ld [hVBlank], a
	ret
; 29ed9

Function29ed9: ; 29ed9
	ld a, $3
	ld [wLinkMode], a
	call Function2ed3
	callab Function28000
	call Function2ee4
	xor a
	ld [hVBlank], a
	ret
; 29eee

Function29eee: ; 29eee
	xor a
	ld [wLinkMode], a
	ld c, $3
	call DelayFrames
	jp Function29f04
; 29efa

Function29efa: ; 29efa
	ld c, $28
	call DelayFrames
	ld a, $e
	jp Function29f17
; 29f04

Function29f04: ; 29f04
	ld c, $3
	call DelayFrames
	ld a, $ff
	ld [hLinkPlayer], a
	ld a, $2
	ld [rSB], a
	xor a
	ld [hSerialReceive], a
	ld [rSC], a
	ret
; 29f17

Function29f17: ; 29f17
	add $d0
	ld [wcf56], a
	ld [wcf57], a
	ld a, $2
	ld [hVBlank], a
	call DelayFrame
	call DelayFrame
.asm_29f29
	call Function83b
	ld a, [wcf51]
	ld b, a
	and $f0
	cp $d0
	jr z, .asm_29f40
	ld a, [wcf52]
	ld b, a
	and $f0
	cp $d0
	jr nz, .asm_29f29
.asm_29f40
	xor a
	ld [hVBlank], a
	ld a, b
	and $f
	ret
; 29f47

Function29f47: ; 29f47
	ld a, [hLinkPlayer]
	cp $1
	ld a, $1
	jr z, .asm_29f50
	dec a
.asm_29f50
	ld [ScriptVar], a
	ret
; 29f54

GFX_29f54: ; 29f54
INCBIN "gfx/unknown/029f54.2bpp"
; 29fe4

Function29fe4: ; 29fe4
	ld a, $0
	call GetSRAMBank
	ld d, $0
	ld b, $2
	predef FlagPredef
	call CloseSRAM
	ld a, c
	and a
	ret
; 29ff8
; 2a052
; 2a06e
;Function2a06e: ; 2a06e same as 2a052 but for water tiles. redundent with unification of table structure
;.loop
;	ld a, [hl]
;	cp $ff
;	ret z
;	push hl
;	ld a, [hli]
;	ld b, a
;	ld a, [hli]
;	ld c, a
;	inc hl
;	ld a, $3 ;check all 3 slots
;	call Function2a088
;	jr nc, .next
;	ld [de], a
;	inc de
;.next
;	pop hl
;	ld bc, $0009
;	add hl, bc
;	jr .loop
; 2a088
; 2a0b7
; 2a0e7
; 2a103
; 2a111
; 2a124
; 2a1cb
;Unknown_2a1cb: ; 2a1cb
;	;db 30,  $0
;	;db 60,  $2
;	db 80,  $4
;	db 90,  $6
;	db 95,  $8
;	db 99,  $a
;	db 100, $c
; 2a1d9
;Unknown_2a1d9: ; 2a1d9
;	db 60,  $0
;	db 90,  $2
;	db 100, $4
 ; 2a1df
; 2a200
; 2a2a0

INCLUDE "engine/roam_mons.asm"

RandomPhoneMon: ; 2a567
; Get a random monster owned by the trainer who's calling.
	push af
	callba GetRematchTrainer
	jr c, .okay_pop
	pop af
	callba Function90439
	jr .okay

.okay_pop
	pop af
.okay
	ld hl, TrainerGroups
	ld a, d
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, BANK(TrainerGroups)
	call GetFarByte2
	ld [wd002], a
	ld a, BANK(TrainerGroups)
	call GetFarHalfword
.skip_trainer
	dec e
	jr z, .skipped
.skip
	ld a, [wd002]
	call GetFarByte2
	cp -1
	jr nz, .skip
	jr .skip_trainer

.skipped
.skip_name
	ld a, [wd002]
	call GetFarByte2
	cp "@"
	jr nz, .skip_name
	ld a, [wd002]
	call GetFarByte2
	ld bc, 2
	bit TRAINERTYPE_MOVES, a
	jr z, .no_moves
	push af
	ld a, NUM_MOVES
	add c
	ld c, a
	pop af
.no_moves
	bit TRAINERTYPE_ITEM, a
	jr z, .no_item
	inc c
.no_item
	bit TRAINERTYPE_NICKNAME, a
	jr z, .got_mon_length
	ld a, PKMN_NAME_LENGTH
	add c
	ld c, a
.got_mon_length
	ld e, 0
	push hl
.count_mon
	inc e
	add hl, bc
	ld a, [wd002]
	call GetFarByte
	cp -1
	jr nz, .count_mon
	pop hl
.rand
	call Random
	and 7
	cp e
	jr nc, .rand
	inc a
.get_mon
	dec a
	jr z, .got_mon
	add hl, bc
	jr .get_mon

.got_mon
	inc hl ; species
	ld a, [wd002]
	call GetFarByte
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	ld de, StringBuffer4
	ld bc, PKMN_NAME_LENGTH
	jp CopyBytes
; 2a5e9

Function2b930: ; 2b930
	callba UpdateEnemyMonInParty
	ld hl, PartyMon1HP
	call Function2b995
	push bc
	ld hl, OTPartyMon1HP
	call Function2b995
	ld a, c
	pop bc
	cp c
	jr z, .asm_2b94c
	jr c, .asm_2b97f
	jr .asm_2b976

.asm_2b94c
	call Function2b9e1
	jr z, .asm_2b98a
	ld a, e
	cp $1
	jr z, .asm_2b976
	cp $2
	jr z, .asm_2b97f
	ld hl, PartyMon1HP
	call Function2b9a6
	push de
	ld hl, OTPartyMon1HP
	call Function2b9a6
	pop hl
	ld a, d
	cp h
	jr c, .asm_2b976
	jr z, .asm_2b970
	jr .asm_2b97f

.asm_2b970
	ld a, e
	cp l
	jr z, .asm_2b98a
	jr nc, .asm_2b97f
.asm_2b976
	ld a, [wd0ee]
	and $f0
	ld [wd0ee], a
	ret

.asm_2b97f
	ld a, [wd0ee]
	and $f0
	add $1
	ld [wd0ee], a
	ret

.asm_2b98a
	ld a, [wd0ee]
	and $f0
	add $2
	ld [wd0ee], a
	ret
; 2b995

Function2b995: ; 2b995
	ld c, $0
	ld b, $3
	ld de, $002f
.asm_2b99c
	ld a, [hli]
	or [hl]
	jr nz, .asm_2b9a1
	inc c
.asm_2b9a1
	add hl, de
	dec b
	jr nz, .asm_2b99c
	ret
; 2b9a6

Function2b9a6: ; 2b9a6
	ld de, $0000
	ld c, $3
.asm_2b9ab
	ld a, [hli]
	or [hl]
	jr z, .asm_2b9d7
	dec hl
	xor a
	ld [hProduct], a
	ld a, [hli]
	ld [hMultiplicand], a
	ld a, [hli]
	ld [$ffb5], a
	xor a
	ld [$ffb6], a
	ld a, [hli]
	ld b, a
	ld a, [hld]
	srl b
	rr a
	srl b
	rr a
	ld [hMultiplier], a
	ld b, $4
	call Divide
	ld a, [$ffb6]
	add e
	ld e, a
	ld a, [$ffb5]
	adc d
	ld d, a
	dec hl
.asm_2b9d7
	push de
	ld de, $002f
	add hl, de
	pop de
	dec c
	jr nz, .asm_2b9ab
	ret
; 2b9e1

Function2b9e1: ; 2b9e1
	ld hl, PartyMon1HP
	call Function2ba01
	jr nz, .asm_2b9f2
	ld hl, OTPartyMon1HP
	call Function2ba01
	ld e, $1
	ret

.asm_2b9f2
	ld hl, OTPartyMon1HP
	call Function2ba01
	ld e, $0
	ret nz
	ld e, $2
	ld a, $1
	and a
	ret
; 2ba01

Function2ba01: ; 2ba01
	ld d, $3
.asm_2ba03
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	or b
	jr z, .asm_2ba10
	ld a, [hli]
	cp b
	ret nz
	ld a, [hld]
	cp c
	ret nz
.asm_2ba10
	push de
	ld de, $002e
	add hl, de
	pop de
	dec d
	jr nz, .asm_2ba03
	ret
; 2ba1a

ChrisBackpic: ; 2ba1a
INCBIN "gfx/misc/player.6x6.2bpp.lz"
; 2bbaa

OldManBackpic:
INCBIN "gfx/misc/oldman.6x6.2bpp.lz"

DudeBackpic: ; 2bbaa
INCBIN "gfx/misc/dude.6x6.2bpp.lz"
; 2bcea

SECTION "WildHandling", ROMX

INCLUDE "engine/wildhandling.asm"

SECTION "Phone Trainers", ROMX
INCLUDE "data/phone_trainers.asm"

SECTION "bankB", ROMX, BANK[$B]

Function2c000: ; 2c000
	ld a, $e4
	ld [rOBP0], a
	call Function2c165
	call Function2c01c
	ld a, [wBattleMode]
	dec a
	ret z
	jp Function2c03a
; 2c012

Function2c012: ; 2c012
	ld a, $e4
	ld [rOBP0], a
	call Function2c165
	jp Function2c03a
; 2c01c

Function2c01c: ; 2c01c
	call Function2c0ad
	ld hl, PartyMon1HP
	ld de, PartyCount
	call Function2c059
	ld a, $60
	ld hl, wcfc4
	ld [hli], a
	ld [hl], a
	ld a, $8
	ld [wd003], a
	ld hl, Sprites
	jp Function2c143
; 2c03a

Function2c03a: ; 2c03a
	call Function2c0c5
	ld hl, OTPartyMon1HP
	ld de, OTPartyCount
	call Function2c059
	ld hl, wcfc4
	ld a, $48
	ld [hli], a
	ld [hl], $20
	ld a, $f8
	ld [wd003], a
	ld hl, Sprites + $18
	jp Function2c143
; 2c059

Function2c059: ; 2c059
	ld a, [de]
	push af
	ld de, Buffer1
	ld c, $6
	ld a, $34
.asm_2c062
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2c062
	pop af
	ld de, Buffer1
.asm_2c06b
	push af
	call Function2c075
	inc de
	pop af
	dec a
	jr nz, .asm_2c06b
	ret
; 2c075

Function2c075: ; 2c075
	ld a, [hli]
	and a
	jr nz, .asm_2c07f
	ld a, [hl]
	and a
	ld b, $33
	jr z, .asm_2c08b
.asm_2c07f
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	and a
	ld b, $32
	jr nz, .asm_2c08e
	dec b
	jr .asm_2c08e

.asm_2c08b
	dec hl
	dec hl
	dec hl
.asm_2c08e
	ld a, b
	ld [de], a
	ld bc, $0032
	add hl, bc
	ret
; 2c095

DrawPlayerExpBar: ; 2c095
	ld hl, .data_2c0a9
	ld de, wd004
	ld bc, 4
	call CopyBytes
	hlcoord 18, 10
	ld de, -1
	jr Function2c0f1

.data_2c0a9
	db $73
	db $77
	db $6f
	db $76
; 2c0ad

Function2c0ad: ; 2c0ad
	ld hl, .data_2c0c1
	ld de, wd004
	ld bc, 4
	call CopyBytes
	hlcoord 18, 10
	ld de, -1
	jr Function2c0f1

.data_2c0c1
	db $73, $5c, $6f, $76
; 2c0c5

Function2c0c5: ; 2c0c5
	ld hl, .data_2c0ed
	ld de, wd004
	ld bc, 4
	call CopyBytes
	hlcoord 1, 2
	ld de, 1
	call Function2c0f1
	ld a, [wBattleMode]
	dec a
	ret nz
	ld a, [TempEnemyMonSpecies]
	dec a
	call CheckCaughtMon
	ret z
	hlcoord 1, 1
	ld [hl], $5d
	ret

.data_2c0ed
	db $6d
	db $74
	db $78
	db $76
; 2c0f1

Function2c0f1: ; 2c0f1
	ld a, [wd004]
	ld [hl], a
	ld bc, $0014
	add hl, bc
	ld a, [StartFlypoint]
	ld [hl], a
	ld b, $8
.asm_2c0ff
	add hl, de
	ld a, [MovementBuffer]
	ld [hl], a
	dec b
	jr nz, .asm_2c0ff
	add hl, de
	ld a, [EndFlypoint]
	ld [hl], a
	ret
; 2c10d

Function2c10d: ; 2c10d
	call Function2c165
	ld hl, PartyMon1HP
	ld de, PartyCount
	call Function2c059
	ld hl, wcfc4
	ld a, $50
	ld [hli], a
	ld [hl], $40
	ld a, $8
	ld [wd003], a
	ld hl, Sprites
	call Function2c143
	ld hl, OTPartyMon1HP
	ld de, OTPartyCount
	call Function2c059
	ld hl, wcfc4
	ld a, $50
	ld [hli], a
	ld [hl], $68
	ld hl, Sprites + $18
	jp Function2c143
; 2c143

Function2c143: ; 2c143
	ld de, Buffer1
	ld c, $6
.asm_2c148
	ld a, [wcfc5]
	ld [hli], a
	ld a, [wcfc4]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld a, [wcfc4]
	ld b, a
	ld a, [wd003]
	add b
	ld [wcfc4], a
	inc de
	dec c
	jr nz, .asm_2c148
	ret
; 2c165

Function2c165: ; 2c165
	ld de, GFX_2c172
	ld hl, $8310
	lb bc, BANK(GFX_2c172), 4
	call Functiondc9
	ret
; 2c172

GFX_2c172: ; 2c172
INCBIN "gfx/battle/balls.2bpp"
; 2c1b2

Function2c1b2: ; 2c1b2
	call WhiteBGMap
	call Functione5f
	hlcoord 2, 3
	ld b, $9
	ld c, $e
	call TextBox
	hlcoord 4, 5
	ld de, PlayerName
	call PlaceString
	hlcoord 4, 10
	ld de, wd26b
	call PlaceString
	hlcoord 9, 8
	ld a, $69
	ld [hli], a
	ld [hl], $6a
	callba Function2c10d
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ld a, $e4
	ld [rOBP0], a
	ret
; 2c1ef

TrainerClassNames:: ; 2c1ef
	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "RIVAL@"
 	db "#MON PROF.@"
 	db "ELITE FOUR@"
 	db $4a, " TRAINER@"
 	db "ELITE FOUR@"
 	db "ELITE FOUR@"
 	db "ELITE FOUR@"
 	db "CHAMPION@"
 	db "LEADER@"
 	db "LEADER@"
 	db "LEADER@"
 	db "SCIENTIST@"
 	db "LEADER@"
 	db "YOUNGSTER@"
 	db "SCHOOLBOY@"
 	db "BIRD KEEPER@"
 	db "LASS@"
 	db "LEADER@"
 	db "COOLTRAINER@"
 	db "COOLTRAINER@"
 	db "BEAUTY@"
 	db "#MANIAC@"
 	db "ROCKET@"
 	db "GENTLEMAN@"
 	db "SKIER@"
 	db "TEACHER@"
 	db "LEADER@"
 	db "BUG CATCHER@"
 	db "FISHER@"
 	db "SWIMMER♂@"
 	db "SWIMMER♀@"
 	db "SAILOR@"
 	db "SUPER NERD@"
 	db "RIVAL@"
 	db "GUITARIST@"
 	db "HIKER@"
 	db "BIKER@"
 	db "LEADER@"
 	db "BURGLAR@"
 	db "FIREBREATHER@"
 	db "JUGGLER@"
 	db "BLACKBELT@"
 	db "ROCKET@"
 	db "PSYCHIC@"
 	db "PICNICKER@"
 	db "CAMPER@"
 	db "ROCKET@"
 	db "SAGE@"
 	db "MEDIUM@"
 	db "BOARDER@"
 	db "#FAN@"
 	db "KIMONO GIRL@"
 	db "TWINS@"
 	db "#FAN@"
 	db $4a, " TRAINER@"
 	db "LEADER@"
 	db "OFFICER@"
 	db "ROCKET@"
 	db "MYSTICALMAN@"
 	db "#MANIAC@"
 	db $4a, " PROF.@"
 	db $4a, " LEAGUE@"
 	db "BOSS@"
 	db "COOLSIBS@"
 	db "RIVAL@"
 	db "RIVAL@"
 	db "LEADER@"
 	db "LEADER@"
	db "ELF COACH'S@"
	db "ROCKET@"
 	; db $4a, " TRAINER@" ; Uncomment this if the above is rejected

AI_Redundant: ; 2c41a
; Check if move effect c will fail because it's already been used.
; Return z if the move is a good choice.
; Return nz if the move is a bad choice.

	ld a, c
	ld de, 3
	ld hl, .Moves
	call IsInArray
	jp nc, .NotRedundant
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.Moves: ; 2c42c
	dbw EFFECT_DREAM_EATER,     .DreamEater
	dbw EFFECT_HEAL,            .Heal
	dbw EFFECT_LIGHT_SCREEN,    .LightScreen
	dbw EFFECT_MIST,            .Mist
	dbw EFFECT_FOCUS_ENERGY,    .FocusEnergy
	dbw EFFECT_CONFUSE,         .Confuse
	dbw EFFECT_TRANSFORM,       .Transform
	dbw EFFECT_REFLECT,         .Reflect
	dbw EFFECT_SUBSTITUTE,      .Substitute
	dbw EFFECT_LEECH_SEED,      .LeechSeed
	dbw EFFECT_DISABLE,         .Disable
	dbw EFFECT_ENCORE,          .Encore
	dbw EFFECT_SNORE,           .Snore
	dbw EFFECT_SLEEP_TALK,      .SleepTalk
	dbw EFFECT_MEAN_LOOK,       .MeanLook
	dbw EFFECT_NIGHTMARE,       .Nightmare
	dbw EFFECT_SPIKES,          .Spikes
	dbw EFFECT_FORESIGHT,       .Foresight
	dbw EFFECT_PERISH_SONG,     .PerishSong
	dbw EFFECT_SANDSTORM,       .Sandstorm
	dbw EFFECT_ATTRACT,         .Attract
	dbw EFFECT_SAFEGUARD,       .Safeguard
	dbw EFFECT_RAIN_DANCE,      .RainDance
	dbw EFFECT_SUNNY_DAY,       .SunnyDay
	dbw EFFECT_TELEPORT,        .Teleport
	dbw EFFECT_MORNING_SUN,     .MorningSun
	dbw EFFECT_SYNTHESIS,       .Synthesis
	dbw EFFECT_MOONLIGHT,       .Moonlight
	dbw EFFECT_SWAGGER,         .Swagger
	dbw EFFECT_FUTURE_SIGHT,    .FutureSight
	dbw EFFECT_ATTACK_DOWN,     .StatDown
	dbw EFFECT_DEFENSE_DOWN,    .StatDown
	dbw EFFECT_SPEED_DOWN,      .StatDown
	dbw EFFECT_SP_ATK_DOWN,     .StatDown
	dbw EFFECT_SP_DEF_DOWN,     .StatDown
	dbw EFFECT_ACCURACY_DOWN,   .StatDown
	dbw EFFECT_EVASION_DOWN,    .StatDown
	dbw EFFECT_ATTACK_DOWN_2,   .StatDown2
	dbw EFFECT_DEFENSE_DOWN_2,  .StatDown2
	dbw EFFECT_SPEED_DOWN_2,    .StatDown2
	dbw EFFECT_SP_ATK_DOWN_2,   .StatDown2
	dbw EFFECT_SP_DEF_DOWN_2,   .StatDown2
	dbw EFFECT_ACCURACY_DOWN_2, .StatDown2
	dbw EFFECT_EVASION_DOWN_2,  .StatDown2
	db -1

.StatDown:
	ld a, c
	sub EFFECT_ATTACK_DOWN
	jr .StatDownCommon

.StatDown2:
	ld a, c
	sub EFFECT_ATTACK_DOWN_2
.StatDownCommon:
	ld c, a
	ld b, 0
	ld hl, PlayerStatLevels
	add hl, bc
	ld a, [hl]
	cp 2
	ret c
	ld a, [PlayerSubStatus4]
	bit SUBSTATUS_MIST, a
	ret

.LightScreen: ; 2c487
	ld a, [EnemyScreens]
	bit SCREENS_LIGHT_SCREEN, a
	ret

.Mist: ; 2c48d
	ld a, [EnemySubStatus4]
	bit SUBSTATUS_MIST, a
	ret

.FocusEnergy: ; 2c493
	ld a, [EnemySubStatus4]
	bit SUBSTATUS_FOCUS_ENERGY, a
	ret

.Confuse: ; 2c499
	ld a, [PlayerSubStatus3]
	bit SUBSTATUS_CONFUSED, a
	ret nz
	ld a, [PlayerScreens]
	bit SCREENS_SAFEGUARD, a
	ret

.Transform: ; 2c4a5
	ld a, [EnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret

.Reflect: ; 2c4ab
	ld a, [EnemyScreens]
	bit SCREENS_REFLECT, a
	ret

.Substitute: ; 2c4b1
	ld a, [EnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ret

.LeechSeed: ; 2c4b7
	ld a, [PlayerSubStatus4]
	bit SUBSTATUS_LEECH_SEED, a
	ret

.Disable: ; 2c4bd
	ld a, [PlayerDisableCount]
	and a
	ret

.Encore: ; 2c4c2
	ld a, [PlayerSubStatus5]
	bit SUBSTATUS_ENCORED, a
	ret

.Snore:
.SleepTalk: ; 2c4c8
	ld a, [EnemyMonStatus]
	and SLP
	jr z, .Redundant
	jr .NotRedundant

.MeanLook: ; 2c4d1
	ld a, [EnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	ret

.Nightmare: ; 2c4d7
	ld a, [BattleMonStatus]
	and a
	jr z, .Redundant
	ld a, [PlayerSubStatus1]
	bit SUBSTATUS_NIGHTMARE, a
	ret

.Spikes: ; 2c4e3
	ld a, [PlayerScreens]
	and $3
	ret

.Foresight: ; 2c4e9
	ld a, [PlayerSubStatus1]
	bit SUBSTATUS_IDENTIFIED, a
	ret

.PerishSong: ; 2c4ef
	ld a, [PlayerSubStatus1]
	bit SUBSTATUS_PERISH, a
	ret

.Sandstorm: ; 2c4f5
	ld a, [Weather]
	cp WEATHER_SANDSTORM
	jr z, .Redundant
	jr .NotRedundant

.Attract: ; 2c4fe
	callba Function377f5
	jr c, .Redundant
	ld a, [PlayerSubStatus1]
	bit SUBSTATUS_IN_LOVE, a
	ret

.Safeguard: ; 2c50c
	ld a, [EnemyScreens]
	bit SCREENS_SAFEGUARD, a
	ret

.RainDance: ; 2c512
	ld a, [Weather]
	cp WEATHER_RAIN
	jr z, .Redundant
	jr .NotRedundant

.SunnyDay: ; 2c51b
	ld a, [Weather]
	cp WEATHER_SUN
	jr z, .Redundant
	jr .NotRedundant

.DreamEater: ; 2c524
	ld a, [BattleMonStatus]
	and SLP
	jr z, .Redundant
	jr .NotRedundant

.Swagger: ; 2c52d
	ld a, [PlayerSubStatus3]
	bit SUBSTATUS_CONFUSED, a
	ret

.FutureSight: ; 2c533
	ld a, [wc71e]
	and a
	ret

.Heal:
.MorningSun:
.Synthesis:
.Moonlight: ; 2c539
	callba AICheckEnemyMaxHP
	jr nc, .NotRedundant
.Teleport:
.Redundant: ; 2c541
	ld a, 1
	and a
	ret

.NotRedundant: ; 2c545
	xor a
	ret

INCLUDE "event/move_deleter.asm"

Function2c642: ; 2c642 (b:4642)
	ld de, OverworldMap
	ld a, $1
	ld [de], a
	inc de
	ld a, $1
	call GetSRAMBank
	ld hl, $a009
	ld a, [hli]
	ld [de], a
	ld b, a
	inc de
	ld a, [hl]
	ld [de], a
	ld c, a
	inc de
	push bc
	ld hl, $a00b
	ld bc, $b
	call CopyBytes
	push de
	ld hl, $aa27
	ld b, $20
	call CountSetBits
	pop de
	pop bc
	ld a, [wd265]
	ld [de], a
	inc de
	call CloseSRAM
	call Random
	and $1
	ld [de], a
	inc de
	call Function2c6ac
	ld [de], a
	inc de
	ld a, c
	ld c, b
	ld b, a
	call Function2c6ac
	ld [de], a
	inc de
	ld a, $0
	call GetSRAMBank
	ld a, [$abe4]
	ld [de], a
	inc de
	ld a, [$abe5]
	ld [de], a
	ld a, $14
	ld [wca00], a
	call CloseSRAM
	ld hl, OverworldMap
	ld de, wc950
	ld bc, $14
	jp CopyBytes

Function2c6ac: ; 2c6ac (b:46ac)
	push de
	call Random
	cp $19
	jr c, .asm_2c6cc
	call Random
	and $7
	ld d, a
	rl d
	ld e, $80
.asm_2c6be
	rlc e
	dec a
	jr nz, .asm_2c6be
	ld a, e
	and c
	jr z, .asm_2c6c9
	ld a, $1
.asm_2c6c9
	add d
	jr .asm_2c706

.asm_2c6cc
	call Random
	cp $32
	jr c, .asm_2c6ed
	call Random
	and $3
	ld d, a
	rl d
	ld e, $80
.asm_2c6dd
	rlc e
	dec a
	jr nz, .asm_2c6dd
	ld a, e
	and b
	jr z, .asm_2c6e8
	ld a, $1
.asm_2c6e8
	add d
	add $10
	jr .asm_2c706

.asm_2c6ed
	call Random
	cp $32
	jr c, .asm_2c6fd
	ld a, b
	swap a
	and $7
	add $18
	jr .asm_2c706

.asm_2c6fd
	ld a, b
	and $80
	ld a, $20
	jr z, .asm_2c706
	ld a, $21
.asm_2c706
	pop de
	ret

Function2c708: ; 2c708 (b:4708)
	ld a, c
	cp $25
	jr nc, Function2c722
	ld hl, Unknown_2c725
	ld b, 0
	add hl, bc
	ld c, [hl]
	ret

Function2c715: ; 2c715 (b:4715)
	ld a, c
	cp $25
	jr nc, Function2c722
	ld hl, Unknown_2c74a
	ld b, 0
	add hl, bc
	ld c, [hl]
	ret

Function2c722: ; 2c722 (b:4722)
	ld c, $4
	ret
; 2c725 (b:4725)

Unknown_2c725: ; 2c725
; May or may not be items.

	db $ad, $4e, $54, $50, $4f
	db $4a, $29, $33, $31, $53
	db $2c, $35, $21, $b9, $ba
	db $bc, $6d, $ae, $27, $04
	db $2a, $2b, $41, $3f, $18
	db $16, $22, $17, $40, $15
	db $28, $8c, $1a, $3e, $20
	db $bb, $bd
; 2c74a

Unknown_2c74a: ; 2c74a
; May or may not be items.

	db $16, $1a, $1b, $1c, $1d
	db $1e, $1f, $20, $21, $22
	db $0d, $0e, $10, $23, $25
	db $26, $08, $09, $0f, $11
	db $17, $19, $01, $02, $04
	db $05, $06, $07, $0a, $12
	db $29, $0c, $2a, $14, $03
	db $24, $27
; 2c76f

Function2c76f: ; 2c76f (b:476f)
	ld a, $1
	ld [$ffaa], a
	call Function2c8d3
	ld a, $0
	ld [$ffaa], a
	ret nc
	call Function1bee
	call WaitBGMap
	ld a, [CurItem]
	dec a
	ld [wd107], a
	ld hl, TMsHMs
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wd10d], a
	call Function2c798
	scf
	ret

Function2c798: ; 2c798 (b:4798)
	ld a, [CurItem]
	ld c, a
	callab GetNumberedTMHM
	ld a, c
	ld [CurItem], a
	ret

Function2c7a7: ; 2c7a7 (b:47a7)
	ld a, [CurItem]
	ld c, a
	callab GetTMHMNumber
	ld a, c
	ld [wd265], a
	ret

GetTMHMItemMove: ; 2c7b6 (b:47b6)
	call Function2c7a7
	predef GetTMHMMove
	ret

Function2c7bf: ; 2c7bf (b:47bf)
	ld hl, Options
	ld a, [hl]
	push af
	res 4, [hl]
	ld a, [CurItem]
	cp TM01
	jr c, .asm_2c7f5
	call GetTMHMItemMove
	ld a, [wd265]
	ld [wd262], a
	call GetMoveName
	call CopyName1
	ld hl, UnknownText_0x2c8bf
	ld a, [CurItem]
	cp HM01
	jr c, .asm_2c7e9
	ld hl, UnknownText_0x2c8c4
.asm_2c7e9
	call PrintText
	ld hl, UnknownText_0x2c8c9
	call PrintText
	call YesNoBox
.asm_2c7f5
	pop bc
	ld a, b
	ld [Options], a
	ret

Function2c7fb: ; 2c7fb
	ld hl, StringBuffer2
	ld de, wd066
	ld bc, $000c
	call CopyBytes
	call WhiteBGMap
Function2c80a: ; 2c80a
	callba Function5004f
	callba Function50405
	callba Function503e0
	ld a, $3
	ld [PartyMenuActionText], a
.asm_2c821
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9
	call DelayFrame
	callba PartyMenuSelect
	push af
	ld a, [CurPartySpecies]
	cp EGG
	pop bc
	jr z, .asm_2c854
	push bc
	ld hl, wd066
	ld de, StringBuffer2
	ld bc, $000c
	call CopyBytes
	pop af
	ret

.asm_2c854
	push hl
	push de
	push bc
	push af
	ld de, SFX_WRONG
	call PlaySFX
	call WaitSFX
	pop af
	pop bc
	pop de
	pop hl
	jr .asm_2c821
; 2c867

Function2c867: ; 2c867
	predef CanLearnTMHMMove
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call GetNick
	pop bc
	ld a, c
	and a
	jr nz, .asm_2c88b
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld hl, UnknownText_0x2c8ce
	call PrintText
	jr .asm_2c8b6

.asm_2c88b
	callab KnowsMove
	jr c, .asm_2c8b6
	ld b, 1
	predef LearnMove
	ld a, b
	and a
	jr z, .asm_2c8b6
	callba Function106049
	ld a, [CurItem]
	call IsHM ;return if a HM
	ret c
	; ld c, $5
	; callab ChangeHappiness ;+ new move happiness
	; call Function2cb0c ; remove TM from TM pocket
	jr .asm_2c8bd

.asm_2c8b6
	and a
	ret

.asm_2c8b8
	ld a, $2
	ld [wd0ec], a
.asm_2c8bd
	scf
	ret
; 2c8bf (b:48bf)

UnknownText_0x2c8bf: ; 0x2c8bf
	; Booted up a TM.
	text_jump UnknownText_0x1c0373
	db "@"
; 0x2c8c4

UnknownText_0x2c8c4: ; 0x2c8c4
	; Booted up an HM.
	text_jump UnknownText_0x1c0384
	db "@"
; 0x2c8c9

UnknownText_0x2c8c9: ; 0x2c8c9
	; It contained @ . Teach @ to a #MON?
	text_jump UnknownText_0x1c0396
	db "@"
; 0x2c8ce

UnknownText_0x2c8ce: ; 0x2c8ce
	; is not compatible with @ . It can't learn @ .
	text_jump UnknownText_0x1c03c2
	db "@"
; 0x2c8d3

Function2c8d3: ; 2c8d3 (b:48d3)
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function2c9e2
	ld a, $2
	ld [wcfa1], a
	ld a, $7
	ld [wcfa2], a
	ld a, $1
	ld [wcfa4], a
	ld a, $5
	sub d
	inc a
	cp $6
	jr nz, .asm_2c8f1
	dec a
.asm_2c8f1
	ld [wcfa3], a
	ld a, $c
	ld [wcfa5], a
	xor a
	ld [wcfa6], a
	ld a, $20
	ld [wcfa7], a
	ld a, $f3
	ld [wcfa8], a
	ld a, [wd0dc]
	inc a
	ld [wcfa9], a
	ld a, $1
	ld [wcfaa], a
	jr Function2c946

Function2c915: ; 2c915 (b:4915)
	call Function2c9e2
	call Function1bc9
	ld b, a
	ld a, [wcfa9]
	dec a
	ld [wd0dc], a
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, [wcfa6]
	bit 7, a
	jp nz, Function2c9b1
	ld a, b
	ld [wcf73], a
	bit 0, a
	jp nz, Function2c974
	bit 1, a
	jp nz, Function2c9a5
	bit 4, a
	jp nz, Function2c9af
	bit 5, a
	jp nz, Function2c9af
Function2c946: ; 2c946 (b:4946)
	call Function2c98a
	jp nc, Function2c9af
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld a, [CurItem]
	cp $3a
	jr nc, Function2c915
	ld [wd265], a
	predef GetTMHMMove
	ld a, [wd265]
	ld [CurSpecies], a
	hlcoord 1, 14
	call PrintMoveDesc
	jp Function2c915

Function2c974: ; 2c974 (b:4974)
	call Function2cad6
	call Function2cb2a
	ld a, [wcfa9]
	dec a
	ld b, a
	ld a, [wd0e2]
	add b
	ld b, a
	ld a, [wd265]
	cp b
	jr z, asm_2c9a8
Function2c98a: ; 2c98a (b:498a)
	call Function2cab5
	ld a, [wcfa9]
	ld b, a
.asm_2c991
	inc c
	ld a, c
	cp $3a
	jr nc, .asm_2c99f
	ld a, [hli]
	and a
	jr z, .asm_2c991
	dec b
	jr nz, .asm_2c991
	ld a, c
.asm_2c99f
	ld [CurItem], a
	cp $ff
	ret

Function2c9a5: ; 2c9a5 (b:49a5)
	call Function2cad6
asm_2c9a8: ; 2c9a8 (b:49a8)
	ld a, $2
	ld [wcf73], a
	and a
	ret

Function2c9af: ; 2c9af (b:49af)
	and a
	ret

Function2c9b1: ; 2c9b1 (b:49b1)
	ld a, b
	bit 7, a
	jr nz, .asm_2c9c5
	ld hl, wd0e2
	ld a, [hl]
	and a
	jp z, Function2c915
	dec [hl]
	call Function2c9e2
	jp Function2c946

.asm_2c9c5
	call Function2cab5
	ld b, $5
.asm_2c9ca
	inc c
	ld a, c
	cp $3a
	jp nc, Function2c915
	ld a, [hli]
	and a
	jr z, .asm_2c9ca
	dec b
	jr nz, .asm_2c9ca
	ld hl, wd0e2
	inc [hl]
	call Function2c9e2
	jp Function2c946

Function2c9e2: ; 2c9e2 (b:49e2)
	ld a, [BattleType]
	cp BATTLETYPE_TUTORIAL
	jp z, Function2caca
	hlcoord 5, 2
	ld bc, $a0f
	ld a, $7f
	call ClearBox
	call Function2cab5
	ld d, $5
.asm_2c9fa
	inc c
	ld a, c
	cp $3a
	jr nc, .asm_2ca77
	ld a, [hli]
	and a
	jr z, .asm_2c9fa
	ld b, a
	ld a, c
	ld [wd265], a
	push hl
	push de
	push bc
	call Function2ca86
	push hl
	ld a, [wd265]
	cp $33
	jr nc, .asm_2ca22
	ld de, wd265
	ld bc, $8102
	call PrintNum
	jr .asm_2ca38

.asm_2ca22
	push af
	sub $32
	ld [wd265], a
	ld [hl], $87
	inc hl
	ld de, wd265
	ld bc, $4102
	call PrintNum
	pop af
	ld [wd265], a
.asm_2ca38
	predef GetTMHMMove
	ld a, [wd265]
	ld [wd262], a
	call GetMoveName
	pop hl
	ld bc, $3
	add hl, bc
	call PlaceString
	pop bc
	pop de
	pop hl
	dec d
	jr nz, .asm_2c9fa
	jr .asm_2ca85

.asm_2ca77
	call Function2ca86
	inc hl
	inc hl
	inc hl
	push de
	ld de, String_2caae
	call PlaceString
	pop de
.asm_2ca85
	ret

Function2ca86: ; 2ca86 (b:4a86)
	hlcoord 5, 0
	ld bc, $28
	ld a, $6
	sub d
	ld e, a
.asm_2ca90
	add hl, bc
	dec e
	jr nz, .asm_2ca90
	ret
; 2ca95 (b:4a95)

Function2ca95: ; 2ca95
	pop hl
	ld bc, $0003
	add hl, bc
	predef GetTMHMMove
	ld a, [wd265]
	ld [wd262], a
	call GetMoveName
	push hl
	call PlaceString
	pop hl
	ret
; 2caae

String_2caae: ; 2caae
	db "CANCEL@"
; 2cab5

Function2cab5: ; 2cab5 (b:4ab5)
	ld hl, TMsHMs
	ld a, [wd0e2]
	ld b, a
	inc b
	ld c, $0
.asm_2cabf
	inc c
	ld a, [hli]
	and a
	jr z, .asm_2cabf
	dec b
	jr nz, .asm_2cabf
	dec hl
	dec c
	ret

Function2caca: ; 2caca (b:4aca)
	hlcoord 9, 3
	push de
	ld de, String_2caae
	call PlaceString
	pop de
	ret

Function2cad6: ; 2cad6 (b:4ad6)
	push de
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	pop de
	ret
; 2cadf (b:4adf)

Function2cadf: ; 2cadf
	call Function2c7a7
	call Function2cafa
	ld hl, UnknownText_0x2caf0
	jr nc, .asm_2caed
	ld hl, UnknownText_0x2caf5
.asm_2caed
	jp PrintText
; 2caf0

UnknownText_0x2caf0: ; 0x2caf0
	; You have no room for any more @ S.
	text_jump UnknownText_0x1c03fa
	db "@"
; 0x2caf5

UnknownText_0x2caf5: ; 0x2caf5
	; You received @ !
	text_jump UnknownText_0x1c0421
	db "@"
; 0x2cafa

Function2cafa: ; 2cafa
	ld a, [wd265]
	dec a
	ld hl, TMsHMs
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	inc a
	cp NUM_TMS * 2
	ret nc
	ld [hl], a
	ret
; 2cb0c

;Function2cb0c: ; 2cb0c (b:4b0c)
;	call Function2c7a7
;	ld a, [wd265]
;	dec a
;	ld hl, TMsHMs ;location of TM pocket?
;	ld b, 0
;	ld c, a
;	add hl, bc
;	ld a, [hl] ;decrement item by 1?
;	and a
;	ret z
;	dec a
;	ld [hl], a
;	ret nz
;	ld a, [wd0e2]
;	and a
;	ret z
;	dec a
;	ld [wd0e2], a
;	ret

Function2cb2a: ; 2cb2a (b:4b2a)
	ld b, $0
	ld c, $39
	ld hl, TMsHMs
.asm_2cb31
	ld a, [hli]
	and a
	jr z, .asm_2cb36
	inc b
.asm_2cb36
	dec c
	jr nz, .asm_2cb31
	ld a, b
	ld [wd265], a
	ret

PrintMoveDesc: ; 2cb3e
	push hl
	ld hl, MoveDescriptions
	ld a, [CurSpecies]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceString
; 2cb52

MoveDescriptions:: ; 2cb52
INCLUDE "battle/moves/move_descriptions.asm"
; 2ed44

Function2ed44: ; 2ed44
	call ConvertBerriesToBerryJuice
	ld hl, PartyMon1PokerusStatus
	ld a, [PartyCount]
	ld b, a
	ld de, PartyMon2 - PartyMon1
.loopMons
	ld a, [hl]
	and $f
	jr nz, .monHasActivePokerus
	add hl, de
	dec b
	jr nz, .loopMons
	ld hl, StatusFlags2
	bit 6, [hl]
	ret z
	call Random
	ld a, [hRandomAdd]
	and a
	ret nz
	ld a, [hRandomSub]
	cp $3
	ret nc                 ; 3/65536 chance (00 00, 00 01 or 00 02)
	ld a, [PartyCount]
	ld b, a
.randomMonSelectLoop
	call Random
	and $7
	cp b
	jr nc, .randomMonSelectLoop
	ld hl, PartyMon1PokerusStatus
	call GetPartyLocation  ; get pokerus byte of random mon
	ld a, [hl]
	and $f0
	ret nz                 ; if it already has pokerus, do nothing
.randomPokerusLoop
	call Random
	and a
	jr z, .randomPokerusLoop
	ld b, a
	and $f0
	jr z, .asm_2ed91
	ld a, b
	and $7
	inc a
	ld b, a
.asm_2ed91
	ld a, b
	swap b
	and $3
	inc a
	add b
	ld [hl], a
	ret

.monHasActivePokerus
	call Random
	cp $55
	ret nc              ; 1/3 chance
	ld a, [PartyCount]
	cp $1
	ret z               ; only one mon, nothing to do
	ld c, [hl]
	ld a, b
	cp $2
	jr c, .checkPreviousMonsLoop    ; no more mons after this one, go backwards
	call Random
	cp $80
	jr c, .checkPreviousMonsLoop    ; 1/2 chance, go backwards
.checkFollowingMonsLoop
	add hl, de
	ld a, [hl]
	and a
	jr z, .infectMon
	ld c, a
	and $3
	ret z               ; if mon has cured pokerus, stop searching
	dec b               ; go on to next mon
	ld a, b
	cp $1
	jr nz, .checkFollowingMonsLoop ; no more mons left
	ret

.checkPreviousMonsLoop
	ld a, [PartyCount]
	cp b
	ret z               ; no more mons
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, [hl]
	and a
	jr z, .infectMon
	ld c, a
	and $3
	ret z               ; if mon has cured pokerus, stop searching
	inc b               ; go on to next mon
	jr .checkPreviousMonsLoop

.infectMon
	ld a, c
	and $f0
	ld b, a
	ld a, c
	swap a
	and $3
	inc a
	add b
	ld [hl], a
	ret
; 2ede6
; any berry held by a Shuckle may be converted to berry juice

ConvertBerriesToBerryJuice: ; 2ede6
	ld hl, StatusFlags2
	bit 6, [hl]
	ret z
	call Random
	cp $10
	ret nc              ; 1/16 chance
	ld hl, PartyMons
	ld a, [PartyCount]
.partyMonLoop
	push af
	push hl
	ld a, [hl]
	cp SHUCKLE
	jr nz, .nextMon
	ld bc, PartyMon1Item - PartyMon1Species
	add hl, bc
	ld a, [hl]
	cp BERRY
	jr z, .convertToJuice
.nextMon
	pop hl
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop af
	dec a
	jr nz, .partyMonLoop
	ret

.convertToJuice
	ld a, BERRY_JUICE
	ld [hl], a
	pop hl
	pop af
	ret
; 2ee18

Function2ee18: ; 2ee18
	ld a, [wLinkMode]
	and a
	ret z
	callba Function2c1b2
	ld c, 150
	call DelayFrames
	call ClearTileMap
	call ClearSprites
	ret
; 2ee2f

Function2ee2f: ; 2ee2f
	xor a
	ld [$ffde], a
	call DelayFrame
	ld a, [OtherTrainerClass]
	and a
	jr z, .wild
	call GetFirstEnemyTrainerLevel
	jr .skip
.wild
	ld a, [CurPartyLevel]
	ld [EnemyMonLevel], a
.skip
	predef Function8c20f
	callba Function3ed9f
	ld a, 1
	ld [hBGMapMode], a
	call ClearSprites
	call ClearTileMap
	xor a
	ld [hBGMapMode], a
	ld [hWY], a
	ld [rWY], a
	ld [$ffde], a
	ret
; 2ee6c
GetFirstEnemyTrainerLevel:
    ld a, [OtherTrainerClass]
	and a
	ret z
	cp CAL
	jr z, .cal
	cp TPPPC
	jr nz, .proceed
	ld a, [OtherTrainerID]
	cp MIRROR
	jr z, .MirrorBattle
.not_cal2
	ld a, [OtherTrainerClass]
.proceed
    dec a
    ld e, a
    ld d, 0
    ld hl, TrainerGroups
    add hl, de
    add hl, de
    add hl, de
    ld a, BANK(TrainerGroups)
    call GetFarByte2
    ld b, a
    ld a, BANK(TrainerGroups)
    call GetFarHalfword
	ld a, [OtherTrainerID]
	dec a
	jr z, .loop2
	ld c, a
.loop
	ld a, b
	call GetFarByte2
	cp $ff
	jr nz, .loop
	dec c
	jr nz, .loop
.loop2
	ld a, b
	call GetFarByte2
	cp $50
	jr nz, .loop2
	inc hl
	ld a, b
	call GetFarByte
	ld [EnemyMonLevel], a
	ret

.MirrorBattle
	ld a, [PartyMon1Level]
	ld [EnemyMonLevel], a
	ret

.cal
	ld a, [OtherTrainerID]
	cp CAL2
	jr nz, .not_cal2
	ld a, BANK(sMysteryGiftTrainer)
	call GetSRAMBank
	ld hl, sMysteryGiftTrainer
	ld a, [hl]
	ld [EnemyMonLevel], a
	call CloseSRAM
	ret


PUSHS
INCLUDE "misc/restoremusic.asm"

POPS
PlayBattleMusic: ; 2ee6c
	push hl
	push de
	push bc
	callab SaveMusic
	xor a
	ld [MusicFade], a
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	call MaxVolume
	ld a, [BattleType]
	cp BATTLETYPE_SUICUNE
	ld de, MUSIC_SUICUNE_BATTLE
	jp z, .done
	cp BATTLETYPE_ROAMING
	jp z, .done

	cp BATTLETYPE_KANTOLEGEND
	ld de, MUSIC_KANTO_LEGEND
	jp z, .done
	; Are we fighting a trainer?
	ld a, [OtherTrainerClass]
	and a
	jr nz, .trainermusic
	ld a, [wd22e]
	cp HO_OH
	ld de, MUSIC_HOOH_BATTLE
	jp z, .done
	cp LUGIA
	ld de, MUSIC_LUGIA_BATTLE
	jp z, .done
	callba RegionCheck
	ld a, e
	and a
	jr nz, .kantowild
	ld de, MUSIC_JOHTO_WILD_BATTLE
	ld a, [TimeOfDay]
	cp NITE
	jp nz, .done
	ld de, MUSIC_JOHTO_WILD_BATTLE_NIGHT
	jp .done

.kantowild
	ld de, MUSIC_KANTO_WILD_BATTLE
	jp .done

.trainermusic
	ld de, MUSIC_CHAMPION_BATTLE
	cp CHAMPION
	jp z, .done
	cp RED
	jp z, .done
	cp POKEMON_PROF
	jp z, .done
	cp BABA
	jp z, .done
	ld de, MUSIC_VS_WCS
	cp PROF_ELM
	jr z, .done
	; really, they should have included admins and scientists here too...
	ld de, MUSIC_ROCKET_BATTLE
	call RocketMusicCheck
	jr c, .okay_rocket
	ld de, MUSIC_KANTO_TRAINER_BATTLE
.okay_rocket
	cp GRUNTM
	jr z, .done
	cp GRUNTF
	jr z, .done
	cp EXECUTIVEM
	jr z, .done
	cp EXECUTIVEF
	jr z, .done
	cp SCIENTIST
	jr z, .scientist
	cp EXECUTIVE_EGK
	jr z, .done
	ld de, MUSIC_RIVAL_BATTLE_RB
	cp BLUE_RB
	jr z, .egk_check
	cp BLUE_RB_F
	jr z, .egk_check
	ld de, MUSIC_KANTO_GYM_LEADER_BATTLE
	callba IsKantoGymLeader
	jr c, .done
	ld de, MUSIC_JOHTO_GYM_LEADER_BATTLE
	callba IsJohtoGymLeader
	jr c, .done
	ld de, MUSIC_RIVAL_BATTLE
	ld a, [OtherTrainerClass]
	cp RIVAL1
	jr z, .done
	cp RIVAL2
	jr nz, .othertrainer
	ld a, [OtherTrainerID]
	cp 4 ; Rival in Indigo Plateau
	jr c, .done
	ld de, MUSIC_CHAMPION_BATTLE
	jr .done

.scientist
	ld a, [InBattleTowerBattle]
	bit 0, a
	jr z, .done
.othertrainer
	ld a, [wLinkMode]
	and a
	jr nz, .johtotrainer
	callba RegionCheck
	ld a, e
	and a
	jr nz, .kantotrainer
.johtotrainer
	ld de, MUSIC_JOHTO_TRAINER_BATTLE
	jr .done

.kantotrainer
	ld de, MUSIC_KANTO_TRAINER_BATTLE
.done
	call PlayMusic
	pop bc
	pop de
	pop hl
	ret
; 2ef18

.egk_check
	ld a, [StatusFlags]
	bit 5, a
	jr z, .done
	ld de, MUSIC_CHAMPION_BATTLE_RB
	jr .done

ClearBattleRAM: ; 2ef18
	xor a
	ld [wd0ec], a
	ld [wd0ee], a
	ld hl, wd0d8
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wd0e4], a
	ld [CriticalHit], a
	ld [BattleMonSpecies], a
	ld [wAliveExperienceSharers], a
	ld [CurBattleMon], a
	ld [wd232], a
	ld [TimeOfDayPal], a
	ld [PlayerTurnsTaken], a
	ld [EnemyTurnsTaken], a
	ld [EvolvableFlags], a
	ld hl, PlayerHPPal
	ld [hli], a
	ld [hl], a
	ld hl, BattleMonDVs
	ld [hli], a
	ld [hl], a
	ld hl, EnemyMonDVs
	ld [hli], a
	ld [hl], a
; Clear the entire BattleMons area

	ld hl, wBattle
	ld bc, wBattleEnd - wBattle
	xor a
	call ByteFill
	callab ResetEnemyStatLevels
	call Function1fbf
	ld hl, hBGMapAddress
	xor a
	ld [hli], a
	ld [hl], $98
	ret
; 2ef6e

FillBox: ; 2ef6e
; Fill wc2c6-aligned box width b height c
; with iterating tile starting from $ffad at hl.
; Predef $13

	ld de, 20
	ld a, [wc2c6]
	and a
	jr nz, .left
	ld a, [$ffad]
.x1
	push bc
	push hl
.y1
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .y1
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .x1
	ret

.left
; Right-aligned.

	push bc
	ld b, 0
	dec c
	add hl, bc
	pop bc
	ld a, [$ffad]
.x2
	push bc
	push hl
.y2
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .y2
	pop hl
	dec hl
	pop bc
	dec b
	jr nz, .x2
	ret
; 2ef9f

SECTION "Tileset Data 4", ROMX, BANK[TILESETS_4]

INCLUDE "tilesets/data_4.asm"

SECTION "bankD", ROMX, BANK[$D]

INCLUDE "battle/effect_commands.asm"

SECTION "bankD_2", ROMX

Function3952d: ; 3952d
	ld hl, RivalName
	ld a, c ;trainer class
	cp RIVAL1
	jr z, .rival ;if equal to rival 1, jump
	ld [CurSpecies], a
	ld a, TRAINER_NAME
	ld [wcf61], a ;ld 7 into var
	call GetName ;put trainer class name in string buffer and make de a pointer to it
	ld de, StringBuffer1
	ret

.rival
	ld de, StringBuffer1
	push de
	ld bc, NAME_LENGTH
	call CopyBytes
	pop de
	ret

SECTION "bankE", ROMX, BANK[$E]

INCLUDE "battle/ai/items.asm"

AIScoring: ; 38591
INCLUDE "battle/ai/scoring.asm"
; 39550

Function39550: ; 39550
	ld hl, wd26b
	ld a, [wLinkMode]
	and a
	jr nz, .ok
	ld hl, RivalName
	ld a, c
	cp RIVAL1
	jr z, .ok
	ld [CurSpecies], a
	ld a, TRAINER_NAME
	ld [wcf61], a
	call GetName
	ld hl, StringBuffer1
.ok
	ld bc, $000d
	ld de, OTClassName
	push de
	call CopyBytes
	pop de
	ret
; 3957b

Function3957b: ; 3957b
	ld a, [TrainerClass]
	ld c, a
	call Function39550
	ld a, [InBattleTowerBattle]
	bit 0, a
	jr nz, .BattleTower
	ld a, [TrainerClass]
	dec a
	ld hl, TrainerClassAttributes
	ld bc, 7
	call AddNTimes
	ld de, wc650
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	jr .finish

.BattleTower
	xor a
	ld hl, wc650
	ld [hli], a
	ld [hl], a
	ld a, [TrainerClass]
	dec a
	ld hl, TrainerClassAttributes + 2
	ld bc, 7
	call AddNTimes
.finish
	ld a, [hl]
	ld [wc652], a
	ret
; 3959c

INCLUDE "trainers/attributes.asm"

ReadTrainerParty: ; 39771
	ld a, [InBattleTowerBattle]
	bit 0, a
	ret nz
	ld a, [wLinkMode]
	and a
	ret nz
	ld hl, wdff5
	xor a
	ld [hli], a
	ld [hl], a
	callba ClearOTMons
	ld a, [OtherTrainerClass]
	cp CAL
	jr nz, .not_cal2
	ld a, [OtherTrainerID]
	cp CAL2
	jr nz, .not_tppPc
	ld hl, wdff5 + 1
	ld [hl], 1
	ld a, $0
	call GetSRAMBank
	ld de, $ac0a
	call TrainerType
	call CloseSRAM
	jp ComputeTrainerReward

.not_cal2
	cp TPPPC
	jr nz, .not_tppPc
	ld a, [OtherTrainerID]
	cp PC_SURVIVAL
	ld hl, wSurvivalModeParty
	jp z, .done_name
	cp MIRROR
	jr nz, .not_tppPc
	callba CopyMirrorBattle
	jp ComputeTrainerReward

.not_tppPc
	ld a, [OtherTrainerClass]
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wdff5], a ;load start of trainer
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld a, [OtherTrainerID]
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer ;loop down the correct number of trainers
.next
	ld a, [wdff5]
	call GetFarByte2
	cp $ff
	jr nz, .next
	jr .skip_trainer

.got_trainer
.skip_name
	ld a, [wdff5]
	call GetFarByte2
	cp "@"
	jr nz, .skip_name ;advance pointer until end of name
	ld a, [wdff5]
	call GetFarByte2
	ld [wdff5 + 1], a ;load in trainertype
.done_name
	ld bc, ComputeTrainerReward ; Return to the start of this function
	push bc
TrainerType:
._loop
	ld a, [wdff5]
	call GetFarByte2
	cp $ff
	ret z
	cp 101
	jr c, .level_okay
	ld a, 100
.level_okay
	ld [CurPartyLevel], a ;else load in as level
	ld a, [wdff5]
	call GetFarByte2
	cp NUM_POKEMON + 1
	jr c, .species_okay
	ld a, UNOWN
.species_okay
	ld [CurPartySpecies], a ;load species in
	ld a, OTPARTYMON ;load montype
	ld [MonType], a
	push hl
	predef Functiond88c ;load in mon
	pop hl
	ld a, [wdff5 + 1]
	bit TRAINERTYPE_ITEM, a
	jr z, .no_item
	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1Item
	ld bc, OTPartyMon2 - OTPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld a, [wdff5]
	call GetFarByte2
	ld [de], a
.no_item
	ld a, [wdff5 + 1]
	bit TRAINERTYPE_NICKNAME, a
	jr z, .no_nick

	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call AddNTimes
	push hl
	ld bc, PKMN_NAME_LENGTH
	ld a, "@"
	call ByteFill
	pop de
	pop hl
	ld b, PKMN_NAME_LENGTH
.copy_nick
	ld a, [wdff5]
	call GetFarByte2
	cp "@"
	jr z, .copied_nick
	ld [de], a
	inc de
	dec b
	jr nz, .copy_nick
	jr .copied_nick

.no_nick
	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, StringBuffer1
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	pop hl
.copied_nick
	ld a, [wdff5 + 1]
	bit TRAINERTYPE_MAXXP, a
	jr z, .no_maxxp
	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1StatExp
	ld bc, OTPartyMon2 - OTPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	push de
	ld a, $ff
	rept 10
	ld [de], a
	inc de
	endr
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1HP
	ld bc, OTPartyMon2 - OTPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	pop hl ;stat xp start
	dec hl ;makes it not break?
	ld b, 1
	ld c, 1
	predef CalcPkmnStatC ; calc hp, put into in $ffb5 and $ffb6.
	ld a, [$ffb5] ;load hp
	ld [de], a
	inc de
	ld a, [$ffb6]
	ld [de], a
	inc de
	predef CalcPkmnStats
	pop hl
.no_maxxp
	ld a, [wdff5 + 1]
	bit TRAINERTYPE_MOVES, a
	jp z, ._loop

	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1Moves
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	ld b, NUM_MOVES
.copy_moves
	ld a, [wdff5]
	call GetFarByte2
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves
	push hl
	ld a, [OTPartyCount]
	dec a
	ld hl, OTPartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, OTPartyMon1PP - OTPartyMon1
	add hl, de
	push hl
	ld hl, OTPartyMon1Moves - OTPartyMon1
	add hl, de
	pop de
	ld b, NUM_MOVES
.copy_pp
	ld a, [wdff5]
	call GetFarByte2
	and a
	jr z, .copied_pp
	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl
	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp
	pop hl
	jp ._loop

ComputeTrainerReward: ; 3991b (e:591b)
	ld hl, $ffb3
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, [wc652] ; base reward
	ld [hli], a
	ld a, [CurPartyLevel]
	ld [hl], a
	call Multiply
	ld hl, wc686
	xor a
	ld [hli], a
	ld a, [$ffb5]
	ld [hli], a
	ld a, [$ffb6]
	ld [hl], a
	ret

Function39939:: ; 39939
	ld a, [StatusFlags]
	bit 5, a
	jr nz, .skip
	push bc
	ld de, EVENT_ROCKET_TAKEOVER_OF_SS_ANNE
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	pop bc
	and a
	jr z, .skip
	ld hl, ReadTrainerName_GruntName
	ld de, StringBuffer1
	ld bc, $b
	call CopyBytes
	ret

.skip
	ld a, [InBattleTowerBattle]
	bit 0, a
	ld hl, wd26b
	jp nz, Function39984
	ld a, [OtherTrainerID]
	ld b, a
	ld a, [OtherTrainerClass]
	ld c, a
Function3994c:: ; 3994c
	ld a, c
	cp CAL
	jr nz, .asm_3996d ;if trainer class is not cal, jump
	ld a, $0
	call GetSRAMBank
	ld a, [$abfd]
	and a ;load something?
	call CloseSRAM
	jr z, .asm_3996d ;if zero jump
	ld a, $0
	call GetSRAMBank
	ld hl, $abfe
	call Function39984 ;copy string from ???? to stringbuffer
	jp CloseSRAM ;ret from there
.asm_3996d
	dec c
	push bc ;holds trainer class -1 in c
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc ;find correct group
	ld a, [hli]
	ld [wdff5],a ;load bank(?) into variable and address into hl
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
.asm_3997a
	dec b ; loop until correct name
	jr z, Function39984 ;store name in string buffer
.asm_3997d
	; ld a, [hli]
	ld a, [wdff5] ; load bank into a
	call GetFarByte2 ;get the first letter of that classes first trainers name and move onto next letter
	cp $ff ;if not end of trainer
	jr nz, .asm_3997d ; check next byte
	jr .asm_3997a ;else check if this trainer
Function39984: ; 39984
	ld de, StringBuffer1
	push de
	ld bc, $000b
	ld a, [wdff5] ;bank to look in
	call FarCopyBytes ;copy into stringbuffer
	pop de
	ret
; 39990
ReadTrainerName_GruntName:
	db "GRUNT@"

INCLUDE "trainers/trainer_pointers.asm"

SECTION "Trainers 1", ROMX
INCLUDE "trainers/trainers.asm"
SECTION "Trainers 2", ROMX
INCLUDE "trainers/trainers2.asm"

SECTION "bankF", ROMX, BANK[$F]

INCLUDE "battle/core.asm"

SECTION "effect command pointers", ROMX

INCLUDE "battle/effect_command_pointers.asm"
CopyMirrorBattle:
	ld hl, PartyCount
	ld de, OTPartyCount
	ld bc, PARTY_STRUCT_LENGTH
	call CopyBytes
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Level
	ld bc, $30
	call AddNTimes
	ld a, [hl]
	ld [CurPartyLevel], a
	ret

ClearOTMons:
	ld hl, OTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, OTPartyMons
	ld bc, OTPartyMonsEnd - OTPartyMons
	xor a
	call ByteFill
	ret

Function39990: ; 39990
	ld de, StringBuffer1
	push de
	ld bc, $000b
	pop de
	ret
; 39999

SECTION "Pokedex", ROMX


INCLUDE "engine/pokedex.asm"

; 41ad7


; 41afb
SECTION "bank10", ROMX, BANK[$10]


INCLUDE "battle/moves/moves.asm"

Function421d8: ; 421d8
	ld hl, EvolvableFlags
	xor a
	ld [hl], a
	ld a, [CurPartyMon]
	ld c, a
	ld b, $1
	call Function42577
Function421e6: ; 421e6
	xor a
	ld [wd268], a
	dec a
	ld [CurPartyMon], a
	push hl
	push bc
	push de
	ld hl, PartyCount
	push hl
Function421f5: ; 421f5
	ld hl, CurPartyMon
	inc [hl]
	pop hl
	inc hl
	ld a, [hl]
	cp $ff
	jp z, Function423ff
	ld [Buffer1], a
	push hl
	ld a, [CurPartyMon]
	ld c, a
	ld hl, EvolvableFlags
	ld b, 2
	call Function42577
	ld a, c
	and a
	jp z, Function421f5
	ld a, [Buffer1]
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	xor a
	ld [MonType], a
	predef Function5084a
	pop hl
.loop
	ld a, [hli]
	and a
	jr z, Function421f5
	ld b, a
	cp EVOLVE_TRADE
	jp z, .trade
	ld a, [wLinkMode]
	and a
	jp nz, .DontEvolve2
	ld a, b
	cp EVOLVE_ITEM
	jp z, .item
	ld a, [wd1e9]
	and a
	jp nz, .DontEvolve2
	ld a, b
	cp EVOLVE_LEVEL
	jp z, .level
	cp EVOLVE_HAPPINESS
	jr z, .happiness

	cp EVOLVE_LEVEL_ITEM
	jp z, .levelitem
; EVOLVE_STAT

	ld a, [TempMonLevel]
	cp [hl]
	jp c, .DontEvolve3
	call CheckMonHoldingEverstone
	jp z, .DontEvolve3
	push hl
	ld de, TempMonAttack
	ld hl, TempMonDefense
	ld c, 2
	call StringCmp
	ld a, ATK_EQ_DEF
	jr z, .asm_4227a
	ld a, ATK_LT_DEF
	jr c, .asm_4227a
	ld a, ATK_GT_DEF
.asm_4227a
	pop hl
	inc hl
	cp [hl]
	jp nz, .DontEvolve2
	inc hl
	jp .GoAheadAndEvolve

.happiness
	ld a, [StatusFlags]
	bit 7, a
	jp z, .DontEvolve2
	ld a, [TempMonHappiness]
	cp 220
	jp c, .DontEvolve2
	call CheckMonHoldingEverstone
	jp z, .DontEvolve2
	ld a, [hli]
	cp TR_ANYTIME
	jp z, .GoAheadAndEvolve
	cp TR_MORNDAY
	jr z, .asm_422a4
; TR_NITE

	ld a, [TimeOfDay]
	cp NITE
	jp nz, .DontEvolve
	jp .GoAheadAndEvolve

.asm_422a4
	ld a, [TimeOfDay]
	cp NITE
	jp z, .DontEvolve
	jp .GoAheadAndEvolve

.trade
	ld a, [wLinkMode]
	and a
	jp z, .level
.trade_item
	call CheckMonHoldingEverstone
	jp z, .DontEvolve2
	ld a, [hli]
	ld b, a
	inc a
	jr z, .GoAheadAndEvolve
	ld a, [wLinkMode]
	cp $1
	jp z, .DontEvolve
	ld a, [TempMonItem]
	cp b
	jp nz, .DontEvolve
	xor a
	ld [TempMonItem], a
	jr .GoAheadAndEvolve

.item
	ld a, [hli]
	ld b, a
	ld a, [CurItem]
	cp b
	jp nz, .DontEvolve
	ld a, [wd1e9]
	and a
	jp z, .DontEvolve
	ld a, [wLinkMode]
	and a
	jp nz, .DontEvolve
	jr .GoAheadAndEvolve

.levelitem
	ld a, [wLinkMode]
	and a
	jr nz, .trade_item
	ld a, [hli]
	ld b, a
	ld a, [TempMonItem]
	cp b
	jr z, .GoAheadAndEvolve_item
	ld a, EVERSTONE
	cp b
	jp z, .DontEvolve
	ld a, b
	push hl
	ld [CurItem], a
	ld hl, NumItems
	call CheckItem
	pop hl
	jp nc, .DontEvolve
	push hl
	ld hl, NumItems
	ld a, 1
	ld [wd10c], a
	call TossItem
	pop hl
	jr .GoAheadAndEvolve
.GoAheadAndEvolve_item
	xor a
	ld [TempMonItem], a
	jr .GoAheadAndEvolve

.level
	ld a, [hli]
	ld b, a
	ld a, [TempMonLevel]
	cp b
	jp c, .DontEvolve
	call CheckMonHoldingEverstone
	jp z, .DontEvolve
.GoAheadAndEvolve
	ld a, [TempMonLevel]
	ld [CurPartyLevel], a
	ld a, $1
	ld [wd268], a
	push hl
	ld a, [hl]
	ld [Buffer2], a
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call GetNick
	call CopyName1
	ld hl, UnknownText_0x42482
	call PrintText
	ld c, 50
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	lb bc, 12, 20
	call ClearBox
	ld a, $1
	ld [hBGMapMode], a
	call ClearSprites
	callba EvolutionAnimation
	push af
	call ClearSprites
	pop af
	jp c, Function42454
	ld hl, UnknownText_0x42473
	call PrintText
	pop hl
	ld a, [hl]
	ld [CurSpecies], a
	ld [TempMonSpecies], a
	ld [Buffer2], a
	ld [wd265], a
	call GetPokemonName
	push hl
	ld hl, UnknownText_0x42478
	call PrintTextBoxText
	callba Function106094
	ld de, MUSIC_NONE
	call PlayMusic
	ld de, SFX_CAUGHT_MON
	call PlaySFX
	call WaitSFX
	ld c, 40
	call DelayFrames
	call ClearTileMap
	call Function42414
	call GetBaseData
	ld hl, TempMonExp + 2
	ld de, TempMonMaxHP
	ld b, $1
	predef CalcPkmnStats
	ld a, [CurPartyMon]
	ld hl, PartyMons
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld bc, PartyMon1MaxHP - PartyMon1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, TempMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, TempMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld hl, TempMonSpecies
	ld bc, PartyMon2 - PartyMon1
	call CopyBytes
	ld a, [CurSpecies]
	ld [wd265], a
	xor a
	ld [MonType], a
	call LearnLevelMoves
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon
; If something were to evolve into Unown, compute its letter.

	ld a, [wd265]
	cp UNOWN
	jr nz, .NotUnown
	ld hl, TempMonDVs
	predef GetUnownLetter
	callab Functionfba18
.NotUnown
	pop de
	pop hl
	ld a, [TempMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jp Function421f5
; 423f8

.DontEvolve3
	inc hl
.DontEvolve2
	inc hl
.DontEvolve
	inc hl
	jp .loop
; 423fe

Function423fe: ; 423fe
	pop hl
Function423ff: ; 423ff
	pop de
	pop bc
	pop hl
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wBattleMode]
	and a
	ret nz
	ld a, [wd268]
	and a
	call nz, RestartMapMusic
	ret
; 42414

Function42414: ; 42414
	ld a, [CurSpecies]
	push af
	ld a, [BaseDexNo]
	ld [wd265], a
	call GetPokemonName
	pop af
	ld [CurSpecies], a
	ld hl, StringBuffer1
	ld de, StringBuffer2
.asm_4242b
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp "@"
	jr nz, .asm_4242b
	ld a, [CurPartyMon]
	ld bc, PKMN_NAME_LENGTH
	ld hl, PartyMonNicknames
	call AddNTimes
	push hl
	ld a, [CurSpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, StringBuffer1
	pop de
	ld bc, PKMN_NAME_LENGTH
	jp CopyBytes
; 42454

Function42454: ; 42454
	ld hl, UnknownText_0x4247d
	call PrintText
	call ClearTileMap
	pop hl
	jp Function421f5
; 42461

CheckMonHoldingEverstone: ; 42461
	push hl
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hl]
	cp EVERSTONE
	pop hl
	ret
; 42473

UnknownText_0x42473: ; 0x42473
	; Congratulations! Your @ @
	text_jump UnknownText_0x1c4b92
	db "@"
; 0x42478

UnknownText_0x42478: ; 0x42478
	; evolved into @ !
	text_jump UnknownText_0x1c4baf
	db "@"
; 0x4247d

UnknownText_0x4247d: ; 0x4247d
	; Huh? @ stopped evolving!
	text_jump UnknownText_0x1c4bc5
	db "@"
; 0x42482

UnknownText_0x42482: ; 0x42482
	; What? @ is evolving!
	text_jump UnknownText_0x1c4be3
	db "@"
; 0x42487

LearnLevelMoves: ; 42487
	ld a, [wd265]
	ld [CurPartySpecies], a
	dec a
	ld b, 0
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skip_evos
	ld a, [hli]
	and a
	jr nz, .skip_evos
.find_move
	ld a, [hli]
	and a
	jr z, .done
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	ld a, [hli]
	jr nz, .find_move
	push hl
	ld d, a
	ld hl, PartyMon1Moves
	ld a, [CurPartyMon]
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld b, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .has_move
	dec b
	jr nz, .check_move
	jr .learn

.has_move
	pop hl
	jr .find_move

.learn
	ld a, d
	ld [wd262], a
	ld [wd265], a
	call GetMoveName
	call CopyName1
	ld b, 0
	predef LearnMove
	pop hl
	jr .find_move

.done
	ld a, [CurPartySpecies]
	ld [wd265], a
	ret
; 424e1

FillMoves: ; 424e1
; Fill in moves at de for CurPartySpecies at CurPartyLevel

	push hl
	push de
	push bc
	ld hl, EvosAttacksPointers
	ld b, 0
	ld a, [CurPartySpecies]
	dec a
	add a ;(species -1)*2
	rl b ;carry in b (if any)
	ld c, a
	add hl, bc ;load that mon location into hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
.GoToAttacks
	ld a, [hli]
	and a
	jr nz, .GoToAttacks ;if an evo there, loop until no evo
	jr .GetLevel

.NextMove
	pop de
.GetMove
	inc hl
.GetLevel
	ld a, [hli] ;load move level, move over move
	and a
	jp z, .done ;if zero, no more moves
	ld b, a
	ld a, [CurPartyLevel]
	cp b
	jp c, .done ;if move level is higher then current level, done
	ld a, [Buffer1]
	and a
	jr z, .CheckMove ;jump if buffer = zero
	ld a, [DefaultFlypoint] ;if ?? is > move level, get next move
	cp b
	jr nc, .GetMove
.CheckMove
	push de ;loc to enter move
	ld c, NUM_MOVES
.CheckRepeat
	ld a, [de] ;if current move same as loaded move, return and try the next move
	inc de
	cp [hl]
	jr z, .NextMove
	dec c ;else check next slot until all slots are checked
	jr nz, .CheckRepeat
	pop de ;reload move entry slot
	push de
	ld c, NUM_MOVES
.CheckSlot
	ld a, [de] ;if current slot 1 is empty
	and a
	jr z, .LearnMove ;skip move shifting
	inc de ;else move to next slot
	dec c
	jr nz, .CheckSlot ;see if any slot is empty, if no shot is empty fall through
	pop de ;reset to slot 1
	push de
	push hl ;stack location in moves table to be recovered later
	ld h, d
	ld l, e
	call ShiftMoves ;move moves from de to the slot above in hl, overwriting the top move
	ld a, [Buffer1]
	and a
	jr z, .ShiftedMove ;if buffer is z, skip ahead
	push de
	ld bc, PartyMon1PP - (PartyMon1Moves + NUM_MOVES - 1) ; difference between pp loc and last moveloc?
	add hl, bc ;move to top of pp
	ld d, h
	ld e, l
	call ShiftMoves ;shift pp amounts
	pop de
.ShiftedMove
	pop hl ;if moves were shifted, reset hl
.LearnMove
	ld a, [hl]
	ld [de], a ;put the move into the move slot
	ld a, [Buffer1]
	and a
	jr z, .NextMove ;if buffer is 0, check next move
	push hl ;stack move loc
	ld a, [hl] ;put move in a
	ld hl, PartyMon1PP - PartyMon1Moves
	add hl, de ;move down to appropriate PP
	push hl ;stack pp loc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes ;move down to moves base PP in database
	ld a, BANK(Moves)
	call GetFarByte ;put it in a
	pop hl
	ld [hl], a;load it into pp, and reset hl before moving onto next move
	pop hl
	jr .NextMove

.done
	pop bc
	pop de
	pop hl
	ret
; 4256e

ShiftMoves: ; 4256e
	ld c, NUM_MOVES - 1
.asm_42570
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .asm_42570
	ret
; 42577

Function42577: ; 42577
	push de
	ld d, $0
	predef FlagPredef
	pop de
	ret
; 42581

GetPreEvolution: ; 42581
; Find the first mon to evolve into CurPartySpecies.
; Return carry and the new species in CurPartySpecies
; if a pre-evolution is found.

	ld c, 0
.asm_42583
	ld hl, EvosAttacksPointers
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_4258d
	ld a, [hli]
	and a
	jr z, .asm_425a2
	cp EVOLVE_STAT
	jr nz, .asm_42596
	inc hl
.asm_42596
	inc hl
	ld a, [CurPartySpecies]
	cp [hl]
	jr z, .asm_425aa
	inc hl
	ld a, [hl]
	and a
	jr nz, .asm_4258d
.asm_425a2
	inc c
	ld a, c
	cp NUM_POKEMON
	jr c, .asm_42583
	and a
	ret

.asm_425aa
	inc c
	ld a, c
	ld [CurPartySpecies], a
	scf
	ret
; 425b1

SECTION "bank11", ROMX, BANK[$11]

INCLUDE "engine/fruit_trees.asm"

IF !DEF(BEESAFREE)
AIChooseMove:
; Wildmons attack at random.

	ld a, [wBattleMode]
	dec a
	ret z
	ld a, [wLinkMode]
	and a
	ret nz
; No use picking a move if there's no choice.

	callba Function3e8d1
	ret nz
; The default score is 20. Unusable moves are given a score of 80.

	ld a, 20
	ld hl, Buffer1
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
; Don't pick disabled moves.

	ld a, [EnemyDisabledMove]
	and a
	jr z, .CheckPP
	ld hl, EnemyMonMoves
	ld c, 0
.CheckDisabledMove
	cp [hl]
	jr z, .ScoreDisabledMove
	inc c
	inc hl
	jr .CheckDisabledMove

.ScoreDisabledMove
	ld hl, Buffer1
	ld b, 0
	add hl, bc
	ld [hl], 80
; Don't pick moves with 0 PP.

.CheckPP
	ld hl, Buffer1 - 1
	ld de, EnemyMonPP
	ld b, 0
.CheckMovePP
	inc b
	ld a, b
	cp EnemyMonMovesEnd - EnemyMonMoves + 1
	jr z, .ApplyLayers
	inc hl
	ld a, [de]
	inc de
	and $3f
	jr nz, .CheckMovePP
	ld [hl], 80
	jr .CheckMovePP
; Apply AI scoring layers depending on the trainer class.

.ApplyLayers
	ld hl, TrainerClassAttributes + 3
	ld a, [InBattleTowerBattle]
	bit 0, a
	jr nz, .asm_4412f
	ld a, [TrainerClass]
	dec a
	ld bc, 7 ; Trainer2AI - Trainer1AI
	call AddNTimes
.asm_4412f
	lb bc, CHECK_FLAG, 0
	push bc
	push hl
.CheckLayer
	pop hl
	pop bc
	ld a, c
	cp 16 ; up to 16 scoring layers
	jr z, .DecrementScores
	push bc
	ld d, BANK(TrainerClassAttributes)
	predef FlagPredef
	ld d, c
	pop bc
	inc c
	push bc
	push hl
	ld a, d
	and a
	jr z, .CheckLayer
	ld hl, AIScoringPointers
	dec c
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(AIScoring)
	rst FarCall
	jr .CheckLayer
; Decrement the scores of all moves one by one until one reaches 0.

.DecrementScores
	ld hl, Buffer1
	ld de, EnemyMonMoves
	ld c, EnemyMonMovesEnd - EnemyMonMoves

.DecrementNextScore
	; If the enemy has no moves, this will infinite.
	ld a, [de]
	inc de
	and a
	jr z, .DecrementScores
	; We are done whenever a score reaches 0
	dec [hl]
	jr z, .PickLowestScoreMoves
	; If we just decremented the fourth move's score, go back to the first move
	inc hl
	dec c
	jr z, .DecrementScores
	jr .DecrementNextScore
; In order to avoid bias towards the moves located first in memory, increment the scores
; that were decremented one more time than the rest (in case there was a tie).
; This means that the minimum score will be 1.

.PickLowestScoreMoves
	ld a, c

.asm_44175
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .asm_44175
	ld hl, Buffer1
	ld de, EnemyMonMoves
	ld c, NUM_MOVES

; Give a score of 0 to a blank move

.asm_44184
	ld a, [de]
	and a
	jr nz, .asm_44189
	ld [hl], a
; Disregard the move if its score is not 1

.asm_44189
	ld a, [hl]
	dec a
	jr z, .asm_44191
	xor a
	ld [hli], a
	jr .asm_44193

.asm_44191
	ld a, [de]
	ld [hli], a
.asm_44193
	inc de
	dec c
	jr nz, .asm_44184
; Randomly choose one of the moves with a score of 1

.ChooseMove
	ld hl, Buffer1
	call Random
	and 3
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and a
	jr z, .ChooseMove
	ld [CurEnemyMove], a
	ld a, c
	ld [CurEnemyMoveNum], a
	ret

; 441af

AIScoringPointers: ; 441af
       dw AI_Basic
       dw AI_Setup
       dw AI_Types
       dw AI_Offensive
       dw AI_Smart
       dw AI_Opportunist
       dw AI_Aggressive
       dw AI_Cautious
       dw AI_Status
       dw AI_Risky
       dw AI_None
       dw AI_None
       dw AI_None
       dw AI_None
       dw AI_None
       dw AI_None
; 441cf
ENDC

Function441cf: ; 441cf
	ld hl, Unknown_441fc
	ld b, 25
.loop
	ld a, [hli]
	; Wrap around
	cp $fe
	jr nz, .ok
	ld hl, Unknown_441fc
	ld a, [hli]
.ok
	ld [wc7db], a
	ld a, [hli]
	ld c, a
	push bc
	push hl
	call Function44207
	pop hl
	pop bc
	call DelayFrames
	dec b
	jr nz, .loop
	xor a
	ld [wc7db], a
	call Function44207
	ld c, $20
	call DelayFrames
	ret
; 441fc

Unknown_441fc: ; 441fc
	db 0, 7
	db 1, 7
	db 2, 7
	db 3, 7
	db 4, 7
	db $fe
; 44207

Function44207: ; 44207
	ld a, [wc7db]
	ld hl, Unknown_44228
	ld de, Sprites
.asm_44210
	ld a, [hli]
	cp $ff
	ret z
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [wc7db]
	ld b, a
	add a
	add b
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr .asm_44210
; 44228

Unknown_44228: ; 44228
	db $58, $48, $00, $00
	db $58, $50, $01, $00
	db $58, $58, $02, $00
	db $60, $48, $10, $00
	db $60, $50, $11, $00
	db $60, $58, $12, $00
	db $68, $48, $20, $00
	db $68, $50, $21, $00
	db $68, $58, $22, $00
	db $ff
; 4424d

; 44331

String_44331: ; 44331
	db "#@"
; 44333


; 44355


; 44378



Function4456e: ; 4456e
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	ld d, [hl]
	callba ItemIsMail
	jr nc, .asm_445be
	call Function44648
	cp $a
	jr nc, .asm_445be
	ld bc, $002f
	ld hl, $a835
	call AddNTimes
	ld d, h
	ld e, l
	ld a, [CurPartyMon]
	ld bc, $002f
	ld hl, $a600
	call AddNTimes
	push hl
	ld a, $0
	call GetSRAMBank
	ld bc, $002f
	call CopyBytes
	pop hl
	xor a
	ld bc, $002f
	call ByteFill
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	ld [hl], $0
	ld hl, $a834
	inc [hl]
	call CloseSRAM
	xor a
	ret

.asm_445be
	scf
	ret
; 445c0

Function445c0: ; 445c0 (11:45c0)
	ld a, $0
	call GetSRAMBank
	ld a, b
	push bc
	ld hl, $a835
	ld bc, $2f
	call AddNTimes
	push hl
	add hl, bc
	pop de
	pop bc
.asm_445d4
	ld a, b
	cp $9
	jr z, .asm_445e4
	push bc
	ld bc, $2f
	call CopyBytes
	pop bc
	inc b
	jr .asm_445d4

.asm_445e4
	ld h, d
	ld l, e
	xor a
	ld bc, $2f
	call ByteFill
	ld hl, $a834
	dec [hl]
	jp CloseSRAM
; 445f4 (11:45f4)

Function445f4: ; 445f4
	ld a, b
	ld hl, $a835
	ld bc, $2f
	call AddNTimes
	ld d, h
	ld e, l
	callba Functionb9237
	ret

Function44607: ; 44607
	ld a, $0
	call GetSRAMBank
	push bc
	ld a, b
	ld bc, $2f
	ld hl, $a835
	call AddNTimes
	push hl
	ld a, [CurPartyMon]
	ld bc, $2f
	ld hl, $a600
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	push hl
	ld bc, $2f
	call CopyBytes
	pop hl
	ld de, $2e
	add hl, de
	ld d, [hl]
	ld a, [CurPartyMon]
	ld hl, PartyMon1Item
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld [hl], d
	call CloseSRAM
	pop bc
	jp Function445c0
; 44648 (11:4648)

Function44648: ; 44648
	ld a, $0
	call GetSRAMBank
	ld a, [$a834]
	ld c, a
	jp CloseSRAM
; 44654

Function44654:: ; 44654
	push bc
	push de
	callba Function50000
	ld a, $2
	jp c, .pop_load
	ld a, [CurPartyMon]
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hl]
	cp NOCTOWL ; Kenya's species
	jp nz, .not_kenya
	ld c, l
	ld b, h
	ld hl, PartyMon1ID - PartyMon1
	add hl, bc
	ld a, [hli]
	cp 01001 / $100
	jp nz, .not_kenya
	ld a, [hl]
	cp 01001 % $100
	jp nz, .not_kenya
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMonOT
	ld bc, NAME_LENGTH
	call AddNTimes
	pop bc
	ld de, .OTName
	call .CompareStrings
	jr nz, .not_kenya
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call AddNTimes
	pop bc
	ld de, .Nickname
	call .CompareStrings
	jr nz, .not_kenya
	ld hl, PartyMon1Item - PartyMon1
	add hl, bc
	ld d, [hl]
	callba ItemIsMail
	ld a, $3
	jr nc, .pop_load
	ld a, $0
	call GetSRAMBank
	ld a, [CurPartyMon]
	ld hl, sPartyMail
	ld bc, $002f
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	pop bc
	ld a, $20
	ld [wd265], a
.loop
	ld a, [de]
	ld c, a
	ld a, b
	call GetFarByte
	cp "@"
	jr z, .done
	cp c
	ld a, $0
	jr nz, .close_sram_load
	inc hl
	inc de
	ld a, [wd265]
	dec a
	ld [wd265], a
	jr nz, .loop
.done
	callba Functione538
	ld a, $4
	jr c, .close_sram_load
	xor a
	ld [wd10b], a
	callba Functione039
	ld a, $1
.close_sram_load
	call CloseSRAM
	jr .load

.not_kenya
	ld a, $5
.pop_load
	pop de
	pop bc
.load
	ld [ScriptVar], a
	ret
; 446cc
.CompareStrings
	ld a, [de]
	cp [hl]
	ret nz
	cp "@"
	ret z
	inc de
	inc hl
	jr .CompareStrings

.OTName
	db "RANDY@"
.Nickname
	db "KENYA@"

Function446cc:: ; 446cc
	ld a, [PartyCount]
	dec a
	push af
	push bc
	ld hl, PartyMon1Item
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	pop bc
	ld [hl], b
	pop af
	push bc
	push af
	ld hl, $a600
	ld bc, $002f
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wd002
	ld bc, $0021
	ld a, $0
	call GetSRAMBank
	call CopyBytes
	pop af
	push af
	ld hl, PartyMonOT
	ld bc, $000b
	call AddNTimes
	ld bc, $000a
	call CopyBytes
	pop af
	ld hl, PartyMon1ID
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, [CurPartySpecies]
	ld [de], a
	inc de
	pop bc
	ld a, b
	ld [de], a
	jp CloseSRAM
; 44725

Function44725: ; 44725
	ld a, $0
	call GetSRAMBank
	ld hl, $a600
	ld de, $a71a
	ld bc, $011a
	call CopyBytes
	ld hl, $a834
	ld de, $aa0b
	ld bc, $01d7
	call CopyBytes
	jp CloseSRAM
; 44745

Function44745: ; 44745 (11:4745)
	ld a, $0
	call GetSRAMBank
	ld hl, $a71a
	ld de, $a600
	ld bc, $11a
	call CopyBytes
	ld hl, $aa0b
	ld de, $a834
	ld bc, $1d7
	call CopyBytes
	jp CloseSRAM

Function44765: ; 44765 (11:4765)
	ld a, $0
	call GetSRAMBank
	xor a
	ld hl, $a600
	ld bc, $11a
	call ByteFill
	xor a
	ld hl, $a834
	ld bc, $1d7
	call ByteFill
	jp CloseSRAM
; 44781 (11:4781)

Function44781: ; 44781
	ld a, [PartyCount]
	and a
	jr z, .asm_4479e
	ld e, a
	ld hl, PartyMon1Item
.asm_4478b
	ld d, [hl]
	push hl
	push de
	callba ItemIsMail
	pop de
	pop hl
	ret c
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	dec e
	jr nz, .asm_4478b
.asm_4479e
	and a
	ret
; 447a0

_KrisMailBoxMenu: ; 0x447a0
	call InitMail
	jr z, .nomail
	call Function1d6e
	call Function44806
	jp Function1c17

.nomail
	ld hl, .EmptyMailboxText
	jp Function1d67
; 0x447b4

.EmptyMailboxText ; 0x447b4
	TX_FAR _EmptyMailboxText
	db "@"
InitMail: ; 0x447b9
; initialize wd0f2 and beyond with incrementing values, one per mail
; set z if no mail

	ld a, $0
	call GetSRAMBank
	ld a, [$a834]
	call CloseSRAM
	ld hl, wd0f2
	ld [hli], a
	and a
	jr z, .done ; if no mail, we're done
	; load values in memory with incrementing values starting at wd0f2
	ld b, a
	ld a, $1
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
.done
	ld [hl], $ff ; terminate
	ld a, [wd0f2]
	and a
	ret
; 0x447da

Function447da: ; 0x447da
	dec a
	ld hl, $a856
	ld bc, $002f
	call AddNTimes
	ld a, $0
	call GetSRAMBank
	ld de, StringBuffer2
	push de
	ld bc, $a
	call CopyBytes
	ld a, $50
	ld [de], a
	call CloseSRAM
	pop de
	ret
; 0x447fb

Function447fb: ; 0x447fb
	push de
	ld a, [MenuSelection]
	call Function447da
	pop hl
	jp PlaceString
; 0x44806

Function44806: ; 0x44806
	xor a
	ld [OBPals + 8 * 6], a
	ld a, $1
	ld [wd0f1], a
.asm_4480f
	call InitMail
	ld hl, MenuData4494c
	call Function1d3c
	xor a
	ld [hBGMapMode], a
	call Function352f
	call Function1ad2
	ld a, [wd0f1]
	ld [wcf88], a
	ld a, [OBPals + 8 * 6]
	ld [wd0e4], a
	call Function350c
	ld a, [wd0e4]
	ld [OBPals + 8 * 6], a
	ld a, [wcfa9]
	ld [wd0f1], a
	ld a, [wcf73]
	cp $2
	jr z, .asm_44848
	call Function4484a
	jr .asm_4480f

.asm_44848
	xor a
	ret
; 0x4484a

Function4484a: ; 0x4484a
	ld hl, MenuData44964
	call LoadMenuDataHeader
	call Function1d81
	call Function1c07 ;unload top menu on menu stack
	jr c, .asm_44860
	ld a, [wcfa9]
	dec a
	ld hl, .JumpTable
	rst JumpTable
.asm_44860
	ret
; 0x44861

.JumpTable
	dw .ReadMail
	dw .PutInPack
	dw .AttachMail
	dw .Cancel

.ReadMail ; 0x44869
	call FadeToMenu
	ld a, [MenuSelection]
	dec a
	ld b, a
	call Function445f4
	jp Function2b3c
; 0x44877

.PutInPack ; 0x44877
	ld hl, .MessageLostText
	call Function1d4f
	call YesNoBox
	call Function1c07 ;unload top menu on menu stack
	ret c
	ld a, [MenuSelection]
	dec a
	call .Function448bb
	ld a, $1
	ld [wd10c], a
	ld hl, NumItems
	call ReceiveItem
	jr c, .asm_4489e
	ld hl, .PackFullText
	jp Function1d67

.asm_4489e
	ld a, [MenuSelection]
	dec a
	ld b, a
	call Function445c0
	ld hl, .PutAwayText
	jp Function1d67
; 0x448ac

.PutAwayText ; 0x448ac
	TX_FAR ClearedMailPutAwayText
	db "@"
.PackFullText ; 0x448b1
	TX_FAR MailPackFullText
	db "@"
.MessageLostText ; 0x448b6
	TX_FAR MailMessageLostText
	db "@"
.Function448bb: ; 0x448bb
	push af
	ld a, $0
	call GetSRAMBank
	pop af
	ld hl, $a863
	ld bc, $002f
	call AddNTimes
	ld a, [hl]
	ld [CurItem], a
	jp CloseSRAM
; 0x448d2

.AttachMail ; 0x448d2
	call FadeToMenu
	xor a
	ld [PartyMenuActionText], a
	call WhiteBGMap
.asm_448dc
	callba Function5004f
	callba Function50405
	callba Function503e0
	callba WritePartyMenuTilemap
	callba PrintPartyMenuText
	call WaitBGMap
	call Function32f9
	call DelayFrame
	callba PartyMenuSelect
	jr c, .asm_44939
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_44923
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr z, .asm_4492b
	ld hl, .HoldingMailText
	call PrintText
	jr .asm_448dc

.asm_44923
	ld hl, .EggText
	call PrintText
	jr .asm_448dc

.asm_4492b
	ld a, [MenuSelection]
	dec a
	ld b, a
	call Function44607
	ld hl, .MailMovedText
	call PrintText
.asm_44939
	jp Function2b3c
; 0x4493c

.HoldingMailText ; 0x4493c
	TX_FAR MailAlreadyHoldingItemText
	db "@"
.EggText ; 0x44941
	TX_FAR MailEggText
	db "@"
.MailMovedText ; 0x44946
	TX_FAR MailMovedFromBoxText
	db "@"
.Cancel
	ret

MenuData4494c: ; 0x4494c
	db %01000000 ; flags
	db 1, 8 ; start coords
	db $a, $12 ; end coords
	dw .MenuData2
	db 1 ; default option
.MenuData2
	db %00010000 ; flags
	db 4, 0 ; rows/columns?
	db 1 ; horizontal spacing?
	dbw 0,wd0f2 ; text pointer
	dbw BANK(Function447fb), Function447fb
	dbw 0,0
	dbw 0,0
MenuData44964: ; 0x44964
	db %01000000 ; flags
	db 0, 0 ; start coords
	db 9, $d ; end coords
	dw .MenuData2
	db 1 ; default option
.MenuData2
	db %10000000 ; flags
	db 4 ; items
	db "READ MAIL@"
	db "PUT IN PACK@"
	db "ATTACH MAIL@"
	db "CANCEL@"
SECTION "bank12", ROMX, BANK[$12]

Function48000: ; 48000
	ld a, $1
	ld [wd474], a
	xor a
	ld [wd473], a
	ld [PlayerGender], a
	ld [wd475], a
	ld [wd476], a
	ld [wd477], a
	ld [wd478], a
	ld [DefaultFlypoint], a
	ld [wd003], a
	ld a, [wd479]
	res 0, a
	ld [wd479], a
	ld a, [wd479]
	res 1, a
	ld [wd479], a
	ret
; 4802f

Function4802f: ; 4802f (12:402f)
	xor a
	set 6, a
	ld [DefaultFlypoint], a
	ld hl, wd003
	set 0, [hl]
	ld a, c
	and a
	call z, Function48000
	call WhiteBGMap
	call Function48d3d
	ld a, [wd479]
	bit 1, a
	jr z, .asm_4805a
	ld a, [wd003]
	set 0, a
	set 1, a
	set 2, a
	set 3, a
	ld [wd003], a
.asm_4805a
	call Function486bf
	call Functione5f
	ld de, GFX_488c3
	ld hl, $9100
	lb bc, BANK(GFX_488c3), 1
	call Request1bpp
	ld de, GFX_488cb
	ld hl, $9110
	lb bc, BANK(GFX_488cb), 1
	call Request1bpp
	call Function4a3a7
	call WhiteBGMap
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_4808a
	call Function48689
	jr .asm_480d7

.asm_4808a
	ld a, $5
	ld [MusicFade], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_MOBILE_ADAPTER_MENU / $100
	ld [MusicFadeIDHi], a
	ld c, $14
	call DelayFrames
	ld b, $1
	call Function4930f
	call WhiteBGMap
	hlcoord 0, 0
	ld b, $2
	ld c, $14
	call ClearBox
	hlcoord 0, 1
	ld a, $c
	ld [hl], a
	ld bc, $13
	add hl, bc
	ld [hl], a
	ld de, MobileProfileString
	hlcoord 1, 1
	call PlaceString
	hlcoord 0, 2
	ld b, $a
	ld c, $12
	call Function48cdc
	hlcoord 2, 4
	ld de, String_48482
	call PlaceString
.asm_480d7
	hlcoord 2, 6
	ld de, String_48489
	call PlaceString
	hlcoord 2, 8
	ld de, String_4848d
	call PlaceString
	hlcoord 2, 10
	ld de, String_48495
	call PlaceString
	hlcoord 2, 12
	ld de, String_4849e
	call PlaceString
	ld a, [DefaultFlypoint]
	bit 6, a
	jr nz, .asm_48113
	ld a, [PlayerGender]
	ld hl, Strings_484fb
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 11, 4
	call PlaceString
.asm_48113
	hlcoord 11, 6
	call Function487ec
	ld a, [wd474]
	dec a
	ld hl, Prefectures
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 11, 8
	call PlaceString
	hlcoord 11, 10
	call Function489ea
	hlcoord 0, 14
	ld b, $2
	ld c, $12
	call TextBox
	hlcoord 1, 16
	ld de, String_48275
	call PlaceString
	call Function48187
	call Function3200
	call Function32f9
	call Function1bc9
	ld hl, wcfa9
	ld b, [hl]
	push bc
	jr asm_4815f

Function48157: ; 48157 (12:4157)
	call Function1bd3
	ld hl, wcfa9
	ld b, [hl]
	push bc
asm_4815f: ; 4815f (12:415f)
	bit 0, a
	jp nz, Function4820d
	ld b, a
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_48177
	ld hl, wd479
	bit 1, [hl]
	jr z, .asm_48177
	bit 1, b
	jr nz, .asm_4817a
.asm_48177
	jp Function48272

.asm_4817a
	call WhiteBGMap
	call Function48d30
	pop bc
	call ClearTileMap
	ld a, $ff
	ret

Function48187: ; 48187 (12:4187)
	ld a, [wd479]
	bit 1, a
	jr nz, .asm_481f1
	ld a, [wd003]
	ld d, a
	call Function48725
	jr c, .asm_481a2
	ld bc, $104
	hlcoord 2, 12
	call ClearBox
	jr .asm_481ad

.asm_481a2
	push de
	hlcoord 2, 12
	ld de, String_4849e
	call PlaceString
	pop de
.asm_481ad
	ld a, [DefaultFlypoint]
	bit 6, a
	jr nz, .asm_481c1
	bit 0, d
	jr nz, .asm_481c1
	ld bc, $108
	hlcoord 11, 4
	call ClearBox
.asm_481c1
	bit 1, d
	jr nz, .asm_481ce
	ld bc, $108
	hlcoord 11, 6
	call ClearBox
.asm_481ce
	bit 2, d
	jr nz, .asm_481db
	ld bc, $208
	hlcoord 11, 7
	call ClearBox
.asm_481db
	bit 3, d
	jr nz, .asm_481f1
	ld a, [wd479]
	bit 0, a
	jr nz, .asm_481f8
	ld bc, $108
	hlcoord 11, 10
	call ClearBox
	jr .asm_48201

.asm_481f1
	ld a, [wd479]
	bit 0, a
	jr nz, .asm_48201
.asm_481f8
	hlcoord 11, 10
	ld de, String_48202
	call PlaceString
.asm_48201
	ret
; 48202 (12:4202)

String_48202: ; 48202
	db "Tell Later@"
; 4820d

Function4820d: ; 4820d (12:420d)
	call Function1bee
	ld hl, wcfa9
	ld a, [hl]
	push af
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_4821f
	pop af
	inc a
	push af
.asm_4821f
	pop af
	cp $1
	jr z, asm_4828d
	cp $2
	jp z, Function4876f
	cp $3
	jp z, Function48304
	cp $4
	jp z, Function488d3
	ld a, $2
	call Function1ff8
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_4825c
	jr .asm_4825c
; 48241 (12:4241)

	hlcoord 1, 15
	ld b, $2
	ld c, $12
	call ClearBox
	ld de, String_484a1
	hlcoord 1, 16
	call PlaceString
	call WaitBGMap
	ld c, $30
	call DelayFrames
.asm_4825c
	call WhiteBGMap
	call Function48d30
	pop bc
	call ClearTileMap
	ld b, $8
	call GetSGBLayout
	ld hl, wd479
	set 1, [hl]
	xor a
	ret

Function48272: ; 48272 (12:4272)
	jp Function4840c
; 48275 (12:4275)

String_48275: ; 48275
	db "Personal Info@"
; 48283

Function48283: ; 48283 (12:4283)
	ld bc, $212
	hlcoord 1, 15
	call ClearBox
	ret

asm_4828d: ; 4828d (12:428d)
	call Function48283
	hlcoord 1, 16
	ld de, String_484b1
	call PlaceString
	ld hl, MenuDataHeader_0x484f1
	call LoadMenuDataHeader
	call Function4873c
	hlcoord 11, 2
	ld b, $4
	ld c, $7
	call Function48cdc
	hlcoord 13, 4
	ld de, String_484fb
	call PlaceString
	hlcoord 13, 6
	ld de, String_484ff
	call PlaceString
	call WaitBGMap
	ld a, [PlayerGender]
	inc a
	ld [wcf88], a
	call Function1bc9
	call PlayClickSFX
	call Function1c07
	bit 0, a
	jp z, Function4840c
	ld hl, wcfa9
	ld a, [hl]
	ld hl, Strings_484fb
	cp $1
	jr z, .asm_482ed
.asm_482e1
	ld a, [hli]
	cp $50
	jr nz, .asm_482e1
	ld a, $1
	ld [PlayerGender], a
	jr .asm_482f1

.asm_482ed
	xor a
	ld [PlayerGender], a
.asm_482f1
	ld d, h
	ld e, l
	hlcoord 11, 4
	call PlaceString
	ld a, [wd003]
	set 0, a
	ld [wd003], a
	jp Function4840c

Function48304: ; 48304 (12:4304)
	call Function48283
	hlcoord 1, 16
	ld de, String_484cf
	call PlaceString
	ld hl, MenuDataHeader_0x48504
	call LoadMenuDataHeader
	ld hl, MenuDataHeader_0x48513
	call LoadMenuDataHeader
	hlcoord 10, 0
	ld b, $c
	ld c, $8
	call Function48cdc
	ld a, [wcf88]
	ld b, a
	ld a, [wd0e4]
	ld c, a
	push bc
	ld a, [wd474]
	dec a
	cp $29
	jr c, .asm_4833f
	sub $29
	inc a
	ld [wcf88], a
	ld a, $29
.asm_4833f
	ld [wd0e4], a
	callba Function104148
.asm_48348
	call Function350c
	ld de, $629
	call Function48383
	jr c, .asm_48348
	ld d, a
	pop bc
	ld a, b
	ld [wcf88], a
	ld a, c
	ld [wd0e4], a
	ld a, d
	push af
	call Function1c07 ;unload top menu on menu stack
	call Function1c07 ;unload top menu on menu stack
	pop af
	ld a, [hJoyPressed] ; $ff00+$a7
	bit 0, a
	jr z, .asm_48377
	call Function483bb
	ld a, [wd003]
	set 2, a
	ld [wd003], a
.asm_48377
	call Function48187
	callba Function104148
	jp Function4840c

Function48383: ; 48383 (12:4383)
	push bc
	push af
	bit 5, a
	jr nz, .asm_48390
	bit 4, a
	jr nz, .asm_4839f
	and a
	jr .asm_483b7

.asm_48390
	ld a, [wd0e4]
	sub d
	ld [wd0e4], a
	jr nc, .asm_483af
	xor a
	ld [wd0e4], a
	jr .asm_483af

.asm_4839f
	ld a, [wd0e4]
	add d
	ld [wd0e4], a
	cp e
	jr c, .asm_483af
	ld a, e
	ld [wd0e4], a
	jr .asm_483af

.asm_483af
	ld hl, wcfa9
	ld a, [hl]
	ld [wcf88], a
	scf
.asm_483b7
	pop bc
	ld a, b
	pop bc
	ret

Function483bb: ; 483bb (12:43bb)
	ld hl, wcf77
	ld a, [hl]
	inc a
	ld [wd474], a
	dec a
	ld b, a
	ld hl, Prefectures
.asm_483c8
	and a
	jr z, .asm_483d5
.asm_483cb
	ld a, [hli]
	cp "@"
	jr nz, .asm_483cb
	ld a, b
	dec a
	ld b, a
	jr .asm_483c8

.asm_483d5
	ld d, h
	ld e, l
	ld b, $2
	ld c, $8
	hlcoord 11, 7
	call ClearBox
	hlcoord 11, 8
	call PlaceString
	ret
; 483e8 (12:43e8)

Function483e8: ; 483e8
	push de
	ld hl, Prefectures
	ld a, [MenuSelection]
	cp $ff
	jr nz, .asm_483f8
	ld hl, Wakayama ; last string
	jr .asm_48405

.asm_483f8
	ld d, a
	and a
	jr z, .asm_48405
.asm_483fc
	ld a, [hli]
	cp "@"
	jr nz, .asm_483fc
	ld a, d
	dec a
	jr .asm_483f8

.asm_48405
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ret
; 4840c

Function4840c: ; 4840c (12:440c)
	call Function48187
	call Function48283
	hlcoord 1, 16
	ld de, String_48275
	call PlaceString
	call Function486bf
	pop bc
	ld hl, wcfa9
	ld [hl], b
	ld a, [DefaultFlypoint]
	bit 6, a
	jr nz, .asm_48437
	ld b, $9
	ld c, $1
	hlcoord 1, 4
	call ClearBox
	jp Function48157

.asm_48437
	ld b, $7
	ld c, $1
	hlcoord 1, 6
	call ClearBox
	jp Function48157

Function48444: ; 48444 (12:4444)
	push bc
	push af
	push de
	push hl
	ld hl, Unknown_4845d
.asm_4844b
	and a
	jr z, .asm_48453
	inc hl
	inc hl
	dec a
	jr .asm_4844b

.asm_48453
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	pop de
	pop af
	pop bc
	ret
; 4845d (12:445d)

Unknown_4845d: ; 4845d
; 4845d

	db "0@"
	db "1@"
	db "2@"
	db "3@"
	db "4@"
	db "5@"
	db "6@"
	db "7@"
	db "8@"
	db "9@"
; 48471

MobileProfileString: db "  Mobile Profile@"
String_48482: db "Gender@"
String_48489: db "Age@"
String_4848d: db "Address@"
String_48495: db "Zip Code@"
String_4849e: db "OK@"
String_484a1: db "Profile Changed@"
String_484b1: db "Boy or girl?@"
String_484be: db "How old are you?@"
String_484cf: db "Where do you live?@"
String_484e2: db "Your zip code?@"
; 484f1

MenuDataHeader_0x484f1: ; 0x484f1
	db $40 ; flags
	db 02, 11 ; start coords
	db 07, 19 ; end coords
	dw MenuData2_0x484f9
	db 1 ; default option
; 0x484f9

MenuData2_0x484f9: ; 0x484f9
	db $a0 ; flags
	db 2 ; items
Strings_484fb:
String_484fb: db "Boy@"
String_484ff: db "Girl@"
; 0x48504

MenuDataHeader_0x48504: ; 0x48504
	db $40 ; flags
	db 00, 10 ; start coords
	db 17, 19 ; end coords
MenuDataHeader_0x48509: ; 0x48509
	db $40 ; flags
	db 05, 10 ; start coords
	db 07, 19 ; end coords
MenuDataHeader_0x4850e: ; 0x4850e
	db $40 ; flags
	db 09, 10 ; start coords
	db 11, 19 ; end coords
MenuDataHeader_0x48513: ; 0x48513
	db $40 ; flags
	db 01, 11 ; start coords
	db 12, 18 ; end coords
	dw MenuData2_0x4851b
	db 1 ; default option
; 0x4851b

MenuData2_0x4851b: ; 0x4851b
	db $1d ; flags
	db 6 ; items
Unknown_4851d: ; 4851d
	db $00, $01, $12, $2b, $45, $12, $e8, $43, $00, $00, $00, $00, $00, $00, $2e, $00, $01, $02, $03, $04
	db $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c
	db $2d, $ff
Prefectures:
Aichi:     db "あいちけん@"   ; Aichi
Aomori:    db "あおもりけん@" ; Aomori
Akita:     db "あきたけん@"   ; Akita
Ishikawa:  db "いしかわけん@" ; Ishikawa
Ibaraki:   db "いばらきけん@" ; Ibaraki
Iwate:     db "いわてけん@"   ; Iwate
Ehime:     db "えひめけん@"   ; Ehime
Oita:      db "おおいたけん@" ; Oita
Osakafu:   db "おおさかふ@"   ; Osakafu
Okayama:   db "おかやまけん@" ; Okayama
Okinawa:   db "おきなわけん@" ; Okinawa
Kagawa:    db "かがわけん@"   ; Kagawa
Kagoshima: db "かごしまけん@" ; Kagoshima
Kanagawa:  db "かながわけん@" ; Kanagawa
Gifu:      db "ぎふけん@"     ; Gifu
Kyotofu:   db "きょうとふ@"   ; Kyotofu
Kumamoto:  db "くまもとけん@" ; Kumamoto
Gunma:     db "ぐんまけん@"   ; Gunma
Kochi:     db "こうちけん@"   ; Kochi
Saitama:   db "さいたまけん@" ; Saitama
Saga:      db "さがけん@"     ; Saga
Shiga:     db "しがけん@"     ; Shiga
Shizuoka:  db "しずおかけん@" ; Shizuoka
Shimane:   db "しまねけん@"   ; Shimane
Chiba:     db "ちばけん@"     ; Chiba
Tokyo:     db "とうきょうと@" ; Tokyo
Tokushima: db "とくしまけん@" ; Tokushima
Tochigi:   db "とちぎけん@"   ; Tochigi
Tottori:   db "とっとりけん@" ; Tottori
Toyama:    db "とやまけん@"   ; Toyama
Nagasaki:  db "ながさきけん@" ; Nagasaki
Nagano:    db "ながのけん@"   ; Nagano
Naraken:   db "ならけん@"     ; Naraken
Niigata:   db "にいがたけん@" ; Niigata
Hyogo:     db "ひょうごけん@" ; Hyogo
Hiroshima: db "ひろしまけん@" ; Hiroshima
Fukui:     db "ふくいけん@"   ; Fukui
Fukuoka:   db "ふくおかけん@" ; Fukuoka
Fukushima: db "ふくしまけん@" ; Fukushima
Hokkaido:  db "ほっかいどう@" ; Hokkaido
Mie:       db "みえけん@"     ; Mie
Miyagi:    db "みやぎけん@"   ; Miyagi
Miyazaki:  db "みやざきけん@" ; Miyazaki
Yamagata:  db "やまがたけん@" ; Yamagata
Yamaguchi: db "やまぐちけん@" ; Yamaguchi
Yamanashi: db "やまなしけん@" ; Yamanashi
Wakayama:  db "わかやまけん@" ; Wakayama
; 48689

Function48689: ; 48689 (12:4689)
	ld c, $7
	call DelayFrames
	ld b, $1
	call Function4930f
	call WhiteBGMap
	hlcoord 0, 0
	ld b, $4
	ld c, $14
	call ClearBox
	hlcoord 0, 2
	ld a, $c
	ld [hl], a
	ld bc, $13
	add hl, bc
	ld [hl], a
	ld de, MobileProfileString
	hlcoord 1, 2
	call PlaceString
	hlcoord 0, 4
	ld b, $8
	ld c, $12
	call Function48cdc
	ret

Function486bf: ; 486bf (12:46bf)
	ld hl, wcfa1
	ld a, [DefaultFlypoint]
	bit 6, a
	jr nz, .asm_486ce
	ld a, $4
	ld [hli], a
	jr .asm_486d1

.asm_486ce
	ld a, $6
	ld [hli], a
.asm_486d1
	ld a, $1
	ld [hli], a
	ld a, [DefaultFlypoint]
	bit 6, a
	jr nz, .asm_486e7
	call Function48725
	ld a, $4
	jr nc, .asm_486e4
	ld a, $5
.asm_486e4
	ld [hli], a
	jr .asm_486fb

.asm_486e7
	ld a, [wd479]
	bit 1, a
	jr nz, .asm_486f8
	call Function48725
	jr c, .asm_486f8
	ld a, $3
	ld [hli], a
	jr .asm_486fb

.asm_486f8
	ld a, $4
	ld [hli], a
.asm_486fb
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $40
	add $80
	push af
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_4871a
	pop af
	add $2
	push af
.asm_4871a
	pop af
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Function48725: ; 48725 (12:4725)
	ld a, [wd003]
	bit 0, a
	jr z, .asm_4873a
	bit 1, a
	jr z, .asm_4873a
	bit 2, a
	jr z, .asm_4873a
	bit 3, a
	jr z, .asm_4873a
	scf
	ret

.asm_4873a
	and a
	ret

Function4873c: ; 4873c (12:473c)
	ld hl, wcfa1
	ld a, $4
	ld [hli], a
	ld a, $c
	ld [hli], a
	ld a, $2
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $2
	ld [hli], a
	ld a, [PlayerGender]
	and a
	jr z, .asm_48764
	ld a, $2
	jr .asm_48766

.asm_48764
	ld a, $1
.asm_48766
	ld [hli], a
	ld a, $1
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Function4876f: ; 4876f (12:476f)
	call Function48283
	hlcoord 1, 16
	ld de, String_484be
	call PlaceString
	ld hl, MenuDataHeader_0x48509
	call LoadMenuDataHeader
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	hlcoord 10, 5
	ld b, $1
	ld c, $8
	call Function48cdc
	call WaitBGMap
	ld a, [wd473]
	and a
	jr z, .asm_487ab
	cp $64
	jr z, .asm_487b2
	hlcoord 12, 5
	ld [hl], $10
	hlcoord 12, 7
	ld [hl], $11
	jr .asm_487b7

.asm_487ab
	hlcoord 12, 5
	ld [hl], $10
	jr .asm_487b7

.asm_487b2
	hlcoord 12, 7
	ld [hl], $11
.asm_487b7
	hlcoord 11, 6
	call Function487ec
	ld c, $a
	call DelayFrames
	ld a, [wd473]
	push af
.asm_487c6
	call Functiona57
	call Function4880e
	jr nc, .asm_487c6
	ld a, $1
	call Function1ff8
	pop bc
	jr nz, .asm_487da
	ld a, b
	ld [wd473], a
.asm_487da
	ld a, [wd473]
	call Function1c07 ;unload top menu on menu stack
	hlcoord 11, 6
	call Function487ec
	pop af
	ld [$ffaa], a
	jp Function4840c

Function487ec: ; 487ec (12:47ec)
	push hl
	ld de, wd473
	call Function487ff
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld de, String_4880d
	call PlaceString
	ret

Function487ff: ; 487ff (12:47ff)
	push hl
	ld a, $7f
	ld [hli], a
	ld [hl], a
	pop hl
	ld b, $81
	ld c, $3
	call PrintNum
	ret
; 4880d (12:480d)

String_4880d: ; 4880d
	db "@"
; 4880e

Function4880e: ; 4880e (12:480e)
	ld a, [hJoyPressed] ; $ff00+$a7
	and A_BUTTON
	jp nz, Function488b9
	ld a, [hJoyPressed] ; $ff00+$a7
	and B_BUTTON
	jp nz, Function488b4
	ld hl, $ffa9
	ld a, [hl]
	and D_UP
	jr nz, .asm_48843
	ld a, [hl]
	and D_DOWN
	jr nz, .asm_48838
	ld a, [hl]
	and D_LEFT
	jr nz, .asm_4884f
	ld a, [hl]
	and D_RIGHT
	jr nz, .asm_4885f
	call DelayFrame
	and a
	ret

.asm_48838
	ld hl, wd473
	ld a, [hl]
	and a
	jr z, .asm_48840
	dec a
.asm_48840
	ld [hl], a
	jr .asm_4886f

.asm_48843
	ld hl, wd473
	ld a, [hl]
	cp $64
	jr nc, .asm_4884c
	inc a
.asm_4884c
	ld [hl], a
	jr .asm_4886f

.asm_4884f
	ld a, [wd473]
	cp $5b
	jr c, .asm_48858
	ld a, $5a
.asm_48858
	add $a
	ld [wd473], a
	jr .asm_4886f

.asm_4885f
	ld a, [wd473]
	cp $a
	jr nc, .asm_48868
	ld a, $a
.asm_48868
	sub $a
	ld [wd473], a
	jr .asm_4886f

.asm_4886f
	ld a, [wd473]
	and a
	jr z, .asm_48887
	cp $64
	jr z, .asm_48898
	jr z, .asm_488a7
	hlcoord 12, 5
	ld [hl], $10
	hlcoord 12, 7
	ld [hl], $11
	jr .asm_488a7

.asm_48887
	hlcoord 10, 5
	ld b, $1
	ld c, $8
	call Function48cdc
	hlcoord 12, 5
	ld [hl], $10
	jr .asm_488a7

.asm_48898
	hlcoord 10, 5
	ld b, $1
	ld c, $8
	call Function48cdc
	hlcoord 12, 7
	ld [hl], $11
.asm_488a7
	hlcoord 11, 6
	call Function487ec
	call WaitBGMap
	ld a, $1
	and a
	ret

Function488b4: ; 488b4 (12:48b4)
	ld a, $0
	and a
	scf
	ret

Function488b9: ; 488b9 (12:48b9)
	ld a, [wd003]
	set 1, a
	ld [wd003], a
	scf
	ret
; 488c3 (12:48c3)

GFX_488c3: ; 488c3
INCBIN "gfx/unknown/0488c3.2bpp"

GFX_488cb: ; 488cb
INCBIN "gfx/unknown/0488cb.2bpp"

Function488d3: ; 488d3 (12:48d3)
	call Function48283
	hlcoord 1, 16
	ld de, String_484e2
	call PlaceString
	call Function48a3a
	jp c, Function4840c
	ld hl, MenuDataHeader_0x4850e
	call LoadMenuDataHeader
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	hlcoord 10, 9
	ld b, $1
	ld c, $8
	call Function48cdc
	ld a, [wd475]
	and $f
	ld d, $0
	hlcoord 11, 10
	call Function489ea
	call WaitBGMap
	ld a, [wd475]
	ld b, a
	ld a, [wd476]
	ld c, a
	ld a, [wd477]
	ld d, a
	ld a, [wd478]
	ld e, a
	push de
	push bc
	ld d, $0
	ld b, $0
asm_48922: ; 48922 (12:4922)
	push bc
	call Functiona57
	ld a, [hJoyDown] ; $ff00+$a8
	and a
	jp z, Function4896e
	bit 0, a
	jp nz, Function4896e
	bit 1, a
	jp nz, Function4896e
	ld a, [DefaultFlypoint]
	and $cf
	res 7, a
	ld [DefaultFlypoint], a
	pop bc
	inc b
	ld a, b
	cp $5
	push bc
	jr c, .asm_4894c
	pop bc
	ld b, $4
	push bc
.asm_4894c
	pop bc
	push bc
	ld a, b
	cp $4
	jr nz, asm_48972
	ld c, $a
	call DelayFrames
	jr asm_48972
; 4895a (12:495a)

Function4895a: ; 4895a
	ld a, [hJoyPressed]
	and a
	jr z, .asm_48965
	pop bc
	ld b, $1
	push bc
	jr asm_48972

.asm_48965
	ld a, [$ffa9]
	and a
	jr z, asm_48972
	pop bc
	ld b, $1
	push bc
Function4896e: ; 4896e (12:496e)
	pop bc
	ld b, $0
	push bc
asm_48972: ; 48972 (12:4972)
	call Function48ab5
	push af
	cp $f0
	jr z, .asm_48994
	cp $f
	jr nz, .asm_48988
	ld a, [DefaultFlypoint]
	set 7, a
	and $cf
	ld [DefaultFlypoint], a
.asm_48988
	hlcoord 11, 10
	ld b, $0
	ld c, d
	add hl, bc
	ld b, $3
	call Function48c11
.asm_48994
	call WaitBGMap
	pop af
	pop bc
	jr nc, asm_48922
	jr nz, .asm_489b1
	pop bc
	ld a, b
	ld [wd475], a
	ld a, c
	ld [wd476], a
	pop bc
	ld a, b
	ld [wd477], a
	ld a, c
	ld [wd478], a
	jr .asm_489c5

.asm_489b1
	push af
	ld a, [wd479]
	set 0, a
	ld [wd479], a
	ld a, [wd003]
	set 3, a
	ld [wd003], a
	pop af
	pop bc
	pop bc
.asm_489c5
	push af
	push bc
	push de
	push hl
	ld a, $1
	call Function1ff8
	pop hl
	pop de
	pop bc
	pop af
	call Function1c07 ;unload top menu on menu stack
	hlcoord 11, 10
	call Function489ea
	hlcoord 11, 9
	ld bc, $108
	call ClearBox
	pop af
	ld [$ffaa], a
	jp Function4840c

Function489ea: ; 489ea (12:49ea)
	push de
	ld a, [wd475]
	and $f
	call Function48444
	ld a, [wd476]
	and $f0
	swap a
	inc hl
	call Function48444
	ld a, [wd476]
	and $f
	inc hl
	call Function48444
	inc hl
	ld de, String_48a38
	call PlaceString
	ld a, [wd477]
	and $f0
	swap a
	inc hl
	call Function48444
	ld a, [wd477]
	and $f
	inc hl
	call Function48444
	ld a, [wd478]
	and $f0
	swap a
	inc hl
	call Function48444
	ld a, [wd478]
	and $f
	inc hl
	call Function48444
	pop de
	ret
; 48a38 (12:4a38)

String_48a38: ; 48a38
	db "-@"
; 48a3a

Function48a3a: ; 48a3a (12:4a3a)
	ld hl, MenuDataHeader_0x48a9c
	call LoadMenuDataHeader
	call Function4873c
	ld a, $a
	ld [wcfa1], a
	ld a, $b
	ld [wcfa2], a
	ld a, $1
	ld [wcfa9], a
	hlcoord 10, 8
	ld b, $4
	ld c, $8
	call Function48cdc
	hlcoord 12, 10
	ld de, String_48aa1
	call PlaceString
	call Function1bc9
	push af
	call PlayClickSFX
	call Function1c07 ;unload top menu on menu stack
	pop af
	bit 1, a
	jp nz, Function48a9a
	ld a, [wcfa9]
	cp $1
	jr z, .asm_48a98
	ld a, [wd003]
	set 3, a
	ld [wd003], a
	ld a, [wd479]
	res 0, a
	ld [wd479], a
	xor a
	ld bc, $4
	ld hl, wd475
	call ByteFill
	jr Function48a9a

.asm_48a98
	and a
	ret

Function48a9a: ; 48a9a (12:4a9a)
	scf
	ret
; 48a9c (12:4a9c)

MenuDataHeader_0x48a9c: ; 0x48a9c
	db $40 ; flags
	db 08, 10 ; start coords
	db 13, 19 ; end coord
String_48aa1: ; 48aa1
	db   "Tell Now"
	next "Tell Later@"
; 48ab5

Function48ab5: ; 48ab5 (12:4ab5)
	ld a, [hJoyPressed] ; $ff00+$a7
	and A_BUTTON
	jp nz, Function48c0f
	ld a, [hJoyPressed] ; $ff00+$a7
	and B_BUTTON
	jp nz, Function48c0d
	ld a, d
	and a
	jr z, .asm_48adf
	cp $1
	jr z, .asm_48ae7
	cp $2
	jr z, .asm_48af1
	cp $3
	jr z, .asm_48af9
	cp $4
	jr z, .asm_48b03
	cp $5
	jr z, .asm_48b0b
	cp $6
	jr .asm_48b15

.asm_48adf
	ld hl, wd475
	ld a, [hl]
	and $f
	jr .asm_48b1d

.asm_48ae7
	ld hl, wd476
	ld a, [hl]
	swap a
	or $f0
	jr .asm_48b1d

.asm_48af1
	ld hl, wd476
	ld a, [hl]
	and $f
	jr .asm_48b1d

.asm_48af9
	ld hl, wd477
	ld a, [hl]
	swap a
	or $f0
	jr .asm_48b1d

.asm_48b03
	ld hl, wd477
	ld a, [hl]
	and $f
	jr .asm_48b1d

.asm_48b0b
	ld hl, wd478
	ld a, [hl]
	swap a
	or $f0
	jr .asm_48b1d

.asm_48b15
	ld hl, wd478
	ld a, [hl]
	and $f
	jr .asm_48b1d

.asm_48b1d
	push hl
	push af
	ld e, $0
	hlcoord 11, 10
	ld a, d
.asm_48b25
	and a
	jr z, .asm_48b2c
	inc e
	dec a
	jr .asm_48b25

.asm_48b2c
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, .asm_48b8d
	ld a, [hl]
	and $80
	jr nz, .asm_48b55
	ld a, [hl]
	and $20
	jp nz, Function48bd7
	ld a, [hl]
	and $10
	jr nz, .asm_48b9d
	hlcoord 11, 10
	call Function489ea
	ld a, [DefaultFlypoint]
	bit 7, a
	jr nz, .asm_48b51
.asm_48b51
	pop bc
	pop bc
	and a
	ret

.asm_48b55
	pop af
	ld b, a
	and $f
	and a
	ld a, b
	jr nz, .asm_48b61
	and $f0
	add $a
.asm_48b61
	dec a
.asm_48b62
	push de
	push af
	hlcoord 10, 9
	ld b, $1
	ld c, $8
	call Function48cdc
	pop af
	pop de
	hlcoord 11, 10
	ld b, a
	ld a, d
	cp $3
	jr c, .asm_48b7a
	inc hl
.asm_48b7a
	ld a, b
	pop hl
	bit 7, a
	jr z, .asm_48b85
	call Function48c4d
	jr .asm_48b88

.asm_48b85
	call Function48c5a
.asm_48b88
	ld a, $f0
	jp Function48c00

.asm_48b8d
	pop af
	ld b, a
	and $f
	cp $9
	ld a, b
	jr c, .asm_48b9a
	and $f0
	add $ff
.asm_48b9a
	inc a
	jr .asm_48b62

.asm_48b9d
	push de
	hlcoord 10, 9
	ld b, $1
	ld c, $8
	call Function48cdc
	pop de
	ld a, d
	cp $6
	jr nc, .asm_48baf
	inc d
.asm_48baf
	pop af
	pop hl
	ld b, a
	ld a, d
	cp $6
	ld a, b
	jr z, .asm_48bc4
	bit 7, a
	jr nz, .asm_48bc4
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr asm_48bc7

.asm_48bc4
	ld a, [hl]
	and $f
asm_48bc7: ; 48bc7 (12:4bc7)
	hlcoord 11, 10
	push af
	ld a, d
	cp $3
	pop bc
	ld a, b
	jr c, .asm_48bd3
	inc hl
.asm_48bd3
	ld a, $f
	jr Function48c00

Function48bd7: ; 48bd7 (12:4bd7)
	push de
	hlcoord 10, 9
	ld b, $1
	ld c, $8
	call Function48cdc
	pop de
	ld a, d
	and a
	pop af
	pop hl
	ld b, a
	ld a, d
	and a
	ld a, b
	jr z, .asm_48bf3
	bit 7, a
	jr z, .asm_48bf8
	dec d
	dec hl
.asm_48bf3
	ld a, [hl]
	and $f
	jr asm_48bc7

.asm_48bf8
	dec d
	ld a, [hl]
	swap a
	and $f
	jr asm_48bc7

Function48c00: ; 48c00 (12:4c00)
	push af
	hlcoord 11, 10
	call Function489ea
	ld a, $1
	and a
	pop bc
	ld a, b
	ret

Function48c0d: ; 48c0d (12:4c0d)
	xor a
	and a
Function48c0f: ; 48c0f (12:4c0f)
	scf
	ret

Function48c11: ; 48c11 (12:4c11)
	ld a, [DefaultFlypoint]
	bit 7, a
	jr z, .asm_48c20
	ld a, d
	cp $3
	jr c, .asm_48c1e
	inc hl
.asm_48c1e
	ld [hl], $7f
.asm_48c20
	ld a, [DefaultFlypoint]
	swap a
	and $3
	inc a
	cp b
	jr nz, .asm_48c40
	ld a, [DefaultFlypoint]
	bit 7, a
	jr z, .asm_48c3a
	res 7, a
	ld [DefaultFlypoint], a
	xor a
	jr .asm_48c40

.asm_48c3a
	set 7, a
	ld [DefaultFlypoint], a
	xor a
.asm_48c40
	swap a
	ld b, a
	ld a, [DefaultFlypoint]
	and $cf
	or b
	ld [DefaultFlypoint], a
	ret

Function48c4d: ; 48c4d (12:4c4d)
	swap a
	and $f0
	push af
	ld a, [hl]
	and $f
	ld [hl], a
	pop af
	or [hl]
	ld [hl], a
	ret

Function48c5a: ; 48c5a (12:4c5a)
	push af
	ld a, [hl]
	and $f0
	ld [hl], a
	pop af
	or [hl]
	ld [hl], a
	ret

Function48c63: ; 48c63
	ld a, "@"
	ld [de], a
	ld a, c
	cp $30
	jr nc, .asm_48c8c
	and a
	jr z, .asm_48c8c
	dec c
	push de
	ld h, d
	ld l, e
	ld a, "@"
	ld b, 7
.asm_48c76
	ld [hli], a
	dec b
	jr nz, .asm_48c76
	ld hl, Prefectures
	ld a, c
	call GetNthString
.asm_48c81
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	cp "@"
	jr nz, .asm_48c81
	and a
	pop de
	ret

.asm_48c8c
	scf
	ret
; 48c8e

Function48c8e: ; 48c8e
	ld hl, wd02a
	ld d, h
	ld e, l
	callba Function48c63
	hlcoord 10, 7
	call PlaceString
	call WaitBGMap
	ret
; 48ca3

Function48ca3: ; 48ca3
	push af
	push bc
	push de
	push hl
	ld b, 0
	ld c, 0
	ld d, 0
.asm_48cad
	cp 100
	jr c, .asm_48cb6
	sub 100
	inc b
	jr .asm_48cad

.asm_48cb6
	cp 10
	jr c, .asm_48cbf
	sub 10
	inc c
	jr .asm_48cb6

.asm_48cbf
	cp 1
	jr c, .asm_48cc7
	dec a
	inc d
	jr .asm_48cbf

.asm_48cc7
	ld a, b
	call Function48444
	inc hl
	ld a, c
	call Function48444
	inc hl
	ld a, d
	call Function48444
	pop hl
	pop de
	pop bc
	pop af
	ret
; 48cda

Function48cda: ; 48cda (12:4cda)
	ld h, d
	ld l, e
Function48cdc: ; 48cdc (12:4cdc)
	push bc
	push hl
	call Function48cfd
	pop hl
	pop bc
	ld de, AttrMap - TileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, $0
.asm_48ced
	push bc
	push hl
.asm_48cef
	ld [hli], a
	dec c
	jr nz, .asm_48cef
	pop hl
	ld de, $14
	add hl, de
	pop bc
	dec b
	jr nz, .asm_48ced
	ret

Function48cfd: ; 48cfd (12:4cfd)
	push hl
	ld a, $4
	ld [hli], a
	inc a
	call Function48d2a
	inc a
	ld [hl], a
	pop hl
	ld de, $14
	add hl, de
.asm_48d0c
	push hl
	ld a, $7
	ld [hli], a
	ld a, $7f
	call Function48d2a
	ld [hl], $8
	pop hl
	ld de, $14
	add hl, de
	dec b
	jr nz, .asm_48d0c
	ld a, $9
	ld [hli], a
	ld a, $a
	call Function48d2a
	ld [hl], $b
	ret

Function48d2a: ; 48d2a (12:4d2a)
	ld d, c
.asm_48d2b
	ld [hli], a
	dec d
	jr nz, .asm_48d2b
	ret

Function48d30: ; 48d30 (12:4d30)
	ld hl, wd475
	call Function48d4a
	ld hl, wd477
	call Function48d4a
	ret

Function48d3d: ; 48d3d (12:4d3d)
	ld hl, wd475
	call Function48d94
	ld hl, wd477
	call Function48d94
	ret

Function48d4a: ; 48d4a (12:4d4a)
	inc hl
	ld a, [hl]
	ld b, a
	and $f
	ld c, a
	srl b
	srl b
	srl b
	srl b
	push bc
	ld c, 10
	ld a, b
	call SimpleMultiply
	pop bc
	add c
	ld [hld], a
	xor a
	ld [hQuotient], a ; $ff00+$b4 (aliases: hMultiplicand)
	ld [$ffb5], a
	ld a, [hl]
	srl a
	srl a
	srl a
	srl a
	ld c, 10
	call SimpleMultiply
	ld b, a
	ld a, [hli]
	and $f
	add b
	ld [$ffb6], a
	ld a, 100
	ld [hDivisor], a ; $ff00+$b7 (aliases: hMultiplier)
	call Multiply
	ld a, [$ffb5]
	ld b, a
	ld a, [$ffb6]
	ld c, a
	ld e, [hl]
	add e
	ld c, a
	ld a, b
	adc $0
	ld b, a
	ld a, c
	ld [hld], a
	ld [hl], b
	ret

Function48d94: ; 48d94 (12:4d94)
	xor a
	ld [$ffb3], a
	ld [hQuotient], a ; $ff00+$b4 (aliases: hMultiplicand)
	ld a, [hli]
	ld [$ffb3], a
	ld a, [hl]
	ld [hQuotient], a ; $ff00+$b4 (aliases: hMultiplicand)
	ld a, 100
	ld [hDivisor], a ; $ff00+$b7 (aliases: hMultiplier)
	ld b, 2
	call Divide
	ld a, [hDivisor] ; $ff00+$b7 (aliases: hMultiplier)
	ld c, $a
	call SimpleDivide
	sla b
	sla b
	sla b
	sla b
	or b
	ld [hld], a
	ld a, [$ffb6]
	ld c, 10
	call SimpleDivide
	sla b
	sla b
	sla b
	sla b
	or b
	ld [hl], a
	ret

; SetPlayerGender: ; 48dcb (12:4dcb)
	; call Function48e14
	; call Function48e47
	; call Function48e64
	; call Function3200
	; call Function32f9
	; ld hl, UnknownText_0x48e0f
	; call PrintText
	; ld hl, MenuDataHeader_0x48dfc
	; call LoadMenuDataHeader
	; call Function3200
	; call Function1d81
	; call Function1c17
	; ld a, [wcfa9]
	; dec a
	; ld [PlayerGender], a
	; ld c, $a
	; call DelayFrames
	; ret
; ; 48dfc (12:4dfc)

; MenuDataHeader_0x48dfc: ; 0x48dfc
	; db $40 ; flags
	; db 04, 06 ; start coords
	; db 09, 12 ; end coords
	; dw MenuData2_0x48e04
	; db 1 ; default option
; ; 0x48e04

; MenuData2_0x48e04: ; 0x48e04
	; db $a1 ; flags
	; db 2 ; items
	; db "Boy@"
	; db "Girl@"
; ; 0x48e0f

; UnknownText_0x48e0f: ; 0x48e0f
	; ; Are you a boy? Or are you a girl?
	; text_jump UnknownText_0x1c0ca3
	; db "@"
; ; 0x48e14

; Function48e14: ; 48e14 (12:4e14)
	; ld a, $10
	; ld [MusicFade], a
	; ld a, $0
	; ld [MusicFadeIDLo], a
	; ld a, $0
	; ld [MusicFadeIDHi], a
	; ld c, $8
	; call DelayFrames
	; call WhiteBGMap
	; call Function48000
	; call Functione5f
	; hlcoord 0, 0
	; ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	; ld a, $0
	; call ByteFill
	; hlcoord 0, 0, AttrMap
	; ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	; xor a
	; call ByteFill
	; ret

; Function48e47: ; 48e47 (12:4e47)
	; ld hl, Palette_48e5c
	; ld de, Unkn1Pals
	; ld bc, $8
	; ld a, $5
	; call FarCopyWRAM
	; callba Function96a4
	; ret
; ; 48e5c (12:4e5c)

; Palette_48e5c: ; 48e5c
	; RGB 31, 31, 31
	; RGB 09, 30, 31
	; RGB 01, 11, 31
	; RGB 00, 00, 00
; ; 48e64

; Function48e64: ; 48e64 (12:4e64)
	; ld de, GFX_48e71
	; ld hl, $9000
	; lb bc, BANK(GFX_48e71), 1
	; call Get2bpp
	; ret
; ; 48e71 (12:4e71)

; GFX_48e71: ; 48e71
; INCBIN "gfx/unknown/048e71.2bpp"

Function48e81: ; 48e81
	ld hl, PackFGFXPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $9500
	lb bc, BANK(PackFGFX), 15
	call Request2bpp
	ret
; 48e93

PackFGFXPointers: ; 48e93
	dw PackFGFX + $f0 * 1
	dw PackFGFX + $f0 * 3
	dw PackFGFX + $f0 * 0
	dw PackFGFX + $f0 * 2
; 48e9b

PackFGFX: ; 48e9b
INCBIN "gfx/misc/pack_f.w40.2bpp"
; 4925b

Function4925b: ; 4925b
	call FadeToMenu
	call WhiteBGMap
	call ClearScreen
	call DelayFrame
	ld b, $14
	call GetSGBLayout
	xor a
	ld [wd142], a
	call Function492a5 ;load a move into a (is it that easy?)
	ld [wd265], a
	ld [wd262], a
	call GetMoveName
	call CopyName1
	callba Function2c7fb
	jr c, .asm_4929c
	jr .asm_49291

.asm_49289
	callba Function2c80a
	jr c, .asm_4929c
.asm_49291
	call Function492b9
	jr nc, .asm_49289
	xor a
	ld [ScriptVar], a
	jr .asm_492a1

.asm_4929c
	ld a, $ff
	ld [ScriptVar], a
.asm_492a1
	call Function2b3c
	ret
; 492a5

Function492a5: ; 492a5 load appropriote tutor move into a
	push hl
	push bc
	ld hl, TutorMovesTable
	ld a, [ScriptVar]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret

TutorMovesTable:
	db 0, FLAMETHROWER, THUNDERBOLT, ICE_BEAM, ICE_PUNCH, THUNDERPUNCH, FIRE_PUNCH, FALSE_SWIPE
; 492b9

Function492b9: ; 492b9
	ld hl, MenuDataHeader_0x4930a
	call LoadMenuDataHeader
	predef CanLearnTMHMMove
	push bc
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call GetNick
	pop bc
	ld a, c
	and a
	jr nz, .can_learn
	push de
	ld de, SFX_WRONG
	call PlaySFX
	pop de
	ld a, BANK(UnknownText_0x2c8ce)
	ld hl, UnknownText_0x2c8ce
	call FarPrintText
	jr .didnt_learn

.can_learn
	callab KnowsMove
	jr c, .didnt_learn
	ld b, 0
	predef LearnMove
	ld a, b
	and a
	jr z, .didnt_learn
	ld c, $5
	callab ChangeHappiness
	jr .learned

.didnt_learn
	call Function1c07 ;unload top menu on menu stack
	and a
	ret

.learned
	call Function1c07 ;unload top menu on menu stack
	scf
	ret
; 4930a

MenuDataHeader_0x4930a: ; 0x4930a
	db $40 ; flags
	db 12, 00 ; start coords
	db 17, 19 ; end coords
; 4930f

Function4930f: ; 4930f (12:530f)
	ld a, b
	cp $ff
	jr nz, .asm_49317
	ld a, [SGBPredef]
.asm_49317
	push af
	callba Function9673
	pop af
	ld l, a
	ld h, 0
	add hl, hl
	ld de, Jumptable_49330
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, .done
	push de
	jp [hl]

.done
	ret
; 49330 (12:5330)

Jumptable_49330: ; 49330
	dw Function4936e
	dw Function4942f
	dw Function49706
; 49336

Function49336: ; 49336
.asm_49336
	push bc
	push hl
.asm_49338
	ld [hli], a
	dec c
	jr nz, .asm_49338
	pop hl
	ld bc, $0014
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_49336
	ret
; 49346

Function49346: ; 49346 (12:5346)
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	ret

Function49351: ; 49351 (12:5351)
	ld de, Unkn1Pals
	ld hl, Palette_493e1
	ld bc, $28
	ld a, $5 ; BANK(Unkn1Pals)
	call FarCopyWRAM
	ld de, Unkn1Pals + $38
	ld hl, Palette_49418
	ld bc, $8
	ld a, $5 ; BANK(Unkn1Pals)
	call FarCopyWRAM
	ret

Function4936e: ; 4936e (12:536e)
	call Function49351
	call Function49346
	call Function49384
	callba Function96b3
	callba Function96a4
	ret

Function49384: ; 49384 (12:5384)
	hlcoord 0, 0, AttrMap
	ld bc, $401
	ld a, $1
	call Function49336
	ld bc, $201
	ld a, $2
	call Function49336
	ld bc, $601
	ld a, $3
	call Function49336
	hlcoord 1, 0, AttrMap
	ld a, $1
	ld bc, $312
	call Function49336
	ld bc, $212
	ld a, $2
	call Function49336
	ld bc, $c12
	ld a, $3
	call Function49336
	hlcoord 19, 0, AttrMap
	ld bc, $401
	ld a, $1
	call Function49336
	ld bc, $201
	ld a, $2
	call Function49336
	ld bc, $601
	ld a, $3
	call Function49336
	hlcoord 0, 12, AttrMap
	ld bc, $78
	ld a, $7
	call ByteFill
	ret
; 493e1 (12:53e1)

Palette_493e1: ; 493e1
	RGB 03, 07, 09
	RGB 26, 31, 00
	RGB 20, 16, 03
	RGB 31, 31, 31
	RGB 13, 24, 29
	RGB 11, 16, 30
	RGB 07, 11, 22
	RGB 05, 06, 18
	RGB 31, 31, 31
	RGB 20, 26, 31
	RGB 13, 24, 29
	RGB 11, 16, 30
	RGB 31, 31, 31
	RGB 20, 26, 31
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 20, 16, 08
	RGB 31, 00, 00
	RGB 00, 00, 00
; 49409

Function49409:: ; 49409
	ld hl, Palette_49418
	ld de, Unkn1Pals + 8 * 7
	ld bc, $0008
	ld a, $5
	call FarCopyWRAM
	ret
; 49418

Palette_49418: ; 49418
	RGB 31, 31, 31
	RGB 08, 19, 28
	RGB 05, 05, 16
	RGB 00, 00, 00
; 49420

Function49420:: ; 49420 (12:5420)
	ld hl, Palette_496bd
	ld de, Unkn1Pals + $30
	ld bc, $8
	ld a, $5 ; BANK(Unkn1Pals)
	call FarCopyWRAM
	ret
; 4942f (12:542f)

Function4942f: ; 4942f
	call Function49351
	ld de, Unkn1Pals + $38
	ld hl, Palette_49478
	ld bc, $8
	ld a, $5 ; BANK(Unkn1Pals)
	call FarCopyWRAM
	call Function49346
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	hlcoord 0, 14, AttrMap
	ld bc, $0050
	ld a, $7
	call ByteFill
	ld a, [DefaultFlypoint]
	bit 6, a
	jr z, .asm_49464
	call Function49480
	jr .asm_49467

.asm_49464
	call Function49496
.asm_49467
	callba Function96b3
	callba Function96a4
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 49478

Palette_49478: ; 49478
	RGB 31, 31, 31
	RGB 26, 31, 00
	RGB 20, 16, 03
	RGB 00, 00, 00
; 49480

Function49480: ; 49480
	hlcoord 0, 0, AttrMap
	ld bc, $0414
	ld a, $7
	call Function49336
	hlcoord 0, 2, AttrMap
	ld a, $4
	ld [hl], a
	hlcoord 19, 2, AttrMap
	ld [hl], a
	ret
; 49496

Function49496: ; 49496
	hlcoord 0, 0, AttrMap
	ld bc, $0214
	ld a, $7
	call Function49336
	hlcoord 0, 1, AttrMap
	ld a, $4
	ld [hl], a
	hlcoord 19, 1, AttrMap
	ld [hl], a
	ret
; 494ac

Function494ac: ; 494ac
	ld a, [wTileset]
	cp $15
	jr z, .pokecom
	cp $16
	jr z, .battletower
	cp $1d
	jr z, .icepath
	cp $5
	jr z, .house1
	cp $1b
	jr z, .radiotower
	cp $d
	jr z, .mansion
	jr .indoor

.pokecom
	call Function494f2
	scf
	ret

.battletower
	call Function49541
	scf
	ret

.icepath
	ld a, [wMapHeaderPermission]
	and $7
	cp INDOOR
	jr z, .indoor
	call Function49590
	scf
	ret

.house1
	call Function495df
	scf
	ret

.radiotower
	call Function4962e
	scf
	ret

.mansion
	call Function496c5
	scf
	ret

.indoor
	and a
	ret
; 494f2

Function494f2: ; 494f2
	ld a, $5
	ld de, Unkn1Pals
	ld hl, Palette_49501
	ld bc, $0040
	call FarCopyWRAM
	ret
; 49501

Palette_49501: ; 49501
	RGB 30, 28, 26
	RGB 19, 19, 19
	RGB 13, 13, 13
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07
	RGB 18, 24, 09
	RGB 15, 20, 01
	RGB 09, 13, 00
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 17, 19, 31
	RGB 14, 16, 31
	RGB 07, 07, 07
	RGB 31, 26, 21
	RGB 31, 20, 01
	RGB 14, 16, 31
	RGB 07, 07, 07
	RGB 21, 17, 07
	RGB 17, 19, 31
	RGB 16, 13, 03
	RGB 07, 07, 07
	RGB 05, 05, 16
	RGB 08, 19, 28
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 49541

Function49541: ; 49541
	ld hl, .pointers
	ld a, [TimeOfDayPal]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Unkn1Pals
	ld bc, $0040
	ld a, $5
	call FarCopyWRAM
	ret
; 49550

.pointers
	dw Palette_49550
	dw Palette_49550_2

Palette_49550_2:
Palette_49550: ; 49550
	RGB 30, 28, 26
	RGB 19, 19, 19
	RGB 13, 13, 13
	RGB 07, 07, 07

	RGB 30, 28, 26
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07

	RGB 18, 24, 09
	RGB 15, 20, 01
	RGB 09, 13, 00
	RGB 07, 07, 07

	RGB 30, 28, 26
	RGB 15, 16, 31
	RGB 09, 09, 31
	RGB 07, 07, 07

	RGB 30, 28, 26
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 07, 07, 07

	RGB 26, 24, 17
	RGB 21, 17, 07
	RGB 16, 13, 03
	RGB 07, 07, 07

	RGB 05, 05, 16
	RGB 08, 19, 28
	RGB 00, 00, 00
	RGB 31, 31, 31

	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 49590

Function49590: ; 49590
	ld a, $5
	ld de, Unkn1Pals
	ld hl, Palette_4959f
	ld bc, $0040
	call FarCopyWRAM
	ret
; 4959f

Palette_4959f: ; 4959f
	RGB 15, 14, 24
	RGB 11, 11, 19
	RGB 07, 07, 12
	RGB 00, 00, 00
	RGB 15, 14, 24
	RGB 14, 07, 17
	RGB 13, 00, 08
	RGB 00, 00, 00
	RGB 22, 29, 31
	RGB 10, 27, 31
	RGB 31, 31, 31
	RGB 05, 00, 09
	RGB 15, 14, 24
	RGB 05, 05, 17
	RGB 03, 03, 10
	RGB 00, 00, 00
	RGB 30, 30, 11
	RGB 16, 14, 18
	RGB 16, 14, 10
	RGB 00, 00, 00
	RGB 15, 14, 24
	RGB 12, 09, 15
	RGB 08, 04, 05
	RGB 00, 00, 00
	RGB 25, 31, 31
	RGB 09, 28, 31
	RGB 16, 11, 31
	RGB 05, 00, 09
	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 495df

Function495df: ; 495df
	ld a, $5
	ld de, Unkn1Pals
	ld hl, Palette_495ee
	ld bc, $0040
	call FarCopyWRAM
	ret
; 495ee

Palette_495ee: ; 495ee
	RGB 30, 28, 26
	RGB 19, 19, 19
	RGB 13, 13, 13
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 15, 20, 01
	RGB 09, 13, 00
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 15, 16, 31
	RGB 09, 09, 31
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 07, 07, 07
	RGB 26, 24, 17
	RGB 21, 17, 07
	RGB 16, 13, 03
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 19, 24
	RGB 16, 13, 03
	RGB 07, 07, 07
	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 4962e

Function4962e: ; 4962e
	ld a, $5
	ld de, Unkn1Pals
	ld hl, Palette_4963d
	ld bc, $0040
	call FarCopyWRAM
	ret
; 4963d

Palette_4963d: ; 4963d
	RGB 27, 31, 27
	RGB 21, 21, 21
	RGB 13, 13, 13
	RGB 07, 07, 07
	RGB 27, 31, 27
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07
	RGB 08, 12, 31
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 07, 07, 07
	RGB 31, 31, 31
	RGB 08, 12, 31
	RGB 01, 04, 31
	RGB 07, 07, 07
	RGB 27, 31, 27
	RGB 12, 25, 01
	RGB 05, 14, 00
	RGB 07, 07, 07
	RGB 27, 31, 27
	RGB 24, 18, 07
	RGB 20, 15, 03
	RGB 07, 07, 07
	RGB 27, 31, 27
	RGB 15, 31, 31
	RGB 05, 17, 31
	RGB 07, 07, 07
	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 4967d

Palette_4967d: ; 4967d
	RGB 30, 28, 26
	RGB 19, 19, 19
	RGB 13, 13, 13
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 19, 24
	RGB 30, 10, 06
	RGB 07, 07, 07
	RGB 18, 24, 09
	RGB 15, 20, 01
	RGB 09, 13, 00
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 15, 16, 31
	RGB 09, 09, 31
	RGB 07, 07, 07
	RGB 30, 28, 26
	RGB 31, 31, 07
	RGB 31, 16, 01
	RGB 07, 07, 07
	RGB 26, 24, 17
	RGB 21, 17, 07
	RGB 16, 13, 03
	RGB 07, 07, 07
Palette_496ad: ; 496ad
	RGB 30, 28, 26
	RGB 17, 19, 31
	RGB 14, 16, 31
	RGB 07, 07, 07
	RGB 31, 31, 16
	RGB 31, 31, 16
	RGB 14, 09, 00
	RGB 00, 00, 00
; 496bd

Palette_496bd: ; 496bd
	RGB 05, 05, 16
	RGB 08, 19, 28
	RGB 00, 00, 00
	RGB 31, 31, 31
; 496c5

Function496c5: ; 496c5
	ld a, $5
	ld de, Unkn1Pals
	ld hl, Palette_4967d
	ld bc, $0040
	call FarCopyWRAM
	ld a, $5
	ld de, wd020
	ld hl, Palette_496fe
	ld bc, $0008
	call FarCopyWRAM
	ld a, $5
	ld de, wd018
	ld hl, Palette_496ad
	ld bc, $0008
	call FarCopyWRAM
	ld a, $5
	ld de, wd030
	ld hl, Palette_496bd
	ld bc, $0008
	call FarCopyWRAM
	ret
; 496fe

Palette_496fe: ; 496fe
	RGB 25, 24, 23
	RGB 20, 19, 19
	RGB 14, 16, 31
	RGB 07, 07, 07
; 49706

Function49706: ; 49706
	ld hl, Palette_49732
	ld de, Unkn1Pals
	ld bc, $0008
	ld a, $5
	call FarCopyWRAM
	callba Function96a4
	call Function49346
	callba Function96b3
	ld hl, Palette_4973a
	ld de, Unkn2Pals
	ld bc, $0008
	ld a, $5
	call FarCopyWRAM
	ret
; 49732

Palette_49732: ; 49732
	RGB 31, 31, 31
	RGB 23, 16, 07
	RGB 23, 07, 07
	RGB 03, 07, 20
; 4973a

Palette_4973a: ; 4973a
	RGB 00, 00, 00
	RGB 07, 05, 31
	RGB 14, 18, 31
	RGB 31, 31, 31
; 49742

Function49742: ; 49742
	ld hl, Palette_49757
	ld de, Unkn1Pals
	ld bc, $0040
	ld a, $5
	call FarCopyWRAM
	callba Function96a4
	ret
; 49757

Palette_49757: ; 49757
	RGB 31, 31, 63
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 31, 31, 63
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 31, 00, 00
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 30, 16, 26
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 16, 16, 16
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 31, 12, 12
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 07, 08, 31
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 21, 00, 21
	RGB 29, 28, 09
	RGB 31, 31, 31
; 49797

Function49797: ; 49797
	hlcoord 0, 0, AttrMap
	ld bc, $1002
	ld a, $4
	call Function49336
	ld a, $3
	ld [AttrMap + 0 + 1 * SCREEN_WIDTH], a
	ld [AttrMap + 0 + 14 * SCREEN_WIDTH], a
	hlcoord 2, 0, AttrMap
	ld bc, $0812
	ld a, $5
	call Function49336
	hlcoord 2, 8, AttrMap
	ld bc, $0812
	ld a, $6
	call Function49336
	hlcoord 0, 16, AttrMap
	ld bc, $0214
	ld a, $4
	call Function49336
	ld a, $3
	ld bc, $0601
	hlcoord 6, 1, AttrMap
	call Function49336
	ld a, $3
	ld bc, $0601
	hlcoord 17, 1, AttrMap
	call Function49336
	ld a, $3
	ld bc, $0601
	hlcoord 6, 9, AttrMap
	call Function49336
	ld a, $3
	ld bc, $0601
	hlcoord 17, 9, AttrMap
	call Function49336
	ld a, $2
	hlcoord 2, 16, AttrMap
	ld [hli], a
	ld a, $7
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $2
	ld [hl], a
	hlcoord 2, 17, AttrMap
	ld a, $3
	ld bc, $0006
	call ByteFill
	ret
; 49811

Function49811: ; 49811
	ld hl, Palette_49826
	ld de, wd010
	ld bc, $0030
	ld a, $5
	call FarCopyWRAM
	callba Function96a4
	ret
; 49826

Palette_49826: ; 49826
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 31, 00, 00
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 15, 23, 30
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 16, 16, 16
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 25, 07, 04
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 03, 22, 08
	RGB 31, 31, 31
	RGB 04, 02, 15
	RGB 07, 09, 31
	RGB 29, 28, 09
	RGB 31, 31, 31
; 49856

Function49856: ; 49856
	call Function49797
	ret
; 4985a

Unknown_4985a: ; unreferenced
	db $ab, $03, $57, $24, $ac, $0e, $13, $32
	db $be, $30, $5b, $4c, $47, $60, $ed, $f2
	db $ab, $03, $55, $26, $aa, $0a, $13, $3a
	db $be, $28, $33, $24, $6e, $71, $df, $b0
	db $a8, $00, $e5, $e0, $9a, $fc, $f4, $2c
	db $fe, $4c, $a3, $5e, $c6, $3a, $ab, $4d
	db $a8, $00, $b5, $b0, $de, $e8, $fc, $1c
	db $ba, $66, $f7, $0e, $ba, $5e, $43, $bd
Function4989a: ; 4989a
	call DelayFrame
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	call Function49912
	ld de, $0750
	ld a, $2c
	call Function3b2a
	ld hl, $0003
	add hl, bc
	ld [hl], $84
	ld hl, $0002
	add hl, bc
	ld [hl], $1f
	ld hl, $000f
	add hl, bc
	ld a, $80
	ld [hl], a
	ld a, $a0
	ld [wcf64], a
	ld d, $0
.asm_498ca
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_498ee
	push bc
	call Function49bae
	inc d
	push de
	ld a, $90
	ld [wc3b5], a
	callba Function8cf7a
	call Function49935
	ld c, $2
	call DelayFrames
	pop de
	pop bc
	jr .asm_498ca

.asm_498ee
	pop af
	ld [VramState], a
	call Function498f9
	call Function49bf3
	ret
; 498f9

Function498f9: ; 498f9
	ld hl, Sprites + 2
	xor a
	ld c, $4
.asm_498ff
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc a
	dec c
	jr nz, .asm_498ff
	ld hl, Sprites + $10
	ld bc, $0090
	xor a
	call ByteFill
	ret
; 49912

Function49912: ; 49912
	callba Function8cf53
	ld de, SpecialCelebiLeafGFX
	ld hl, VTiles1
	lb bc, BANK(SpecialCelebiLeafGFX), 4
	call Request2bpp
	ld de, SpecialCelebiGFX
	ld hl, $8840
	lb bc, BANK(SpecialCelebiGFX), $10
	call Request2bpp
	xor a
	ld [wcf63], a
	ret
; 49935

Function49935: ; 49935
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_4993e
	dec [hl]
	ret

.asm_4993e
	ld hl, wcf63
	set 7, [hl]
	ret
; 49944

Function49944: ; 49944
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	and $7
	ret nz
	ld a, [hl]
	and $18
	sla a
	add $40
	ld d, a
	ld e, $0
	ld a, $18
	call Function3b2a
	ld hl, $0003
	add hl, bc
	ld [hl], $80
	ret
; 49962

SpecialCelebiLeafGFX: ; 49962
INCBIN "gfx/special/celebi/leaf.2bpp"

SpecialCelebiGFX: ; 499a2
INCBIN "gfx/special/celebi/1.2bpp"

INCBIN "gfx/special/celebi/2.2bpp"
INCBIN "gfx/special/celebi/3.2bpp"

INCBIN "gfx/special/celebi/4.2bpp"
Function49aa2: ; 49aa2 (12:5aa2)
	ld hl, $6
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $52
	jp nc, Function49b30
	ld hl, $5
	add hl, bc
	inc [hl]
	ld hl, $f
	add hl, bc
	ld a, [hl]
	ld d, a
	cp $3a
	jr c, .asm_49ac6
	jr z, .asm_49ac6
	sub $3
	ld [hl], a
.asm_49ac6
	ld hl, $e
	add hl, bc
	ld a, [hl]
	inc [hl]
	call Function49b3b
	ld hl, $6
	add hl, bc
	ld [hl], a
	ld d, a
	ld hl, $4
	add hl, bc
	add [hl]
	cp $5c
	jr nc, .asm_49ae2
	cp $44
	jr nc, .asm_49b0d
.asm_49ae2
	pop af
	push af
	cp d
	jr nc, .asm_49af2
	ld hl, $4
	add hl, bc
	add [hl]
	cp $50
	jr c, .asm_49b05
	jr .asm_49afb

.asm_49af2
	ld hl, $4
	add hl, bc
	add [hl]
	cp $50
	jr nc, .asm_49b05
.asm_49afb
	ld hl, $5
	add hl, bc
	ld a, [hl]
	sub $2
	ld [hl], a
	jr .asm_49b0d

.asm_49b05
	ld hl, $5
	add hl, bc
	ld a, [hl]
	add $1
	ld [hl], a
.asm_49b0d
	pop af
	ld hl, $4
	add hl, bc
	add [hl]
	cp $50
	jr c, .asm_49b26
	cp $e6
	jr nc, .asm_49b26
	ld hl, $1
	add hl, bc
	ld a, $41
	call Function3b3c
	jr .asm_49b2f

.asm_49b26
	ld hl, $1
	add hl, bc
	ld a, $40
	call Function3b3c
.asm_49b2f
	ret

Function49b30: ; 49b30 (12:5b30)
	pop af
	ld hl, $1
	add hl, bc
	ld a, $40
	call Function3b3c
	ret

Function49b3b: ; 49b3b (12:5b3b)
	add $10
	and $3f
	cp $20
	jr nc, .asm_49b48
	call Function49b52
	ld a, h
	ret

.asm_49b48
	and $1f
	call Function49b52
	ld a, h
	xor $ff
	inc a
	ret

Function49b52: ; 49b52 (12:5b52)
	ld e, a
	ld a, d
	ld d, $0
	ld hl, Unknown_49b6e
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.asm_49b61
	srl a
	jr nc, .asm_49b66
	add hl, de
.asm_49b66
	sla e
	rl d
	and a
	jr nz, .asm_49b61
	ret
; 49b6e (12:5b6e)

Unknown_49b6e: ; 49b6e
	sine_wave $100
; 49bae

Function49bae: ; 49bae
	push hl
	push bc
	push de
	ld a, d
	ld d, $3
	ld e, d
	cp $0
	jr z, .asm_49bd0
	cp d
	jr z, .asm_49bd4
	call Function49bed
	cp d
	jr z, .asm_49bd8
	call Function49bed
	cp d
	jr z, .asm_49bdc
	call Function49bed
	cp d
	jr c, .asm_49be9
	jr .asm_49be5

.asm_49bd0
	ld a, $84
	jr .asm_49bde

.asm_49bd4
	ld a, $88
	jr .asm_49bde

.asm_49bd8
	ld a, $8c
	jr .asm_49bde

.asm_49bdc
	ld a, $90
.asm_49bde
	ld hl, $0003
	add hl, bc
	ld [hl], a
	jr .asm_49be9

.asm_49be5
	pop de
	ld d, $ff
	push de
.asm_49be9
	pop de
	pop bc
	pop hl
	ret
; 49bed

Function49bed: ; 49bed
	push af
	ld a, d
	add e
	ld d, a
	pop af
	ret
; 49bf3

Function49bf3: ; 49bf3
	ld a, BATTLETYPE_CELEBI
	ld [BattleType], a
	ret
; 49bf9

Function49bf9: ; 49bf9
	ld a, [wd0ee]
	bit 6, a
	jr z, .asm_49c07
	ld a, $1
	ld [ScriptVar], a
	jr .asm_49c0b

.asm_49c07
	xor a
	ld [ScriptVar], a
.asm_49c0b
	ret
; 49c0c

GFX_49c0c: ; 49c0c
INCBIN "gfx/unknown/049c0c.2bpp"
; 49cdc

MainMenu: ; 49cdc
	callba DeleteSavedMusic
	xor a
	ld [wc2d7], a
	call Function49ed0
	ld b, $8
	call GetSGBLayout
	call Function32f9
	ld hl, GameTimerPause
	res 0, [hl]
	call Function49da4
	ld [wcf76], a
	call Function49e09
	ld hl, MenuDataHeader_0x49d14
	call LoadMenuDataHeader
	call Function49de4
	call Function1c17
	jr c, .quit
	call ClearTileMap
	ld a, [MenuSelection]
	ld hl, Jumptable_49d60
	rst JumpTable
	jr MainMenu

.quit
	ret
; 49d14

MenuDataHeader_0x49d14: ; 49d14
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 16 ; end coords
	dw MenuData2_0x49d1c
	db 1 ; default option
; 49d1c

MenuData2_0x49d1c: ; 49d1c
	db $80 ; flags
	db 0 ; items
	dw MainMenuItems
	dw Function1f79
	dw MainMenuText
; 49d20

MainMenuText: ; 49d24
	db "CONTINUER@"
	db "NOUVEAU JEU@"
	db "OPTION@"
	db "CADEAU MYSTERE@"
	db "MOBILE@"
	db "MOBILE STUDIUM@"
Jumptable_49d60: ; 0x49d60
	dw MainMenu_Continue
	dw MainMenu_NewGame
	dw MainMenu_Options
	dw MainMenu_MysteryGift
	dw MainMenu_Mobile
	dw MainMenu_MobileStudium

; 0x49d6c

CONTINUE       EQU 0
NEW_GAME       EQU 1
OPTION         EQU 2
MYSTERY_GIFT   EQU 3
MOBILE         EQU 4
MOBILE_STUDIUM EQU 5

MainMenuItems:

NewGameMenu: ; 0x49d6c
	db 2
	db NEW_GAME
	db OPTION
	db -1

ContinueMenu: ; 0x49d70
	db 3
	db CONTINUE
	db NEW_GAME
	db OPTION
	db -1

MobileMysteryMenu: ; 0x49d75
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE
	db -1

MobileMenu: ; 0x49d7c
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE
	db -1

MobileStudiumMenu: ; 0x49d82
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE
	db MOBILE_STUDIUM
	db -1

MysteryMobileStudiumMenu: ; 0x49d89
	db 6
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE
	db MOBILE_STUDIUM
	db -1

MysteryMenu: ; 0x49d91
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db -1

MysteryStudiumMenu: ; 0x49d97
	db 5
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MYSTERY_GIFT
	db MOBILE_STUDIUM
	db -1

StudiumMenu: ; 0x49d9e
	db 4
	db CONTINUE
	db NEW_GAME
	db OPTION
	db MOBILE_STUDIUM
	db -1
	
Function49da4: ; 49da4
	nop
	nop
	nop
	ld a, [wcfcd]
	and a
	jr nz, .asm_49db0
	ld a, $0
	ret

.asm_49db0
IF !DEF(BEESAFREE)
	ld a, [hCGB]
	cp $1
	ld a, $1
	ret nz
	ld a, $0
	call GetSRAMBank
	ld a, [$abe5]
	cp $ff
	call CloseSRAM
	jr nz, .asm_49dd6
ENDC
	ld a, $1
	ret

.asm_49dd6
	ld a, $6
	ret
; 49de4

Function49de4: ; 49de4
	call SetUpMenu
.asm_49de7
	call Function49e09
	ld a, [wcfa5]
	set 5, a
	ld [wcfa5], a
	call Function1f1a
	ld a, [wcf73]
	cp $2
	jr z, .asm_49e07
	cp $1
	jr z, .asm_49e02
	jr .asm_49de7

.asm_49e02
	call PlayClickSFX
	and a
	ret

.asm_49e07
	scf
	ret
; 49e09

Function49e09: ; 49e09
	ld a, [wcfcd]
	and a
	ret z
	xor a
	ld [hBGMapMode], a
	call Function49e27
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl]
	call Function49e3d
	pop af
	ld [Options], a
	ld a, $1
	ld [hBGMapMode], a
	ret
; 49e27

Function49e27: ; 49e27
	call Function6e3
	and $80
	jr nz, .asm_49e39
	ld a, [Options2]
	bit 2, a
	hlcoord 0, 15
	ld b, $1
	jr z, .h24
	hlcoord 0, 14
	ld b, $2
.h24
	ld c, $12
	call TextBox
	ret

.asm_49e39
	call SpeechTextBox
	ret
; 49e3d

Function49e3d: ; 49e3d
	ld a, [wcfcd]
	and a
	ret z
	call Function6e3
	and $80
	jp nz, Function49e75
	call UpdateTime
	call GetWeekday
	ld b, a
	ld a, [Options2]
	bit 2, a
	jr z, .h24
	decoord 1, 15
	call Function49e91
	decoord 4, 16
	ld a, [hHours]
	ld c, a
	callba Function90b3e
	jr .skip
.h24
	decoord 1, 16
	call Function49e91
	hlcoord 11, 16
	ld de, hHours
	ld bc, $102
	call PrintNum
.skip
	ld [hl], ":"
	inc hl
	ld de, hMinutes
	ld bc, $8102
	call PrintNum
	ld [hl], ":"
	inc hl
	ld de, hSeconds
	ld bc, $8102
	call PrintNum
	ret
; 49e70
; 49e70

	db "min.@"
; 49e75

Function49e75: ; 49e75
	hlcoord 1, 14
	ld de, .TimeNotSet
	call PlaceString
	ret
; 49e7f

.TimeNotSet ; 49e7f
	db "TIME NOT SET@"
; 49e8c

UnknownText_0x49e8c: ; 49e8c
	text_jump UnknownText_0x1c5182
	db "@"
; 49e91

Function49e91: ; 49e91
	push de
	ld hl, .Days
	ld a, b
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	ld h, b
	ld l, c
	ld de, .Day
	call PlaceString
	ret
; 49ea8

.Days
	db "SUN@"
	db "MON@"
	db "TUES@"
	db "WEDNES@"
	db "THURS@"
	db "FRI@"
	db "SATUR@"
.Day
	db "DAY@"
; 49ed0

Function49ed0: ; 49ed0
	xor a
	ld [$ffde], a
	call ClearTileMap
	call Functione5f
	call Functione51
	call Function1fbf
	ret
; 49ee0

MainMenu_NewGame: ; 49ee0
	callba NewGame
	ret
; 49ee7

MainMenu_Options: ; 49ee7
	callba OptionsMenu
	ret
; 49eee

MainMenu_Continue: ; 49eee
	callba Continue
	ret
; 49ef5

MainMenu_MysteryGift: ; 49ef5
	callba MysteryGift
	ret
; 49efc

MainMenu_Mobile: ; 49efc
	call WhiteBGMap
	ld a, MUSIC_MOBILE_ADAPTER_MENU
	ld [wMapMusic], a
	ld de, MUSIC_MOBILE_ADAPTER_MENU
	call Function4a6c5
Function49f0a: ; 49f0a
	call WhiteBGMap
	call Function4a3a7
	call Function4a492
	call WhiteBGMap
Function49f16: ; 49f16
	call Function4a071
	ld c, $c
	call DelayFrames
	hlcoord 4, 0
	ld b, $a
	ld c, $a
	call Function48cdc
	hlcoord 6, 2
	ld de, MobileString1
	call PlaceString
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	xor a
	ld de, String_0x49fe9
	hlcoord 1, 14
	call PlaceString
	call Function3200
	call Function32f9
	call Function1bc9
	ld hl, wcfa9
	ld b, [hl]
	push bc
	jr .asm_49f5d

.asm_49f55
	call Function1bd3
	ld hl, wcfa9
	ld b, [hl]
	push bc
.asm_49f5d
	bit 0, a
	jr nz, .asm_49f67
	bit 1, a
	jr nz, .asm_49f84
	jr .asm_49f97

.asm_49f67
	ld hl, wcfa9
	ld a, [hl]
	cp $1
	jp z, Function4a098
	cp $2
	jp z, Function4a0b9
	cp $3
	jp z, Function4a0c2
	cp $4
	jp z, Function4a100
	ld a, $1
	call Function1ff8
.asm_49f84
	pop bc
	call WhiteBGMap
	call ClearTileMap
	ld a, MUSIC_MAIN_MENU
	ld [wMapMusic], a
	ld de, MUSIC_MAIN_MENU
	call Function4a6c5
	ret

.asm_49f97
	ld hl, wcfa9
	ld a, [hl]
	dec a
	ld hl, MobileStrings2
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 13
	ld b, $4
	ld c, $12
	call ClearBox
	hlcoord 1, 14
	call PlaceString
	jp .asm_49fb7

.asm_49fb7
	call Function4a071
	pop bc
	ld hl, wcfa9
	ld [hl], b
	ld b, $a
	ld c, $1
	hlcoord 5, 1
	call ClearBox
	jp .asm_49f55
; 49fcc

MobileString1: ; 49fcc
	db   "めいしフ,ルダー"
	next "あいさつ"
	next "プロフィール"
	next "せ", $1e, "い"
	next "もどる"
	db   "@"
; 49fe9

MobileStrings2:
String_0x49fe9: ; 49fe9
	db   "めいし", $1f, "つくったり"
	next "ほぞんしておける フ,ルダーです@"
; 4a004

String_0x4a004: ; 4a004
	db   "モバイルたいせんや じぶんのめいしで"
	next "つかう あいさつ", $1f, "つくります@"
; 4a026

String_0x4a026: ; 4a026
	db   "あなた", $25, "じゅうしょや ねんれいの"
	next "せ", $1e, "い", $1f, "かえられます@"
; 4a042

String_0x4a042: ; 4a042
	db  "モバイルセンター", $1d, "せつぞくするとき"
	next "ひつような こと", $1f, "きめます@"
; 4a062

String_0x4a062: ; 4a062
	db   "まえ", $25, "がめん ", $1d, "もどります"
	next "@"
; 4a071

Function4a071: ; 4a071 (12:6071)
	ld hl, wcfa1
	ld a, $2
	ld [hli], a
	ld a, $5
	ld [hli], a
	ld a, $5
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $40
	add $80
	add $2
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hli], a
	ret

Function4a098: ; 4a098 (12:6098)
	ld a, $2
	call Function1ff8
	call Function1bee
	call WaitBGMap
	call Function1d6e
	callba Function89de0
	call Function1d7d
	call Function49351
	call Function4a485
	pop bc
	jp Function49f16

Function4a0b9: ; 4a0b9 (12:60b9)
	ld a, $2
	call Function1ff8
	pop bc
	jp Function4a4c4

Function4a0c2: ; 4a0c2 (12:60c2)
	ld a, $2
	call Function1ff8
	ld a, $1
	call GetSRAMBank
	ld hl, $a00b
	ld de, PlayerName
	ld bc, $6
	call CopyBytes
	call CloseSRAM
	callba Function150b9
	ld c, $2
	call DelayFrames
	ld c, $1
	call Function4802f
	push af
	call WhiteBGMap
	pop af
	and a
	jr nz, .asm_4a0f9
	callba Function1509a
.asm_4a0f9
	ld c, $5
	call DelayFrames
	jr asm_4a111

Function4a100: ; 4a100 (12:6100)
	ld a, $2
	call Function1ff8
	call WhiteBGMap
	call Function4a13b
	call WhiteBGMap
	call ClearTileMap
asm_4a111: ; 4a111 (12:6111)
	pop bc
	call Functione5f
	jp Function49f0a

Function4a118: ; 4a118 (12:6118)
	ld hl, wcfa1
	ld a, $1
	ld [hli], a
	ld a, $d
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $2
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hli], a
	ret

Function4a13b: ; 4a13b (12:613b)
	call Function4a3a7
	call Function4a492
	call Function4a373
	ld c, $a
	call DelayFrames
Function4a149: ; 4a149 (12:6149)
	hlcoord 1, 2
	ld b, $6
	ld c, $10
	call Function48cdc
	hlcoord 3, 4
	ld de, String_4a1ef
	call PlaceString
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld a, [wcfa9]
	dec a
	ld hl, Strings_4a23d
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 13
	ld b, $4
	ld c, $12
	call ClearBox
	hlcoord 1, 14
	call PlaceString
	callba Function104148
	call Function32f9
	call Function1bc9
	ld hl, wcfa9
	ld b, [hl]
	push bc
	jr asm_4a19d

Function4a195: ; 4a195 (12:6195)
	call Function1bd3
	ld hl, wcfa9
	ld b, [hl]
	push bc
asm_4a19d: ; 4a19d (12:619d)
	bit 0, a
	jr nz, .asm_4a1a7
	bit 1, a
	jr nz, .asm_4a1ba
	jr .asm_4a1bc

.asm_4a1a7
	ld hl, wcfa9
	ld a, [hl]
	cp $1
	jp z, Function4a20e
	cp $2
	jp z, Function4a221
	ld a, $1
	call Function1ff8
.asm_4a1ba
	pop bc
	ret

.asm_4a1bc
	ld hl, wcfa9
	ld a, [hl]
	dec a
	ld hl, Strings_4a23d
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 13
	ld b, $4
	ld c, $12
	call ClearBox
	hlcoord 1, 14
	call PlaceString
	jr .asm_4a1db

.asm_4a1db
	call Function4a373
	pop bc
	ld hl, wcfa9
	ld [hl], b
	ld bc, $601
	hlcoord 2, 3
	call ClearBox
	jp Function4a195
; 4a1ef (12:61ef)

String_4a1ef: ; 4a1ef
	db   "モバイルセンター", $1f, "えらぶ"
	next "ログインパスワード", $1f, "いれる"
	next "もどる@"
; 4a20e

Function4a20e: ; 4a20e (12:620e)
	ld a, $1
	call Function1ff8
	callba Function1719c8
	call WhiteBGMap
	call DelayFrame
	jr Function4a239

Function4a221: ; 4a221 (12:6221)
	ld a, $1
	call Function1ff8
	call Function4a28a
	jr c, Function4a239
	call Function4a373
	ld a, $2
	ld [wcfa9], a
	jr .asm_4a235

.asm_4a235
	pop bc
	jp Function4a149

Function4a239: ; 4a239 (12:6239)
	pop bc
	jp Function4a13b
; 4a23d (12:623d)

Strings_4a23d: ; 4a23d
	db   "いつも せつぞく", $1f, "する"
	next "モバイルセンター", $1f, "えらびます@"
	db   "モバイルセンター", $1d, "せつぞくするとき"
	next "つかうパスワード", $1f, "ほぞんできます@"
	db   "まえ", $25, "がめん ", $1d, "もどります@"
	db   "@"
; 4a28a

Function4a28a: ; 4a28a (12:628a)
	hlcoord 2, 3
	ld bc, $601
	ld a, $7f
	call Function4a6d8
	call Function1bee
	call WaitBGMap
	call Function1d6e
	ld a, $5
	call GetSRAMBank
	ld a, [$aa4b]
	call CloseSRAM
	and a
	jr z, .asm_4a2df
	hlcoord 12, 0
	ld b, $5
	ld c, $6
	call Function48cdc
	hlcoord 14, 1
	ld de, String_4a34b
	call PlaceString
	callba Function104148
	call Function4a118
	call Function1bd3
	push af
	call PlayClickSFX
	pop af
	bit 1, a
	jr nz, .asm_4a33b
	ld a, [wcfa9]
	cp $2
	jr z, .asm_4a2f0
	cp $3
	jr z, .asm_4a33b
.asm_4a2df
	callba Function11765d
	call WhiteBGMap
	call Function1d7d
	call Functione5f
	scf
	ret

.asm_4a2f0
	call Function1bee
	ld hl, UnknownText_0x4a358
	call PrintText
	hlcoord 14, 7
	ld b, $3
	ld c, $4
	call TextBox
	callba Function104148
	ld hl, MenuDataHeader_0x4a362
	call LoadMenuDataHeader
	call Function1d81
	bit 1, a
	jr nz, .asm_4a338
	ld a, [wcfa9]
	cp $2
	jr z, .asm_4a338
	ld a, $5
	call GetSRAMBank
	ld hl, $aa4b
	xor a
	ld bc, $11
	call ByteFill
	call CloseSRAM
	ld hl, UnknownText_0x4a35d
	call PrintText
	call Functiona36
.asm_4a338
	call Function1c07 ;unload top menu on menu stack
.asm_4a33b
	call Function1d7d
	callba Function104148
	xor a
	ret
; 4a346 (12:6346)

MenuDataHeader_0x4a346: ; 0x4a346
	db $40 ; flags
	db 00, 12 ; start coords
	db 06, 19 ; end coords
String_4a34b: ; 4a34b
	db   "いれなおす"
	next "けす"
	next "もどる@"
; 4a358

UnknownText_0x4a358: ; 0x4a358
	; Delete the saved LOG-IN PASSWORD?
	text_jump UnknownText_0x1c5196
	db "@"
; 0x4a35d

UnknownText_0x4a35d: ; 0x4a35d
	; Deleted the LOG-IN PASSWORD.
	text_jump UnknownText_0x1c51b9
	db "@"
; 0x4a362

MenuDataHeader_0x4a362: ; 0x4a362
	db $40 ; flags
	db 07, 14 ; start coords
	db 11, 19 ; end coords
	dw MenuData2_0x4a36a
	db 2 ; default option
; 0x4a36a

MenuData2_0x4a36a: ; 0x4a36a
	db $e0 ; flags
	db 2 ; items
	db "はい@"
	db "いいえ@"
; 0x4a373

Function4a373: ; 4a373 (12:6373)
	ld hl, wcfa1
	ld a, $4
	ld [hli], a
	ld a, $2
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $40
	add $80
	add $2
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hli], a
	ret
; 4a39a (12:639a)

Function4a39a: ; 4a39a
	call Function4a485
	call Function4a492
	call Function4a3aa
	call Function32f9
	ret
; 4a3a7

Function4a3a7: ; 4a3a7 (12:63a7)
	call Function4a485
Function4a3aa: ; 4a3aa
	hlcoord 0, 0
	ld bc, $301
	xor a
	call Function4a6d8
	ld bc, $101
	ld a, $1
	call Function4a6d8
	ld bc, $101
	xor a
	call Function4a6d8
	ld bc, $101
	ld a, $1
	call Function4a6d8
	ld bc, $401
	ld a, $2
	call Function4a6d8
	ld bc, $101
	ld a, $3
	call Function4a6d8
	ld bc, $101
	ld a, $7f
	call Function4a6d8
	hlcoord 1, 0
	ld a, $1
	ld bc, $312
	call Function4a6d8
	ld bc, $112
	ld a, $0
	call Function4a6d8
	ld bc, $112
	ld a, $1
	call Function4a6d8
	ld bc, $112
	ld a, $2
	call Function4a6d8
	ld bc, $b12
	ld a, $7f
	call Function4a6d8
	hlcoord 19, 0
	ld bc, $301
	ld a, $0
	call Function4a6d8
	ld bc, $101
	ld a, $1
	call Function4a6d8
	ld bc, $101
	xor a
	call Function4a6d8
	ld bc, $101
	ld a, $1
	call Function4a6d8
	ld bc, $401
	ld a, $2
	call Function4a6d8
	ld bc, $101
	ld a, $3
	call Function4a6d8
	ld bc, $101
	ld a, $7f
	call Function4a6d8
	ret
; 4a449 (12:6449)

Function4a449: ; 4a449
	ld bc, $003c
	ld a, $0
	hlcoord 0, 0
	call ByteFill
	ld bc, $0028
	ld a, $1
	call ByteFill
	ld bc, $0028
	ld a, $0
	call ByteFill
	ld bc, $0028
	ld a, $1
	call ByteFill
	ld bc, $0014
	ld a, $2
	call ByteFill
	ld bc, $0014
	ld a, $3
	call ByteFill
	ld bc, $0014
	ld a, $7f
	call ByteFill
	ret
; 4a485

Function4a485: ; 4a485 (12:6485)
	ld de, GFX_49c0c
	ld hl, $9000
	lb bc, BANK(GFX_49c0c), $d
	call Get2bpp
	ret

Function4a492: ; 4a492 (12:6492)
	call Function4936e
	ret

MainMenu_MobileStudium: ; 4a496
	ld a, [StartDay]
	ld b, a
	ld a, [StartHour]
	ld c, a
	ld a, [StartMinute]
	ld d, a
	ld a, [StartSecond]
	ld e, a
	push bc
	push de
	callba MobileStudium
	call WhiteBGMap
	pop de
	pop bc
	ld a, b
	ld [StartDay], a
	ld a, c
	ld [StartHour], a
	ld a, d
	ld [StartMinute], a
	ld a, e
	ld [StartSecond], a
	ret
; 4a4c4

Function4a4c4: ; 4a4c4 (12:64c4)
	call WhiteBGMap
	call Function4a3a7
	call Function4a492
	call Function4a680
	call WhiteBGMap
	ld c, $14
	call DelayFrames
	hlcoord 2, 0
	ld b, $a
	ld c, $e
	call Function48cdc
	hlcoord 4, 2
	ld de, String_4a5c5
	call PlaceString
	hlcoord 4, 4
	ld de, String_4a5cd
	call PlaceString
	hlcoord 4, 6
	ld de, String_4a5da
	call PlaceString
	hlcoord 4, 8
	ld de, String_4a5e6
	call PlaceString
	hlcoord 4, 10
	ld de, String_4a5f2
	call PlaceString
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	xor a
	ld hl, Strings_4a5f6
	ld d, h
	ld e, l
	hlcoord 1, 14
	call PlaceString
	ld a, $1
	ld hl, Strings_4a5f6
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 16
	call PlaceString
	call Function3200
	call Function32f9
	call Function1bc9
	ld hl, wcfa9
	ld b, [hl]
	push bc
	jr asm_4a54d

Function4a545: ; 4a545 (12:6545)
	call Function1bd3
	ld hl, wcfa9
	ld b, [hl]
	push bc
asm_4a54d: ; 4a54d (12:654d)
	bit 0, a
	jr nz, .asm_4a557
	bit 1, a
	jr nz, .asm_4a574
	jr .asm_4a57e

.asm_4a557
	ld hl, wcfa9
	ld a, [hl]
	cp $1
	jp z, Function4a6ab
	cp $2
	jp z, Function4a6ab
	cp $3
	jp z, Function4a6ab
	cp $4
	jp z, Function4a6ab
	ld a, $1
	call Function1ff8
.asm_4a574
	pop bc
	call WhiteBGMap
	call ClearTileMap
	jp Function49f0a

.asm_4a57e
	ld hl, wcfa9
	ld a, [hl]
	dec a
	add a
	push af
	ld hl, Strings_4a5f6
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 13
	ld b, $4
	ld c, $12
	call ClearBox
	hlcoord 1, 14
	call PlaceString
	pop af
	inc a
	ld hl, Strings_4a5f6
	call GetNthString
	ld d, h
	ld e, l
	hlcoord 1, 16
	call PlaceString
	jp Function4a5b0

Function4a5b0: ; 4a5b0 (12:65b0)
	call Function4a680
	pop bc
	ld hl, wcfa9
	ld [hl], b
	ld b, $a
	ld c, $1
	hlcoord 3, 1
	call ClearBox
	jp Function4a545
; 4a5c5 (12:65c5)

String_4a5c5: ; 4a5c5
	db "じこしょうかい@"
String_4a5cd: ; 4a5cd
	db "たいせん ", $4a, "はじまるとき@"
String_4a5da: ; 4a5da
	db "たいせん ", $1d, "かったとき@"
String_4a5e6: ; 4a5e6
	db "たいせん ", $1d, "まけたとき@"
String_4a5f2: ; 4a5f2
	db "もどる@"
; 4a5f6

Strings_4a5f6: ; 4a5f6
	db "めいし や ニュース ", $1d, "のせる@"
	db "あなた", $25, "あいさつです@"
	db "モバイル たいせん", $4a, "はじまるとき@"
	db "あいて", $1d, "みえる あいさつです@"
	db "モバイル たいせんで かったとき@"
	db "あいて", $1d, "みえる あいさつです@"
	db "モバイル たいせんで まけたとき@"
	db "あいて", $1d, "みえる あいさつです@"
	db "まえ", $25, "がめん ", $1d, "もどります@"
	db "@"
; 4a680

Function4a680: ; 4a680 (12:6680)
	ld hl, wcfa1
	ld a, $2
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld a, $5
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hl], $0
	set 5, [hl]
	inc hl
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $1
	add $40
	add $80
	add $2
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Function4a6ab: ; 4a6ab (12:66ab)
	ld a, $2
	call Function1ff8
	call WhiteBGMap
	ld b, $8
	call GetSGBLayout
	callba Function11c1ab
	pop bc
	call Functione5f
	jp Function4a4c4

Function4a6c5: ; 4a6c5 (12:66c5)
	ld a, $5
	ld [MusicFade], a
	ld a, e
	ld [MusicFadeIDLo], a
	ld a, d
	ld [MusicFadeIDHi], a
	ld c, $16
	call DelayFrames
	ret

Function4a6d8: ; 4a6d8 (12:66d8)
	push bc
	push hl
.asm_4a6da
	ld [hli], a
	dec c
	jr nz, .asm_4a6da
	pop hl
	ld bc, $14
	add hl, bc
	pop bc
	dec b
	jr nz, Function4a6d8
	ret

SpecialBeastsCheck: ; 0x4a6e8
; Check if the player owns all three legendary beasts.
; They must exist in either party or PC, and have the player's OT and ID.
; Return the result in ScriptVar.

	ld a, RAIKOU
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist
	ld a, ENTEI
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist
	ld a, SUICUNE
	ld [ScriptVar], a
	call CheckOwnMonAnywhere
	jr nc, .notexist
	; they exist
	ld a, 1
	ld [ScriptVar], a
	ret

.notexist
	xor a
	ld [ScriptVar], a
	ret

SpecialMonCheck: ; 0x4a711
; Check if the player owns any monsters of the species in ScriptVar.
; Return the result in ScriptVar.

	call CheckOwnMonAnywhere
	jr c, .exists
	; doesn't exist
	xor a
	ld [ScriptVar], a
	ret

.exists
	ld a, 1
	ld [ScriptVar], a
	ret

CheckOwnMonAnywhere: ; 0x4a721
; Check if the player owns any monsters of the species in ScriptVar.
; It must exist in either party or PC, and have the player's OT and ID.

	; If there are no monsters in the party,
	; the player must not own any yet.
	ld a, [PartyCount]
	and a
	ret z
	ld d, a
	ld e, 0
	ld hl, PartyMon1Species
	ld bc, PartyMonOT
	; Run CheckOwnMon on each Pokémon in the party.
.partymon
	call CheckOwnMon
	ret c ; found!
	push bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .partymon
	; Run CheckOwnMon on each Pokémon in the PC.
	ld a, 1
	call GetSRAMBank
	ld a, [sBoxCount]
	and a
	jr z, .boxes
	ld d, a
	ld hl, sBoxMon1Species
	ld bc, sBoxMonOT
.openboxmon
	call CheckOwnMon
	jr nc, .next
	; found!
	call CloseSRAM
	ret

.next
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .openboxmon
	; Run CheckOwnMon on each monster in the other 13 PC boxes.
.boxes
	call CloseSRAM
	ld c, 0
.box
	; Don't search the current box again.
	ld a, [wCurBox]
	and $f
	cp c
	jr z, .nextbox
	; Load the box.
	ld hl, Unknown_4a810
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; Number of monsters in the box
	ld a, [hl]
	and a
	jr z, .nextbox
	push bc
	push hl
	ld de, sBoxMons - sBoxCount
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push de
	ld de, sBoxMonOT - sBoxCount
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld d, a
.boxmon
	call CheckOwnMon
	jr nc, .nextboxmon
	; found!
	pop bc
	call CloseSRAM
	ret

.nextboxmon
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	call UpdateOTPointer
	dec d
	jr nz, .boxmon
	pop bc
.nextbox
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .box
	; not found
	call CloseSRAM
	and a
	ret

CheckOwnMon: ; 0x4a7ba
; Check if a Pokémon belongs to the player and is of a specific species.
; inputs:
; hl, pointer to PartyMonNSpecies
; bc, pointer to PartyMonNOT
; ScriptVar should contain the species we're looking for
; outputs:
; sets carry if monster matches species, ID, and OT name.

	push bc
	push hl
	push de
	ld d, b
	ld e, c
; check species

	ld a, [ScriptVar] ; species we're looking for
	ld b, [hl] ; species we have
	cp b
	jr nz, .notfound ; species doesn't match
; check ID number

	ld bc, PartyMon1ID - PartyMon1Species
	add hl, bc ; now hl points to ID number
	ld a, [PlayerID]
	cp [hl]
	jr nz, .notfound ; ID doesn't match
	inc hl
	ld a, [PlayerID + 1]
	cp [hl]
	jr nz, .notfound ; ID doesn't match
; check OT
; This only checks five characters, which is fine for the Japanese version,
; but in the English version the player name is 7 characters, so this is wrong.

	ld hl, PlayerName
	rept 4
	ld a, [de]
	cp [hl]
	jr nz, .notfound
	cp "@"
	jr z, .found ; reached end of string
	inc hl
	inc de
	endr
	ld a, [de]
	cp [hl]
	jr z, .found
.notfound
	pop de
	pop hl
	pop bc
	and a
	ret

.found
	pop de
	pop hl
	pop bc
	scf
	ret
; 0x4a810

Unknown_4a810: ; 4a810
	;  bank, address
	dbw $02, $a000
	dbw $02, $a450
	dbw $02, $a8a0
	dbw $02, $acf0
	dbw $02, $b140
	dbw $02, $b590
	dbw $02, $b9e0
	dbw $03, $a000
	dbw $03, $a450
	dbw $03, $a8a0
	dbw $03, $acf0
	dbw $03, $b140
	dbw $03, $b590
	dbw $03, $b9e0
; 4a83a

UpdateOTPointer: ; 0x4a83a
	push hl
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ret
; 0x4a843

Function4a843: ; 4a843
; Like CheckOwnMonAnywhere, but only check for species.
; OT/ID don't matter.

	ld a, [PartyCount]
	and a
	ret z
	ld d, a
	ld e, 0
	ld hl, PartyMon1Species
	ld bc, PartyMonOT
.asm_4a851
	call Function4a8dc
	ret c
	push bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	call Function4a91e
	dec d
	jr nz, .asm_4a851
	ld a, 1
	call GetSRAMBank
	ld a, [sBoxCount]
	and a
	jr z, .asm_4a888
	ld d, a
	ld hl, sBoxMon1Species
	ld bc, sBoxMonOT
.asm_4a873
	call Function4a8dc
	jr nc, .asm_4a87c
	call CloseSRAM
	ret

.asm_4a87c
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	call Function4a91e
	dec d
	jr nz, .asm_4a873
.asm_4a888
	call CloseSRAM
	ld c, 0
.asm_4a88d
	ld a, [wCurBox]
	and $f
	cp c
	jr z, .asm_4a8d1
	ld hl, Unknown_4a8f4
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and a
	jr z, .asm_4a8d1
	push bc
	push hl
	ld de, sBoxMons - sBoxCount
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push de
	ld de, sBoxMonOT - sBoxCount
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld d, a
.asm_4a8ba
	call Function4a8dc
	jr nc, .asm_4a8c4
	pop bc
	call CloseSRAM
	ret

.asm_4a8c4
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	call Function4a91e
	dec d
	jr nz, .asm_4a8ba
	pop bc
.asm_4a8d1
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .asm_4a88d
	call CloseSRAM
	and a
	ret
; 4a8dc

Function4a8dc: ; 4a8dc
	push bc
	push hl
	push de
	ld d, b
	ld e, c
	ld a, [ScriptVar]
	ld b, [hl]
	cp b
	jr nz, .no_match
	jr .match

.no_match
	pop de
	pop hl
	pop bc
	and a
	ret

.match
	pop de
	pop hl
	pop bc
	scf
	ret
; 4a8f4

Unknown_4a8f4: ; 4a8f4
	;  bank, address
	dbw $02, $a000
	dbw $02, $a450
	dbw $02, $a8a0
	dbw $02, $acf0
	dbw $02, $b140
	dbw $02, $b590
	dbw $02, $b9e0
	dbw $03, $a000
	dbw $03, $a450
	dbw $03, $a8a0
	dbw $03, $acf0
	dbw $03, $b140
	dbw $03, $b590
	dbw $03, $b9e0
; 4a91e

Function4a91e: ; 4a91e
	push hl
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ret
; 4a927

Function4a927: ; 4a927
	ld a, [ScriptVar]
	ld [CurItem], a
	ld hl, PCItems
	call CheckItem
	jr c, .asm_4a948
	ld a, [ScriptVar]
	ld [CurItem], a
	ld hl, NumItems
	call CheckItem
	jr c, .asm_4a948
	xor a
	ld [ScriptVar], a
	ret

.asm_4a948
	ld a, 1
	ld [ScriptVar], a
	ret
; 4a94e

Function4a94e: ; 4a94e
	call FadeToMenu
	ld a, $ff
	ld hl, DefaultFlypoint
	ld bc, $0003
	call ByteFill
	xor a
	ld [wd018], a
	ld [wd019], a
	ld b, $14
	call GetSGBLayout
	call Function32f9
	call Function4aa22
	jr c, .asm_4a985
	jr z, .asm_4a9a1
	jr .asm_4a97b

.asm_4a974
	call Function4aa25
	jr c, .asm_4a985
	jr z, .asm_4a9a1
.asm_4a97b
	call Function4ac58
	ld hl, wd019
	res 1, [hl]
	jr .asm_4a974

.asm_4a985
	ld a, [wd018]
	and a
	jr nz, .asm_4a990
	call Function4aba8
	jr c, .asm_4a974
.asm_4a990
	call Function2b3c
	ld hl, DefaultFlypoint
	ld a, $ff
	ld bc, $0003
	call ByteFill
	scf
	jr .asm_4a9af

.asm_4a9a1
	call Function4a9c3
	jr c, .asm_4a9b0
	call Function4a9d7
	jr c, .asm_4a974
	call Function2b3c
	and a
.asm_4a9af
	ret

.asm_4a9b0
	ld de, SFX_WRONG
	call PlaySFX
	ld hl, UnknownText_0x4a9be
	call PrintText
	jr .asm_4a974
; 4a9be

UnknownText_0x4a9be: ; 0x4a9be
	; Pick three #MON for battle.
	text_jump UnknownText_0x1c51d7
	db "@"
; 0x4a9c3

Function4a9c3: ; 4a9c3
	ld hl, DefaultFlypoint
	ld a, $ff
	cp [hl]
	jr z, .asm_4a9d5
	inc hl
	cp [hl]
	jr z, .asm_4a9d5
	inc hl
	cp [hl]
	jr z, .asm_4a9d5
	and a
	ret

.asm_4a9d5
	scf
	ret
; 4a9d7

Function4a9d7: ; 4a9d7
	ld a, [DefaultFlypoint]
	ld hl, PartyMonNicknames
	call GetNick
	ld h, d
	ld l, e
	ld de, EndFlypoint
	ld bc, $0006
	call CopyBytes
	ld a, [wd003]
	ld hl, PartyMonNicknames
	call GetNick
	ld h, d
	ld l, e
	ld de, wd00c
	ld bc, $0006
	call CopyBytes
	ld a, [wd004]
	ld hl, PartyMonNicknames
	call GetNick
	ld h, d
	ld l, e
	ld de, wd012
	ld bc, $0006
	call CopyBytes
	ld hl, UnknownText_0x4aa1d
	call PrintText
	call YesNoBox
	ret
; 4aa1d

UnknownText_0x4aa1d: ; 0x4aa1d
	;, @  and @ . Use these three?
	text_jump UnknownText_0x1c51f4
	db "@"
; 0x4aa22

Function4aa22: ; 4aa22
	call WhiteBGMap
Function4aa25: ; 4aa25
	callba Function5004f
	callba Function50405
	call Function4aad3
Function4aa34: ; 4aa34
	ld a, $9
	ld [PartyMenuActionText], a
	callba WritePartyMenuTilemap
	xor a
	ld [PartyMenuActionText], a
	callba PrintPartyMenuText
	call Function4aab6
	call WaitBGMap
	call Function32f9
	call DelayFrame
	call Function4ab1a
	jr z, .asm_4aa66
	push af
	call Function4aafb
	jr c, .asm_4aa67
	call Function4ab06
	jr c, .asm_4aa67
	pop af
.asm_4aa66
	ret

.asm_4aa67
	ld hl, wd019
	set 1, [hl]
	pop af
	ret
; 4aa6e

Function4aa6e: ; 4aa6e
	pop af
	ld de, SFX_WRONG
	call PlaySFX
	call WaitSFX
	jr Function4aa34
; 4aa7a

Function4aa7a: ; 4aa7a
	ld hl, DefaultFlypoint
	ld d, $3
.asm_4aa7f
	ld e, $6
	ld a, [hli]
	push de
	push hl
	cp $ff
	jr z, .asm_4aab3
	ld hl, wc314
	inc a
	ld d, a
.asm_4aa8d
	ld a, [hl]
	and a
	jr z, .asm_4aaa5
	cp d
	jr z, .asm_4aa9a
	jr .asm_4aaa5
	ld a, $3
	jr .asm_4aa9c

.asm_4aa9a
	ld a, $2
.asm_4aa9c
	push hl
	ld c, l
	ld b, h
	ld hl, $0002
	add hl, bc
	ld [hl], a
	pop hl
.asm_4aaa5
	ld bc, $0010
	add hl, bc
	dec e
	jr nz, .asm_4aa8d
	pop hl
	pop de
	dec d
	jr nz, .asm_4aa7f
	jr .asm_4aab5

.asm_4aab3
	pop hl
	pop de
.asm_4aab5
	ret
; 4aab6

Function4aab6: ; 4aab6
	ld hl, DefaultFlypoint
	ld d, $3
.asm_4aabb
	ld a, [hli]
	cp $ff
	jr z, .asm_4aad2
	push de
	push hl
	hlcoord 0, 1
	ld bc, $0028
	call AddNTimes
	ld [hl], $ec
	pop hl
	pop de
	dec d
	jr nz, .asm_4aabb
.asm_4aad2
	ret
; 4aad3

Function4aad3: ; 4aad3
	ld hl, PartyCount
	ld a, [hli]
	and a
	ret z
	ld c, a
	xor a
	ld [$ffb0], a
.asm_4aadd
	push bc
	push hl
	ld e, 0
	callba Function8e83f
	ld a, [$ffb0]
	inc a
	ld [$ffb0], a
	pop hl
	pop bc
	dec c
	jr nz, .asm_4aadd
	call Function4aa7a
	callba Function8cf69
	ret
; 4aafb

Function4aafb: ; 4aafb
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_4ab04
	and a
	ret

.asm_4ab04
	scf
	ret
; 4ab06

Function4ab06: ; 4ab06
	ld a, [CurPartyMon]
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1HP
	call AddNTimes
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr nz, .asm_4ab19
	scf
.asm_4ab19
	ret
; 4ab1a

Function4ab1a: ; 4ab1a
.asm_4ab1a
	ld a, $fb
	ld [wcfa8], a
	ld a, $26
	ld [wcfa7], a
	ld a, $2
	ld [wcfa4], a
	call Function4adf7
	call Function1bc9
	call Function4abc3
	jr c, .asm_4ab1a
	push af
	call Function4ab99
	call nc, Function1bee
	pop af
	bit 1, a
	jr nz, .asm_4ab6d
	ld a, [PartyCount]
	inc a
	ld b, a
	ld a, [wcfa9]
	ld [wd0d8], a
	cp b
	jr z, .asm_4ab7e
	ld a, [wcfa9]
	dec a
	ld [CurPartyMon], a
	ld c, a
	ld b, $0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	ld [CurPartySpecies], a
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	call WaitSFX
	ld a, $1
	and a
	ret

.asm_4ab6d
	ld a, [wcfa9]
	ld [wd0d8], a
.asm_4ab73
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	call WaitSFX
	scf
	ret

.asm_4ab7e
	ld a, $1
	ld [wd018], a
	ld a, [wcfaa]
	cp $2
	jr z, .asm_4ab73
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	call WaitSFX
	xor a
	ld [wd018], a
	and a
	ret
; 4ab99

Function4ab99: ; 4ab99
	bit 1, a
	jr z, .asm_4aba6
	ld a, [DefaultFlypoint]
	cp $ff
	jr z, .asm_4aba6
	scf
	ret

.asm_4aba6
	and a
	ret
; 4aba8

Function4aba8: ; 4aba8
	ld hl, wd004
	ld a, [hl]
	cp $ff
	jr nz, .asm_4abbe
	dec hl
	ld a, [hl]
	cp $ff
	jr nz, .asm_4abbe
	dec hl
	ld a, [hl]
	cp $ff
	jr nz, .asm_4abbe
	and a
	ret

.asm_4abbe
	ld a, $ff
	ld [hl], a
	scf
	ret
; 4abc3

Function4abc3: ; 4abc3
	bit 3, a
	jr z, .asm_4abd5
	ld a, [PartyCount]
	inc a
	ld [wcfa9], a
	ld a, $1
	ld [wcfaa], a
	jr .asm_4ac29

.asm_4abd5
	bit 6, a
	jr z, .asm_4abeb
	ld a, [wcfa9]
	ld [wcfa9], a
	and a
	jr nz, .asm_4ac29
	ld a, [PartyCount]
	inc a
	ld [wcfa9], a
	jr .asm_4ac29

.asm_4abeb
	bit 7, a
	jr z, .asm_4ac08
	ld a, [wcfa9]
	ld [wcfa9], a
	ld a, [PartyCount]
	inc a
	inc a
	ld b, a
	ld a, [wcfa9]
	cp b
	jr nz, .asm_4ac29
	ld a, $1
	ld [wcfa9], a
	jr .asm_4ac29

.asm_4ac08
	bit 4, a
	jr nz, .asm_4ac10
	bit 5, a
	jr z, .asm_4ac56
.asm_4ac10
	ld a, [wcfa9]
	ld b, a
	ld a, [PartyCount]
	inc a
	cp b
	jr nz, .asm_4ac29
	ld a, [wcfaa]
	cp $1
	jr z, .asm_4ac26
	ld a, $1
	jr .asm_4ac29

.asm_4ac26
	ld [wcfaa], a
.asm_4ac29
	hlcoord 0, 1
	ld bc, $0d01
	call ClearBox
	call Function4aab6
	ld a, [PartyCount]
	hlcoord 6, 1
.asm_4ac3b
	ld bc, $0028
	add hl, bc
	dec a
	jr nz, .asm_4ac3b
	ld [hl], $7f
	ld a, [wcfa9]
	ld b, a
	ld a, [PartyCount]
	inc a
	cp b
	jr z, .asm_4ac54
	ld a, $1
	ld [wcfaa], a
.asm_4ac54
	scf
	ret

.asm_4ac56
	and a
	ret
; 4ac58

Function4ac58: ; 4ac58
	ld bc, $0212
	hlcoord 1, 15
	call ClearBox
	callba Function8ea4a
	ld hl, MenuDataHeader_0x4aca2
	call LoadMenuDataHeader
	ld hl, wd019
	bit 1, [hl]
	jr z, .asm_4ac89
	hlcoord 11, 13
	ld b, $3
	ld c, $7
	call TextBox
	hlcoord 13, 14
	ld de, String_4ada7
	call PlaceString
	jr .asm_4ac96

.asm_4ac89
	hlcoord 11, 9
	ld b, $7
	ld c, $7
	call TextBox
	call Function4ad68
.asm_4ac96
	ld a, $1
	ld [hBGMapMode], a
	call Function4acaa
	call Function1c07 ;unload top menu on menu stack
	and a
	ret
; 4aca2

MenuDataHeader_0x4aca2: ; 0x4aca2
	db $40 ; flags
	db 09, 11 ; start coords
	db 17, 19 ; end coords
	dw NULL
	db 1 ; default option
; 0x4acaa

Function4acaa: ; 4acaa
.asm_4acaa
	ld a, $a0
	ld [wcf91], a
	ld a, [wd019]
	bit 1, a
	jr z, .asm_4acc2
	ld a, $2
	ld [wcf92], a
	ld a, $c
	ld [wcf82], a
	jr .asm_4accc

.asm_4acc2
	ld a, $4
	ld [wcf92], a
	ld a, $8
	ld [wcf82], a
.asm_4accc
	ld a, $b
	ld [wcf83], a
	ld a, $1
	ld [wcf88], a
	call Function1c10
	ld hl, wcfa5
	set 6, [hl]
	call Function1bc9
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	ld a, [hJoyPressed]
	bit 0, a
	jr nz, .asm_4acf4
	bit 1, a
	jr nz, .asm_4acf3
	jr .asm_4acaa

.asm_4acf3
	ret

.asm_4acf4
	ld a, [wd019]
	bit 1, a
	jr nz, .asm_4ad0e
	ld a, [wcfa9]
	cp $1
	jr z, Function4ad17
	cp $2
	jp z, Function4ad56
	cp $3
	jp z, Function4ad60
	jr .asm_4acf3

.asm_4ad0e
	ld a, [wcfa9]
	cp $1
	jr z, Function4ad56
	jr .asm_4acf3

Function4ad17: ; 4ad17
	call Function4adb2
	jr z, .asm_4ad4a
	ld hl, DefaultFlypoint
	ld a, $ff
	cp [hl]
	jr z, .asm_4ad39
	inc hl
	cp [hl]
	jr z, .asm_4ad39
	inc hl
	cp [hl]
	jr z, .asm_4ad39
	ld de, SFX_WRONG
	call WaitPlaySFX
	ld hl, UnknownText_0x4ad51
	call PrintText
	ret

.asm_4ad39
	ld a, [CurPartyMon]
	ld [hl], a
	call Function4a9c3
	ret c
	ld a, [wd019]
	set 0, a
	ld [wd019], a
	ret

.asm_4ad4a
	ld a, $ff
	ld [hl], a
	call Function4adc2
	ret

UnknownText_0x4ad51: ; 0x4ad51
	; Only three #MON may enter.
	text_jump UnknownText_0x1c521c
	db "@"
; 0x4ad56

Function4ad56: ; 4ad56
	callba OpenPartyStats
	call Function3200
	ret
; 4ad60

Function4ad60: ; 4ad60
	callba Function12fba
	ret
; 4ad67

Function4ad67: ; 4ad67
	ret
; 4ad68

Function4ad68: ; 4ad68
	hlcoord 13, 12
	ld de, String_4ad88
	call PlaceString
	call Function4adb2
	jr c, .asm_4ad7e
	hlcoord 13, 10
	ld de, String_4ada0
	jr .asm_4ad84

.asm_4ad7e
	hlcoord 13, 10
	ld de, String_4ad9a
.asm_4ad84
	call PlaceString
	ret
; 4ad88

String_4ad88: ; 4ad88
	db   "つよさをみる"
	next "つかえるわざ"
	next "もどる@"
; 4ad9a

String_4ad9a: ; 4ad9a
	db   "さんかする@"
; 4ada0

String_4ada0: ; 4ada0
	db   "さんかしない@"
; 4ada7

String_4ada7: ; 4ada7
	db   "つよさをみる"
	next "もどる@" ; BACK
; 4adb2

Function4adb2: ; 4adb2
	ld hl, DefaultFlypoint
	ld a, [CurPartyMon]
	cp [hl]
	ret z
	inc hl
	cp [hl]
	ret z
	inc hl
	cp [hl]
	ret z
	scf
	ret
; 4adc2

Function4adc2: ; 4adc2
	ld a, [DefaultFlypoint]
	cp $ff
	jr nz, .asm_4ade5
	ld a, [wd003]
	cp $ff
	jr nz, .asm_4addd
	ld a, [wd004]
	ld [DefaultFlypoint], a
	ld a, $ff
	ld [wd004], a
	jr .asm_4ade5

.asm_4addd
	ld [DefaultFlypoint], a
	ld a, $ff
	ld [wd003], a
.asm_4ade5
	ld a, [wd003]
	cp $ff
	ret nz
	ld b, a
	ld a, [wd004]
	ld [wd003], a
	ld a, b
	ld [wd004], a
	ret
; 4adf7

Function4adf7: ; 4adf7
	ld a, [wd019]
	bit 0, a
	ret z
	ld a, [PartyCount]
	inc a
	ld [wcfa9], a
	ld a, $1
	ld [wcfaa], a
	ld a, [wd019]
	res 0, a
	ld [wd019], a
	ret
; 4ae12

Function4ae12: ; 4ae12
	call Function4ae1f
	ld a, $0
	jr c, .asm_4ae1b
	ld a, $1
.asm_4ae1b
	ld [ScriptVar], a
	ret
; 4ae1f

Function4ae1f: ; 4ae1f
	ld bc, $0e07
	push bc
	ld hl, YesNoMenuDataHeader
	call Function1d3c
	pop bc
	ld a, b
	ld [wcf83], a
	add $5
	ld [wcf85], a
	ld a, c
	ld [wcf82], a
	add $4
	ld [wcf84], a
	call Function1c00
	call Function1d81
	push af
	ld c, $f
	call DelayFrames
	call Function4ae5e
	pop af
	jr c, .asm_4ae57
	ld a, [wcfa9]
	cp $2
	jr z, .asm_4ae57
	and a
	ret

.asm_4ae57
	ld a, $2
	ld [wcfa9], a
	scf
	ret
; 4ae5e

Function4ae5e: ; 4ae5e
	ld a, [hOAMUpdate]
	push af
	call Function1c07 ;unload top menu on menu stack
	call Function1ad2
	xor a
	ld [hOAMUpdate], a
	call DelayFrame
	ld a, $1
	ld [hOAMUpdate], a
	call Function321c
	pop af
	ld [hOAMUpdate], a
	ret
; 4ae78

SECTION "bank13", ROMX, BANK[$13]

Function4c000:: ; 4c000
	hlcoord 0, 0
	ld de, AttrMap
	ld b, $12
.asm_4c008
	push bc
	ld c, $14
.asm_4c00b
	call ReadGymSpinnerPals
	jr c, .next_maybe
	ld a, [hl]
	push hl
	srl a
	jr c, .asm_4c021
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [TilesetPalettes + 1]
	adc $0
	ld h, a
	ld a, [hl]
	and $f
	jr .asm_4c031

.asm_4c021
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [TilesetPalettes + 1]
	adc $0
	ld h, a
	ld a, [hl]
	swap a
	and $f
.asm_4c031
	pop hl
	ld [de], a
	res 7, [hl]
	inc hl
	inc de
.next_maybe
	dec c
	jr nz, .asm_4c00b
	pop bc
	dec b
	jr nz, .asm_4c008
	ret
; 4c03f

Function4c03f:: ; 4c03f
	ld hl, BGMapBuffer
	ld de, BGMapPalBuffer
.asm_4c045
	call ReadGymSpinnerPals
	jr c, .next_maybe
	ld a, [hl]
	push hl
	srl a
	jr c, .asm_4c05b
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [TilesetPalettes + 1]
	adc $0
	ld h, a
	ld a, [hl]
	and $f
	jr .asm_4c06b

.asm_4c05b
	ld hl, TilesetPalettes
	add [hl]
	ld l, a
	ld a, [TilesetPalettes + 1]
	adc $0
	ld h, a
	ld a, [hl]
	swap a
	and $f
.asm_4c06b
	pop hl
	ld [de], a
	res 7, [hl]
	inc hl
	inc de
.next_maybe
	dec c
	jr nz, .asm_4c045
	ret

PUSHS
SECTION "gym spinner pals", ROM0

ReadGymSpinnerPals:
; this is a really stupid hack that no one should emulate

	ld a, [wTileset]
	cp 17
	jr nz, .nope
	ld a, [hli]
	cp $84
	jr z, .ne
	cp $87
	jr z, .sw
	cp $85
	jr z, .se
	cp $86
	jr z, .nw
	dec hl
.nope
	xor a
	ret

.se
.ne
.right
	ld a, 8 + 6
	jr .ok

.nw
	cp [hl]
	jr z, .left
.up
	ld a, 8 + 1
	jr .ok

.left
	ld a, 8 + 3
	jr .ok

.sw
	cp [hl]
	jr z, .left
.down
	ld a, 8 + 4
;	jr .ok

.ok
	dec hl
	res 7, [hl]
	inc hl
	res 7, [hl]
	inc hl
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	scf
	ret

POPS
INCLUDE "tilesets/palette_maps.asm"

TileCollisionTable:: ; 4ce1f
; 00 land
; 01 water
; 0f wall
; 11 talkable water
; 1f talkable wall

	db $00, $00, $00, $00, $00, $00, $00, $0f
	db $00, $00, $00, $00, $00, $00, $00, $0f
	db $00, $00, $1f, $00, $00, $1f, $00, $00
	db $00, $00, $1f, $00, $00, $1f, $00, $00
	db $01, $01, $11, $00, $11, $01, $01, $0f
	db $01, $01, $11, $00, $11, $01, $01, $0f
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $0f, $00, $00, $00, $00, $00
	db $00, $00, $0f, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $0f, $0f, $0f, $0f, $0f, $00, $00, $00
	db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
	db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $0f
; 4cf1f

Function4cf1f:: ; 4cf1f
	ld a, $0
	call Function4cf34
	ld a, $1
	call Function4cf34
	ld a, $2
	call Function4cf34
	ld a, $3
	call Function4cf34
	ret
; 4cf34

Function4cf34: ; 4cf34
	call GetSRAMBank
	ld hl, $a000
	ld bc, $2000
	xor a
	call ByteFill
	call CloseSRAM
	ret
; 4cf45

Function4cf45: ; 4cf45 (13:4f45)
	ld a, [hCGB] ; $ff00+$e6
	and a
	jp z, WaitBGMap
	ld a, [hBGMapMode] ; $ff00+$d4
	push af
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
.asm_4cf57
	ld a, [rLY] ; $ff00+$44
	cp $60
	jr c, .asm_4cf57
	di
	ld a, $1
	ld [rVBK], a ; $ff00+$4f
	hlcoord 0, 0, AttrMap
	call Function4cf80
	ld a, $0
	ld [rVBK], a ; $ff00+$4f
	hlcoord 0, 0
	call Function4cf80
.asm_4cf72
	ld a, [rLY] ; $ff00+$44
	cp $60
	jr c, .asm_4cf72
	ei
	pop af
	ld [$ffde], a
	pop af
	ld [hBGMapMode], a ; $ff00+$d4
	ret

Function4cf80: ; 4cf80 (13:4f80)
	ld [hSPBuffer], sp ; $ffd9
	ld sp, hl
	ld a, [$ffd7]
	ld h, a
	ld l, $0
	ld a, $12
	ld [$ffd3], a
	ld b, $2
	ld c, $41
.asm_4cf91
	pop de
.asm_4cf92
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cf92
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cf9b
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cf9b
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfa4
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfa4
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfad
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfad
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfb6
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfb6
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfbf
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfbf
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfc8
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfc8
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfd1
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfd1
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfda
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfda
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4cfe3
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4cfe3
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld de, $c
	add hl, de
	ld a, [$ffd3]
	dec a
	ld [$ffd3], a
	jr nz, .asm_4cf91
	ld a, [hSPBuffer] ; $ff00+$d9
	ld l, a
	ld a, [$ffda]
	ld h, a
	ld sp, hl
	ret

Function4cffe:: ; 4cffe
	ld a, $1
	call GetSRAMBank
	ld a, [$a008]
	ld b, a
	ld a, [$ad0f]
	ld c, a
	call CloseSRAM
	ld a, b
	cp $63
	jr nz, .asm_4d01b
	ld a, c
	cp $7f
	jr nz, .asm_4d01b
	ld c, $1
	ret

.asm_4d01b
	ld c, $0
	ret
; 4d01e

INCLUDE "engine/map_triggers.asm"

Function4d15b:: ; 4d15b
	ld hl, wc608
	ld a, [wd196]
	and a
	jr z, .asm_4d168
	ld bc, $0030
	add hl, bc
.asm_4d168
	ld a, [wd197]
	and a
	jr z, .asm_4d170
	inc hl
	inc hl
.asm_4d170
	ld de, TileMap
	ld b, SCREEN_HEIGHT
.asm_4d175
	ld c, SCREEN_WIDTH
.asm_4d177
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_4d177
	ld a, l
	add $4
	ld l, a
	jr nc, .asm_4d184
	inc h
.asm_4d184
	dec b
	jr nz, .asm_4d175
	ret
; 4d188

Function4d188: ; 4d188
	ld a, [hCGB]
	and a
	jp z, WaitBGMap
	ld a, [wc2ce]
	cp $0
	jp z, WaitBGMap
	ld a, [hBGMapMode]
	push af
	xor a
	ld [hBGMapMode], a
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a
.asm_4d1a2
	ld a, [rLY]
	cp $8f
	jr c, .asm_4d1a2
	di
	ld a, $1
	ld [rVBK], a
	hlcoord 0, 0, AttrMap
	call Function4d1cb
	ld a, $0
	ld [rVBK], a
	hlcoord 0, 0
	call Function4d1cb
.asm_4d1bd
	ld a, [rLY]
	cp $8f
	jr c, .asm_4d1bd
	ei
	pop af
	ld [$ffde], a
	pop af
	ld [hBGMapMode], a
	ret
; 4d1cb

Function4d1cb: ; 4d1cb
	ld [hSPBuffer], sp
	ld sp, hl
	ld a, [$ffd7]
	ld h, a
	ld l, $0
	ld a, $12
	ld [$ffd3], a
	ld b, $2
	ld c, $41
.asm_4d1dc
	pop de
.asm_4d1dd
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1dd
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1e6
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1e6
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1ef
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1ef
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d1f8
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d1f8
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d201
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d201
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d20a
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d20a
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d213
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d213
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d21c
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d21c
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d225
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d225
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	pop de
.asm_4d22e
	ld a, [$ff00+c]
	and b
	jr nz, .asm_4d22e
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld de, $000c
	add hl, de
	ld a, [$ffd3]
	dec a
	ld [$ffd3], a
	jr nz, .asm_4d1dc
	ld a, [hSPBuffer]
	ld l, a
	ld a, [$ffda]
	ld h, a
	ld sp, hl
	ret
; 4d249

Shrink1Pic: ; 4d249
INCBIN "gfx/shrink1.2bpp.lz"

Shrink2Pic: ; 4d2d9
INCBIN "gfx/shrink2.2bpp.lz"
; 4d319

Function4d319: ; 4d319
	ld a, [wcfa9]
	dec a
	ld [CurPartyMon], a
	call LowVolume
	predef StatsScreenInit
	ld a, [CurPartyMon]
	inc a
	ld [wcfa9], a
	call ClearScreen
	call WhiteBGMap
	call MaxVolume
	callba Function28ef8
	callba Function4d354
	callba Function16d673
	callba Function28eff
	call Function3200
	ret
; 4d354

Function4d354: ; 4d354
	call WaitBGMap
	call Function3200
	ret
; 4d35b

Function4d35b: ; 4d35b
	ld h, d
	ld l, e
	push bc
	push hl
	call Function4d37e
	pop hl
	pop bc
	ld de, AttrMap - TileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	ld a, $7
.asm_4d36e
	push bc
	push hl
.asm_4d370
	ld [hli], a
	dec c
	jr nz, .asm_4d370
	pop hl
	ld de, $0014
	add hl, de
	pop bc
	dec b
	jr nz, .asm_4d36e
	ret
; 4d37e

Function4d37e: ; 4d37e
	push hl
	ld a, $76
	ld [hli], a
	inc a
	call Function4d3ab
	inc a
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
.asm_4d38d
	push hl
	ld a, $79
	ld [hli], a
	ld a, $7f
	call Function4d3ab
	ld [hl], $7a
	pop hl
	ld de, $0014
	add hl, de
	dec b
	jr nz, .asm_4d38d
	ld a, $7b
	ld [hli], a
	ld a, $7c
	call Function4d3ab
	ld [hl], $7d
	ret
; 4d3ab

Function4d3ab: ; 4d3ab
	ld d, c
.asm_4d3ac
	ld [hli], a
	dec d
	jr nz, .asm_4d3ac
	ret
; 4d3b1

Function4d3b1: ; 4d3b1
	callba Function8000
	ld b, $8
	call GetSGBLayout
	call Functione51
	call Functione5f
	ld de, MUSIC_MAIN_MENU
	call PlayMusic
	ld hl, UnknownText_0x4d408
	call PrintText
	ld hl, MenuDataHeader_0x4d40d
	call Function1d3c
	call Function1d81
	ret c
	ld a, [wcfa9]
	cp $1
	ret z
	call Function4d41e
	jr c, .asm_4d3f7
	ld a, $0
	call GetSRAMBank
	ld a, $80
	ld [$ac60], a
	call CloseSRAM
	ld hl, UnknownText_0x4d3fe
	call PrintText
	ret

.asm_4d3f7
	ld hl, UnknownText_0x4d403
	call PrintText
	ret
; 4d3fe

UnknownText_0x4d3fe: ; 0x4d3fe
	; Password OK. Select CONTINUE & reset settings.
	text_jump UnknownText_0x1c55db
	db "@"
; 0x4d403

UnknownText_0x4d403: ; 0x4d403
	; Wrong password!
	text_jump UnknownText_0x1c560b
	db "@"
; 0x4d408

UnknownText_0x4d408: ; 0x4d408
	; Reset the clock?
	text_jump UnknownText_0x1c561c
	db "@"
; 0x4d40d

MenuDataHeader_0x4d40d: ; 0x4d40d
	db $00 ; flags
	db 07, 14 ; start coords
	db 11, 19 ; end coords
	dw MenuData2_0x4d415
	db 1 ; default option
; 0x4d415

MenuData2_0x4d415: ; 0x4d415
	db $c0 ; flags
	db 2 ; items
	db "NON@"
	db "OUI@"
; 0x4d41e

Function4d41e: ; 4d41e
	call Function4d50f
	push de
	ld hl, StringBuffer2
	ld bc, $0005
	xor a
	call ByteFill
	ld a, $4
	ld [StringBuffer2 + 5], a
	ld hl, UnknownText_0x4d463
	call PrintText
.asm_4d437
	call Function4d468
.asm_4d43a
	call Functiona57
	ld a, [$ffa9]
	ld b, a
	and $1
	jr nz, .asm_4d453
	ld a, b
	and $f0
	jr z, .asm_4d43a
	call Function4d490
	ld c, $3
	call DelayFrames
	jr .asm_4d437

.asm_4d453
	call Function4d4e0
	pop de
	ld a, e
	cp l
	jr nz, .asm_4d461
	ld a, d
	cp h
	jr nz, .asm_4d461
	and a
	ret

.asm_4d461
	scf
	ret
; 4d463

UnknownText_0x4d463: ; 0x4d463
	; Please enter the password.
	text_jump UnknownText_0x1c562e
	db "@"
; 0x4d468

Function4d468: ; 4d468
	hlcoord 14, 15
	ld de, StringBuffer2
	ld c, $5
.asm_4d470
	ld a, [de]
	add $f6
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_4d470
	hlcoord 14, 16
	ld bc, $0005
	ld a, $7f
	call ByteFill
	hlcoord 14, 16
	ld a, [StringBuffer2 + 5]
	ld e, a
	ld d, $0
	add hl, de
	ld [hl], $61
	ret
; 4d490

Function4d490: ; 4d490
	ld a, b
	and $20
	jr nz, .asm_4d4a5
	ld a, b
	and $10
	jr nz, .asm_4d4af
	ld a, b
	and $40
	jr nz, .asm_4d4ba
	ld a, b
	and $80
	jr nz, .asm_4d4c8
	ret

.asm_4d4a5
	ld a, [StringBuffer2 + 5]
	and a
	ret z
	dec a
	ld [StringBuffer2 + 5], a
	ret

.asm_4d4af
	ld a, [StringBuffer2 + 5]
	cp $4
	ret z
	inc a
	ld [StringBuffer2 + 5], a
	ret

.asm_4d4ba
	call Function4d4d5
	ld a, [hl]
	cp $9
	jr z, .asm_4d4c5
	inc a
	ld [hl], a
	ret

.asm_4d4c5
	ld [hl], $0
	ret

.asm_4d4c8
	call Function4d4d5
	ld a, [hl]
	and a
	jr z, .asm_4d4d2
	dec a
	ld [hl], a
	ret

.asm_4d4d2
	ld [hl], $9
	ret
; 4d4d5

Function4d4d5: ; 4d4d5
	ld a, [StringBuffer2 + 5]
	ld e, a
	ld d, $0
	ld hl, StringBuffer2
	add hl, de
	ret
; 4d4e0

Function4d4e0: ; 4d4e0
	ld hl, 0
	ld de, StringBuffer2 + 4
	ld bc, 1
	call Function4d501
	ld bc, 10
	call Function4d501
	ld bc, 100
	call Function4d501
	ld bc, 1000
	call Function4d501
	ld bc, 10000
Function4d501: ; 4d501
	ld a, [de]
	dec de
	push hl
	ld hl, 0
	call AddNTimes
	ld c, l
	ld b, h
	pop hl
	add hl, bc
	ret
; 4d50f

Function4d50f: ; 4d50f
	ld a, $1
	call GetSRAMBank
	ld de, $0000
	ld hl, $a009
	ld c, $2
	call Function4d533
	ld hl, $a00b
	ld c, $5
	call Function4d53e
	ld hl, $a3dc
	ld c, $3
	call Function4d533
	call CloseSRAM
	ret
; 4d533

Function4d533: ; 4d533
.asm_4d533
	ld a, [hli]
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec c
	jr nz, .asm_4d533
	ret
; 4d53e

Function4d53e: ; 4d53e
.asm_4d53e
	ld a, [hli]
	cp "@"
	ret z
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec c
	jr nz, .asm_4d53e
	ret
; 4d54c

Function4d54c: ; 4d54c
	callba Function8000
	ld b, $8
	call GetSGBLayout
	call Functione51
	call Functione5f
	ld de, MUSIC_MAIN_MENU
	call PlayMusic
	ld hl, UnknownText_0x4d580
	call PrintText
	ld hl, MenuDataHeader_0x4d585
	call Function1d3c
	call Function1d81
	ret c
	ld a, [wcfa9]
	cp $1
	ret z
	callba Function4cf1f
	ret
; 4d580

UnknownText_0x4d580: ; 0x4d580
	; Clear all save data?
	text_jump UnknownText_0x1c564a
	db "@"
; 0x4d585

MenuDataHeader_0x4d585: ; 0x4d585
	db $00 ; flags
	db 07, 14 ; start coords
	db 11, 19 ; end coords
	dw MenuData2_0x4d58d
	db 1 ; default option
; 0x4d58d

MenuData2_0x4d58d: ; 0x4d58d
	db $c0 ; flags
	db 2 ; items
	db "NON@"
	db "OUI@"
; 0x4d596

Tilesets::
INCLUDE "tilesets/tileset_headers.asm"

FlagPredef: ; 4d7c1
; Perform action b on flag c in flag array hl.
; If checking a flag, check flag array d:hl unless d is 0.
; For longer flag arrays, see FlagAction.

	push hl
	push bc
; Divide by 8 to get the byte we want.

	push bc
	srl c
	srl c
	srl c
	ld b, 0
	add hl, bc
	pop bc
; Which bit we want from the byte

	ld a, c
	and 7
	ld c, a ; c equals bit number
; Shift left until we can mask the bit

	ld a, 1
	jr z, .shifted
.shift
	add a
	dec c
	jr nz, .shift
.shifted
	ld c, a ; a&c = only the target bit set
; What are we doing to this flag?

	dec b
	jr z, .set ; 1
	dec b
	jr z, .check ; 2
.reset
	ld a, c
	cpl
	and [hl]
	ld [hl], a
	jr .done

.set
	ld a, [hl]
	or c
	ld [hl], a
	jr .done

.check
	ld a, d
	cp 0
	jr nz, .farcheck
	ld a, [hl]
	and c
	jr .done ;sets z flag if flag if off, nz if flag is on
.farcheck
	call GetFarByte
	and c
.done
	pop bc
	pop hl
	ld c, a ;puts the state of the flag in c
	ret
; 4d7fd

Function4d7fd: ; 4d7fd
	ld a, [wc702]
	ld hl, wc72f
	ld de, VTiles2
	push de
	push af
	predef GetUnownLetter
	pop af
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call GetBaseData
	pop de
	predef Function5108b
	ret
; 4d81e

Function4d81e: ; 4d81e
	ld a, [wc702]
	call IsAPokemon
	ret c
	callba Function29549
	ld a, [wc702]
	ld [CurPartySpecies], a
	ld a, [wc72f]
	ld [TempMonDVs], a
	ld a, [wc730]
	ld [TempMonDVs + 1], a
	ld b, $1a
	call GetSGBLayout
	ld a, $e4
	call DmgToCgbBGPals
	callba Function294c0
	ld a, [wc702]
	ld [CurPartySpecies], a
	hlcoord 7, 2
	ld d, $0
	ld e, $3
	predef Functiond008e
	ret
; 4d860

CheckPokerus: ; 4d860
; Return carry if a monster in your party has Pokerus
; Get number of monsters to iterate over

	ld a, [PartyCount]
	and a
	jr z, .NoPokerus
	ld b, a
; Check each monster in the party for Pokerus

	ld hl, PartyMon1PokerusStatus
	ld de, PartyMon2 - PartyMon1
.Check
	ld a, [hl]
	and $0f ; only the bottom nybble is used
	jr nz, .HasPokerus
; Next PartyMon

	add hl, de
	dec b
	jr nz, .Check
.NoPokerus
	and a
	ret

.HasPokerus
	scf
	ret
; 4d87a

Function4d87a: ; 4d87a
	xor a
	ld [ScriptVar], a
	ld [wd265], a
	ld a, [PartyCount]
	and a
	ret z
	ld d, a
	ld hl, PartyMon1ID
	ld bc, PartySpecies
.asm_4d88d
	ld a, [bc]
	inc bc
	cp EGG
	call nz, Function4d939
	push bc
	ld bc, PartyMon2 - PartyMon1
	add hl, bc
	pop bc
	dec d
	jr nz, .asm_4d88d
	ld a, $1
	call GetSRAMBank
	ld a, [sBoxCount]
	and a
	jr z, .asm_4d8c8
	ld d, a
	ld hl, sBoxMon1ID
	ld bc, sBoxSpecies
.asm_4d8af
	ld a, [bc]
	inc bc
	cp EGG
	jr z, .asm_4d8bf
	call Function4d939
	jr nc, .asm_4d8bf
	ld a, $1
	ld [wd265], a
.asm_4d8bf
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	dec d
	jr nz, .asm_4d8af
.asm_4d8c8
	call CloseSRAM
	ld c, $0
.asm_4d8cd
	ld a, [wCurBox]
	and $f
	cp c
	jr z, .asm_4d90b
	ld hl, Unknown_4d99f
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	call GetSRAMBank
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and a
	jr z, .asm_4d90b
	push bc
	ld b, h
	ld c, l
	inc bc
	ld de, $001c
	add hl, de
	ld d, a
.asm_4d8f1
	ld a, [bc]
	inc bc
	cp EGG
	jr z, .asm_4d901
	call Function4d939
	jr nc, .asm_4d901
	ld a, $1
	ld [wd265], a
.asm_4d901
	push bc
	ld bc, sBoxMon2 - sBoxMon1
	add hl, bc
	pop bc
	dec d
	jr nz, .asm_4d8f1
	pop bc
.asm_4d90b
	inc c
	ld a, c
	cp NUM_BOXES
	jr c, .asm_4d8cd
	call CloseSRAM
	ld a, [ScriptVar]
	and a
	ret z
	callba Function1060cd
	ld a, [wd265]
	and a
	push af
	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName
	ld hl, UnknownText_0x4d9c9
	pop af
	jr z, .asm_4d936
	ld hl, UnknownText_0x4d9ce
.asm_4d936
	jp PrintText
; 4d939

Function4d939: ; 4d939
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, Buffer1
	ld bc, $8205
	call PrintNum
	ld hl, DefaultFlypoint
	ld de, wdc9f
	ld bc, $8205
	call PrintNum
	ld b, $5
	ld c, $0
	ld hl, EndFlypoint
	ld de, wd1ee
.asm_4d95d
	ld a, [de]
	cp [hl]
	jr nz, .asm_4d967
	dec de
	dec hl
	inc c
	dec b
	jr nz, .asm_4d95d
.asm_4d967
	pop hl
	push hl
	ld de, -6
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	push af
	ld a, c
	ld b, $1
	cp $5
	jr z, .asm_4d984
	ld b, $2
	cp $3
	jr nc, .asm_4d984
	ld b, $3
	cp $2
	jr nz, .asm_4d99b
.asm_4d984
	inc b
	ld a, [ScriptVar]
	and a
	jr z, .asm_4d98e
	cp b
	jr c, .asm_4d99b
.asm_4d98e
	dec b
	ld a, b
	ld [ScriptVar], a
	pop bc
	ld a, b
	ld [CurPartySpecies], a
	pop bc
	scf
	ret

.asm_4d99b
	pop bc
	pop bc
	and a
	ret
; 4d99f

Unknown_4d99f: ; 4d99f
	;  bank, address
	dbw $02, $a000
	dbw $02, $a450
	dbw $02, $a8a0
	dbw $02, $acf0
	dbw $02, $b140
	dbw $02, $b590
	dbw $02, $b9e0
	dbw $03, $a000
	dbw $03, $a450
	dbw $03, $a8a0
	dbw $03, $acf0
	dbw $03, $b140
	dbw $03, $b590
	dbw $03, $b9e0
; 4d9c9

UnknownText_0x4d9c9: ; 0x4d9c9
	; Congratulations! We have a match with the ID number of @  in your party.
	text_jump UnknownText_0x1c1261
	db "@"
; 0x4d9ce

UnknownText_0x4d9ce: ; 0x4d9ce
	; Congratulations! We have a match with the ID number of @  in your PC BOX.
	text_jump UnknownText_0x1c12ae
	db "@"
; 0x4d9d3

Function4d9d3: ; 4d9d3
	ld hl, StringBuffer3
	ld de, wdc9f
	ld bc, $8205
	call PrintNum
	ld a, $50
	ld [StringBuffer3 + 5], a
	ret
; 4d9e5

Function4d9e5: ; 4d9e5 ;insert mon into party if space, otherwise into PC box in top slot. mon is in wdf9c (Contest mon).
	;return 0 in scriptvar if mon went to party, 1 if they went to box and 2 if no mon was caught
	ld a, [wdf9c] ;mon species
	and a
	jp z, Function4db35 ;if not 0, continue, else return no mon
	ld [CurPartySpecies], a ;load into cur species variables
	ld [CurSpecies], a
	call GetBaseData ;load the species base data into ram
	ld hl, PartyCount
	ld a, [hl] ;place partycount into a
	cp $6
	jp nc, Function4daa3 ;if party is full, jump
	inc a
	ld [hl], a ;increment by 1 and put it back
	ld c, a
	ld b, $0
	add hl, bc ;advance partycount by new number of mons to get correct partyspecies slot
	ld a, [wdf9c]; load species again
	ld [hli], a ;place in party species
	ld [CurSpecies], a
	ld a, $ff
	ld [hl], a ;and end of paty space after it
	ld hl, PartyMon1Species
	ld a, [PartyCount]
	dec a
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes ;go down to correct party storage location (over species)
	ld d, h
	ld e, l
	ld hl, wdf9c
	ld bc, PartyMon2 - PartyMon1
	call CopyBytes ;copy mon details into the party data
	ld a, [PartyCount]
	dec a
	ld hl, PartyMonOT
	call SkipNames; go to correct space for OT
	ld d, h
	ld e, l
	ld hl, PlayerName ;load in player name
	call CopyBytes
	ld a, [CurPartySpecies]
	ld [wd265], a ;load name into another variable
	call GetPokemonName ;put that pokemons name in string buffer 1
	ld hl, StringBuffer1
	ld de, wd050
	ld bc, $000b
	call CopyBytes ;copy into wd050
	ld a, [PartyCount]
	dec a
	ld [CurPartyMon], a ;load this slot into curpartymon
	xor a
	ld [MonType], a ;load zero into montype
	ld de, wd050
	callab Functione3de ;InitNickname
.asm_4da66
	ld a, [PartyCount]
	dec a
	ld hl, PartyMonNicknames
	call SkipNames ;skip to next nickname space
	ld d, h
	ld e, l
	ld hl, wd050
	call CopyBytes ;copy nickname into data structure
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Level
	call GetPartyLocation ;move down to correct mon slot
	ld a, [hl]
	ld [CurPartyLevel], a
	call Function4db49 ;store utility data
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and $80 ;use last bit only
	ld b, $13 ; 00001101
	or b
	ld [hl], a ;set caught location especially
	xor a
	ld [wdf9c], a
	and a
	ld [ScriptVar], a ; load zero into script var
	ret
; 4daa3

Function4daa3: ; 4daa3
	ld a, $1
	call GetSRAMBank ;set sram bank
	ld hl, sBoxCount
	ld a, [hl] ;store boxcount in a
	cp MONS_PER_BOX ;compare to monsperbox
	call CloseSRAM
	jr nc, .asm_4db08 ;if count => mons per box. jump
	xor a
	ld [CurPartyMon], a ;use the top slot of the box
	ld hl, wdf9c ;contest mon
	ld de, wd018
	ld bc, sBoxMon2 - sBoxMon1
	call CopyBytes ;copy mon from contestmon to place to enter box mon from
	ld hl, PlayerName
	ld de, wd00d
	ld bc, NAME_LENGTH
	call CopyBytes ;copy player name for OT
	callab Function51322 ;copy full boxmon from CurPartySpecies(species), wd002(nickname),wd00d(OT),moves (wd01a), PP(wd02f) and the rest of boxstruct(wd018) into place [curpartymon] in the current box
	ld a, [CurPartySpecies]
	ld [wd265], a ;insert species name into stringbuffer
	call GetPokemonName
	ld hl, StringBuffer1
	ld a, BOXMON
	ld [MonType], a
	ld de, wd050
	callab Functione3de ;InitNickname
	ld hl, wd050
.asm_4daf7
	ld a, $1
	call GetSRAMBank
	ld de, sBoxMonNicknames ;enter nickname into box at top position
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes
	call CloseSRAM
	ld a, $1
	call GetSRAMBank ;set to boxbank
	ld a, [sBoxMon1Level] ;get mon level
	ld [CurPartyLevel], a
	call CloseSRAM
	call Function4db83 ;store data on caught mon in first slot of box
	ld a, $1
	call GetSRAMBank
	ld hl, sBoxMon1CaughtLocation
	ld a, [hl]
	and $80 ;bit 7 of caught loc only
	ld b, $13
	or b ; bit 7 and 00001101 (inseting special bug catching data? that would make bit 7 ToD)
	ld [hl], a
	call CloseSRAM
	xor a
	ld [wdf9c], a ;load zero into species var
	ld a, $1
	ld [ScriptVar], a ;load 1 into scriptvar
	ret

.asm_4db08
	xor a
	ld [wdf9c], a ;load zero into species var
	ld a, $3
	ld [ScriptVar], a ;load 3 into scriptvar
	ret
; 4db35

Function4db35: ; 4db35
	ld a, $2 ;if no mon, ret 2 in scriptvar
	ld [ScriptVar], a
	ret
; 4db3b

UnknownText_0x4db44: ; 0x4db44
	; Give a nickname to the @  you received?
	text_jump UnknownText_0x1c12fc
	db "@"
; 0x4db49

Function4db49: ; 4db49
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CaughtLevel
	call GetPartyLocation
Function4db53: ; 4db53 store data on caught mon at HL and HL+1
	ld a, [TimeOfDay]
	inc a
	rrca
	rrca
	ld b, a ;put time into b
	ld a, [CurPartyLevel] ;put level into b
	; Pokemon caught above level 63 will bug out under the default scheme,
	; making this check now necessary.
	cp 64
	jr c, .okay
	ld a, 63
.okay
	or b
	ld [hli], a ;store time and caught level at HL
	ld a, [MapGroup] ;load current map
	ld b, a
	ld a, [MapNumber]
	ld c, a
	cp MAP_POKECENTER_2F ;If trade area
	jr z, .check_group
	cp MAP_POKECENTER_2F_KANTO
	jr nz, .asm_4db78
.check_group
	ld a, b
	cp GROUP_POKECENTER_2F
	jr nz, .asm_4db78
	ld a, [BackupMapGroup] ;load backup map?
	ld b, a
	ld a, [BackupMapNumber]
	ld c, a
.asm_4db78
	call GetWorldMapLocation ; c = something to do with location
	ld b, a
	ld a, [PlayerGender]
	rrca
	or b
	ld [hl], a ;store them both in the mon
	ret
; 4db83

Function4db83: ; 4db83
	ld a, $1
	call GetSRAMBank
	ld hl, sBoxMon1CaughtLevel
	call Function4db53
	call CloseSRAM
	ret
; 4db92

Function4db92: ; 4db92
	push bc
	ld a, $1
	call GetSRAMBank
	ld hl, sBoxMon1CaughtLevel
	pop bc
	call Function4dbaf
	call CloseSRAM
	ret
; 4dba3

Function4dba3: ; 4dba3
	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1CaughtLevel
	push bc
	call GetPartyLocation
	pop bc
Function4dbaf: ; 4dbaf
	xor a
	ld [hli], a
	ld a, $7e
	rrc b
	or b
	ld [hl], a
	ret
; 4dbb8

Function4dbb8: ; 4dbb8 (13:5bb8)
	ld a, [CurPartyMon]
	ld hl, PartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [CurPartyLevel]
	push af
	ld a, $1
	ld [CurPartyLevel], a
	call Function4db53
	pop af
	ld [CurPartyLevel], a
	ret

Function4dbd2: ; 4dbd2
	ld hl, PartyMon1Level
	call Function4dc31
	ret
; 4dbd9

Function4dbd9: ; 4dbd9
	ld hl, PartyMon1Happiness
	call Function4dc0a
	ret
; 4dbe0

Function4dbe0: ; 4dbe0
	ld hl, PartyMon1Species
	jp Function4dc56
; 4dbe6

Function4dbe6: ; 4dbe6
	ld hl, PartyMon1Species
	call Function4dc56
	ret z
	ld a, c
	ld hl, PartyMon1ID
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld a, [PlayerID]
	cp [hl]
	jr nz, .asm_4dc08
	inc hl
	ld a, [PlayerID + 1]
	cp [hl]
	jr nz, .asm_4dc08
	ld a, $1
	and a
	ret

.asm_4dc08
	xor a
	ret
; 4dc0a

Function4dc0a: ; 4dc0a
	ld c, $0
	ld a, [PartyCount]
	ld d, a
.asm_4dc10
	ld a, d
	dec a
	push hl
	push bc
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	pop bc
	ld a, b
	cp [hl]
	pop hl
	jr z, .asm_4dc22
	jr nc, .asm_4dc26
.asm_4dc22
	ld a, c
	or $1
	ld c, a
.asm_4dc26
	sla c
	dec d
	jr nz, .asm_4dc10
	call Function4dc67
	ld a, c
	and a
	ret
; 4dc31

Function4dc31: ; 4dc31
	ld c, $0
	ld a, [PartyCount]
	ld d, a
.asm_4dc37
	ld a, d
	dec a
	push hl
	push bc
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	pop bc
	ld a, b
	cp [hl]
	pop hl
	jr c, .asm_4dc4b
	ld a, c
	or $1
	ld c, a
.asm_4dc4b
	sla c
	dec d
	jr nz, .asm_4dc37
	call Function4dc67
	ld a, c
	and a
	ret
; 4dc56

Function4dc56: ; 4dc56
	ld c, $ff
	ld hl, PartySpecies
.asm_4dc5b
	ld a, [hli]
	cp $ff
	ret z
	inc c
	cp b
	jr nz, .asm_4dc5b
	ld a, $1
	and a
	ret
; 4dc67

Function4dc67: ; 4dc67
	ld e, $fe
	ld hl, PartySpecies
.asm_4dc6c
	ld a, [hli]
	cp $ff
	ret z
	cp EGG
	jr nz, .asm_4dc77
	ld a, c
	and e
	ld c, a
.asm_4dc77
	rlc e
	jr .asm_4dc6c
; 4dc7b

Function4dc7b: ; 4dc7b (13:5c7b)
	ld a, [wLinkMode]
	cp $4
	jr nz, StatsScreenInit
	ld a, [wBattleMode] ; wd22d (aliases: EnemyMonEnd)
	and a
	jr z, StatsScreenInit
	jr Function4dc8f

StatsScreenInit: ; 4dc8a
	ld hl, StatsScreenMain
	jr StatsScreenInit_gotaddress

Function4dc8f: ; 4dc8f
	ld hl, StatsScreenBattle
	jr StatsScreenInit_gotaddress

StatsScreenInit_gotaddress: ; 4dc94
	ld a, [$ffde]
	push af
	xor a
	ld [$ffde], a ; disable overworld tile animations
	ld a, [wc2c6] ; whether sprite is to be mirrorred
	push af
	ld a, [wcf63]
	ld b, a
	ld a, [wcf64]
	ld c, a
	push bc
	push hl
	call WhiteBGMap
	call ClearTileMap
	call Function1ad2
	callba Functionfb53e
	pop hl
	call _hl_
	call WhiteBGMap
	call ClearTileMap
	pop bc
	; restore old values
	ld a, b
	ld [wcf63], a
	ld a, c
	ld [wcf64], a
	pop af
	ld [wc2c6], a
	pop af
	ld [$ffde], a
	ret
; 0x4dcd2

StatsScreenMain: ; 0x4dcd2
	xor a
	ld [wcf63], a
	ld [wcf64], a
.loop ; 4dce3
	ld a, [wcf63]
	and $7f
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call Function4dd3a ; check for keys?
	ld a, [wcf63]
	bit 7, a
	jr z, .loop
	ret
; 0x4dcf7

StatsScreenBattle: ; 4dcf7
	xor a
	ld [wcf63], a
	ld [wcf64], a
.asm_4dd08
	callba Function100dd2
	ld a, [wcf63]
	and $7f
	ld hl, StatsScreenPointerTable
	rst JumpTable
	call Function4dd3a
	callba Function100dfd
	jr c, .asm_4dd29
	ld a, [wcf63]
	bit 7, a
	jr z, .asm_4dd08
.asm_4dd29
	ret
; 4dd2a

StatsScreenPointerTable: ; 4dd2a
	dw Function4dd72 ; regular pokémon
	dw EggStatsInit ; egg
	dw Function4dde6
	dw Function4ddac
	dw Function4ddc6
	dw Function4dde6
	dw Function4ddd6
	dw Function4dd6c
; 4dd3a

Function4dd3a: ; 4dd3a (13:5d3a)
	ld hl, wcf64
	bit 6, [hl]
	jr nz, .asm_4dd49
	bit 5, [hl]
	jr nz, .asm_4dd56
	call DelayFrame
	ret

.asm_4dd49
	callba Functiond00b4
	jr nc, .asm_4dd56
	ld hl, wcf64
	res 6, [hl]
.asm_4dd56
	ld hl, wcf64
	res 5, [hl]
	callba Function10402d
	ret

Function4dd62: ; 4dd62 (13:5d62)
	ld a, [wcf63]
	and $80
	or h
	ld [wcf63], a
	ret

Function4dd6c: ; 4dd6c (13:5d6c)
	ld hl, wcf63
	set 7, [hl]
	ret

Function4dd72: ; 4dd72 (13:5d72)
	ld hl, wcf64
	res 6, [hl]
	call WhiteBGMap
	call ClearTileMap
	callba Function10402d
	call Function4ddf2
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_4dd9b
	call Function4deea
	ld hl, wcf64
	set 4, [hl]
	ld h, $4
	call Function4dd62
	ret

.asm_4dd9b
	ld h, $1
	call Function4dd62
	ret

EggStatsInit: ; 4dda1
	call EggStatsScreen
	ld a, [wcf63]
	inc a
	ld [wcf63], a
	ret
; 0x4ddac

Function4ddac: ; 4ddac (13:5dac)
	call Function4de2c
	jr nc, .asm_4ddb7
	ld h, $0
	call Function4dd62
	ret

.asm_4ddb7
	bit 0, a
	jr nz, .asm_4ddc0
	and $c3
	jp Function4de54

.asm_4ddc0
	ld h, $7
	call Function4dd62
	ret

Function4ddc6: ; 4ddc6 (13:5dc6)
	call Function4dfb6
	ld hl, wcf64
	res 4, [hl]
	ld a, [wcf63]
	inc a
	ld [wcf63], a
	ret

Function4ddd6: ; 4ddd6 (13:5dd6)
	call Function4de2c
	jr nc, .asm_4dde1
	ld h, $0
	call Function4dd62
	ret

.asm_4dde1
	and $f3
	jp Function4de54

Function4dde6: ; 4dde6 (13:5de6)
	call IsSFXPlaying
	ret nc
	ld a, [wcf63]
	inc a
	ld [wcf63], a
	ret

Function4ddf2: ; 4ddf2 (13:5df2)
	ld a, [MonType]
	cp $3
	jr nz, .asm_4de10
	ld a, [wd018]
	ld [CurSpecies], a
	call GetBaseData
	ld hl, wd018
	ld de, TempMon
	ld bc, $30
	call CopyBytes
	jr .asm_4de2a

.asm_4de10
	callba Function5084a
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_4de2a
	ld a, [MonType]
	cp $2
	jr c, .asm_4de2a
	callba Function50890
.asm_4de2a
	and a
	ret

Function4de2c: ; 4de2c (13:5e2c)
	call GetJoypad
	ld a, [MonType]
	cp $3
	jr nz, .asm_4de4e
	push hl
	push de
	push bc
	callba Functione2f95
	pop bc
	pop de
	pop hl
	ld a, [wcf73]
	and $c0
	jr nz, .asm_4de52
	ld a, [wcf73]
	jr .asm_4de50

.asm_4de4e
	ld a, [hJoyPressed] ; $ff00+$a7
.asm_4de50
	and a
	ret

.asm_4de52
	scf
	ret

Function4de54: ; 4de54 (13:5e54)
	push af
	ld a, [wcf64]
	and $3
	ld c, a
	pop af
	bit 1, a
	jp nz, Function4dee4
	bit 5, a
	jr nz, .asm_4dec7
	bit 4, a
	jr nz, .asm_4debd
	bit 0, a
	jr nz, .asm_4deb8
	bit 6, a
	jr nz, .asm_4dea0
	bit 7, a
	jr nz, .asm_4de77
	jr .asm_4dece

.asm_4de77
	ld a, [MonType]
	cp $2
	jr nc, .asm_4dece
	and a
	ld a, [PartyCount]
	jr z, .asm_4de87
	ld a, [OTPartyCount]
.asm_4de87
	ld b, a
	ld a, [CurPartyMon]
	inc a
	cp b
	jr z, .asm_4dece
	ld [CurPartyMon], a
	ld b, a
	ld a, [MonType]
	and a
	jr nz, .asm_4dede
	ld a, b
	inc a
	ld [wd0d8], a
	jr .asm_4dede

.asm_4dea0
	ld a, [CurPartyMon]
	and a
	jr z, .asm_4dece
	dec a
	ld [CurPartyMon], a
	ld b, a
	ld a, [MonType]
	and a
	jr nz, .asm_4dede
	ld a, b
	inc a
	ld [wd0d8], a
	jr .asm_4dede

.asm_4deb8
	ld a, c
	cp $3
	jr z, Function4dee4
.asm_4debd
	inc c
	ld a, $3
	cp c
	jr nc, .asm_4decf
	ld c, 0
	jr .asm_4decf

.asm_4dec7
	ld a, c
	dec c
	and a
	jr nz, .asm_4decf
	ld c, $3
	jr .asm_4decf

.asm_4dece
	ret

.asm_4decf
	ld a, [wcf64]
	and $fc
	or c
	ld [wcf64], a
	ld h, $4
	call Function4dd62
	ret

.asm_4dede
	ld h, $0
	call Function4dd62
	ret

Function4dee4: ; 4dee4 (13:5ee4)
	ld h, $7
	call Function4dd62
	ret

Function4deea: ; 4deea (13:5eea)
	call Function4df45
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, [CurBaseData] ; wd236 (aliases: BaseDexNo)
	ld [wd265], a
	ld [CurSpecies], a
	hlcoord 8, 0
	ld [hl], "№"
	inc hl
	ld [hl], "."
	inc hl
	hlcoord 10, 0
	ld bc, $8103
	ld de, wd265
	call PrintNum
	hlcoord 14, 0
	call PrintLevel
	ld hl, Unknown_4df77
	call Function4e528
	call Function4e505
	hlcoord 8, 2
	call PlaceString
	hlcoord 18, 0
	call Function4df66
	hlcoord 9, 4
	ld a, $f3
	ld [hli], a
	ld a, [CurBaseData] ; wd236 (aliases: BaseDexNo)
	ld [wd265], a
	call GetPokemonName
	call PlaceString
	call Function4df8f
	call Function4df9b
	call Function4dfa6
	ret

Function4df45: ; 4df45 (13:5f45)
	ld hl, TempMonHP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, TempMonMaxHP
	ld a, [hli]
	ld d, a
	ld e, [hl]
	callba Functionc699
	ld hl, wcda1
	call SetHPPal
	ld b, $3
	call GetSGBLayout
	call DelayFrame
	ret

Function4df66: ; 4df66 (13:5f66)
	push hl
	callba GetGender
	pop hl
	ret c
	ld a, "♂"
	jr nz, .asm_4df75
	ld a, "♀"
.asm_4df75
	ld [hl], a
	ret
; 4df77 (13:5f77)

Unknown_4df77: ; 4df77
	dw PartyMonNicknames
	dw OTPartyMonNicknames
	dw $b082
	dw wd002
; 4df7f

Function4df7f: ; 4df7f
	hlcoord 7, 0
	ld bc, 20
	ld d, 18
.asm_4df87
	ld a, $31
	ld [hl], a
	add hl, bc
	dec d
	jr nz, .asm_4df87
	ret
; 4df8f

Function4df8f: ; 4df8f (13:5f8f)
	hlcoord 0, 7
	ld b, 20
	ld a, $62
.asm_4df96
	ld [hli], a
	dec b
	jr nz, .asm_4df96
	ret

Function4df9b: ; 4df9b (13:5f9b)
	hlcoord 10, 6
	ld [hl], $71
	hlcoord 19, 6
	ld [hl], $ed
	ret

Function4dfa6: ; 4dfa6 (13:5fa6)
	ld bc, TempMonDVs
	callba CheckShininess
	ret nc
	hlcoord 19, 0
	ld [hl], $3f
	ret

Function4dfb6: ; 4dfb6 (13:5fb6)
	ld a, [CurBaseData] ; wd236 (aliases: BaseDexNo)
	ld [wd265], a
	ld [CurSpecies], a
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function4dfda
	call Function4e002
	call Function4dfed
	ld hl, wcf64
	bit 4, [hl]
	jr nz, .asm_4dfd6
	call Function32f9
	ret

.asm_4dfd6
	call Function4e226
	ret

Function4dfda: ; 4dfda (13:5fda)
	ld a, [wcf64]
	and $3
	ld c, a
	call Function4e4cd
	hlcoord 0, 8
	ld bc, $a14
	call ClearBox
	ret

Function4dfed: ; 4dfed (13:5fed)
	ld a, [wcf64]
	and $3
	ld c, a
	callba Function8c8a
	call DelayFrame
	ld hl, wcf64
	set 5, [hl]
	ret

Function4e002: ; 4e002 (13:6002)
	ld a, [wcf64]
	and $3
	ld hl, Jumptable_4e00d
	rst JumpTable
	ret

Jumptable_4e00d: ; 4e00d (13:600d)
	dw Function4e013
	dw Function4e147
	dw Function4e1ae
	dw TrainerNotes

Function4e013: ; 4e013 (13:6013)
	hlcoord 0, 9
	ld b, $0
	predef DrawPlayerHP
	hlcoord 8, 9
	ld [hl], $41
	ld de, String_4e119
	hlcoord 0, 12
	call PlaceString
	ld a, [TempMonPokerusStatus]
	ld b, a
	and $f
	jr nz, .asm_4e055
	ld a, b
	and $f0
	jr z, .asm_4e03d
	hlcoord 8, 8
	ld [hl], $e8
.asm_4e03d
	ld a, [MonType]
	cp $2
	jr z, .asm_4e060
	hlcoord 6, 13
	push hl
	ld de, TempMonStatus
	predef Function50d0a
	pop hl
	jr nz, .asm_4e066
	jr .asm_4e060

.asm_4e055
	ld de, String_4e142
	hlcoord 1, 13
	call PlaceString
	jr .asm_4e066

.asm_4e060
	ld de, String_4e127
	call PlaceString
.asm_4e066
	hlcoord 1, 15
	predef PrintMonTypes
	hlcoord 9, 8
	ld de, $14
	ld b, $a
	ld a, $31
.asm_4e078
	ld [hl], a
	add hl, de
	dec b
	jr nz, .asm_4e078
	ld de, String_4e12b
	hlcoord 10, 9
	call PlaceString
	hlcoord 17, 14
	call Function4e0d3
	hlcoord 13, 10
	ld bc, $307
	ld de, TempMonExp
	call PrintNum
	call Function4e0e7
	hlcoord 13, 13
	ld bc, $307
	ld de, Buffer1 ; wd1ea (aliases: MagikarpLength)
	call PrintNum
	ld de, String_4e136
	hlcoord 10, 12
	call PlaceString
	ld de, String_4e13f
	hlcoord 14, 14
	call PlaceString
	hlcoord 11, 16
	ld a, [TempMonLevel]
	ld b, a
	ld de, TempMonExp + 2
	predef FillInExpBar
	hlcoord 10, 16
	ld [hl], $40
	hlcoord 19, 16
	ld [hl], $41
	ret

Function4e0d3: ; 4e0d3 (13:60d3)
	ld a, [TempMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .asm_4e0df
	inc a
	ld [TempMonLevel], a
.asm_4e0df
	call PrintLevel
	pop af
	ld [TempMonLevel], a
	ret

Function4e0e7: ; 4e0e7 (13:60e7)
	ld a, [TempMonLevel]
	cp MAX_LEVEL
	jr z, .asm_4e111
	inc a
	ld d, a
	callba Function50e47
	ld hl, TempMonExp + 2
	ld a, [$ffb6]
	sub [hl]
	dec hl
	ld [wd1ec], a
	ld a, [$ffb5]
	sbc [hl]
	dec hl
	ld [Buffer2], a ; wd1eb (aliases: MovementType)
	ld a, [hQuotient] ; $ff00+$b4 (aliases: hMultiplicand)
	sbc [hl]
	ld [Buffer1], a ; wd1ea (aliases: MagikarpLength)
	ret

.asm_4e111
	ld hl, Buffer1 ; wd1ea (aliases: MagikarpLength)
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret
; 4e119 (13:6119)

String_4e119: ; 4e119
	db   "STATUS/"
	next "TYPE/@"
; 4e127

String_4e127: ; 4e127
	db "OK @"
; 4e12b

String_4e12b: ; 4e12b
	db "EXP POINTS@"
; 4e136

String_4e136: ; 4e136
	db "LEVEL UP@"
; 4e13f

String_4e13f: ; 4e13f
	db "TO@"
; 4e142

String_4e142: ; 4e142
	db "#RUS@"
; 4e147

Function4e147: ; 4e147 (13:6147)
	ld de, String_4e1a0
	hlcoord 0, 8
	call PlaceString
	call Function4e189
	hlcoord 8, 8
	call PlaceString
	ld de, String_4e1a9
	hlcoord 0, 10
	call PlaceString
	ld hl, TempMonMoves
	ld de, wd25e
	ld bc, NUM_MOVES
	call CopyBytes
	hlcoord 8, 10
	ld a, SCREEN_WIDTH * 2
	ld [Buffer1], a
	predef ListMoves
	hlcoord 12, 11
	ld a, $28
	ld [Buffer1], a
	predef Function50c50
	ret

Function4e189: ; 4e189 (13:6189)
	ld de, String_4e1a5
	ld a, [TempMonItem]
	and a
	ret z
	ld b, a
	callba Function28771
	ld a, b
	ld [wd265], a
	call GetItemName
	ret
; 4e1a0 (13:61a0)

String_4e1a0: ; 4e1a0
	db "ITEM@"
; 4e1a5

String_4e1a5: ; 4e1a5
	db "---@"
; 4e1a9

String_4e1a9: ; 4e1a9
	db "MOVE@"
; 4e1ae

Function4e1ae: ; 4e1ae (13:61ae)
	call Function4e1cc
	hlcoord 10, 8
	ld de, $14
	ld b, $a
	ld a, $31
.asm_4e1bb
	ld [hl], a
	add hl, de
	dec b
	jr nz, .asm_4e1bb
	hlcoord 11, 8
	ld bc, $6
	predef PrintTempMonStats
	ret

Function4e1cc: ; 4e1cc (13:61cc)
	ld de, IDNoString
	hlcoord 0, 9
	call PlaceString
	ld de, OTString
	hlcoord 0, 12
	call PlaceString
	hlcoord 2, 10
	ld bc, $8205
	ld de, TempMonID
	call PrintNum
	ld hl, Unknown_4e216
	call Function4e528
	call Function4e505
	callba CheckNickErrors
	hlcoord 2, 13
	call PlaceString
	ld a, [TempMonCaughtGender]
	and a
	jr z, .asm_4e215
	cp $7f
	jr z, .asm_4e215
	and $80
	ld a, "♂"
	jr z, .asm_4e211
	ld a, "♀"
.asm_4e211
	hlcoord 9, 13
	ld [hl], a
.asm_4e215
	ret
; 4e216 (13:6216)

Unknown_4e216: ; 4e216
	dw PartyMonOT
	dw OTPartyMonOT
	dw sBoxMonOT
	dw wd00d
; 4e21e

IDNoString: ; 4e21e
	db $73, "№.@"
OTString: ; 4e222
	db "OT/@"
; 4e226

Function4e226: ; 4e226 (13:6226)
	ld hl, TempMonDVs
	predef GetUnownLetter
	call Function4e2ad
	jr c, .asm_4e238
	and a
	jr z, .asm_4e23f
	jr .asm_4e246

.asm_4e238
	call Function4e271
	call Function32f9
	ret

.asm_4e23f
	call Function4e253
	call Function32f9
	ret

.asm_4e246
	call Function32f9
	call Function4e253
	ld a, [CurPartySpecies]
	call PlayCry2
	ret

Function4e253: ; 4e253 (13:6253)
	ld hl, wcf64
	set 5, [hl]
	ld a, [CurPartySpecies]
	cp UNOWN
	jr z, .asm_4e266
	hlcoord 0, 0
	call Function3786
	ret

.asm_4e266
	xor a
	ld [wc2c6], a
	hlcoord 0, 0
	call Function378b
	ret

Function4e271: ; 4e271 (13:6271)
	ld a, [CurPartySpecies]
	cp UNOWN
	jr z, .asm_4e281
	ld a, $1
	ld [wc2c6], a
	call Function4e289
	ret

.asm_4e281
	xor a
	ld [wc2c6], a
	call Function4e289
	ret

Function4e289: ; 4e289 (13:6289)
	ld a, [CurPartySpecies]
	call IsAPokemon
	ret c
	call Function4e307
	ld de, $9000
	predef Function5108b
	hlcoord 0, 0
	ld d, $0
	ld e, $2
	predef Functiond00a3
	ld hl, wcf64
	set 6, [hl]
	ret

Function4e2ad: ; 4e2ad (13:62ad)
	ld a, [MonType]
	ld hl, Jumptable_4e2b5
	rst JumpTable
	ret

Jumptable_4e2b5: ; 4e2b5 (13:62b5)
	dw Function4e2bf
	dw Function4e2cf
	dw Function4e2d1
	dw Function4e2ed
	dw Function4e301

Function4e2bf: ; 4e2bf (13:62bf)
	ld a, [CurPartyMon]
	ld hl, PartyMons ; wdcdf (aliases: PartyMon1, PartyMon1Species)
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld b, h
	ld c, l
	jr Function4e2f2

Function4e2cf: ; 4e2cf (13:62cf)
	xor a
	ret

Function4e2d1: ; 4e2d1 (13:62d1)
	ld hl, sBoxMons
	ld bc, $30
	ld a, [CurPartyMon]
	call AddNTimes
	ld b, h
	ld c, l
	ld a, $1
	call GetSRAMBank
	call Function4e2f2
	push af
	call CloseSRAM
	pop af
	ret

Function4e2ed: ; 4e2ed (13:62ed)
	ld bc, TempMonSpecies ; wd10e (aliases: TempMon)
	jr Function4e2f2

Function4e2f2: ; 4e2f2 (13:62f2)
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_4e2fe
	call Function4e53f
	jr c, Function4e305
.asm_4e2fe
	xor a
	scf
	ret

Function4e301: ; 4e301 (13:6301)
	ld a, $1
	and a
	ret

Function4e305: ; 4e305 (13:6305)
	xor a
	ret

Function4e307: ; 4e307 (13:6307)
	nop
	push hl
	push de
	push bc
	push af
	call DelayFrame
	ld a, [rVBK] ; $ff00+$4f
	push af
	ld a, $1
	ld [rVBK], a ; $ff00+$4f
	ld de, GFX_f9204
	lb bc, BANK(GFX_f9204), 1
	ld hl, $97f0
	call Get2bpp
	pop af
	ld [rVBK], a ; $ff00+$4f
	pop af
	pop bc
	pop de
	pop hl
	ret
; 4e32a (13:632a)

Unknown_4e32a: ; 4e32a
; A blank tile?

	ds 16
; 4e33a

TrainerNotes:
	callba TrainerNotes_
	ret

EggStatsScreen: ; 4e33a
	xor a
	ld [hBGMapMode], a
	ld hl, wcda1
	call SetHPPal
	ld b, $3
	call GetSGBLayout
	call Function4df8f
	ld de, EggString
	hlcoord 8, 1
	call PlaceString
	ld de, IDNoString
	hlcoord 8, 3
	call PlaceString
	ld de, OTString
	hlcoord 8, 5
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 3
	call PlaceString
	ld de, FiveQMarkString
	hlcoord 11, 5
	call PlaceString
	ld a, [TempMonHappiness] ; egg status
	ld de, EggSoonString
	cp $6
	jr c, .picked
	ld de, EggCloseString
	cp $b
	jr c, .picked
	ld de, EggMoreTimeString
	cp $29
	jr c, .picked
	ld de, EggALotMoreTimeString
.picked
	hlcoord 1, 9
	call PlaceString
	ld hl, wcf64
	set 5, [hl]
	call Function32f9 ; pals
	call DelayFrame
	hlcoord 0, 0
	call Function3786
	callba Function10402d
	call Function4e497
	ld a, [TempMonHappiness]
	cp 6
	ret nc
	ld de, SFX_2_BOOPS
	call PlaySFX
	ret
; 0x4e3c0

EggString: ; 4e3c0
	db "EGG@"
FiveQMarkString: ; 4e3c4
	db "?????@"
EggSoonString: ; 0x4e3ca
	db   "It's making sounds"
	next "inside. It's going"
	next "to hatch soon!@"
EggCloseString: ; 0x4e3fd
	db   "It moves around"
	next "inside sometimes."
	next "It must be close"
	next "to hatching.@"
EggMoreTimeString: ; 0x4e43d
	db   "Wonder what's"
	next "inside? It needs"
	next "more time, though.@"
EggALotMoreTimeString: ; 0x4e46e
	db   "This EGG needs a"
	next "lot more time to"
	next "hatch.@"
; 0x4e497

Function4e497: ; 4e497 (13:6497)
	call Function4e2ad
	ret nc
	ld a, [TempMonHappiness]
	ld e, $7
	cp $6
	jr c, .asm_4e4ab
	ld e, $8
	cp $b
	jr c, .asm_4e4ab
	ret

.asm_4e4ab
	push de
	ld a, $1
	ld [wc2c6], a
	call Function4e307
	ld de, $9000
	predef Function5108b
	pop de
	hlcoord 0, 0
	ld d, $0
	predef Functiond00a3
	ld hl, wcf64
	set 6, [hl]
	ret

Function4e4cd: ; 4e4cd (13:64cd)
	hlcoord 11, 5
	ld a, $36
	call Function4e4f7
	hlcoord 13, 5
	ld a, $36
	call Function4e4f7
	hlcoord 15, 5
	ld a, $36
	call Function4e4f7
	hlcoord 17, 5
	ld a, $36
	call Function4e4f7
	ld a, c
	and a
	jr z, .zero
	cp $2
	ld a, $3a
	hlcoord 13, 5
	jr c, Function4e4f7
	hlcoord 15, 5
	jr z, Function4e4f7
	hlcoord 17, 5
	jr Function4e4f7
.zero
	ld a, $3a
	hlcoord 11, 5
Function4e4f7: ; 4e4f7 (13:64f7)
	push bc
	ld [hli], a
	inc a
	ld [hld], a
	ld bc, $14
	add hl, bc
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

Function4e505: ; 4e505 (13:6505)
	ld de, StringBuffer1
	ld bc, $b
	jr .asm_4e50d

.asm_4e50d
	ld a, [MonType]
	cp BOXMON
	jr nz, .asm_4e522
	ld a, $1
	call GetSRAMBank
	push de
	call CopyBytes
	pop de
	call CloseSRAM
	ret

.asm_4e522
	push de
	call CopyBytes
	pop de
	ret

Function4e528: ; 4e528 (13:6528)
	ld a, [MonType]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [MonType]
	cp $3
	ret z
	ld a, [CurPartyMon]
	jp SkipNames

Function4e53f: ; 4e53f
	ld hl, PartyMon1HP - PartyMon1
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .asm_4e552
	ld hl, PartyMon1Status - PartyMon1
	add hl, bc
	ld a, [hl]
	and (1 << FRZ) | SLP
	jr nz, .asm_4e552
	and a
	ret

.asm_4e552
	scf
	ret
; 4e554

Function4e554:: ; 4e554
	ld a, [BattleType]
	dec a
	ld c, a
	ld hl, Jumptable_4e564
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 4e564

Jumptable_4e564: ; 4e564 (13:6564)
	dw Function4e56a
	dw Function4e56a
	dw Function4e56a

Function4e56a: ; 4e56a (13:656a)
	ld hl, PlayerName
	ld de, MomsName
	ld bc, NAME_LENGTH
	call CopyBytes
	ld a, [MapGroup]
	cp GROUP_VIRIDIAN_CITY_RB
	jr z, .OldMan
	ld hl, DudeString
	jr .GotString

.OldMan
	ld hl, OldManString
.GotString
	ld de, PlayerName
	ld bc, NAME_LENGTH
	call CopyBytes
	call Function4e5b7
	xor a
	ld [hJoyDown], a
	ld [hJoyPressed], a
	ld a, [Options]
	push af
	and $f8
	add $3
	ld [Options], a
	ld hl, AutoInput_4e5df
	ld a, BANK(AutoInput_4e5df)
	call StartAutoInput
	callab StartBattle
	call StopAutoInput
	pop af
	ld [Options], a
	ld hl, MomsName
	ld de, PlayerName
	ld bc, NAME_LENGTH
	call CopyBytes
	ret

Function4e5b7: ; 4e5b7 (13:65b7)
	ld hl, OTPartyMon1
	ld [hl], 1
	inc hl
	ld [hl], POTION
	inc hl
	ld [hl], 1
	inc hl
	ld [hl], -1
	ld hl, OTPartyMon1Exp + 2
	ld [hl], 0
	inc hl
	ld [hl], -1
	ld hl, OTPartyMon1CaughtGender
	ld a, 1
	ld [hli], a
	ld a, [MapGroup]
	cp GROUP_VIRIDIAN_CITY_RB
	jr z, .OldMan
	ld a, GREAT_BALL
	ld [hli], a
	ld a, 5
	ld [hli], a
	ld [hl], -1
	ret
.OldMan
	ld a, POKE_BALL ; 5
	ld [hli], a
	ld [hli], a
	ld [hl], -1
	ret


DudeString: ; 4e5da
	db "DUDE@"
; 4e5df
OldManString:
	db "OLD MAN@"

AutoInput_4e5df: ; 4e5df
	db NO_INPUT, $ff ; end
; 4e5e1

EvolutionAnimation: ; 4e5e1
	push hl
	push de
	push bc
	ld a, [CurSpecies]
	push af
	ld a, [rOBP0]
	push af
	ld a, [BaseDexNo]
	push af
	call _EvolutionAnimation
	pop af
	ld [BaseDexNo], a
	pop af
	ld [rOBP0], a
	pop af
	ld [CurSpecies], a
	pop bc
	pop de
	pop hl
	ld a, [wd1ed]
	and a
	ret z
	scf
	ret
; 4e607

_EvolutionAnimation: ; 4e607
	ld a, $e4
	ld [rOBP0], a
	ld de, MUSIC_NONE
	call PlayMusic
	callba Function8cf53
	ld de, EvolutionGFX
	ld hl, VTiles0
	lb bc, BANK(EvolutionGFX), 8
	call Request2bpp
	xor a
	ld [Danger], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld a, [Buffer1]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	ld a, [Buffer1]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call Function4e708
	ld de, VTiles2
	ld hl, $9310
	ld bc, $0031
	call Request2bpp
	ld a, $31
	ld [wd1ec], a
	call Function4e755
	ld a, [Buffer2]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	call Function4e711
	ld a, [Buffer1]
	ld [CurPartySpecies], a
	ld [CurSpecies], a
	ld a, $1
	ld [hBGMapMode], a
	call Function4e794
	jr c, .asm_4e67c
	ld a, [Buffer1]
	call PlayCry
.asm_4e67c
	ld de, MUSIC_EVOLUTION
	call PlayMusic
	ld c, 80
	call DelayFrames
	ld c, $1
	call Function4e703
	call Function4e726
	jr c, .asm_4e6df
	ld a, $cf
	ld [wd1ec], a
	call Function4e755
	xor a
	ld [wd1ed], a
	ld a, [Buffer2]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	call Function4e7a6
	callba Function8cf53
	call Function4e794
	jr c, .asm_4e6de
	ld a, [wc2c6]
	push af
	ld a, $1
	ld [wc2c6], a
	ld a, [CurPartySpecies]
	push af
	ld a, [PlayerHPPal]
	ld [CurPartySpecies], a
	hlcoord 7, 2
	ld d, $0
	ld e, $4
	predef Functiond008e
	pop af
	ld [CurPartySpecies], a
	pop af
	ld [wc2c6], a
	ret

.asm_4e6de
	ret

.asm_4e6df
	ld a, $1
	ld [wd1ed], a
	ld a, [Buffer1]
	ld [PlayerHPPal], a
	ld c, $0
	call Function4e703
	call Function4e7a6
	callba Function8cf53
	call Function4e794
	ret c
	ld a, [PlayerHPPal]
	call PlayCry
	ret
; 4e703

Function4e703: ; 4e703
	ld b, $b
	jp GetSGBLayout
; 4e708

Function4e708: ; 4e708
	call GetBaseData
	hlcoord 7, 2
	jp Function3786
; 4e711

Function4e711: ; 4e711
	call GetBaseData
	ld a, $1
	ld [wc2c6], a
	ld de, VTiles2
	predef Function5108b
	xor a
	ld [wc2c6], a
	ret
; 4e726

Function4e726: ; 4e726
	ld a, [wcf64]
	push af
	ld a, 3
	ld [wcf64], a
	call ClearJoypad
	ld bc, $010e ;b = legnth of uncancelable flahes(starts at 1, 8 frames each), c = legnth of cancellable flashes(starts at 14, c frames each)
.asm_4e72c
	push bc
	call Function4e779 ;cancellable section
	pop bc
	jr c, .asm_4e73f ;if skipped
	push bc
	call Function4e741 ;uncancellable section
	pop bc
	inc b ;b+1, c -2
	dec c
	dec c
	jr nz, .asm_4e72c ;repeat 7 times
	pop af
	ld [wcf64], a
	and a
	ret

.asm_4e73f
	pop af
	ld [wcf64], a
	scf
	ret
; 4e741

Function4e741: ; 4e741
.asm_4e741
	ld a, $cf
	ld [wd1ec], a ;load 207 into ??
	call Function4e755
	ld a, $31
	ld [wd1ec], a
	call Function4e755
	dec b
	jr nz, .asm_4e741 ;loop b times
	ret
; 4e755

Function4e755: ; 4e755
	push bc
	xor a
	ld [hBGMapMode], a ;load 0 into map mode
	hlcoord 7, 2
	ld bc, $0707 ;loop 7*7 times
	ld de, $000d
.asm_4e762
	push bc
.asm_4e763
	ld a, [wd1ec]
	add [hl] ; tile += wd1ec in a 7*7 square
	ld [hli], a
	dec c
	jr nz, .asm_4e763 ;loop 7 columns
	pop bc
	add hl, de ;skip forward to start of next row
	dec b
	jr nz, .asm_4e762 ;loop 7 rows
	ld a, $1
	ld [hBGMapMode], a ;reset bgmapmode
	call WaitBGMap ;delays 4 frames
	pop bc
	ret
; 4e779

Function4e779: ; 4e779 evo cancelling
.asm_4e779
	call DelayFrame
	push bc
	call Functiona57 ; update joypad data
	ld a, [hJoyPressed]
	pop bc
	and $2 ; if b, check if forced
	jr nz, .asm_4e78c
	ld a, [hJoyPressed]
	and $1
	jr z, .asm_4e787
	ld hl, wcf64
	ld a, [hl]
	cp 3
	jr z, .asm_4e787
	inc [hl]
.asm_4e787
	dec c
	jr nz, .asm_4e779 ; loop c times
	and a
	ret

.asm_4e78c
	ld a, [wd1e9]
	and a
	jr nz, .asm_4e787 ; if forced to evolve, next frame
	ld hl, wcf64
	dec [hl]
	jr nz, .asm_4e787
	scf
	ret
; 4e794

Function4e794: ; 4e794
	ld a, [CurPartyMon]
	ld hl, PartyMon1Species
	call GetPartyLocation
	ld b, h
	ld c, l
	callba Function4e53f
	ret
; 4e7a6

Function4e7a6: ; 4e7a6
	ld a, [wd1ed]
	and a
	ret nz
	ld de, SFX_EVOLVED
	call PlaySFX
	ld hl, wcf63
	ld a, [hl]
	push af
	ld [hl], $0
.asm_4e7b8
	call Function4e7cf
	jr nc, .asm_4e7c2
	call Function4e80c
	jr .asm_4e7b8

.asm_4e7c2
	ld c, $20
.asm_4e7c4
	call Function4e80c
	dec c
	jr nz, .asm_4e7c4
	pop af
	ld [wcf63], a
	ret
; 4e7cf

Function4e7cf: ; 4e7cf
	ld hl, wcf63
	ld a, [hl]
	cp $20
	ret nc
	ld d, a
	inc [hl]
	and $1
	jr nz, .asm_4e7e6
	ld e, $0
	call Function4e7e8
	ld e, $10
	call Function4e7e8
.asm_4e7e6
	scf
	ret
; 4e7e8

Function4e7e8: ; 4e7e8
	push de
	ld de, $4858
	ld a, $13
	call Function3b2a
	ld hl, $000b
	add hl, bc
	ld a, [wcf63]
	and $e
	sla a
	pop de
	add e
	ld [hl], a
	ld hl, $0003
	add hl, bc
	ld [hl], $0
	ld hl, $000c
	add hl, bc
	ld [hl], $10
	ret
; 4e80c

Function4e80c: ; 4e80c
	push bc
	callab Function8cf69
	ld a, [$ff9b]
	and $e
	srl a
	inc a
	inc a
	and $7
	ld b, a
	ld hl, Sprites + 3
	ld c, $28
.asm_4e823
	ld a, [hl]
	or b
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_4e823
	pop bc
	call DelayFrame
	ret
; 4e831

EvolutionGFX:
INCBIN "gfx/evo/bubble_large.2bpp"

INCBIN "gfx/evo/bubble.2bpp"
Function4e881: ; 4e881
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call Functione51
	call Functione58
	ld hl, VBGMap0
	ld bc, $400
	ld a, $7f
	call ByteFill
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	ld hl, UnknownText_0x4e8bd
	call PrintText
	call Function3200
	call Function32f9
	ret
; 4e8bd

UnknownText_0x4e8bd: ; 0x4e8bd
	; SAVING RECORD<...> DON'T TURN OFF!
	text_jump UnknownText_0x1bd39e
	db "@"
; 0x4e8c2

Function4e8c2: ; 4e8c2
	call WhiteBGMap
	call ClearTileMap
	call ClearSprites
	call DisableLCD
	call Functione51
	call Functione58
	ld hl, VBGMap0
	ld bc, $400
	ld a, $7f
	call ByteFill
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	ld hl, wd000
	ld c, $40
.asm_4e8ee
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	dec c
	jr nz, .asm_4e8ee
	xor a
	ld [hSCY], a
	ld [hSCX], a
	call EnableLCD
	call Function3200
	call Function32f9
	ret
; 4e906

Function4e906: ; 4e906
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	ld hl, w6_d000
	ld bc, $400
	ld a, $7f
	call ByteFill
	ld hl, VBGMap0
	ld de, w6_d000
	ld b, $0
	ld c, $40
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret
; 4e929

Function4e929: ; 4e929
	ld h, b
	ld l, c
	call Function4e930
	ld c, a
	ret
; 4e930

Function4e930: ; 4e930
	ld a, [hli]
	xor [hl]
	ld c, a
	jr z, .asm_4e941
	srl c
	srl c
.asm_4e939
	srl c
	ld a, c
	cp MaleTrainersEnd - MaleTrainers - 1
	jr nc, .asm_4e939
	inc c
.asm_4e941
	ld a, [de]
	cp $1
	ld hl, MaleTrainers
	jr nz, .asm_4e958
	ld hl, FemaleTrainers
	ld a, c
	and a
	jr z, .asm_4e958
.asm_4e950
	srl c
	ld a, c
	cp FemaleTrainersEnd - FemaleTrainers - 1
	jr nc, .asm_4e950
	inc c
.asm_4e958
	ld b, $0
	add hl, bc
	ld a, [hl]
	ret
; 4e95d

MaleTrainers: ; 4e95d
	db BURGLAR
	db YOUNGSTER
	db SCHOOLBOY
	db BIRD_KEEPER
	db POKEMANIAC
	db GENTLEMAN
	db BUG_CATCHER
	db FISHER
	db SWIMMERM
	db SAILOR
	db SUPER_NERD
	db GUITARIST
	db HIKER
	db FIREBREATHER
	db BLACKBELT_T
	db PSYCHIC_T
	db CAMPER
	db COOLTRAINERM
	db BOARDER
	db JUGGLER
	db POKEFANM
	db OFFICER
	db SAGE
	db BIKER
	db SCIENTIST
MaleTrainersEnd:
; 4e976

FemaleTrainers: ; 4e976
	db MEDIUM
	db LASS
	db BEAUTY
	db SKIER
	db TEACHER
	db SWIMMERF
	db PICNICKER
	db KIMONO_GIRL
	db POKEFANF
	db COOLTRAINERF
FemaleTrainersEnd:
; 4e980

Function4e980: ; 4e980
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	call Function4e998
	ld a, rSCX - $ff00
	ld [hLCDStatCustom], a
	call Function4e9ab
	xor a
	ld [hLCDStatCustom], a
	pop af
	ld [rSVBK], a
	ret
; 4e998

Function4e998: ; 4e998
	call Function4e9e5
	ld a, $90
	ld [hSCX], a
	ld a, $e4
	call DmgToCgbBGPals
	ld de, $e4e4
	call DmgToCgbObjPals
	ret
; 4e9ab

Function4e9ab: ; 4e9ab
	ld d, $90
	ld e, $72
	ld a, $48
	inc a
.asm_4e9b2
	push af
.asm_4e9b3
	ld a, [rLY]
	cp $60
	jr c, .asm_4e9b3
	ld a, d
	ld [hSCX], a
	call Function4e9f1
	inc e
	inc e
	dec d
	dec d
	pop af
	push af
	cp $1
	jr z, .asm_4e9ce
	push de
	call Function4e9d6
	pop de
.asm_4e9ce
	call DelayFrame
	pop af
	dec a
	jr nz, .asm_4e9b2
	ret
; 4e9d6

Function4e9d6: ; 4e9d6
	ld hl, Sprites + 1
	ld c, $12
	ld de, $0004
.asm_4e9de
	dec [hl]
	dec [hl]
	add hl, de
	dec c
	jr nz, .asm_4e9de
	ret
; 4e9e5

Function4e9e5: ; 4e9e5
	ld hl, LYOverrides
	ld a, $90
	ld bc, $0090
	call ByteFill
	ret
; 4e9f1

Function4e9f1: ; 4e9f1
	ld hl, LYOverrides
	ld a, d
	ld c, $3e
.asm_4e9f7
	ld [hli], a
	dec c
	jr nz, .asm_4e9f7
	ld a, e
	ld c, $22
.asm_4e9fe
	ld [hli], a
	dec c
	jr nz, .asm_4e9fe
	xor a
	ld c, $30
.asm_4ea05
	ld [hli], a
	dec c
	jr nz, .asm_4ea05
	ret
; 4ea0a

Function4ea0a: ; 4ea0a
	ld a, c
	push af
	call SpeechTextBox
	;call MobileTextBorder
	pop af
	dec a
	ld bc, $000c
	ld hl, wdc1a
	call AddNTimes
	ld de, wcd53
	ld bc, $000c
	ld a, $5
	call FarCopyWRAM
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld bc, wcd53
	decoord 1, 14
	callba Function11c0c6
	pop af
	ld [rSVBK], a
	ld c, $b4
	call DelayFrames
	ret
; 4ea44

CheckBattleScene: ; 4ea44
; Return carry if battle scene is turned off.

	ld a, 0
	ld hl, wLinkMode
	call GetFarWRAMByte
	cp 4
	jr z, .mobile
	ld a, [Options]
	bit BATTLE_SCENE, a
	jr nz, .off
	and a
	ret

.mobile
	ld a, [wcd2f]
	and a
	jr nz, .asm_4ea72
	ld a, $4
	call GetSRAMBank
	ld a, [$a60c]
	ld c, a
	call CloseSRAM
	ld a, c
	bit 0, c
	jr z, .off
	and a
	ret

.asm_4ea72
	ld a, $5
	ld hl, wdc00
	call GetFarWRAMByte
	bit 0, a
	jr z, .off
	and a
	ret

.off
	scf
	ret
; 4ea82

INCLUDE "misc/gbc_only.asm"

INCLUDE "event/poke_seer.asm"
SECTION "bank14", ROMX, BANK[$14]

Function50000: ; 50000
	call Function2ed3 ; disables overworld sprite updating?
	xor a
	ld [PartyMenuActionText], a
	call WhiteBGMap
	call Function5003f
	call WaitBGMap
	call Function32f9
	call DelayFrame
	call PartyMenuSelect
	call Function2b74
	ret
; 5001d

Function5001d: ; 5001d
	ld a, b
	ld [PartyMenuActionText], a
	call Function2ed3
	call WhiteBGMap
	call Function5003f
	call WaitBGMap
	ld b, $a
	call GetSGBLayout
	call Function32f9
	call DelayFrame
	call PartyMenuSelect
	call Function2b74
	ret
; 5003f

Function5003f: ; 5003f
	call Function5004f
	call Function50405
	call Function503e0
	call WritePartyMenuTilemap
	call PrintPartyMenuText
	ret
; 5004f

Function5004f: ; 5004f
	call Functione58
	callab InitPartyMenuPalettes
	callab Function8e814
	ret
; 5005f

WritePartyMenuTilemap: ; 0x5005f
	ld hl, Options
	ld a, [hl]
	push af
	set 4, [hl] ; Disable text delay
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, " "
	call ByteFill ; blank the tilemap
	call Function50396 ; This reads from a pointer table???
.asm_50077
	ld a, [hli]
	cp $ff
	jr z, .asm_50084 ; 0x5007a $8
	push hl
	ld hl, Jumptable_50089
	rst JumpTable
	pop hl
	jr .asm_50077 ; 0x50082 $f3
.asm_50084
	pop af
	ld [Options], a
	ret
; 0x50089

Jumptable_50089: ; 50089
	dw Function5009b
	dw Function500cf
	dw Function50138
	dw Function50176
	dw Function501b2
	dw Function501e0
	dw Function5022f
	dw Function502b1
	dw Function50307
; 5009b

Function5009b: ; 5009b
	hlcoord 3, 1
	ld a, [PartyCount]
	and a
	jr z, .asm_500bf
	ld c, a
	ld b, $0
.asm_500a7
	push bc
	push hl
	push hl
	ld hl, PartyMonNicknames
	ld a, b
	call GetNick
	pop hl
	call PlaceString
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_500a7
.asm_500bf
	dec hl
	dec hl
	ld de, String_500c8
	call PlaceString
	ret
; 500c8

String_500c8: ; 500c8
	db "CANCEL@"
; 500cf

Function500cf: ; 500cf
	xor a
	ld [wcda9], a
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	hlcoord 11, 2
.asm_500de
	push bc
	push hl
	call Function50389
	jr z, .asm_50103
	push hl
	call Function50117
	pop hl
	ld d, $6
	ld b, $0
	call DrawHPBar
	ld hl, wcd9b
	ld a, [wcda9]
	ld c, a
	ld b, $0
	add hl, bc
	call SetHPPal
	ld b, $fc
	call GetSGBLayout
.asm_50103
	ld hl, wcda9
	inc [hl]
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_500de
	ld b, $a
	call GetSGBLayout
	ret
; 50117

Function50117: ; 50117
	ld a, b
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1HP
	call AddNTimes
	ld a, [hli]
	or [hl]
	jr nz, .asm_50129
	xor a
	ld e, a
	ld c, a
	ret

.asm_50129
	dec hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	predef Functionc699
	ret
; 50138

Function50138: ; 50138
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, $0
	hlcoord 13, 1
.asm_50143
	push bc
	push hl
	call Function50389
	jr z, .asm_5016b
	push hl
	ld a, b
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1HP
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	push de
	ld bc, $0203
	call PrintNum
	pop de
	ld a, $f3
	ld [hli], a
	inc de
	inc de
	ld bc, $0203
	call PrintNum
.asm_5016b
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50143
	ret
; 50176

Function50176: ; 50176
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 8, 2
.asm_50181
	push bc
	push hl
	call Function50389
	jr z, .asm_501a7
	push hl
	ld a, b
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Level
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	cp 100 ; This is distinct from MAX_LEVEL.
	jr nc, .asm_501a1
	ld a, LV_CHAR
	ld [hli], a
	ld bc, $4102
.asm_501a1
	ld bc, $4103
	call PrintNum
.asm_501a7
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50181
	ret
; 501b2

Function501b2: ; 501b2
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 5, 2
.asm_501bd
	push bc
	push hl
	call Function50389
	jr z, .asm_501d5
	push hl
	ld a, b
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Status
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	call Function50d0a
.asm_501d5
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_501bd
	ret
; 501e0

Function501e0: ; 501e0
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.asm_501eb
	push bc
	push hl
	call Function50389
	jr z, .asm_5020a
	push hl
	ld hl, PartySpecies
	ld e, b
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [CurPartySpecies], a
	predef CanLearnTMHMMove
	pop hl
	call Function50215
	call PlaceString
.asm_5020a
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_501eb
	ret
; 50215

Function50215: ; 50215
	ld a, c
	and a
	jr nz, .asm_5021d
	ld de, String_50226
	ret

.asm_5021d
	ld de, String_50221
	ret
; 50221

String_50221: ; 50221
	db "ABLE@"
; 50226

String_50226: ; 50226
	db "NOT ABLE@"
; 5022f

Function5022f: ; 5022f
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.asm_5023a
	push bc
	push hl
	call Function50389
	jr z, .asm_5025d
	push hl
	ld a, b
	ld bc, PartyMon2 - PartyMon1
	ld hl, PartyMon1Species
	call AddNTimes
	ld a, [hl]
	dec a
	ld e, a
	ld d, 0
	ld hl, EvosAttacksPointers
	add hl, de
	add hl, de
	call Function50268
	pop hl
	call PlaceString
.asm_5025d
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_5023a
	ret
; 50268

Function50268: ; 50268
	ld de, StringBuffer1
	ld a, BANK(EvosAttacksPointers)
	ld bc, 2
	call FarCopyBytes
	ld hl, StringBuffer1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, StringBuffer1
	ld a, BANK(EvosAttacks)
	ld bc, $a
	call FarCopyBytes
	ld hl, StringBuffer1
.asm_50287
	ld a, [hli]
	and a
	jr z, .asm_5029f
	inc hl
	inc hl
	cp EVOLVE_ITEM
	jr nz, .asm_50287
	dec hl
	dec hl
	ld a, [CurItem]
	cp [hl]
	inc hl
	inc hl
	jr nz, .asm_50287
	ld de, String_502a3
	ret

.asm_5029f
	ld de, String_502a8
	ret
; 502a3

String_502a3: ; 502a3
	db "ABLE@"
; 502a8

String_502a8: ; 502a8
	db "NOT ABLE@"
; 502b1

Function502b1: ; 502b1
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 2
.asm_502bc
	push bc
	push hl
	call Function50389
	jr z, .asm_502e3
	ld [CurPartySpecies], a
	push hl
	ld a, b
	ld [CurPartyMon], a
	xor a
	ld [MonType], a
	call GetGender
	ld de, String_502fe
	jr c, .asm_502df
	ld de, String_502ee
	jr nz, .asm_502df
	ld de, String_502f5
.asm_502df
	pop hl
	call PlaceString
.asm_502e3
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_502bc
	ret
; 502ee

String_502ee: ; 502ee
	db "♂<...>MALE@"
; 502f5

String_502f5: ; 502f5
	db "♀<...>FEMALE@"
; 502fe

String_502fe: ; 502fe
	db "<...>UNKNOWN@"
; 50307

Function50307: ; 50307
	ld a, [PartyCount]
	and a
	ret z
	ld c, a
	ld b, 0
	hlcoord 12, 1
.asm_50312
	push bc
	push hl
	ld de, String_50372
	call PlaceString
	pop hl
	ld de, $0028
	add hl, de
	pop bc
	inc b
	dec c
	jr nz, .asm_50312
	ld a, l
	ld e, $b
	sub e
	ld l, a
	ld a, h
	sbc $0
	ld h, a
	ld de, String_50379
	call PlaceString
	ld b, $3
	ld c, $0
	ld hl, DefaultFlypoint
	ld a, [hl]
.asm_5033b
	push hl
	push bc
	hlcoord 12, 1
.asm_50340
	and a
	jr z, .asm_5034a
	ld de, $0028
	add hl, de
	dec a
	jr .asm_50340

.asm_5034a
	ld de, String_5036b
	push hl
	call PlaceString
	pop hl
	pop bc
	push bc
	push hl
	ld a, c
	ld hl, Strings_50383
	call GetNthString
	ld d, h
	ld e, l
	pop hl
	call PlaceString
	pop bc
	pop hl
	inc hl
	ld a, [hl]
	inc c
	dec b
	ret z
	jr .asm_5033b
; 5036b

String_5036b: ; 5036b
	db " ばんめ  @" ; Place
; 50372

String_50372: ; 50372
	db "さんかしない@" ; Cancel
; 50379

String_50379: ; 50379
	db "けってい  やめる@" ; Quit
; 50383

Strings_50383: ; 50383
	db "1@", "2@", "3@" ; 1st, 2nd, 3rd
; 50389

Function50389: ; 50389
	ld a, PartySpecies % $100
	add b
	ld e, a
	ld a, PartySpecies / $100
	adc 0
	ld d, a
	ld a, [de]
	cp EGG
	ret
; 50396

Function50396: ; 50396
	ld a, [PartyMenuActionText]
	and $f0
	jr nz, .asm_503ae
	ld a, [PartyMenuActionText]
	and $f
	ld e, a
	ld d, 0
	ld hl, Unknown_503b2
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.asm_503ae
	ld hl, Unknown_503c6
	ret
; 503b2

Unknown_503b2: ; 503b2
	dw Unknown_503c6
	dw Unknown_503c6
	dw Unknown_503c6
	dw Unknown_503cc
	dw Unknown_503c6
	dw Unknown_503d1
	dw Unknown_503d6
	dw Unknown_503d6
	dw Unknown_503c6
	dw Unknown_503db
; 503c6

Unknown_503c6: db 0, 1, 2, 3, 4, $ff
Unknown_503cc: db 0, 5, 3, 4, $ff
Unknown_503d1: db 0, 6, 3, 4, $ff
Unknown_503d6: db 0, 7, 3, 4, $ff
Unknown_503db: db 0, 8, 3, 4, $ff
; 503e0

Function503e0: ; 503e0
	ld hl, PartyCount
	ld a, [hli]
	and a
	ret z
	ld c, a
	xor a
	ld [$ffb0], a
.asm_503ea
	push bc
	push hl
	ld hl, Function8e83f
	ld a, BANK(Function8e83f)
	ld e, $0
	rst FarCall
	ld a, [$ffb0]
	inc a
	ld [$ffb0], a
	pop hl
	pop bc
	dec c
	jr nz, .asm_503ea
	callab Function8cf69
	ret
; 50405

Function50405: ; 50405
	xor a
	ld [wd0e3], a
	ld de, Unknown_5044f
	call Function1bb1 ;load some menu data from de into current and reset cursor data
	ld a, [PartyCount]
	inc a
	ld [wcfa3], a ;load partycount into max vertical pos
	dec a
	ld b, a
	ld a, [wd0d8]
	and a
	jr z, .asm_50422  ;if cursor memory = 0, a = 1
	inc b
	cp b
	jr c, .asm_50424 ;if cursor memory > partycount, a = 1, else a = cursor memory
.asm_50422
	ld a, $1
.asm_50424
	ld [wcfa9], a ;load it into  cursor positon
	ld a, $7 ;$3 SELECTADD If I want it to not recognise select, change this
	ld [wcfa8], a ;load 3 into loop exit (a and b)
	ret
; 5042d

Function5042d: ; 0x5042d ;load menu data for party switch and set cursor up
	ld de, Unknown_5044f
	call Function1bb1 ;load some menu data from de into current and reset cursor data
	ld a, [PartyCount]
	ld [wcfa3], a ;load partycount into max vertical pos
	ld b, a
	ld a, [wd0d8] ;cursor memory
	and a
	jr z, .asm_50444 ;if cursor memory = 0, a = 1
	inc b ;if cursor memory > partycount +1, a = 1, else a = cursor memory
	cp b
	jr c, .asm_50446
.asm_50444
	ld a, $1
.asm_50446
	ld [wcfa9], a ;load it into  cursor positon
	ld a, $3
	ld [wcfa8], a ;load 3 into loop exit (a and b)
	ret
; 5044f (14:444f)

Unknown_5044f: ; 5044f
; cursor y
; cursor x
; vertical list length
; horizontal list legnth
; bit 6: animate sprites  bit 5: wrap around
; ?
; distance between items (hi: y, lo: x)
; allowed buttons (mask)

	db $01, $00, $00, $01, $60, $00, $20, $00
; 50457

PartyMenuSelect: ; 0x50457 make menu selection, ret c if cancelling, set curpartymon and curspecies if not
; sets carry if exitted menu.

	call Function1bc9 ;place and update cursor, loop until allowed input is pressed, update joylsast
	call Function1bee ;load white cursor into cursor location
	ld a, [PartyCount]
	inc a
	ld b, a
	ld a, [wcfa9]
	cp b
	jr z, .exitmenu ; CANCEL If vert menu selection = partycount+1, cancel
	ld [wd0d8], a ;load selection into ??
	ld a, [$ffa9]
	ld b, a
	bit 1, b
	jr nz, .exitmenu ; If b button pressed, exit
	ld a, [wcfa9]
	dec a
	ld [CurPartyMon], a ;curpartymon = selection
	ld c, a
	ld b, $0
	ld hl, PartySpecies
	add hl, bc
	ld a, [hl]
	ld [CurPartySpecies], a ;cur species = selectonmon species
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	call WaitSFX
	and a
	ret

.exitmenu
	ld de, SFX_READ_TEXT_2
	call PlaySFX
	call WaitSFX
	scf
	ret
; 0x5049a

PrintPartyMenuText: ; 5049a
	hlcoord 0, 14
	ld bc, $0212
	call TextBox
	ld a, [PartyCount]
	and a
	jr nz, .haspokemon
	ld de, YouHaveNoPKMNString
	jr .gotstring

.haspokemon ; 504ae
	ld a, [PartyMenuActionText]
	and $f ; drop high nibble
	ld hl, PartyMenuStrings
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
.gotstring ; 504be
	ld a, [Options]
	push af
	set 4, a ; disable text delay
	ld [Options], a
	hlcoord 1, 16 ; Coord
	call PlaceString
	pop af
	ld [Options], a
	ret
; 0x504d2

PartyMenuStrings: ; 0x504d2
	dw ChooseAMonString
	dw UseOnWhichPKMNString
	dw WhichPKMNString
	dw TeachWhichPKMNString
	dw MoveToWhereString
	dw UseOnWhichPKMNString
	dw ChooseAMonString ; Probably used to be ChooseAFemalePKMNString
	dw ChooseAMonString ; Probably used to be ChooseAMalePKMNString
	dw ToWhichPKMNString

ChooseAMonString: ; 0x504e4
	db "Choose a #MON.@"
UseOnWhichPKMNString: ; 0x504f3
	db "Use on which ", $e1, $e2, "?@"
WhichPKMNString: ; 0x50504
	db "Which ", $e1, $e2, "?@"
TeachWhichPKMNString: ; 0x5050e
	db "Teach which ", $e1, $e2, "?@"
MoveToWhereString: ; 0x5051e
	db "Move to where?@"
ChooseAFemalePKMNString: ; 0x5052d  ; UNUSED
	db "Choose a ♀", $e1, $e2, ".@"
ChooseAMalePKMNString: ; 0x5053b    ; UNUSED
	db "Choose a ♂", $e1, $e2, ".@"
ToWhichPKMNString: ; 0x50549
	db "To which ", $e1, $e2, "?@"
YouHaveNoPKMNString: ; 0x50556
	db "You have no ", $e1, $e2, "!@"
Function50566: ; 50566
	ld a, [CurPartyMon]
	ld hl, PartyMonNicknames
	call GetNick
	ld a, [PartyMenuActionText]
	and $f
	ld hl, Unknown_5057b
	call Function505c1
	ret
; 5057b

Unknown_5057b: ; 5057b
	dw UnknownText_0x50594
	dw UnknownText_0x5059e
	dw UnknownText_0x505a3
	dw UnknownText_0x505a8
	dw UnknownText_0x50599
	dw UnknownText_0x5058f
	dw UnknownText_0x505ad
	dw UnknownText_0x505b2
	dw UnknownText_0x505b7
	dw UnknownText_0x505bc
; 5058f

UnknownText_0x5058f: ; 0x5058f
	; recovered @ HP!
	text_jump UnknownText_0x1bc0a2
	db "@"
; 0x50594

UnknownText_0x50594: ; 0x50594
	; 's cured of poison.
	text_jump UnknownText_0x1bc0bb
	db "@"
; 0x50599

UnknownText_0x50599: ; 0x50599
	; 's rid of paralysis.
	text_jump UnknownText_0x1bc0d2
	db "@"
; 0x5059e

UnknownText_0x5059e: ; 0x5059e
	; 's burn was healed.
	text_jump UnknownText_0x1bc0ea
	db "@"
; 0x505a3

UnknownText_0x505a3: ; 0x505a3
	; was defrosted.
	text_jump UnknownText_0x1bc101
	db "@"
; 0x505a8

UnknownText_0x505a8: ; 0x505a8
	; woke up.
	text_jump UnknownText_0x1bc115
	db "@"
; 0x505ad

UnknownText_0x505ad: ; 0x505ad
	; 's health returned.
	text_jump UnknownText_0x1bc123
	db "@"
; 0x505b2

UnknownText_0x505b2: ; 0x505b2
	; is revitalized.
	text_jump UnknownText_0x1bc13a
	db "@"
; 0x505b7

UnknownText_0x505b7: ; 0x505b7
	; grew to level @ !@ @
	text_jump UnknownText_0x1bc14f
	db "@"
; 0x505bc

UnknownText_0x505bc: ; 0x505bc
	; came to its senses.
	text_jump UnknownText_0x1bc16e
	db "@"
; 0x505c1

Function505c1: ; 505c1
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [Options]
	push af
	set 4, a
	ld [Options], a
	call PrintText
	pop af
	ld [Options], a
	ret
; 505da

OverworldPoisonDamage:: ; 505da
	; Poison flags stored in 7 bytes at d03e (EngineBuffer1)
	; d03e: cumulative | d03f - d045: each party mon separately
	; bit 0: took poison damage
	; bit 1: survived the poisoning
	ld a, [PartyCount]
	and a
	jr z, .not_fainted
	xor a
	ld c, 7
	ld hl, EngineBuffer1
.reset
	ld [hli], a
	dec c
	jr nz, .reset
	xor a
	ld [CurPartyMon], a
.loop
	call Function5062e
	jr nc, .not_psn
	ld a, [CurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wd03f
	add hl, de
	ld [hl], c
	ld a, [EngineBuffer1]
	or c
	ld [EngineBuffer1], a
.not_psn
	ld a, [PartyCount]
	ld hl, CurPartyMon
	inc [hl]
	cp [hl]
	jr nz, .loop
	ld a, [EngineBuffer1]
	and $2
	jr nz, .fainted
	ld a, [EngineBuffer1]
	and $1
	jr z, .not_fainted
	call Function50658
	xor a
	ret

.fainted
	ld a, BANK(UnknownScript_0x50669)
	ld hl, UnknownScript_0x50669
	call CallScript
	scf
	ret

.not_fainted
	xor a
	ret
; 5062e

Function5062e: ; 5062e
	ld a, PartyMon1Status - PartyMon1
	call GetPartyParamLocation
	ld a, [hl]
	and 1 << PSN
	ret z
	ld a, PartyMon1HP - PartyMon1
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	or c
	ret z
	dec bc
	ld [hl], c
	dec hl
	ld [hl], b
	ld a, b
	or c
	jr nz, .not_fainted
	; Survive with 1 HP
	inc hl
	inc [hl]
	ld a, PartyMon1Status - PartyMon1
	call GetPartyParamLocation
	ld [hl], 0
	ld c, 2
	scf
	ret

.not_fainted
	ld c, 1
	scf
	ret
; 50658

Function50658: ; 50658
	ld de, SFX_POISON
	call PlaySFX
	ld b, $2
	predef Functioncbcdd
	call DelayFrame
	ret
; 50669

UnknownScript_0x50669: ; 50669
	callasm Function50658
	loadfont
	callasm Function5067b
	; iffalse UnknownScript_0x50677
	closetext
	end
; 50677

; UnknownScript_0x50677: ; 50677
	; farjump UnknownScript_0x124c8
; 5067b

Function5067b: ; 5067b
	xor a
	ld [CurPartyMon], a
	ld de, EngineBuffer2
.loop
	push de
	ld a, [de]
	and 2
	jr z, .dont_inform_survival
	; ld c, 7
	; callba ChangeHappiness
	callba GetPartyNick
	ld hl, PoisonSurviveText
	call PrintText
.dont_inform_survival
	pop de
	inc de
	ld hl, CurPartyMon
	inc [hl]
	ld a, [PartyCount]
	cp [hl]
	jr nz, .loop
	; predef CheckAnyPartyMonAlive
	; ld a, d
	; ld [ScriptVar], a
	ret
; 506b2

PoisonSurviveText: ; 506b2
	text_jump UnknownText_0x1c0acc
	db "@"
; 506b7

; PoisonWhiteOutText: ; 506b7
	; text_jump UnknownText_0x1c0ada
	; db "@"
; ; 506bc

Function506bc: ; 506bc
	ld hl, UnknownScript_0x506c8
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret
; 506c8

UnknownScript_0x506c8: ; 0x506c8 SWEET SCENT
	reloadmappart
	special UpdateTimePals
	callasm Functioncd1d
	writetext UnknownText_0x50726
	waitbutton
	closetext
	farscall FieldMovePokepicScript
	loadfont
	callasm Function506ef
	iffalse UnknownScript_0x506e9
	checkflag ENGINE_BUG_CONTEST_TIMER
	iftrue UnknownScript_0x506e5
	battlecheck
	startbattle
	returnafterbattle
	end
; 0x506e5

UnknownScript_0x506e5: ; 0x506e5
	farjump UnknownScript_0x135eb
; 0x506e9

UnknownScript_0x506e9: ; 0x506e9
	writetext UnknownText_0x5072b
	waitbutton
	closetext
	end
; 0x506ef

Function506ef: ; 506ef probably sweet scent
	callba Function97cfd
	jr nc, .asm_5071e
	ld hl, StatusFlags2 ;check bug catching timer
	bit 2, [hl]
	jr nz, .asm_50712 ; if on, check bug contest encounter
	callba Function2a111 ;b = encounter chance
	ld a, b
	and a
	jr z, .asm_5071e ;if zero jump ahead
	callba Function2a14f ; check for normal encounters
	jr nz, .asm_5071e
	jr .asm_50718

.asm_50712
	callba Function97d31
.asm_50718
	ld a, $1
	ld [ScriptVar], a
	ret

.asm_5071e
	xor a
	ld [ScriptVar], a
	ld [BattleType], a
	ret
; 50726

UnknownText_0x50726: ; 0x50726
	; used SWEET SCENT!
	text_jump UnknownText_0x1c0b03
	db "@"
; 0x5072b

UnknownText_0x5072b: ; 0x5072b
	; Looks like there's nothing here<...>
	text_jump UnknownText_0x1c0b1a
	db "@"
; 0x50730

_Squirtbottle: ; 50730
	ld hl, UnknownScript_0x5073c
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret
; 5073c

UnknownScript_0x5073c: ; 0x5073c
	reloadmappart
	special UpdateTimePals
	callasm Function50753
	iffalse UnknownScript_0x5074b
	farjump WateredWeirdTreeScript
; 0x5074b

UnknownScript_0x5074b: ; 0x5074b
	jumptext UnknownText_0x5074e
; 0x5074e

UnknownText_0x5074e: ; 0x5074e
	; sprinkled water. But nothing happened<...>
	text_jump UnknownText_0x1c0b3b
	db "@"
; 0x50753

Function50753: ; 50753
	ld a, [MapGroup]
	cp GROUP_ROUTE_36
	jr nz, .asm_50774
	ld a, [MapNumber]
	cp MAP_ROUTE_36
	jr nz, .asm_50774
	callba Functioncf0d
	jr c, .asm_50774
	ld a, d
	cp 23
	jr nz, .asm_50774
	ld a, $1
	ld [ScriptVar], a
	ret

.asm_50774
	xor a
	ld [ScriptVar], a
	ret
; 50779

_CardKey: ; 50779
	ld a, [MapGroup]
	cp GROUP_RADIO_TOWER_3F
	jr nz, .asm_507a9
	ld a, [MapNumber]
	cp MAP_RADIO_TOWER_3F
	jr nz, .asm_507a9
	ld a, [PlayerDirection]
	and $c
	cp UP << 2
	jr nz, .asm_507a9
	call GetFacingTileCoord
	ld a, d
	cp 18
	jr nz, .asm_507a9
	ld a, e
	cp 6
	jr nz, .asm_507a9
	ld hl, UnknownScript_0x507af
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret

.asm_507a9
	ld a, $0
	ld [wd0ec], a
	ret
; 507af

UnknownScript_0x507af: ; 0x507af
	closetext
	farjump MapRadioTower3FSignpost2Script
; 0x507b4

_BasementKey: ; 507b4
	ld a, [MapGroup]
	cp GROUP_WAREHOUSE_ENTRANCE
	jr nz, .asm_507db
	ld a, [MapNumber]
	cp MAP_WAREHOUSE_ENTRANCE
	jr nz, .asm_507db
	call GetFacingTileCoord
	ld a, d
	cp 22
	jr nz, .asm_507db
	ld a, e
	cp 10
	jr nz, .asm_507db
	ld hl, UnknownScript_0x507e1
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret

.asm_507db
	ld a, $0
	ld [wd0ec], a
	ret
; 507e1

UnknownScript_0x507e1: ; 0x507e1
	closetext
	farjump MapWarehouseEntranceSignpost0Script
; 0x507e6

_SacredAsh: ; 507e6
	ld a, $0
	ld [wd0ec], a
	call CheckAnyFaintedMon
	ret nc
	ld hl, UnknownScript_0x50821
	call QueueScript
	ld a, $1
	ld [wd0ec], a
	ret
; 507fb

CheckAnyFaintedMon: ; 507fb
	ld de, PartyMon2 - PartyMon1
	ld bc, PartySpecies
	ld hl, PartyMon1HP
	ld a, [PartyCount]
	and a
	ret z
.loop
	push af
	push hl
	ld a, [bc]
	inc bc
	cp EGG
	jr z, .next
	ld a, [hli]
	or [hl]
	jr z, .asm_5081d
.next
	pop hl
	add hl, de
	pop af
	dec a
	jr nz, .loop
	xor a
	ret

.asm_5081d
	pop hl
	pop af
	scf
	ret
; 50821

UnknownScript_0x50821: ; 0x50821
; Sacred Ash
	special HealParty
	reloadmappart
	playsound SFX_WARP_TO
	special Function8c084
	special Function8c079
	special Function8c084
	special Function8c079
	special Function8c084
	special Function8c079
	waitsfx
	writetext UnknownText_0x50845
	playsound SFX_CAUGHT_MON
	waitsfx
	waitbutton
	closetext
	end
; 0x50845

UnknownText_0x50845: ; 0x50845
	; 's #MON were all healed!
	text_jump UnknownText_0x1c0b65
	db "@"
; 0x5084a

Function5084a: ; 5084a
	ld a, [CurPartyMon]
	ld e, a
	call Function508d5
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld a, [MonType]
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	and a
	jr z, .asm_5087b
	ld hl, OTPartyMon1Species
	ld bc, OTPartyMon2 - OTPartyMon1
	cp $1
	jr z, .asm_5087b
	ld bc, $0020
	callab Functione5bb
	jr .asm_5088a

.asm_5087b
	ld a, [CurPartyMon]
	call AddNTimes
	ld de, TempMonSpecies
	ld bc, PartyMon2 - PartyMon1
	call CopyBytes
.asm_5088a
	ret
; 5088b

Function5088b: ; 5088b
	ld bc, wd018
	jr Function50893
; 50890

Function50890: ; 50890
	ld bc, TempMon
	; fallthrough
; 50893

Function50893: ; 50893
	ld hl, TempMonLevel - TempMon
	add hl, bc
	ld a, [hl]
	ld [CurPartyLevel], a
	ld hl, TempMonMaxHP - TempMon
	add hl, bc
	ld d, h
	ld e, l
	ld hl, TempMonExp + 2 - TempMon
	add hl, bc
	push bc
	ld b, $1
	predef CalcPkmnStats
	pop bc
	ld hl, TempMonHP - TempMon
	add hl, bc
	ld d, h
	ld e, l
	ld a, [CurPartySpecies]
	cp EGG
	jr nz, .asm_508c1
	xor a
	ld [de], a
	inc de
	ld [de], a
	jr .asm_508cd

.asm_508c1
	push bc
	ld hl, TempMonMaxHP - TempMon
	add hl, bc
	ld bc, 2
	call CopyBytes
	pop bc
.asm_508cd
	ld hl, TempMonStatus - TempMon
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ret
; 508d5

Function508d5: ; 508d5
	ld a, [MonType]
	and a ; PARTYMON
	jr z, .asm_508e7
	cp OTPARTYMON
	jr z, .asm_508ec
	cp BOXMON
	jr z, .asm_508f1
	cp $3
	jr z, .asm_50900
	; WILDMON
.asm_508e7
	ld hl, PartySpecies
	jr .asm_50905

.asm_508ec
	ld hl, OTPartySpecies
	jr .asm_50905

.asm_508f1
	ld a, 1 ; BANK(sBoxSpecies)
	call GetSRAMBank
	ld hl, sBoxSpecies
	call .asm_50905
	call CloseSRAM
	ret

.asm_50900
	ld a, [wBreedMon1Species]
	jr .asm_50909

.asm_50905
	ld d, 0
	add hl, de
	ld a, [hl]
.asm_50909
	ld [CurPartySpecies], a
	ret
; 5090d

INCLUDE "text/types.asm"

Function50a28: ; 50a28
	ld hl, Strings50a42
	ld a, [TrainerClass]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, StringBuffer1
.copy
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copy
	ret
; 50a42

Strings50a42: ; 50a42
; Untranslated trainer class names from Red.

	dw .Youngster
	dw .BugCatcher
	dw .Lass
	dw OTClassName
	dw .JrTrainerM
	dw .JrTrainerF
	dw .Pokemaniac
	dw .SuperNerd
	dw OTClassName
	dw OTClassName
	dw .Burglar
	dw .Engineer
	dw .Jack
	dw OTClassName
	dw .Swimmer
	dw OTClassName
	dw OTClassName
	dw .Beauty
	dw OTClassName
	dw .Rocker
	dw .Juggler
	dw OTClassName
	dw OTClassName
	dw .Blackbelt
	dw OTClassName
	dw .ProfOak
	dw .Chief
	dw .Scientist
	dw OTClassName
	dw .Rocket
	dw .CooltrainerM
	dw .CooltrainerF
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName
	dw OTClassName

.Youngster    db "たんパン@"
.BugCatcher   db "むしとり@"
.Lass         db "ミニスカ@"
.JrTrainerM   db "ボーイ@"
.JrTrainerF   db "ガール@"
.Pokemaniac   db "マニア@"
.SuperNerd    db "りかけい@"
.Burglar      db "どろぼう@"
.Engineer     db "ォヤジ@"
.Jack         db "ジャック@"
.Swimmer      db "かいパン@"
.Beauty       db "おねえさん@"
.Rocker       db "グループ@"
.Juggler      db "ジャグラー@"
.Blackbelt    db "からて@"
.ProfOak      db "ォーキド@"
.Chief        db "チーフ@"
.Scientist    db "けんきゅういん@"
.Rocket       db "だんいん@"
.CooltrainerM db "エりート♂@"
.CooltrainerF db "エりート♀@"
; 50b0a

DrawPlayerHP: ; 50b0a
	ld a, $1
	jr DrawHP

DrawEnemyHP: ; 50b0e
	ld a, $2
DrawHP: ; 50b10
	ld [wWhichHPBar], a
	push hl
	push bc
	ld a, [MonType]
	cp BOXMON
	jr z, .asm_50b30
	ld a, [TempMonHP]
	ld b, a
	ld a, [TempMonHP + 1]
	ld c, a
; Any HP?

	or b
	jr nz, .asm_50b30
	xor a
	ld c, a
	ld e, a
	ld a, 6
	ld d, a
	jp .asm_50b4a

.asm_50b30
	ld a, [TempMonMaxHP]
	ld d, a
	ld a, [TempMonMaxHP + 1]
	ld e, a
	ld a, [MonType]
	cp BOXMON
	jr nz, .asm_50b41
	ld b, d
	ld c, e
.asm_50b41
	predef Functionc699
	ld a, 6
	ld d, a
	ld c, a
.asm_50b4a
	ld a, c
	pop bc
	ld c, a
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
; Print HP

	ld bc, $0015 ; move (1,1)
	add hl, bc
	ld de, TempMonHP
	ld a, [MonType]
	cp BOXMON
	jr nz, .asm_50b66
	ld de, TempMonMaxHP
.asm_50b66
	ld bc, $0203
	call PrintNum
	ld a, "/"
	ld [hli], a
; Print max HP

	ld de, TempMonMaxHP
	ld bc, $0203
	call PrintNum
	pop hl
	pop de
	ret
; 50b7b

PrintTempMonStats: ; 50b7b
; Print TempMon's stats at hl, with spacing bc.

	push bc
	push hl
	ld de, .StatNames
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, TempMonAttack
	ld bc, $0203
	call .PrintStat
	ld de, TempMonDefense
	call .PrintStat
	ld de, TempMonSpclAtk
	call .PrintStat
	ld de, TempMonSpclDef
	call .PrintStat
	ld de, TempMonSpeed
	jp PrintNum
; 50bab

.PrintStat: ; 50bab
	push hl
	call PrintNum
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret
; 50bb5

.StatNames: ; 50bb5
	db   "ATTACK"
	next "DEFENSE"
	next "SPCL.ATK"
	next "SPCL.DEF"
	next "SPEED"
	next "@"
; 50bdd

GetGender: ; 50bdd
; Return the gender of a given monster (CurPartyMon/CurOTMon/CurWildMon).
; When calling this function, a should be set to an appropriate MonType value.
; return values:
; a = 1: f = nc|nz; male
; a = 0: f = nc|z;  female
;        f = c:  genderless
; This is determined by comparing the Attack and Speed DVs
; with the species' gender ratio.
; Figure out what type of monster struct we're looking at.
; 0: PartyMon

	ld hl, PartyMon1DVs
	ld bc, PartyMon2 - PartyMon1
	ld a, [MonType]
	and a
	jr z, .PartyMon

; 1: OTPartyMon

	ld hl, OTPartyMon1DVs
	dec a
	jr z, .PartyMon

; 2: sBoxMon

	ld hl, sBoxMon1DVs
	ld bc, sBoxMon2 - sBoxMon1
	dec a
	jr z, .sBoxMon

; 3: Unknown

	ld hl, TempMonDVs
	dec a
	jr z, .DVs

; else: WildMon

	ld hl, EnemyMonDVs
	jr .DVs


; Get our place in the party/box.


.PartyMon
.sBoxMon
	ld a, [CurPartyMon]
	call AddNTimes


.DVs

; sBoxMon data is read directly from SRAM.

	ld a, [MonType]
	cp BOXMON
	ld a, 1
	call z, GetSRAMBank

; Attack DV

	ld a, [hli]
	and $f0
	ld b, a
; Speed DV

	ld a, [hl]
	and $f0
	swap a

; Put our DVs together.

	or b
	ld b, a
; Close SRAM if we were dealing with a sBoxMon.

	ld a, [MonType]
	cp BOXMON
	call z, CloseSRAM


; We need the gender ratio to do anything with this.

	push bc
	ld a, [CurPartySpecies]
	dec a
	ld hl, BaseData + BaseGender - CurBaseData
	ld bc, BaseData1 - BaseData
	call AddNTimes
	pop bc

	ld a, BANK(BaseData)
	call GetFarByte


; The higher the ratio, the more likely the monster is to be female.


	cp $ff
	jr z, .Genderless

	and a
	jr z, .Male

	cp $fe
	jr z, .Female

; Values below the ratio are male, and vice versa.

	cp b
	jr c, .Male

.Female
	xor a
	ret

.Male
	ld a, 1
	and a
	ret

.Genderless
	scf
	ret
; 50c50

Function50c50: ; 50c50
	ld a, [wd0eb]
	inc a
	ld c, a
	ld a, $4
	sub c
	ld b, a
	push hl
	ld a, [Buffer1]
	ld e, a
	ld d, $0
	ld a, $3e
	call Function50cc9
	ld a, b
	and a
	jr z, .asm_50c6f
	ld c, a
	ld a, $e3
	call Function50cc9
.asm_50c6f
	pop hl
	inc hl
	inc hl
	inc hl
	ld d, h
	ld e, l
	ld hl, TempMonMoves
	ld b, 0
.asm_50c7a
	ld a, [hli]
	and a
	jr z, .asm_50cc8
	push bc
	push hl
	push de
	ld hl, wcfa9
	ld a, [hl]
	push af
	ld [hl], b
	push hl
	callab Functionf8ec
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, TempMonPP - (TempMonMoves + 1)
	add hl, bc
	ld a, [hl]
	and $3f
	ld [StringBuffer1 + 4], a
	ld h, d
	ld l, e
	push hl
	ld de, StringBuffer1 + 4
	ld bc, $0102
	call PrintNum
	ld a, $f3
	ld [hli], a
	ld de, wd265
	ld bc, $0102
	call PrintNum
	pop hl
	ld a, [Buffer1]
	ld e, a
	ld d, 0
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .asm_50c7a
.asm_50cc8
	ret
; 50cc9

Function50cc9: ; 50cc9
.asm_50cc9
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, .asm_50cc9
	ret
; 50cd0

Function50cd0: ; 50cd0
.asm_50cd0
	ld [hl], $32
	inc hl
	ld [hl], $3e
	dec hl
	add hl, de
	dec c
	jr nz, .asm_50cd0
	ret
; 50cdb

Function50cdb: ; 50cdb
	push hl
	push hl
	ld hl, PartyMonNicknames
	ld a, [CurPartyMon]
	call GetNick
	pop hl
	call PlaceString
	call Function5084a
	pop hl
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_50d09
	push hl
	ld bc, $fff4
	add hl, bc
	ld b, $0
	call DrawEnemyHP
	pop hl
	ld bc, $0005
	add hl, bc
	push de
	call PrintLevel
	pop de
.asm_50d09
	ret
; 50d0a

Function50d0a: ; 50d0a
	push de
	inc de
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	pop de
	jr nz, Function50d2e
	push de
	ld de, FntString
	call Function50d25
	pop de
	ld a, $1
	and a
	ret
; 50d22

FntString: ; 50d22
	db "FNT@"
; 50d25

Function50d25: ; 50d25
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret
; 50d2e

Function50d2e: ; 50d2e
	push de
	ld a, [de]
	bit PSN, a
	jr z, .check_brn
	pop de
	inc de
	ld a, [de]
	and a
	dec de
	ld a, [de]
	push de
	ld de, ToxString
	jr nz, .asm_50d53
	ld de, PsnString
	jr .asm_50d53
.check_brn
	ld de, BrnString
	bit BRN, a
	jr nz, .asm_50d53
	ld de, FrzString
	bit FRZ, a
	jr nz, .asm_50d53
	ld de, ParString
	bit PAR, a
	jr nz, .asm_50d53
	ld de, SlpString
	and SLP
	jr z, .asm_50d59
.asm_50d53
	call Function50d25
	ld a, $1
	and a
.asm_50d59
	pop de
	ret
; 50d5b

SlpString: db "SLP@"
PsnString: db "PSN@"
ToxString: db "TOX@"
BrnString: db "BRN@"
FrzString: db "FRZ@"
ParString: db "PAR@"
; 50d6f

ListMoves: ; 50d6f
; List moves at hl, spaced every [Buffer1] tiles.

	ld de, wd25e
	ld b, $0
.asm_50d74
	ld a, [de]
	inc de
	and a
	jr z, .asm_50da7
	push de
	push hl
	push hl
	ld [CurSpecies], a
	ld a, MOVE_NAME
	ld [wcf61], a
	call GetName
	ld de, StringBuffer1
	pop hl
	push bc
	call PlaceString
	pop bc
	ld a, b
	ld [wd0eb], a
	inc b
	pop hl
	push bc
	ld a, [Buffer1]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	pop de
	ld a, b
	cp NUM_MOVES
	jr z, .asm_50db8
	jr .asm_50d74

.asm_50da7
	ld a, b
.asm_50da8
	push af
	ld [hl], "-"
	ld a, [Buffer1]
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	inc a
	cp NUM_MOVES
	jr nz, .asm_50da8
.asm_50db8
	ret
; 50db9

Function50db9: ; 50db9
	ld a, [wd263]
	cp $1
	jr nz, .asm_50dca
	ld hl, OTPartyCount
	ld de, OTPartyMonOT
	ld a, ENEMY_OT_NAME
	jr .asm_50dfc

.asm_50dca
	cp $4
	jr nz, .asm_50dd8
	ld hl, PartyCount
	ld de, PartyMonOT
	ld a, PARTY_OT_NAME
	jr .asm_50dfc

.asm_50dd8
	cp $5
	jr nz, .asm_50de6
	ld hl, OBPals + 8 * 6
	ld de, PokemonNames
	ld a, PKMN_NAME
	jr .asm_50dfc

.asm_50de6
	cp $2
	jr nz, .asm_50df4
	ld hl, NumItems
	ld de, ItemNames
	ld a, ITEM_NAME
	jr .asm_50dfc

.asm_50df4
	ld hl, OBPals + 8 * 6
	ld de, ItemNames
	ld a, ITEM_NAME
.asm_50dfc
	ld [wcf61], a
	ld a, l
	ld [wd100], a
	ld a, h
	ld [wd101], a
	ld a, e
	ld [wd102], a
	ld a, d
	ld [wd103], a
	ld bc, $67c1 ; XXX ItemAttributes?
	ld a, c
	ld [wd104], a
	ld a, b
	ld [wd105], a
	ret
; 50e1b

Function50e1b: ; 50e1b
	ld a, [TempMonSpecies]
	ld [CurSpecies], a
	call GetBaseData
	ld d, 1
.asm_50e26
	inc d
	ld a, d
	cp (MAX_LEVEL + 1) % $100
	jr z, .asm_50e45
	call Function50e47
	push hl
	ld hl, TempMonExp + 2
	ld a, [$ffb6]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [$ffb5]
	ld c, a
	ld a, [hld]
	sbc c
	ld a, [hMultiplicand]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, .asm_50e26
.asm_50e45
	dec d
	ret
; 50e47

Function50e47: ; 50e47
;d = level
; (a/b)*n**3 + c*n**2 + d*n - e
	ld a, d
	cp 2
	jp c, .zero_exp
	ld a, [BaseGrowthRate]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, GrowthRates
	add hl, bc
; Cube the level
	call .LevelSquared
	ld a, d
	ld [hMultiplier], a
	call Multiply
; Multiply by a
	ld a, [hl]
	and $f0
	swap a
	ld [hMultiplier], a
	call Multiply
; Divide by b
	ld a, [hli]
	and $f
	ld [hDivisor], a
	ld b, 4
	call Divide
; Push the cubic term to the stack
	ld a, [hQuotient + 0]
	push af
	ld a, [hQuotient + 1]
	push af
	ld a, [hQuotient + 2]
	push af
; Square the level and multiply by the lower 7 bits of c
	call .LevelSquared
	ld a, [hl]
	and $7f
	ld [hMultiplier], a
	call Multiply
; Push the absolute value of the quadratic term to the stack
	ld a, [hProduct + 1]
	push af
	ld a, [hProduct + 2]
	push af
	ld a, [hProduct + 3]
	push af
	ld a, [hli]
	push af
; Multiply the level by d
	xor a
	ld [hMultiplicand + 0], a
	ld [hMultiplicand + 1], a
	ld a, d
	ld [hMultiplicand + 2], a
	ld a, [hli]
	ld [hMultiplier], a
	call Multiply
; Subtract e
	ld b, [hl]
	ld a, [hProduct + 3]
	sub b
	ld [hMultiplicand + 2], a
	ld b, $0
	ld a, [hProduct + 2]
	sbc b
	ld [hMultiplicand + 1], a
	ld a, [hProduct + 1]
	sbc b
	ld [hMultiplicand], a
; If bit 7 of c is set, c is negative; otherwise, it's positive
	pop af
	and $80
	jr nz, .subtract
; Add c*n**2 to (d*n - e)
	pop bc
	ld a, [hProduct + 3]
	add b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	adc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	adc b
	ld [hMultiplicand], a
	jr .done_quadratic

.subtract
; Subtract c*n**2 from (d*n - e)
	pop bc
	ld a, [hProduct + 3]
	sub b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	sbc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	sbc b
	ld [hMultiplicand], a

.done_quadratic
; Add (a/b)*n**3 to (d*n - e +/- c*n**2)
	pop bc
	ld a, [hProduct + 3]
	add b
	ld [hMultiplicand + 2], a
	pop bc
	ld a, [hProduct + 2]
	adc b
	ld [hMultiplicand + 1], a
	pop bc
	ld a, [hProduct + 1]
	adc b
	ld [hMultiplicand], a
	ret
; 50eed

.LevelSquared: ; 50eed
	xor a
	ld [hMultiplicand + 0], a
	ld [hMultiplicand + 1], a
	ld a, d
	ld [hMultiplicand + 2], a
	ld [hMultiplier], a
	jp Multiply

.zero_exp
	xor a
	ld hl, hMultiplicand
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

GrowthRates: ; 50efa
growth_rate: MACRO
; [1]/[2]*n**3 + [3]*n**2 + [4]*n - [5]

	dn \1, \2
	if \3 & $80 ; signed
		db -\3 | $80
	else
		db \3
	endc
	db \4, \5
ENDM
	growth_rate 1, 1,   0,   0,   0 ; Medium Fast
	growth_rate 3, 4,  10,   0,  30
	growth_rate 3, 4,  20,   0,  70
	growth_rate 6, 5, -15, 100, 140 ; Medium Slow
	growth_rate 4, 5,   0,   0,   0 ; Fast
	growth_rate 5, 4,   0,   0,   0 ; Slow
; 50f12

Function50f12:
	ld a, [wd0e3]
	dec a
	ld [wd1ec], a
	ld b, a
	ld a, [wcfa9]
	dec a
	ld [Buffer2], a ; wd1eb (aliases: MovementType)
	cp b
	jr z, .asm_50f33
	call Function50f62
	ld a, [wd1ec]
	call Function50f34
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	call Function50f34
.asm_50f33
	ret

Function50f34: ; 50f34 (14:4f34)
	push af
	hlcoord 0, 1
	ld bc, $28
	call AddNTimes
	ld bc, $28
	ld a, $7f
	call ByteFill
	pop af
	ld hl, Sprites
	ld bc, $10
	call AddNTimes
	ld de, $4
	ld c, $4
.asm_50f55
	ld [hl], $a0
	add hl, de
	dec c
	jr nz, .asm_50f55
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	ret

Function50f62: ; 50f62 (14:4f62)
	push hl
	push de
	push bc
	ld bc, PartySpecies
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	ld l, a
	ld h, $0
	add hl, bc
	ld d, h
	ld e, l
	ld a, [wd1ec]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, [hl]
	push af
	ld a, [de]
	ld [hl], a
	pop af
	ld [de], a
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	ld hl, PartyMons ; wdcdf (aliases: PartyMon1, PartyMon1Species)
	ld bc, $30
	call AddNTimes
	push hl
	ld de, DefaultFlypoint
	ld bc, $30
	call CopyBytes
	ld a, [wd1ec]
	ld hl, PartyMons ; wdcdf (aliases: PartyMon1, PartyMon1Species)
	ld bc, $30
	call AddNTimes
	pop de
	push hl
	ld bc, $30
	call CopyBytes
	pop de
	ld hl, DefaultFlypoint
	ld bc, $30
	call CopyBytes
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	ld hl, PartyMonOT ; wddff (aliases: PartyMonOT)
	call SkipNames
	push hl
	call Function51036
	ld a, [wd1ec]
	ld hl, PartyMonOT ; wddff (aliases: PartyMonOT)
	call SkipNames
	pop de
	push hl
	call Function51039
	pop de
	ld hl, DefaultFlypoint
	call Function51039
	ld hl, PartyMonNicknames
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	call SkipNames
	push hl
	call Function51036
	ld hl, PartyMonNicknames
	ld a, [wd1ec]
	call SkipNames
	pop de
	push hl
	call Function51039
	pop de
	ld hl, DefaultFlypoint
	call Function51039
	ld hl, $a600
	ld a, [Buffer2] ; wd1eb (aliases: MovementType)
	ld bc, $2f
	call AddNTimes
	push hl
	ld de, DefaultFlypoint
	ld bc, $2f
	ld a, $0
	call GetSRAMBank
	call CopyBytes
	ld hl, $a600
	ld a, [wd1ec]
	ld bc, $2f
	call AddNTimes
	pop de
	push hl
	ld bc, $2f
	call CopyBytes
	pop de
	ld hl, DefaultFlypoint
	ld bc, $2f
	call CopyBytes
	call CloseSRAM
	pop bc
	pop de
	pop hl
	ret

Function51036: ; 51036 (14:5036)
	ld de, DefaultFlypoint
Function51039: ; 51039 (14:5039)
	ld bc, $b
	call CopyBytes
	ret

GetUnownLetter: ; 51040
; Return Unown letter in UnownLetter based on DVs at hl
; Take the middle 2 bits of each DV and place them in order:
;	atk  def  spd  spc
;	.ww..xx.  .yy..zz.
	; atk
	ld a, [hl]
	and %01100000
	sla a
	ld b, a
	; def
	ld a, [hli]
	and %00000110
	swap a
	srl a
	or b
	ld b, a

	; spd
	ld a, [hl]
	and %01100000
	swap a
	sla a
	or b
	ld b, a
	; spc
	ld a, [hl]
	and %00000110
	srl a
	or b
; Divide by 10 to get 0-25

	ld [hDividend + 3], a
	xor a
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld a, 10
	ld [hDivisor], a
	ld b, $4
	call Divide
; Increment to get 1-26

	ld a, [hQuotient + 2]
	inc a
	ld [UnownLetter], a
	ret
; 51077

GetFrontpic: ; 51077
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call IsAPokemon
	ret c
	ld a, [rSVBK]
	push af
	call _GetFrontpic
	pop af
	ld [rSVBK], a
	ret
; 5108b

Function5108b: ; 5108b
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	call IsAPokemon
	ret c
	ld a, [rSVBK]
	push af
	xor a
	ld [hBGMapMode], a
	call _GetFrontpic
	call Function51103
	pop af
	ld [rSVBK], a
	ret
; 510a5

GetFossilPic:
	ld a, [rSVBK]
	push af
	call .GetFossilPic
	pop af
	ld [rSVBK], a
	ret

.GetFossilPic
	push de
	ld a, 6
	ld [rSVBK], a
	ld hl, FossilPicPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(AerodactylFossilPic)
	ld b, 7
	push bc
	jr _FinishLoadingFrontpic

_GetFrontpic: ; 510a5
	push de
	call GetBaseData
	ld a, [BasePicSize]
	and $f
	ld b, a
	push bc
	call GetFrontpicPointer
	ld a, $6
	ld [rSVBK], a
	ld a, b
_FinishLoadingFrontpic:
	ld de, w6_d000 + $800
	call FarDecompress
	pop bc
	ld hl, w6_d000
	ld de, w6_d000 + $800
	call Function512ab
	pop hl
	push hl
	ld de, w6_d000
	ld c, 7 * 7
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop hl
	ret
; 510d7

FossilPicPointers:
	dw AerodactylFossilPic
	dw KabutopsFossilPic

GetFrontpicPointer: ; 510d7
GLOBAL PicPointers, UnownPicPointers
	ld a, [CurPartySpecies]
	cp UNOWN
	jr z, .unown
	ld a, [CurPartySpecies]
	ld d, BANK(PicPointers)
	jr .ok

.unown
	ld a, [UnownLetter]
	ld d, BANK(UnownPicPointers)
.ok
	ld hl, PicPointers ; UnownPicPointers
	dec a
	ld bc, 6
	call AddNTimes
	ld a, d
	call GetFarByte
	call FixPicBank
	push af
	inc hl
	ld a, d
	call GetFarHalfword
	pop bc
	ret
; 51103

Function51103: ; 51103
	ld a, $1
	ld [rVBK], a
	push hl
	ld de, w6_d000
	ld c, 7 * 7
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop hl
	ld de, 7 * 7 * $10
	add hl, de
	push hl
	ld a, $1
	ld hl, BasePicSize
	call GetFarWRAMByte
	pop hl
	and $f
	ld de, w6_d000 + $800 + 5 * 5 * $10
	ld c, 5 * 5
	cp 5
	jr z, .asm_5113b
	ld de, w6_d000 + $800 + 6 * 6 * $10
	ld c, 6 * 6
	cp 6
	jr z, .asm_5113b
	ld de, w6_d000 + $800 + 7 * 7 * $10
	ld c, 7 * 7
.asm_5113b
	push hl
	push bc
	call Function5114f
	pop bc
	pop hl
	ld de, w6_d000
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	xor a
	ld [rVBK], a
	ret
; 5114f

Function5114f: ; 5114f
	ld hl, w6_d000
	swap c
	ld a, c
	and $f
	ld b, a
	ld a, c
	and $f0
	ld c, a
	push bc
	call Function512f2
	pop bc
.asm_51161
	push bc
	ld c, $0
	call Function512f2
	pop bc
	dec b
	jr nz, .asm_51161
	ret
; 5116c

GetBackpic: ; 5116c
	ld a, [CurPartySpecies]
	call IsAPokemon
	ret c
	ld a, [CurPartySpecies]
	ld b, a
	ld a, [UnownLetter]
	ld c, a
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push de
	; These are assumed to be at the same
	; address in their respective banks.
	GLOBAL PicPointers,  UnownPicPointers
	ld hl, PicPointers ; UnownPicPointers
	ld a, b
	ld d, BANK(PicPointers)
	cp UNOWN
	jr nz, .ok
	ld a, c
	ld d, BANK(UnownPicPointers)
.ok
	dec a
	ld bc, 6
	call AddNTimes
	ld bc, 3
	add hl, bc
	ld a, d
	call GetFarByte
	call FixPicBank
	push af
	inc hl
	ld a, d
	call GetFarHalfword
	ld de, w6_d000
	pop af
	call FarDecompress
	ld hl, w6_d000
	ld c, 6 * 6
	call Function5127c
	pop hl
	ld de, w6_d000
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop af
	ld [rSVBK], a
	ret
; 511c5

FixPicBank: ; 511c5
; This is a thing for some reason.

	push hl
	push bc
	sub PICS_1 - $36
	ld c, a
	ld b, 0
	ld hl, Unknown_511d4
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret
; 511d4

Unknown_511d4: ; 511d4
	db PICS_1
	db PICS_2
	db PICS_3
	db PICS_4
	db PICS_5
	db PICS_6
	db PICS_7
	db PICS_8
	db PICS_9
	db PICS_10
	db PICS_11
	db PICS_12
	db PICS_13
	db PICS_14
	db PICS_15
	db PICS_16
	db PICS_17
	db PICS_18
	db PICS_19
	db PICS_19 + 1
	db PICS_19 + 2
	db PICS_19 + 3
	db PICS_19 + 4
	db PICS_19 + 5
Function511ec: ; 511ec
	ld a, c
	push de
	ld hl, PicPointers
	dec a
	ld bc, 6
	call AddNTimes
	ld a, BANK(PicPointers)
	call GetFarByte
	call FixPicBank
	push af
	inc hl
	ld a, BANK(PicPointers)
	call GetFarHalfword
	pop af
	pop de
	call FarDecompress
	ret
; 0x5120d

GetTrainerPic: ; 5120d
	ld a, [TrainerClass]
	and a
	ret z
	cp NUM_TRAINER_CLASSES
	ret nc
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld hl, TrainerPicPointers
	ld a, [TrainerClass]
	dec a
	ld bc, 3
	call AddNTimes
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push de
	ld a, BANK(TrainerPicPointers)
	call GetFarByte
	call FixPicBank
	push af
	inc hl
	ld a, BANK(TrainerPicPointers)
	call GetFarHalfword
	pop af
	ld de, w6_d000
	call FarDecompress
	pop hl
	ld de, w6_d000
	ld c, 7 * 7
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop af
	ld [rSVBK], a
	call WaitBGMap
	ld a, $1
	ld [hBGMapMode], a
	ret
; 5125d

DecompressPredef: ; 5125d
; Decompress lz data from b:hl to scratch space at 6:d000, then copy it to address de.

	ld a, [rSVBK]
	push af
	ld a, 6
	ld [rSVBK], a
	push de
	push bc
	ld a, b
	ld de, w6_d000
	call FarDecompress
	pop bc
	ld de, w6_d000
	pop hl
	ld a, [hROMBank]
	ld b, a
	call Get2bpp
	pop af
	ld [rSVBK], a
	ret
; 5127c

Function5127c: ; 5127c
	push de
	push bc
	ld a, [wc2c6]
	and a
	jr z, .asm_512a8
	ld a, c
	cp 7 * 7
	ld de, 7 * 7 * $10
	jr z, .asm_51296
	cp 6 * 6
	ld de, 6 * 6 * $10
	jr z, .asm_51296
	ld de, 5 * 5 * $10
.asm_51296
	ld a, [hl]
	ld b, $0
	ld c, $8
.asm_5129b
	rra
	rl b
	dec c
	jr nz, .asm_5129b
	ld a, b
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .asm_51296
.asm_512a8
	pop bc
	pop de
	ret
; 512ab

Function512ab: ; 512ab
	ld a, b
	cp 6
	jr z, .six
	cp 5
	jr z, .five
.seven
	ld c, $70
	call Function512f2
	dec b
	jr nz, .seven
	ret

.six
	ld c, $70
	xor a
	call .Fill
.asm_512c3
	ld c, $10
	xor a
	call .Fill
	ld c, $60
	call Function512f2
	dec b
	jr nz, .asm_512c3
	ret

.five
	ld c, $70
	xor a
	call .Fill
.asm_512d8
	ld c, $20
	xor a
	call .Fill
	ld c, $50
	call Function512f2
	dec b
	jr nz, .asm_512d8
	ld c, $70
	xor a
	call .Fill
	ret

.Fill
	ld [hli], a
	dec c
	jr nz, .Fill
	ret
; 512f2

Function512f2: ; 512f2
	ld a, [wc2c6]
	and a
	jr nz, .asm_512ff
.asm_512f8
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_512f8
	ret

.asm_512ff
	push bc
.asm_51300
	ld a, [de]
	inc de
	ld b, a
	xor a
	rept 8
	rr b
	rla
	endr
	ld [hli], a
	dec c
	jr nz, .asm_51300
	pop bc
	ret
; 51322

Function51322: ; 51322 copy full boxmon from CurPartySpecies, wd002(nickname),wd00d(OT),moves (wd01a), PP(wd02f) and the rest of boxstruct(wd018) into place [curpartymon] in the current box
	ld a, $1
	call GetSRAMBank ;switch to box sram bank
	ld hl, sBoxCount
	call Function513cb ;place [CurPartySpecies] into slot [CurPartyMon] in list hl
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH ;load nicknames location to copy new name into
	ld de, wd002
	call Function513e0 ;copy block of data bc long from hl into list wd265 long de at place [CurPartyMon]
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMonOT
	ld bc, NAME_LENGTH
	ld de, wd00d
	call Function513e0 ;copy OT into box data
	ld a, [sBoxCount]
	dec a
	ld [wd265], a
	ld hl, sBoxMons
	ld bc, sBoxMon1End - sBoxMon1
	ld de, wd018
	call Function513e0 ;copy full box_struct
	ld hl, wd01a
	ld de, TempMonMoves
	ld bc, NUM_MOVES
	call CopyBytes ;copy moves and PP into temp zone?
	ld hl, wd02f
	ld de, TempMonPP
	ld bc, NUM_MOVES
	call CopyBytes
	ld a, [CurPartyMon]
	ld b, a ;store slot to add into into b
	callba Functiondcb6 ;store box mon moves and PP
	jp CloseSRAM
; 5138b

Function5138b: ; 5138b
	ld hl, PartyCount
	call Function513cb ;place [CurPartySpecies] into slot [CurPartyMon] in list hl
	ld a, [PartyCount]
	dec a
	ld [wd265], a
	ld hl, PartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	ld de, wd002
	call Function513e0 ;copy block of data bc long from hl into list wd265 long de at place [CurPartyMon]
	ld a, [PartyCount]
	dec a
	ld [wd265], a
	ld hl, PartyMonOT
	ld bc, NAME_LENGTH
	ld de, wd00d
	call Function513e0
	ld a, [PartyCount]
	dec a
	ld [wd265], a
	ld hl, PartyMons
	ld bc, PartyMon2 - PartyMon1
	ld de, wd018
	call Function513e0
	ret
; 513cb

Function513cb: ; 513cb ;place [CurPartySpecies] into slot [CurPartyMon] in list hl
	inc [hl] ;inc location count
	inc hl ;move up 1
	ld a, [CurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc ;move down to species slot to insert into
	ld a, [CurPartySpecies]
	ld c, a
.asm_513d8
	ld a, [hl] ;place current mon in slot in register
	ld [hl], c ;load new mon in
	inc hl ;go to next slot
	inc c ;check if done, loop until ff
	ld c, a
	jr nz, .asm_513d8
	ret
; 513e0

Function513e0: ; 513e0 ;copy block of data bc long from hl into list wd265 long de at place [CurPartyMon]
	push de
	push hl
	push bc
	ld a, [wd265]
	dec a ;a = slots to move down
	call AddNTimes ; go down that many slots to "highlight" what will be the last slot in the list
	push hl
	add hl, bc ;go back 1
	ld d, h
	ld e, l ;put 1 above into de (the current last slot)
	pop hl ;back to bottom
.asm_513ef
	push bc
	ld a, [wd265] ;current slot in list, start from bottom and work up
	ld b, a
	ld a, [CurPartyMon] ;slot to insert in
	cp b
	pop bc
	jr z, .asm_51415 ;if inserting into target slot, jump
	push hl
	push de
	push bc
	call CopyBytes ;copy current slot down 1
	pop bc
	pop de
	pop hl
	push hl
	ld a, l ;hl - bc ; go up 1 slot
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	pop de ;new de is current hl, going up 1 slot
	ld a, [wd265]
	dec a
	ld [wd265], a ;loop counter -1
	jr .asm_513ef

.asm_51415
	pop bc
	pop hl
	ld a, [CurPartyMon] ;go to target slot
	call AddNTimes
	ld d, h
	ld e, l
	pop hl
	call CopyBytes ;insert new data into slot
	ret
; 51424

BaseData::
INCLUDE "data/base_stats.asm"

PokemonNames::
INCLUDE "data/pokemon_names.asm"

Unknown_53d84: ; unreferenced
	db $1a, $15
	db $33, $16
	db $4b, $17
	db $62, $18
	db $79, $19
	db $90, $1a
	db $a8, $1b
	db $c4, $1c
	db $e0, $1d
	db $f6, $1e
	db $ff, $1f
	db $ff, $20
; 53d9c

UnknownEggPic:: ; 53d9c
; Another egg pic. This is shifted up a few pixels.

INCBIN "gfx/misc/unknown_egg.5x5.2bpp.lz"
; 53e2e

SECTION "bank19", ROMX, BANK[$19]

INCLUDE "text/phone/extra.asm"

SECTION "bank20", ROMX, BANK[$20]

DoPlayerMovement:: ; 80000 load input, set movement data and animation. c = what type of movement
	call GetMovementInput ;ret joydown in curinput, apply downhill
	ld a, $3e ; standing
	ld [MovementAnimation], a ;set movement anim
	xor a
	ld [wd041], a ;load 0 into ??
	call GetPlayerMovement ;set movement data, ret 3 is in whirlpool, ret 5 is forced movement, ret 4 if moving.
	ld c, a
	ld a, [MovementAnimation] ;put animation into ??
	ld [wc2de], a
	ret
; 80017

GetMovementInput: ; 80017 ret joydown in curinput, apply downhill
	ld a, [hJoyDown]
	ld [CurInput], a
; Standing downhill instead moves down.

	ld hl, BikeFlags
	bit 2, [hl] ; downhill
	ret z
	ld c, a ;ignore if any direction pressed, else press down
	and $f0
	ret nz
	ld a, c
	or D_DOWN
	ld [CurInput], a
	ret
; 8002d

GetPlayerMovement: ; 8002d set movement data, ret 3 is in whirlpool, ret 5 is forced movement, ret 4 if moving
	ld a, [PlayerState]
	cp PLAYER_NORMAL
	jr z, .Normal
	cp PLAYER_SURF
	jr z, .Surf
	cp PLAYER_SURF_PIKA
	jr z, .Surf
	cp PLAYER_BIKE
	jr z, .Normal
	cp PLAYER_SLIP
	jr z, .Board
.Normal
	call CheckForcedMovementInput ;if forved to move, replace movement
	call GetMovementAction ;set movement data
	call CheckTileMovement;if whirlpool, a = 3 and carry, if stand still or no force movement ret and nc, else ret a = 5 and carry. also sets animations
	ret c
	call CheckTurning ;do turn frame if needed, ret c if turned. if turn, a = 2
	ret c
	call TryStep ;move if possible. a = 4 if moving, a = 0 if standing
	ret c
	call TryJumpLedge ;if jump ledge, ret a = 7 and carry
	ret c
	call CheckEdgeWarp
	ret c
	jr .NotMoving

.Surf
	call CheckForcedMovementInput
	call GetMovementAction
	call CheckTileMovement
	ret c
	call CheckTurning
	ret c
	call TrySurfStep
	ret c
	jr .NotMoving

.Board
	call CheckForcedMovementInput
	call GetMovementAction
	call CheckTileMovement
	ret c
	call CheckTurning
	ret c
	call TryStep
	ret c
	call TryJumpLedge
	ret c
	call CheckEdgeWarp
	ret c
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .HitWall
	call PlayBump
.HitWall
	call StandInPlace
	xor a
	ret

.NotMoving
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .Standing
; Walking into an edge warp won't bump.

	ld a, [wd041]
	and a
	jr nz, .CantMove
	call PlayBump
.CantMove
	call WalkInPlace
	xor a
	ret

.Standing
	call StandInPlace
	xor a
	ret
; 800b7

CheckSpinning::
	ld a, [StandingTile]
	call IsSpinTile
	jr z, .start_spin
	call IsStopTile
	jr z, .stop_spin
	ld a, [wSpinning]
	and a
	ret

.start_spin
	ld a, c
	inc a
	ld [wSpinning], a
	and a
	ret

.stop_spin
	xor a
	ld [wSpinning], a
	ret
; ~~~~~~~~~~~~~~~~~~~~~~~

pushs
SECTION "Spinners", WRAMX

wSpinning:: ds 1
pops
; ~~~~~~~~~~~~~~~~~~~~~~~

IsSpinTile:
	cp $81
	ld c, UP
	ret z
	cp $82
	ld c, DOWN
	ret z
	cp $83
	ld c, LEFT
	ret z
	cp $84
	ld c, RIGHT
	ret z
	ld c, STANDING
	ret

IsStopTile:
	cp $80
	ret

CheckTileMovement: ; 800b7
; Tiles such as waterfalls and warps move the player
; in a given direction, overriding input.
;if whirlpool, a = 3 and carry, if stand still ret a = 0 and nc, else ret a = 5 and carry
;also sets animations
	ld a, [StandingTile]
	ld c, a
	call CheckWhirlpoolTile ;if a whirlpool, a = 3 and ret c
	jr c, .asm_800c4
	ld a, 3
	scf
	ret

.asm_800c4
	and $f0 ;check if on moving tiles or warps
	cp $30 ; moving water
	jr z, .water
	cp $40 ; moving land 1
	jr z, .land1
	cp $50 ; moving land 2
	jr z, .land2
	cp $70 ; warps
	jr z, .warps
	jr .asm_8013c

.water
	ld a, c
	and 3
	ld c, a ;first 2 bits of tile show direction
	ld b, 0
	ld hl, .water_table
	add hl, bc
	ld a, [hl]
	ld [WalkingDirection], a ;set walking direction based on that
	jr .asm_8013e

.water_table
	db RIGHT
	db LEFT
	db UP
	db DOWN
.land1
	ld a, c
	and 7
	ld c, a
	ld b, 0
	ld hl, .land1_table
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .asm_8013c ;if forced to stand, branch, else set direction
	ld [WalkingDirection], a
	jr .asm_8013e

.land1_table
	db STANDING
	db RIGHT
	db LEFT
	db UP
	db DOWN
	db STANDING
	db STANDING
	db STANDING
.land2
	ld a, c
	and 7
	ld c, a
	ld b, 0
	ld hl, .land2_table
	add hl, bc
	ld a, [hl]
	cp STANDING
	jr z, .asm_8013c ;if forced to stand, branch, else set direction
	ld [WalkingDirection], a
	jr .asm_8013e

.land2_table
	db RIGHT
	db LEFT
	db UP
	db DOWN
	db STANDING
	db STANDING
	db STANDING
	db STANDING
.warps
	ld a, c
	cp $71 ; door ;set direction to down for warps if needed
	jr z, .down
	cp $79
	jr z, .down
	cp $7a ; stairs
	jr z, .down
	cp $7b ; cave
	jr nz, .asm_8013c
.down
	ld a, DOWN
	ld [WalkingDirection], a
	jr .asm_8013e

.asm_8013c ;ret a = 0
	xor a
	ret

.asm_8013e
	ld a, STEP_WALK
	call DoStep ;load appropriote animations for the type of step, walk in place into d04e. ret a = 4 if moving, a = 0 if standing
	ld a, 5
	scf
	ret
; 80147

CheckTurning: ; 80147
; If the player is turning, change direction first. This also lets
; the player change facing without moving by tapping a direction.

	ld a, [wd04e]
	cp 0
	jr nz, .asm_80169 ;if no walk in place anim, ret nc
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .asm_80169 ;if standing still, ret nc
	ld e, a ;store direction
	ld a, [PlayerDirection]
	rrca
	rrca
	and 3 ;ise bits 2-3 only
	cp e
	jr z, .asm_80169 ;if same as direction moving in, ret nc
	ld a, STEP_TURN
	call DoStep
	ld a, 2
	scf
	ret

.asm_80169
	xor a
	ret
; 8016b

TryStep: ; 8016b
; Surfing actually calls TrySurfStep directly instead of passing through here.

	ld a, [PlayerState]
	cp PLAYER_SURF
	jp z, TrySurfStep
	cp PLAYER_SURF_PIKA
	jp z, TrySurfStep
	call CheckLandPermissions ; Return nc if walking onto land and tile permissions allow it.
	jr c, .asm_801be
	call IsNPCInFront  ;ret a = 1 if something in way, do some bike checks and possibly a = 2
	and a
	jr z, .asm_801be ;if colliding, continue, else ret
	cp 2
	jr z, .asm_801be
	ld a, [wSpinning]
	and a
	jr nz, .spin ;if spinning, jump
	ld a, [StandingTile]
	call CheckIceTile
	jr nc, .ice ;if on ice, jump
; Downhill riding is slower when not moving down.

	call CheckRiding ;if on bike or slipping, continue, else jump
	jr nz, .asm_801ae
	ld hl, BikeFlags
	bit 2, [hl] ; downhill
	jr z, .fast ;if not downhill or pressing down, go fast
	ld a, [WalkingDirection]
	cp DOWN
	jr z, .fast
	ld a, STEP_WALK
	call DoStep
	scf
	ret

.fast
	ld a, STEP_BIKE
	call DoStep
	scf
	ret

.asm_801ae
	ld de, EVENT_GUIDE_GENT_VISIBLE_IN_CHERRYGROVE
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr nz, .norm
	ld a, [CurInput]
	and B_BUTTON
	jr nz, .run
.norm
	ld a, STEP_WALK
	call DoStep
	scf
	ret

.ice
	ld a, STEP_ICE
	call DoStep
	scf
	ret

.run
	ld a, STEP_RUN
	call DoStep
	ld a, [$ffa4]
	and $f0
	jr z, .skip_trainer
	call CheckTrainerRun
.skip_trainer
	scf
	ret

.spin
	ld de, SFX_SQUEAK
	call PlaySFX
	ld a, STEP_SPIN
	call DoStep
	scf
	ret
; unused?

	xor a
	ret

.asm_801be
	xor a
	ld [wSpinning], a
	ret
; 801c0

TrySurfStep: ; 801c0
	call CheckWaterPermissions
	ld [wd040], a
	jr c, .asm_801f1
	call IsNPCInFront
	ld [wd03f], a
	and a
	jr z, .asm_801f1
	cp 2
	jr z, .asm_801f1
	ld a, [wd040]
	and a
	jr nz, .ExitWater
	ld a, STEP_WALK
	call DoStep
	scf
	ret

.ExitWater
	call WaterToLandSprite
	call PlayMapMusic
	ld a, STEP_WALK
	call DoStep
	ld a, 6
	scf
	ret

.asm_801f1
	xor a
	ret
; 801f3

TryJumpLedge: ; 801f3
	ld a, [StandingTile]
	ld e, a
	and $f0
	cp $a0 ; ledge
	jr nz, .DontJump
	ld a, e
	and 7
	ld e, a
	ld d, 0
	ld hl, .data_8021e
	add hl, de
	ld a, [FacingDirection]
	and [hl]
	jr z, .DontJump
	ld de, SFX_JUMP_OVER_LEDGE
	call PlaySFX
	ld a, STEP_LEDGE
	call DoStep
	ld a, 7
	scf
	ret

.DontJump
	xor a
	ret

.data_8021e
	db FACE_RIGHT
	db FACE_LEFT
	db FACE_UP
	db FACE_DOWN
	db FACE_RIGHT | FACE_DOWN
	db FACE_DOWN | FACE_LEFT
	db FACE_UP | FACE_RIGHT
	db FACE_UP | FACE_LEFT
; 80226

CheckEdgeWarp: ; 80226
; Bug: Since no case is made for STANDING here, it will check
; [.edgewarps + $ff]. This resolves to $3e at $8035a.
; This causes wd041 to be nonzero when standing on tile $3e,
; making bumps silent.

	ld a, [WalkingDirection]
	cp STANDING
	jr z, .asm_80259
	ld e, a
	ld d, 0
	ld hl, .EdgeWarps
	add hl, de
	ld a, [StandingTile]
	cp [hl]
	jr nz, .asm_80259
	ld a, 1
	ld [wd041], a
	ld a, [WalkingDirection]
	cp STANDING
	jr z, .asm_80259
	ld e, a
	ld a, [PlayerDirection]
	rrca
	rrca
	and 3
	cp e
	jr nz, .asm_80259
	call Function224a ; CheckFallPit?
	jr nc, .asm_80259
	call StandInPlace
	scf
	ld a, 1
	ret

.asm_80259
	xor a
	ret

.EdgeWarps
	db $70, $78, $76, $7e
; 8025f

DoStep: ; 8025f ;load appropriote animations for the type of step, walk in place into d04e. ret a = 4 if moving, a = 0 if standing
	ld e, a
	ld d, 0
	ld hl, .Steps ;a = step type, load appropriote branch into hl
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [WalkingDirection]
	ld e, a
	cp STANDING
	jp z, StandInPlace ;if standing, stand in place
	add hl, de ;go down to direction
	ld a, [hl]
	ld [MovementAnimation], a ;place animation
	ld hl, .WalkInPlace
	add hl, de
	ld a, [hl]
	ld [wd04e], a ;load in walk in place anim
	ld a, 4 ;load 4 into a
	ret

.Steps
	dw .Slow
	dw .Walk
	dw .Bike
	dw .Ledge
	dw .Ice
	dw .Turn
	dw .BackwardsLedge
	dw .WalkInPlace
	dw .Spin
	dw .Run

.Slow
	slow_step_down
	slow_step_up
	slow_step_left
	slow_step_right
.Walk
	step_down
	step_up
	step_left
	step_right
.Bike
	big_step_down
	big_step_up
	big_step_left
	big_step_right
.Ledge
	jump_step_down
	jump_step_up
	jump_step_left
	jump_step_right
.Ice
	fast_slide_step_down
	fast_slide_step_up
	fast_slide_step_left
	fast_slide_step_right
.BackwardsLedge
	jump_step_up
	jump_step_down
	jump_step_left
	jump_step_right
.Turn
	half_step_down
	half_step_up
	half_step_left
	half_step_right
.WalkInPlace
	walk_in_place_down
	walk_in_place_up
	walk_in_place_left
	walk_in_place_right
.Spin
	turn_waterfall_down
	turn_waterfall_up
	turn_waterfall_left
	turn_waterfall_right
.Run
	run_step_down
	run_step_up
	run_step_left
	run_step_right
; 802b3

StandInPlace: ; 802b3
	ld a, 0
	ld [wd04e], a ;load 0 into walk in place anim
	ld a, $3e ; standing
	ld [MovementAnimation], a
	xor a
	ret
; 802bf

WalkInPlace: ; 802bf
	ld a, 0
	ld [wd04e], a
	ld a, $50 ; walking
	ld [MovementAnimation], a
	xor a
	ret
; 802cb

CheckTrainerRun:
; Check if any trainer on the map sees the player.

; Skip the player object.
	ld a, 1
	ld de, MapObjects + OBJECT_LENGTH

.loop

; Have them face the player if the object:

	push af
	push de

; Has a sprite
	ld hl, MAPOBJECT_SPRITE
	add hl, de
	ld a, [hl]
	and a
	jr z, .next

; Is a trainer
	ld hl, MAPOBJECT_COLOR
	add hl, de
	ld a, [hl]
	and $f
	cp $2
	jr nz, .next
; Is visible on the map
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	cp -1
	jr z, .next

; Spins around
	ld hl, MAPOBJECT_MOVEMENT
	add hl, de
	ld a, [hl]
	cp $3
	jr z, .spinner
	cp $a
	jr z, .spinner
	cp $1e
	jr z, .spinner
	cp $1f
	jr nz, .next

.spinner

; You're within their sight range
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	call Function1ae5
	call AnyFacingPlayerDistance_bc
	ld hl, MAPOBJECT_RANGE
	add hl, de
	ld a, [hl]
	cp c
	jr c, .next

; Get them to face you
	ld a, b
	push af
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, de
	ld a, [hl]
	call Function1ae5
	pop af
	call Function1af8
	ld hl, OBJECT_STEP_DURATION
	add hl, bc
	ld a, [hl]
	cp $40
	jr nc, .next
	ld a, $40
	ld [hl], a

.next
	pop de
	ld hl, OBJECT_LENGTH
	add hl, de
	ld d, h
	ld e, l

	pop af
	inc a
	cp NUM_OBJECTS
	jr nz, .loop
	xor a
	ret

AnyFacingPlayerDistance_bc::
; Returns distance in c and direction in b.
	push de
	call .AnyFacingPlayerDistance
	ld b, d
	ld c, e
	pop de
	ret

.AnyFacingPlayerDistance
	ld hl, OBJECT_NEXT_MAP_X ; x
	add hl, bc
	ld d, [hl]

	ld hl, OBJECT_NEXT_MAP_Y ; y
	add hl, bc
	ld e, [hl]

	ld a, [$ffa4]
	bit 7, a
	jr nz, .down
	bit 6, a
	jr nz, .up
	bit 5, a
	jr nz, .left
	bit 4, a
	jr nz, .right
.down
	ld bc, $0100
	jr .got_vector
.up
	ld bc, $ff00
	jr .got_vector
.left
	ld bc, $00ff
	jr .got_vector
.right
	ld bc, $0001
.got_vector

	ld a, [MapX]
	add c
	sub d
	ld l, OW_RIGHT
	jr nc, .check_y
	cpl
	inc a
	ld l, OW_LEFT
.check_y
	ld d, a
	ld a, [MapY]
	add b
	sub e
	ld h, OW_DOWN
	jr nc, .compare
	cpl
	inc a
	ld h, OW_UP
.compare
	cp d
	ld e, a
	ld a, d
	ld d, h
	ret nc
	ld e, a
	ld d, l
	ret

CheckForcedMovementInput: ; 802cb
; When sliding on ice, input is forced to remain in the same direction.

	call CheckSpinning ; a = spinning. if on spin tile spin = c
	jr z, .not_spinning
	dec a
	jr .force ;filter incorrect directions
.not_spinning
	call Function80404 ;ret c if sliding
	ret nc
	ld a, [wd04e] ;if walkinplace = 0, can't slide
	cp 0
	ret z
.force
	and 3
	ld e, a ;put spin direction in e?
	ld d, 0
	ld hl, .data_802e8
	add hl, de
	ld a, [CurInput]
	and A_BUTTON | B_BUTTON | SELECT | START
	or [hl]
	ld [CurInput], a
	ret

.data_802e8
	db D_DOWN, D_UP, D_LEFT, D_RIGHT
; 802ec

GetMovementAction: ; 802ec
; Poll player input and update movement info.

	ld hl, .table
	ld de, .table2 - .table1
	ld a, [CurInput] ;go to correct direction
	bit 7, a
	jr nz, .down
	bit 6, a
	jr nz, .up
	bit 5, a
	jr nz, .left
	bit 4, a
	jr nz, .right
; Standing

	jr .update

.down 	add hl, de
.up   	add hl, de
.left 	add hl, de
.right	add hl, de
.update
	ld a, [hli]
	ld [WalkingDirection], a
	ld a, [hli]
	ld [FacingDirection], a
	ld a, [hli]
	ld [WalkingX], a
	ld a, [hli]
	ld [WalkingY], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ld [WalkingTile], a
	ret

.table
; struct:
;	walk direction
;	facing
;	x movement
;	y movement
;	tile collision pointer
.table1
	db STANDING, FACE_CURRENT, 0, 0
	dw StandingTile

.table2
	db RIGHT, FACE_RIGHT,  1,  0
	dw TileRight
	db LEFT,  FACE_LEFT,  -1,  0
	dw TileLeft
	db UP,    FACE_UP,     0, -1
	dw TileUp
	db DOWN,  FACE_DOWN,   0,  1
	dw TileDown
; 80341

IsNPCInFront: ; 80341 ret a = 1 if something in way, do some bike checks and possibly a = 2
	ld a, 0
	ld [$ffaf], a ;0 out strip legnth
	ld a, [MapX]
	ld d, a
	ld a, [WalkingX]
	add d
	ld d, a
	ld a, [MapY]
	ld e, a
	ld a, [WalkingY]
	add e
	ld e, a ;de = place walking to
	;ld bc, ObjectStructs ; redundant
	callba Function7041 ;if no object is in contact with place walking to, ret a = 1
	jr nc, .asm_80369
	call Function8036f ;if bikeflag 0 is 1, bc+7 is not ff and bc+6 bit 6 = 1, set bc+5 bit 2, replace first 2 bits of bc + 32 with direction and ret a = 2
	jr c, .asm_8036c ;else ret a = 0
	xor a
	ret

.asm_80369
	ld a, 1
	ret

.asm_8036c
	ld a, 2
	ret
; 8036f

Function8036f: ; 8036f if bikeflag 0 is 1, bc+7 is not ff and bc+6 bit 6 = 1, set bc+5 bit 2 and replace first 2 bits of bc + 32 with direction
	ld hl, BikeFlags
	bit 0, [hl]
	jr z, .asm_8039c ;if bike flag 0 = 0, ret a = 0
	ld hl, $0007 ;if bc + 7 = FF, ret a = 0
	add hl, bc
	ld a, [hl]
	cp $ff
	jr nz, .asm_8039c
	ld hl, $0006
	add hl, bc
	bit 6, [hl]
	jr z, .asm_8039c ;if bc + 6  bit 6 = 0, ret a = 0
	ld hl, $0005
	add hl, bc
	set 2, [hl] ;set bc+5 bit 2
	ld a, [WalkingDirection]
	ld d, a
	ld hl, $0020
	add hl, bc ;replace first 2 bits of bc + 32 with direction
	ld a, [hl]
	and $fc
	or d
	ld [hl], a
	scf
	ret

.asm_8039c
	xor a
	ret
; 8039e

CheckLandPermissions: ; 8039e
; Return 0 if walking onto land and tile permissions allow it.
; Otherwise, return carry.

	ld a, [TilePermissions]
	ld d, a
	ld a, [FacingDirection]
	and d
	jr nz, .NotWalkable
	ld a, [WalkingTile]
	call CheckWalkable
	jr c, .NotWalkable
	xor a
	ret

.NotWalkable
	scf
	ret
; 803b4

CheckWaterPermissions: ; 803b4
; Return 0 if moving in water, or 1 if moving onto land.
; Otherwise, return carry.

	ld a, [TilePermissions]
	ld d, a
	ld a, [FacingDirection]
	and d
	jr nz, .NotSurfable
	ld a, [WalkingTile]
	call CheckSurfable
	jr c, .NotSurfable
	and a
	ret

.NotSurfable
	scf
	ret
; 803ca

CheckRiding: ; 803ca
	ld a, [PlayerState]
	cp PLAYER_BIKE
	ret z
	cp PLAYER_SLIP
	ret
; 803d3

CheckWalkable: ; 803d3
; Return 0 if tile a is land. Otherwise, return carry.

	call GetTileCollision
	and a ; land
	ret z
	scf
	ret
; 803da

CheckSurfable: ; 803da
; Return 0 if tile a is water, or 1 if land.
; Otherwise, return carry.

	call GetTileCollision
	cp 1
	jr z, .Water
; Can walk back onto land from water.

	and a
	jr z, .Land
	jr .Neither

.Water
	xor a
	ret

.Land
	ld a, 1
	and a
	ret

.Neither
	scf
	ret
; 803ee

PlayBump: ; 803ee
	call CheckSFX
	ret c
	ld de, SFX_BUMP
	call PlaySFX
	ret
; 803f9

WaterToLandSprite: ; 803f9
	push bc
	ld a, PLAYER_NORMAL
	ld [PlayerState], a
	call Functione4a ; UpdateSprites
	pop bc
	ret
; 80404

Function80404:: ; 80404 if player is on ice or sliding and has no-0 walking anim, ret c, else ret nc
	ld a, [wd04e]
	cp 0
	jr z, .asm_80420 ;if walkinplace = 0 or f0, ret nc
	cp $f0
	jr z, .asm_80420
	ld a, [StandingTile]
	call CheckIceTile ;if not $23 or $2b, scf
	jr nc, .asm_8041e ;ret c if ice
	ld a, [PlayerState]
	cp PLAYER_SLIP
	jr nz, .asm_80420 ;If player is slipping scf and ret, otherwise just ret

.asm_8041e
	scf
	ret

.asm_80420
	and a
	ret
; 80422

Function80422:: ; 80422
	ld hl, wc2de
	ld a, $3e ; standing
	cp [hl]
	ret z
	ld [hl], a
	ld a, 0
	ld [wd04e], a
	ret
; 80430

EngineFlagAction:: ; 80430
; Do action b on engine flag de
;
;   b = 0: reset flag
;     = 1: set flag
;     > 1: check flag, result in c
;
; Setting/resetting does not return a result.
; 16-bit flag ids are considered invalid, but it's nice
; to know that the infrastructure is there.

	ld a, d
	cp 0
	jr z, .ceiling
	jr c, .read ; cp 0 can't set carry!
	jr .invalid

; There are only $a2 engine flags, so
; anything beyond that is invalid too.


.ceiling
	ld a, e
	cp NUM_ENGINE_FLAGS
	jr c, .read

; Invalid flags are treated as flag 00.


.invalid
	xor a
	ld e, a
	ld d, a

; Get this flag's location.


.read
	ld hl, EngineFlags
; location

	add hl, de
	add hl, de
; bit

	add hl, de

; location

	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
; bit

	ld c, [hl]

; What are we doing with this flag?


	ld a, b
	cp 1
	jr c, .reset ; b = 0
	jr z, .set   ; b = 1

; Return the given flag in c.

.check
	ld a, [de]
	and c
	ld c, a
	ret

; Set the given flag.

.set
	ld a, [de]
	or c
	ld [de], a
	ret

; Reset the given flag.

.reset
	ld a, c
	cpl ; AND all bits except the one in question
	ld c, a
	ld a, [de]
	and c
	ld [de], a
	ret
; 80462

EngineFlags: ; 80462
INCLUDE "engine/engine_flags.asm"
; 80648

Function80648:: ; 80648 (20:4648)
	ld a, c
	cp NUM_VARS
	jr c, .asm_8064e ; if out of bounds, make 0
	xor a
.asm_8064e
	ld c, a
	ld b, 0
	ld hl, Unknown_80671 ;jump to correct part of list
	add hl, bc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl] ; de = location of variable
	inc hl
	ld b, [hl] ;oppcode
	ld a, b
	and $80
	jr nz, .asm_80668 ;if $80, call de
	ld a, b
	and $40 ;if $40, return stringbuffer with what's at location in it?
	ret nz ;if 0 just return de
	ld a, [de]
	jr Function8066c

.asm_80668
	call _de_ ;just a call de
	ret

Function8066c: ; 8066c (20:466c)
	ld de, StringBuffer2
	ld [de], a
	ret
; 80671 (20:4671)

Unknown_80671: ; 80671
; $00: return address
; $40: return at StringBuffer2
; $80: return function result at StringBuffer2

	dwb StringBuffer2, $00 ; $0
	dwb PartyCount,    $00 ; $1
	dwb Function80728, $80 ; $2
	dwb BattleType,    $40 ; $3
	dwb TimeOfDay,     $00 ; $4
	dwb Function806c5, $80 ; $5 Dex Caught
	dwb Function806d3, $80 ; $6 Dex Seen
	dwb Function806e1, $80 ; $7 Badges
	dwb PlayerState,   $40 ; $8
	dwb Function806ef, $80 ; $9 Player Facing
	dwb hHours,        $00 ; $a
	dwb Function806f9, $80 ; $b Day of the week
	dwb MapGroup,      $00 ; $c
	dwb MapNumber,     $00 ; $d
	dwb Function806ff, $80 ; $e Unown count
	dwb wMapHeaderPermission,         $00 ; $f Roof palette (?)
	dwb Function80715, $80 ; $10 Empty Box Slots
	dwb wd46c,         $00 ; $11 time left on bug catching?
	dwb XCoord,        $00 ; $12
	dwb YCoord,        $00 ; $13
	dwb wdc31,         $00 ; $14 Pokerus
	dwb wcf64,         $00 ; $15 Unused
	dwb wdca4,         $00 ; $16 kurt ball count?
	dwb wdbf9,         $40 ; $17 Caller ID
	dwb wBlueCardBalance,         $40 ; $18 BlueCard Balance
	dwb wdc4a,         $40 ; $19 Unused
	dwb wdc58,         $00 ; $1a
	dwb NULL,          $00
; 806c5

Function806c5: ; 806c5
; Caught mons.

	ld hl, PokedexCaught
	ld b, EndPokedexCaught - PokedexCaught
	call CountSetBits
	ld a, [wd265]
	jp Function8066c
; 806d3

Function806d3: ; 806d3
; Seen mons.

	ld hl, PokedexSeen
	ld b, EndPokedexSeen - PokedexSeen
	call CountSetBits
	ld a, [wd265]
	jp Function8066c
; 806e1

Function806e1: ; 806e1
; Number of owned badges.

	ld hl, Badges
	ld b, 2
	call CountSetBits
	ld a, [wd265]
	jp Function8066c
; 806ef

Function806ef: ; 806ef
; The direction the player is facing.

	ld a, [PlayerDirection]
	and $c
	rrca
	rrca
	jp Function8066c
; 806f9

Function806f9: ; 806f9
; The day of the week.

	call GetWeekday
	jp Function8066c
; 806ff

Function806ff: ; 806ff
; Number of unique Unown caught.

	call .count
	ld a, b
	jp Function8066c

.count
	ld hl, UnownDex
	ld b, 0
.loop
	ld a, [hli]
	and a
	ret z
	inc b
	ld a, b
	cp 26
	jr c, .loop
	ret
; 80715

Function80715: ; 80715
; Remaining slots in the current box.

	ld a, 1 ; BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	ld a, MONS_PER_BOX
	sub [hl]
	ld b, a
	call CloseSRAM
	ld a, b
	jp Function8066c
; 80728

Function80728: ; 80728
	ld a, [wd0ee]
	and $3f
	jp Function8066c
; 80730

BattleText::
INCLUDE "text/battle.asm"

ColorTest: ; 818ac
; A debug menu to test monster and trainer palettes at runtime.

	ld a, [hCGB]
	and a
	jr nz, .asm_818b5
	ld a, [hSGB]
	and a
	ret z
.asm_818b5
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	call DisableLCD
	call Function81948
	call Function8197c
	call Function819a7
	call Function818f4
	call EnableLCD
	ld de, MUSIC_NONE
	call PlayMusic
	xor a
	ld [wcf63], a
	ld [wcf66], a
	ld [wd003], a
.asm_818de
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_818f0
	call Function81a74
	call Function81f5e
	call DelayFrame
	jr .asm_818de

.asm_818f0
	pop af
	ld [$ffaa], a
	ret
; 818f4

Function818f4: ; 818f4
	ld a, [DefaultFlypoint]
	and a
	jr nz, Function81911
	ld hl, PokemonPalettes
Function818fd: ; 818fd
	ld de, OverworldMap
	ld c, NUM_POKEMON + 1
.asm_81902
	push bc
	push hl
	call Function81928
	pop hl
	ld bc, $0008
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_81902
	ret

Function81911: ; 81911
	ld hl, TrainerPalettes
	ld de, OverworldMap
	ld c, NUM_TRAINER_CLASSES
.asm_81919
	push bc
	push hl
	call Function81928
	pop hl
	ld bc, $0004
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_81919
	ret
; 81928

Function81928: ; 81928
	ld a, BANK(PokemonPalettes) ; BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	ld a, BANK(PokemonPalettes) ; BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	ld a, BANK(PokemonPalettes) ; BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	ld a, BANK(PokemonPalettes) ; BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	ret
; 81948

Function81948: ; 81948
	ld a, $1
	ld [rVBK], a
	ld hl, VTiles0
	ld bc, $2000
	xor a
	call ByteFill
	ld a, $0
	ld [rVBK], a
	ld hl, VTiles0
	ld bc, $2000
	xor a
	call ByteFill
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	call ByteFill
	call ClearSprites
	ret
; 8197c

Function8197c: ; 8197c
	ld hl, DebugColorTestGFX + $10
	ld de, $96a0
	ld bc, $0160
	call CopyBytes
	ld hl, DebugColorTestGFX
	ld de, VTiles0
	ld bc, $0010
	call CopyBytes
	call Functione51
	ld hl, VTiles1
	ld bc, $0800
.asm_8199d
	ld a, [hl]
	xor $ff
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_8199d
	ret
; 819a7

Function819a7: ; 819a7
	ld a, [hCGB]
	and a
	ret z
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_819f4
	ld de, BGPals
	ld bc, $0080
	call CopyBytes
	ld a, $80
	ld [rBGPI], a
	ld hl, Palette_819f4
	ld c, $40
	xor a
.asm_819c8
	ld [rBGPD], a
	dec c
	jr nz, .asm_819c8
	ld a, $80
	ld [rOBPI], a
	ld hl, Palette_81a34
	ld c, $40
.asm_819d6
	ld a, [hli]
	ld [rOBPD], a
	dec c
	jr nz, .asm_819d6
	ld a, $94
	ld [wc608], a
	ld a, $52
	ld [wc608 + 1], a
	ld a, $4a
	ld [wc608 + 2], a
	ld a, $29
	ld [wc608 + 3], a
	pop af
	ld [rSVBK], a
	ret
; 819f4

Palette_819f4: ; 819f4
	; white
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	; red
	RGB 31, 00, 00
	RGB 31, 00, 00
	RGB 31, 00, 00
	RGB 00, 00, 00
	; green
	RGB 00, 31, 00
	RGB 00, 31, 00
	RGB 00, 31, 00
	RGB 00, 00, 00
	; blue
	RGB 00, 00, 31
	RGB 00, 00, 31
	RGB 00, 00, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
Palette_81a34: ; 81a34
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
	; red
	RGB 31, 31, 31
	RGB 31, 00, 00
	RGB 31, 00, 00
	RGB 00, 00, 00
	; green
	RGB 31, 31, 31
	RGB 00, 31, 00
	RGB 00, 31, 00
	RGB 00, 00, 00
	; blue
	RGB 31, 31, 31
	RGB 00, 00, 31
	RGB 00, 00, 31
	RGB 00, 00, 00
; 81a74

Function81a74: ; 81a74
	call Functiona57
	ld a, [wcf63]
	cp $4
	jr nc, .asm_81a8b
	ld hl, $ffa9
	ld a, [hl]
	and $4
	jr nz, .asm_81a9a
	ld a, [hl]
	and $8
	jr nz, .asm_81aab
.asm_81a8b
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_81acf
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.asm_81a9a
	call Function81eca
	call Function81ac3
	ld e, a
	ld a, [wcf66]
	inc a
	cp e
	jr c, .asm_81aba
	xor a
	jr .asm_81aba

.asm_81aab
	call Function81eca
	ld a, [wcf66]
	dec a
	cp $ff
	jr nz, .asm_81aba
	call Function81ac3
	dec a
.asm_81aba
	ld [wcf66], a
	ld a, $0
	ld [wcf63], a
	ret
; 81ac3

Function81ac3: ; 81ac3
; Looping back around the pic set.

	ld a, [DefaultFlypoint]
	and a
	jr nz, .asm_81acc
	ld a, NUM_POKEMON ; CELEBI
	ret

.asm_81acc
	ld a, NUM_TRAINER_CLASSES - 1 ; MYSTICALMAN
	ret
; 81acf

Jumptable_81acf: ; 81acf
	dw Function81adb
	dw Function81c18
	dw Function81c33
	dw Function81cc2
	dw Function81d8e
	dw Function81daf
; 81adb

Function81adb: ; 81adb
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $6f
	call ByteFill
	hlcoord 1, 3
	ld bc, $0712
	ld a, $6c
	call Functionfb8
	hlcoord 11, 0
	ld bc, $0203
	ld a, $6d
	call Functionfb8
	hlcoord 16, 0
	ld bc, $0203
	ld a, $6e
	call Functionfb8
	call Function81bc0
	call Function81bf4
	ld a, [wcf66]
	inc a
	ld [CurPartySpecies], a
	ld [wd265], a
	hlcoord 0, 1
	ld de, wd265
	ld bc, $8103
	call PrintNum
	ld a, [DefaultFlypoint]
	and a
	jr nz, .asm_81b7a
	ld a, $1
	ld [UnownLetter], a
	call GetPokemonName
	hlcoord 4, 1
	call PlaceString
	xor a
	ld [wc2c6], a
	hlcoord 12, 3
	call Function378b
	ld de, $9310
	predef GetBackpic
	ld a, $31
	ld [$ffad], a
	hlcoord 2, 4
	ld bc, $0606
	predef FillBox
	ld a, [wd003]
	and a
	jr z, .asm_81b66
	ld de, String_81baf
	jr .asm_81b69

.asm_81b66
	ld de, String_81bb4
.asm_81b69
	hlcoord 7, 17
	call PlaceString
	hlcoord 0, 17
	ld de, String_81bb9
	call PlaceString
	jr .asm_81ba9

.asm_81b7a
	ld a, [wd265]
	ld [TrainerClass], a
	callab Function3957b
	ld de, StringBuffer1
	hlcoord 4, 1
	call PlaceString
	ld de, VTiles2
	callab GetTrainerPic
	xor a
	ld [TempEnemyMonSpecies], a
	ld [$ffad], a
	hlcoord 2, 3
	ld bc, $0707
	predef FillBox
.asm_81ba9
	ld a, $1
	ld [wcf63], a
	ret
; 81baf

String_81baf: db "レア", $6f, $6f, "@" ; rare (shiny)
String_81bb4: db "ノーマル@" ; normal
String_81bb9: db $7a, "きりかえ▶@" ; (A) switches
; 81bc0

Function81bc0: ; 81bc0
	decoord 0, 11, AttrMap
	hlcoord 2, 11
	ld a, $1
	call Function81bde
	decoord 0, 13, AttrMap
	hlcoord 2, 13
	ld a, $2
	call Function81bde
	decoord 0, 15, AttrMap
	hlcoord 2, 15
	ld a, $3
Function81bde: ; 81bde
	push af
	ld a, $6a
	ld [hli], a
	ld bc, $000f
	ld a, $6b
	call ByteFill
	ld l, e
	ld h, d
	pop af
	ld bc, $0028
	call ByteFill
	ret
; 81bf4

Function81bf4: ; 81bf4
	ld a, [wcf66]
	inc a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld de, OverworldMap
	add hl, de
	ld de, wc608
	ld bc, $0004
	call CopyBytes
	xor a
	ld [wcf64], a
	ld [wcf65], a
	ld de, wc608
	call Function81ea5
	ret
; 81c18

Function81c18: ; 81c18
	ld a, [hCGB]
	and a
	jr z, .asm_81c2a
	ld a, $2
	ld [hBGMapMode], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
.asm_81c2a
	call WaitBGMap
	ld a, $2
	ld [wcf63], a
	ret
; 81c33

Function81c33: ; 81c33
	ld a, [hCGB]
	and a
	jr z, .asm_81c69
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, BGPals
	ld de, wc608
	ld c, $1
	call Function81ee3
	hlcoord 10, 2
	ld de, wc608
	call Function81ca7
	hlcoord 15, 2
	ld de, wc608 + 2
	call Function81ca7
	ld a, $1
	ld [hCGBPalUpdate], a
	ld a, $3
	ld [wcf63], a
	pop af
	ld [rSVBK], a
	ret

.asm_81c69
	ld hl, wcda9
	ld a, $1
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, [wc608]
	ld [hli], a
	ld a, [wc608 + 1]
	ld [hli], a
	ld a, [wc608 + 2]
	ld [hli], a
	ld a, [wc608 + 3]
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wcda9
	call Function81f0c
	hlcoord 10, 2
	ld de, wc608
	call Function81ca7
	hlcoord 15, 2
	ld de, wc608 + 2
	call Function81ca7
	ld a, $3
	ld [wcf63], a
	ret
; 81ca7

Function81ca7: ; 81ca7
	inc hl
	inc hl
	inc hl
	ld a, [de]
	call Function81cbc
	ld a, [de]
	swap a
	call Function81cbc
	inc de
	ld a, [de]
	call Function81cbc
	ld a, [de]
	swap a
Function81cbc: ; 81cbc
	and $f
	add $70
	ld [hld], a
	ret
; 81cc2

Function81cc2: ; 81cc2
	ld a, [$ffa9]
	and $2
	jr nz, .asm_81cdf
	ld a, [$ffa9]
	and $1
	jr nz, .asm_81ce5
	ld a, [wcf64]
	and $3
	ld e, a
	ld d, 0
	ld hl, Jumptable_81d02
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

.asm_81cdf
	ld a, $4
	ld [wcf63], a
	ret

.asm_81ce5
	ld a, [DefaultFlypoint]
	and a
	ret nz
	ld a, [wd003]
	xor $4
	ld [wd003], a
	ld c, a
	ld b, 0
	ld hl, PokemonPalettes
	add hl, bc
	call Function818fd
	ld a, $0
	ld [wcf63], a
	ret
; 81d02

Jumptable_81d02: ; 81d02
	dw Function81d0a
	dw Function81d34
	dw Function81d46
	dw Function81d58
; 81d0a

Function81d0a: ; 81d0a
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function81d89
	ld a, [hl]
	and $20
	jr nz, .asm_81d1d
	ld a, [hl]
	and $10
	jr nz, .asm_81d28
	ret

.asm_81d1d
	xor a
	ld [wcf65], a
	ld de, wc608
	call Function81ea5
	ret

.asm_81d28
	ld a, $1
	ld [wcf65], a
	ld de, wc608 + 2
	call Function81ea5
	ret

Function81d34: ; 81d34
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function81d89
	ld a, [hl]
	and $40
	jr nz, Function81d84
	ld hl, wc608 + 10
	jr Function81d63

Function81d46: ; 81d46
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function81d89
	ld a, [hl]
	and $40
	jr nz, Function81d84
	ld hl, wc608 + 11
	jr Function81d63

Function81d58: ; 81d58
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, Function81d84
	ld hl, wc608 + 12
Function81d63: ; 81d63
	ld a, [$ffa9]
	and $10
	jr nz, Function81d70
	ld a, [$ffa9]
	and $20
	jr nz, Function81d77
	ret

Function81d70: ; 81d70
	ld a, [hl]
	cp $1f
	ret nc
	inc [hl]
	jr Function81d7b

Function81d77: ; 81d77
	ld a, [hl]
	and a
	ret z
	dec [hl]
Function81d7b: ; 81d7b
	call Function81e67
	ld a, $2
	ld [wcf63], a
	ret

Function81d84: ; 81d84
	ld hl, wcf64
	dec [hl]
	ret

Function81d89: ; 81d89
	ld hl, wcf64
	inc [hl]
	ret
; 81d8e

Function81d8e: ; 81d8e
	hlcoord 0, 10
	ld bc, $00a0
	ld a, $6f
	call ByteFill
	hlcoord 2, 12
	ld de, String_81fcd
	call PlaceString
	xor a
	ld [wd004], a
	call Function81df4
	ld a, $5
	ld [wcf63], a
	ret
; 81daf

Function81daf: ; 81daf
	ld hl, hJoyPressed
	ld a, [hl]
	and $2
	jr nz, .asm_81dbb
	call Function81dc7
	ret

.asm_81dbb
	ld a, $0
	ld [wcf63], a
	ret
; 81dc1

Function81dc1: ; 81dc1
	ld hl, wcf63
	set 7, [hl]
	ret
; 81dc7

Function81dc7: ; 81dc7
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, .asm_81dd5
	ld a, [hl]
	and $80
	jr nz, .asm_81de2
	ret

.asm_81dd5
	ld a, [wd004]
	cp $3b
	jr z, .asm_81ddf
	inc a
	jr .asm_81ded

.asm_81ddf
	xor a
	jr .asm_81ded

.asm_81de2
	ld a, [wd004]
	and a
	jr z, .asm_81deb
	dec a
	jr .asm_81ded

.asm_81deb
	ld a, $3b
.asm_81ded
	ld [wd004], a
	call Function81df4
	ret
; 81df4

Function81df4: ; 81df4
	hlcoord 10, 11
	call Function81e5e
	hlcoord 10, 12
	call Function81e5e
	hlcoord 10, 13
	call Function81e5e
	hlcoord 10, 14
	call Function81e5e
	ld a, [wd004]
	inc a
	ld [wd265], a
	predef GetTMHMMove
	ld a, [wd265]
	ld [wd262], a
	call GetMoveName
	hlcoord 10, 12
	call PlaceString
	ld a, [wd004]
	call Function81e55
	ld [CurItem], a
	predef CanLearnTMHMMove
	ld a, c
	and a
	ld de, String_81e46
	jr nz, .asm_81e3f
	ld de, String_81e4d
.asm_81e3f
	hlcoord 10, 14
	call PlaceString
	ret
; 81e46

String_81e46: db "おぼえられる@" ; can be taught
String_81e4d: db "おぼえられない@" ; cannot be taught
; 81e55

Function81e55: ; 81e55
	cp $32
	jr c, .asm_81e5b
	inc a
	inc a
.asm_81e5b
	add $bf
	ret
; 81e5e

Function81e5e: ; 81e5e
	ld bc, $000a
	ld a, $6f
	call ByteFill
	ret
; 81e67

Function81e67: ; 81e67
	ld a, [wc608 + 10]
	and $1f
	ld e, a
	ld a, [wc608 + 11]
	and $7
	sla a
	swap a
	or e
	ld e, a
	ld a, [wc608 + 11]
	and $18
	sla a
	swap a
	ld d, a
	ld a, [wc608 + 12]
	and $1f
	sla a
	sla a
	or d
	ld d, a
	ld a, [wcf65]
	and a
	jr z, .asm_81e9c
	ld a, e
	ld [wc608 + 2], a
	ld a, d
	ld [wc608 + 3], a
	ret

.asm_81e9c
	ld a, e
	ld [wc608], a
	ld a, d
	ld [wc608 + 1], a
	ret
; 81ea5

Function81ea5: ; 81ea5
	ld a, [de]
	and $1f
	ld [wc608 + 10], a
	ld a, [de]
	and $e0
	swap a
	srl a
	ld b, a
	inc de
	ld a, [de]
	and $3
	swap a
	srl a
	or b
	ld [wc608 + 11], a
	ld a, [de]
	and $7c
	srl a
	srl a
	ld [wc608 + 12], a
	ret
; 81eca

Function81eca: ; 81eca
	ld a, [wcf66]
	inc a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld de, OverworldMap
	add hl, de
	ld e, l
	ld d, h
	ld hl, wc608
	ld bc, $0004
	call CopyBytes
	ret
; 81ee3

Function81ee3: ; 81ee3
.asm_81ee3
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .asm_81ee3
	ret
; 81efc

Function81f0c: ; 81f0c
	ld a, [wcfbe]
	push af
	set 7, a
	ld [wcfbe], a
	call Function81f1d
	pop af
	ld [wcfbe], a
	ret
; 81f1d

Function81f1d: ; 81f1d
	ld a, [hl]
	and $7
	ret z
	ld b, a
.asm_81f22
	push bc
	xor a
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	ld b, $10
.asm_81f2c
	ld e, $8
	ld a, [hli]
	ld d, a
.asm_81f30
	bit 0, d
	ld a, $10
	jr nz, .asm_81f38
	ld a, $20
.asm_81f38
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	rr d
	dec e
	jr nz, .asm_81f30
	dec b
	jr nz, .asm_81f2c
	ld a, $20
	ld [rJOYP], a
	ld a, $30
	ld [rJOYP], a
	ld de, 7000
.asm_81f51
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .asm_81f51
	pop bc
	dec b
	jr nz, .asm_81f22
	ret
; 81f5e

Function81f5e: ; 81f5e
	ld a, $6f
	hlcoord 10, 0
	ld [hl], a
	hlcoord 15, 0
	ld [hl], a
	hlcoord 1, 11
	ld [hl], a
	hlcoord 1, 13
	ld [hl], a
	hlcoord 1, 15
	ld [hl], a
	ld a, [wcf63]
	cp $3
	jr nz, .asm_81fc9
	ld a, [wcf64]
	and a
	jr z, .asm_81f8d
	dec a
	hlcoord 1, 11
	ld bc, $0028
	call AddNTimes
	ld [hl], $ed
.asm_81f8d
	ld a, [wcf65]
	and a
	jr z, .asm_81f98
	hlcoord 15, 0
	jr .asm_81f9b

.asm_81f98
	hlcoord 10, 0
.asm_81f9b
	ld [hl], $ed
	ld b, $70
	ld c, $5
	ld hl, Sprites
	ld de, wc608 + 10
	call .asm_81fb7
	ld de, wc608 + 11
	call .asm_81fb7
	ld de, wc608 + 12
	call .asm_81fb7
	ret

.asm_81fb7
	ld a, b
	ld [hli], a
	ld a, [de]
	add a
	add a
	add $18
	ld [hli], a
	xor a
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $10
	add b
	ld b, a
	inc c
	ret

.asm_81fc9
	call ClearSprites
	ret
; 81fcd

String_81fcd: ; 81fcd
	db   "おわりますか?" ; Are you finished?
	next "はい", $f2, $f2, $f2, $7a ; YES (A)
	next "いいえ",    $f2, $f2, $7b ; NO  (B)
	db   "@"
; 81fe3

DebugColorTestGFX:
INCBIN "gfx/debug/color_test.2bpp"

TilesetColorTest:
	ret
	xor a
	ld [wcf63], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	ld [$ffde], a
	call ClearSprites
	call Function2173
	call Function3200
	xor a
	ld [hBGMapMode], a
	ld de, DebugColorTestGFX + $10
	ld hl, $96a0
	lb bc, BANK(DebugColorTestGFX), $16
	call Request2bpp
	ld de, DebugColorTestGFX
	ld hl, VTiles1
	lb bc, BANK(DebugColorTestGFX), 1
	call Request2bpp
	ld a, $9c
	ld [$ffd7], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $6f
	call ByteFill
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7
	call ByteFill
	ld de, $0015
	ld a, $6c
	call Function821d2
	ld de, $001a
	ld a, $6d
	call Function821d2
	ld de, $001f
	ld a, $6e
	call Function821d2
	ld de, $0024
	ld a, $6f
	call Function821d2
	call Function821f4
	call Function8220f
	call Function3200
	ld [wcf63], a
	ld a, $40
	ld [hWY], a
	ret
; 821d2

Function821d2: ; 821d2
	hlcoord 0, 0
	call Function821de
Function821d8: ; 821d8
	ld a, [wcf64]
	hlcoord 0, 0, AttrMap
Function821de: ; 821de
	add hl, de
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld bc, $0010
	add hl, bc
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld bc, $0010
	add hl, bc
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret
; 821f4

Function821f4: ; 821f4
	hlcoord 2, 4
	call Function82203
	hlcoord 2, 6
	call Function82203
	hlcoord 2, 8
Function82203: ; 82203
	ld a, $6a
	ld [hli], a
	ld bc, $000f
	ld a, $6b
	call ByteFill
	ret
; 8220f

Function8220f: ; 8220f
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, [wcf64]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, Unkn1Pals
	add hl, de
	ld de, wc608
	ld bc, $0008
	call CopyBytes
	ld de, wc608
	call Function81ea5
	pop af
	ld [rSVBK], a
	ret
; 82236

Function82236: ; 82236
	ld hl, $ffa9
	ld a, [hl]
	and $4
	jr nz, .asm_82247
	ld a, [hl]
	and $2
	jr nz, .asm_82299
	call Function822f0
	ret

.asm_82247
	ld hl, wcf64
	ld a, [hl]
	inc a
	and $7
	cp $7
	jr nz, .asm_82253
	xor a
.asm_82253
	ld [hl], a
	ld de, $0015
	call Function821d8
	ld de, $001a
	call Function821d8
	ld de, $001f
	call Function821d8
	ld de, $0024
	call Function821d8
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, BGPals
	ld a, [wcf64]
	ld bc, $0008
	call AddNTimes
	ld de, wc608
	ld bc, $0008
	call CopyBytes
	pop af
	ld [rSVBK], a
	ld a, $2
	ld [hBGMapMode], a
	ld c, $3
	call DelayFrames
	ld a, $1
	ld [hBGMapMode], a
	ret

.asm_82299
	call ClearSprites
	ld a, [hWY]
	xor $d0
	ld [hWY], a
	ret
; 822a3

Function822a3: ; 822a3
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, BGPals
	ld a, [wcf64]
	ld bc, $0008
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wc608
	ld bc, $0008
	call CopyBytes
	hlcoord 1, 0
	ld de, wc608
	call Function81ca7
	hlcoord 6, 0
	ld de, wc608 + 2
	call Function81ca7
	hlcoord 11, 0
	ld de, wc608 + 4
	call Function81ca7
	hlcoord 16, 0
	ld de, wc608 + 6
	call Function81ca7
	pop af
	ld [rSVBK], a
	ld a, $1
	ld [hCGBPalUpdate], a
	call DelayFrame
	ret
; 822f0

Function822f0: ; 822f0
	ld a, [wcf65]
	and 3
	ld e, a
	ld d, 0
	ld hl, Jumptable_82301
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 82301

Jumptable_82301: ; 82301
	dw Function82309
	dw Function82339
	dw Function8234b
	dw Function8235d
; 82309

Function82309: ; 82309
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function8238c
	ld a, [hl]
	and $20
	jr nz, .asm_8231c
	ld a, [hl]
	and $10
	jr nz, .asm_82322
	ret

.asm_8231c
	ld a, [wcf66]
	dec a
	jr .asm_82326

.asm_82322
	ld a, [wcf66]
	inc a
.asm_82326
	and $3
	ld [wcf66], a
	ld e, a
	ld d, $0
	ld hl, wc608
	add hl, de
	add hl, de
	ld e, l
	ld d, h
	call Function81ea5
	ret

Function82339: ; 82338
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function8238c
	ld a, [hl]
	and $40
	jr nz, Function82387
	ld hl, wc608 + 10
	jr Function82368

Function8234b: ; 8234b
	ld hl, $ffa9
	ld a, [hl]
	and $80
	jr nz, Function8238c
	ld a, [hl]
	and $40
	jr nz, Function82387
	ld hl, wc608 + 11
	jr Function82368

Function8235d: ; 8235d
	ld hl, $ffa9
	ld a, [hl]
	and $40
	jr nz, Function82387
	ld hl, wc608 + 12
Function82368: ; 82368
	ld a, [$ffa9]
	and $10
	jr nz, .asm_82375
	ld a, [$ffa9]
	and $20
	jr nz, .asm_8237c
	ret

.asm_82375
	ld a, [hl]
	cp $1f
	ret nc
	inc [hl]
	jr .asm_82380

.asm_8237c
	ld a, [hl]
	and a
	ret z
	dec [hl]
.asm_82380
	call Function82391
	call Function822a3
	ret

Function82387: ; 82387
	ld hl, wcf65
	dec [hl]
	ret

Function8238c: ; 8238c
	ld hl, wcf65
	inc [hl]
	ret
; 82391

Function82391: ; 82391
	ld a, [wc608 + 10]
	and $1f
	ld e, a
	ld a, [wc608 + 11]
	and $7
	sla a
	swap a
	or e
	ld e, a
	ld a, [wc608 + 11]
	and $18
	sla a
	swap a
	ld d, a
	ld a, [wc608 + 12]
	and $1f
	sla a
	sla a
	or d
	ld d, a
	ld a, [wcf66]
	ld c, a
	ld b, $0
	ld hl, wc608
	add hl, bc
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d
	ret
; 823c6

Function823c6: ; 823c6
	ret

Function823c7: ; 823c7
	ret
; 823c8

SECTION "bank21", ROMX, BANK[$21]

Function84000: ; 84000
	ld hl, OverworldMap
	ld bc, $040c
	xor a
	call Function842ab
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [wc2d5], a
	ld hl, wc2d4
	set 0, [hl]
	ld a, [GBPrinter]
	ld [wcbfb], a
	xor a
	ld [wcf63], a
	ret
; 84022

Function84022: ; 84022
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_84031
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 84031

Jumptable_84031: ; 84031 (21:4031)
	dw Function84077
	dw Function84143
	dw Function84120
	dw Function84099
	dw Function84180
	dw Function8412e
	dw Function840c5
	dw Function84180
	dw Function84120
	dw Function840de
	dw Function84180
	dw Function84120
	dw Function841a1
	dw Function84063
	dw Function8406d
	dw Function84120
	dw Function84103
	dw Function84071
	dw Function841b0
	dw Function841b3

Function84059: ; 84059 (21:4059)
	ld hl, wcf63
	inc [hl]
	ret

Function8405e: ; 8405e (21:405e)
	ld hl, wcf63
	dec [hl]
	ret

Function84063: ; 84063 (21:4063)
	xor a
	ld [wca89], a
	ld hl, wcf63
	set 7, [hl]
	ret

Function8406d: ; 8406d (21:406d)
	call Function84059
	ret

Function84071: ; 84071 (21:4071)
	ld a, $1
	ld [wcf63], a
	ret

Function84077: ; 84077 (21:4077)
	call Function841fb
	ld hl, Unknown_842b7
	call Function841e2
	xor a
	ld [wca8e], a
	ld [wca8f], a
	ld a, [wcf65]
	ld [wca81], a
	call Function84059
	call Function841c3
	ld a, $1
	ld [wcbf8], a
	ret

Function84099: ; 84099 (21:4099)
	call Function841fb
	ld hl, wca81
	ld a, [hl]
	and a
	jr z, Function840c5
	ld hl, Unknown_842c3
	call Function841e2
	call Function84260
	ld a, $80
	ld [wca8e], a
	ld a, $2
	ld [wca8f], a
	call Function84219
	call Function84059
	call Function841c3
	ld a, $2
	ld [wcbf8], a
	ret

Function840c5: ; 840c5 (21:40c5)
	ld a, $6
	ld [wcf63], a
	ld hl, Unknown_842c9
	call Function841e2
	xor a
	ld [wca8e], a
	ld [wca8f], a
	call Function84059
	call Function841c3
	ret

Function840de: ; 840de (21:40de)
	call Function841fb
	ld hl, Unknown_842bd
	call Function841e2
	call Function84249
	ld a, $4
	ld [wca8e], a
	ld a, $0
	ld [wca8f], a
	call Function84219
	call Function84059
	call Function841c3
	ld a, $3
	ld [wcbf8], a
	ret

Function84103: ; 84103 (21:4103)
	call Function841fb
	ld hl, Unknown_842b7
	call Function841e2
	xor a
	ld [wca8e], a
	ld [wca8f], a
	ld a, [wcf65]
	ld [wca81], a
	call Function84059
	call Function841c3
	ret

Function84120: ; 84120 (21:4120)
	ld hl, wca8b
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	call Function84059
	ret

Function8412e: ; 8412e (21:412e)
	ld hl, wca8b
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	ld hl, wca81
	dec [hl]
	call Function8405e
	call Function8405e
	ret

Function84143: ; 84143 (21:4143)
	ld a, [wc2d5]
	and a
	ret nz
	ld a, [wca88]
	cp $ff
	jr nz, .asm_84156
	ld a, [wca89]
	cp $ff
	jr z, .asm_84172
.asm_84156
	ld a, [wca88]
	cp $81
	jr nz, .asm_84172
	ld a, [wca89]
	cp $0
	jr nz, .asm_84172
	ld hl, wc2d4
	set 1, [hl]
	ld a, $5
	ld [wca8a], a
	call Function84059
	ret

.asm_84172
	ld a, $ff
	ld [wca88], a
	ld [wca89], a
	ld a, $e
	ld [wcf63], a
	ret

Function84180: ; 84180 (21:4180)
	ld a, [wc2d5]
	and a
	ret nz
	ld a, [wca89]
	and $f0
	jr nz, .asm_8419b
	ld a, [wca89]
	and $1
	jr nz, .asm_84197
	call Function84059
	ret

.asm_84197
	call Function8405e
	ret

.asm_8419b
	ld a, $12
	ld [wcf63], a
	ret

Function841a1: ; 841a1 (21:41a1)
	ld a, [wc2d5]
	and a
	ret nz
	ld a, [wca89]
	and $f3
	ret nz
	call Function84059
	ret

Function841b0: ; 841b0 (21:41b0)
	call Function84059
Function841b3: ; 841b3 (21:41b3)
	ld a, [wc2d5]
	and a
	ret nz
	ld a, [wca89]
	and $f0
	ret nz
	xor a
	ld [wcf63], a
	ret

Function841c3: ; 841c3 (21:41c3)
	ld a, [wc2d5]
	and a
	jr nz, Function841c3
	xor a
	ld [wca8c], a
	ld [wca8d], a
	ld a, $1
	ld [wc2d5], a
	ld a, $88
	ld [rSB], a ; $ff00+$1
	ld a, $1
	ld [rSC], a ; $ff00+$2
	ld a, $81
	ld [rSC], a ; $ff00+$2
	ret

Function841e2: ; 841e2 (21:41e2)
	ld a, [hli]
	ld [wca82], a
	ld a, [hli]
	ld [wca83], a
	ld a, [hli]
	ld [wca84], a
	ld a, [hli]
	ld [wca85], a
	ld a, [hli]
	ld [wca86], a
	ld a, [hl]
	ld [wca87], a
	ret

Function841fb: ; 841fb (21:41fb)
	xor a
	ld hl, wca82
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wca86
	ld [hli], a
	ld [hl], a
	xor a
	ld [wca8e], a
	ld [wca8f], a
	ld hl, OverworldMap
	ld bc, $280
	call Function842ab
	ret

Function84219: ; 84219 (21:4219)
	ld hl, $0
	ld bc, $4
	ld de, wca82
	call Function8423c
	ld a, [wca8e]
	ld c, a
	ld a, [wca8f]
	ld b, a
	ld de, OverworldMap
	call Function8423c
	ld a, l
	ld [wca86], a
	ld a, h
	ld [wca87], a
	ret

Function8423c: ; 8423c (21:423c)
	ld a, [de]
	inc de
	add l
	jr nc, .asm_84242
	inc h
.asm_84242
	ld l, a
	dec bc
	ld a, c
	or b
	jr nz, Function8423c
	ret

Function84249: ; 84249 (21:4249)
	ld a, $1
	ld [OverworldMap], a
	ld a, [wcbfa]
	ld [wc801], a
	ld a, $e4
	ld [wc802], a
	ld a, [wcbfb]
	ld [wc803], a
	ret

Function84260: ; 84260 (21:4260)
	ld a, [wca81]
	xor $ff
	ld d, a
	ld a, [wcf65]
	inc a
	add d
	ld hl, wca90
	ld de, $28
.asm_84271
	and a
	jr z, .asm_84278
	add hl, de
	dec a
	jr .asm_84271

.asm_84278
	ld e, l
	ld d, h
	ld hl, OverworldMap
	ld c, $28
.asm_8427f
	ld a, [de]
	inc de
	push bc
	push de
	push hl
	swap a
	ld d, a
	and $f0
	ld e, a
	ld a, d
	and $f
	ld d, a
	and $8
	ld a, d
	jr nz, .asm_84297
	or $90
	jr .asm_84299

.asm_84297
	or $80
.asm_84299
	ld d, a
	lb bc, $21, 1
	call Request2bpp
	pop hl
	ld de, $10
	add hl, de
	pop de
	pop bc
	dec c
	jr nz, .asm_8427f
	ret

Function842ab: ; 842ab
	push de
	ld e, a
.asm_842ad
	ld [hl], e
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_842ad
	ld a, e
	pop de
	ret
; 842b7

Unknown_842b7: db  1, 0, $00, 0,  1, 0
Unknown_842bd: db  2, 0, $04, 0,  0, 0
Unknown_842c3: db  4, 0, $80, 2,  0, 0
Unknown_842c9: db  4, 0, $00, 0,  4, 0
Unknown_842cf: db  8, 0, $00, 0,  8, 0 ; unused
Unknown_842d5: db 15, 0, $00, 0, 15, 0 ; unused
; 842db

Function842db:: ; 842db
	ld a, [wc2d5]
	add a
	ld e, a
	ld d, 0
	ld hl, Jumptable_842ea
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 842ea

Jumptable_842ea: ; 842ea (21:42ea)
	dw Function8432f
	dw Function84330
	dw Function84339
	dw Function84343
	dw Function8434d
	dw Function84357
	dw Function84361
	dw Function8438b
	dw Function84395
	dw Function8439f
	dw Function843a8
	dw Function843b6
	dw Function84330
	dw Function843c0
	dw Function843c9
	dw Function843c9
	dw Function843c9
	dw Function843c0
	dw Function843c9
	dw Function8439f
	dw Function843a8
	dw Function843e6
	dw Function84330
	dw Function843d2
	dw Function843c9
	dw Function843c9
	dw Function843c9
	dw Function843d2
	dw Function843c9
	dw Function8439f
	dw Function843a8
	dw Function843b6

Function8432a: ; 8432a (21:432a)
	ld hl, wc2d5
	inc [hl]
	ret

Function8432f: ; 8432f (21:432f)
	ret

Function84330: ; 84330 (21:4330)
	ld a, $33
	call Function843db
	call Function8432a
	ret

Function84339: ; 84339 (21:4339)
	ld a, [wca82]
	call Function843db
	call Function8432a
	ret

Function84343: ; 84343 (21:4343)
	ld a, [wca83]
	call Function843db
	call Function8432a
	ret

Function8434d: ; 8434d (21:434d)
	ld a, [wca84]
	call Function843db
	call Function8432a
	ret

Function84357: ; 84357 (21:4357)
	ld a, [wca85]
	call Function843db
	call Function8432a
	ret

Function84361: ; 84361 (21:4361)
	ld hl, wca8e
	ld a, [hli]
	ld d, [hl]
	ld e, a
	or d
	jr z, .asm_84388
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	ld a, [wca8c]
	ld e, a
	ld a, [wca8d]
	ld d, a
	ld hl, OverworldMap
	add hl, de
	inc de
	ld a, e
	ld [wca8c], a
	ld a, d
	ld [wca8d], a
	ld a, [hl]
	call Function843db
	ret

.asm_84388
	call Function8432a
Function8438b: ; 8438b (21:438b)
	ld a, [wca86]
	call Function843db
	call Function8432a
	ret

Function84395: ; 84395 (21:4395)
	ld a, [wca87]
	call Function843db
	call Function8432a
	ret

Function8439f: ; 8439f (21:439f)
	ld a, $0
	call Function843db
	call Function8432a
	ret

Function843a8: ; 843a8 (21:43a8)
	ld a, [rSB] ; $ff00+$1
	ld [wca88], a
	ld a, $0
	call Function843db
	call Function8432a
	ret

Function843b6: ; 843b6 (21:43b6)
	ld a, [rSB] ; $ff00+$1
	ld [wca89], a
	xor a
	ld [wc2d5], a
	ret

Function843c0: ; 843c0 (21:43c0)
	ld a, $f
	call Function843db
	call Function8432a
	ret

Function843c9: ; 843c9 (21:43c9)
	ld a, $0
	call Function843db
	call Function8432a
	ret

Function843d2: ; 843d2 (21:43d2)
	ld a, $8
	call Function843db
	call Function8432a
	ret

Function843db: ; 843db (21:43db)
	ld [rSB], a ; $ff00+$1
	ld a, $1
	ld [rSC], a ; $ff00+$2
	ld a, $81
	ld [rSC], a ; $ff00+$2
	ret

Function843e6: ; 843e6 (21:43e6)
	ld a, [rSB] ; $ff00+$1
	ld [wca89], a
	xor a
	ld [wc2d5], a
	ret

Function843f0: ; 843f0
.asm_843f0
	call Functiona57
	call Function846f6
	jr c, .asm_8440f
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_8440d
	call Function84022
	call Function84757
	call Function84785
	call DelayFrame
	jr .asm_843f0

.asm_8440d
	and a
	ret

.asm_8440f
	scf
	ret
; 84411

Function84411: ; 84411
	xor a
	ld [wc2d4], a
	ld [wc2d5], a
	ret
; 84419

Function84419: ; 84419
	push af
	call Function84000
	pop af
	ld [wcbfa], a
	call Function84728
	ret
; 84425

Function84425: ; 84425
	call Function222a
	call Function84753
	ret
; 8442c

Function8442c: ; 8442c
	ld a, [wcf65]
	push af
	ld hl, VTiles1
	ld de, FontInversed
	lb bc, BANK(FontInversed), $80
	call Request1bpp
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	call Function84000
	ld a, $10
	ld [wcbfa], a
	callba Function1dc1b0
	call ClearTileMap
	ld a, $e4
	call DmgToCgbBGPals
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $8
	ld [wcf65], a
	call Function84742
	call Function843f0
	jr c, .asm_8449d
	call Function84411
	ld c, $c
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	call Function84000
	ld a, $3
	ld [wcbfa], a
	callba Function1dc213
	call Function84742
	ld a, $4
	ld [wcf65], a
	call Function843f0
.asm_8449d
	pop af
	ld [hVBlank], a
	call Function84411
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	ld c, $8
.asm_844ae
	call LowVolume
	call DelayFrame
	dec c
	jr nz, .asm_844ae
	pop af
	ld [wcf65], a
	ret
; 844bc

Function844bc: ; 844bc (21:44bc)
	ld a, [wcf65]
	push af
	ld a, $9
	ld [wcf65], a
	ld a, e
	ld [wd004], a
	ld a, d
	ld [StartFlypoint], a
	ld a, b
	ld [EndFlypoint], a
	ld a, c
	ld [MovementBuffer], a
	xor a
	ld [$ffac], a
	ld [wd003], a
	call Function8474c
	ld a, [rIE] ; $ff00+$ff
	push af
	xor a
	ld [rIF], a ; $ff00+$f
	ld a, $9
	ld [rIE], a ; $ff00+$ff
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function84817
	ld a, $10
	call Function84419
	call Function84559
	jr c, .asm_84545
	call Function84411
	ld c, $c
	call DelayFrames
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function8486f
	ld a, $0
	call Function84419
	call Function84559
	jr c, .asm_84545
	call Function84411
	ld c, $c
	call DelayFrames
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function84893
	ld a, $0
	call Function84419
	call Function84559
	jr c, .asm_84545
	call Function84411
	ld c, $c
	call DelayFrames
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function848b7
	ld a, $3
	call Function84419
	call Function84559
.asm_84545
	pop af
	ld [hVBlank], a
	call Function84411
	xor a
	ld [rIF], a ; $ff00+$f
	pop af
	ld [rIE], a ; $ff00+$ff
	call Function84425
	pop af
	ld [wcf65], a
	ret

Function84559: ; 84559 (21:4559)
	call Function84742
	call Function843f0
	ret

Function84560: ; 84560
	ld a, [wcf65]
	push af
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	xor a
	ld [hBGMapMode], a
	call Function309d
	callba Function16dac
	ld a, $0
	call Function84419
	call Function30b4
	call Function84742
	ld a, $9
	ld [wcf65], a
.asm_84597
	call Functiona57
	call Function846f6
	jr c, .asm_845c0
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_845c0
	call Function84022
	ld a, [wcf63]
	cp $2
	jr nc, .asm_845b5
	ld a, $3
	ld [wca81], a
.asm_845b5
	call Function84757
	call Function84785
	call DelayFrame
	jr .asm_84597

.asm_845c0
	pop af
	ld [hVBlank], a
	call Function84411
	call Function30b4
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	pop af
	ld [wcf65], a
	ret
; 845d4

Function845d4: ; 845d4
	call Function845db
	call Function84425
	ret
; 845db

Function845db: ; 845db
	ld a, [wcf65]
	push af
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	xor a
	ld [hBGMapMode], a
	ld a, $13
	call Function84419
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $9
	ld [wcf65], a
	call Function843f0
	pop af
	ld [hVBlank], a
	call Function84411
	call Function84735
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	pop af
	ld [wcf65], a
	ret
; 8461a

Function8461a: ; 8461a
	ld a, [wcf65]
	push af
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	xor a
	ld [hBGMapMode], a
	callba Function1dc381
	ld a, $10
	call Function84419
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $8
	ld [wcf65], a
	call Function84742
	call Function843f0
	jr c, .asm_84671
	call Function84411
	ld c, $c
	call DelayFrames
	xor a
	ld [hBGMapMode], a
	callba Function1dc47b
	ld a, $3
	call Function84419
	ld a, $9
	ld [wcf65], a
	call Function84742
	call Function843f0
.asm_84671
	pop af
	ld [hVBlank], a
	call Function84411
	call Function84735
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	pop af
	ld [wcf65], a
	ret
; 84688

Function84688: ; 84688
	ld a, [wcf65]
	push af
	callba Function1dd709
	xor a
	ld [$ffac], a
	call Function8474c
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $9
	ld [rIE], a
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $4
	ld a, $10
	call Function84419
	call Function84742
	ld a, $9
	ld [wcf65], a
	call Function843f0
	jr c, .asm_846e2
	call Function84411
	ld c, $c
	call DelayFrames
	call Function309d
	xor a
	ld [hBGMapMode], a
	callba Function1dd7ae
	ld a, $3
	call Function84419
	call Function30b4
	call Function84742
	ld a, $9
	ld [wcf65], a
	call Function843f0
.asm_846e2
	pop af
	ld [hVBlank], a
	call Function84411
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	call Function84425
	pop af
	ld [wcf65], a
	ret
; 846f6

Function846f6: ; 846f6
	ld a, [hJoyDown]
	and $2
	jr nz, .asm_846fe
	and a
	ret

.asm_846fe
	ld a, [wca80]
	cp $c
	jr nz, .asm_84722
.asm_84705
	ld a, [wc2d5]
	and a
	jr nz, .asm_84705
	ld a, $16
	ld [wc2d5], a
	ld a, $88
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_8471c
	ld a, [wc2d5]
	and a
	jr nz, .asm_8471c
.asm_84722
	ld a, $1
	ld [$ffac], a
	scf
	ret
; 84728

Function84728: ; 84728
	hlcoord 0, 0
	ld de, wca90
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyBytes
	ret
; 84735

Function84735: ; 84735
	ld hl, wca90
	ld de, TileMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call CopyBytes
	ret
; 84742

Function84742: ; 84742
	xor a
	ld [hJoyReleased], a
	ld [hJoyPressed], a
	ld [hJoyDown], a
	ld [$ffa9], a
	ret
; 8474c

Function8474c: ; 8474c
	ld de, MUSIC_PRINTER
	call PlayMusic2
	ret
; 84753

Function84753: ; 84753
	call RestartMapMusic
	ret
; 84757

Function84757: ; 84757
	ld a, [wca88]
	cp $ff
	jr nz, .asm_84765
	ld a, [wca89]
	cp $ff
	jr z, .asm_8477f
.asm_84765
	ld a, [wca89]
	and $e0
	ret z
	bit 7, a
	jr nz, .asm_8477b
	bit 6, a
	jr nz, .asm_84777
	ld a, $6
	jr .asm_84781

.asm_84777
	ld a, $7
	jr .asm_84781

.asm_8477b
	ld a, $4
	jr .asm_84781

.asm_8477f
	ld a, $5
.asm_84781
	ld [wcbf8], a
	ret
; 84785

Function84785: ; 84785
	ld a, [wcbf8]
	and a
	ret z
	push af
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 5
	ld bc, $0a12
	call TextBox
	pop af
	ld e, a
	ld d, 0
	ld hl, Unknown_84807
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 1, 7
	ld a, BANK(GBPrinterStrings)
	call FarString
	hlcoord 2, 15
	ld de, String_847f5
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	xor a
	ld [wcbf8], a
	ret
; 847bd

Function847bd: ; 847bd
	ld a, [wcbf8]
	and a
	ret z
	push af
	xor a
	ld [hBGMapMode], a
	hlcoord 2, 4
	ld bc, $0d10
	call ClearBox
	pop af
	ld e, a
	ld d, 0
	ld hl, Unknown_84807
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 4, 7
	ld a, BANK(GBPrinterStrings)
	call FarString
	hlcoord 4, 15
	ld de, String_847f5
	call PlaceString
	ld a, $1
	ld [hBGMapMode], a
	xor a
	ld [wcbf8], a
	ret
; 847f5

String_847f5:
	db "Press B to Cancel@"
; 84807

Unknown_84807: ; 84807
	dw String_1dc275
	dw String_1dc276
	dw String_1dc289
	dw String_1dc29c
	dw String_1dc2ad
	dw String_1dc2e2
	dw String_1dc317
	dw String_1dc34c
; 84817

Function84817: ; 84817 (21:4817)
	xor a
	ld [wd002], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	call Function84a0e
	hlcoord 0, 0
	ld bc, $b4
	ld a, $7f
	call ByteFill
	call Function849e9
	call Function849d7
	hlcoord 4, 3
	ld de, String_84865
	call PlaceString
	ld a, [wd007]
	ld bc, 9
	ld hl, wBoxNames
	call AddNTimes
	ld d, h
	ld e, l
	hlcoord 6, 5
	call PlaceString
	ld a, $1
	call Function849c6
	hlcoord 2, 9
	ld c, $3
	call Function848e7
	ret
; 84865 (21:4865)

String_84865:
	db "#MON LIST@"
; 8486f

Function8486f: ; 8486f (21:486f)
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	call Function84a0e
	call Function849e9
	ld a, [wd003]
	and a
	ret nz
	ld a, $4
	call Function849c6
	hlcoord 2, 0
	ld c, $6
	call Function848e7
	ret

Function84893: ; 84893 (21:4893)
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	call Function84a0e
	call Function849e9
	ld a, [wd003]
	and a
	ret nz
	ld a, $a
	call Function849c6
	hlcoord 2, 0
	ld c, $6
	call Function848e7
	ret

Function848b7: ; 848b7 (21:48b7)
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	call Function84a0e
	hlcoord 1, 15
	ld bc, $212
	call ClearBox
	call Function849e9
	call Function849fc
	ld a, [wd003]
	and a
	ret nz
	ld a, $10
	call Function849c6
	hlcoord 2, 0
	ld c, $5
	call Function848e7
	ret

Function848e7: ; 848e7 (21:48e7)
	ld a, [EndFlypoint]
	call GetSRAMBank
Function848ed: ; 848ed (21:48ed)
	ld a, c
	and a
	jp z, Function84986
	dec c
	ld a, [de]
	cp $ff
	jp z, Function84981
	ld [wd265], a
	ld [CurPartySpecies], a
	push bc
	push hl
	push de
	push hl
	ld bc, $10
	ld a, $7f
	call ByteFill
	pop hl
	push hl
	call GetBasePokemonName
	pop hl
	push hl
	call PlaceString
	ld a, [CurPartySpecies]
	cp $fd
	pop hl
	jr z, .asm_84972
	ld bc, $b
	add hl, bc
	call Function8498a
	ld bc, $9
	add hl, bc
	ld a, $f3
	ld [hli], a
	push hl
	ld bc, $e
	ld a, $7f
	call ByteFill
	pop hl
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [StartFlypoint]
	ld h, a
	ld bc, $372
	add hl, bc
	ld bc, $b
	ld a, [DefaultFlypoint]
	call AddNTimes
	ld e, l
	ld d, h
	pop hl
	push hl
	call PlaceString
	pop hl
	ld bc, $b
	add hl, bc
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [StartFlypoint]
	ld h, a
	ld bc, $35
	add hl, bc
	ld bc, $20
	ld a, [DefaultFlypoint]
	call AddNTimes
	ld a, [hl]
	pop hl
	call Function383d
.asm_84972
	ld hl, DefaultFlypoint
	inc [hl]
	pop de
	pop hl
	ld bc, $3c
	add hl, bc
	pop bc
	inc de
	jp Function848ed

Function84981: ; 84981 (21:4981)
	ld a, $1
	ld [wd003], a
Function84986: ; 84986 (21:4986)
	call CloseSRAM
	ret

Function8498a: ; 8498a (21:498a)
	push hl
	ld a, [wd004]
	ld l, a
	ld a, [StartFlypoint]
	ld h, a
	ld bc, $2b
	add hl, bc
	ld bc, $20
	ld a, [DefaultFlypoint]
	call AddNTimes
	ld de, TempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [DefaultFlypoint]
	ld [CurPartyMon], a
	ld a, $3
	ld [MonType], a
	callba GetGender
	ld a, $7f
	jr c, .asm_849c3
	ld a, $ef
	jr nz, .asm_849c3
	ld a, $f5
.asm_849c3
	pop hl
	ld [hli], a
	ret

Function849c6: ; 849c6 (21:49c6)
	push hl
	ld e, a
	ld d, $0
	ld a, [wd004]
	ld l, a
	ld a, [StartFlypoint]
	ld h, a
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

Function849d7: ; 849d7 (21:49d7)
	hlcoord 0, 0
	ld a, $79
	ld [hli], a
	ld a, $7a
	ld c, $12
.asm_849e1
	ld [hli], a
	dec c
	jr nz, .asm_849e1
	ld a, $7b
	ld [hl], a
	ret

Function849e9: ; 849e9 (21:49e9)
	hlcoord 0, 0
	ld de, $13
	ld c, $12
.asm_849f1
	ld a, $7c
	ld [hl], a
	add hl, de
	ld a, $7c
	ld [hli], a
	dec c
	jr nz, .asm_849f1
	ret

Function849fc: ; 849fc (21:49fc)
	hlcoord 0, 17
	ld a, $7d
	ld [hli], a
	ld a, $7a
	ld c, $12
.asm_84a06
	ld [hli], a
	dec c
	jr nz, .asm_84a06
	ld a, $7e
	ld [hl], a
	ret

Function84a0e: ; 84a0e (21:4a0e)
	hlcoord 2, 0
	ld c, $6
.asm_84a13
	push bc
	push hl
	ld de, String84a25
	call PlaceString
	pop hl
	ld bc, $3c
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_84a13
	ret
; 84a25 (21:4a25)

String84a25: ; 84a25
	db "  ------@"
; 84a2e

INCLUDE "battle/anim_gfx.asm"

HallOfFame:: ; 0x8640e
	call Function8648e
	ld a, [StatusFlags]
	push af
	ld a, $1
	ld [wc2cd], a
	call Function2ed3
	ld a, $1
	ld [wd4b5], a
	; Enable the Pokégear map to cycle through all of Kanto
	ld hl, StatusFlags
	set 6, [hl]
	callba Function14da0
	ld hl, wd95e
	ld a, [hl]
	cp $c8
	jr nc, .asm_86436 ; 0x86433 $1
	inc [hl]
.asm_86436
	callba Function14b85
	call Function8653f
	callba Function14b5f
	xor a
	ld [wc2cd], a
	call Function864c3
	pop af
	ld b, a
	callba PlayCredits_109847
	ret
; 0x86455

BeatRed_Credits:: ; 86455
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld a, $a
	ld [MusicFade], a
	callba Function8c084
	xor a
	ld [VramState], a
	ld [$ffde], a
	callba Function4e8c2
	ld c, $8
	call DelayFrames
	call Function2ed3
	ld a, $2
	ld [wd4b5], a
	callba Function14b85
	ld a, [StatusFlags]
	res 6, a
	ld b, a
	callba PlayCredits_109847
	ret
; 8648e

Function8648e: ; 8648e
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld a, $a
	ld [MusicFade], a
	callba Function8c084
	xor a
	ld [VramState], a
	ld [$ffde], a
	callba Function4e881
	ld c, $64
	jp DelayFrames
; 864b4

Function864b4: ; 864b4
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	pop de
	call PlayMusic
	ret
; 864c3

Function864c3: ; 864c3
	xor a
	ld [wcf63], a
	call Function8671c
	jr c, .asm_864fb
	ld de, $0014
	call Function864b4
	xor a
	ld [wcf64], a
.asm_864d6
	ld a, [wcf64]
	cp $6
	jr nc, .asm_864fb
	ld hl, wc608 + 1
	ld bc, $0010
	call AddNTimes
	ld a, [hl]
	cp $ff
	jr z, .asm_864fb
	push hl
	call Function865b5
	pop hl
	call Function8650c
	jr c, .asm_864fb
	ld hl, wcf64
	inc [hl]
	jr .asm_864d6

.asm_864fb
	call Function86810
	ld a, $4
	ld [MusicFade], a
	call Function4b6
	ld c, $8
	call DelayFrames
	ret
; 8650c

Function8650c: ; 8650c
	call Function86748
	ld de, String_8652c
	hlcoord 1, 2
	call PlaceString
	call WaitBGMap
	decoord 6, 5
	ld c, $6
	predef Functiond066e
	ld c, $3c
	call DelayFrames
	and a
	ret
; 8652c

String_8652c:
	db "New Hall of Famer!@"
; 8653f

Function8653f: ; 8653f
	ld hl, OverworldMap
	ld bc, $0062
	xor a
	call ByteFill
	ld a, [wd95e]
	ld de, OverworldMap
	ld [de], a
	inc de
	ld hl, PartySpecies
	ld c, 0
.asm_86556
	ld a, [hli]
	cp $ff
	jr z, .asm_865b1
	cp EGG
	jr nz, .asm_86562
	inc c
	jr .asm_86556

.asm_86562
	push hl
	push de
	push bc
	ld a, c
	ld hl, PartyMon1Species
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	ld c, l
	ld b, h
	ld hl, $0000
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $0006
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $0015
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	push bc
	ld a, c
	ld hl, PartyMonNicknames
	ld bc, $000b
	call AddNTimes
	ld bc, $000a
	call CopyBytes
	pop bc
	inc c
	pop de
	ld hl, $0010
	add hl, de
	ld e, l
	ld d, h
	pop hl
	jr .asm_86556

.asm_865b1
	ld a, $ff
	ld [de], a
	ret
; 865b5

Function865b5: ; 865b5
	push hl
	call WhiteBGMap
	callba Function4e906
	pop hl
	ld a, [hli]
	ld [TempMonSpecies], a
	ld [CurPartySpecies], a
	inc hl
	inc hl
	ld a, [hli]
	ld [TempMonDVs], a
	ld a, [hli]
	ld [TempMonDVs + 1], a
	ld hl, TempMonDVs
	predef GetUnownLetter
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	ld de, $9310
	predef GetBackpic
	ld a, $31
	ld [$ffad], a
	hlcoord 6, 6
	ld bc, $0606
	predef FillBox
	ld a, $d0
	ld [hSCY], a
	ld a, $90
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld b, $1a
	call GetSGBLayout
	call Function32f9
	call Function86635
	xor a
	ld [wc2c6], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	hlcoord 6, 5
	call Function378b
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [hSCY], a
	call Function86643
	ret
; 86635

Function86635: ; 86635
.asm_86635
	ld a, [hSCX]
	cp $70
	ret z
	add $4
	ld [hSCX], a
	call DelayFrame
	jr .asm_86635
; 86643

Function86643: ; 86643
.asm_86643
	ld a, [hSCX]
	and a
	ret z
	dec a
	dec a
	ld [hSCX], a
	call DelayFrame
	jr .asm_86643
; 86650

Function86650: ; 86650
	call Functione58
	xor a
	ld [wcf63], a
.asm_86657
	call Function8671c
	ret c
	call Function86665
	ret c
	ld hl, wcf63
	inc [hl]
	jr .asm_86657
; 86665

Function86665: ; 86665
	xor a
	ld [wcf64], a
.asm_86669
	call Function86692
	jr c, .asm_86690
.asm_8666e
	call Functiona57
	ld hl, $ffa9
	ld a, [hl]
	and $2
	jr nz, .asm_8668e
	ld a, [hl]
	and $1
	jr nz, .asm_86688
	ld a, [hl]
	and $8
	jr nz, .asm_86690
	call DelayFrame
	jr .asm_8666e

.asm_86688
	ld hl, wcf64
	inc [hl]
	jr .asm_86669

.asm_8668e
	scf
	ret

.asm_86690
	and a
	ret
; 86692

Function86692: ; 86692
; Print the number of times the player has entered the Hall of Fame.
; If that number is above 200, print "HOF Master!" instead.

	ld a, [wcf64]
	cp $6
	jr nc, .asm_866a7
	ld hl, wc608 + 1
	ld bc, $0010
	call AddNTimes
	ld a, [hl]
	cp $ff
	jr nz, .asm_866a9
.asm_866a7
	scf
	ret

.asm_866a9
	push hl
	call WhiteBGMap
	pop hl
	call Function86748
	ld a, [wc608]
	cp 200 + 1
	jr c, .asm_866c6
	ld de, String_866fc
	hlcoord 1, 2
	call PlaceString
	hlcoord 13, 2
	jr .asm_866de

.asm_866c6
	ld de, String_8670c
	hlcoord 1, 2
	call PlaceString
	hlcoord 2, 2
	ld de, wc608
	ld bc, $0103
	call PrintNum
	hlcoord 11, 2
.asm_866de
	ld de, String_866fb
	call PlaceString
	call WaitBGMap
	ld b, $1a
	call GetSGBLayout
	call Function32f9
	decoord 6, 5
	ld c, $6
	predef Functiond066e
	and a
	ret
; 866fb

String_866fb:
	db "@"
; 866fc

String_866fc:
	db "    HOF Master!@"
; 8670c

String_8670c:
	db "    -Time Famer@"
; 8671c

Function8671c: ; 8671c
	ld a, [wcf63]
	cp $1e
	jr nc, .asm_86746
	ld hl, $b2c0
	ld bc, $0062
	call AddNTimes
	ld a, $1
	call GetSRAMBank
	ld a, [hl]
	and a
	jr z, .asm_86743
	ld de, wc608
	ld bc, $0062
	call CopyBytes
	call CloseSRAM
	and a
	ret

.asm_86743
	call CloseSRAM
.asm_86746
	scf
	ret
; 86748

Function86748: ; 86748
	xor a
	ld [hBGMapMode], a
	ld a, [hli]
	ld [TempMonSpecies], a
	ld a, [hli]
	ld [TempMonID], a
	ld a, [hli]
	ld [TempMonID + 1], a
	ld a, [hli]
	ld [TempMonDVs], a
	ld a, [hli]
	ld [TempMonDVs + 1], a
	ld a, [hli]
	ld [TempMonLevel], a
	ld de, StringBuffer2
	ld bc, $000a
	call CopyBytes
	ld a, $50
	ld [StringBuffer2 + 10], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	hlcoord 0, 0
	ld bc, $0312
	call TextBox
	hlcoord 0, 12
	ld bc, $0412
	call TextBox
	ld a, [TempMonSpecies]
	ld [CurPartySpecies], a
	ld [wd265], a
	ld hl, TempMonDVs
	predef GetUnownLetter
	xor a
	ld [wc2c6], a
	hlcoord 6, 5
	call Function378b
	ld a, [CurPartySpecies]
	cp EGG
	jr z, .asm_867f8
	hlcoord 1, 13
	ld a, $74
	ld [hli], a
	ld [hl], $f2
	hlcoord 3, 13
	ld de, wd265
	ld bc, $8103
	call PrintNum
	call GetBasePokemonName
	hlcoord 7, 13
	call PlaceString
	ld a, $3
	ld [MonType], a
	callba GetGender
	ld a, $7f
	jr c, .asm_867e2
	ld a, $ef
	jr nz, .asm_867e2
	ld a, $f5
.asm_867e2
	hlcoord 18, 13
	ld [hli], a
	hlcoord 8, 14
	ld a, $f3
	ld [hli], a
	ld de, StringBuffer2
	call PlaceString
	hlcoord 1, 16
	call PrintLevel
.asm_867f8
	hlcoord 7, 16
	ld a, $73
	ld [hli], a
	ld a, $74
	ld [hli], a
	ld [hl], $f3
	hlcoord 10, 16
	ld de, TempMonID
	ld bc, $8205
	call PrintNum
	ret
; 86810

Function86810: ; 86810
	call WhiteBGMap
	ld hl, $9630
	ld de, FontExtra + $d0
	lb bc, BANK(FontExtra), 1
	call Request2bpp
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	callba GetPlayerBackpic
	ld a, $31
	ld [$ffad], a
	hlcoord 6, 6
	ld bc, $0606
	predef FillBox
	ld a, $d0
	ld [hSCY], a
	ld a, $90
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [CurPartySpecies], a
	ld b, $1a
	call GetSGBLayout
	call Function32f9
	call Function86635
	xor a
	ld [wc2c6], a
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $7f
	call ByteFill
	callba Function88840
	xor a
	ld [$ffad], a
	hlcoord 12, 5
	ld bc, $0707
	predef FillBox
	ld a, $c0
	ld [hSCX], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld [hSCY], a
	call Function86643
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 2
	ld bc, $080a
	call TextBox
	hlcoord 0, 12
	ld bc, $0412
	call TextBox
	hlcoord 2, 4
	ld de, PlayerName
	call PlaceString
	hlcoord 1, 6
	ld a, $73
	ld [hli], a
	ld a, $74
	ld [hli], a
	ld [hl], $f3
	hlcoord 4, 6
	ld de, PlayerID
	ld bc, $8205
	call PrintNum
	hlcoord 1, 8
	ld de, .PlayTime
	call PlaceString
	hlcoord 1, 9
	ld de, GameTimeHours
	ld bc, $0204
	call PrintNum
	ld [hl], $63
	inc hl
	ld de, GameTimeMinutes
	ld bc, $8102
	call PrintNum
	ld [hl], $63
	inc hl
	ld de, GameTimeSeconds
	ld bc, $8102
	call PrintNum
	call WaitBGMap
	callba Function26601 ; Rate Dex
	ret
; 868ed

.PlayTime
	db "PLAY TIME@"
; 868f7

SECTION "bank22", ROMX, BANK[$22]

Function88000: ; 88000
	ld hl, UnknownText_0x88007
	call PrintText
	ret
; 88007

UnknownText_0x88007: ; 0x88007
	; Which APRICORN should I use?
	text_jump UnknownText_0x1bc06b
	db "@"
; 0x8800c

Function8800c: ; 8800c
	ld hl, UnknownText_0x88013
	call PrintText
	ret
; 88013

UnknownText_0x88013: ; 0x88013
	; How many should I make?
	text_jump UnknownText_0x1bc089
	db "@"
; 0x88018

Function88018: ; 88018
	call Function1d6e
	ld c, $1
	xor a
	ld [wd0e4], a
	ld [wdca4], a
.asm_88024
	push bc
	call Function88000
	pop bc
	ld a, c
	ld [MenuSelection], a
	call Function88055
	ld a, c
	ld [ScriptVar], a
	and a
	jr z, .asm_88051
	ld [CurItem], a
	ld a, [wcfa9]
	ld c, a
	push bc
	call Function8800c
	call Function880c2
	pop bc
	jr nc, .asm_88024
	ld a, [wd10c]
	ld [wdca4], a
	call Function88161
.asm_88051
	call Function1d7d
	ret
; 88055

Function88055: ; 88055
	callba Function24c64
	jr c, .asm_88083
	ld hl, MenuDataHeader_0x88086
	call Function1d3c
	ld a, [MenuSelection]
	ld [wcf88], a
	xor a
	ld [hBGMapMode], a
	call Function352f
	call Function1ad2
	call Function350c
	ld a, [wcf73]
	cp $2
	jr z, .asm_88083
	ld a, [MenuSelection]
	cp $ff
	jr nz, .asm_88084
.asm_88083
	xor a
.asm_88084
	ld c, a
	ret
; 88086

MenuDataHeader_0x88086: ; 0x88086
	db $40 ; flags
	db 01, 01 ; start coords
	db 10, 13 ; end coords
	dw MenuData2_0x8808f
	db 1 ; default option
; 0x8808e

	db 0
MenuData2_0x8808f: ; 0x8808f
	db $10 ; flags
	db 4, 7
	db 1
	dbw 0, wd1ea
	dbw BANK(Function8809f), Function8809f
	dbw BANK(Function880ab), Function880ab
	dbw BANK(NULL), NULL
Function8809f: ; 8809f
	ld a, [MenuSelection]
	and a
	ret z
	callba Function24ab4
	ret
; 880ab

Function880ab: ; 880ab
	ld a, [MenuSelection]
	ld [CurItem], a
	call Function88139
	ret z
	ld a, [wd10c]
	ld [wcf75], a
	callba Function24ac3
	ret
; 880c2

Function880c2: ; 880c2
	ld a, [CurItem]
	ld [MenuSelection], a
	call Function88139
	jr z, .asm_88109
	ld a, [wd10c]
	ld [wd10d], a
	ld a, $1
	ld [wd10c], a
	ld hl, MenuDataHeader_0x8810d
	call LoadMenuDataHeader
.asm_880de
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function1ad2
	call Function88116
	call Function88126
	call Function321c
	callba Function27a28
	jr nc, .asm_880de
	push bc
	call PlayClickSFX
	pop bc
	ld a, b
	cp $ff
	jr z, .asm_88109
	ld a, [wd10c]
	ld [wd10c], a
	scf
.asm_88109
	call Function1c17
	ret
; 8810d

MenuDataHeader_0x8810d: ; 0x8810d
	db $40 ; flags
	db 09, 06 ; start coords
	db 12, 19 ; end coords
	db 0, 0, -1, 0 ; XXX
Function88116: ; 88116
	call Function1cfd ;hl = curmenu start location in tilemap
	ld de, $0015
	add hl, de
	ld d, h
	ld e, l
	callba Function24ab4
	ret
; 88126

Function88126: ; 88126
	call Function1cfd ;hl = curmenu start location in tilemap
	ld de, $0032
	add hl, de
	ld [hl], $f1
	inc hl
	ld de, wd10c
	ld bc, $8102
	jp PrintNum
; 88139

Function88139: ; 88139
	push bc
	ld hl, NumItems
	ld a, [CurItem]
	ld c, a
	ld b, $0
.asm_88143
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_88153
	cp c
	jr nz, .asm_88143
	ld a, [hl]
	add b
	ld b, a
	jr nc, .asm_88143
	ld b, $ff
.asm_88153
	ld a, b
	sub $63
	jr c, .asm_8815a
	ld b, $63
.asm_8815a
	ld a, b
	ld [wd10c], a
	and a
	pop bc
	ret
; 88161

Function88161: ; 88161
	push de
	push bc
	ld hl, NumItems
	ld a, [CurItem]
	ld c, a
	ld e, $0
	xor a
	ld [wd107], a
	ld a, $ff
	ld [DefaultFlypoint], a
.asm_88175
	ld a, [wd107]
	inc a
	ld [wd107], a
	inc hl
	ld a, [hli]
	cp $ff
	jr z, .asm_88198
	cp c
	jr nz, .asm_88175
	ld d, $0
	push hl
	ld hl, DefaultFlypoint
	add hl, de
	inc e
	ld a, [wd107]
	dec a
	ld [hli], a
	ld a, $ff
	ld [hl], a
	pop hl
	jr .asm_88175

.asm_88198
	ld a, e
	and a
	jr z, .asm_881fa
	dec a
	jr z, .asm_881d0
	ld hl, DefaultFlypoint
.asm_881a2
	ld a, [hl]
	ld c, a
	push hl
.asm_881a5
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .asm_881c9
	ld b, a
	ld a, c
	call Function88201
	ld e, a
	ld a, b
	call Function88201
	sub e
	jr z, .asm_881bc
	jr c, .asm_881c0
	jr .asm_881a5

.asm_881bc
	ld a, c
	sub b
	jr nc, .asm_881a5
.asm_881c0
	ld a, c
	ld c, b
	ld [hl], a
	ld a, c
	pop hl
	ld [hl], a
	push hl
	jr .asm_881a5

.asm_881c9
	pop hl
	inc hl
	ld a, [hl]
	cp $ff
	jr nz, .asm_881a2
.asm_881d0
	ld hl, DefaultFlypoint
.asm_881d3
	ld a, [hl]
	cp $ff
	jr z, .asm_881fa
	push hl
	ld [wd107], a
	call Function88211
	pop hl
	ld a, [wd10c]
	and a
	jr z, .asm_881fa
	push hl
	ld a, [hli]
	ld c, a
.asm_881e9
	ld a, [hli]
	cp $ff
	jr z, .asm_881f6
	cp c
	jr c, .asm_881e9
	dec a
	dec hl
	ld [hli], a
	jr .asm_881e9

.asm_881f6
	pop hl
	inc hl
	jr .asm_881d3

.asm_881fa
	ld a, [wd10c]
	and a
	pop bc
	pop de
	ret
; 88201

Function88201: ; 88201
	push hl
	push bc
	ld hl, NumItems
	inc hl
	ld c, a
	ld b, $0
	add hl, bc
	add hl, bc
	inc hl
	ld a, [hl]
	pop bc
	pop hl
	ret
; 88211

Function88211: ; 88211
	push bc
	ld hl, NumItems
	ld a, [wd107]
	ld c, a
	ld b, $0
	inc hl
	add hl, bc
	add hl, bc
	ld a, [CurItem]
	ld c, a
	ld a, [hli]
	cp $ff
	jr z, .asm_88243
	cp c
	jr nz, .asm_88243
	ld a, [wd10c]
	ld c, a
	ld a, [hl]
	sub c
	ld b, c
	jr nc, .asm_88235
	add c
	ld b, a
.asm_88235
	push bc
	ld hl, NumItems
	ld a, b
	ld [wd10c], a
	call TossItem
	pop bc
	ld a, c
	sub b
.asm_88243
	ld [wd10c], a
	pop bc
	ret
; 88248

Function88248: ; 88248
	ld c, $c
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88253
	ld c, $e
.asm_88253
	ld a, c
	ld [TrainerClass], a
	ret
; 88258

MovePlayerPicRight: ; 88258
	hlcoord 6, 4
	ld de, 1
	jr MovePlayerPic

MovePlayerPicLeft: ; 88260
	hlcoord 13, 4
	ld de, -1
	; fallthrough
MovePlayerPic: ; 88266
; Move player pic at hl by de * 7 tiles.

	ld c, $8
.loop
	push bc
	push hl
	push de
	xor a
	ld [hBGMapMode], a
	ld bc, $0707
	predef FillBox
	xor a
	ld [hBGMapThird], a
	call WaitBGMap
	call DelayFrame
	pop de
	pop hl
	add hl, de
	pop bc
	dec c
	ret z
	push hl
	push bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld bc, $0707
	call ClearBox
	pop bc
	pop hl
	jr .loop
; 88297

ShowRivalRBNamingChoices:
	ld hl, KrisNameMenuHeader
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotGender
	ld hl, ChrisNameMenuHeader
.GotGender
	call LoadMenuDataHeader
	call Function1d81
	ld a, [wcfa9]
	dec a
	call Function1db8
	call Function1c17
	ret

ShowPlayerNamingChoices: ; 88297
	ld hl, ChrisNameMenuHeader
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotGender
	ld hl, KrisNameMenuHeader
.GotGender
	call LoadMenuDataHeader
	call Function1d81
	ld a, [wcfa9]
	dec a
	call Function1db8
	call Function1c17
	ret
; 882b5

ChrisNameMenuHeader: ; 882b5
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw MenuData2_0x882be
	db 1 ; ????
	db 0 ; default option
; 882be

MenuData2_0x882be: ; 882be
	db $91 ; flags
	db 5 ; items
	db "CHOIX@"
Unknown_882c9: ; 882c9
	db "RUST@"
	db "CARMINE@"
	db "DUSTIN@"
	db "EVAN@"
	db 2 ; displacement
	db " NOM @" ; title
; 882e5

KrisNameMenuHeader: ; 882e5
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 10 ; end coords
	dw MenuData2_0x882ee
	db 1 ; ????
	db 0 ; default option
; 882ee

MenuData2_0x882ee: ; 882ee
	db $91 ; flags
	db 5 ; items
	db "NEW NAME@"
Unknown_882f9: ; 882f9
	db "AZURE@"
	db "CELESTE@"
	db "DAPHNE@"
	db "AURORA@"
	db 2 ; displacement
	db " NAME @" ; title
; 88318

Function88318: ; 88318
	ld hl, PlayerName
	ld de, Unknown_882c9
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88328
	ld de, Unknown_882f9
.asm_88328
	call InitName
	ret
; 8832c

GetRivalRBIcon:
	ld de, ChrisSpriteGFX
	ld b, BANK(ChrisSpriteGFX)

	ld a, [PlayerGender]
	bit 0, a
	ret nz
	ld de, KrisSpriteGFX
	ld b, BANK(KrisSpriteGFX)
	ret

GetPlayerIcon: ; 8832c
; Get the player icon corresponding to gender
; Male

	ld de, ChrisSpriteGFX
	ld b, BANK(ChrisSpriteGFX)

	ld a, [PlayerGender]
	bit 0, a
	ret z

; Female

	ld de, KrisSpriteGFX
	ld b, BANK(KrisSpriteGFX)
	ret
; 8833e

Function8833e: ; 8833e
	ld hl, ChrisCardPic
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_8834b
	ld hl, KrisCardPic
.asm_8834b
	ld de, $9000
	ld bc, $230
	ld a, BANK(ChrisCardPic) ; BANK(KrisCardPic)
	call FarCopyBytes
	ld hl, CardGFX
	ld de, $9230
	ld bc, $60
	ld a, BANK(CardGFX)
	call FarCopyBytes
	ret
; 88365 (22:4365)

ChrisCardPic: ; 88365
INCBIN "gfx/misc/chris_card.5x7.2bpp"
; 88595

KrisCardPic: ; 88595
INCBIN "gfx/misc/kris_card.5x7.2bpp"
; 887c5

CardGFX: ; 887c5
INCBIN "gfx/misc/trainer_card.2bpp"
; 88825

GetPlayerBackpic: ; 88825
	ld a, [PlayerGender]
	bit 0, a
	jr z, GetChrisBackpic
	call GetKrisBackpic
	ret

GetChrisBackpic: ; 88830
	ld hl, ChrisBackpic
	ld b, BANK(ChrisBackpic)
	ld de, $9310
	ld c, $31
	predef DecompressPredef
	ret
; 88840

Function88840: ; 88840
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ld e, 0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88851
	ld e, 1
.asm_88851
	ld a, e
	ld [TrainerClass], a
	ld de, ChrisPic
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_88862
	ld de, KrisPic
.asm_88862
	ld hl, VTiles2
	ld b, BANK(ChrisPic) ; BANK(KrisPic)
	ld c, $31
	call Get2bpp
	call WaitBGMap
	ld a, $1
	ld [hBGMapMode], a
	ret
; 88874
DrawIntroRivalPic:
	ld e, 0
	ld a, [PlayerGender]
	bit 0, a
	jr nz, .GotClass
	ld e, 1
.GotClass
	ld a, e
	ld [TrainerClass], a
	ld de, ChrisPic
	ld a, [PlayerGender]
	bit 0, a
	jr nz, IntroPic_GotPic
	ld de, KrisPic
	jr IntroPic_GotPic

DrawIntroPlayerPic: ; 88874
; Draw the player pic at (6,4).
; Get class

	ld e, 0
	ld a, [PlayerGender]
	bit 0, a
	jr z, .GotClass
	ld e, 1
.GotClass
	ld a, e
	ld [TrainerClass], a
; Load pic

	ld de, ChrisPic
	ld a, [PlayerGender]
	bit 0, a
	jr z, IntroPic_GotPic
	ld de, KrisPic
IntroPic_GotPic
	ld hl, VTiles2
	ld b, BANK(ChrisPic) ; BANK(KrisPic)
	ld c, 7 * 7 ; dimensions
	call Get2bpp
; Draw

	xor a
	ld [$ffad], a
	hlcoord 6, 4
	ld bc, $0707
	predef FillBox
	ret
; 888a9

ChrisPic: ; 888a9
INCBIN "gfx/misc/chris.7x7.2bpp"
; 88bb9

KrisPic: ; 88bb9
INCBIN "gfx/misc/kris.7x7.2bpp"
; 88ec9

GetKrisBackpic: ; 88ec9
; Kris's backpic is uncompressed.

	ld de, KrisBackpic
	ld hl, $9310
	lb bc, BANK(KrisBackpic), 7 * 7 ; dimensions
	call Get2bpp
	ret
; 88ed6

KrisBackpic: ; 88ed6
INCBIN "gfx/misc/kris_back.6x6.2bpp"
; 89116

String_89116:
	db "-----@"
; 8911c

String_8911c: ; 8911c
	db   "でんわばんごうが ただしく"   ; Phone number is not
	next "はいって いません!@"         ; entered correctly!
; 89135

String_89135: ; 89135
	db   "データが かわって いますが"  ; The data has changed.
	next "かきかえないで やめますか?@" ; Quit anyway?
; 89153

String_89153: ; 89153
	db   "メッセージは ありません@"    ; No message
; 89160

Function89160: ; 89160
	push af
	ld a, $4
	call GetSRAMBank
	pop af
	ret
; 89168

Function89168: ; 89168 (22:5168)
	ld hl, GameTimerPause
	set 7, [hl]
	ret

Function8916e: ; 8916e (22:516e)
	ld hl, GameTimerPause
	res 7, [hl]
	ret

Function89174: ; 89174 (22:5174)
	ld hl, GameTimerPause
	bit 7, [hl]
	ret

Function8917a: ; 8917a (22:517a)
	ld hl, DefaultFlypoint
	ld bc, $32
	xor a
	call ByteFill
	ret

Function89185: ; 89185 (22:5185)
	push de
	push hl
.asm_89187
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_89190
	inc hl
	dec c
	jr nz, .asm_89187
.asm_89190
	pop hl
	pop de
	ret

Function89193: ; 89193
	push de
	push hl
.asm_89195
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_89195
	pop hl
	pop de
	ret
; 8919e

Function8919e: ; 8919e (22:519e)
	ld a, c
	and a
	ret z
.asm_891a1
	ld a, [de]
	inc de
	cp $50
	jr nz, .asm_891a1
	dec c
	jr nz, .asm_891a1
	ret

Function891ab: ; 891ab
	call Function89240
	callba Function104061
	call Function8923c
	ret
; 891b8

Function891b8: ; 891b8
	call Function8923c
	hlcoord 0, 0
	ld a, $7f
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	call DelayFrame
	ret
; 891ca

Function891ca: ; 891ca (22:51ca)
	push bc
	call Function891b8
	call WaitBGMap
	pop bc
	ret

Function891d3: ; 891d3 (22:51d3)
	push bc
	call Function891ca
	ld c, $10
	call DelayFrames
	pop bc
	ret

Function891de: ; 891de
	call Function8923c
	call ClearPalettes
	hlcoord 0, 0, AttrMap
	ld a, $7
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	hlcoord 0, 0
	ld a, $7f
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	call Function891ab
	ret
; 891fe

Function891fe: ; 891fe
	push bc
	call Function891de
	ld c, $10
	call DelayFrames
	pop bc
	ret
; 89209

Function89209: ; 89209
	ld a, $1
	ld [wc2ce], a
	ret
; 8920f

Function8920f: ; 8920f
	ld a, $0
	ld [wc2ce], a
	ret
; 89215

Function89215: ; 89215
	push hl
	push bc
	ld bc, AttrMap - TileMap
	add hl, bc
	ld [hl], a
	pop bc
	pop hl
	ret
; 8921f

Function8921f: ; 8921f (22:521f)
	push de
	ld de, $14
	add hl, de
	inc hl
	ld a, $7f
.asm_89227
	push bc
	push hl
.asm_89229
	ld [hli], a
	dec c
	jr nz, .asm_89229
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_89227
	pop de
	ret

Function89235: ; 89235 (22:5235)
	call Functiona36
	call PlayClickSFX
	ret

Function8923c: ; 8923c
	xor a
	ld [hBGMapMode], a
	ret
; 89240

Function89240: ; 89240
	ld a, $1
	ld [hBGMapMode], a
	ret
; 89245

Function89245: ; 89245 (22:5245)
	callba Function14ea5
	ret c
	callba Function150b9
	and a
	ret

Function89254: ; 89254 (22:5254)
	ld bc, $d07
	jr Function89261

Function89259: ; 89259
	ld bc, $0e07
	jr Function89261

Function8925e: ; 8925e
	ld bc, $0e0c
Function89261: ; 89261
	push af
	push bc
	ld hl, MenuDataHeader_0x892a3
	call Function1d3c
	pop bc
	ld hl, wcf82
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	add $4
	ld [hli], a
	ld a, b
	add $5
	ld [hl], a
	pop af
	ld [wcf88], a
	call Function1c00
	call Function8923c
	call Function89209
	call Function1d81
	push af
	ld c, $a
	call DelayFrames
	call Function1c17
	call Function8920f
	pop af
	jr c, .asm_892a1
	ld a, [wcfa9]
	cp $2
	jr z, .asm_892a1
	and a
	ret

.asm_892a1
	scf
	ret
; 892a3

MenuDataHeader_0x892a3: ; 0x892a3
	db $40 ; flags
	db 05, 10 ; start coords
	db 09, 15 ; end coords
	dw MenuData2_0x892ab
	db 1 ; default option
; 0x892ab

MenuData2_0x892ab: ; 0x892ab
	db $c0 ; flags
	db 2 ; items
	db "はい@"
	db "いいえ@"
; 0x892b4

Function892b4: ; 892b4 (22:52b4)
	call Function8931b
Function892b7: ; 892b7
	ld d, b
	ld e, c
	ld hl, $0000
	add hl, bc
	ld a, $50
	ld bc, $0006
	call ByteFill
	ld b, d
	ld c, e
	ld hl, $0006
	add hl, bc
	ld a, $50
	ld bc, $0006
	call ByteFill
	ld b, d
	ld c, e
	ld hl, $000c
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, $000e
	add hl, bc
	ld [hli], a
	ld [hl], a
	ld hl, $0010
	add hl, bc
	ld [hl], a
	ld hl, $0011
	add hl, bc
	ld a, $ff
	ld bc, $0008
	call ByteFill
	ld b, d
	ld c, e
	ld e, $6
	ld hl, $0019
	add hl, bc
.asm_892fb
	ld a, $ff
	ld [hli], a
	ld a, $ff
	ld [hli], a
	dec e
	jr nz, .asm_892fb
	ret
; 89305

Function89305: ; 89305 (22:5305)
	xor a
	ld [MenuSelection], a
	ld c, $28
.asm_8930b
	ld a, [MenuSelection]
	inc a
	ld [MenuSelection], a
	push bc
	call Function892b4
	pop bc
	dec c
	jr nz, .asm_8930b
	ret

Function8931b: ; 8931b
	push hl
	ld hl, $a03b
	ld a, [MenuSelection]
	dec a
	ld bc, $0025
	call AddNTimes
	ld b, h
	ld c, l
	pop hl
	ret
; 8932d

Function8932d: ; 8932d
	ld hl, $0000
	add hl, bc
Function89331: ; 89331
	push bc
	ld c, $5
.asm_89334
	ld a, [hli]
	cp $50
	jr z, .asm_89340
	cp $7f
	jr nz, .asm_89343
	dec c
	jr nz, .asm_89334
.asm_89340
	scf
	jr .asm_89344

.asm_89343
	and a
.asm_89344
	pop bc
	ret
; 89346

Function89346: ; 89346 (22:5346)
	ld h, b
	ld l, c
	jr asm_8934e

Function8934a: ; 8934a
	ld hl, $0006
	add hl, bc
asm_8934e:
	push bc
	ld c, $5
.asm_89351
	ld a, [hli]
	cp $50
	jr z, .asm_8935d
	cp $7f
	jr nz, .asm_89360
	dec c
	jr nz, .asm_89351
.asm_8935d
	scf
	jr .asm_89361

.asm_89360
	and a
.asm_89361
	pop bc
	ret
; 89363

Function89363: ; 89363
	ld h, b
	ld l, c
	jr .asm_8936b
	ld hl, $0019
	add hl, bc
.asm_8936b
	push de
	ld e, $6
.asm_8936e
	ld a, [hli]
	cp $ff
	jr nz, .asm_8937e
	ld a, [hli]
	cp $ff
	jr nz, .asm_8937e
	dec e
	jr nz, .asm_8936e
	scf
	jr .asm_8937f

.asm_8937e
	and a
.asm_8937f
	pop de
	ret
; 89381

Function89381: ; 89381
	push bc
	push de
	call Function89b45
	jr c, .asm_89392
	push hl
	ld a, $ff
	ld bc, $0008
	call ByteFill
	pop hl
.asm_89392
	pop de
	ld c, $8
	call Function89193
	pop bc
	ret
; 8939a

Function8939a: ; 8939a
	push bc
	ld hl, $0000
	add hl, bc
	ld de, DefaultFlypoint
	ld c, $6
	call Function89193
	pop bc
	ld hl, $0011
	add hl, bc
	ld de, wd008
	call Function89381
	ret
; 893b3

Function893b3: ; 893b3 (22:53b3)
	call DisableLCD
	call ClearSprites
	call Functione51
	call Functione5f
	call Function893ef
	call Function8942b
	call Function89455
	call EnableLCD
	ret

Function893cc: ; 893cc
	call DisableLCD
	call ClearSprites
	call Functione51
	call Functione5f
	call Function893ef
	call Function89464
	call EnableLCD
	ret
; 893e2

Function893e2: ; 893e2 (22:53e2)
	call Function89b1e
	call Function893b3
	call Function8a5b6
	call Function8949c
	ret

Function893ef: ; 893ef
	ld de, VTiles0
	ld hl, GFX_8940b
	ld bc, $0020
	ld a, BANK(GFX_8940b)
	call FarCopyBytes
	ret
; 893fe

Function893fe: ; 893fe
	call DisableLCD
	call Function893ef
	call EnableLCD
	call DelayFrame
	ret
; 8940b

GFX_8940b: ; 8940b
INCBIN "gfx/unknown/08940b.2bpp"
; 8942b

Function8942b: ; 8942b (22:542b)
	ld de, $8020
	ld hl, MobileAdapterGFX + $7d0
	ld bc, $80
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ld de, $80a0
	ld hl, MobileAdapterGFX + $c60
	ld bc, $40
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret

Function89448: ; 89448 (22:5448)
	push af
	ld hl, Sprites
	ld d, $60
	xor a
.asm_8944f
	ld [hli], a
	dec d
	jr nz, .asm_8944f
	pop af
	ret

Function89455: ; 89455 (22:5455)
	ld hl, MobileAdapterGFX + $7d0
	ld de, $90c0
	ld bc, $490
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret

Function89464: ; 89464
	ld hl, MobileAdapterGFX
	ld de, VTiles2
	ld bc, $200
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ld hl, MobileAdapterGFX + $660
	ld de, $9200
	ld bc, $170
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	ret
; 89481

Function89481: ; 89481
	ld d, $2
	call Function8934a
	ret c
	ld d, $0
	ld hl, $0010
	add hl, bc
	bit 0, [hl]
	ret z
	inc d
	ret
; 89492

Function89492: ; 89492 (22:5492)
	ld d, $0
	ld a, [PlayerGender]
	bit 0, a
	ret z
	inc d
	ret

Function8949c: ; 8949c
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_894b3
	ld de, Unkn1Pals + 8 * 7
	ld bc, $0008
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 894b3

Palette_894b3: ; 894b3
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
; 894bb

Function894bb: ; 894bb
	call Function894dc
	push bc
	call Function8956f
	call Function8949c
	call Function8a60d
	pop bc
	ret
; 894ca

Function894ca: ; 894ca (22:54ca)
	push bc
	call Function894dc
	call Function895c7
	call Function8949c
	call Function8a60d
	call Function32f9
	pop bc
	ret

Function894dc: ; 894dc
	push bc
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld c, d
	ld b, 0
	ld hl, Unknown_89509
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Unkn1Pals
	ld bc, $0018
	call CopyBytes
	ld hl, Palette_89557
	ld de, wd018
	ld bc, $0018
	call CopyBytes
	pop af
	ld [rSVBK], a
	pop bc
	ret
; 89509

Unknown_89509: ; 89509
	dw Palette_8950f
	dw Palette_89527
	dw Palette_8953f
; 8950f

Palette_8950f: ; 8950f
	RGB 31, 31, 31
	RGB 10, 17, 13
	RGB 10, 08, 22
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 10, 08, 22
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 10, 17, 13
	RGB 00, 00, 00
Palette_89527: ; 89527
	RGB 31, 31, 31
	RGB 30, 22, 11
	RGB 31, 08, 15
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 31, 08, 15
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 30, 22, 11
	RGB 00, 00, 00
Palette_8953f: ; 8953f
	RGB 31, 31, 31
	RGB 15, 20, 26
	RGB 25, 07, 20
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 25, 07, 20
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 20, 31
	RGB 15, 20, 26
	RGB 00, 00, 00
Palette_89557: ; 89557
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 13, 00
	RGB 14, 08, 00
	RGB 31, 31, 31
	RGB 16, 16, 31
	RGB 00, 00, 31
	RGB 00, 00, 00
	RGB 19, 31, 11
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
; 8956f

Function8956f: ; 8956f
	push bc
	ld hl, $0010
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, wd030
	ld a, $ff
	ld [hli], a
	ld a, $7f
	ld [hl], a
	pop af
	ld [rSVBK], a
	ld a, [TrainerClass]
	ld h, $0
	ld l, a
	add hl, hl
	add hl, hl
	ld de, TrainerPalettes
	add hl, de
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld de, wd032
	ld c, $4
.asm_895b1
	ld a, BANK(TrainerPalettes)
	call GetFarByte
	ld [de], a
	inc de
	inc hl
	dec c
	jr nz, .asm_895b1
	ld hl, wd036
	xor a
	ld [hli], a
	ld [hl], a
	pop af
	ld [rSVBK], a
	pop bc
	ret
; 895c7

Function895c7: ; 895c7 (22:55c7)
	ld a, [rSVBK] ; $ff00+$70
	push af
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	ld hl, Palette_895de
	ld de, wd030
	ld bc, $8
	call CopyBytes
	pop af
	ld [rSVBK], a ; $ff00+$70
	ret
; 895de (22:55de)

Palette_895de: ; 895de
	RGB 31, 31, 31
	RGB 07, 07, 06
	RGB 07, 07, 06
	RGB 00, 00, 00
; 895e6

Function895e6: ; 895e6
	ld a, $7
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	ret
; 895f2

Function895f2: ; 895f2
	push bc
	xor a
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	call ByteFill
	call Function89605
	call Function89655
	pop bc
	ret
; 89605

Function89605: ; 89605
	hlcoord 19, 2, AttrMap
	ld a, $1
	ld de, $0014
	ld c, $e
.asm_8960f
	ld [hl], a
	dec c
	jr z, .asm_8961b
	add hl, de
	inc a
	ld [hl], a
	dec a
	add hl, de
	dec c
	jr nz, .asm_8960f
.asm_8961b
	hlcoord 0, 16, AttrMap
	ld c, $a
	ld a, $2
.asm_89622
	ld [hli], a
	dec a
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_89622
	hlcoord 1, 11, AttrMap
	ld a, $4
	ld bc, $0004
	call ByteFill
	ld a, $5
	ld bc, $000e
	call ByteFill
	ret
; 8963d

Function8963d: ; 8963d
	hlcoord 12, 3, AttrMap
	ld a, 6
	ld de, SCREEN_WIDTH
	ld bc, (7 << 4) | 7
.loop
	push hl
	ld c, 7
.loop2
	ld [hli], a
	dec c
	jr nz, .loop2
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	ret
; 89655

Function89655: ; 89655
	hlcoord 1, 12, AttrMap
	ld de, SCREEN_WIDTH
	ld a, 5
	ld b, 4
.loop
	ld c, 18
	push hl
.loop2
	ld [hli], a
	dec c
	jr nz, .loop2
	pop hl
	add hl, de
	dec b
	jr nz, .loop
	ret
; 8966c

Function8966c: ; 8966c
	push bc
	call Function89688
	hlcoord 4, 0
	ld c, $8
	call Function896f5
	pop bc
	ret
; 8967a

Function8967a: ; 8967a (22:567a)
	push bc
	call Function89688
	hlcoord 2, 0
	ld c, $c
	call Function896f5
	pop bc
	ret

Function89688: ; 89688
	hlcoord 0, 0
	ld a, $1
	ld e, $14
	call Function896e1
	ld a, $2
	ld e, $14
	call Function896eb
	ld a, $3
	ld [hli], a
	ld a, $4
	ld e, $12
	call Function896e1
	ld a, $6
	ld [hli], a
	push bc
	ld c, $d
.asm_896a9
	call Function896cb
	dec c
	jr z, .asm_896b5
	call Function896d6
	dec c
	jr nz, .asm_896a9
.asm_896b5
	pop bc
	ld a, $19
	ld [hli], a
	ld a, $1a
	ld e, $12
	call Function896e1
	ld a, $1c
	ld [hli], a
	ld a, $2
	ld e, $14
	call Function896eb
	ret
; 896cb

Function896cb: ; 896cb
	ld de, $0013
	ld a, $7
	ld [hl], a
	add hl, de
	ld a, $9
	ld [hli], a
	ret
; 896d6

Function896d6: ; 896d6
	ld de, $0013
	ld a, $a
	ld [hl], a
	add hl, de
	ld a, $b
	ld [hli], a
	ret
; 896e1

Function896e1: ; 896e1
.asm_896e1
	ld [hli], a
	inc a
	dec e
	ret z
	ld [hli], a
	dec a
	dec e
	jr nz, .asm_896e1
	ret
; 896eb

Function896eb: ; 896eb
.asm_896eb
	ld [hli], a
	dec a
	dec e
	ret z
	ld [hli], a
	inc a
	dec e
	jr nz, .asm_896eb
	ret
; 896f5

Function896f5: ; 896f5
	call Function8971f
	call Function89736
	inc hl
	inc hl
	ld b, 2
ClearScreenArea: ; 0x896ff
; clears an area of the screen
; INPUT:
; hl = address of upper left corner of the area
; b = height
; c = width

	ld a, " " ; blank tile
	ld de, 20 ; screen width
.loop
	push bc
	push hl
.innerLoop
	ld [hli], a
	dec c
	jr nz, .innerLoop
	pop hl
	pop bc
	add hl, de
	dec b
	jr nz, .loop
	dec hl
	inc c
	inc c
.asm_89713
	ld a, $36
	ld [hli], a
	dec c
	ret z
	ld a, $18
	ld [hli], a
	dec c
	jr nz, .asm_89713 ; 0x8971c $f5
	ret
; 0x8971f

Function8971f: ; 8971f
	ld a, $2c
	ld [hli], a
	ld a, $2d
	ld [hld], a
	push hl
	ld de, $0014
	add hl, de
	ld a, $31
	ld [hli], a
	ld a, $32
	ld [hld], a
	add hl, de
	ld a, $35
	ld [hl], a
	pop hl
	ret
; 89736

Function89736: ; 89736
	push hl
	inc hl
	inc hl
	ld e, c
	ld d, $0
	add hl, de
	ld a, $2f
	ld [hli], a
	ld a, $30
	ld [hld], a
	ld de, $0014
	add hl, de
	ld a, $33
	ld [hli], a
	ld a, $34
	ld [hl], a
	add hl, de
	ld a, $1f
	ld [hl], a
	pop hl
	ret
; 89753

Function89753: ; 89753
	ld a, $c
	ld [hl], a
	xor a
	call Function89215
	ret
; 8975b

Function8975b: ; 8975b
	ld a, $1d
	ld [hli], a
	inc a
	ld [hli], a
	ld a, $d
	ld [hl], a
	dec hl
	dec hl
	ld a, $4
	ld e, $3
.asm_89769
	call Function89215
	inc hl
	dec e
	jr nz, .asm_89769
	ret
; 89771

Function89771: ; 89771
	ld a, $12
	ld [hl], a
	ld a, $3
	call Function89215
	ret
; 8977a

Function8977a: ; 8977a
	ld e, $4
	ld d, $13
.asm_8977e
	ld a, d
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc d
	dec e
	jr nz, .asm_8977e
	ld e, $e
.asm_8978c
	ld a, d
	ld [hl], a
	xor a
	call Function89215
	inc hl
	dec e
	jr nz, .asm_8978c
	ret
; 89797

Function89797: ; 89797
	push bc
	ld a, $e
	ld [hl], a
	ld bc, $0014
	add hl, bc
	ld a, $11
	ld [hli], a
	ld a, $10
	ld c, $8
.asm_897a6
	ld [hli], a
	dec c
	jr nz, .asm_897a6
	ld a, $f
	ld [hl], a
	pop bc
	ret
; 897af

Function897af: ; 897af
	push bc
	ld hl, $0010
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $000c
	add hl, bc
	ld b, h
	ld c, l
	callba Function4e929
	ld a, c
	ld [TrainerClass], a
	xor a
	ld [CurPartySpecies], a
	ld de, $9370
	callba GetTrainerPic
	pop bc
	ret
; 897d5

Function897d5: ; 897d5
	push bc
	call Function8934a
	jr nc, .asm_897f3
	hlcoord 12, 3, AttrMap
	xor a
	ld de, $0014
	ld bc, $0707
.asm_897e5
	push hl
	ld c, $7
.asm_897e8
	ld [hli], a
	dec c
	jr nz, .asm_897e8
	pop hl
	add hl, de
	dec b
	jr nz, .asm_897e5
	pop bc
	ret

.asm_897f3
	ld a, $37
	ld [$ffad], a
	hlcoord 12, 3
	ld bc, $0707
	predef FillBox
	call Function8963d
	pop bc
	ret
; 89807

Function89807: ; 89807 (22:5807)
	ld hl, MobileAdapterGFX + $200
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_89814
	ld hl, MobileAdapterGFX + $200 + $230
.asm_89814
	call DisableLCD
	ld de, $9370
	ld bc, $230
	ld a, BANK(MobileAdapterGFX)
	call FarCopyBytes
	call EnableLCD
	call DelayFrame
	ret

Function89829: ; 89829 (22:5829)
	push bc
	ld bc, $705
	ld de, $14
	ld a, $37
.asm_89832
	push bc
	push hl
.asm_89834
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_89834
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_89832
	call Function8963d
	pop bc
	ret

Function89844: ; 89844
	call Function89481
	call Function894bb
	call Function897af
	push bc
	call Function3200
	call Function32f9
	pop bc
	ret
; 89856

Function89856: ; 89856
	push bc
	call Function891b8
	pop bc
	call Function895f2
	call Function8966c
	call Function899d3
	call Function898aa
	call Function898be
	call Function898dc
	call Function898f3
	push bc
	ld bc, wd008
	hlcoord 2, 10
	call Function89975
	pop bc
	call Function897d5
	ret
; 8987f

Function8987f: ; 8987f (22:587f)
	call Function891b8
	call Function895f2
	call Function8967a
	call Function899d3
	hlcoord 5, 1
	call Function8999c
	hlcoord 13, 3
	call Function89829
	call Function899b2
	hlcoord 5, 5
	call Function899c9
	ld bc, wd008
	hlcoord 2, 10
	call Function89975
	ret

Function898aa: ; 898aa
	ld a, [MenuSelection]
	and a
	ret z
	push bc
	hlcoord 6, 1
	ld de, MenuSelection
	ld bc, $8102
	call PrintNum
	pop bc
	ret
; 898be

Function898be: ; 898be
	push bc
	ld de, DefaultFlypoint
	ld hl, DefaultFlypoint
	call Function89331
	jr nc, .asm_898cd
	ld de, String_89116
.asm_898cd
	hlcoord 9, 1
	ld a, [MenuSelection]
	and a
	jr nz, .asm_898d7
	dec hl
.asm_898d7
	call PlaceString
	pop bc
	ret
; 898dc

Function898dc: ; 898dc
	ld hl, $0006
	add hl, bc
	push bc
	ld d, h
	ld e, l
	call Function8934a
	jr nc, .asm_898eb
	ld de, String_89116
.asm_898eb
	hlcoord 6, 4
	call PlaceString
	pop bc
	ret
; 898f3

Function898f3: ; 898f3
	push bc
	ld hl, $000c
	add hl, bc
	ld d, h
	ld e, l
	call Function8934a
	jr c, .asm_8990a
	hlcoord 5, 5
	ld bc, $8205
	call PrintNum
	jr .asm_89913

.asm_8990a
	hlcoord 5, 5
	ld de, String_89116
	call PlaceString
.asm_89913
	pop bc
	ret
; 89915

Function89915: ; 89915
	push bc
	push hl
	ld de, Unknown_89942
	ld c, $8
.asm_8991c
	ld a, [de]
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc de
	dec c
	jr nz, .asm_8991c
	pop hl
	ld b, $4
	ld c, $2b
	ld a, $8
	ld de, Unknown_8994a
.asm_89932
	push af
	ld a, [de]
	cp [hl]
	jr nz, .asm_8993b
	call Function8994e
	inc de
.asm_8993b
	inc hl
	pop af
	dec a
	jr nz, .asm_89932
	pop bc
	ret
; 89942

Unknown_89942: ; 89942
	db $24, $25, $26, " ", $27, $28, $29, $2a
Unknown_8994a: ; 8994a
	db $24, $27, $29, $ff
; 8994e

Function8994e: ; 8994e
	push hl
	push de
	ld de, $0014
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	ld a, c
	ld [hl], a
	ld a, b
	call Function89215
	pop de
	pop hl
	ret
; 89962

Function89962: ; 89962
	push bc
	ld c, $4
	ld b, $20
.asm_89967
	ld a, b
	ld [hl], a
	ld a, $4
	call Function89215
	inc hl
	inc b
	dec c
	jr nz, .asm_89967
	pop bc
	ret
; 89975

Function89975: ; 89975
	push bc
	ld e, $8
.asm_89978
	ld a, [bc]
	ld d, a
	call Function8998b
	swap d
	inc hl
	ld a, d
	call Function8998b
	inc bc
	inc hl
	dec e
	jr nz, .asm_89978
	pop bc
	ret
; 8998b

Function8998b: ; 8998b
	push bc
	and $f
	cp $a
	jr nc, .asm_89997
	ld c, $f6
	add c
	jr .asm_89999

.asm_89997
	ld a, $7f
.asm_89999
	ld [hl], a
	pop bc
	ret
; 8999c

Function8999c: ; 8999c (22:599c)
	ld de, PlayerName
	call PlaceString
	inc bc
	ld h, b
	ld l, c
	ld de, String_899ac
	call PlaceString
	ret
; 899ac (22:59ac)

String_899ac: ; 899ac
	db "の めいし@"
; 899b2

Function899b2: ; 899b2 (22:59b2)
	ld bc, PlayerName
	call Function89346
	jr c, .asm_899bf
	ld de, PlayerName
	jr .asm_899c2

.asm_899bf
	ld de, String_89116
.asm_899c2
	hlcoord 6, 4
	call PlaceString
	ret

Function899c9: ; 899c9 (22:59c9)
	ld de, PlayerID
	ld bc, $8205
	call PrintNum
	ret

Function899d3: ; 899d3
	hlcoord 1, 4
	call Function89753
	hlcoord 2, 5
	call Function8975b
	hlcoord 1, 9
	call Function89771
	hlcoord 1, 11
	call Function8977a
	hlcoord 1, 5
	call Function89797
	hlcoord 2, 4
	call Function89962
	hlcoord 2, 9
	call Function89915
	ret
; 899fe

Function899fe: ; 899fe
	push bc
	push hl
	ld hl, $0019
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	call Function89a0c
	pop bc
	ret
; 89a0c

Function89a0c: ; 89a0c
	push hl
	call Function89363
	pop hl
	jr c, .asm_89a1c
	ld d, h
	ld e, l
	callba Function11c08f
	ret

.asm_89a1c
	ld de, String_89153
	call PlaceString
	ret
; 89a23

Function89a23: ; 89a23 (22:5a23)
	hlcoord 0, 11
	ld b, $4
	ld c, $12
	call Function8921f
	ret

Function89a2e: ; 89a2e (22:5a2e)
	hlcoord 11, 12
	ld b, $2
	ld c, $6
	call TextBox
	hlcoord 13, 13
	ld de, String_89a4e
	call PlaceString
	hlcoord 13, 14
	ld de, String_89a53
	call PlaceString
	call Function89655
	ret
; 89a4e (22:5a4e)

String_89a4e: ; 89a4e
	db "けってい@"
; 89a53

String_89a53: ; 89a53
	db "やめる@"
; 89a57

Function89a57: ; 89a57
	call Function354b
	bit 6, c
	jr nz, .asm_89a78
	bit 7, c
	jr nz, .asm_89a81
	bit 0, c
	jr nz, .asm_89a70
	bit 1, c
	jr nz, .asm_89a70
	bit 3, c
	jr nz, .asm_89a74
	scf
	ret

.asm_89a70
	ld a, $1
	and a
	ret

.asm_89a74
	ld a, $2
	and a
	ret

.asm_89a78
	call Function89a9b
	call nc, Function89a8a
	ld a, $0
	ret

.asm_89a81
	call Function89a93
	call nc, Function89a8a
	ld a, $0
	ret
; 89a8a

Function89a8a: ; 89a8a
	push af
	ld de, SFX_UNKNOWN_62
	call PlaySFX
	pop af
	ret
; 89a93

Function89a93: ; 89a93
	ld d, $28
	ld e, $1
	call Function89aa3
	ret
; 89a9b

Function89a9b: ; 89a9b
	ld d, $1
	ld e, $ff
	call Function89aa3
	ret
; 89aa3

Function89aa3: ; 89aa3
	ld a, [MenuSelection]
	ld c, a
	push bc
.asm_89aa8
	ld a, [MenuSelection]
	cp d
	jr z, .asm_89ac0
	add e
	jr nz, .asm_89ab2
	inc a
.asm_89ab2
	ld [MenuSelection], a
	call Function89ac7
	jr nc, .asm_89aa8
	call Function89ae6
	pop bc
	and a
	ret

.asm_89ac0
	pop bc
	ld a, c
	ld [MenuSelection], a
	scf
	ret
; 89ac7

Function89ac7: ; 89ac7
	call Function89160
	call Function8931b
	call Function89ad4
	call CloseSRAM
	ret
; 89ad4

Function89ad4: ; 89ad4
	push de
	call Function8932d
	jr c, .asm_89ae3
	ld hl, $0011
	add hl, bc
	call Function89b45
	jr c, .asm_89ae4
.asm_89ae3
	and a
.asm_89ae4
	pop de
	ret
; 89ae6

Function89ae6: ; 89ae6
	ld hl, wd031
	xor a
	ld [hl], a
	ld a, [MenuSelection]
.asm_89aee
	cp $6
	jr c, .asm_89afc
	sub $5
	ld c, a
	ld a, [hl]
	add $5
	ld [hl], a
	ld a, c
	jr .asm_89aee

.asm_89afc
	ld [wd030], a
	ret
; 89b00

Function89b00: ; 89b00 (22:5b00)
	callba Function49351
	ret
; 89b07 (22:5b07)

Function89b07: ; 89b07
	call Function8923c
	call DelayFrame
	callba Function4a3a7
	ret
; 89b14

Function89b14: ; 89b14
	call WhiteBGMap
	call Function89b07
	call Function89b00
	ret
; 89b1e

Function89b1e: ; 89b1e (22:5b1e)
	callba Function4a485
	call Function89b00
	ret

Function89b28: ; 89b28 (22:5b28)
	call Function891de
	call WhiteBGMap
	call Function893e2
	call Function1d7d
	call Function891ab
	call Function32f9
	ret

Function89b3b: ; 89b3b (22:5b3b)
	call Function8923c
	callba Function48cda
	ret

Function89b45: ; 89b45
	push hl
	push bc
	ld c, $10
	ld e, $0
.asm_89b4b
	ld a, [hli]
	ld b, a
	and $f
	cp $a
	jr c, .asm_89b5a
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b5a
	dec c
	swap b
	inc e
	ld a, b
	and $f
	cp $a
	jr c, .asm_89b6c
	ld a, c
	cp $b
	jr nc, .asm_89b74
	jr .asm_89b71

.asm_89b6c
	inc e
	dec c
	jr nz, .asm_89b4b
	dec e
.asm_89b71
	scf
	jr .asm_89b75

.asm_89b74
	and a
.asm_89b75
	pop bc
	pop hl
	ret
; 89b78

Function89b78: ; 89b78 (22:5b78)
	push bc
	ld a, [wd010]
	cp $10
	jr c, .asm_89b8c
	ld a, e
	and a
	jr z, .asm_89b89
	ld c, e
.asm_89b85
	inc hl
	dec c
	jr nz, .asm_89b85
.asm_89b89
	ld a, $7f
	ld [hl], a
.asm_89b8c
	ld a, [wd010]
	inc a
	and $1f
	ld [wd010], a
	pop bc
	ret

Function89b97: ; 89b97 (22:5b97)
	call Function89c34
	jr c, .asm_89ba0
	call Function89448
	ret

.asm_89ba0
	ld a, [wd011]
	ld hl, Unknown_89bd8
	and a
	jr z, .asm_89bae
.asm_89ba9
	inc hl
	inc hl
	dec a
	jr nz, .asm_89ba9
.asm_89bae
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Sprites
.asm_89bb4
	ld a, [hli]
	cp $ff
	ret z
	ld c, a
	ld b, $0
.asm_89bbb
	push hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, $8
	add b
	ld b, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop hl
	dec c
	jr nz, .asm_89bbb
	ld b, $0
	ld c, $4
	add hl, bc
	jr .asm_89bb4
; 89bd8 (22:5bd8)

Unknown_89bd8: ; 89bd8
	dw Unknown_89be0
	dw Unknown_89bf5
	dw Unknown_89c0a
	dw Unknown_89c1f
; 89be0

Unknown_89be0: ; 89be0
	db $01, $12, $4e, $01, $00
	db $01, $19, $4e, $01, $40
	db $01, $12, $72, $01, $20
	db $01, $19, $72, $01, $60
	db $ff
Unknown_89bf5: ; 89bf5
	db $01, $60, $16, $01, $00
	db $01, $62, $16, $01, $40
	db $01, $60, $92, $01, $20
	db $01, $62, $92, $01, $60
	db $ff
Unknown_89c0a: ; 89c0a
	db $01, $78, $66, $01, $00
	db $01, $78, $66, $01, $40
	db $01, $78, $92, $01, $20
	db $01, $78, $92, $01, $60
	db $ff
Unknown_89c1f: ; 89c1f
	db $01, $80, $66, $01, $00
	db $01, $80, $66, $01, $40
	db $01, $80, $92, $01, $20
	db $01, $80, $92, $01, $60
	db $ff
; 89c34

Function89c34: ; 89c34 (22:5c34)
	push bc
	ld a, [wd012]
	ld c, a
	inc a
	and $f
	ld [wd012], a
	ld a, c
	cp $8
	pop bc
	ret

Function89c44: ; 89c44 (22:5c44)
	call Function89c34
	jr c, .asm_89c4f
	push de
	call Function89448
	pop de
	ret

.asm_89c4f
	ld hl, Sprites
	push de
	ld a, b
	ld [hli], a
	ld d, $8
	ld a, e
	and a
	ld a, c
	jr z, .asm_89c60
.asm_89c5c
	add d
	dec e
	jr nz, .asm_89c5c
.asm_89c60
	pop de
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ret

Function89c67: ; 89c67 (22:5c67)
	call Function354b
	ld b, $0
	bit 0, c
	jr z, .asm_89c74
	ld b, $1
	and a
	ret

.asm_89c74
	bit 1, c
	jr z, .asm_89c7a
	scf
	ret

.asm_89c7a
	xor a
	bit 6, c
	jr z, .asm_89c81
	ld a, $1
.asm_89c81
	bit 7, c
	jr z, .asm_89c87
	ld a, $2
.asm_89c87
	bit 5, c
	jr z, .asm_89c8d
	ld a, $3
.asm_89c8d
	bit 4, c
	jr z, .asm_89c93
	ld a, $4
.asm_89c93
	and a
	ret z
	dec a
	ld c, a
	ld d, $0
	ld hl, Unknown_89cbf
	ld a, [wd02f]
	and a
	jr z, .asm_89ca5
	ld hl, Unknown_89ccf
.asm_89ca5
	ld a, [wd011]
	and a
	jr z, .asm_89cb1
	ld e, $4
.asm_89cad
	add hl, de
	dec a
	jr nz, .asm_89cad
.asm_89cb1
	ld e, c
	add hl, de
	ld a, [hl]
	and a
	ret z
	dec a
	ld [wd011], a
	xor a
	ld [wd012], a
	ret
; 89cbf (22:5cbf)

Unknown_89cbf: ; 89cbf
	db 0, 2, 0, 0
	db 1, 3, 0, 0
	db 2, 4, 0, 0
	db 3, 0, 0, 0
Unknown_89ccf: ; 89ccf
	db 0, 0, 0, 0
	db 0, 3, 0, 0
	db 2, 4, 0, 0
	db 3, 0, 0, 0
; 89cdf

Function89cdf: ; 89cdf (22:5cdf)
	ld a, $10
	add b
	ld b, a
	ld a, $8
	add c
	ld c, a
	ld e, $2
	ld a, $2
	ld hl, Sprites
.asm_89cee
	push af
	push bc
	ld d, $4
.asm_89cf2
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld a, $8
	add c
	ld c, a
	inc e
	dec d
	jr nz, .asm_89cf2
	pop bc
	ld a, $8
	add b
	ld b, a
	pop af
	dec a
	jr nz, .asm_89cee
	ret

Function89d0d: ; 89d0d (22:5d0d)
	call Function8923c
	ld a, [rSVBK] ; $ff00+$70
	push af
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	ld c, $8
	ld de, Unkn1Pals
.asm_89d1c
	push bc
	ld hl, Palette_89d4e
	ld bc, $8
	call CopyBytes
	pop bc
	dec c
	jr nz, .asm_89d1c
	ld hl, Palette_89d56
	ld de, wd010
	ld bc, $8
	call CopyBytes
	pop af
	ld [rSVBK], a ; $ff00+$70
	call Function32f9
	callba Function845db
	call Function89240
	ld c, $18
	call DelayFrames
	call RestartMapMusic
	ret
; 89d4e (22:5d4e)

Palette_89d4e: ; 89d4e
	RGB 31, 31, 31
	RGB 19, 19, 19
	RGB 15, 15, 15
	RGB 00, 00, 00
; 89d56

Palette_89d56: ; 89d56
	RGB 31, 31, 31
	RGB 19, 19, 19
	RGB 19, 19, 19
	RGB 00, 00, 00
; 89d5e

Function89d5e: ; 89d5e (22:5d5e)
	push af
	call Function1d3c
	pop af
	ld [wcf88], a
	call Function8923c
	call Function1c89
	call Function1c10
	ld hl, wcfa5
	set 7, [hl]
	ret

Function89d75: ; 89d75 (22:5d75)
	push hl
	call Function8923c
	call _hl_
	callba Function104148
	pop hl
	jr asm_89d90

Function89d85: ; 89d85 (22:5d85)
	push hl
	call Function8923c
	call _hl_
	call Function3238
	pop hl
asm_89d90: ; 89d90 (22:5d90)
	call Function8923c
	push hl
	call _hl_
	call Function89dab
	ld a, [wcfa9]
	push af
	call Function891ab
	pop af
	pop hl
	jr c, .asm_89da9
	jr z, asm_89d90
	scf
	ret

.asm_89da9
	and a
	ret

Function89dab: ; 89dab (22:5dab)
	call Function8923c
	callba Function241ba
	call Function8923c
	ld a, c
	ld hl, wcfa8
	and [hl]
	ret z
	bit 0, a
	jr nz, .asm_89dc7
	bit 1, a
	jr nz, .asm_89dd9
	xor a
	ret

.asm_89dc7
	call PlayClickSFX
	ld a, [wcfa3]
	ld c, a
	ld a, [wcfa9]
	cp c
	jr z, .asm_89dd9
	call Function1bee
	scf
	ret

.asm_89dd9
	call PlayClickSFX
	ld a, $1
	and a
	ret

Function89de0: ; 89de0 (22:5de0)
	call ClearSprites
	call Function89e0a
	jr c, .asm_89e00
	ld c, $1
.asm_89dea
	call Function8a31c
	jr z, .asm_89dfd
	ld a, [wcfa9]
	ld c, a
	push bc
	ld hl, Jumptable_89e04
	ld a, e
	dec a
	rst JumpTable
	pop bc
	jr .asm_89dea

.asm_89dfd
	call Function891fe
.asm_89e00
	call Function8917a
	ret

Jumptable_89e04: ; 89e04 (22:5e04)
	dw Function8a62c
	dw Function8a999
	dw Function8ab93

Function89e0a: ; 89e0a (22:5e0a)
	call Function89160
	call Function8b3b0
	call CloseSRAM
	ld hl, Jumptable_89e18
	rst JumpTable
	ret

Jumptable_89e18: ; 89e18 (22:5e18)
	dw Function89e1e
	dw Function8a116
	dw Function8a2aa

Function89e1e: ; 89e1e (22:5e1e)
	call Function89160
	ld bc, $a037
	call Function8b36c
	call CloseSRAM
	xor a
	ld [wd02d], a
asm_89e2e: ; 89e2e (22:5e2e)
	ld a, [wd02d]
	ld hl, Jumptable_89e3c
	rst JumpTable
	ret

Function89e36: ; 89e36 (22:5e36)
	ld hl, wd02d
	inc [hl]
	jr asm_89e2e

Jumptable_89e3c: ; 89e3c (22:5e3c)
	dw Function89e6f
	dw Function89fed
	dw Function89ff6
	dw Function8a03d
	dw Function89eb9
	dw Function89efd
	dw Function89fce
	dw Function8a04c
	dw Function8a055
	dw Function8a0e6
	dw Function8a0ec
	dw Function8a0f5
	dw Function89e58
	dw Function89e68

Function89e58: ; 89e58 (22:5e58)
	ld a, $1
	call Function8a2fe
	call Function891fe
	call Function893e2
	call Function89168
	and a
	ret

Function89e68: ; 89e68 (22:5e68)
	call Function891fe
	ld a, $1
	scf
	ret

Function89e6f: ; 89e6f (22:5e6f)
	call Function891de
	call Function89245
	call Function89ee1
	call Function89e9a
	hlcoord 7, 4
	call Function8a58d
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function891ab
	call Function32f9
	jp Function89e36

Function89e9a: ; 89e9a (22:5e9a)
	ld a, [rSVBK] ; $ff00+$70
	push af
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	ld hl, Palette_89eb1
	ld de, wd028
	ld bc, $8
	call CopyBytes
	pop af
	ld [rSVBK], a ; $ff00+$70
	ret
; 89eb1 (22:5eb1)

Palette_89eb1: ; 89eb1
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 27, 19, 00
	RGB 00, 00, 00
; 89eb9

Function89eb9: ; 89eb9 (22:5eb9)
	call Function891fe
	call Function89ee1
	call Function89e9a
	hlcoord 7, 4
	call Function8a58d
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function891ab
	call Function32f9
	jp Function89e36

Function89ee1: ; 89ee1 (22:5ee1)
	call WhiteBGMap
	call Function893e2
	call Function8923c
	callba Function4a3a7
	callba Function49384
	hlcoord 1, 0
	call Function8a53d
	ret

Function89efd: ; 89efd (22:5efd)
	ld hl, wd012
	ld a, $ff
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.asm_89f09
	ld hl, wd012
	inc [hl]
	ld a, [hli]
	and $3
	jr nz, .asm_89f2e
	ld a, [hl]
	cp $4
	jr nc, .asm_89f2e
	ld b, $32
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .asm_89f26
	ld c, a
.asm_89f1f
	ld a, $b
	add b
	ld b, a
	dec c
	jr nz, .asm_89f1f
.asm_89f26
	ld c, $e8
	ld a, [wd013]
	call Function89fa5
.asm_89f2e
	ld a, [wd013]
	and a
	jr z, .asm_89f58
.asm_89f34
	call Function89f6a
	ld e, a
	ld a, c
	cp $a8
	jr nc, .asm_89f4d
	cp $46
	jr c, .asm_89f4d
	ld d, $0
	dec e
	ld hl, wd014
	add hl, de
	set 0, [hl]
	inc e
	jr .asm_89f51

.asm_89f4d
	ld a, $2
	add c
	ld c, a
.asm_89f51
	ld a, e
	call Function89f77
	dec a
	jr nz, .asm_89f34
.asm_89f58
	call DelayFrame
	ld hl, wd014
	ld c, $4
.asm_89f60
	ld a, [hli]
	and a
	jr z, .asm_89f09
	dec c
	jr nz, .asm_89f60
	jp Function89e36

Function89f6a: ; 89f6a (22:5f6a)
	push af
	ld de, $10
	call Function89f9a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop af
	ret

Function89f77: ; 89f77 (22:5f77)
	push af
	ld de, $10
	call Function89f9a
	ld d, $2
.asm_89f80
	push bc
	ld e, $2
.asm_89f83
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	inc hl
	inc hl
	ld a, $8
	add c
	ld c, a
	dec e
	jr nz, .asm_89f83
	pop bc
	ld a, $8
	add b
	ld b, a
	dec d
	jr nz, .asm_89f80
	pop af
	ret

Function89f9a: ; 89f9a (22:5f9a)
	dec a
	ld hl, Sprites
	and a
	ret z
.asm_89fa0
	add hl, de
	dec a
	jr nz, .asm_89fa0
	ret

Function89fa5: ; 89fa5 (22:5fa5)
	ld de, $10
	call Function89f9a
	ld e, $2
	ld d, $a
.asm_89faf
	push bc
	ld a, $2
.asm_89fb2
	push af
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	inc d
	ld [hli], a
	ld a, $1
	ld [hli], a
	ld a, $8
	add c
	ld c, a
	pop af
	dec a
	jr nz, .asm_89fb2
	pop bc
	ld a, $8
	add b
	ld b, a
	dec e
	jr nz, .asm_89faf
	ret

Function89fce: ; 89fce (22:5fce)
	call Function8a5b6
	ld a, $5
	hlcoord 7, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 10, 4, AttrMap
	call Function8a5a3
	call Function89448
	call Function32f9
	call Function891ab
	jp Function89e36

Function89fed: ; 89fed (22:5fed)
	ld hl, UnknownText_0x8a102
	call PrintText
	jp Function89e36

Function89ff6: ; 89ff6 (22:5ff6)
	call Function891fe
	call WhiteBGMap
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
	call Function89160
	ld hl, $a603
	ld a, $ff
	ld bc, $8
	call ByteFill
	ld hl, $a603
	ld de, wd008
	call Function89381
	call CloseSRAM
	call Function8987f
	call Function89160
	hlcoord 1, 13
	ld bc, $a007
	call Function89a0c
	call CloseSRAM
	call Function891ab
	call Function89235
	jp Function89e36

Function8a03d: ; 8a03d (22:603d)
	ld hl, UnknownText_0x8a107
	call Function89209
	call PrintText
	call Function8920f
	jp Function89e36

Function8a04c: ; 8a04c (22:604c)
	ld hl, UnknownText_0x8a10c
	call PrintText
	jp Function89e36

Function8a055: ; 8a055 (22:6055)
	ld c, $7
	ld b, $4
.asm_8a059
	call Function8a0a1
	inc c
	call Function8a0c9
	push bc
	call Function8a58d
	pop bc
	call Function8a0de
	push bc
	push hl
	ld a, $5
	call Function8a5a3
	pop hl
	inc hl
	inc hl
	inc hl
	ld a, $6
	call Function8a5a3
	call Function3238
	pop bc
	ld a, c
	cp $b
	jr nz, .asm_8a059
	call Function8a0a1
	hlcoord 12, 4
	call Function8a58d
	ld a, $5
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	pop hl
	ld a, $6
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	call Function3238
	jp Function89e36

Function8a0a1: ; 8a0a1 (22:60a1)
	call Function8923c
	push bc
	call Function8a0c9
	ld e, $6
.asm_8a0aa
	push hl
	ld bc, $6
	add hl, bc
	ld d, [hl]
	call Function8a0c1
	pop hl
	ld [hl], d
	call Function89215
	ld bc, $14
	add hl, bc
	dec e
	jr nz, .asm_8a0aa
	pop bc
	ret

Function8a0c1: ; 8a0c1 (22:60c1)
	push hl
	ld bc, AttrMap - TileMap
	add hl, bc
	ld a, [hl]
	pop hl
	ret

Function8a0c9: ; 8a0c9 (22:60c9)
	push bc
	hlcoord 0, 0
	ld de, $14
	ld a, b
	and a
	jr z, .asm_8a0d8
.asm_8a0d4
	add hl, de
	dec b
	jr nz, .asm_8a0d4
.asm_8a0d8
	ld d, $0
	ld e, c
	add hl, de
	pop bc
	ret

Function8a0de: ; 8a0de (22:60de)
	call Function8a0c9
	ld de, AttrMap - TileMap
	add hl, de
	ret

Function8a0e6: ; 8a0e6 (22:60e6)
	call Function8b539
	jp Function89e36

Function8a0ec: ; 8a0ec (22:60ec)
	ld hl, UnknownText_0x8a111
	call PrintText
	jp Function89e36

Function8a0f5: ; 8a0f5 (22:60f5)
	call Function8b555
	jp nc, Function8a0ff
	ld hl, wd02d
	inc [hl]
Function8a0ff: ; 8a0ff (22:60ff)
	jp Function89e36
; 8a102 (22:6102)

UnknownText_0x8a102: ; 0x8a102
	; The CARD FOLDER stores your and your friends' CARDS. A CARD contains information like the person's name, phone number and profile.
	text_jump UnknownText_0x1c5238
	db "@"
; 0x8a107

UnknownText_0x8a107: ; 0x8a107
	; This is your CARD. Once you've entered your phone number, you can trade CARDS with your friends.
	text_jump UnknownText_0x1c52bc
	db "@"
; 0x8a10c

UnknownText_0x8a10c: ; 0x8a10c
	; If you have your friend's CARD, you can use it to make a call from a mobile phone on the 2nd floor of a #MON CENTER.
	text_jump UnknownText_0x1c531e
	db "@"
; 0x8a111

UnknownText_0x8a111: ; 0x8a111
	; To safely store your collection of CARDS, you must set a PASSCODE for your CARD FOLDER.
	text_jump UnknownText_0x1c5394
	db "@"
; 0x8a116

Function8a116: ; 8a116 (22:6116)
	ld a, $1
	ld [wd030], a
	ld hl, MenuDataHeader_0x8a176
	call LoadMenuDataHeader
.asm_8a121
	call Function8923c
	call Function8a17b
	jr c, .asm_8a16b
	ld a, [wcfa9]
	ld [wd030], a
	dec d
	jr z, .asm_8a140
	call Function8a20d
	jr c, .asm_8a121
	xor a
	call Function8a2fe
	call Function8916e
	jr .asm_8a16b

.asm_8a140
	call Function89174
	jr nz, .asm_8a14c
	call Function8a241
	jr c, .asm_8a121
	jr .asm_8a15a

.asm_8a14c
	call WaitSFX
	ld de, SFX_TWINKLE
	call PlaySFX
	ld c, $10
	call DelayFrames
.asm_8a15a
	call Function1c07 ;unload top menu on menu stack
	call Function891de
	call Function893e2
	call Function89245
	call Function89168
	and a
	ret

.asm_8a16b
	call Function89209
	call Function1c17
	call Function8920f
	scf
	ret
; 8a176 (22:6176)

MenuDataHeader_0x8a176: ; 0x8a176
	db $40 ; flags
	db 00, 14 ; start coords
	db 06, 19 ; end coords
; 8a17b

Function8a17b: ; 8a17b (22:617b)
	decoord 14, 0
	ld b, $5
	ld c, $4
	call Function89b3b
	ld hl, MenuDataHeader_0x8a19a
	ld a, [wd030]
	call Function89d5e
	ld hl, Function8a1b0
	call Function89d75
	jr nc, .asm_8a198
	ld a, $0
.asm_8a198
	ld d, a
	ret
; 8a19a (22:619a)

MenuDataHeader_0x8a19a: ; 0x8a19a
	db $40 ; flags
	db 00, 14 ; start coords
	db 06, 19 ; end coords
	dw MenuData2_0x8a1a2
	db 1 ; default option
; 0x8a1a2

MenuData2_0x8a1a2: ; 0x8a1a2
	db $e0 ; flags
	db 3 ; items
	db "ひらく@"
	db "すてる@"
	db "もどる@"
; 0x8a1b0

Function8a1b0: ; 8a1b0
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	hlcoord 1, 14
	ld a, [wcfa9]
	ld de, Strings_8a1cc
	dec a
	ld c, a
	call Function8919e
	call PlaceString
	ret
; 8a1cc

Strings_8a1cc: ; 8a1cc
	db   "めいし", $25, "せいりと へんしゅうを"
	next "おこないます"
	db   "@"
	db   "めいしフ,ルダー", $25, "めいしと"
	next "あんしょうばんごう", $1f, "けします"
	db   "@"
	db   "まえ", $25, "がめん", $1d, "もどります"
	db   "@"
; 8a20d

Function8a20d: ; 8a20d (22:620d)
	ld hl, UnknownText_0x8a232
	call PrintText
	ld a, $2
	call Function89259
	ret c
	ld hl, UnknownText_0x8a237
	call PrintText
	ld a, $2
	call Function89259
	ret c
	xor a
	call Function8a2fe
	ld hl, UnknownText_0x8a23c
	call PrintText
	xor a
	and a
	ret
; 8a232 (22:6232)

UnknownText_0x8a232: ; 0x8a232
	; If the CARD FOLDER is deleted, all its CARDS and the PASSCODE will also be deleted. Beware--a deleted CARD FOLDER can't be restored. Want to delete your CARD FOLDER?
	text_jump UnknownText_0x1c53ee
	db "@"
; 0x8a237

UnknownText_0x8a237: ; 0x8a237
	; Are you sure you want to delete it?
	text_jump UnknownText_0x1c5494
	db "@"
; 0x8a23c

UnknownText_0x8a23c: ; 0x8a23c
	; The CARD FOLDER has been deleted.
	text_jump UnknownText_0x1c54b9
	db "@"
; 0x8a241

Function8a241: ; 8a241 (22:6241)
	call Function1d6e
	call Function891fe
	call Function8a262
	jr nc, .asm_8a254
	call Function891fe
	call Function89b28
	scf
	ret

.asm_8a254
	call Function891de
	call WhiteBGMap
	call Function1d7d
	call Function891de
	and a
	ret

Function8a262: ; 8a262 (22:6262)
	call WhiteBGMap
	call Function893e2
	call Function8923c
	callba Function4a3a7
	callba Function49384
	hlcoord 1, 0
	call Function8a53d
	hlcoord 12, 4
	call Function8a58d
	ld a, $5
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	xor a
	ld [wd02e], a
	ld bc, wd013
	call Function8b36c
	call Function8b493
	call Function891ab
	call Function32f9
	call Function8b5e7
	ret

Function8a2aa: ; 8a2aa (22:62aa)
	ld hl, MenuDataHeader_0x8a2ef
	call LoadMenuDataHeader
	ld hl, UnknownText_0x8a2f4
	call PrintText
	ld a, $1
	call Function89259
	jr nc, .asm_8a2cf
	ld hl, UnknownText_0x8a2f9
	call PrintText
	ld a, $2
	call Function89259
	jr c, .asm_8a2ea
	call Function8a20d
	jr .asm_8a2ea

.asm_8a2cf
	call Function1c07 ;unload top menu on menu stack
	call Function8a241
	jr c, .asm_8a2ed
	ld a, $1
	call Function8a313
	call CloseSRAM
	call Function891de
	call Function89245
	call Function89168
	and a
	ret

.asm_8a2ea
	call Function1c17
.asm_8a2ed
	scf
	ret
; 8a2ef (22:62ef)

MenuDataHeader_0x8a2ef: ; 0x8a2ef
	db $40 ; flags
	db 12, 00 ; start coords
	db 17, 19 ; end coords
; 8a2f4

UnknownText_0x8a2f4: ; 0x8a2f4
	; There is an older CARD FOLDER from a previous journey. Do you want to open it?
	text_jump UnknownText_0x1c54dd
	db "@"
; 0x8a2f9

UnknownText_0x8a2f9: ; 0x8a2f9
	; Delete the old CARD FOLDER?
	text_jump UnknownText_0x1c552d
	db "@"
; 0x8a2fe

Function8a2fe: ; 8a2fe (22:62fe)
	call Function8a313
	call Function89305
	ld hl, $a603
	ld bc, $8
	ld a, $ff
	call ByteFill
	call CloseSRAM
	ret

Function8a313: ; 8a313 (22:6313)
	ld c, a
	call Function89160
	ld a, c
	ld [$a60b], a
	ret

Function8a31c: ; 8a31c (22:631c)
	push bc
	call Function8923c
	callba Function4a3a7
	callba Function49384
	hlcoord 1, 0
	call Function8a53d
	hlcoord 12, 4
	call Function8a58d
	call Function8a3b2
	pop bc
	ld a, c
	ld [wcf88], a
	ld [MenuSelection], a
	call Function1c89
	call Function1c10
	ld hl, wcfa5
	set 7, [hl]
.asm_8a34e
	call Function8a3a2
	call Function8923c
	call Function8a453
	call Function8a4d3
	call Function8a4fc
	call Function891ab
	call Function32f9
	call Function8a383
	jr c, .asm_8a370
	jr z, .asm_8a34e
.asm_8a36a
	call Function89448
	xor a
	ld e, a
	ret

.asm_8a370
	call Function89448
	call Function1bee
	call Function8a3a2
	ld a, [MenuSelection]
	cp $ff
	jr z, .asm_8a36a
	ld e, a
	and a
	ret

Function8a383: ; 8a383 (22:6383)
	callba Function241ba
	ld a, c
	ld hl, wcfa8
	and [hl]
	ret z
	bit 0, a
	jr nz, .asm_8a399
	bit 1, a
	jr nz, .asm_8a39e
	xor a
	ret

.asm_8a399
	call PlayClickSFX
	scf
	ret

.asm_8a39e
	call PlayClickSFX
	ret

Function8a3a2: ; 8a3a2 (22:63a2)
	ld a, [wcfa9]
	dec a
	ld hl, DefaultFlypoint
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	ld [MenuSelection], a
	ret

Function8a3b2: ; 8a3b2 (22:63b2)
	ld a, $1
	ld [MenuSelection], a
	call Function8a4fc
	call Function8a3df
	jr nc, .asm_8a3ce
	decoord 0, 2
	ld b, $6
	ld c, $9
	call Function89b3b
	ld hl, MenuDataHeader_0x8a435
	jr .asm_8a3db

.asm_8a3ce
	decoord 0, 2
	ld b, $8
	ld c, $9
	call Function89b3b
	ld hl, MenuDataHeader_0x8a40f
.asm_8a3db
	call Function1d3c
	ret

Function8a3df: ; 8a3df (22:63df)
	call Function89160
	ld hl, $a603
	call Function89b45
	call CloseSRAM
	ld hl, DefaultFlypoint
	jr c, .asm_8a3f8
	ld de, Unknown_8a408
	call Function8a400
	scf
	ret

.asm_8a3f8
	ld de, Unknown_8a40b
	call Function8a400
	and a
	ret

Function8a400: ; 8a400 (22:6400)
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, Function8a400
	ret
; 8a408 (22:6408)

Unknown_8a408: db 1, 2, -1
Unknown_8a40b: db 1, 2, 3, -1
MenuDataHeader_0x8a40f: ; 0x8a40f
	db $40 ; flags
	db 02, 00 ; start coords
	db 11, 10 ; end coords
	dw MenuData2_0x8a417
	db 1 ; default option
; 0x8a417

MenuData2_0x8a417: ; 0x8a417
	db $a0 ; flags
	db 4 ; items
	db "めいしりスト@"
	db "じぶんの めいし@"
	db "めいしこうかん@"
	db "やめる@"
; 0x8a435

MenuDataHeader_0x8a435: ; 0x8a435
	db $40 ; flags
	db 02, 00 ; start coords
	db 09, 10 ; end coords
	dw MenuData2_0x8a43d
	db 1 ; default option
; 0x8a43d

MenuData2_0x8a43d: ; 0x8a43d
	db $a0 ; flags
	db 3 ; items
	db "めいしりスト@"
	db "じぶんの めいし@"
	db "やめる@"
; 0x8a453

Function8a453: ; 8a453 (22:6453)
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	hlcoord 1, 14
	ld de, String_8a476
	ld a, [MenuSelection]
	cp $ff
	jr z, .asm_8a472
	ld de, Strings_8a483
	dec a
	ld c, a
	call Function8919e
.asm_8a472
	call PlaceString
	ret
; 8a476 (22:6476)

String_8a476: ; 8a476
	db   "まえ", $25, "がめん", $1d, "もどります@"
; 8a483

Strings_8a483: ; 8a483
	db   "おともだち", $25, "めいしは"
	next "ここ", $1d, "いれておきます@"
	db   "でんわばんごう", $1f, "いれると"
	next "めいしこうかん", $4a, "できます@"
	db   "ともだちと じぶん", $25, "めいしを"
	next "せきがいせんで こうかん します@"
; 8a4d3

Function8a4d3: ; 8a4d3 (22:64d3)
	ld a, [MenuSelection]
	cp $1
	jr nz, .asm_8a4eb
	ld a, $5
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	ld a, $7
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	ret

.asm_8a4eb
	ld a, $7
	hlcoord 12, 4, AttrMap
	call Function8a5a3
	ld a, $6
	hlcoord 15, 4, AttrMap
	call Function8a5a3
	ret

Function8a4fc: ; 8a4fc (22:64fc)
	ld a, [MenuSelection]
	cp $3
	jr nz, asm_8a529
	ld hl, wd012
	ld a, [hli]
	ld b, a
	ld a, [hld]
	add b
	ld [hl], a
	ld b, a
	ld c, $80
	call Function89cdf
	call Function8a515
	ret

Function8a515: ; 8a515 (22:6515)
	ld hl, wd012
	ld a, [hl]
	cp $38
	jr c, .asm_8a520
	cp $3c
	ret c
.asm_8a520
	ld a, [wd013]
	cpl
	inc a
	ld [wd013], a
	ret

asm_8a529: ; 8a529 (22:6529)
	ld hl, wd012
	ld a, $3c
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld hl, Sprites
	xor a
	ld bc, $20
	call ByteFill
	ret

Function8a53d: ; 8a53d (22:653d)
	push hl
	ld a, $15
	ld c, $8
	ld de, $14
	call Function8a573
	ld a, $1d
	ld c, $9
	call Function8a57c
	inc a
	ld [hl], a
	call Function8a584
	pop hl
	add hl, de
	ld a, $1f
	ld c, $8
	call Function8a573
	dec hl
	ld a, $51
	ld [hli], a
	ld a, $26
	ld c, $1
	call Function8a57c
	ld a, $52
	ld c, $3
	call Function8a573
	ld a, $27
	ld c, $6
Function8a573: ; 8a573 (22:6573)
	ld [hl], a
	call Function8a584
	inc a
	dec c
	jr nz, Function8a573
	ret

Function8a57c: ; 8a57c (22:657c)
	ld [hl], a
	call Function8a584
	dec c
	jr nz, Function8a57c
	ret

Function8a584: ; 8a584 (22:6584)
	push af
	ld a, $4
	call Function89215
	inc hl
	pop af
	ret

Function8a58d: ; 8a58d (22:658d)
	ld a, $2d
	ld bc, $606
	ld de, $14
.asm_8a595
	push bc
	push hl
.asm_8a597
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_8a597
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8a595
	ret

Function8a5a3: ; 8a5a3 (22:65a3)
	ld bc, $603
	ld de, $14
.asm_8a5a9
	push bc
	push hl
.asm_8a5ab
	ld [hli], a
	dec c
	jr nz, .asm_8a5ab
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8a5a9
	ret

Function8a5b6: ; 8a5b6 (22:65b6)
	ld a, [rSVBK] ; $ff00+$70
	push af
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	ld hl, Palette_8a5e5
	ld de, wd020
	ld bc, $18
	call CopyBytes
	ld hl, Palette_8a5fd
	ld de, Unkn2Pals
	ld bc, $8
	call CopyBytes
	ld hl, Palette_8a605
	ld de, wd048
	ld bc, $8
	call CopyBytes
	pop af
	ld [rSVBK], a ; $ff00+$70
	ret
; 8a5e5 (22:65e5)

Palette_8a5e5: ; 8a5e5
	RGB 31, 31, 31
	RGB 27, 19, 00
	RGB 07, 11, 22
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 16, 16, 31
	RGB 27, 19, 00
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 00, 00
	RGB 27, 19, 00
	RGB 00, 00, 00
; 8a5fd

Palette_8a5fd: ; 8a5fd
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 00, 00, 00
	RGB 31, 31, 31
; 8a605

Palette_8a605: ; 8a605
	RGB 00, 00, 00
	RGB 14, 18, 31
	RGB 16, 16, 31
	RGB 31, 31, 31
; 8a60d

Function8a60d: ; 8a60d
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_8a624
	ld de, Unkn2Pals
	ld bc, $0008
	call CopyBytes
	pop af
	ld [rSVBK], a
	ret
; 8a624

Palette_8a624: ; 8a624
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 00, 00, 00
; 8a62c

Function8a62c: ; 8a62c (22:662c)
	call Function1d6e
	call Function891fe
	xor a
	call Function8b94a
	call Function8b677
.asm_8a639
	xor a
	ld [wd033], a
	ld [wd032], a
	ld [wd0e3], a
	call Function8b7bd
	ld a, c
	and a
	jr z, .asm_8a66a
	ld [MenuSelection], a
	ld b, a
	ld a, [wcf77]
	inc a
	ld [wd034], a
	push bc
	call Function8b960
	ld a, c
	pop bc
	jr z, .asm_8a639
	ld c, a
	ld hl, Jumptable_8a671
	ld a, b
	ld [MenuSelection], a
	ld a, c
	dec a
	rst JumpTable
	jr .asm_8a639

.asm_8a66a
	call Function891fe
	call Function89b28
	ret

Jumptable_8a671: ; 8a671 (22:6671)
	dw Function8a679
	dw Function8a6cd
	dw Function8a8c3
	dw Function8a930

Function8a679: ; 8a679 (22:6679)
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	call Function89844
	call CloseSRAM
	call Function89160
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call Function891ab
	call CloseSRAM
.asm_8a6a3
	call Function89a57
	jr c, .asm_8a6a3
	and a
	jr z, Function8a679
	ld hl, Jumptable_8a6bc
	dec a
	rst JumpTable
	jr c, Function8a679
	call Function891fe
	call Function8b677
	call Function89448
	ret

Jumptable_8a6bc: ; 8a6bc (22:66bc)
	dw Function8a6c0
	dw Function8a6c5

Function8a6c0: ; 8a6c0 (22:66c0)
	call PlayClickSFX
	and a
	ret

Function8a6c5: ; 8a6c5 (22:66c5)
	call PlayClickSFX
	call Function89d0d
	scf
	ret

Function8a6cd: ; 8a6cd (22:66cd)
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	call Function89844
	call Function8a757
	call CloseSRAM
.asm_8a6e5
	call Function89160
	call Function8931b
	call Function89856
	call Function89a2e
	call Function891ab
	xor a
	ld [wd02f], a
	call CloseSRAM
.asm_8a6fb
	call Function89b97
	call Function89c67
	jr c, .asm_8a718
	ld a, b
	and a
	jr z, .asm_8a6fb
	call PlayClickSFX
	call Function89448
	ld a, [wd011]
	ld hl, Jumptable_8a74f
	rst JumpTable
	jr nc, .asm_8a6e5
	jr .asm_8a742

.asm_8a718
	call Function89160
	call Function8a765
	call CloseSRAM
	jr nc, .asm_8a73f
	call Function8923c
	call Function89448
	call Function89a23
	hlcoord 1, 13
	ld de, String_89135
	call PlaceString
	call WaitBGMap
	ld a, $2
	call Function89254
	jr c, .asm_8a6e5
.asm_8a73f
	call CloseSRAM
.asm_8a742
	call WhiteBGMap
	call Function89448
	call Function891d3
	call Function8b677
	ret

Jumptable_8a74f: ; 8a74f (22:674f)
	dw Function8a78c
	dw Function8a7cb
	dw Function8a818
	dw Function8a8a1

Function8a757: ; 8a757 (22:6757)
	call Function8939a
	xor a
	ld [wd010], a
	ld [wd011], a
	ld [wd012], a
	ret

Function8a765: ; 8a765 (22:6765)
	call Function8931b
	push bc
	ld hl, $0
	add hl, bc
	ld de, DefaultFlypoint
	ld c, $6
	call Function89185
	pop bc
	jr nz, .asm_8a78a
	push bc
	ld hl, $11
	add hl, bc
	ld de, wd008
	ld c, $8
	call Function89185
	pop bc
	jr nz, .asm_8a78a
	and a
	ret

.asm_8a78a
	scf
	ret

Function8a78c: ; 8a78c (22:678c)
	call Function891fe
	ld de, DefaultFlypoint
	ld b, $5
	callba NamingScreen
	call Function89160
	call Function8931b
	push bc
	ld hl, $0
	add hl, bc
	ld d, h
	ld e, l
	ld hl, DefaultFlypoint
	call InitName
	call CloseSRAM
	call DelayFrame
	call Functiona57
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	pop bc
	call Function89844
	call CloseSRAM
	and a
	ret

Function8a7cb: ; 8a7cb (22:67cb)
	ld a, [MenuSelection]
	push af
	call Function891de
	ld de, wd008
	ld c, $0
	callba Function17a68f
	jr c, .asm_8a7f4
	ld hl, wd008
	ld a, $ff
	ld bc, $8
	call ByteFill
	ld h, d
	ld l, e
	ld de, wd008
	ld c, $8
	call Function89193
.asm_8a7f4
	pop af
	ld [MenuSelection], a
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	call Function89844
	call Function89856
	call Function89a2e
	call Function891ab
	call CloseSRAM
	and a
	ret

Function8a818: ; 8a818 (22:6818)
	call Function89a23
	ld hl, DefaultFlypoint
	call Function89331
	jr c, .asm_8a875
	ld hl, wd008
	call Function89b45
	jr nc, .asm_8a87a
	call Function89160
	call Function8a765
	jr nc, .asm_8a863
	call Function8931b
	push bc
	ld hl, $0
	add hl, bc
	ld d, h
	ld e, l
	ld hl, DefaultFlypoint
	ld c, $6
	call Function89193
	pop bc
	ld hl, $11
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wd008
	ld c, $8
	call Function89193
	hlcoord 1, 13
	ld de, .string_8a868
	call PlaceString
	call WaitBGMap
	call Functiona36
.asm_8a863
	call CloseSRAM
	scf
	ret
; 8a868 (22:6868)

.string_8a868
	db "めいし", $1f, "かきかえ まし", $22, "@"
.asm_8a875
	ld de, String_8a88b
	jr .asm_8a87d

.asm_8a87a
	ld de, String_8911c
.asm_8a87d
	hlcoord 1, 13
	call PlaceString
	call WaitBGMap
	call Functiona36
	and a
	ret
; 8a88b (22:688b)

String_8a88b: ; 8a88b
	db   "おともだち", $25, "なまえが"
	next "かかれて いません!@"
; 8a8a1

Function8a8a1: ; 8a8a1 (22:68a1)
	call Function89160
	call Function8a765
	call CloseSRAM
	jr nc, .asm_8a8bf
	call Function89a23
	hlcoord 1, 13
	ld de, String_89135
	call PlaceString
	ld a, $2
	call Function89254
	jr c, .asm_8a8c1
.asm_8a8bf
	scf
	ret

.asm_8a8c1
	and a
	ret

Function8a8c3: ; 8a8c3 (22:68c3)
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	call Function89844
	call Function8939a
	call Function89856
	call CloseSRAM
	call Function891ab
	hlcoord 1, 13
	ld de, String_8a919
	call PlaceString
	ld a, $2
	call Function89254
	jr c, .asm_8a90f
	call Function89160
	call Function892b4
	call CloseSRAM
	call Function89a23
	call Function8923c
	hlcoord 1, 13
	ld de, String_8a926
	call PlaceString
	call WaitBGMap
	call Functiona36
.asm_8a90f
	call Function89448
	call Function891fe
	call Function8b677
	ret
; 8a919 (22:6919)

String_8a919: ; 8a919
	db "このデータ", $1f, "けしますか?@"
; 8a926

String_8a926: ; 8a926
	db "データ", $1f, "けしまし", $22, "@"
; 8a930

Function8a930: ; 8a930 (22:6930)
	ld a, [MenuSelection]
	push af
	xor a
	ld [wd032], a
	ld a, $1
	ld [wd033], a
	ld a, [wd034]
	ld [wd0e3], a
.asm_8a943
	call Function8b7bd
	ld a, [wcf73]
	and $1
	jr nz, .asm_8a953
	ld a, c
	and a
	jr nz, .asm_8a943
	pop af
	ret

.asm_8a953
	call Function89160
	pop af
	cp c
	jr z, .asm_8a995
	push bc
	ld [MenuSelection], a
	call Function8931b
	push bc
	ld h, b
	ld l, c
	ld de, DefaultFlypoint
	ld bc, $25
	call CopyBytes
	pop de
	pop bc
	ld a, c
	ld [MenuSelection], a
	call Function8931b
	push bc
	ld h, b
	ld l, c
	ld bc, $25
	call CopyBytes
	pop de
	ld hl, DefaultFlypoint
	ld bc, $25
	call CopyBytes
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
	ld de, SFX_SWITCH_POKEMON
	call WaitPlaySFX
.asm_8a995
	call CloseSRAM
	ret

Function8a999: ; 8a999 (22:6999)
	ld hl, MenuDataHeader_0x8a9c9
	call LoadMenuDataHeader
	ld c, $1
.asm_8a9a1
	call Function8a9ce
	jr c, .asm_8a9bb
	push bc
	push de
	call Function1d6e
	pop de
	dec e
	ld a, e
	ld hl, Jumptable_8a9c5
	rst JumpTable
	call Function891fe
	call Function89b28
	pop bc
	jr .asm_8a9a1

.asm_8a9bb
	call Function89209
	call Function1c17
	call Function8920f
	ret

Jumptable_8a9c5: ; 8a9c5 (22:69c5)
	dw Function8aa0a
	dw Function8ab3b
; 8a9c9 (22:69c9)

MenuDataHeader_0x8a9c9: ; 0x8a9c9
	db $40 ; flags
	db 04, 11 ; start coords
	db 11, 18 ; end coords
; 8a9ce

Function8a9ce: ; 8a9ce (22:69ce)
	push bc
	decoord 11, 4
	ld b, $6
	ld c, $6
	call Function89b3b
	pop bc
	ld a, c
	ld hl, MenuDataHeader_0x8a9f2
	call Function89d5e
	ld hl, Function8aa09
	call Function89d85
	jr c, .asm_8a9ed
	ld c, a
	ld e, a
	and a
	ret

.asm_8a9ed
	ld c, a
	ld e, $0
	scf
	ret
; 8a9f2 (22:69f2)

MenuDataHeader_0x8a9f2: ; 0x8a9f2
	db $40 ; flags
	db 04, 11 ; start coords
	db 11, 18 ; end coords
	dw MenuData2_0x8a9fa
	db 1 ; default option
; 0x8a9fa

MenuData2_0x8a9fa: ; 0x8a9fa
	db $a0 ; flags
	db 3 ; items
	db "へんしゅう@"
	db "みる@"
	db "やめる@"
; 0x8aa09

Function8aa09: ; 8aa09
	ret
; 8aa0a

Function8aa0a: ; 8aa0a (22:6a0a)
	ld a, $1
	ld [wd02f], a
	ld [wd011], a
	xor a
	ld [wd010], a
	ld [wd012], a
	call Function89160
	ld hl, $a603
	ld de, wd008
	call Function89381
	call CloseSRAM
	call Function891fe
	call WhiteBGMap
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
.asm_8aa3a
	call Function8987f
	call Function89a2e
	call Function891ab
.asm_8aa43
	call Function89b97
	call Function89c67
	jr c, .asm_8aa61
	ld a, b
	and a
	jr z, .asm_8aa43
	call PlayClickSFX
	call Function89448
	ld a, [wd011]
	dec a
	ld hl, Jumptable_8aa6d
	rst JumpTable
	jr nc, .asm_8aa3a
	jr .asm_8aa69

.asm_8aa61
	call Function89448
	call Function8ab11
	jr nc, .asm_8aa3a
.asm_8aa69
	call Function89448
	ret

Jumptable_8aa6d: ; 8aa6d (22:6a6d)
	dw Function8aa73
	dw Function8aab6
	dw Function8ab11

Function8aa73: ; 8aa73 (22:6a73)
	ld a, [MenuSelection]
	ld e, a
	push de
	call Function891de
	ld de, wd008
	ld c, $0
	callba Function17a68f
	jr c, .asm_8aa9d
	ld hl, wd008
	ld a, $ff
	ld bc, $8
	call ByteFill
	ld h, d
	ld l, e
	ld de, wd008
	ld c, $8
	call Function89193
.asm_8aa9d
	call Function891fe
	call WhiteBGMap
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
	pop de
	ld a, e
	ld [MenuSelection], a
	and a
	ret

Function8aab6: ; 8aab6 (22:6ab6)
	call Function89a23
	ld hl, wd008
	call Function89b45
	jr nc, Function8ab00
	call Function89160
	ld de, wd008
	ld hl, $a603
	ld c, $8
	call Function89185
	jr z, .asm_8aaeb
	ld hl, wd008
	ld de, $a603
	ld c, $8
	call Function89193
	hlcoord 1, 13
	ld de, String_8aaf0
	call PlaceString
	call WaitBGMap
	call Functiona36
.asm_8aaeb
	call CloseSRAM
	scf
	ret
; 8aaf0 (22:6af0)

String_8aaf0: ; 8aaf0
	db "あたらしい めいし", $4a, "できまし", $22, "@"
; 8ab00

Function8ab00: ; 8ab00
	ld de, String_8911c
	hlcoord 1, 13
	call PlaceString
	call WaitBGMap
	call Function89235
	and a
	ret

Function8ab11: ; 8ab11 (22:6b11)
	call Function89160
	ld hl, $a603
	ld de, wd008
	ld c, $8
	call Function89185
	call CloseSRAM
	jr z, .asm_8ab37
	call Function89a23
	hlcoord 1, 13
	ld de, String_89135
	call PlaceString
	ld a, $2
	call Function89254
	jr c, .asm_8ab39
.asm_8ab37
	scf
	ret

.asm_8ab39
	and a
	ret

Function8ab3b: ; 8ab3b (22:6b3b)
	call Function891fe
	call WhiteBGMap
	call Function893cc
	call Function89807
	call Function89492
	call Function894ca
	call Function89160
	ld hl, $a603
	ld de, wd008
	call Function89381
	call CloseSRAM
	call Function8987f
	call Function89160
	hlcoord 1, 13
	ld bc, $a007
	call Function89a0c
	call CloseSRAM
	call Function891ab
	call Function8ab77
	jr c, Function8ab3b
	ret

Function8ab77: ; 8ab77 (22:6b77)
	call Function354b
	bit 0, c
	jr nz, .asm_8ab8e
	bit 1, c
	jr nz, .asm_8ab8e
	bit 3, c
	jr z, Function8ab77
	call PlayClickSFX
	call Function89d0d
	scf
	ret

.asm_8ab8e
	call PlayClickSFX
	and a
	ret

Function8ab93: ; 8ab93 (22:6b93)
	call WhiteBGMap
	call Function1d6e
	callba Function105688
	call ClearSprites
	call Function891fe
	call Function89b28
	ret
; 8aba9 (22:6ba9)

Function8aba9: ; 8aba9
	ld a, $2
	call Function8b94a
	ld a, $1
	ld [wd032], a
.asm_8abb3
	call Function891fe
	call Function8b677
.asm_8abb9
	call Function8b7bd
	jr z, .asm_8abdf
	ld a, c
	ld [MenuSelection], a
	call Function89160
	call Function8931b
	ld hl, $0011
	add hl, bc
	call Function89b45
	call CloseSRAM
	jr c, .asm_8abe2
	ld de, SFX_WRONG
	call WaitPlaySFX
	call CloseSRAM
	jr .asm_8abb9

.asm_8abdf
	xor a
	ld c, a
	ret

.asm_8abe2
	call PlayClickSFX
.asm_8abe5
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	call Function89844
	call CloseSRAM
	call Function89160
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call CloseSRAM
	call Function891ab
.asm_8ac0f
	call Function89a57
	jr c, .asm_8ac0f
	and a
	jr z, .asm_8abe5
	cp $2
	jr z, .asm_8ac0f
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	hlcoord 1, 14
	ld de, String_8ac3b
	call PlaceString
	ld a, $1
	call Function8925e
	jp c, .asm_8abb3
	ld a, [MenuSelection]
	ld c, a
	ret
; 8ac3b

String_8ac3b: ; 8ac3b
	db   "こ", $25, "ともだち", $1d, "でんわを"
	next "かけますか?@"
; 8ac4e

Function8ac4e: ; 8ac4e
	xor a
	ld [MenuSelection], a
	push de
	call Function891de
	call WhiteBGMap
	call Function893cc
	pop bc
	call Function89844
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call Function891ab
	ret
; 8ac70

Function8ac70: ; 8ac70
	push de
	ld a, $3
	call Function8b94a
Function8ac76: ; 8ac76
	call Function891fe
	call Function8b677
Function8ac7c: ; 8ac7c
	call Function8b7bd
	jr z, .asm_8acf0
	ld a, c
	ld [wd02f], a
	ld [MenuSelection], a
	call Function89160
	call Function8931b
	call Function8932d
	call CloseSRAM
	jr nc, .asm_8acb0
	call Function89160
	ld hl, $0011
	add hl, bc
	call Function89b45
	call CloseSRAM
	jr nc, .asm_8accc
	call Function89160
	call Function892b7
	call CloseSRAM
	jr .asm_8accc

.asm_8acb0
	call Function8ad0b
	jr c, Function8ac76
	and a
	jr nz, .asm_8accc
	call Function89160
	ld h, b
	ld l, c
	ld d, $0
	ld e, $6
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld c, $1f
	call Function89193
	jr .asm_8ace4

.asm_8accc
	pop hl
	call Function89160
	ld d, b
	ld e, c
	ld c, $6
	call Function89193
	ld a, $6
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld c, $1f
	call Function89193
.asm_8ace4
	call CloseSRAM
	call Functione51
	ld a, [wd02f]
	ld c, a
	and a
	ret

.asm_8acf0
	ld hl, UnknownText_0x8ad06
	call PrintText
	ld a, $2
	call Function89259
	jp c, Function8ac7c
	call Functione51
	pop de
	ld c, $0
	scf
	ret
; 8ad06

UnknownText_0x8ad06: ; 0x8ad06
	; Finish registering CARDS?
	text_jump UnknownText_0x1c554a
	db "@"
; 0x8ad0b

Function8ad0b: ; 8ad0b
.asm_8ad0b
	ld a, [MenuSelection]
	ld [wd02f], a
	call Function891de
	call WhiteBGMap
	call Function893cc
	call Function89160
	call Function8931b
	push bc
	call Function89844
	call Function8939a
	call Function89856
	hlcoord 1, 13
	call Function899fe
	call CloseSRAM
	call Function891ab
	pop bc
.asm_8ad37
	push bc
	call Function89a57
	pop bc
	jr c, .asm_8ad37
	and a
	jr z, .asm_8ad0b
	cp $2
	jr z, .asm_8ad37
	call Function8923c
	push bc
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld de, String_8ad89
	hlcoord 1, 14
	call PlaceString
	ld a, $2
	call Function8925e
	jr c, .asm_8ad87
	call Function8923c
	hlcoord 0, 12
	ld b, $4
	ld c, $12
	call TextBox
	ld de, String_8ad9c
	hlcoord 1, 14
	call PlaceString
	ld a, $1
	call Function8925e
	jr c, .asm_8ad84
	ld a, $0
	jr .asm_8ad86

.asm_8ad84
	ld a, $1
.asm_8ad86
	and a
.asm_8ad87
	pop bc
	ret
; 8ad89

String_8ad89: ; 8ad89
	db   "こ", $25, "めいし", $1f, "けして"
	next "いれかえますか?@"
; 8ad9c

String_8ad9c: ; 8ad9c
	db   "おともだち", $25, "なまえを"
	next "のこして おきますか?@"
; 8adb3

Function8adb3: ; 8adb3
	call Function891de
	call Function8a262
	push af
	call Function891de
	pop af
	ret
; 8adbf

Function8adbf: ; 8adbf
	call Function89160
	ld hl, $a603
	call Function89b45
	call CloseSRAM
	ret
; 8adcc

Function8adcc: ; 8adcc
	call Function89160
	call Function8b3b0
	call CloseSRAM
	ret nc
	cp $2
	ret z
	scf
	ret
; 8addb

SpecialHoOhChamber: ; 0x8addb
	ld hl, PartySpecies
	ld a, [hl]
	cp HO_OH ; is Ho-oh the first Pokémon in the party?
	jr nz, .done ; if not, we're done
	call GetSecondaryMapHeaderPointer
	ld de, $0326
	ld b, SET_FLAG
	call EventFlagAction
.done
	ret
; 0x8adef

Function8adef: ; 8adef
	call GetSecondaryMapHeaderPointer
	ld de, $0328
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr nz, .asm_8ae2f
	ld a, WATER_STONE
	ld [CurItem], a
	ld hl, NumItems
	call CheckItem
	jr c, .asm_8ae24
	ld a, [PartyCount]
	ld b, a
	inc b
.asm_8ae10
	dec b
	jr z, .asm_8ae2f
	ld a, b
	dec a
	ld [CurPartyMon], a
	push bc
	ld a, PartyMon1Item - PartyMon1
	call GetPartyParamLocation
	pop bc
	ld a, [hl]
	cp WATER_STONE
	jr nz, .asm_8ae10
.asm_8ae24
	call GetSecondaryMapHeaderPointer
	ld de, $0328
	ld b, SET_FLAG
	call EventFlagAction
.asm_8ae2f
	ret
; 8ae30

Function8ae30: ; 8ae30
	push de
	push bc
	call GetSecondaryMapHeaderPointer
	ld a, h
	cp RuinsofAlphAerodactylChamber_SecondMapHeader / $100
	jr nz, .asm_8ae4a
	ld a, l
	cp RuinsofAlphAerodactylChamber_SecondMapHeader % $100
	jr nz, .asm_8ae4a
	ld de, $0329
	ld b, SET_FLAG
	call EventFlagAction
	scf
	jr .done

.asm_8ae4a
	and a
.done
	pop bc
	pop de
	ret
; 8ae4e

Function8ae4e: ; 8ae4e
	push hl
	push de
	call GetSecondaryMapHeaderPointer
	ld a, h
	cp RuinsofAlphKabutoChamber_SecondMapHeader / $100
	jr nz, .done
	ld a, l
	cp RuinsofAlphKabutoChamber_SecondMapHeader % $100
	jr nz, .done
	ld de, $0327
	ld b, SET_FLAG
	call EventFlagAction
.done
	pop de
	pop hl
	ret
; 8ae68

Function8ae68: ; 8ae68
	ld a, [ScriptVar]
	ld hl, MenuDataHeader_0x8aed5
	and a
	jr z, .asm_8ae79
	ld d, $0
	ld e, $5
.asm_8ae75
	add hl, de
	dec a
	jr nz, .asm_8ae75
.asm_8ae79
	call LoadMenuDataHeader
	xor a
	ld [hBGMapMode], a
	call Function1cbb
	call Function1ad2
	call Function321c
	call Function1cfd ;hl = curmenu start location in tilemap
	inc hl
	ld d, $0
	ld e, $14
	add hl, de
	add hl, de
	ld a, [ScriptVar]
	ld c, a
	ld de, Unknown_8aebc
	and a
	jr z, .asm_8aea5
.asm_8ae9c
	ld a, [de]
	inc de
	cp $ff
	jr nz, .asm_8ae9c
	dec c
	jr nz, .asm_8ae9c
.asm_8aea5
	call Function8af09
	ld bc, AttrMap - TileMap
	add hl, bc
	call Function8aee9
	call Function3200
	call Functiona36
	call PlayClickSFX
	call Function1c17
	ret
; 8aebc

Unknown_8aebc: ; 8aebc
	db $08, $44, $04, $00, $2e, $08, $ff
	db $26, $20, $0c, $0e, $46, $ff
	db $4c, $00, $46, $08, $42, $ff
	db $0e, $2c, $64, $2c, $0e, $ff
	db $02, $20, $42, $06, $44, $ff
; 8aed5

MenuDataHeader_0x8aed5: ; 0x8aed5
	db $40 ; flags
	db 04, 03 ; start coords
	db 09, 16 ; end coords
MenuDataHeader_0x8aeda: ; 0x8aeda
	db $40 ; flags
	db 04, 04 ; start coords
	db 09, 15 ; end coords
MenuDataHeader_0x8aedf: ; 0x8aedf
	db $40 ; flags
	db 04, 04 ; start coords
	db 09, 15 ; end coords
MenuDataHeader_0x8aee4: ; 0x8aee4
	db $40 ; flags
	db 04, 04 ; start coords
	db 09, 15 ; end coords

MenuDataHeader_0x8aee9: ; 0x8aee4
	db $40 ; flags
	db 04, 04 ; start coords
	db 09, 15 ; end coords
; 8aee9

Function8aee9: ; 8aee9
.asm_8aee9
	ld a, [de]
	cp $ff
	ret z
	cp $60
	ld a, $d
	jr c, .asm_8aef5
	ld a, $5
.asm_8aef5
	call Function8aefd
	inc hl
	inc hl
	inc de
	jr .asm_8aee9
; 8aefd

Function8aefd: ; 8aefd
	push hl
	ld [hli], a
	ld [hld], a
	ld b, $0
	ld c, $14
	add hl, bc
	ld [hli], a
	ld [hl], a
	pop hl
	ret
; 8af09

Function8af09: ; 8af09
	push hl
	push de
.asm_8af0b
	ld a, [de]
	cp $ff
	jr z, .asm_8af19
	ld c, a
	call Function8af1c
	inc hl
	inc hl
	inc de
	jr .asm_8af0b

.asm_8af19
	pop de
	pop hl
	ret
; 8af1c

Function8af1c: ; 8af1c
	push hl
	ld a, c
	cp $60
	jr z, .asm_8af3b
	cp $62
	jr z, .asm_8af4b
	cp $64
	jr z, .asm_8af5b
	ld [hli], a
	inc a
	ld [hld], a
	dec a
	ld b, $0
	ld c, $14
	add hl, bc
	ld c, $10
	add c
	ld [hli], a
	inc a
	ld [hl], a
	pop hl
	ret

.asm_8af3b
	ld [hl], $5b
	inc hl
	ld [hl], $5c
	ld bc, $0013
	add hl, bc
	ld [hl], $4d
	inc hl
	ld [hl], $5d
	pop hl
	ret

.asm_8af4b
	ld [hl], $4e
	inc hl
	ld [hl], $4f
	ld bc, $0013
	add hl, bc
	ld [hl], $5e
	inc hl
	ld [hl], $5f
	pop hl
	ret

.asm_8af5b
	ld [hl], $2
	inc hl
	ld [hl], $3
	ld bc, $0013
	add hl, bc
	ld [hl], $3
	inc hl
	ld [hl], $2
	pop hl
	ret
; 8af6b

SpecialBuenasPassword: ; 8af6b
	xor a
	ld [wcf76], a
	ld hl, MenuDataHeader_0x8afa9
	call Function1d3c
	ld a, [wdc4a]
	ld c, a
	callba Functionb8f8f
	ld a, [wcf83]
	add c
	add $2
	ld [wcf85], a
	call Function1c00
	call Function1e5d
	callba Function4ae5e
	ld b, $0
	ld a, [MenuSelection]
	ld c, a
	ld a, [wdc4a]
	and $3
	cp c
	jr nz, .asm_8afa4
	ld b, $1
.asm_8afa4
	ld a, b
	ld [ScriptVar], a
	ret
; 8afa9

MenuDataHeader_0x8afa9: ; 0x8afa9
	db $40 ; flags
	db 00, 00 ; start coords
	db 07, 10 ; end coords
	dw MenuData2_0x8afb2
	db 1 ; default option
; 0x8afb1

	db 0
MenuData2_0x8afb2: ; 0x8afb2
	db $81 ; flags
	db 0 ; items
	dw Unknown_8afb8
	dw Function8afbd
; 0x8afb4

Unknown_8afb8: ; 8afb8
	db 3
	db 0, 1, 2, $ff
Function8afbd: ; 8afbd
	push de
	ld a, [wdc4a]
	and $f0
	ld c, a
	ld a, [MenuSelection]
	add c
	ld c, a
	callba Functionb8f8f
	pop hl
	call PlaceString
	ret
; 8afd4

SpecialBuenaPrize: ; 8afd4
	xor a
	ld [wd0e4], a
	ld a, $1
	ld [MenuSelection], a
	call Function8b0d6
	call Function8b090
	ld hl, UnknownText_0x8b072
	call PrintText
	jr .asm_8aff1

.asm_8afeb
	ld hl, UnknownText_0x8b072
	call Function105a
.asm_8aff1
	call DelayFrame
	call Function1ad2
	call Function8b097
	call Function8b0e2
	jr z, .asm_8b05f
	ld [wcf75], a
	call GetBuenaPrize
	ld a, [hl]
	ld [wd265], a
	call GetItemName
	ld hl, UnknownText_0x8b077
	call Function105a
	call YesNoBox
	jr c, .asm_8afeb
	ld a, [wcf75]
	call GetBuenaPrize
	inc hl
	ld a, [hld]
	ld c, a
	ld a, [wBlueCardBalance]
	cp c
	jr c, .asm_8b047
	ld a, [hli]
	push hl
	ld [CurItem], a
	ld a, $1
	ld [wd10c], a
	ld hl, NumItems
	call ReceiveItem
	pop hl
	jr nc, .asm_8b04c
	ld a, [hl]
	ld c, a
	ld a, [wBlueCardBalance]
	sub c
	ld [wBlueCardBalance], a
	call Function8b097
	jr .asm_8b051

.asm_8b047
	ld hl, UnknownText_0x8b081
	jr .asm_8b05a

.asm_8b04c
	ld hl, UnknownText_0x8b086
	jr .asm_8b05a

.asm_8b051
	ld de, SFX_TRANSACTION
	call PlaySFX
	ld hl, UnknownText_0x8b07c
.asm_8b05a
	call Function105a
	jr .asm_8afeb

.asm_8b05f
	call Function1c17
	call Function1c17
	ld hl, UnknownText_0x8b08b
	call PrintText
	call Functiona36
	call PlayClickSFX
	ret
; 8b072

UnknownText_0x8b072: ; 0x8b072
	; Which prize would you like?
	text_jump UnknownText_0x1c589f
	db "@"
; 0x8b077

UnknownText_0x8b077: ; 0x8b077
	; ? Is that right?
	text_jump UnknownText_0x1c58bc
	db "@"
; 0x8b07c

UnknownText_0x8b07c: ; 0x8b07c
	; Here you go!
	text_jump UnknownText_0x1c58d1
	db "@"
; 0x8b081

UnknownText_0x8b081: ; 0x8b081
	; You don't have enough points.
	text_jump UnknownText_0x1c58e0
	db "@"
; 0x8b086

UnknownText_0x8b086: ; 0x8b086
	; You have no room for it.
	text_jump UnknownText_0x1c58ff
	db "@"
; 0x8b08b

UnknownText_0x8b08b: ; 0x8b08b
	; Oh. Please come back again!
	text_jump UnknownText_0x1c591a
	db "@"
; 0x8b090

Function8b090: ; 8b090
	ld hl, MenuDataHeader_0x8b0d1
	call LoadMenuDataHeader
	ret
; 8b097

Function8b097: ; 8b097
	ld de, wBlueCardBalance
	call Function8b09e
	ret
; 8b09e

Function8b09e: ; 8b09e
	push de
	xor a
	ld [hBGMapMode], a
	ld hl, MenuDataHeader_0x8b0d1
	call Function1d3c
	call Function1cbb
	call Function1ad2
	call Function1cfd ;hl = curmenu start location in tilemap
	ld bc, $0015
	add hl, bc
	ld de, String_8b0ca
	call PlaceString
	ld h, b
	ld l, c
	inc hl
	ld a, $7f
	ld [hli], a
	ld [hld], a
	pop de
	ld bc, $0102
	call PrintNum
	ret
; 8b0ca

String_8b0ca:
	db "Points@"
; 8b0d1

MenuDataHeader_0x8b0d1: ; 0x8b0d1
	db $40 ; flags
	db 11, 00 ; start coords
	db 13, 11 ; end coords
; 8b0d6

Function8b0d6: ; 8b0d6
	ld hl, MenuDataHeader_0x8b0dd
	call LoadMenuDataHeader
	ret
; 8b0dd

MenuDataHeader_0x8b0dd: ; 0x8b0dd
	db $40 ; flags
	db 00, 00 ; start coords
	db 11, 17 ; end coords
; 8b0e2

Function8b0e2: ; 8b0e2
	ld hl, MenuDataHeader_0x8b113
	call Function1d3c
	ld a, [MenuSelection]
	ld [wcf88], a
	xor a
	ld [wcf76], a
	ld [hBGMapMode], a
	call Function352f
	call Function1ad2
	call Function350c
	ld a, [MenuSelection]
	ld c, a
	ld a, [wcfa9]
	ld [MenuSelection], a
	ld a, [wcf73]
	cp $2
	jr z, .asm_8b111
	ld a, c
	and a
	ret nz
.asm_8b111
	xor a
	ret
; 8b113

MenuDataHeader_0x8b113: ; 0x8b113
	db $40 ; flags
	db 01, 01 ; start coords
	db 09, 16 ; end coords
	dw MenuData2_0x8b11c
	db 1 ; default option
; 0x8b11b

	db 0
MenuData2_0x8b11c: ; 0x8b11c
	db $10 ; flags
	db 4 ; items
	db $d, $1
	dbw BANK(Unknown_8b129), Unknown_8b129
	dbw BANK(BuenaPrizeItem), BuenaPrizeItem
	dbw BANK(BuenaPrizePoints), BuenaPrizePoints
; 8b129

Unknown_8b129: ; 8b129
	db 9
	db 1, 2, 3, 4, 5, 6, 7, 8, 9, $ff
; 8b134

BuenaPrizeItem: ; 8b134
	ld a, [MenuSelection]
	call GetBuenaPrize
	ld a, [hl]
	push de
	ld [wd265], a
	call GetItemName
	pop hl
	call PlaceString
	ret
; 8b147

BuenaPrizePoints: ; 8b147
	ld a, [MenuSelection]
	call GetBuenaPrize
	inc hl
	ld a, [hl]
	ld c, "0"
	add c
	ld [de], a
	ret
; 8b154

GetBuenaPrize: ; 8b154
	dec a
	ld hl, BuenaPrizes
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	ret
; 8b15e

BuenaPrizes: ; 8b15e
	db ULTRA_BALL,   2
	db FULL_RESTORE, 2
	db NUGGET,       3
	db RARE_CANDY,   3
	db PROTEIN,      5
	db IRON,         5
	db CARBOS,       5
	db CALCIUM,      5
	db HP_UP,        5
; 8b170

INCLUDE "event/dratini.asm"

Function8b1e1: ; 8b1e1
	ld de, Unknown_8b1ed
	call Function8b25b
	ret z
	call Function8b231
	scf
	ret
; 8b1ed

Unknown_8b1ed: ; 8b1ed
	db 2
	dw Unknown_8b1f2
	dw Unknown_8b1f6

Unknown_8b1f2: ; 8b1f2
	dw Function8b2bb
	dw Function8b2c1
; 8b1f6

Unknown_8b1f6: ; 8b1f6
	dw UnknownText_0x8b1fc
	dw UnknownText_0x8b23d
	dw UnknownText_0x8b242
; 8b1fc

UnknownText_0x8b1fc: ; 0x8b1fc
	; Excuse me!
	text_jump UnknownText_0x1c5937
	db "@"
; 0x8b201

Function8b201: ; 8b201 ;check if possible to enter, display fail text and ret c otherwise. made redundent
	;ld hl, StringBuffer2
	;ld [hl], "3"
	;inc hl
	;ld [hl], "@"
	;ld de, Unknown_8b215 ;load 3 into string buffer2 and checks table into de
	;call Function8b25b
	;ret z ;ret if still ok to go in
	;call Function8b231 ;please return when you're ready
	;scf
	ret
; 8b215

Unknown_8b215: ; 8b215
	;db 4
	;dw Unknown_8b21a
	;dw Unknown_8b222


Unknown_8b21a: ; 8b21a ;fail checks
	;dw Function8b2da ;if party not 3 members REMOVED
	;dw Function8b2e2 ;check for species REMOVED
	;dw Function8b32a ;check for items REMOVED
	;dw Function8b331 ;check for eggs REMOVED

; 8b222

Unknown_8b222: ; 8b222 ;fail messages
	;dw UnknownText_0x8b22c
	;dw UnknownText_0x8b247
	;dw UnknownText_0x8b24c
	;dw UnknownText_0x8b251
	;dw UnknownText_0x8b256

; 8b22c

UnknownText_0x8b22c: ; 0x8b22c
	; Excuse me. You're not ready.
	;text_jump UnknownText_0x1c5944
	;db "@"
; 0x8b231

Function8b231: ; 8b231
	ld hl, UnknownText_0x8b238
	call PrintText
	ret
; 8b238

UnknownText_0x8b238: ; 0x8b238
	; Please return when you're ready.
	text_jump UnknownText_0x1c5962
	db "@"
; 0x8b23d

UnknownText_0x8b23d: ; 0x8b23d
	; You need at least three #MON.
	text_jump UnknownText_0x1c5983
	db "@"
; 0x8b242

UnknownText_0x8b242: ; 0x8b242
	; Sorry, an EGG doesn't qualify.
	text_jump UnknownText_0x1c59a3
	db "@"
; 0x8b247

UnknownText_0x8b247: ; 0x8b247
	; Only three #MON may be entered.
	;text_jump UnknownText_0x1c59c3
	;db "@"
; 0x8b24c

UnknownText_0x8b24c: ; 0x8b24c
	; The @  #MON must all be different kinds.
	;text_jump UnknownText_0x1c59e5
	;db "@"
; 0x8b251

UnknownText_0x8b251: ; 0x8b251
	; The @  #MON must not hold the same items.
	;text_jump UnknownText_0x1c5a13
;	db "@"
; 0x8b256

UnknownText_0x8b256: ; 0x8b256
	; You can't take an EGG!
;	text_jump UnknownText_0x1c5a42
;	db "@"
; 0x8b25b

Function8b25b: ; 8b25b
	ld bc, $0000
.asm_8b25e
	call Function8b26c ;if can't enter, ret c
	call c, Function8b28e ;print why can't enter, b = 1 to fail
	call Function8b276 ;inc c, load de into a, loop [de] times
	jr nz, .asm_8b25e ;loop [de] times
	ld a, b
	and a
	ret
; 8b26c

Function8b26c: ; 8b26c
	push de
	push bc
	call Function8b27a ;hl = contents of de+1
	ld a, c ;run place c of that table
	rst JumpTable
	pop bc
	pop de
	ret
; 8b276

Function8b276: ; 8b276
	inc c
	ld a, [de]
	cp c
	ret
; 8b27a

Function8b27a: ; 8b27a hl = contents of de+1
	inc de
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	ret
; 8b281

Function8b281: ; 8b281
	inc de
	inc de
	inc de
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	ret
; 8b28a

Function8b28a: ; 8b28a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 8b28e

Function8b28e: ; 8b28e print fail to enter text
	push de
	push bc
	ld a, b
	and a
	call z, Function8b29d ;if b = 0, print not ready text
	pop bc
	call Function8b2a9 ;print text c+1
	ld b, $1
	pop de
	ret
; 8b29d

Function8b29d: ; 8b29d print not ready text
	push de
	call Function8b281 ;hl = second row of de (text list)
	call Function8b28a ;hl = contents of hl
	call PrintText ;
	pop de
	ret
; 8b2a9

Function8b2a9: ; 8b2a9 print text c+1
	push bc
	call Function8b281 ;hl = second row of de (text list)
	inc hl
	inc hl
	ld b, $0 ;text c + 1
	add hl, bc
	add hl, bc
	call Function8b28a ;hl = contents of hl
	call PrintText
	pop bc
	ret
; 8b2bb

Function8b2bb: ; 8b2bb
	ld a, [PartyCount]
	cp 3
	ret
; 8b2c1

Function8b2c1: ; 8b2c1
	ld hl, PartyCount
	ld a, [hli]
	ld b, $0
	ld c, a
.asm_8b2c8
	ld a, [hli]
	cp EGG
	jr z, .asm_8b2ce
	inc b
.asm_8b2ce
	dec c
	jr nz, .asm_8b2c8
	ld a, [PartyCount]
	cp b
	ret z
	ld a, b
	cp 3
	ret
; 8b2da

Function8b2da: ; 8b2da
	;ld a, [PartyCount]
	;cp 3 removed as now scales to partycount
	;ret z
	;scf
	ret
; 8b2e2

Function8b2e2: ; 8b2e2
	;ld hl, PartyMon1Species unneded
	;call Function8b2e9 ;check if party has all different species, if they don't ret c
	ret
; 8b2e9

Function8b2e9: ; 8b2e9 ;check if party has all different versions of what's pointed to by hl, if they don't ret c. made redundent
;	ld de, PartyCount
;	ld a, [de]
;	inc de
;	dec a
;	jr z, .asm_8b314 ;if party size = 1, all clear
;	ld b, a
.asm_8b2f2
;	push hl
;	push de
;	ld c, b ;c = mons below
;	call Function8b322 ;if [de] = egg, skip
;	jr z, .asm_8b30c
;	ld a, [hl]
;	and a
;	jr z, .asm_8b30c ;if hl = 0, skip
.asm_8b2fe
;	call Function8b31a ;go down 1 mon in hl, inc de
;	call Function8b322 ;if [de] = egg, skip
;	jr z, .asm_8b309
;	cp [hl]
;	jr z, .asm_8b316 ;if they match, ret c

.asm_8b309
;	dec c ;loop for each mon after
;	jr nz, .asm_8b2fe
.asm_8b30c
;	pop de
;	pop hl
;	call Function8b31a
;	dec b ;b becomes c for inner loop
;	jr nz, .asm_8b2f2 ;loop for each mon

.asm_8b314
;	and a
;	ret

.asm_8b316

;	pop de
;	pop hl
;	scf
;	ret

; 8b31a

Function8b31a: ; 8b31a redundent due to other changes
;	push bc
;	ld bc, PartyMon2 - PartyMon1
;	add hl, bc ;go down 1 mon in hl, inc de
;	inc de
;	pop bc
	ret
; 8b322

Function8b322: ; 8b322
	push bc
	ld b, a
	ld a, [de]
	cp EGG
	ld a, b
	pop bc
	ret
; 8b32a

Function8b32a: ; 8b32a
	;ld hl, PartyMon1Item ;removed
	;call Function8b2e9 ;check if party has all different items, if they don't ret c
	ret
; 8b331

Function8b331: ; 8b331
;	ld hl, PartyCount
;	ld a, [hli]
;	ld c, a
.asm_8b336
;	ld a, [hli]
;	cp EGG
;	jr z, .asm_8b340 ;if egg, ret c
;	dec c
;	jr nz, .asm_8b336
;	and a
;	ret

.asm_8b340
;	scf
	ret
; 8b342

Function8b342:: ; 8b342
	call GetSecondaryMapHeaderPointer
	ld d, h
	ld e, l
	xor a
.asm_8b348
	push af
	ld hl, Jumptable_8b354
	rst JumpTable
	pop af
	inc a
	cp 3
	jr nz, .asm_8b348
	ret
; 8b354

Jumptable_8b354: ; 8b354
	dw Function8b35a
	dw Function8b35b
	dw Function8b35c
; 8b35a

Function8b35a: ; 8b35a
	ret
; 8b35b

Function8b35b: ; 8b35b
	ret
; 8b35c

Function8b35c: ; 8b35c
	ret
; 8b35d

Function8b35d: ; 8b35d
	ld a, h
	cp d
	ret nz
	ld a, l
	cp e
	ret
; 8b363

Function8b363: ; 8b363
	push bc
	callba Function10632f
	pop bc
	ret
; 8b36c

Function8b36c: ; 8b36c (22:736c)
	push bc
	ld h, b
	ld l, c
	ld bc, $4
	ld a, $ff
	call ByteFill
	pop bc
	ret

Function8b379: ; 8b379 (22:7379)
	push bc
	ld a, c
	add e
	ld c, a
	ld a, $0
	adc b
	ld b, a
	ld a, [bc]
	ld d, a
	pop bc
	ret

Function8b385: ; 8b385 (22:7385)
	push bc
	ld a, c
	add e
	ld c, a
	ld a, $0
	adc b
	ld b, a
	ld a, d
	ld [bc], a
	pop bc
	ret

Function8b391: ; 8b391 (22:7391)
	push bc
	ld e, $0
	ld d, $4
.asm_8b396
	ld a, [bc]
	inc bc
	cp $ff
	jr z, .asm_8b3a2
	inc e
	dec d
	jr nz, .asm_8b396
	dec e
	scf
.asm_8b3a2
	pop bc
	ret

Function8b3a4: ; 8b3a4 (22:73a4)
	push de
	push bc
	ld d, b
	ld e, c
	ld c, $4
	call Function89185
	pop bc
	pop de
	ret

Function8b3b0: ; 8b3b0 (22:73b0)
	ld bc, $a037
	ld a, [$a60b]
	and a
	jr z, .asm_8b3c2
	cp $3
	jr nc, .asm_8b3c2
	call Function8b391
	jr c, .asm_8b3c9
.asm_8b3c2
	call Function8b36c
	xor a
	ld [$a60b], a
.asm_8b3c9
	ld a, [$a60b]
	ret

Function8b3cd: ; 8b3cd (22:73cd)
	push de
	push bc
	ld e, $4
.asm_8b3d1
	ld a, [bc]
	inc bc
	call Function8998b
	inc hl
	dec e
	jr nz, .asm_8b3d1
	pop bc
	pop de
	ret

Function8b3dd: ; 8b3dd (22:73dd)
	push de
	push bc
	call Function354b
	ld a, c
	pop bc
	pop de
	bit 0, a
	jr nz, .asm_8b3f7
	bit 1, a
	jr nz, .asm_8b40e
	bit 6, a
	jr nz, .asm_8b429
	bit 7, a
	jr nz, .asm_8b443
	and a
	ret

.asm_8b3f7
	ld a, e
	cp $3
	jr z, .asm_8b407
	inc e
	ld d, $0
	call Function8b385
	xor a
	ld [wd010], a
	ret

.asm_8b407
	call PlayClickSFX
	ld d, $0
	scf
	ret

.asm_8b40e
	ld a, e
	and a
	jr nz, .asm_8b41e
	call PlayClickSFX
	ld d, $ff
	call Function8b385
	ld d, $1
	scf
	ret

.asm_8b41e
	ld d, $ff
	call Function8b385
	dec e
	xor a
	ld [wd010], a
	ret

.asm_8b429
	call Function8b379
	ld a, d
	cp $a
	jr c, .asm_8b433
	ld d, $9
.asm_8b433
	inc d
	ld a, d
	cp $a
	jr c, .asm_8b43b
	ld d, $0
.asm_8b43b
	call Function8b385
	xor a
	ld [wd010], a
	ret

.asm_8b443
	call Function8b379
	ld a, d
	cp $a
	jr c, .asm_8b44d
	ld d, $0
.asm_8b44d
	ld a, d
	dec d
	and a
	jr nz, .asm_8b454
	ld d, $9
.asm_8b454
	call Function8b385
	xor a
	ld [wd010], a
	ret

Function8b45c: ; 8b45c (22:745c)
	call Function8b36c
	xor a
	ld [wd010], a
	ld [wd012], a
	call Function8b391
	ld d, $0
	call Function8b385
.asm_8b46e
	call Function8923c
	call Function8b493
	call Function8b4cc
	call Function8b518
	call Function89b78
	push bc
	call Function8b4fd
	call Function89c44
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	pop bc
	call Function8b3dd
	jr nc, .asm_8b46e
	ld a, d
	and a
	ret z
	scf
	ret

Function8b493: ; 8b493 (22:7493)
	push bc
	call Function8923c
	call Function8b521
	ld hl, Jumptable_8b4a0
	pop bc
	rst JumpTable
	ret

Jumptable_8b4a0: ; 8b4a0 (22:74a0)
	dw Function8b4a4
	dw Function8b4b8

Function8b4a4: ; 8b4a4 (22:74a4)
	push bc
	push de
	call Function8b4d8
	call TextBox
	pop de
	pop bc
	call Function8b4cc
	call Function8b518
	call Function8b3cd
	ret

Function8b4b8: ; 8b4b8 (22:74b8)
	push bc
	push de
	call Function8b4ea
	call Function89b3b
	pop de
	pop bc
	call Function8b4cc
	call Function8b518
	call Function8b3cd
	ret

Function8b4cc: ; 8b4cc (22:74cc)
	push bc
	ld hl, Unknown_8b529
	call Function8b50a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ret

Function8b4d8: ; 8b4d8 (22:74d8)
	ld hl, Unknown_8b529
	call Function8b50a
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Function8b4ea: ; 8b4ea (22:74ea)
	ld hl, Unknown_8b529
	call Function8b50a
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ret

Function8b4fd: ; 8b4fd (22:74fd)
	ld hl, Unknown_8b529 + 4
	call Function8b50a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld d, a
	ret

Function8b50a: ; 8b50a (22:750a)
	ld a, [wd02e]
	and a
	ret z
	ld b, $0
	ld c, $8
.asm_8b513
	add hl, bc
	dec a
	jr nz, .asm_8b513
	ret

Function8b518: ; 8b518 (22:7518)
	push de
	ld d, $0
	ld e, $14
	add hl, de
	inc hl
	pop de
	ret

Function8b521: ; 8b521 (22:7521)
	ld hl, Unknown_8b529 + 7
	call Function8b50a
	ld a, [hl]
	ret
; 8b529 (22:7529)

Unknown_8b529: ; 8b529
	dwcoord 2, 5
	db 1, 4, $20, $49, 0, 1
	dwcoord 7, 4
	db 1, 4, $48, $41, 0, 0
; 8b539

Function8b539: ; 8b539 (22:7539)
	ld bc, wd017
	call Function8b36c
	xor a
	ld [wd012], a
	ld [wd02e], a
	call Function8b493
	call Function8b4fd
	ld e, $0
	call Function89c44
	call Function3238
	ret

Function8b555: ; 8b555 (22:7555)
	ld hl, UnknownText_0x8b5ce
	call PrintText
	ld bc, wd017
	call Function8b45c
	jr c, .asm_8b5c8
	call Function89448
	ld bc, wd017
	call Function8b493
	ld bc, wd017
	call Function8b664
	jr nz, .asm_8b57c
	ld hl, UnknownText_0x8b5e2
	call PrintText
	jr Function8b555

.asm_8b57c
	ld hl, UnknownText_0x8b5d3
	call PrintText
	ld bc, wd013
	call Function8b45c
	jr c, Function8b555
	ld bc, wd017
	ld hl, wd013
	call Function8b3a4
	jr z, .asm_8b5a6
	call Function89448
	ld bc, wd013
	call Function8b493
	ld hl, UnknownText_0x8b5d8
	call PrintText
	jr .asm_8b57c

.asm_8b5a6
	call Function89160
	ld hl, wd013
	ld de, $a037
	ld bc, $4
	call CopyBytes
	call CloseSRAM
	call Function89448
	ld bc, wd013
	call Function8b493
	ld hl, UnknownText_0x8b5dd
	call PrintText
	and a
.asm_8b5c8
	push af
	call Function89448
	pop af
	ret
; 8b5ce (22:75ce)

UnknownText_0x8b5ce: ; 0x8b5ce
	; Please enter any four-digit number.
	text_jump UnknownText_0x1bc187
	db "@"
; 0x8b5d3

UnknownText_0x8b5d3: ; 0x8b5d3
	; Enter the same number to confirm.
	text_jump UnknownText_0x1bc1ac
	db "@"
; 0x8b5d8

UnknownText_0x8b5d8: ; 0x8b5d8
	; That's not the same number.
	text_jump UnknownText_0x1bc1cf
	db "@"
; 0x8b5dd

UnknownText_0x8b5dd: ; 0x8b5dd
	; Your PASSCODE has been set. Enter this number next time to open the CARD FOLDER.
	text_jump UnknownText_0x1bc1eb
	db "@"
; 0x8b5e2

UnknownText_0x8b5e2: ; 0x8b5e2
	; 0000 is invalid!
	text_jump UnknownText_0x1bc23e
	db "@"
; 0x8b5e7

Function8b5e7: ; 8b5e7 (22:75e7)
	ld bc, wd013
	call Function8b36c
	xor a
	ld [wd012], a
	ld [wd02e], a
	call Function8b493
	call Function891ab
	call Function8b4fd
	ld e, $0
	call Function89c44
.asm_8b602
	ld hl, UnknownText_0x8b642
	call PrintText
	ld bc, wd013
	call Function8b45c
	jr c, .asm_8b63c
	call Function89448
	ld bc, wd013
	call Function8b493
	call Function89160
	ld hl, $a037
	call Function8b3a4
	call CloseSRAM
	jr z, .asm_8b635
	ld hl, UnknownText_0x8b647
	call PrintText
	ld bc, wd013
	call Function8b36c
	jr .asm_8b602

.asm_8b635
	ld hl, UnknownText_0x8b64c
	call PrintText
	and a
.asm_8b63c
	push af
	call Function89448
	pop af
	ret
; 8b642 (22:7642)

UnknownText_0x8b642: ; 0x8b642
	; Enter the CARD FOLDER PASSCODE.
	text_jump UnknownText_0x1bc251
	db "@"
; 0x8b647

UnknownText_0x8b647: ; 0x8b647
	; Incorrect PASSCODE!
	text_jump UnknownText_0x1bc272
	db "@"
; 0x8b64c

UnknownText_0x8b64c: ; 0x8b64c
	; CARD FOLDER open.@ @
	text_jump UnknownText_0x1bc288
	start_asm
; 0x8b651

Function8b651: ; 8b651
	ld de, SFX_TWINKLE
	call PlaySFX
	call WaitSFX
	ld c, $8
	call DelayFrames
	ld hl, .string_8b663
	ret

.string_8b663
	db "@"
; 8b664

Function8b664: ; 8b664 (22:7664)
	push bc
	ld de, $4
.asm_8b668
	ld a, [bc]
	cp $0
	jr nz, .asm_8b66e
	inc d
.asm_8b66e
	inc bc
	dec e
	jr nz, .asm_8b668
	pop bc
	ld a, d
	cp $4
	ret

Function8b677: ; 8b677
	call WhiteBGMap
	call DisableLCD
	call Function8b690
	call Function8b6bb
	call Function8b6ed
	call EnableLCD
	call Function891ab
	call Function32f9
	ret
; 8b690

Function8b690: ; 8b690
	ld hl, GFX_17afa5 + $514
	ld de, VTiles2
	ld bc, $160
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ld hl, GFX_17afa5 + $514 + $160 - $10
	ld de, $9610
	ld bc, $10
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ld hl, GFX_17afa5 + $514 + $160
	ld de, $8ee0
	ld bc, $10
	ld a, BANK(GFX_17afa5)
	call FarCopyBytes
	ret
; 8b6bb

Function8b6bb: ; 8b6bb
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Palette_8b6d5
	ld de, Unkn1Pals
	ld bc, $0018
	call CopyBytes
	pop af
	ld [rSVBK], a
	call Function8949c
	ret
; 8b6d5

Palette_8b6d5: ; 8b6d5
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 14, 07, 03
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 22, 09, 17
	RGB 00, 00, 00
	RGB 31, 31, 31
	RGB 31, 21, 00
	RGB 06, 24, 08
	RGB 00, 00, 00
; 8b6ed

Function8b6ed: ; 8b6ed
	hlcoord 0, 0, AttrMap
	ld bc, $012c
	xor a
	call ByteFill
	hlcoord 0, 14, AttrMap
	ld bc, $0050
	ld a, $7
	call ByteFill
	ret
; 8b703

Function8b703: ; 8b703
	call Function8923c
	push hl
	ld a, $c
	ld [hli], a
	inc a
	call Function8b73e
	inc a
	ld [hl], a
	pop hl
	push hl
	push bc
	ld de, $0014
	add hl, de
.asm_8b717
	push hl
	ld a, $f
	ld [hli], a
	ld a, $7f
	call Function8b73e
	ld a, $11
	ld [hl], a
	pop hl
	ld de, $0014
	add hl, de
	dec b
	jr nz, .asm_8b717
	call Function8b732
	pop bc
	pop hl
	jr Function8b744
; 8b732

Function8b732: ; 8b732
	ld a, $12
	ld [hli], a
	ld a, $13
	call Function8b73e
	ld a, $14
	ld [hl], a
	ret
; 8b73e

Function8b73e: ; 8b73e
	ld d, c
.asm_8b73f
	ld [hli], a
	dec d
	jr nz, .asm_8b73f
	ret
; 8b744

Function8b744: ; 8b744
	ld de, AttrMap - TileMap
	add hl, de
	inc b
	inc b
	inc c
	inc c
	xor a
.asm_8b74d
	push bc
	push hl
.asm_8b74f
	ld [hli], a
	dec c
	jr nz, .asm_8b74f
	pop hl
	ld de, $0014
	add hl, de
	pop bc
	dec b
	jr nz, .asm_8b74d
	ret
; 8b75d

Function8b75d: ; 8b75d
	call Function8923c
	hlcoord 0, 0
	ld a, $1
	ld bc, $0014
	call ByteFill
	hlcoord 0, 1
	ld a, $2
	ld [hl], a
	hlcoord 9, 1
	ld c, $b
	call Function8b788
	hlcoord 1, 1
	ld a, $4
	ld e, $8
.asm_8b780
	ld [hli], a
	inc a
	dec e
	jr nz, .asm_8b780
	jr Function8b79e
; 8b787

Function8b787: ; 8b787
	ret
; 8b788

Function8b788: ; 8b788
.asm_8b788
	ld a, $2
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	ret z
	ld a, $3
	ld [hli], a
	dec c
	ret z
	ld a, $1
	ld [hli], a
	dec c
	jr nz, .asm_8b788
	ret
; 8b79e

Function8b79e: ; 8b79e
	hlcoord 0, 1, AttrMap
	ld a, $1
	ld [hli], a
	hlcoord 9, 1, AttrMap
	ld e, $b
.asm_8b7a9
	ld a, $2
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	ret z
	ld a, $1
	ld [hli], a
	dec e
	ret z
	xor a
	ld [hli], a
	dec e
	jr nz, .asm_8b7a9
	ret
; 8b7bd

Function8b7bd: ; 8b7bd
	call Function8b855
	ld hl, MenuDataHeader_0x8b867
	call Function1d3c
	ld a, [wd030]
	ld [wcf88], a
	ld a, [wd031]
	ld [wd0e4], a
	ld a, [wd032]
	and a
	jr z, .asm_8b7e0
	ld a, [wcf81]
	set 3, a
	ld [wcf81], a
.asm_8b7e0
	ld a, [wd0e3]
	and a
	jr z, .asm_8b7ea
	dec a
	ld [wcf77], a
.asm_8b7ea
	hlcoord 0, 2
	ld b, $b
	ld c, $12
	call Function8b703
	call Function8b75d
	call Function1ad2
	call Function89209
	call Function350c
	call Function8920f
	ld a, [wcf73]
	cp $2
	jr z, .asm_8b823
	cp $20
	jr nz, .asm_8b813
	call Function8b832
	jr .asm_8b7ea

.asm_8b813
	cp $10
	jr nz, .asm_8b81c
	call Function8b83e
	jr .asm_8b7ea

.asm_8b81c
	ld a, [MenuSelection]
	cp $ff
	jr nz, .asm_8b824
.asm_8b823
	xor a
.asm_8b824
	ld c, a
	ld a, [wcfa9]
	ld [wd030], a
	ld a, [wd0e4]
	ld [wd031], a
	ret
; 8b832

Function8b832: ; 8b832
	ld a, [wd0e4]
	ld hl, wcf92
	sub [hl]
	jr nc, Function8b84b
	xor a
	jr Function8b84b
; 8b83e

Function8b83e: ; 8b83e
	ld a, [wd0e4]
	ld hl, wcf92
	add [hl]
	cp $24
	jr c, Function8b84b
	ld a, $24
Function8b84b: ; 8b84b
	ld [wd0e4], a
	ld a, [wcfa9]
	ld [wcf88], a
	ret
; 8b855

Function8b855: ; 8b855
	ld a, $28
	ld hl, DefaultFlypoint
	ld [hli], a
	ld c, $28
	xor a
.asm_8b85e
	inc a
	ld [hli], a
	dec c
	jr nz, .asm_8b85e
	ld a, $ff
	ld [hl], a
	ret
; 8b867

MenuDataHeader_0x8b867: ; 0x8b867
	db $40 ; flags
	db 03, 01 ; start coords
	db 13, 18 ; end coords
	dw MenuData2_0x8b870
	db 1 ; default option
; 0x8b86f

	db 0
MenuData2_0x8b870: ; 0x8b870
	db $3c ; flags
	db 5 ; items
	db 3, 1
	dbw 0, wd002
	dbw BANK(Function8b880), Function8b880
	dbw BANK(Function8b88c), Function8b88c
	dbw BANK(Function8b8c8), Function8b8c8
; 8b880

Function8b880: ; 8b880
	ld h, d
	ld l, e
	ld de, MenuSelection
	ld bc, $8102
	call PrintNum
	ret
; 8b88c

Function8b88c: ; 8b88c
	call Function89160
	ld h, d
	ld l, e
	push hl
	ld de, String_89116
	call Function8931b
	call Function8932d
	jr c, .asm_8b8a3
	ld hl, $0000
	add hl, bc
	ld d, h
	ld e, l
.asm_8b8a3
	pop hl
	push hl
	call PlaceString
	pop hl
	ld d, $0
	ld e, $6
	add hl, de
	push hl
	ld de, String_89116
	call Function8931b
	call Function8934a
	jr c, .asm_8b8c0
	ld hl, $0006
	add hl, bc
	ld d, h
	ld e, l
.asm_8b8c0
	pop hl
	call PlaceString
	call CloseSRAM
	ret
; 8b8c8

Function8b8c8: ; 8b8c8
	hlcoord 0, 14
	ld b, $2
	ld c, $12
	call TextBox
	ld a, [wd033]
	ld b, 0
	ld c, a
	ld hl, Unknown_8b903
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	hlcoord 1, 16
	call PlaceString
	hlcoord 0, 13
	ld a, $f
	ld [hl], a
	hlcoord 19, 13
	ld a, $11
	ld [hl], a
	ld a, [wd0e4]
	cp $24
	ret c
	hlcoord 0, 13
	ld c, $12
	call Function8b732
	ret
; 8b903

Unknown_8b903: ; 8b903
	dw String_8b90b
	dw String_8b919
	dw String_8b92a
	dw String_8b938

String_8b90b: db "めいしを えらんでください@"        ; Please select a noun.
String_8b919: db "どの めいしと いれかえますか?@"    ; OK to swap with any noun?
String_8b92a: db "あいてを えらんでください@"        ; Please select an opponent.
String_8b938: db "いれる ところを えらんでください@" ; Please select a location.
; 8b94a

Function8b94a: ; 8b94a
	ld [wd033], a
	xor a
	ld [wd0e4], a
	ld [wd032], a
	ld [wd0e3], a
	ld [wd031], a
	ld a, $1
	ld [wd030], a
	ret
; 8b960

Function8b960: ; 8b960 (22:7960)
	ld hl, MenuDataHeader_0x8b9ac
	call LoadMenuDataHeader
	call Function8b9e9
	jr c, .asm_8b97a
	hlcoord 11, 0
	ld b, $6
	ld c, $7
	call Function8b703
	ld hl, MenuDataHeader_0x8b9b1
	jr .asm_8b987

.asm_8b97a
	hlcoord 11, 0
	ld b, $a
	ld c, $7
	call Function8b703
	ld hl, MenuDataHeader_0x8b9ca
.asm_8b987
	ld a, $1
	call Function89d5e
	ld hl, Function8b9ab
	call Function89d85
	call Function1c07 ;unload top menu on menu stack
	jr c, .asm_8b99c
	call Function8b99f
	jr nz, .asm_8b99d
.asm_8b99c
	xor a
.asm_8b99d
	ld c, a
	ret

Function8b99f: ; 8b99f (22:799f)
	ld hl, DefaultFlypoint
	dec a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	cp $ff
	ret
; 8b9ab (22:79ab)

Function8b9ab: ; 8b9ab
	ret
; 8b9ac

MenuDataHeader_0x8b9ac: ; 0x8b9ac
	db $40 ; flags
	db 00, 11 ; start coords
	db 11, 19 ; end coords
MenuDataHeader_0x8b9b1: ; 0x8b9b1
	db $40 ; flags
	db 00, 11 ; start coords
	db 07, 19 ; end coords
	dw MenuData2_0x8b9b9
	db 1 ; default option
; 0x8b9b9

MenuData2_0x8b9b9: ; 0x8b9b9
	db $a0 ; flags
	db 3 ; items
	db "へんしゅう@" ; EDIT
	db "いれかえ@"   ; REPLACE
	db "やめる@"     ; QUIT
; 0x8b9ca

MenuDataHeader_0x8b9ca: ; 0x8b9ca
	db $40 ; flags
	db 00, 11 ; start coords
	db 11, 19 ; end coords
	dw MenuData2_0x8b9d2
	db 1 ; default option
; 0x8b9d2

MenuData2_0x8b9d2: ; 0x8b9d2
	db $a0 ; flags
	db 5 ; items
	db "みる@"       ; VIEW
	db "へんしゅう@" ; EDIT
	db "いれかえ@"   ; REPLACE
	db "けす@"       ; ERASE
	db "やめる@"     ; QUIT
; 0x8b9e9

Function8b9e9: ; 8b9e9 (22:79e9)
	call Function89160
	call Function8931b
	call Function8932d
	jr nc, .asm_8b9f6
	jr .asm_8b9ff

.asm_8b9f6
	ld hl, $11
	add hl, bc
	call Function89b45
	jr c, .asm_8ba08
.asm_8b9ff
	call Function892b4
	and a
	ld de, Unknown_8ba1c
	jr .asm_8ba0c

.asm_8ba08
	ld de, Unknown_8ba1f
	scf
.asm_8ba0c
	push af
	ld hl, DefaultFlypoint
.asm_8ba10
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, .asm_8ba10
	call CloseSRAM
	pop af
	ret
; 8ba1c (22:7a1c)

Unknown_8ba1c: ; 8b1ac
	db 2, 4, -1
Unknown_8ba1f: ; 8ba1f
	db 1, 2, 4, 3, -1
; 8ba24

SECTION "bank23", ROMX, BANK[$23]

Function8c000: ; 8c000
Function8c000_2:
	ret
; 8c001

Function8c001:: ; 8c001
	call UpdateTime
	ld a, [TimeOfDay]
	ld [CurTimeOfDay], a
	call GetTimePalette
	ld [TimeOfDayPal], a
	ret
; 8c011

_TimeOfDayPals:: ; 8c011
; return carry if pals are changed
; forced pals?

	ld hl, wd846
	bit 7, [hl]
	jr nz, .dontchange

; do we need to bother updating?

	ld a, [TimeOfDay]
	ld hl, CurTimeOfDay
	cp [hl]
	jr z, .dontchange

; if so, the time of day has changed

	ld a, [TimeOfDay]
	ld [CurTimeOfDay], a

; get palette id

	call GetTimePalette

; same palette as before?

	ld hl, TimeOfDayPal
	cp [hl]
	jr z, .dontchange

; update palette id

	ld [TimeOfDayPal], a


; save bg palette 8

	ld hl, Unkn1Pals + 8 * 7 ; Unkn1Pals + 7 pals

; save wram bank

	ld a, [rSVBK]
	ld b, a
; wram bank 5

	ld a, 5
	ld [rSVBK], a

; push palette

	ld c, 4 ; NUM_PAL_COLORS
.push
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	push de
	dec c
	jr nz, .push

; restore wram bank

	ld a, b
	ld [rSVBK], a


; update sgb pals

	ld b, $9
	call GetSGBLayout


; restore bg palette 8

	ld hl, wd03f ; last byte in Unkn1Pals

; save wram bank

	ld a, [rSVBK]
	ld d, a
; wram bank 5

	ld a, 5
	ld [rSVBK], a

; pop palette

	ld e, 4 ; NUM_PAL_COLORS
.pop
	pop bc
	ld [hl], c
	dec hl
	ld [hl], b
	dec hl
	dec e
	jr nz, .pop

; restore wram bank

	ld a, d
	ld [rSVBK], a

; update palettes

	call _UpdateTimePals
	call DelayFrame

; successful change

	scf
	ret

.dontchange
; no change occurred

	and a
	ret
; 8c070

_UpdateTimePals:: ; 8c070
	ld c, $9 ; normal
	call GetTimePalFade
	call DmgToCgbTimePals
	ret
; 8c079

Function8c079:: ; 8c079
	ld c, $12
	call GetTimePalFade
	ld b, $4
	call Function8c16d
	ret
; 8c084

Function8c084:: ; 8c084
	call Function8c0c1
	ld c, $9
	call GetTimePalFade
	ld b, $4
	call Function8c15e
	ret
; 8c092

Function8c092: ; 8c092
	call Function8c0c1
	ld c, $9
	call GetTimePalFade
	ld b, $4
.asm_8c09c
	call DmgToCgbTimePals
	inc hl
	inc hl
	inc hl
	ld c, $7
	call DelayFrames
	dec b
	jr nz, .asm_8c09c
	ret
; 8c0ab

Function8c0ab: ; 8c0ab
	ld c, $0
	call GetTimePalFade ;set HL to location of ???
	ld b, $4
	call Function8c15e
	ret
; 8c0b6

Special_FadeToBlack: ; 8c0b6
	ld c, $9
	call GetTimePalFade
	ld b, $4
	call Function8c16d
	ret
; 8c0c1

Function8c0c1: ; 8c0c1
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Unkn1Pals
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, Unkn1Pals + 8
	ld c, $6
.asm_8c0d4
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .asm_8c0d4
	pop af
	ld [rSVBK], a
	ret
; 8c0e5

Function8c0e5: ; 8c0e5
	ld hl, Unknown_8c10f
	ld a, [wc2d0]
	cp $4
	jr z, .asm_8c0fc
	and $7
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
	ld a, [hl]
	ld [wd847], a
	ret

.asm_8c0fc
	ld a, [StatusFlags]
	bit 2, a
	jr nz, .asm_8c109
	ld a, $ff
	ld [wd847], a
	ret

.asm_8c109
	ld a, $aa
	ld [wd847], a
	ret
; 8c10f (23:410f)

Unknown_8c10f: ; 8c10f
	db $e4 ; 3210
	db $55 ; 1111
	db $aa ; 2222
	db $00 ; 0000
	db $ff ; 3333
	db $e4 ; 3210
	db $e4 ; 3210
	db $e4 ; 3210
; 8c117

GetTimePalette: ; 8c117
	ld a, [TimeOfDay]
	ld e, a
	ld d, 0
	ld hl, .TimePalettes
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8c126

.TimePalettes
	dw .MorningPalette
	dw .DayPalette
	dw .NitePalette
	dw .DarknessPalette

.MorningPalette
	ld a, [wd847]
	and %00000011 ; 0
	ret

.DayPalette
	ld a, [wd847]
	and %00001100 ; 1
	srl a
	srl a
	ret

.NitePalette
	ld a, [wd847]
	and %00110000 ; 2
	swap a
	ret

.DarknessPalette
	ld a, [wd847]
	and %11000000 ; 3
	rlca
	rlca
	ret
; 8c14e

DmgToCgbTimePals: ; 8c14e
	push hl
	push de
	ld a, [hli]
	call DmgToCgbBGPals ;a is put into rBGP, alot of pallet stuff if not gbc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call DmgToCgbObjPals
	pop de
	pop hl
	ret
; 8c15e

Function8c15e: ; 8c15e
.asm_8c15e
	call DmgToCgbTimePals
	inc hl
	inc hl
	inc hl
	ld c, $2
	call DelayFrames
	dec b
	jr nz, .asm_8c15e
	ret
; 8c16d

Function8c16d: ; 8c16d
.asm_8c16d
	call DmgToCgbTimePals
	dec hl
	dec hl
	dec hl
	ld c, $2
	call DelayFrames
	dec b
	jr nz, .asm_8c16d
	ret
; 8c17c

GetTimePalFade: ; 8c17c
; check cgb

	ld a, [hCGB]
	and a
	jr nz, .cgb

; else: dmg
; index

	ld a, [TimeOfDayPal]
	and %11 ; first 2 bits only, 0-3

; get fade table

	push bc
	ld c, a
	ld b, $0
	ld hl, .dmgfades
	add hl, bc
	add hl, bc
	ld a, [hli] ;load correct ToD table location into hl
	ld h, [hl]
	ld l, a
	pop bc

; get place in fade table

	ld b, $0
	add hl, bc
	ret

.cgb
	ld hl, .cgbfade
	ld b, $0
	add hl, bc
	ret

.dmgfades
	dw .morn
	dw .day
	dw .nite
	dw .darkness

.morn
	db %11111111, %11111111, %11111111
	db %11111110, %11111110, %11111110
	db %11111001, %11100100, %11100100
	db %11100100, %11010000, %11010000
	db %10010000, %10000000, %10000000
	db %01000000, %01000000, %01000000
	db %00000000, %00000000, %00000000
.day
	db %11111111, %11111111, %11111111
	db %11111110, %11111110, %11111110
	db %11111001, %11100100, %11100100
	db %11100100, %11010000, %11010000
	db %10010000, %10000000, %10000000
	db %01000000, %01000000, %01000000
	db %00000000, %00000000, %00000000
.nite
	db %11111111, %11111111, %11111111
	db %11111110, %11111110, %11111110
	db %11111001, %11100100, %11100100
	db %11101001, %11010000, %11010000
	db %10010000, %10000000, %10000000
	db %01000000, %01000000, %01000000
	db %00000000, %00000000, %00000000
.darkness
	db %11111111, %11111111, %11111111
	db %11111110, %11111110, %11111111
	db %11111110, %11100100, %11111111
	db %11111101, %11010000, %11111111
	db %11111101, %10000000, %11111111
	db %00000000, %01000000, %00000000
	db %00000000, %00000000, %00000000
.cgbfade
	db %11111111, %11111111, %11111111
	db %11111110, %11111110, %11111110
	db %11111001, %11111001, %11111001
	db %11100100, %11100100, %11100100
	db %10010000, %10010000, %10010000
	db %01000000, %01000000, %01000000
	db %00000000, %00000000, %00000000
; 8c20f

Function8c20f: ; 8c20f
	call Function8c26d
	ld a, [rBGP]
	ld [wcfc7], a
	ld a, [rOBP0]
	ld [wcfc8], a
	ld a, [rOBP1]
	ld [wcfc9], a
	call DelayFrame
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $1
.asm_8c22b
	ld a, [wcf63]
	bit 6, a
	jr nz, .skiploadingblack
	bit 7, a
	jr nz, .asm_8c23a
	call Function8c314
	call DelayFrame
	jr .asm_8c22b

.asm_8c23a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, Unkn1Pals
	ld bc, $0040
	xor a
	call ByteFill
	pop af
	ld [rSVBK], a
	ld a, $ff
	ld [wcfc7], a
	call DmgToCgbBGPals
	call DelayFrame
.skiploadingblack
	xor a
	ld [hLCDStatCustom], a
	ld [$ffc7], a
	ld [$ffc8], a
	ld [hSCY], a
	ld a, $1
	ld [rSVBK], a
	pop af
	ld [hVBlank], a
	call DelayFrame
	ret
; 8c26d

Function8c26d: ; 8c26d
	ld a, [wLinkMode]
	cp $4
	jr z, .asm_8c288
	callba Function6454
	call Function1ad2
	call DelayFrame
	call Function8c2a0
	call Function8cf4f
	jr .asm_8c28b

.asm_8c288
	call Function8c2aa
.asm_8c28b
	ld a, $90
	ld [hWY], a
	call DelayFrame
	xor a
	ld [hBGMapMode], a
	ld hl, wcf63
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	call Function8c6d8
	ret
; 8c2a0

Function8c2a0: ; 8c2a0
	call Function8c2aa
	ld hl, VBGMap0
	call Function8c2cf
	ret
; 8c2aa

Function8c2aa: ; 8c2aa
	ld de, GFX_8c2f4
	ld hl, $8fe0
	ld b, BANK(GFX_8c2f4)
	ld c, 2
	call Request2bpp
	ld a, [rVBK]
	push af
	ld a, $1
	ld [rVBK], a
	ld de, GFX_8c2f4
	ld hl, $8fe0
	ld b, BANK(GFX_8c2f4)
	ld c, 2
	call Request2bpp
	pop af
	ld [rVBK], a
	ret
; 8c2cf

Function8c2cf: ; 8c2cf
	ld a, [rSVBK]
	push af
	ld a, $6
	ld [rSVBK], a
	push hl
	ld hl, w6_d000
	ld bc, $28 * $10
.asm_8c2dd
	ld [hl], $ff
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_8c2dd
	pop hl
	ld de, w6_d000
	ld b, BANK(Function8c2cf) ; BANK(@)
	ld c, $28
	call Request2bpp
	pop af
	ld [rSVBK], a
	ret
; 8c2f4

GFX_8c2f4: ; 8c2f4
INCBIN "gfx/unknown/08c2f4.2bpp"

Function8c314: ; 8c314
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_8c323
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8c323

Jumptable_8c323: ; 8c323 (23:4323)
	dw Function8c365
; cave
	dw Function8c5dc
	dw Function8c3a1
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c39c
	dw Function8c3e8
	dw Function8c408
; cave, stronger foe
	dw Function8c5dc
	dw Function8c3a1
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c39c
	dw Function8c768
; outdoor
	dw Function8c5dc
	dw Function8c3a1
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c39c
	dw Function8c43d
	dw Function8c44f
	dw Function8c5dc
; outdoor, stronger foe
	dw Function8c3a1
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c3ab
	dw Function8c39c
	dw Function8c578
	dw Function8c58f
	dw Function8c393

Function8c365: ; 8c365 (23:4365)
	ld hl, PartySpecies
	ld c, 0
	ld b, 6
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	cp EGG
	jr z, .next
	set 6, c
.next
	srl c
	dec b
	jr .loop
.done
	ld a, b
	and a
	jr z, .done2
.loop2
	srl c
	dec a
	jr nz, .loop2
.done2
	ld b, 6
	ld hl, PartyMon1HP
	ld de, PartyMon2 - PartyMon1 - 1
.asm_2ee3d
	srl c
	jr nc, .inc_loop
	ld a, [hli]
	or [hl]
	jr nz, .asm_2ee45
	jr .skip_inc
.inc_loop
	inc hl
.skip_inc
	add hl, de
	dec b
	jr nz, .asm_2ee3d
.asm_2ee45
	ld de, PartyMon1Level - (PartyMon1HP + 1)
	add hl, de
	ld a, [hl]
	ld [BattleMonLevel], a
	ld de, 0
	add 3
	ld hl, EnemyMonLevel
	cp [hl]
	jr nc, .asm_8c375
	set 0, e
.asm_8c375
	ld a, [wMapHeaderPermission]
	cp CAVE
	jr z, .asm_8c386
	cp FOREST
	jr z, .asm_8c386
	cp DUNGEON
	jr z, .asm_8c386
	set 1, e
.asm_8c386
	ld hl, Unknown_8c38f
	add hl, de
	ld a, [hl]
	ld [wcf63], a
	ret
; 8c38f (23:438f)

Unknown_8c38f: ; 8c38f
	db 1,  9
	db 16, 24
; 8c393

Function8c393: ; 8c393 (23:4393)
	call ClearSprites
	ld a, $80
	ld [wcf63], a
	ret

Function8c39c: ; 8c39c (23:439c)
	ld hl, wcf63
	inc [hl]
	ret

Function8c3a1: ; 8c3a1 (23:43a1)
	call Function8c39c
	xor a
	ld [wcf64], a
	ld [hBGMapMode], a ; $ff00+$d4
	ret

Function8c3ab: ; 8c3ab (23:43ab)
	call Function8c3b3
	ret nc
	call Function8c39c
	ret

Function8c3b3: ; 8c3b3 (23:43b3)
	ld a, [wd847]
	cp $ff
	jr z, .asm_8c3d5
	ld hl, wcf64
	ld a, [hl]
	inc [hl]
	srl a
	ld e, a
	ld d, 0
	ld hl, Unknown_8c3db
	add hl, de
	ld a, [hl]
	cp $1
	jr z, .asm_8c3d5
	ld [wcfc7], a
	call DmgToCgbBGPals
	and a
	ret

.asm_8c3d5
	xor a
	ld [wcf64], a
	scf
	ret
; 8c3db (23:43db)

Unknown_8c3db: ; 8c3db
	db $f9 ; 3321
	db $fe ; 3332
	db $ff ; 3333
	db $fe ; 3332
	db $f9 ; 3321
	db $e4 ; 3210
	db $90 ; 2100
	db $40 ; 1000
	db $00 ; 0000
	db $40 ; 1000
	db $90 ; 2100
	db $e4 ; 3210
	db $01 ; 0001
; 8c3e8

Function8c3e8: ; 8c3e8 (23:43e8)
	callba Function5602
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	call Function8c39c
	ld a, $43
	ld [hLCDStatCustom], a ; $ff00+$c6
	xor a
	ld [$ffc7], a
	ld a, $90
	ld [$ffc8], a
	xor a
	ld [wcf64], a
	ld [wcf65], a
	ret

Function8c408: ; 8c408 (23:4408)
	call HostsBattleTransition
	ret c
	ld a, [wcf64]
	cp $60
	jr nc, .asm_8c413
	call Function8c419
	ret

.asm_8c413
	ld a, $20
	ld [wcf63], a
	ret

Function8c419: ; 8c419 (23:4419)
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	ld hl, wcf64
	ld d, [hl]
	add [hl]
	ld [hl], a
	ld a, $90
	ld bc, wd100
	ld e, $0
.asm_8c42b
	push af
	push de
	ld a, e
	call Function8c6f7
	ld [bc], a
	inc bc
	pop de
	ld a, e
	add $2
	ld e, a
	pop af
	dec a
	jr nz, .asm_8c42b
	ret

Function8c43d: ; 8c43d (23:443d)
	callba Function5602
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	call Function8c39c
	xor a
	ld [wcf64], a
	ret

Function8c44f: ; 8c44f (23:444f)
	call HostsBattleTransition
	ret c
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, [wcf64]
	ld e, a
	ld d, 0
	ld hl, Unknown_8c490
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	cp $ff
	jr z, .asm_8c47a
	ld [wcf65], a
	call Function8c4f5
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	call DelayFrame
	call DelayFrame
	ld hl, wcf64
	inc [hl]
	ret

.asm_8c47a
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, $20
	ld [wcf63], a
	ret
; 8c490 (23:4490)

HostsBattleTransition:
	ld a, [rSVBK]
	push af
	ld a, 1
	ld [rSVBK], a
	ld a, [OtherTrainerClass]
	cp RED
	jr nz, .okay
	ld a, [OtherTrainerID]
	dec a
	jr z, .start
	dec a
	jr z, .start
	jr .nocarry
.okay
	cp CAL
	jr nz, .okay2
	ld a, [OtherTrainerID]
	cp 4
	jr z, .start
	jr .nocarry
.okay2
	cp BABA
	jr nz, .nocarry
.start
	pop af
	ld [rSVBK], a
	callba _HostsBattleTransition
	ld a, $40
	ld [wcf63], a
	scf
	ret
.nocarry
	pop af
	ld [rSVBK], a
	xor a
	ret

Unknown_8c490: ; 8c490
macro_8c490: MACRO
	db \1
	dw \2
	dw TileMap + SCREEN_WIDTH * \4 + \3
ENDM
	macro_8c490 0, Unknown_8c538,  1,  6
	macro_8c490 0, Unknown_8c53e,  0,  3
	macro_8c490 0, Unknown_8c548,  1,  0
	macro_8c490 0, Unknown_8c55a,  5,  0
	macro_8c490 0, Unknown_8c568,  9,  0
	macro_8c490 1, Unknown_8c568, 10,  0
	macro_8c490 1, Unknown_8c55a, 14,  0
	macro_8c490 1, Unknown_8c548, 18,  0
	macro_8c490 1, Unknown_8c53e, 19,  3
	macro_8c490 1, Unknown_8c538, 18,  6
	macro_8c490 3, Unknown_8c538, 18, 11
	macro_8c490 3, Unknown_8c53e, 19, 14
	macro_8c490 3, Unknown_8c548, 18, 17
	macro_8c490 3, Unknown_8c55a, 14, 17
	macro_8c490 3, Unknown_8c568, 10, 17
	macro_8c490 2, Unknown_8c568,  9, 17
	macro_8c490 2, Unknown_8c55a,  5, 17
	macro_8c490 2, Unknown_8c548,  1, 17
	macro_8c490 2, Unknown_8c53e,  0, 14
	macro_8c490 2, Unknown_8c538,  1, 11
	db $ff
; 8c4f5

Function8c4f5: ; 8c4f5 (23:44f5)
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_8c4fc
	push hl
	ld a, [de]
	ld c, a
	inc de
.asm_8c500
	ld [hl], $ff
	ld a, [wcf65]
	bit 0, a
	jr z, .asm_8c50c
	inc hl
	jr .asm_8c50d

.asm_8c50c
	dec hl
.asm_8c50d
	dec c
	jr nz, .asm_8c500
	pop hl
	ld a, [wcf65]
	bit 1, a
	ld bc, $14
	jr z, .asm_8c51e
	ld bc, $ffec
.asm_8c51e
	add hl, bc
	ld a, [de]
	inc de
	cp $ff
	ret z
	and a
	jr z, .asm_8c4fc
	ld c, a
.asm_8c528
	ld a, [wcf65]
	bit 0, a
	jr z, .asm_8c532
	dec hl
	jr .asm_8c533

.asm_8c532
	inc hl
.asm_8c533
	dec c
	jr nz, .asm_8c528
	jr .asm_8c4fc
; 8c538 (23:4538)

Unknown_8c538: db 2, 3, 5, 4, 9, $ff
Unknown_8c53e: db 1, 1, 2, 2, 4, 2, 4, 2, 3, $ff
Unknown_8c548: db 2, 1, 3, 1, 4, 1, 4, 1, 4, 1, 3, 1, 2, 1, 1, 1, 1, $ff
Unknown_8c55a: db 4, 1, 4, 0, 3, 1, 3, 0, 2, 1, 2, 0, 1, $ff
Unknown_8c568: db 4, 0, 3, 0, 3, 0, 2, 0, 2, 0, 1, 0, 1, 0, 1, $ff
; 8c578

Function8c578: ; 8c578 (23:4578)
	callba Function5602
	ld a, $5
	ld [rSVBK], a ; $ff00+$70
	call Function8c39c
	ld a, $10
	ld [wcf64], a
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	ret

Function8c58f: ; 8c58f (23:458f)
	call HostsBattleTransition
	ret c
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_8c5a2
	dec [hl]
	ld c, $c
.asm_8c599
	push bc
	call Function8c5b8
	pop bc
	dec c
	jr nz, .asm_8c599
	ret

.asm_8c5a2
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	ld a, $20
	ld [wcf63], a
	ret

Function8c5b8: ; 8c5b8 (23:45b8)
	call Random
	cp $12
	jr nc, Function8c5b8
	ld b, a
.asm_8c5c0
	call Random
	cp $14
	jr nc, .asm_8c5c0
	ld c, a
	ld hl, Sprites + $8c
	ld de, $14
	inc b
.asm_8c5cf
	add hl, de
	dec b
	jr nz, .asm_8c5cf
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, Function8c5b8
	ld [hl], $ff
	ret

Function8c5dc: ; 8c5dc (23:45dc)
; moved to an another bank because we are running out of space
	callba _Function8c5dc
	ret

Function8c6d8: ; 8c6d8
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld hl, LYOverrides
	call Function8c6ef
	ld hl, LYOverridesBackup
	call Function8c6ef
	pop af
	ld [rSVBK], a
	ret
; 8c6ef

Function8c6ef: ; 8c6ef
	xor a
	ld c, $90
.asm_8c6f2
	ld [hli], a
	dec c
	jr nz, .asm_8c6f2
	ret
; 8c6f7

Function8c6f7: ; 8c6f7 (23:46f7)
	and $3f
	cp $20
	jr nc, .asm_8c702
	call Function8c70c
	ld a, h
	ret

.asm_8c702
	and $1f
	call Function8c70c
	ld a, h
	xor $ff
	inc a
	ret

Function8c70c: ; 8c70c (23:470c)
	ld e, a
	ld a, d
	ld d, 0
	ld hl, Unknown_8c728
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.asm_8c71b
	srl a
	jr nc, .asm_8c720
	add hl, de
.asm_8c720
	sla e
	rl d
	and a
	jr nz, .asm_8c71b
	ret
; 8c728 (23:4728)

Unknown_8c728: ; 8c728
	sine_wave $100
; 8c768

Function8c768: ; 8c768 (23:4768)
	call HostsBattleTransition
	ret c
	callba Function5602
	ld de, Unknown_8c792
.asm_8c771
	ld a, [de]
	cp $ff
	jr z, .asm_8c78c
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Function8c7b7
	call WaitBGMap
	jr .asm_8c771

.asm_8c78c
	ld a, $20
	ld [wcf63], a
	ret
; 8c792 (23:4792)

Unknown_8c792: ; 8c792
macro_8c792: macro
	db \1, \2
	dwcoord \3, \4
endm
	macro_8c792  4,  2,  8, 8
	macro_8c792  6,  4,  7, 7
	macro_8c792  8,  6,  6, 6
	macro_8c792 10,  8,  5, 5
	macro_8c792 12, 10,  4, 4
	macro_8c792 14, 12,  3, 3
	macro_8c792 16, 14,  2, 2
	macro_8c792 18, 16,  1, 1
	macro_8c792 20, 18,  0, 0
	db $ff
; 8c7b7

Function8c7b7: ; 8c7b7 (23:47b7)
	ld a, $ff
.asm_8c7b9
	push bc
	push hl
.asm_8c7bb
	ld [hli], a
	dec c
	jr nz, .asm_8c7bb
	pop hl
	ld bc, $14
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_8c7b9
	ret
; 8c7c9 (23:47c9)

Function8c7c9: ; 8c7c9
	ld a, $1
	ld [hBGMapMode], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ret
; 8c7d4

Function8c7d4: ; 8c7d4
	call WaitSFX
	ld de, SFX_SURF
	call PlaySFX
	call WaitSFX
	ret
; 8c7e1

Function8c7e1: ; 8c7e1
	callba Function8c084
	ld hl, StatusFlags
	set 2, [hl]
	callba Function8c0e5
	callba Function8c001
	ld b, $9
	call GetSGBLayout
	callba Function49409
	callba Function8c079
	ret
; 8c80a

ShakeHeadbuttTree: ; 8c80a
	callba Function8cf53
	ld de, GFX_8c9cc
	ld hl, VTiles1
	lb bc, BANK(GFX_8c9cc), 4
	call Request2bpp
	ld de, HeadbuttTreeGFX
	ld hl, $8840
	lb bc, BANK(HeadbuttTreeGFX), 8
	call Request2bpp
	call Function8cad3
	ld a, $1b
	call Function3b2a
	ld hl, $0003
	add hl, bc
	ld [hl], $84
	ld a, $90
	ld [wc3b5], a
	callba Function8cf7a
	call Function8c913
	ld a, $20
	ld [wcf64], a
	call WaitSFX
	ld de, SFX_SANDSTORM
	call PlaySFX
.asm_8c852
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_8c86a
	dec [hl]
	ld a, $90
	ld [wc3b5], a
	callba Function8cf7a
	call DelayFrame
	jr .asm_8c852

.asm_8c86a
	call Function2173
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	callba Function8cf53
	ld hl, Sprites + $90
	ld bc, $0010
	xor a
	call ByteFill
	ld de, Font
	ld hl, VTiles1
	lb bc, BANK(Font), $c
	call Get1bpp
	call Functione4a
	ret
; 8c893

HeadbuttTreeGFX: ; 8c893
INCBIN "gfx/unknown/08c893.2bpp"
; 8c913

Function8c913: ; 8c913
	xor a
	ld [hBGMapMode], a
	ld a, [PlayerDirection]
	and $c
	srl a
	ld e, a
	ld d, 0
	ld hl, Unknown_8c938
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $5
	ld [hli], a
	ld [hld], a
	ld bc, $0014
	add hl, bc
	ld [hli], a
	ld [hld], a
	call WaitBGMap
	xor a
	ld [hBGMapMode], a
	ret
; 8c938

Unknown_8c938: ; 8c938
	dw TileMap +  8 + 10 * SCREEN_WIDTH
	dw TileMap +  8 +  6 * SCREEN_WIDTH
	dw TileMap +  6 +  8 * SCREEN_WIDTH
	dw TileMap + 10 +  8 * SCREEN_WIDTH
; 8c940

Function8c940: ; 8c940
	ld a, e
	and $1
	ld [wcf63], a
	call Function8c96d
	call WaitSFX
	ld de, SFX_PLACE_PUZZLE_PIECE_DOWN
	call PlaySFX
.asm_8c952
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_8c96c
	ld a, $90
	ld [wc3b5], a
	callab Function8cf7a
	call Function8ca0c
	call DelayFrame
	jr .asm_8c952

.asm_8c96c
	ret
; 8c96d

Function8c96d: ; 8c96d
	callab Function8cf53
	ld de, GFX_8c9cc
	ld hl, VTiles1
	lb bc, BANK(GFX_8c9cc), 4
	call Request2bpp
	ld de, CutTreeGFX
	ld hl, VTiles1 + $40
	lb bc, BANK(CutTreeGFX), 4
	call Request2bpp
	ret
; 8c98c

CutTreeGFX: ; c898c
INCBIN "gfx/unknown/08c98c.2bpp"
; c89cc

GFX_8c9cc: ; 8c9cc
INCBIN "gfx/unknown/08c9cc.2bpp"
; 8ca0c

Function8ca0c: ; 8ca0c
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_8ca1b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8ca1b

Jumptable_8ca1b: ; 8ca1b (23:4a1b)
	dw Function8ca23
	dw Function8ca3c
	dw Function8ca5c
	dw Function8ca64

Function8ca23: ; 8ca23 (23:4a23)
	call Function8cad3
	ld a, $17
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $84
	ld a, $20
	ld [wcf64], a
	ld hl, wcf63
	inc [hl]
	inc [hl]
	ret

Function8ca3c: ; 8ca3c (23:4a3c)
	call Function8ca8e
	xor a
	call Function8ca73
	ld a, $10
	call Function8ca73
	ld a, $20
	call Function8ca73
	ld a, $30
	call Function8ca73
	ld a, $20
	ld [wcf64], a
	ld hl, wcf63
	inc [hl]
	ret

Function8ca5c: ; 8ca5c (23:4a5c)
	ld a, $1
	ld [hBGMapMode], a ; $ff00+$d4
	ld hl, wcf63
	inc [hl]
Function8ca64: ; 8ca64 (23:4a64)
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_8ca6d
	dec [hl]
	ret

.asm_8ca6d
	ld hl, wcf63
	set 7, [hl]
	ret

Function8ca73: ; 8ca73 (23:4a73)
	push de
	push af
	ld a, $16
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $80
	ld hl, $e
	add hl, bc
	ld [hl], $4
	pop af
	ld hl, $c
	add hl, bc
	ld [hl], a
	pop de
	ret

Function8ca8e: ; 8ca8e (23:4a8e)
	ld de, $0
	ld a, [wd197]
	bit 0, a
	jr z, .asm_8ca9a
	set 0, e
.asm_8ca9a
	ld a, [wd196]
	bit 0, a
	jr z, .asm_8caa3
	set 1, e
.asm_8caa3
	ld a, [PlayerDirection]
	and $c
	add e
	ld e, a
	ld hl, Unknown_8cab3
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
; 8cab3 (23:4ab3)

Unknown_8cab3: ; 8cab3
	db $58, $60
	db $48, $60
	db $58, $70
	db $48, $70
	db $58, $40
	db $48, $40
	db $58, $50
	db $48, $50
	db $38, $60
	db $48, $60
	db $38, $50
	db $48, $50
	db $58, $60
	db $68, $60
	db $58, $50
	db $68, $50
; 8cad3

Function8cad3: ; 8cad3 (23:4ad3)
	ld a, [PlayerDirection]
	and $c
	srl a
	ld e, a
	ld d, 0
	ld hl, Unknown_8cae5
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret
; 8cae5 (23:4ae5)

Unknown_8cae5: ; 8cae5
	db $50, $68
	db $50, $48
	db $40, $58
	db $60, $58
; 8caed

Function8caed: ; 8caed
	call DelayFrame
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	call Function8cb9b
	ld de, $5450
	ld a, $a
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $84
	ld hl, $2
	add hl, bc
	ld [hl], $16
	ld a, $80
	ld [wcf64], a
.asm_8cb14
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_8cb2e
	ld a, $0
	ld [wc3b5], a
	callab Function8cf7a
	call Function8cbc8
	call DelayFrame
	jr .asm_8cb14

.asm_8cb2e
	pop af
	ld [VramState], a
	ret
; 8cb33

Function8cb33: ; 8cb33
	call DelayFrame
	ld a, [VramState]
	push af
	xor a
	ld [VramState], a
	call Function8cb9b
	ld de, $fc50
	ld a, $a
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $84
	ld hl, $2
	add hl, bc
	ld [hl], $18
	ld hl, $f
	add hl, bc
	ld [hl], $58
	ld a, $40
	ld [wcf64], a
.asm_8cb60
	ld a, [wcf63]
	bit 7, a
	jr nz, .asm_8cb7a
	ld a, $0
	ld [wc3b5], a
	callab Function8cf7a
	call Function8cbc8
	call DelayFrame
	jr .asm_8cb60

.asm_8cb7a
	pop af
	ld [VramState], a
	call Function8cb82
	ret

Function8cb82: ; 8cb82 (23:4b82)
	ld hl, Sprites + 2
	xor a
	ld c, $4
.asm_8cb88
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc a
	dec c
	jr nz, .asm_8cb88
	ld hl, Sprites + $10
	ld bc, $90
	xor a
	call ByteFill
	ret

Function8cb9b: ; 8cb9b (23:4b9b)
	callab Function8cf53
	ld de, GFX_8c9cc
	ld hl, $8800
	lb bc, BANK(GFX_8c9cc), 4
	call Request2bpp
	ld a, [CurPartyMon]
	ld hl, PartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [wd265], a
	ld e, $84
	callba Function8e9bc
	xor a
	ld [wcf63], a
	ret

Function8cbc8: ; 8cbc8 (23:4bc8)
	call Function8cbe6
	ld hl, wcf64
	ld a, [hl]
	and a
	jr z, .asm_8cbe0
	dec [hl]
	cp $40
	ret c
	and $7
	ret nz
	ld de, SFX_FLY
	call PlaySFX
	ret

.asm_8cbe0
	ld hl, wcf63
	set 7, [hl]
	ret

Function8cbe6: ; 8cbe6 (23:4be6)
	ld hl, wcf65
	ld a, [hl]
	inc [hl]
	and $7
	ret nz
	ld a, [hl]
	and $18
	sla a
	add $40
	ld d, a
	ld e, $0
	ld a, $18
	call Function3b2a
	ld hl, $3
	add hl, bc
	ld [hl], $80
	ret

Function8cc04: ; 8cc04
	ld a, [ScriptVar]
	and a
	jr nz, .asm_8cc14
	ld a, $1
	lb bc, $40, $60
	ld de, $fca0
	jr .asm_8cc1c

.asm_8cc14
	ld a, $ff
	lb bc, $c0, $a0
	ld de, $b460
.asm_8cc1c
	ld h, a
	ld a, [rSVBK]
	push af
	ld a, $5
	ld [rSVBK], a
	ld a, h
	ld [wd191], a
	ld a, c
	ld [wd192], a
	ld a, b
	ld [wd193], a
	ld a, e
	ld [wd194], a
	ld a, d
	ld [wd195], a
	ld a, [hSCX]
	push af
	ld a, [hSCY]
	push af
	call Function8ccc9
	ld hl, hVBlank
	ld a, [hl]
	push af
	ld [hl], $1
.asm_8cc48
	ld a, [wcf63]
	and a
	jr z, .asm_8cc66
	bit 7, a
	jr nz, .asm_8cc6b
	callab Function8cf69
	call Function8cdf7
	call Function8cc99
	call Function3b0c
	call DelayFrame
	jr .asm_8cc48

.asm_8cc66
	call Function8ceae
	jr .asm_8cc48

.asm_8cc6b
	pop af
	ld [hVBlank], a
	call WhiteBGMap
	xor a
	ld [hLCDStatCustom], a
	ld [$ffc7], a
	ld [$ffc8], a
	ld [hSCX], a
	ld [Requested2bppSource], a
	ld [Requested2bppSource + 1], a
	ld [Requested2bppDest], a
	ld [Requested2bppDest + 1], a
	ld [Requested2bpp], a
	call ClearTileMap
	pop af
	ld [hSCY], a
	pop af
	ld [hSCX], a
	xor a
	ld [hBGMapMode], a
	pop af
	ld [rSVBK], a
	ret
; 8cc99

Function8cc99: ; 8cc99
	ld hl, LYOverridesBackup
	ld c, $2f
	ld a, [wcf64]
	add a
	ld [hSCX], a
	call Function8ccc4
	ld c, $30
	ld a, [wcf65]
	call Function8ccc4
	ld c, $31
	ld a, [wcf64]
	add a
	call Function8ccc4
	ld a, [wd191]
	ld d, a
	ld hl, wcf64
	ld a, [hl]
	add d
	add d
	ld [hl], a
	ret
; 8ccc4

Function8ccc4: ; 8ccc4
.asm_8ccc4
	ld [hli], a
	dec c
	jr nz, .asm_8ccc4
	ret
; 8ccc9

Function8ccc9: ; 8ccc9
	call WhiteBGMap
	call ClearSprites
	call DisableLCD
	callab Function8cf53
	call SetMagnetTrainPals
	call DrawMagnetTrain
	ld a, $90
	ld [hWY], a
	call EnableLCD
	xor a
	ld [hBGMapMode], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	callba GetPlayerIcon
	pop af
	ld [rSVBK], a
	ld hl, VTiles0
	ld c, $4
	call Request2bpp
	ld hl, $00c0
	add hl, de
	ld d, h
	ld e, l
	ld hl, $8040
	ld c, $4
	call Request2bpp
	call Function8cda6
	ld hl, wcf63
	xor a
	ld [hli], a
	ld a, [wd192]
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld de, MUSIC_MAGNET_TRAIN
	call PlayMusic2
	ret
; 8cd27

DrawMagnetTrain: ; 8cd27
	ld hl, VBGMap0
	xor a
.asm_8cd2b
	call GetMagnetTrainBGTiles
	ld b, 32 / 2
	call .FillAlt
	inc a
	cp $12
	jr c, .asm_8cd2b
	ld hl, $98c0
	ld de, MagnetTrainTilemap1
	ld c, 20
	call .FillLine
	ld hl, $98e0
	ld de, MagnetTrainTilemap2
	ld c, 20
	call .FillLine
	ld hl, $9900
	ld de, MagnetTrainTilemap3
	ld c, 20
	call .FillLine
	ld hl, $9920
	ld de, MagnetTrainTilemap4
	ld c, 20
	call .FillLine
	ret
; 8cd65

.FillLine ; 8cd65
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .FillLine
	ret
; 8cd6c

.FillAlt ; 8cd6c
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	dec b
	jr nz, .FillAlt
	ret
; 8cd74

GetMagnetTrainBGTiles: ; 8cd74
	push hl
	ld e, a
	ld d, 0
	ld hl, MagnetTrainBGTiles
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret
; 8cd82

MagnetTrainBGTiles: ; 8cd82
; Alternating tiles for each line
; of the Magnet Train tilemap.

	db $4c, $4d ; bush
	db $5c, $5d ; bush
	db $4c, $4d ; bush
	db $5c, $5d ; bush
	db $08, $08 ; fence
	db $18, $18 ; fence
	db $1f, $1f ; track
	db $31, $31 ; track
	db $11, $11 ; track
	db $11, $11 ; track
	db $0d, $0d ; track
	db $31, $31 ; track
	db $04, $04 ; fence
	db $18, $18 ; fence
	db $4c, $4d ; bush
	db $5c, $5d ; bush
	db $4c, $4d ; bush
	db $5c, $5d ; bush
; 8cda6

Function8cda6: ; 8cda6
	ld hl, LYOverrides
	ld bc, $0090
	ld a, [wd192]
	call ByteFill
	ld hl, LYOverridesBackup
	ld bc, $0090
	ld a, [wd192]
	call ByteFill
	ld a, $43
	ld [hLCDStatCustom], a
	ret
; 8cdc3

SetMagnetTrainPals: ; 8cdc3
	ld a, $1
	ld [rVBK], a
	; bushes
	ld hl, VBGMap0
	ld bc, $0080
	ld a, $2
	call ByteFill
	; train
	ld hl, $9880
	ld bc, $0140
	xor a
	call ByteFill
	; more bushes
	ld hl, $99c0
	ld bc, $0080
	ld a, $2
	call ByteFill
	; train window
	ld hl, $9907
	ld bc, $0006
	ld a, $4
	call ByteFill
	ld a, $0
	ld [rVBK], a
	ret
; 8cdf7

Function8cdf7: ; 8cdf7
	ld a, [wcf63]
	ld e, a
	ld d, 0
	ld hl, Jumptable_8ce06
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8ce06

Jumptable_8ce06: ; 8ce06
	dw Function8ce19
	dw Function8ce6d
	dw Function8ce47
	dw Function8ce6d
	dw Function8ce7a
	dw Function8ce6d
	dw Function8cea2
; 8ce14

Function8ce14: ; 8ce14
	ld hl, wcf63
	inc [hl]
	ret
; 8ce19

Function8ce19: ; 8ce19
	ld d, $55
	ld a, [wd195]
	ld e, a
	ld b, $15
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, [PlayerGender]
	bit 0, a
	jr z, .asm_8ce31
	ld b, $1f
.asm_8ce31
	pop af
	ld [rSVBK], a
	ld a, b
	call Function3b2a
	ld hl, $0003
	add hl, bc
	ld [hl], $0
	; Set the palette here
	call Function8ce14
	ld a, $80
	ld [wcf66], a
	ret
; 8ce47

Function8ce47: ; 8ce47
	ld hl, wd193
	ld a, [wcf65]
	cp [hl]
	jr z, .asm_8ce64
	ld e, a
	ld a, [wd191]
	xor $ff
	inc a
	add e
	ld [wcf65], a
	ld hl, wc3c0
	ld a, [wd191]
	add [hl]
	ld [hl], a
	ret

.asm_8ce64
	call Function8ce14
	ld a, $80
	ld [wcf66], a
	ret
; 8ce6d

Function8ce6d: ; 8ce6d
	ld hl, wcf66
	ld a, [hl]
	and a
	jr z, .asm_8ce76
	dec [hl]
	ret

.asm_8ce76
	call Function8ce14
	ret
; 8ce7a

Function8ce7a: ; 8ce7a
	ld hl, wd194
	ld a, [wcf65]
	cp [hl]
	jr z, .asm_8ce9e
	ld e, a
	ld a, [wd191]
	xor $ff
	inc a
	ld d, a
	ld a, e
	add d
	add d
	ld [wcf65], a
	ld hl, wc3c0
	ld a, [wd191]
	ld d, a
	ld a, [hl]
	add d
	add d
	ld [hl], a
	ret
	ret

.asm_8ce9e
	call Function8ce14
	ret
; 8cea2

Function8cea2: ; 8cea2
	ld a, $80
	ld [wcf63], a
	ld de, SFX_TRAIN_ARRIVED
	call PlaySFX
	ret
; 8ceae

Function8ceae: ; 8ceae
	callba Function8cf69
	call Function8cdf7
	call Function8cc99
	call Function3b0c
	call DelayFrame
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, [TimeOfDayPal]
	push af
	ld a, [wMapHeaderPermission]
	push af
	ld a, [TimeOfDay]
	and $3
	ld [TimeOfDayPal], a
	ld a, $1
	ld [wMapHeaderPermission], a
	ld b, $9
	call GetSGBLayout
	call UpdateTimePals
	ld a, [rBGP]
	ld [wcfc7], a
	ld a, [rOBP0]
	ld [wcfc8], a
	ld a, [rOBP1]
	ld [wcfc9], a
	pop af
	ld [wMapHeaderPermission], a
	pop af
	ld [TimeOfDayPal], a
	pop af
	ld [rSVBK], a
	ret
; 8ceff

MagnetTrainTilemap1: db $1f, $05, $06, $0a, $0a, $0a, $09, $0a, $0a, $0a, $0a, $0a, $0a, $09, $0a, $0a, $0a, $0b, $0c, $1f
MagnetTrainTilemap2: db $14, $15, $16, $1a, $1a, $1a, $19, $1a, $1a, $1a, $1a, $1a, $1a, $19, $1a, $1a, $1a, $1b, $1c, $1d
MagnetTrainTilemap3: db $24, $25, $26, $27, $07, $2f, $29, $28, $28, $28, $28, $28, $28, $29, $07, $2f, $2a, $2b, $2c, $2d
MagnetTrainTilemap4: db $20, $1f, $2e, $1f, $17, $00, $2e, $1f, $1f, $1f, $1f, $1f, $1f, $2e, $17, $00, $1f, $2e, $1f, $0f
; 8cf4f

Function8cf4f: ; 8cf4f
	call Function3238
	ret
; 8cf53

INCLUDE "engine/sprites.asm"

Function8e72a: ; 8e72a
	add $10
Function8e72c: ; 8e72c
	and $3f
	cp $20
	jr nc, .asm_8e737
	call Function8e741
	ld a, h
	ret

.asm_8e737
	and $1f
	call Function8e741
	ld a, h
	xor $ff
	inc a
	ret
; 8e741

Function8e741: ; 8e741
	ld e, a
	ld a, d
	ld d, 0
	ld hl, Unknown_8e75d
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.asm_8e750
	srl a
	jr nc, .asm_8e755
	add hl, de
.asm_8e755
	sla e
	rl d
	and a
	jr nz, .asm_8e750
	ret
; 8e75d

Unknown_8e75d: ; 8e75d
	sine_wave $100
Function8e79d: ; 8e79d
	ld a, [hSGB]
	ld de, GFX_8e7f4
	and a
	jr z, .asm_8e7a8
	ld de, GFX_8e804
.asm_8e7a8
	ld hl, VTiles0
	lb bc, BANK(GFX_8e7f4), 1
	call Request2bpp
	ld c, $8
	ld d, $0
.asm_8e7b5
	push bc
	call Function8e7c6
	call DelayFrame
	pop bc
	inc d
	inc d
	dec c
	jr nz, .asm_8e7b5
	call ClearSprites
	ret
; 8e7c6

Function8e7c6: ; 8e7c6
	ld hl, Sprites
	ld c, $8
.asm_8e7cb
	ld a, c
	and a
	ret z
	dec c
	ld a, c
	sla a
	sla a
	sla a
	push af
	push de
	push hl
	call Function8e72c
	pop hl
	pop de
	add $68
	ld [hli], a
	pop af
	push de
	push hl
	call Function8e72a
	pop hl
	pop de
	add $54
	ld [hli], a
	ld a, $0
	ld [hli], a
	ld a, $6
	ld [hli], a
	jr .asm_8e7cb
; 8e7f4

GFX_8e7f4: ; 8e7f4
INCBIN "gfx/unknown/08e7f4.2bpp"

GFX_8e804: ; 8e804
INCBIN "gfx/unknown/08e804.2bpp"

Function8e814: ; 8e814
	push hl
	push de
	push bc
	push af
	ld hl, wc300
	ld bc, $00c1
.asm_8e81e
	ld [hl], $0
	inc hl
	dec bc
	ld a, c
	or b
	jr nz, .asm_8e81e
	pop af
	pop bc
	pop de
	pop hl
	ret
; 8e82b

Function8e82b: ; 8e82b
	ld a, e
	call ReadMonMenuIcon
	ld l, a
	ld h, 0
	add hl, hl
	ld de, IconPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld b, BANK(Icons)
	ld c, 8
	ret
; 8e83f

Function8e83f: ; 8e83f
	push hl
	push de
	push bc
	call Function8e849
	pop bc
	pop de
	pop hl
	ret
; 8e849

Function8e849: ; 8e849
	ld d, 0
	ld hl, Jumptable_8e854
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]
; 8e854

Jumptable_8e854: ; 8e854 (23:6854)
	dw Function8e8d5
	dw Function8e961
	dw Function8e97d
	dw Function8e99a
	dw Function8e898
	dw Function8e8b1
	dw Function8e862

Function8e862: ; 8e862 (23:6862)
	call Function8e908
	call Function8e86c
	call Function8e936
	ret

Function8e86c: ; 8e86c (23:686c)
	push bc
	ld a, [$ffb0]
	ld hl, PartyMon1Item
	ld bc, PartyMon2 - PartyMon1
	call AddNTimes
	pop bc
	ld a, [hl]
	and a
	jr z, .asm_8e890
	push hl
	push bc
	ld d, a
	callab ItemIsMail
	pop bc
	pop hl
	jr c, .asm_8e88e
	ld a, $6
	jr .asm_8e892

.asm_8e88e
	ld a, $5
	jr .asm_8e892

.asm_8e890
	ld a, $4
.asm_8e892
	ld hl, $1
	add hl, bc
	ld [hl], a
	ret

Function8e898: ; 8e898 (23:6898)
	call Function8e8d5
	ld hl, $2
	add hl, bc
	ld a, $0
	ld [hl], a
	ld hl, $4
	add hl, bc
	ld a, $48
	ld [hl], a
	ld hl, $5
	add hl, bc
	ld a, $48
	ld [hl], a
	ret

Function8e8b1: ; 8e8b1 (23:68b1)
	call Function8e908
	call Function8e936
	ld hl, $2
	add hl, bc
	ld a, $0
	ld [hl], a
	ld hl, $4
	add hl, bc
	ld a, $18
	ld [hl], a
	ld hl, $5
	add hl, bc
	ld a, $60
	ld [hl], a
	ld a, c
	ld [wc608], a
	ld a, b
	ld [wc608 + 1], a
	ret

Function8e8d5: ; 8e8d5 (23:68d5)
	call Function8e908
	call Function8e8df
	call Function8e936
	ret

Function8e8df: ; 8e8df (23:68df)
	push bc
	ld a, [$ffb0]
	ld hl, PartyMon1Item
	ld bc, $30
	call AddNTimes
	pop bc
	ld a, [hl]
	and a
	ret z
	push hl
	push bc
	ld d, a
	callab ItemIsMail
	pop bc
	pop hl
	jr c, .asm_8e900
	ld a, $3
	jr .asm_8e902

.asm_8e900
	ld a, $2
.asm_8e902
	ld hl, $1
	add hl, bc
	ld [hl], a
	ret

Function8e908: ; 8e908 (23:6908)
	ld a, [wc3b7]
	push af
	ld a, [$ffb0]
	ld hl, PartySpecies
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call ReadMonMenuIcon
	ld [CurIcon], a
	call Function8e9db
	ld a, [$ffb0]
	add a
	add a
	add a
	add a
	add $1c
	ld d, a
	ld e, $10
	ld a, $0
	call Function8cfd6
	pop af
	ld hl, $3
	add hl, bc
	ld [hl], a
	ret

Function8e936: ; 8e936 (23:6936)
	push bc
	ld a, [$ffb0]
	ld b, a
	call Function8e94c
	ld a, b
	pop bc
	ld hl, $9
	add hl, bc
	ld [hl], a
	rlca
	rlca
	ld hl, $d
	add hl, bc
	ld [hl], a
	ret

Function8e94c: ; 8e94c (23:694c)
	callba Function50117
	call GetHPPal
	ld e, d
	ld d, 0
	ld hl, Unknown_8e95e
	add hl, de
	ld b, [hl]
	ret
; 8e95e (23:695e)

Unknown_8e95e: ; 8e95e
	db $00, $40, $80
; 8e961

Function8e961: ; 8e961 (23:6961)
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	xor a
	call GetIconGFX
	ld de, $2420
	ld a, $0
	call Function8cfd6
	ld hl, $2
	add hl, bc
	ld [hl], $0
	ret

Function8e961_2: ; 8e961 (23:6961)
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	xor a
	call GetIconGFX
	ld de, $2420
	ld a, $0
	call Function8cfd6
	ld hl, $2
	add hl, bc
	ld [hl], $0
	ret

Function8e97d: ; 8e97d (23:697d)
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	xor a
	call GetIconGFX
	ld d, $1a
	ld e, $24
	ld a, $0
	call Function8cfd6
	ld hl, $2
	add hl, bc
	ld [hl], $0
	ret

Function8e99a: ; 8e99a (23:699a)
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	ld a, $62
	ld [wc3b7], a
	call Function8e9db
	ret

GetSpeciesIcon: ; 8e9ac
; Load species icon into VRAM at tile a

	push de
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	pop de
	ld a, e
	call GetIconGFX
	ret
; 8e9bc

Function8e9bc: ; 8e9bc (23:69bc)
	push de
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	pop de
	ld a, e
	call GetIcon_a
	ret
; 8e9cc (23:69cc)

Function8e9cc: ; 8e9cc
	push de
	ld a, [wd265]
	call ReadMonMenuIcon
	ld [CurIcon], a
	pop de
	call GetIcon_de
	ret
; 8e9db

Function8e9db: ; 8e9db (23:69db)
	ld a, [wc3b7]
GetIconGFX: ; 8e9de
	call GetIcon_a
	ld de, $80 ; 8 tiles
	add hl, de
	ld de, HeldItemIcons
	lb bc, BANK(HeldItemIcons), 2
	call GetGFXUnlessMobile
	ld a, [wc3b7]
	add 10
	ld [wc3b7], a
	ret

HeldItemIcons:
INCBIN "gfx/icon/mail.2bpp"

INCBIN "gfx/icon/item.2bpp"
; 8ea17

GetIcon_de: ; 8ea17
; Load icon graphics into VRAM starting from tile de.

	ld l, e
	ld h, d
	jr GetIcon

GetIcon_a: ; 8ea1b
; Load icon graphics into VRAM starting from tile a.

	ld l, a
	ld h, 0

GetIcon: ; 8ea1e
; Load icon graphics into VRAM starting from tile hl.
; One tile is 16 bytes long.

	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl

	ld de, VTiles0
	add hl, de
	push hl
; The icons are contiguous, in order and of the same
; size, so the pointer table is somewhat redundant.

	ld a, [CurIcon]
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	ld de, IconPointers
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl

	lb bc, BANK(Icons), 8
	call GetGFXUnlessMobile
	pop hl
	ret
; 8ea3f

GetGFXUnlessMobile: ; 8ea3f
	ld a, [wLinkMode]
	cp 4 ; Mobile Link Battle
	jp nz, Request2bpp
	jp Functiondc9
; 8ea4a

Function8ea4a: ; 8ea4a ;hl = wc314 + 96. load 2 into the third byte of each 16 byte blockif the first byte is equal to wcfa9, otherwise 0 if the first byte is not 0
	ld hl, wc314 ;load ??
	ld e, $6
	ld a, [wcfa9] ;place ?? in d
	ld d, a
.asm_8ea53
	ld a, [hl] ;if ?? is 0, skip, if equal to other ?? continue with a = 2, else a = 0
	and a
	jr z, .asm_8ea69
	cp d
	jr z, .asm_8ea5e
	ld a, $0
	jr .asm_8ea60

.asm_8ea5e
	ld a, $2
.asm_8ea60
	push hl
	ld c, l
	ld b, h
	ld hl, $0002
	add hl, bc ;load a into hl+2
	ld [hl], a
	pop hl
.asm_8ea69
	ld bc, $0010 ;add 16 to hl
	add hl, bc
	dec e
	jr nz, .asm_8ea53 ;loop 6 times
	ret
; 8ea71

Function8ea71: ; 8ea71
	ld hl, wc314
	ld e, $6
.asm_8ea76
	ld a, [hl]
	and a
	jr z, .asm_8ea84
	push hl
	ld c, l
	ld b, h
	ld hl, $2
	add hl, bc
	ld [hl], $1
	pop hl
.asm_8ea84
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .asm_8ea76
	ret
; 8ea8c (23:6a8c)

Function8ea8c: ; 8ea8c load 2 into wc316,wc326,wc336,wc346,wc356 and wc366 if corrisponding slot matches current, else load 3
	ld hl, wc314
	ld e, $6 ;loop 6 times
	ld a, [wd0e3] ;mon selected
	ld d, a
.asm_8ea95
	ld a, [hl]
	and a
	jr z, .asm_8eaab ;if slot = zero,skip
	cp d
	jr z, .asm_8eaa0 ;if equal to selected mon, load 2, else load 3
	ld a, $3
	jr .asm_8eaa2

.asm_8eaa0
	ld a, $2
.asm_8eaa2
	push hl ;holds current slot
	ld c, l
	ld b, h
	ld hl, $2
	add hl, bc ;go down 2
	ld [hl], a ;load 2 or 3 into slot
	pop hl
.asm_8eaab
	ld bc, $10 ;go down 16
	add hl, bc
	dec e
	jr nz, .asm_8ea95 ;loop 6 times
	ret

INCLUDE "menu/mon_icons.asm"

INCLUDE "engine/voltorb_flip.asm"

SECTION "Revive Fossils", ROMX
INCLUDE "engine/fossilmenu.asm"

SECTION "bank24", ROMX, BANK[$24]

Function90000:: ; 90000
	call Function9001c
	jr c, .asm_9000d
	call Function9002d
	jr nc, .asm_9000d
	ld [hl], c
	xor a
	ret

.asm_9000d
	scf
	ret
; 9000f

Function9000f:: ; 9000f
	call Function9001c
	jr nc, .asm_90017
	xor a
	ld [hl], a
	ret

.asm_90017
	scf
	ret
; 90019

Function90019:: ; 90019
	jp Function9001c
; 9001c

Function9001c: ; 9001c
	ld hl, wPhoneList
	ld b, $a
.asm_90021
	ld a, [hli]
	cp c
	jr z, .asm_9002a
	dec b
	jr nz, .asm_90021
	xor a
	ret

.asm_9002a
	dec hl
	scf
	ret
; 9002d

Function9002d: ; 9002d
	call Function90040
	ld b, a
	ld hl, wPhoneList
.asm_90034
	ld a, [hli]
	and a
	jr z, .asm_9003d
	dec b
	jr nz, .asm_90034
	xor a
	ret

.asm_9003d
	dec hl
	scf
	ret
; 90040

Function90040: ; 90040
	xor a
	ld [Buffer1], a
	ld hl, Unknown_90066
.asm_90047
	ld a, [hli]
	cp $ff
	jr z, .asm_9005f
	cp c
	jr z, .asm_9005d
	push bc
	push hl
	ld c, a
	call Function9001c
	jr c, .asm_9005b
	ld hl, Buffer1
	inc [hl]
.asm_9005b
	pop hl
	pop bc
.asm_9005d
	jr .asm_90047

.asm_9005f
	ld a, $a
	ld hl, Buffer1
	sub [hl]
	ret
; 90066

Unknown_90066: ; 90066
	db 1, 4, $ff
; 90069

Function90069: ; 90069
	ld a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch
	call PlaceString
	pop af
	rst Bankswitch
	ret
; 90074

CheckPhoneCall:: ; 90074 (24:4074)
; Check if the phone is ringing in the overworld.
	ld a, [wd957]
	bit 2, a
	jr z, .no_call
	call CheckStandingOnEntrance
	jr z, .no_call
	call Function900a6
	nop
	jr nc, .no_call
	call Random
	ld b, a
	and $7f
	cp b
	jr nz, .no_call
	call Function2d05
	and a
	jr nz, .no_call
	call Function900de
	call Function900bf
	jr nc, .no_call
	ld e, a
	call Function9020d
	ld a, BANK(UnknownScript_0x90241)
	ld hl, UnknownScript_0x90241
	call CallScript
	scf
	ret

.no_call
	xor a
	ret

Function900a6: ; 900a6 (24:40a6)
	callba Function11401
	ret

Function900ad: ; 900ad (24:40ad)
	push hl
	push bc
	push de
	push af
	callba Functionc000
	pop af
	and $7
	and c
	pop de
	pop bc
	pop hl
	ret

Function900bf: ; 900bf (24:40bf)
	ld a, [wd040]
	and a
	jr z, .asm_900dc
	ld c, a
	call Random
	ld a, [hRandomAdd] ; $ff00+$e1
	swap a
	and $1f
	call SimpleDivide
	ld c, a
	ld b, $0
	ld hl, wd041
	add hl, bc
	ld a, [hl]
	scf
	ret

.asm_900dc
	xor a
	ret

Function900de: ; 900de (24:40de)
	callba Functionc000
	ld a, c
	ld [EngineBuffer1], a ; wd03e (aliases: MenuItemsList, CurFruitTree, CurInput)
	ld hl, wd040
	ld bc, $b
	xor a
	call ByteFill
	ld de, wPhoneList
	ld a, $a
.asm_900f7
	ld [wd03f], a
	ld a, [de]
	and a
	jr z, .asm_9012e
	ld hl, PhoneContacts + 8
	ld bc, 12
	call AddNTimes
	ld a, [EngineBuffer1] ; wd03e (aliases: MenuItemsList, CurFruitTree, CurInput)
	and [hl]
	jr z, .asm_9012e
	ld bc, $fffa
	add hl, bc
	ld a, [MapGroup]
	cp [hl]
	jr nz, .asm_9011e
	inc hl
	ld a, [MapNumber]
	cp [hl]
	jr z, .asm_9012e
.asm_9011e
	ld a, [wd040]
	ld c, a
	ld b, $0
	inc a
	ld [wd040], a
	ld hl, wd041
	add hl, bc
	ld a, [de]
	ld [hl], a
.asm_9012e
	inc de
	ld a, [wd03f]
	dec a
	jr nz, .asm_900f7
	ret

Function90136:: ; 90136 (24:4136)
	ld a, [wd957]
	bit 2, a
	jr z, .asm_90171
	ld a, [wdc31]
	and a
	jr z, .asm_90171
	dec a
	ld c, a
	ld b, 0
	ld hl, Unknown_90627
	ld a, 6
	call AddNTimes
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	jr nc, .asm_90171 ;leave if cannot recieve call
	call Function90178 ;reset phone postion
	inc hl
	inc hl
	ld a, [hli] ;load contect
	ld e, a
	push hl
	call Function9020d ;place contact's bank into a and loc into hl
	pop hl
	ld de, wd048 ;load script bank and script position into ram
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, BANK(UnknownScript_0x90173)
	ld hl, UnknownScript_0x90173
	call CallScript
	scf
	ret

.asm_90171
	xor a
	ret
; 90173 (24:4173)

UnknownScript_0x90173: ; 0x90173
	pause 30
	jump UnknownScript_0x90241
; 0x90178

Function90178: ; 90178 (24:4178)
	ld a, [wdc31]
	dec a
	ld c, a
	ld b, 0
	ld hl, Unknown_90627
	ld a, 6
	call AddNTimes
	ret

Function90188: ; 90188
	ld a, [wMapHeaderPermission]
	cp $1
	jr z, .asm_90195
	cp $2
	jr z, .asm_90195
	xor a
	ret

.asm_90195
	scf
	ret

Function90197: ; 90197
	scf
	ret

Function90199: ; 90199 (24:4199)
	ld a, [wLinkMode]
	and a
	jr nz, .asm_901e7
	call Function2d05
	and a
	jr nz, .asm_901e7
	ld a, b
	ld [wdbf9], a
	ld hl, PhoneContacts
	ld bc, 12
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, 4
	add hl, de
	ld a, [hl]
	call Function900ad
	jr z, .asm_901e7
	ld hl, 2
	add hl, de
	ld a, [MapGroup]
	cp [hl]
	jr nz, .asm_901d9
	ld hl, $3
	add hl, de
	ld a, [MapNumber]
	cp [hl]
	jr nz, .asm_901d9
	ld b, BANK(UnknownScript_0x90660)
	ld hl, UnknownScript_0x90660
	jr .asm_901f0

.asm_901d9
	ld hl, $5
	add hl, de
	ld b, [hl]
	ld hl, $6
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .asm_901f0

.asm_901e7
	ld b, BANK(UnknownScript_0x90209)
	ld de, UnknownScript_0x90209
	call Function2674
	ret

.asm_901f0
	ld a, b
	ld [wd002], a
	ld a, l
	ld [wd003], a
	ld a, h
	ld [wd004], a
	ld b, BANK(UnknownScript_0x90205)
	ld de, UnknownScript_0x90205
	call Function2674
	ret
; 90205 (24:4205)

UnknownScript_0x90205: ; 0x90205
	ptcall wd002
	return
; 0x90209

UnknownScript_0x90209: ; 0x90209
	scall UnknownScript_0x90657
	return
; 0x9020d

Function9020d: ; 9020d (24:420d) ;place contect es bank into a and loc into hl
	nop
	nop
	ld a, e
	ld [wdbf9], a
	and a
	jr nz, .asm_9021d
	ld a, BANK(Unknown_90233) ;if 0, use below, else use that number phone contact
	ld hl, Unknown_90233
	jr .asm_90229

.asm_9021d
	ld hl, PhoneContacts
	ld bc, 12
	ld a, e
	call AddNTimes
	ld a, BANK(PhoneContacts)
.asm_90229
	ld de, wd03f
	ld bc, 12
	call FarCopyBytes
	ret
; 90233 (24:4233)

Unknown_90233: ; 90233
	db 0, 0
	dbw BANK(UnknownScript_0x90238), UnknownScript_0x90238
UnknownScript_0x90238:
	writetext UnknownText_0x9023c
	end
UnknownText_0x9023c:
	text_jump UnknownText_0x1c5565
	db "@"
; 90241

UnknownScript_0x90241: ; 0x90241
	refreshscreen $0
	callasm Function9026f
	ptcall wd048
	waitbutton
	callasm Function902eb
	closetext
	callasm Function113e5
	end
; 0x90255

UnknownScript_0x90255:: ; 0x90255
	callasm Function9025c
	jump UnknownScript_0x90241
; 0x9025c

Function9025c: ; 9025c
	ld e, $3
	jp Function9020d
; 90261

UnknownScript_0x90261: ; 0x90261
	callasm Function9026a
	pause 30
	jump UnknownScript_0x90241
; 0x9026a

Function9026a: ; 9026a
	ld e, $4
	jp Function9020d
; 9026f

Function9026f: ; 9026f
	call Function9027c
	call Function9027c
	callba Function1060d3
	ret
; 9027c

Function9027c: ; 9027c (24:427c)
	call Function9033f
	call Function90357
	call Function90292
	call Function90357
	call Function90375
	call Function90357
	call Function90292
	ret

Function90292: ; 90292 (24:4292)
	ld a, [wdbf9]
	ld b, a
	call Function90363
	ret

Function9029a:: ; 9029a
	ld a, b
	ld [DefaultFlypoint], a
	ld a, e
	ld [wd003], a
	ld a, d
	ld [wd004], a
	call Function902b3
	call Function902b3
	callba Function1060d3
	ret
; 902b3

Function902b3: ; 902b3
	call Function9033f
	call Function90357
	call Function902c9
	call Function90357
	call Function90375
	call Function90357
	call Function902c9
	ret
; 902c9

Function902c9: ; 902c9
	call Function90375
	hlcoord 1, 2
	ld [hl], $62
	inc hl
	inc hl
	ld a, [wd002]
	ld b, a
	ld a, [wd003]
	ld e, a
	ld a, [wd004]
	ld d, a
	call Function90069
	ret
; 902e3

Function902e3: ; 902e3 (24:42e3)
	ld de, SFX_NO_SIGNAL
	call PlaySFX
	jr Function902f1

Function902eb:: ; 902eb
	call Function9031d
	call Function90355
Function902f1:
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	call Function9032f
	call Function90355
	call Function9033b
	call Function90355
	ret
; 90316

Function90316: ; 90316
	ld de, SFX_SHUT_DOWN_PC
	call PlaySFX
	ret
; 9031d

Function9031d: ; 9031d
	ld hl, UnknownText_0x9032a
	call PrintText
	ld de, SFX_HANG_UP
	call PlaySFX
	ret
; 9032a

UnknownText_0x9032a: ; 9032a
	text_jump UnknownText_0x1c5580
	db "@"
; 9032f

Function9032f: ; 9032f
	ld hl, UnknownText_0x90336
	call PrintText
	ret
; 90336

UnknownText_0x90336: ; 0x90336
	text_jump UnknownText_0x1c5588
	db "@"
; 0x9033b

Function9033b: ; 9033b
	call SpeechTextBox
	ret
; 9033f

Function9033f: ; 9033f
	call WaitSFX
	ld de, SFX_CALL
	call PlaySFX
	call Function90375
	call Function1ad2
	callba Function4d188
	ret
; 90355

Function90355: ; 90355
	jr Function90357

Function90357
	ld c, 20
	call DelayFrames
	callba Function4d188
	ret
; 90363

Function90363: ; 90363 (24:4363)
	push bc
	call Function90375
	hlcoord 1, 1
	ld [hl], $62
	inc hl
	inc hl
	ld d, h
	ld e, l
	pop bc
	call Function90380
	ret

Function90375: ; 90375
	hlcoord 0, 0
	ld b, $2
	ld c, $12
	call TextBox
	ret
; 90380

Function90380: ; 90380 (24:4380)
	ld h, d
	ld l, e
	ld a, b
	call Function9039a
	call Function903a9
	ret

Function9038a: ; 9038a (24:438a)
	ld a, c
	call Function9039a
	ld a, c
	and a
	ret nz
	ld a, b
	cp $1
	ret z
	cp $4
	ret z
	ld c, $1
	ret

Function9039a: ; 9039a
	push hl
	ld hl, PhoneContacts
	ld bc, 12
	call AddNTimes
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	ret
; 903a9

Function903a9: ; 903a9 (24:43a9)
	ld a, c
	and a
	jr z, .asm_903c5
	call Function90423
	push hl
	push bc
	call PlaceString
	ld a, ":"
	ld [bc], a
	pop bc
	pop hl
	ld de, 20 + 3
	add hl, de
	call Function9042e
	call PlaceString
	ret

.asm_903c5
	push hl
	ld c, b
	ld b, 0
	ld hl, Unknown_903d6
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	call PlaceString
	ret
; 903d6 (24:43d6)

Unknown_903d6: ; 903d6
	dw String_903e2
	dw String_903ed
	dw String_90402
	dw String_903f2
	dw String_903f8
	dw String_9040d

String_903e2: db "----------@"
String_903ed: db "MOM:@"
String_903f2: db "BILL:@"
String_903f8: db "PROF.ELM:@"
String_90402: db "BIKE SHOP:@"
String_9040d: db "BUENA:", $22, "   DISC JOCKEY@"
; 90423

Function90423: ; 90423 (24:4423)
	push hl
	push bc
	callba Function3994c
	pop bc
	pop hl
	ret

Function9042e: ; 9042e (24:442e)
	push hl
	push bc
	callba Function3952d
	pop bc
	pop hl
	ret

Function90439: ; 90439 from 2a4ab
	ld a, [wdbf9]
	call Function9039a
	ld d, c
	ld e, b
	push de
	ld a, [wdbf9]
	ld hl, PhoneContacts + 2
	ld bc, 12
	call AddNTimes
	ld b, [hl]
	inc hl
	ld c, [hl]
	push bc
	call GetWorldMapLocation
	ld e, a
	callba GetLandmarkName
	pop bc
	pop de
	ret
; 9045f

PhoneContacts: ; 9045f
phone: MACRO
	db  \1, \2 ; trainer
	map \3     ; map
	db  \4
	dbw BANK(\5), \5 ; script 1
	db  \6
	dbw BANK(\7), \7 ; script 2
ENDM
	phone 0, 0, N_A,                            0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone 0, 1, KRISS_HOUSE_1F,                 7, MomPhoneScript, 0, UnusedPhoneScript
	phone 0, 2, OAKS_LAB,                       0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone 0, 3, N_A,                            7, BillPhoneScript1, 0, BillPhoneScript2
	phone 0, 4, ELMS_LAB,                       7, ElmPhoneScript1, 0, ElmPhoneScript2
	phone SCHOOLBOY, JACK1, NATIONAL_PARK,      7, UnknownScript_0xbd0d0, 7, UnknownScript_0xbd0fa
	phone POKEFANF, BEVERLY1, NATIONAL_PARK,    7, UnknownScript_0xbd13f, 7, UnknownScript_0xbd158
	phone SAILOR, HUEY1, OLIVINE_LIGHTHOUSE_2F, 7, UnknownScript_0xbd17c, 7, UnknownScript_0xbd1a9
	phone 0, 0, N_A,                            0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone 0, 0, N_A,                            0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone 0, 0, N_A,                            0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone COOLTRAINERM, GAVEN3, ROUTE_26,       7, UnknownScript_0xbd1da, 7, UnknownScript_0xbd204
	phone COOLTRAINERF, BETH1, ROUTE_26,        7, UnknownScript_0xbd23d, 7, UnknownScript_0xbd267
	phone BIRD_KEEPER, JOSE2, ROUTE_27,         7, UnknownScript_0xbd294, 7, UnknownScript_0xbd2cb
	phone COOLTRAINERF, REENA1, ROUTE_27,       7, UnknownScript_0xbd31c, 7, UnknownScript_0xbd346
	phone YOUNGSTER, JOEY1, ROUTE_30,           7, UnknownScript_0xbd373, 7, UnknownScript_0xbd3a0
	phone BUG_CATCHER, WADE1, ROUTE_31,         7, UnknownScript_0xbd3d1, 7, UnknownScript_0xbd428
	phone FISHER, RALPH1, ROUTE_32,             7, UnknownScript_0xbd4d2, 7, UnknownScript_0xbd509
	phone PICNICKER, LIZ1, ROUTE_32,            7, UnknownScript_0xbd560, 7, UnknownScript_0xbd58d
	phone HIKER, ANTHONY2, ROUTE_33,            7, UnknownScript_0xbd634, 7, UnknownScript_0xbd66b
	phone CAMPER, TODD1, ROUTE_34,              7, UnknownScript_0xbd6c1, 7, UnknownScript_0xbd6f5
	phone PICNICKER, GINA1, ROUTE_34,           7, UnknownScript_0xbd743, 7, UnknownScript_0xbd784
	phone JUGGLER, IRWIN1, ROUTE_35,            7, UnknownScript_0xbd7e7, 7, UnknownScript_0xbd7fd
	phone BUG_CATCHER, ARNIE1, ROUTE_35,        7, UnknownScript_0xbd813, 7, UnknownScript_0xbd84a
	phone SCHOOLBOY, ALAN1, ROUTE_36,           7, UnknownScript_0xbd8a6, 7, UnknownScript_0xbd8dd
	phone 0, 0, N_A,                            0, UnusedPhoneScript, 0, UnusedPhoneScript
	phone LASS, DANA1, ROUTE_38,                7, UnknownScript_0xbd930, 7, UnknownScript_0xbd967
	phone SCHOOLBOY, CHAD1, ROUTE_38,           7, UnknownScript_0xbd9c6, 7, UnknownScript_0xbd9f0
	phone POKEFANM, DEREK1, ROUTE_39,           7, UnknownScript_0xbda35, 7, UnknownScript_0xbda6e
	phone FISHER, TULLY1, ROUTE_42,             7, UnknownScript_0xbdaac, 7, UnknownScript_0xbdae3
	phone POKEMANIAC, BRENT1, ROUTE_43,         7, UnknownScript_0xbdb36, 7, UnknownScript_0xbdb60
	phone PICNICKER, TIFFANY3, ROUTE_43,        7, UnknownScript_0xbdb99, 7, UnknownScript_0xbdbd0
	phone BIRD_KEEPER, VANCE1, ROUTE_44,        7, UnknownScript_0xbdc73, 7, UnknownScript_0xbdc9d
	phone FISHER, WILTON1, ROUTE_44,            7, UnknownScript_0xbdcce, 7, UnknownScript_0xbdd05
	phone BLACKBELT_T, KENJI3, ROUTE_45,        7, UnknownScript_0xbdd71, 7, UnknownScript_0xbdd7d
	phone HIKER, PARRY1, ROUTE_45,              7, UnknownScript_0xbdd89, 7, UnknownScript_0xbddb3
	phone PICNICKER, ERIN1, ROUTE_46,           7, UnknownScript_0xbdde4, 7, UnknownScript_0xbde0e
	phone 0, 5, GOLDENROD_DEPT_STORE_ROOF,      7, UnknownScript_0xa0b14, 7, UnknownScript_0xa0b26
; 90627

Unknown_90627: ; 90627
	dw Function90188
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
	dw Function90188
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
	dw Function90188
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
	dw Function90188
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
	dw Function90197
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
	dw Function90197
	db $02
	dbw BANK(UnknownScript_0xa0b09), UnknownScript_0xa0b09 ; bike shop
	dw Function90197
	db $01
	dbw BANK(MomPhoneLectureScript), MomPhoneLectureScript
	dw Function90188
	db $04
	dbw BANK(ElmPhoneScript2), ElmPhoneScript2
; 90657

UnknownScript_0x90657: ; 0x90657
	writetext UnknownText_0x9065b
	end
; 0x9065b

UnknownText_0x9065b: ; 0x9065b
	; That number is out of the area.
	text_jump UnknownText_0x1c558b
	db "@"
; 0x90660

UnknownScript_0x90660: ; 0x90660
	writetext UnknownText_0x90664
	end
; 0x90664

UnknownText_0x90664: ; 0x90664
	; Just go talk to that person!
	text_jump UnknownText_0x1c55ac
	db "@"
; 0x90669

UnknownScript_0x90669: ; 0x90669
	writetext UnknownText_0x9066d
	end
; 0x9066d

UnknownText_0x9066d: ; 0x9066d
	; Thank you!
	text_jump UnknownText_0x1c55ca
	db "@"
; 0x90672

LoadMaplessEnvironment:
	call ClearTileMap
	call ClearSprites
	ld b, $8
	call GetSGBLayout
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Functione51
	ret

SetTimeOfDay: ; 90672 (24:4672)
	ld a, [$ffaa]
	push af
	ld a, $1
	ld [$ffaa], a
	ld a, $0
	ld [wc2ce], a
	ld a, $10
	ld [MusicFade], a
	ld a, MUSIC_NONE % $100
	ld [MusicFadeIDLo], a
	ld a, MUSIC_NONE / $100
	ld [MusicFadeIDHi], a
	ld c, 8
	call DelayFrames
	call Function4dd
	call ClearTileMap
	call ClearSprites
	ld b, $8
	call GetSGBLayout
	xor a
	ld [hBGMapMode], a ; $ff00+$d4
	call Functione51
	ld de, GFX_908fb
	ld hl, $9000
	lb bc, BANK(GFX_908fb), 1
	call Request1bpp
	ld de, GFX_90903
	ld hl, $9010
	lb bc, BANK(GFX_90903), 1
	call Request1bpp
	ld de, GFX_9090b
	ld hl, $9020
	lb bc, BANK(GFX_9090b), 1
	call Request1bpp
	call Function90783
	call WaitBGMap
	call Function4a3
	ld hl, UnknownText_0x90874
	call PrintText
	ld hl, wc608
	ld bc, $32
	xor a
	call ByteFill
	ld a, $a
	ld [wc608 + 20], a
.asm_906e8
	ld hl, UnknownText_0x90879
	call PrintText
	hlcoord 3, 7
	ld b, $2
	ld c, $f
	call TextBox
	hlcoord 11, 7
	ld [hl], $1
	hlcoord 11, 10
	ld [hl], $2
	hlcoord 4, 9
	call Function907de
	ld c, $a
	call DelayFrames
.asm_9070d
	call Functiona57
	call Function90795
	jr nc, .asm_9070d
	ld a, [wc608 + 20]
	ld [StringBuffer2 + 1], a
	call Function90783
	ld hl, UnknownText_0x90886
	call PrintText
	call YesNoBox
	jr nc, .asm_9072e
	call Function90783
	jr .asm_906e8

.asm_9072e

	ret