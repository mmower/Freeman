//
//  FreemanKeyMapper.m
//  Freeman
//
//  Created by Matt Mower on 20/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanKeyMapper.h"

int mapKeyCodeToFavouriteNumber( CGKeyCode keyCode ) {
	switch( keyCode ) {
		case 18:
			return 1;
		case 19:
			return 2;
		case 20:
			return 3;
		case 21:
			return 4;
		case 23:
		return 5;
		case 22:
			return 6;
		case 26:
			return 7;
		case 28:
			return 8;
		case 25:
			return 9;
		case 29:
			return 10;
		default:
			return 0;
	}
}


// int favouriteNumberFromCGEvent( CGEventRef ref ) {
// 	
// 	if( CGEventSourceKeyState( ))
// 	
// 	
// }