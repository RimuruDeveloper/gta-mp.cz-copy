new Text:logo[2];

stock textdraw_Create()
{
	logo[1] = TextDrawCreate(500.000000, 4.000000, "GTA-MULTIPLAYER.CZ");
	TextDrawLetterSize(logo[1], 0.300000, 1.500000);
	TextDrawTextSize(logo[1], 1280.000000, 1280.000000);
	TextDrawAlignment(logo[1], 0);
	TextDrawColor(logo[1], 0xFF6600FF);
	TextDrawUseBox(logo[1], 0);
	TextDrawBoxColor(logo[1], 0x80808080);
	TextDrawSetShadow(logo[1], 2);
	TextDrawSetOutline(logo[1], 1);
	TextDrawBackgroundColor(logo[1], 0xFFFFFFFF);
	TextDrawFont(logo[1], 1);
	TextDrawSetProportional(logo[1], 1);
	TextDrawSetSelectable(logo[1], 0);

	logo[0] = TextDrawCreate(500.000000, 4.000000, "GTA-MULTIPLAYER");
	TextDrawLetterSize(logo[0], 0.300000, 1.500000);
	TextDrawTextSize(logo[0], 1280.000000, 1280.000000);
	TextDrawAlignment(logo[0], 0);
	TextDrawColor(logo[0], 0x000000FF);
	TextDrawUseBox(logo[0], 0);
	TextDrawBoxColor(logo[0], 0x80808080);
	TextDrawSetShadow(logo[0], 2);
	TextDrawSetOutline(logo[0], 1);
	TextDrawBackgroundColor(logo[0], 0xFFFFFFFF);
	TextDrawFont(logo[0], 1);
	TextDrawSetProportional(logo[0], 1);
	TextDrawSetSelectable(logo[0], 0);
}