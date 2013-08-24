//from sdl_loadso.h

{**
 *  This function dynamically loads a shared object and returns a pointer
 *  to the object handle (or NULL if there was an error).
 *  The 'sofile' parameter is a system dependent name of the object file.
 *}
function SDL_LoadObject(sofile: PAnsiChar): Pointer;

{**
 *  Given an object handle, this function looks up the address of the
 *  named function in the shared object and returns it.  This address
 *  is no longer valid after calling SDL_UnloadObject().
 *}
function SDL_LoadFunction(handle: Pointer; name: PAnsiChar): Pointer;

{**
 *  Unload a shared object from memory.
 *}
procedure SDL_UnloadObject(handle: Pointer);
