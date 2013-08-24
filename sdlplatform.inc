//from sdl_platform.h

{**
 *  Gets the name of the platform.
 *}
function SDL_GetPlatform: PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetPlatform' {$ELSE} SDL_LibName {$ENDIF};