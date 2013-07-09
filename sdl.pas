unit SDL;

{
  Simple DirectMedia Layer
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Conversion
  Copyright (C) 2012/13 Tim Blume aka End

  SDL.pas is based on the files:
  "sdl.h",
 	"sdl_main.h",
  "sdltype_s.h",
	"sdl_stdinc.h",
	"sdl_events.h",
  "sdl_keyboard.h",
  "sdl_keycode.h",
  "sdl_scancode.h",
  "sdl_mouse.h",
  "sdl_video.h",
  "sdl_pixels.h",
  "sdl_surface.h",
  "sdl_rwops.h",
	"sdl_blendmode.h",
	"sdl_rect.h",
  "sdl_joystick.h",
  "sdl_touch.h",
  "sdl_gesture.h",
  "sdl_error.h",
  "sdl_version.h",
  "sdl_render.h"

  I will not translate:
  "sdl_opengl.h",
  "sdl_opengles.h"
  "sdl_opengles2.h"

  cause there's a much better OpenGL-Header avaible at delphigl.com:

  the dglopengl.pas

  Parts of the SDL.pas are from the SDL-1.2-Headerconversion from the JEDI-Team,
  written by Domenique Louis and others.

  I've changed the names of the dll for 32 & 64-Bit, so theres no conflict
  between 32 & 64 bit Libraries.

  This software is provided 'as-is', without any express or implied
  warranty.  In no case will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  Special Thanks to:

   - DelphiGL.com - Community
   - Domenique Louis and everyone else from the JEDI-Team
   - Sam Latinga and everyone else from the SDL-Team
}

{
  Changelog:
  ----------
  v.1.0; 05.07.2013: Initial Alpha-Release.
}

{$DEFINE SDL}

{$I sdl.inc}

interface

uses
  {$IFDEF WINDOWS}
    Windows;
  {$ENDIF}

const

  {$IFDEF WINDOWS}
    {$IFDEF WIN32}
      SDL_LibName = 'SDL2_x86.dll';
	  {$ENDIF}
	  {$IFDEF WIN64}
	    SDL_LibName = 'SDL2_x86_x64.dll';
   	{$ENDIF}
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      SDL_LibName = 'libSDL-2.dylib';
    {$ELSE}
      {$IFDEF FPC}
        SDL_LibName = 'libSDL-2.so';
      {$ELSE}
        SDL_LibName = 'libSDL-2.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    SDL_LibName = 'SDL2';
    {$linklib libSDL}
  {$ENDIF}

  //types from SDLtype_s.h / SDL_stdinc.h
type

  TSDL_Bool = (SDL_FALSE,SDL_TRUE);

  DWord = LongWord;

  PUInt8Array = ^TUInt8Array;
  PUInt8 = ^UInt8;
  UInt8 = Byte;
  {$EXTERNALSYM UInt8}
  TUInt8Array = array [0..MAXINT shr 1] of UInt8;

  PUInt16 = ^UInt16;
  UInt16 = word;
  {$EXTERNALSYM UInt16}

  PSInt8 = ^SInt8;
  SInt8 = Shortint;
  {$EXTERNALSYM SInt8}

  PSInt16 = ^SInt16;
  SInt16 = smallint;
  {$EXTERNALSYM SInt16}

  PUInt32 = ^UInt32;
  UInt32 = Cardinal;
  {$EXTERNALSYM UInt32}

  SInt32 = LongInt;
  {$EXTERNALSYM SInt32}

  PFloat = ^Float;
  PInt = ^LongInt;

  PShortInt = ^ShortInt;

  PUInt64 = ^UInt64;
  UInt64 = record
    hi: UInt32;
    lo: UInt32;
  end;
  {$EXTERNALSYM UInt64}

  PSInt64 = ^SInt64;
  SInt64 = record
    hi: UInt32;
    lo: UInt32;
  end;
  {$EXTERNALSYM SInt64}

  {$IFDEF WIN64}
    size_t = UInt32;
  {$ELSE}
    size_t = UInt64;
  {$ENDIF}
  {$EXTERNALSYM SIZE_T}

  Float = Single;
  {$EXTERNALSYM Float}

  //from "sdl_version.h"

  {**
   *  Information the version of SDL in use.
   *
   *  Represents the library's version as three levels: major revision
   *  (increments with massive changes, additions, and enhancements),
   *  minor revision (increments with backwards-compatible changes to the
   *  major revision), and patchlevel (increments with fixes to the minor
   *  revision).
   *
   *  SDL_VERSION
   *  SDL_GetVersion
   *}
type
  PSDL_Version = ^TSDL_Version;
  TSDL_Version = record
    major,         {**< major version *}
    minor,         {**< minor version *}
    patch: UInt8;  {**< update version *}
  end;

{* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL
*}
const
  SDL_MAJOR_VERSION = 2;
  SDL_MINOR_VERSION = 0;
  SDL_PATCHLEVEL    = 0;

{**
 *  Macro to determine SDL version program was compiled against.
 *
 *  This macro fills in a SDL_version structure with the version of the
 *  library you compiled against. This is determined by what header the
 *  compiler uses. Note that if you dynamically linked the library, you might
 *  have a slightly newer or older version at runtime. That version can be
 *  determined with SDL_GetVersion(), which, unlike SDL_VERSION(),
 *  is not a macro.
 *
 *   x A pointer to a SDL_version struct to initialize.
 *
 *  SDL_version
 *  SDL_GetVersion
 *}
procedure SDL_VERSION(x: PSDL_Version);

{**
 *  This macro turns the version numbers into a numeric value:
 *
 *  (1,2,3) -> (1203)
 *
 *
 *  This assumes that there will never be more than 100 patchlevels.
 *}
function SDL_VERSIONNUM(X,Y,Z: UInt32): Cardinal;

  {**
   *  This is the version number macro for the current SDL version.
   *}
function SDL_COMPILEDVERSION: Cardinal;

  {**
   *  This macro will evaluate to true if compiled with SDL at least X.Y.Z.
   *}
function SDL_VERSION_ATLEAST(X,Y,Z: Cardinal): Boolean;

  {**
   *  Get the version of SDL that is linked against your program.
   *
   *  If you are linking to SDL dynamically, then it is possible that the
   *  current version will be different than the version you compiled against.
   *  This function returns the current version, while SDL_VERSION() is a
   *  macro that tells you what version you compiled with.
   *
   *
   *  SDL_version compiled;
   *  SDL_version linked;
   *
   *  SDL_VERSION(&compiled);
   *  SDL_GetVersion(&linked);
   *  printf("We compiled against SDL version %d.%d.%d ...\n",
   *         compiled.major, compiled.minor, compiled.patch);
   *  printf("But we linked against SDL version %d.%d.%d.\n",
   *         linked.major, linked.minor, linked.patch);
   *
   *
   *  This function may be called safely at any time, even before SDL_Init().
   *
   *  SDL_VERSION
   *}
procedure SDL_GetVersion(ver: PSDL_Version) cdecl; external {$IFDEF GPC} name 'SDL_GetVersion' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the code revision of SDL that is linked against your program.
   *
   *  Returns an arbitrary string (a hash value) uniquely identifying the
   *  exact revision of the SDL library in use, and is only useful in comparing
   *  against other revisions. It is NOT an incrementing number.
   *}
function SDL_GetRevision: PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetRevision' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the revision number of SDL that is linked against your program.
   *
   *  Returns a number uniquely identifying the exact revision of the SDL
   *  library in use. It is an incrementing number based on commits to
   *  hg.libsdl.org.
   *}
function SDL_GetRevisionNumber: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRevisionNumber' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_error.h"

  {* Public functions *}

  {* SDL_SetError() unconditionally returns -1. *}
function SDL_SetError(const fmt: PAnsiChar): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetError' {$ELSE} SDL_LibName {$ENDIF};
function SDL_GetError: PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetError' {$ELSE} SDL_LibName {$ENDIF};
procedure SDL_ClearError cdecl; external {$IFDEF GPC} name 'SDL_ClearError' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Internal error functions
   *
   *  Private error reporting function - used internally.
   *}

    {
#define SDL_OutOfMemory()   SDL_Error(SDL_ENOMEM)
#define SDL_Unsupported()   SDL_Error(SDL_UNSUPPORTED)
#define SDL_InvalidParamError(param)    SDL_SetError("Parameter '%s' is invalid", (param))
   }

type
  TSDL_ErrorCode = (SDL_ENOMEM,
                    SDL_EFREAD,
                    SDL_EFWRITE,
                    SDL_EFSEEK,
                    SDL_UNSUPPORTED,
                    SDL_LASTERROR);

  {* SDL_Error() unconditionally returns -1. *}
function SDL_Error(code: TSDL_ErrorCode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_Error' {$ELSE} SDL_LibName {$ENDIF};
  {*Internal error functions*}

  //from "sdl_pixels.h"

  {**
   *  Transparency definitions
   *
   *  These define alpha as the opacity of a surface.
   *}

  const
    SDL_ALPHA_OPAQUE = 255;
    SDL_ALPHA_TRANSPARENT = 0;

    {** Pixel type. *}
    
    SDL_PIXELTYPE_UNKNOWN = 0;
    SDL_PIXELTYPE_INDEX1 = 1;
    SDL_PIXELTYPE_INDEX4 = 2;
    SDL_PIXELTYPE_INDEX8 = 3;
    SDL_PIXELTYPE_PACKED8 = 4;
    SDL_PIXELTYPE_PACKED16 = 5;
    SDL_PIXELTYPE_PACKED32 = 6;
    SDL_PIXELTYPE_ARRAYU8 = 7;
    SDL_PIXELTYPE_ARRAYU16 = 8;
    SDL_PIXELTYPE_ARRAYU32 = 9;
    SDL_PIXELTYPE_ARRAYF16 = 10;
    SDL_PIXELTYPE_ARRAYF32 = 11;

    {** Bitmap pixel order, high bit -> low bit. *}

    SDL_BITMAPORDER_NONE = 0;
    SDL_BITMAPORDER_4321 = 1;
    SDL_BITMAPORDER_1234 = 2;

    {** Packed component order, high bit -> low bit. *}

    SDL_PACKEDORDER_NONE = 0;
    SDL_PACKEDORDER_XRGB = 1;
    SDL_PACKEDORDER_RGBX = 2;
    SDL_PACKEDORDER_ARGB = 3;
    SDL_PACKEDORDER_RGBA = 4;
    SDL_PACKEDORDER_XBGR = 5;
    SDL_PACKEDORDER_BGRX = 6;
    SDL_PACKEDORDER_ABGR = 7;
    SDL_PACKEDORDER_BGRA = 8;

    {** Array component order, low byte -> high byte. *}

    SDL_ARRAYORDER_NONE = 0;
    SDL_ARRAYORDER_RGB = 1;
    SDL_ARRAYORDER_RGBA = 2;
    SDL_ARRAYORDER_ARGB = 3;
    SDL_ARRAYORDER_BGR = 4;
    SDL_ARRAYORDER_BGRA = 5;
    SDL_ARRAYORDER_ABGR = 6;

    {** Packed component layout. *}

    SDL_PACKEDLAYOUT_NONE = 0;
    SDL_PACKEDLAYOUT_332 = 1;
    SDL_PACKEDLAYOUT_4444 = 2;
    SDL_PACKEDLAYOUT_1555 = 3;
    SDL_PACKEDLAYOUT_5551 = 4;
    SDL_PACKEDLAYOUT_565 = 5;
    SDL_PACKEDLAYOUT_8888 = 6;
    SDL_PACKEDLAYOUT_2101010 = 7;
    SDL_PACKEDLAYOUT_1010102 = 8;

    {
        //todo!!
function SDL_DEFINE_PIXELFOURCC(A,B,C,D: Variant): Variant;

#define SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
     ((bits) << 8) | ((bytes) << 0))
       }

function SDL_PIXELFLAG(X: Cardinal): Boolean;
function SDL_PIXELTYPE(X: Cardinal): Boolean;
function SDL_PIXELORDER(X: Cardinal): Boolean;
function SDL_PIXELLAYOUT(X: Cardinal): Boolean;
function SDL_BITSPERPIXEL(X: Cardinal): Boolean;
     {
#define SDL_BYTESPERPIXEL(X) \
    (SDL_ISPIXELFORMAT_FOURCC(X) ? \
        ((((X) == SDL_PIXELFORMAT_YUY2) || \
          ((X) == SDL_PIXELFORMAT_UYVY) || \
          ((X) == SDL_PIXELFORMAT_YVYU)) ? 2 : 1) : (((X) >> 0) & 0xFF))

#define SDL_ISPIXELFORMAT_INDEXED(format)   \
    (!SDL_ISPIXELFORMAT_FOURCC(format) && \
     ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || \
      (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))

#define SDL_ISPIXELFORMAT_ALPHA(format)   \
    (!SDL_ISPIXELFORMAT_FOURCC(format) && \
     ((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || \
      (SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA)))

  function SDL_IsPixelFormat_FOURCC(format: Variant);

  {* Note: If you modify this list, update SDL_GetPixelFormatName() *}

const
    SDL_PIXELFORMAT_UNKNOWN = 0;
    SDL_PIXELFORMAT_INDEX1LSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX1 shl 24) or
                                (SDL_BITMAPORDER_4321 shl 20) or
                                (0 shl 16)                    or
                                (1 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX1MSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX1 shl 24) or
                                (SDL_BITMAPORDER_1234 shl 20) or
                                (0 shl 16)                    or
                                (1 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX4LSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX4 shl 24) or
                                (SDL_BITMAPORDER_4321 shl 20) or
                                (0 shl 16)                    or
                                (4 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX4MSB = (1 shl 28)                    or
                                (SDL_PIXELTYPE_INDEX4 shl 24) or
                                (SDL_BITMAPORDER_1234 shl 20) or
                                (0 shl 16)                    or
                                (4 shl 8)                     or
                                (0 shl 0);

    SDL_PIXELFORMAT_INDEX8 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED8 shl 24)  or
                                (0 shl 20)                      or
                                (0 shl 16)                      or
                                (8 shl 8)                       or
                                (1 shl 0);
                                
    SDL_PIXELFORMAT_RGB332 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED8 shl 24)  or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_332 shl 16)   or
                                (8 shl 8)                       or
                                (1 shl 0);

    SDL_PIXELFORMAT_RGB444 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (12 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB555 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (15 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGR555 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (15 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ARGB4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGBA4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ABGR4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGRA4444 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_BGRA shl 20)   or
                                (SDL_PACKEDLAYOUT_4444 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ARGB1555 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGBA5551 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_5551 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_ABGR1555 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGRA5551 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_BGRA shl 20)   or
                                (SDL_PACKEDLAYOUT_5551 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB565 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_565 shl 16)   or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_BGR565 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED16 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_1555 shl 16)  or
                                (16 shl 8)                      or
                                (2 shl 0);

    SDL_PIXELFORMAT_RGB24 =     (1 shl 28)                      or
                                (SDL_PIXELTYPE_ARRAYU8 shl 24)  or
                                (SDL_ARRAYORDER_RGB shl 20)     or
                                (0 shl 16)                      or
                                (24 shl 8)                      or
                                (3 shl 0);

    SDL_PIXELFORMAT_BGR24 =     (1 shl 28)                      or
                                (SDL_PIXELTYPE_ARRAYU8 shl 24)  or
                                (SDL_ARRAYORDER_BGR shl 20)     or
                                (0 shl 16)                      or
                                (24 shl 8)                      or
                                (3 shl 0);

    SDL_PIXELFORMAT_RGB888 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_XRGB shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_RGBX8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGR888 =    (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_XBGR shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGRX8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_BGRX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (24 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ARGB8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_ARGB shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_RGBA8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBA shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ABGR8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_ABGR shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_BGRA8888 =  (1 shl 28)                      or
                                (SDL_PIXELTYPE_PACKED32 shl 24) or
                                (SDL_PACKEDORDER_RGBX shl 20)   or
                                (SDL_PACKEDLAYOUT_8888 shl 16)  or
                                (32 shl 8)                      or
                                (4 shl 0);

    SDL_PIXELFORMAT_ARGB2101010 = (1 shl 28)                       or
                                  (SDL_PIXELTYPE_PACKED32 shl 24)  or
                                  (SDL_PACKEDORDER_ARGB shl 20)    or
                                  (SDL_PACKEDLAYOUT_2101010 shl 16)or
                                  (32 shl 8)                       or
                                  (4 shl 0);

    {**< Planar mode: Y + V + U  (3 planes) *}
    SDL_PIXELFORMAT_YV12 = (Integer('Y')       ) or
                           (Integer('V') shl  8) or
                           (Integer('1') shl 16) or
                           (Integer('2') shl 24);
    {**< Planar mode: Y + U + V  (3 planes) *}
    SDL_PIXELFORMAT_IYUV = (Integer('I')       ) or
                           (Integer('Y') shl  8) or
                           (Integer('U') shl 16) or
                           (Integer('V') shl 24);
    {**< Packed mode: Y0+U0+Y1+V0 (1 plane) *}
    SDL_PIXELFORMAT_YUY2 = (Integer('Y')       ) or
                           (Integer('U') shl  8) or
                           (Integer('Y') shl 16) or
                           (Integer('2') shl 24);
    {**< Packed mode: U0+Y0+V0+Y1 (1 plane) *}
    SDL_PIXELFORMAT_UYVY = (Integer('U')       ) or
                           (Integer('Y') shl  8) or
                           (Integer('V') shl 16) or
                           (Integer('Y') shl 24);
    {**< Packed mode: Y0+V0+Y1+U0 (1 plane) *}
    SDL_PIXELFORMAT_YVYU = (Integer('Y')       ) or
                           (Integer('V') shl  8) or
                           (Integer('Y') shl 16) or
                           (Integer('U') shl 24);

type
  PSDL_Color = ^TSDL_Color;
  TSDL_Color = record
    r: UInt8;
    g: UInt8;
    b: UInt8;
    unused: UInt8;
  end;

  TSDL_Colour = TSDL_Color;
  PSDL_Colour = ^TSDL_Colour;

  PSDL_Palette = ^TSDL_Palette;
  TSDL_Palette = record
    ncolors: SInt32;
    colors: PSDL_Color;
    version: UInt32;
    refcount: SInt32;
  end;

  {**
   *  Everything in the pixel format structure is read-only.
   *}

  PSDL_PixelFormat = ^TSDL_PixelFormat;
  TSDL_PixelFormat = record
    format: UInt32;
    palette: PSDL_Palette;
    BitsPerPixel: UInt8;
    BytesPerPixel: UInt8;
    padding: array[0..1] of UInt8;
    Rmask: UInt32;
    Gmask: UInt32;
    Bmask: UInt32;
    Amask: UInt32;
    Rloss: UInt8;
    Gloss: UInt8;
    Bloss: UInt8;
    Aloss: UInt8;
    Rshift: UInt8;
    Gshift: UInt8;
    Bshift: UInt8;
    Ashift: UInt8;
    refcount: SInt32;
    next: PSDL_PixelFormat;
  end;

  {**
   *  Get the human readable name of a pixel format
   *}

function SDL_GetPixelFormatName(format: UInt32): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetPixelFormatName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Convert one of the enumerated pixel formats to a bpp and RGBA masks.
   *
   *  SDL_TRUE, or SDL_FALSE if the conversion wasn't possible.
   *
   *  SDL_MasksToPixelFormatEnum()
   *}

function SDL_PixelFormatEnumToMasks(format: UInt32; bpp: PInt; Rmask: PUInt32; Gmask: PUInt32; Bmask: PUInt32; Amask: PUInt32): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_PixelFormatEnumToMasks' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Convert a bpp and RGBA masks to an enumerated pixel format.
   *
   *  The pixel format, or SDL_PIXELFORMAT_UNKNOWN if the conversion
   *  wasn't possible.
   *
   *  SDL_PixelFormatEnumToMasks()
   *}

function SDL_MasksToPixelFormatEnum(bpp: SInt32; Rmask: UInt32; Gmask: UInt32; Bmask: UInt32; Amask: UInt32): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_MasksToPixelFormatEnum' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create an SDL_PixelFormat structure from a pixel format enum.
   *}

function SDL_AllocFormat(pixel_format: UInt32): PSDL_PixelFormat cdecl; external {$IFDEF GPC} name 'SDL_AllocFormat' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Free an SDL_PixelFormat structure.
   *}

procedure SDL_FreeFormat(format: PSDL_PixelFormat) cdecl; external {$IFDEF GPC} name 'SDL_FreeFormat' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a palette structure with the specified number of color
   *  entries.
   *
   *  A new palette, or nil if there wasn't enough memory.
   *
   *  The palette entries are initialized to white.
   *  
   *  SDL_FreePalette()
   *}

function SDL_AllocPalette(ncolors: SInt32): PSDL_Palette cdecl; external {$IFDEF GPC} name 'SDL_AllocPalette' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the palette for a pixel format structure.
   *}

function SDL_SetPixelFormatPalette(format: PSDL_PixelFormat; palette: PSDL_Palette): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetPixelFormatPalette' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set a range of colors in a palette.
   *
   *  palette    The palette to modify.
   *  colors     An array of colors to copy into the palette.
   *  firstcolor The index of the first palette entry to modify.
   *  ncolors    The number of entries to modify.
   *
   *  0 on success, or -1 if not all of the colors could be set.
   *}

function SDL_SetPaletteColors(palette: PSDL_Palette; const colors: PSDL_Color; firstcolor: SInt32; ncolors: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetPaletteColors' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Free a palette created with SDL_AllocPalette().
   *
   *  SDL_AllocPalette()
   *}

procedure SDL_FreePalette(palette: PSDL_Palette) cdecl; external {$IFDEF GPC} name 'SDL_FreePalette' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Maps an RGB triple to an opaque pixel value for a given pixel format.
   *
   *  SDL_MapRGBA
   *}

function SDL_MapRGB(const format: PSDL_PixelFormat; r: UInt8; g: UInt8; b: UInt8): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_MapRGB' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Maps an RGBA quadruple to a pixel value for a given pixel format.
   *
   *  SDL_MapRGB
   *}

function SDL_MapRGBA(const format: PSDL_PixelFormat; r: UInt8; g: UInt8; b: UInt8; a: UInt8): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_MapRGBA' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the RGB components from a pixel of the specified format.
   *
   *  SDL_GetRGBA
   *}

procedure SDL_GetRGB(pixel: UInt32; const format: PSDL_PixelFormat; r: PUInt8; g: PUInt8; b: PUInt8) cdecl; external {$IFDEF GPC} name 'SDL_GetRGB' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the RGBA components from a pixel of the specified format.
   *
   *  SDL_GetRGB
   *}

procedure SDL_GetRGBA(pixel: UInt32; const format: PSDL_PixelFormat; r: PUInt8; g: PUInt8; b: PUInt8; a: PUInt8) cdecl; external {$IFDEF GPC} name 'SDL_GetRGBA' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Calculate a 256 entry gamma ramp for a gamma value.
   *}

procedure SDL_CalculateGammaRamp(gamma: Float; ramp: PUInt16) cdecl; external {$IFDEF GPC} name 'SDL_CalculateGammaRamp' {$ELSE} SDL_LibName {$ENDIF};

//from "sdl_rect.h"

type
  {**
   *  The structure that defines a point
   *
   *  SDL_EnclosePoints
   *}

  PSDL_Point = ^TSDL_Point;
  TSDL_Point = record
    x: SInt32;
    y: SInt32;
  end;

  {**
   *  A rectangle, with the origin at the upper left.
   *
   *  SDL_RectEmpty
   *  SDL_RectEquals
   *  SDL_HasIntersection
   *  SDL_IntersectRect
   *  SDL_UnionRect
   *  SDL_EnclosePoints
   *}

  PSDL_Rect = ^TSDL_Rect;
  TSDL_Rect = record
    x,y: SInt32;
    w,h: SInt32;
  end;

  {**
   *  Returns true if the rectangle has no area.
   *}

  //changed from variant(bäääääh!) to TSDL_Rect
  //maybe PSDL_Rect?
function SDL_RectEmpty(X: TSDL_Rect): Boolean;

    {**
     *  Returns true if the two rectangles are equal.
     *}

function SDL_RectEquals(A: TSDL_Rect; B: TSDL_Rect): Boolean;

  {**
   *  Determine whether two rectangles intersect.
   *
   *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
   *}

function SDL_HasIntersection(const A: PSDL_Rect; const B: PSDL_Rect): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_HasIntersection' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Calculate the intersection of two rectangles.
   *
   *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
   *}

function SDL_IntersectRect(const A: PSDL_Rect; const B: PSDL_Rect; result: PSDL_Rect): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_IntersectRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Calculate the union of two rectangles.
   *}

procedure SDL_UnionRect(const A: PSDL_Rect; const B: PSDL_Rect; result: PSDL_Rect) cdecl; external {$IFDEF GPC} name 'SDL_UnionRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Calculate a minimal rectangle enclosing a set of points
   *
   *  SDL_TRUE if any points were within the clipping rect
   *}

function SDL_EnclosePoints(const points: PSDL_Point; count: SInt32; const clip: PSDL_Rect; result: PSDL_Rect): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_EnclosePoints' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Calculate the intersection of a rectangle and line segment.
   *
   *  SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
   *}

function SDL_IntersectRectAndLine(const rect: PSDL_Rect; X1: PInt; Y1: PInt; X2: PInt; Y2: PInt): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_IntersectRectAndLine' {$ELSE} SDL_LibName {$ENDIF};

//from "sdl_rwops"

const
  {* RWops Types *}
  SDL_RWOPS_UNKNOWN	  = 0;	{* Unknown stream type *}
  SDL_RWOPS_WINFILE	  = 1;	{* Win32 file *}
  SDL_RWOPS_STDFILE	  = 2;	{* Stdio file *}
  SDL_RWOPS_JNIFILE	  = 3;	{* Android asset *}
  SDL_RWOPS_MEMORY    =	4;	{* Memory stream *}
  SDL_RWOPS_MEMORY_RO =	5;	{* Read-Only memory stream *}

type
  PSDL_RWops = ^TSDL_RWops;

  {**
   * This is the read/write operation structure -- very basic.
   *}

  {**
   *  Return the size of the file in this rwops, or -1 if unknown
   *}
  TSize = function(context: PSDL_RWops): SInt64; {$IFNDEF GPC} cdecl; {$ENDIF}
  
  {**
   *  Seek to offset relative to whence, one of stdio's whence values:
   *  RW_SEEK_SET, RW_SEEK_CUR, RW_SEEK_END
   *
   *  the final offset in the data stream, or -1 on error.
   *}
  TSeek = function(context: PSDL_RWops; offset: SInt64; whence: SInt32): SInt64; {$IFNDEF GPC} cdecl; {$ENDIF}
                   
  {**
   *  Read up to maxnum objects each of size size from the data
   *  stream to the area pointed at by ptr.
   *
   *  the number of objects read, or 0 at error or end of file.
   *}

   TRead = function(context: PSDL_RWops; ptr: Pointer; size: size_t; maxnum: size_t): size_t; {$IFNDEF GPC} cdecl; {$ENDIF}
   
  {**
   *  Write exactly num objects each of size size from the area
   *  pointed at by ptr to data stream.
   *  
   *  the number of objects written, or 0 at error or end of file.
   *}
	
   TWrite = function(context: PSDL_RWops; const ptr: Pointer; size: size_t; num: size_t): size_t; {$IFNDEF GPC} cdecl; {$ENDIF}
	
  {**
   *  Close and free an allocated SDL_RWops structure.
   *  
   *  0 if successful or -1 on write error when flushing data.
   *}

  TClose =  function(context: PSDL_RWops): SInt32;  
	
  TStdio = record
    autoclose: TSDL_Bool;
	fp: file;
  end;
  
  TMem = record
    base: PUInt8;
	here: PUInt8;
	stop: PUInt8;
  end;
  
  TUnknown = record
    data1: Pointer;
  end;
  
  TAndroidIO = record
    fileNameRef: Pointer;
    inputStreamRef: Pointer;
    readableByteChannelRef: Pointer;
    readMethod: Pointer;
    assetFileDescriptorRef: Pointer;
    position: LongInt;
    size: LongInt;
    offset: LongInt;
    fd: SInt32;
  end;
  
  TWindowsIOBuffer = record
    data: Pointer;
	size: size_t;
	left: size_t;
  end;
  
  TWindowsIO = record
    append: TSDL_Bool;
    h: Pointer;
    buffer: TWindowsIOBuffer;
  end;
	
  TSDL_RWops = packed record
    size: TSize;
    seek: TSeek;
    read: TRead;
    write: TWrite;
    close: TClose;

    _type: UInt32;

	case Integer of
	  0: (stdio: TStdio);
	  1: (mem: TMem);
	  2: (unknown: TUnknown);
	  {$IFDEF ANDROID}
	  3: (androidio: TAndroidIO);
	  {$ENDIF}
	  {$IFDEF WINDOWS}
	  3: (windowsio: TWindowsIO);
	  {$ENDIF}
  end;

  {**
   *  RWFrom functions
   *
   *  Functions to create SDL_RWops structures from various data streams.
   *}

function SDL_RWFromFile(const _file: PAnsiChar; const mode: PAnsiChar): PSDL_RWops; cdecl; external {$IFDEF GPC} name 'SDL_RWFromFile' {$ELSE} SDL_LibName {$ENDIF};

  {function SDL_RWFromFP(fp: file; autoclose: TSDL_Bool): PSDL_RWops; cdecl; external SDL_LibName;} //don't know if this works

function SDL_RWFromFP(fp: Pointer; autoclose: TSDL_Bool): PSDL_RWops; cdecl; external {$IFDEF GPC} name 'SDL_RWFromFP' {$ELSE} SDL_LibName {$ENDIF};

function SDL_RWFromMem(mem: Pointer; size: SInt32): PSDL_RWops; cdecl; external {$IFDEF GPC} name 'SDL_RWFromMem' {$ELSE} SDL_LibName {$ENDIF};
function SDL_RWFromConstMem(const mem: Pointer; size: SInt32): PSDL_RWops; cdecl; external {$IFDEF GPC} name 'SDL_RWFromConstMem' {$ELSE} SDL_LibName {$ENDIF};

{*RWFrom functions*}


function SDL_AllocRW: PSDL_RWops; cdecl; external {$IFDEF GPC} name 'SDL_AllocRW' {$ELSE} SDL_LibName {$ENDIF};
procedure SDL_FreeRW(area: PSDL_RWops); cdecl; external {$IFDEF GPC} name 'SDL_FreeRW' {$ELSE} SDL_LibName {$ENDIF};

const
  RW_SEEK_SET = 0;       {**< Seek from the beginning of data *}
  RW_SEEK_CUR = 1;       {**< Seek relative to current read point *}
  RW_SEEK_END = 2;       {**< Seek relative to the end of data *}

  {**
   *  Read/write macros
   *
   *  Macros to easily read and write from an SDL_RWops structure.
   *}
  {
  #define SDL_RWsize(ctx)	        (ctx)->size(ctx)
  #define SDL_RWseek(ctx, offset, whence)	(ctx)->seek(ctx, offset, whence)
  #define SDL_RWtell(ctx)			(ctx)->seek(ctx, 0, RW_SEEK_CUR)
  #define SDL_RWread(ctx, ptr, size, n)	(ctx)->read(ctx, ptr, size, n)
  #define SDL_RWwrite(ctx, ptr, size, n)	(ctx)->write(ctx, ptr, size, n)
  #define SDL_RWclose(ctx)		(ctx)->close(ctx)
  { Read/write macros }


  {**
   *  Read endian functions
   *
   *  Read an item of the specified endianness and return in native format.
   *}

function SDL_ReadU8(src: PSDL_RWops): UInt8 cdecl; external {$IFDEF GPC} name 'SDL_ReadU8' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadLE16(src: PSDL_RWops): UInt16 cdecl; external {$IFDEF GPC} name 'SDL_ReadLE16' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadBE16(src: PSDL_RWops): UInt16 cdecl; external {$IFDEF GPC} name 'SDL_ReadBE16' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadLE32(src: PSDL_RWops): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_ReadLE32' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadBE32(src: PSDL_RWops): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_ReadBE32' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadLE64(src: PSDL_RWops): UInt64 cdecl; external {$IFDEF GPC} name 'SDL_ReadLE64' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ReadBE64(src: PSDL_RWops): UInt64 cdecl; external {$IFDEF GPC} name 'SDL_ReadBE64' {$ELSE} SDL_LibName {$ENDIF};

  {*Read endian functions*}

  {**
   *  Write endian functions
   *
   *  Write an item of native format to the specified endianness.
   *}

function SDL_WriteU8(dst: PSDL_RWops; value: UInt8): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteU8' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteLE16(dst: PSDL_RWops; value: UInt16): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteLE16' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteBE16(dst: PSDL_RWops; value: UInt16): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteBE16' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteLE32(dst: PSDL_RWops; value: UInt32): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteLE32' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteBE32(dst: PSDL_RWops; value: UInt32): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteBE32' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteLE64(dst: PSDL_RWops; value: UInt64): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteLE64' {$ELSE} SDL_LibName {$ENDIF};
function SDL_WriteBE64(dst: PSDL_RWops; value: UInt64): size_t cdecl; external {$IFDEF GPC} name 'SDL_WriteBE64' {$ELSE} SDL_LibName {$ENDIF};
  { Write endian functions }

//from "sdl_blendmode.h"

{**
 *  The blend mode used in SDL_RenderCopy() and drawing operations.
 *}
 
type
  PSDL_BlendMode = ^TSDL_BlendMode;
  TSDL_BlendMode = DWord;
 
const
  SDL_BLENDMODE_NONE  = $00000000;    {**< No blending *}
  SDL_BLENDMODE_BLEND = $00000001;    {**< dst = (src * A) + (dst * (1-A)) *}
  SDL_BLENDMODE_ADD   = $00000002;    {**< dst = (src * A) + dst *}
  SDL_BLENDMODE_MOD   = $00000004;    {**< dst = src * dst *}

//from "sdl_surface.h"

const
  {**
   *  Surface flags
   *
   *  These are the currently supported flags for the ::SDL_surface.
   *
   *  Used internally (read-only).
   *}

  SDL_SWSURFACE = 0;          {**< Just here for compatibility *}
  SDL_PREALLOC  = $00000001;  {**< Surface uses preallocated memory *}
  SDL_RLEACCEL  = $00000002;  {**< Surface is RLE encoded *}
  SDL_DONTFREE  = $00000004;  {**< Surface is referenced internally *}

  {*Surface flags*}

  {**
   *  Evaluates to true if the surface needs to be locked before access.
   *}

  //SDL_MUSTLOCK(S)	(((S)->flags & SDL_RLEACCEL) != 0)

type
  {**
   *  A collection of pixels used in software blitting.
   *
   *  This structure should be treated as read-only, except for \c pixels,
   *  which, if not NULL, contains the raw pixel data for the surface.
   *}

  PSDL_BlitMap = ^TSDL_BlitMap;
  TSDL_BlitMap = record
    map: Pointer;
  end;

  PSDL_Surface = ^TSDL_Surface;
  TSDL_Surface = record
    flags: UInt32;              {**< Read-only *}
    format: PSDL_PixelFormat;   {**< Read-only *}
    w, h: SInt32;               {**< Read-only *}
    pitch: SInt32;              {**< Read-only *}
    pixels: Pointer;            {**< Read-write *}

    {** Application data associated with the surface *}
    userdata: Pointer;          {**< Read-write *}

    {** information needed for surfaces requiring locks *}
    locked: SInt32;             {**< Read-only *}
    lock_data: Pointer;         {**< Read-only *}

    {** clipping information *}
    clip_rect: PSDL_Rect;       {**< Read-only *}

    {** info for fast blit mapping to other surfaces *}
    map: Pointer;               {**< Private *} //SDL_BlitMap

    {** Reference count -- used when freeing surface *}
    refcount: SInt32;           {**< Read-mostly *}
  end;

  {**
   *  The type of function used for surface blitting functions.
   *}

   TSDL_Blit = function(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): SInt32;

  {**
   *  Allocate and free an RGB surface.
   *
   *  If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
   *  If the depth is greater than 8 bits, the pixel format is set using the
   *  flags '[RGB]mask'.
   *
   *  If the function runs out of memory, it will return NULL.
   *
   *  flags The flags are obsolete and should be set to 0.
   *}

function SDL_CreateRGBSurface(flags: UInt32; width: SInt32; height: SInt32; depth: SInt32; Rmask: UInt32; Gmask: UInt32; Bmask: UInt32; Amask: UInt32): PSDL_Surface cdecl; external {$IFDEF GPC} name 'SDL_CreateRGBSurface' {$ELSE} SDL_LibName {$ENDIF};
function SDL_CreateRGBSurfaceFrom(pixels: Pointer; width: SInt32; height: SInt32; depth: SInt32; pitch: SInt32; Rmask: UInt32; Gmask: UInt32; Bmask: UInt32; Amask: UInt32): PSDL_Surface cdecl; external {$IFDEF GPC} name 'SDL_CreateRGBSurfaceFrom' {$ELSE} SDL_LibName {$ENDIF};
procedure SDL_FreeSurface(surface: PSDL_Surface) cdecl; external {$IFDEF GPC} name 'SDL_FreeSurface' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the palette used by a surface.
   *
   *  0, or -1 if the surface format doesn't use a palette.
   *
   *  A single palette can be shared with many surfaces.
   *}

function SDL_SetSurfacePalette(surface: PSDL_Surface; palette: PSDL_Palette): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetSurfacePalette' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Sets up a surface for directly accessing the pixels.
   *
   *  Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write
   *  to and read from surface.pixels, using the pixel format stored in
   *  surface.format. Once you are done accessing the surface, you should
   *  use SDL_UnlockSurface() to release it.
   *
   *  Not all surfaces require locking.  If SDL_MUSTLOCK(surface) evaluates
   *  to 0, then you can read and write to the surface at any time, and the
   *  pixel format of the surface will not change.
   *
   *  No operating system or library calls should be made between lock/unlock
   *  pairs, as critical system locks may be held during this time.
   *
   *  SDL_LockSurface() returns 0, or -1 if the surface couldn't be locked.
   *
   *  SDL_UnlockSurface()
   *}

function SDL_LockSurface(surface: PSDL_Surface): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LockSurface' {$ELSE} SDL_LibName {$ENDIF};

  {** SDL_LockSurface() *}

procedure SDL_UnlockSurface(surface: PSDL_Surface) cdecl; external {$IFDEF GPC} name 'SDL_UnlockSurface' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Load a surface from a seekable SDL data stream (memory or file).
   *
   *  If freesrc is non-zero, the stream will be closed after being read.
   *
   *  The new surface should be freed with SDL_FreeSurface().
   *
   *  the new surface, or NULL if there was an error.
   *}

function SDL_LoadBMP_RW(src: PSDL_RWops; freesrc: SInt32): PSDL_Surface cdecl; external {$IFDEF GPC} name 'SDL_LoadBMP_RW' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Load a surface from a file.
   *
   *  Convenience macro.
   *}

function SDL_LoadBMP(_file: PAnsiChar): PSDL_Surface;

  {**
   *  Save a surface to a seekable SDL data stream (memory or file).
   *
   *  If freedst is non-zero, the stream will be closed after being written.
   *
   *  0 if successful or -1 if there was an error.
   *}

function SDL_SaveBMP_RW(surface: PSDL_Surface; dst: PSDL_RWops; freedst: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LoadBMP_RW' {$ELSE} SDL_LibName {$ENDIF};

    {**
     *  Save a surface to a file.
     *
     *  Convenience macro.
     *}
  {
  #define SDL_SaveBMP(surface, file) \
      SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1)
  }

  {**
   *  Sets the RLE acceleration hint for a surface.
   *
   *  0 on success, or -1 if the surface is not valid
   *  
   *  If RLE is enabled, colorkey and alpha blending blits are much faster,
   *  but the surface must be locked before directly accessing the pixels.
   *}

function SDL_SetSurfaceRLE(surface: PSDL_Surface; flag: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetSurfaceRLE' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Sets the color key (transparent pixel) in a blittable surface.
   *
   *  surface The surface to update
   *  flag Non-zero to enable colorkey and 0 to disable colorkey
   *  key The transparent pixel in the native surface format
   *  
   *  0 on success, or -1 if the surface is not valid
   *
   *  You can pass SDL_RLEACCEL to enable RLE accelerated blits.
   *}

function SDL_SetColorKey(surface: PSDL_Surface; flag: SInt32; key: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetColorKey' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Gets the color key (transparent pixel) in a blittable surface.
   *  
   *  surface The surface to update
   *  key A pointer filled in with the transparent pixel in the native
   *      surface format
   *  
   *  0 on success, or -1 if the surface is not valid or colorkey is not
   *  enabled.
   *}

function SDL_GetColorKey(surface: PSDL_Surface; key: PUInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetColorKey' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set an additional color value used in blit operations.
   *
   *  surface The surface to update.
   *  r The red color value multiplied into blit operations.
   *  g The green color value multiplied into blit operations.
   *  b The blue color value multiplied into blit operations.
   *
   *  0 on success, or -1 if the surface is not valid.
   *
   *  SDL_GetSurfaceColorMod()
   *}

function SDL_SetSurfaceColorMod(surface: PSDL_Surface; r: UInt8; g: UInt8; b: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetSurfaceColorMod' {$ELSE} SDL_LibName {$ENDIF};


  {**
   *  Get the additional color value used in blit operations.
   *
   *  surface The surface to query.
   *  r A pointer filled in with the current red color value.
   *  g A pointer filled in with the current green color value.
   *  b A pointer filled in with the current blue color value.
   *
   *  0 on success, or -1 if the surface is not valid.
   *
   *  SDL_SetSurfaceColorMod()
   *}

function SDL_GetSurfaceColorMod(surface: PSDL_Surface; r: UInt8; g: UInt8; b: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetSurfaceColorMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set an additional alpha value used in blit operations.
   *
   *  surface The surface to update.
   *  alpha The alpha value multiplied into blit operations.
   *
   *  0 on success, or -1 if the surface is not valid.
   *
   *  SDL_GetSurfaceAlphaMod()
   *}

function SDL_SetSurfaceAlphaMod(surface: PSDL_Surface; alpha: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetSurfaceAlphaMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the additional alpha value used in blit operations.
   *
   *  surface The surface to query.
   *  alpha A pointer filled in with the current alpha value.
   *
   *  0 on success, or -1 if the surface is not valid.
   *
   *  SDL_SetSurfaceAlphaMod()
   *}

function SDL_GetSurfaceAlphaMod(surface: PSDL_Surface; alpha: PUInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetSurfaceAlphaMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the blend mode used for blit operations.
   *
   *  surface The surface to update.
   *  blendMode ::SDL_BlendMode to use for blit blending.
   *
   *  0 on success, or -1 if the parameters are not valid.
   *
   *  SDL_GetSurfaceBlendMode()
   *}

function SDL_SetSurfaceBlendMode(surface: PSDL_Surface; blendMode: TSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetSurfaceBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the blend mode used for blit operations.
   *
   *  surface   The surface to query.
   *  blendMode A pointer filled in with the current blend mode.
   *
   *  0 on success, or -1 if the surface is not valid.
   *
   *  SDL_SetSurfaceBlendMode()
   *}

function SDL_GetSurfaceBlendMode(surface: PSDL_Surface; blendMode: PSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetSurfaceBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Sets the clipping rectangle for the destination surface in a blit.
   *
   *  If the clip rectangle is NULL, clipping will be disabled.
   *
   *  If the clip rectangle doesn't intersect the surface, the function will
   *  return SDL_FALSE and blits will be completely clipped.  Otherwise the
   *  function returns SDL_TRUE and blits to the surface will be clipped to
   *  the intersection of the surface area and the clipping rectangle.
   *
   *  Note that blits are automatically clipped to the edges of the source
   *  and destination surfaces.
   *}

function SDL_SetClipRect(surface: PSDL_Surface; const rect: PSDL_Rect): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_SetClipRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Gets the clipping rectangle for the destination surface in a blit.
   *
   *  rect must be a pointer to a valid rectangle which will be filled
   *  with the correct values.
   *}

procedure SDL_GetClipRect(surface: PSDL_Surface; rect: PSDL_Rect) cdecl; external {$IFDEF GPC} name 'SDL_GetClipRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Creates a new surface of the specified format, and then copies and maps
   *  the given surface to it so the blit of the converted surface will be as
   *  fast as possible.  If this function fails, it returns NULL.
   *
   *  The flags parameter is passed to SDL_CreateRGBSurface() and has those
   *  semantics.  You can also pass SDL_RLEACCEL in the flags parameter and
   *  SDL will try to RLE accelerate colorkey and alpha blits in the resulting
   *  surface.
   *}

function SDL_ConvertSurface(src: PSDL_Surface; fmt: PSDL_PixelFormat; flags: UInt32): PSDL_Surface cdecl; external {$IFDEF GPC} name 'SDL_ConvertSurface' {$ELSE} SDL_LibName {$ENDIF};
function SDL_ConvertSurfaceFormat(src: PSDL_Surface; pixel_format: UInt32; flags: UInt32): PSDL_Surface cdecl; external {$IFDEF GPC} name 'SDL_ConvertSurfaceFormat' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Copy a block of pixels of one format to another format
   *
   *  0 on success, or -1 if there was an error
   *}

function SDL_ConvertPixels(width: SInt32; height: SInt32; src_format: UInt32; const src: Pointer; src_pitch: SInt32; dst_format: UInt32; dst: Pointer; dst_pitch: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_ConvertPixels' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Performs a fast fill of the given rectangle with color.
   *
   *  If rect is NULL, the whole surface will be filled with color.
   *
   *  The color should be a pixel of the format used by the surface, and 
   *  can be generated by the SDL_MapRGB() function.
   *  
   *  0 on success, or -1 on error.
   *}

function SDL_FillRect(dst: PSDL_Surface; const rect: PSDL_Rect; color: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_FillRect' {$ELSE} SDL_LibName {$ENDIF};
function SDL_FillRects(dst: PSDL_Surface; const rects: PSDL_Rect; count: SInt32; color: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_FillRects' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Performs a fast blit from the source surface to the destination surface.
   *
   *  This assumes that the source and destination rectangles are
   *  the same size.  If either \c srcrect or \c dstrect are NULL, the entire
   *  surface ( src or  dst) is copied.  The final blit rectangles are saved
   *  in srcrect and dstrect after all clipping is performed.
   *
   *  If the blit is successful, it returns 0, otherwise it returns -1.
   *
   *  The blit function should not be called on a locked surface.
   *
   *  The blit semantics for surfaces with and without alpha and colorkey
   *  are defined as follows:
   *
      RGBA->RGB:
        SDL_SRCALPHA set:
          alpha-blend (using alpha-channel).
          SDL_SRCCOLORKEY ignored.
        SDL_SRCALPHA not set:
          copy RGB.
          if SDL_SRCCOLORKEY set, only copy the pixels matching the
          RGB values of the source colour key, ignoring alpha in the
          comparison.
   
      RGB->RGBA:
        SDL_SRCALPHA set:
          alpha-blend (using the source per-surface alpha value);
          set destination alpha to opaque.
        SDL_SRCALPHA not set:
          copy RGB, set destination alpha to source per-surface alpha value.
        both:
          if SDL_SRCCOLORKEY set, only copy the pixels matching the
          source colour key.
   
      RGBA->RGBA:
        SDL_SRCALPHA set:
          alpha-blend (using the source alpha channel) the RGB values;
          leave destination alpha untouched. [Note: is this correct?]
          SDL_SRCCOLORKEY ignored.
        SDL_SRCALPHA not set:
          copy all of RGBA to the destination.
          if SDL_SRCCOLORKEY set, only copy the pixels matching the
          RGB values of the source colour key, ignoring alpha in the
         comparison.

      RGB->RGB:
        SDL_SRCALPHA set:
          alpha-blend (using the source per-surface alpha value).
        SDL_SRCALPHA not set:
          copy RGB.
        both:
          if SDL_SRCCOLORKEY set, only copy the pixels matching the
          source colour key.r
   *
   *  You should call SDL_BlitSurface() unless you know exactly how SDL
   *  blitting works internally and how to use the other blit functions.
   *}

  {**
   *  This is the public blit function, SDL_BlitSurface(), and it performs
   *  rectangle validation and clipping before passing it to SDL_LowerBlit()
   *}

function SDL_UpperBlit(src: PSDL_Surface; const srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_UpperBlit' {$ELSE} SDL_LibName {$ENDIF};

  //SDL_BlitSurface = SDL_UpperBlit;

  {**
   *  This is a semi-private blit function and it performs low-level surface
   *  blitting only.
   *}

function SDL_LowerBlit(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LowerBlit' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Perform a fast, low quality, stretch blit between two surfaces of the
   *  same pixel format.
   *  
   *  This function uses a static buffer, and is not thread-safe.
   *}

function SDL_SoftStretch(src: PSDL_Surface; const srcrect: PSDL_Rect; dst: PSDL_Surface; const dstrect: PSDL_Surface): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SoftStretch' {$ELSE} SDL_LibName {$ENDIF};

  //SDL_BlitScaled = SDL_UpperBlitScaled;

  {**
   *  This is the public scaled blit function, SDL_BlitScaled(), and it performs
   *  rectangle validation and clipping before passing it to SDL_LowerBlitScaled()
   *}

function SDL_UpperBlitScaled(src: PSDL_Surface; const srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_UpperBlitScaled' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  This is a semi-private blit function and it performs low-level surface
   *  scaled blitting only.
   *}

function SDL_LowerBlitScaled(src: PSDL_Surface; srcrect: PSDL_Rect; dst: PSDL_Surface; dstrect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LowerBlitScaled' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_video.h"
  
type
  PPSDL_Window = ^PSDL_Window;
  PSDL_Window = Pointer; //todo!!

  {**
   *  The structure that defines a display mode
   *
   *   SDL_GetNumDisplayModes()
   *   SDL_GetDisplayMode()
   *   SDL_GetDesktopDisplayMode()
   *   SDL_GetCurrentDisplayMode()
   *   SDL_GetClosestDisplayMode()
   *   SDL_SetWindowDisplayMode()
   *   SDL_GetWindowDisplayMode()
   *}

  PSDL_DisplayMode = ^TSDL_DisplayMode;
  TSDL_DisplayMode = record
    format: UInt32;              {**< pixel format *}
    w: SInt32;                   {**< width *}
    h: SInt32;                   {**< height *}
    refresh_rate: SInt32;        {**< refresh rate (or zero for unspecified) *}
    driverdata: Pointer;         {**< driver-specific data, initialize to 0 *}
  end;

  {**
   *  The type used to identify a window
   *  
   *   SDL_CreateWindow()
   *   SDL_CreateWindowFrom()
   *   SDL_DestroyWindow()
   *   SDL_GetWindowData()
   *   SDL_GetWindowFlags()
   *   SDL_GetWindowGrab()
   *   SDL_GetWindowPosition()
   *   SDL_GetWindowSize()
   *   SDL_GetWindowTitle()
   *   SDL_HideWindow()
   *   SDL_MaximizeWindow()
   *   SDL_MinimizeWindow()
   *   SDL_RaiseWindow()
   *   SDL_RestoreWindow()
   *   SDL_SetWindowData()
   *   SDL_SetWindowFullscreen()
   *   SDL_SetWindowGrab()
   *   SDL_SetWindowIcon()
   *   SDL_SetWindowPosition()
   *   SDL_SetWindowSize()
   *   SDL_SetWindowBordered()
   *   SDL_SetWindowTitle()
   *   SDL_ShowWindow()
   *}

  //typedef struct SDL_Window SDL_Window;

const
  {**
   *  The flags on a window
   *  
   *   SDL_GetWindowFlags()
   *}

  SDL_WINDOW_FULLSCREEN = $00000001;         {**< fullscreen window *}
  SDL_WINDOW_OPENGL = $00000002;             {**< window usable with OpenGL context *}
  SDL_WINDOW_SHOWN = $00000004;              {**< window is visible *}
  SDL_WINDOW_HIDDEN = $00000008;             {**< window is not visible *}
  SDL_WINDOW_BORDERLESS = $00000010;         {**< no window decoration *}
  SDL_WINDOW_RESIZABLE = $00000020;          {**< window can be resized *}
  SDL_WINDOW_MINIMIZED = $00000040;          {**< window is minimized *}
  SDL_WINDOW_MAXIMIZED = $00000080;          {**< window is maximized *}
  SDL_WINDOW_INPUT_GRABBED = $00000100;      {**< window has grabbed input focus *}
  SDL_WINDOW_INPUT_FOCUS = $00000200;        {**< window has input focus *}
  SDL_WINDOW_MOUSE_FOCUS = $00000400;        {**< window has mouse focus *}
  SDL_WINDOW_FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN or $00001000;
  SDL_WINDOW_FOREIGN = $00000800;            {**< window not created by SDL *}

type
  TSDL_WindowFlags = DWord;

function SDL_WindowPos_IsUndefined(X: Variant): Variant;
function SDL_WindowPos_IsCentered(X: Variant): Variant;

const
   {**
   *  Used to indicate that you don't care what the window position is.
   *}

  SDL_WINDOWPOS_UNDEFINED_MASK = $1FFF0000;
  SDL_WINDOWPOS_UNDEFINED = SDL_WINDOWPOS_UNDEFINED_MASK or 0;


  {**
   *  Used to indicate that the window position should be centered.
   *}

  SDL_WINDOWPOS_CENTERED_MASK = $2FFF0000;
  SDL_WINDOWPOS_CENTERED = SDL_WINDOWPOS_CENTERED_MASK or 0;

  {**
   *  Event subtype for window events
   *}

  SDL_WINDOWEVENT_NONE = 0;           {**< Never used *}
  SDL_WINDOWEVENT_SHOWN = 1;          {**< Window has been shown *}
  SDL_WINDOWEVENT_HIDDEN = 2;         {**< Window has been hidden *}
  SDL_WINDOWEVENT_EXPOSED = 3;        {**< Window has been exposed and should be redrawn *}
  SDL_WINDOWEVENT_MOVED = 4;          {**< Window has been moved to data1; data2 *}
  SDL_WINDOWEVENT_RESIZED = 5;        {**< Window has been resized to data1xdata2 *}
  SDL_WINDOWEVENT_SIZE_CHANGED = 6;   {**< The window size has changed; either as a result of an API call or through the system or user changing the window size. *}
  SDL_WINDOWEVENT_MINIMIZED = 7;      {**< Window has been minimized *}
  SDL_WINDOWEVENT_MAXIMIZED = 8;      {**< Window has been maximized *}
  SDL_WINDOWEVENT_RESTORED = 9;       {**< Window has been restored to normal size and position *}
  SDL_WINDOWEVENT_ENTER = 10;          {**< Window has gained mouse focus *}
  SDL_WINDOWEVENT_LEAVE = 11;          {**< Window has lost mouse focus *}
  SDL_WINDOWEVENT_FOCUS_GAINED = 12;   {**< Window has gained keyboard focus *}
  SDL_WINDOWEVENT_FOCUS_LOST = 13;     {**< Window has lost keyboard focus *}
  SDL_WINDOWEVENT_CLOSE = 14;          {**< The window manager requests that the window be closed *}

type
  TSDL_WindowEventID = DWord;

  {**
   *  An opaque handle to an OpenGL context.
   *}

  TSDL_GLContext = Pointer;

  {**
   *  OpenGL configuration attributes
   *}
   
const
  SDL_GL_RED_SIZE = 0;
  SDL_GL_GREEN_SIZE = 1;
  SDL_GL_BLUE_SIZE = 2;
  SDL_GL_ALPHA_SIZE = 3;
  SDL_GL_BUFFER_SIZE = 4;
  SDL_GL_DOUBLEBUFFER = 5;
  SDL_GL_DEPTH_SIZE = 6;
  SDL_GL_STENCIL_SIZE = 7;
  SDL_GL_ACCUM_RED_SIZE = 8;
  SDL_GL_ACCUM_GREEN_SIZE = 9;
  SDL_GL_ACCUM_BLUE_SIZE = 10;
  SDL_GL_ACCUM_ALPHA_SIZE = 11;
  SDL_GL_STEREO = 12;
  SDL_GL_MULTISAMPLEBUFFERS = 13;
  SDL_GL_MULTISAMPLESAMPLES = 14;
  SDL_GL_ACCELERATED_VISUAL = 15;
  SDL_GL_RETAINED_BACKING = 16;
  SDL_GL_CONTEXT_MAJOR_VERSION = 17;
  SDL_GL_CONTEXT_MINOR_VERSION = 18;
  SDL_GL_CONTEXT_EGL = 19;
  SDL_GL_CONTEXT_FLAGS = 20;
  SDL_GL_CONTEXT_PROFILE_MASK = 21;
  SDL_GL_SHARE_WITH_CURRENT_CONTEXT = 22;

type
  TSDL_GLattr = DWord;

const
  SDL_GL_CONTEXT_PROFILE_CORE           = $0001;
  SDL_GL_CONTEXT_PROFILE_COMPATIBILITY  = $0002;
  SDL_GL_CONTEXT_PROFILE_ES             = $0004;

type
  TSDL_GLprofile = DWord;

const
  SDL_GL_CONTEXT_DEBUG_FLAG              = $0001;
  SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = $0002;
  SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG      = $0004;
  SDL_GL_CONTEXT_RESET_ISOLATION_FLAG    = $0008;

type
  TSDL_GLcontextFlag = DWord;

  {* Function prototypes *}

  {**
   *  Get the number of video drivers compiled into SDL
   *
   *  SDL_GetVideoDriver()
   *}

function SDL_GetNumVideoDrivers: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumVideoDrivers' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the name of a built in video driver.
   *
   *  The video drivers are presented in the order in which they are
   *  normally checked during initialization.
   *
   *  SDL_GetNumVideoDrivers()
   *}

function SDL_GetVideoDriver(index: SInt32): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetVideoDriver' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Initialize the video subsystem, optionally specifying a video driver.
   *  
   *  driver_name Initialize a specific driver by name, or nil for the
   *  default video driver.
   *  
   *  0 on success, -1 on error
   *  
   *  This function initializes the video subsystem; setting up a connection
   *  to the window manager, etc, and determines the available display modes
   *  and pixel formats, but does not initialize a window or graphics mode.
   *  
   *  SDL_VideoQuit()
   *}

function SDL_VideoInit(const driver_name: PAnsiChar): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_VideoInit' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Shuts down the video subsystem.
   *  
   *  function closes all windows, and restores the original video mode.
   *  
   *  SDL_VideoInit()
   *}
procedure SDL_VideoQuit cdecl; external {$IFDEF GPC} name 'SDL_VideoQuit' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns the name of the currently initialized video driver.
   *
   *  The name of the current video driver or nil if no driver
   *  has been initialized
   *  
   *  SDL_GetNumVideoDrivers()
   *  SDL_GetVideoDriver()
   *}

function SDL_GetCurrentVideoDriver: PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetCurrentVideoDriver' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns the number of available video displays.
   *  
   *  SDL_GetDisplayBounds()
   *}

function SDL_GetNumVideoDisplays: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumVideoDisplays' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the name of a display in UTF-8 encoding
   *
   *  The name of a display, or nil for an invalid display index.
   *  
   *  SDL_GetNumVideoDisplays()
   *}

function SDL_GetDisplayName(displayIndex: SInt32): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetDisplayName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the desktop area represented by a display, with the primary
   *  display located at 0,0
   *  
   *  0 on success, or -1 if the index is out of range.
   *  
   *  SDL_GetNumVideoDisplays()
   *}

function SDL_GetDisplayBounds(displayIndex: SInt32; rect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetDisplayBounds' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns the number of available display modes.
   *  
   *  SDL_GetDisplayMode()
   *}

function SDL_GetNumDisplayModes(displayIndex: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumDisplayModes' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill in information about a specific display mode.
   *
   *  The display modes are sorted in this priority:
   *        bits per pixel -> more colors to fewer colors
   *        width -> largest to smallest
   *        height -> largest to smallest
   *        refresh rate -> highest to lowest
   *
   *  SDL_GetNumDisplayModes()
   *}

function SDL_GetDisplayMode(displayIndex: SInt32; modeIndex: SInt32; mode: PSDL_DisplayMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetDisplayMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill in information about the desktop display mode.
   *}

function SDL_GetDesktopDisplayMode(displayIndex: SInt32; mode: PSDL_DisplayMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetDesktopDisplayMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill in information about the current display mode.
   *}

function SDL_GetCurrentDisplayMode(displayIndex: SInt32; mode: PSDL_DisplayMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetCurrentDisplayIndex' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the closest match to the requested display mode.
   *  
   *  mode The desired display mode
   *  closest A pointer to a display mode to be filled in with the closest
   *  match of the available display modes.
   *  
   *  The passed in value closest, or nil if no matching video mode
   *  was available.
   *  
   *  The available display modes are scanned, and closest is filled in with the
   *  closest mode matching the requested mode and returned.  The mode format and 
   *  refresh_rate default to the desktop mode if they are 0.  The modes are 
   *  scanned with size being first priority, format being second priority, and 
   *  finally checking the refresh_rate.  If all the available modes are too 
   *  small, then nil is returned.
   *  
   *  SDL_GetNumDisplayModes()
   *  SDL_GetDisplayMode()
   *}

function SDL_GetClosestDisplayMode(displayIndex: SInt32; const mode: PSDL_DisplayMode; closest: PSDL_DisplayMode): PSDL_DisplayMode cdecl; external {$IFDEF GPC} name 'SDL_GetClosestDisplayMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the display index associated with a window.
   *  
   *  the display index of the display containing the center of the
   *  window, or -1 on error.
   *}

function SDL_GetWindowDisplayIndex(window: PSDL_Window): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowDisplayIndex' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the display mode used when a fullscreen window is visible.
   *
   *  By default the window's dimensions and the desktop format and refresh rate
   *  are used.
   *  
   *  mode The mode to use, or nil for the default mode.
   *  
   *  0 on success, or -1 if setting the display mode failed.
   *  
   *  SDL_GetWindowDisplayMode()
   *  SDL_SetWindowFullscreen()
   *}

function SDL_SetWindowDisplayMode(window: PSDL_Window; const mode: PSDL_DisplayMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetWindowDisplayMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill in information about the display mode used when a fullscreen
   *  window is visible.
   *
   *  SDL_SetWindowDisplayMode()
   *  SDL_SetWindowFullscreen()
   *}

function SDL_GetWindowDisplayMode(window: PSDL_Window; mode: PSDL_DisplayMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowDisplayMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the pixel format associated with the window.
   *}

function SDL_GetWindowPixelFormat(window: PSDL_Window): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowPixelFormat' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a window with the specified position, dimensions, and flags.
   *  
   *  title The title of the window, in UTF-8 encoding.
   *  x     The x position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *  y     The y position of the window, ::SDL_WINDOWPOS_CENTERED, or
   *               ::SDL_WINDOWPOS_UNDEFINED.
   *  w     The width of the window.
   *  h     The height of the window.
   *  flags The flags for the window, a mask of any of the following:
   *               ::SDL_WINDOW_FULLSCREEN, ::SDL_WINDOW_OPENGL, 
   *               ::SDL_WINDOW_SHOWN,      ::SDL_WINDOW_BORDERLESS, 
   *               ::SDL_WINDOW_RESIZABLE,  ::SDL_WINDOW_MAXIMIZED, 
   *               ::SDL_WINDOW_MINIMIZED,  ::SDL_WINDOW_INPUT_GRABBED.
   *  
   *  The id of the window created, or zero if window creation failed.
   *  
   *  SDL_DestroyWindow()
   *}

function SDL_CreateWindow(const title: PAnsiChar; x: SInt32; y: SInt32; w: SInt32; h: SInt32; flags: UInt32): PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_CreateWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create an SDL window from an existing native window.
   *  
   *  data A pointer to driver-dependent window creation data
   *  
   *  The id of the window created, or zero if window creation failed.
   *
   *  SDL_DestroyWindow()
   *}

function SDL_CreateWindowFrom(const data: Pointer): PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_CreateWindowFrom' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the numeric ID of a window, for logging purposes.
   *}

function SDL_GetWindowID(window: PSDL_Window): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowID' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a window from a stored ID, or nil if it doesn't exist.
   *}

function SDL_GetWindowFromID(id: UInt32): PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_GetWindowFromID' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the window flags.
   *}

function SDL_GetWindowFlags(window: PSDL_Window): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowFlags' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the title of a window, in UTF-8 format.
   *  
   *  SDL_GetWindowTitle()
   *}

procedure SDL_SetWindowTitle(window: PSDL_Window; const title: PAnsiChar) cdecl; external {$IFDEF GPC} name 'SDL_GetWindowTitle' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the title of a window, in UTF-8 format.
   *  
   *  SDL_SetWindowTitle()
   *}

function SDL_GetWindowTitle(window: PSDL_Window): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetWindowTitle' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the icon for a window.
   *  
   *  icon The icon for the window.
   *}

procedure SDL_SetWindowIcon(window: PSDL_Window; icon: PSDL_Surface) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowIcon' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Associate an arbitrary named pointer with a window.
   *  
   *  window   The window to associate with the pointer.
   *  name     The name of the pointer.
   *  userdata The associated pointer.
   *
   *  The previous value associated with 'name'
   *
   *  The name is case-sensitive.
   *
   *  SDL_GetWindowData()
   *}

function SDL_SetWindowData(window: PSDL_Window; const name: PAnsiChar; userdata: Pointer): Pointer cdecl; external {$IFDEF GPC} name 'SDL_SetWindowData' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Retrieve the data pointer associated with a window.
   *  
   *  window   The window to query.
   *  name     The name of the pointer.
   *
   *  The value associated with 'name'
   *  
   *  SDL_SetWindowData()
   *}

function SDL_GetWindowData(window: PSDL_Window; const name: PAnsiChar): Pointer cdecl; external {$IFDEF GPC} name 'SDL_GetWindowData' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the position of a window.
   *  
   *  window   The window to reposition.
   *  x        The x coordinate of the window, SDL_WINDOWPOS_CENTERED, or
   *                  SDL_WINDOWPOS_UNDEFINED.
   *  y        The y coordinate of the window, SDL_WINDOWPOS_CENTERED, or
   *                  SDL_WINDOWPOS_UNDEFINED.
   *  
   *  The window coordinate origin is the upper left of the display.
   *  
   *  SDL_GetWindowPosition()
   *}

procedure SDL_SetWindowPosition(window: PSDL_Window; x: SInt32; y: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowPosition' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the position of a window.
   *  
   *  x        Pointer to variable for storing the x position, may be nil
   *  y        Pointer to variable for storing the y position, may be nil
   *
   *  SDL_SetWindowPosition()
   *}

procedure SDL_GetWindowPosition(window: PSDL_Window; x: PInt; y: PInt) cdecl; external {$IFDEF GPC} name 'SDL_GetWindowPosition' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the size of a window's client area.
   *  
   *  w        The width of the window, must be >0
   *  h        The height of the window, must be >0
   *
   *  You can't change the size of a fullscreen window, it automatically
   *  matches the size of the display mode.
   *  
   *  SDL_GetWindowSize()
   *}

procedure SDL_SetWindowSize(window: PSDL_Window; w: SInt32; h: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the size of a window's client area.
   *  
   *  w        Pointer to variable for storing the width, may be nil
   *  h        Pointer to variable for storing the height, may be nil
   *  
   *  SDL_SetWindowSize()
   *}

procedure SDL_GetWindowSize(window: PSDL_Window; w: PInt; h: PInt) cdecl; external {$IFDEF GPC} name 'SDL_GetWindowSize' {$ELSE} SDL_LibName {$ENDIF};
    
  {**
   *  Set the minimum size of a window's client area.
   *  
   *  min_w     The minimum width of the window, must be >0
   *  min_h     The minimum height of the window, must be >0
   *
   *  You can't change the minimum size of a fullscreen window, it
   *  automatically matches the size of the display mode.
   *
   *  SDL_GetWindowMinimumSize()
   *  SDL_SetWindowMaximumSize()
   *}

procedure SDL_SetWindowMinimumSize(window: PSDL_Window; min_w: SInt32; min_h: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowMinimumSize' {$ELSE} SDL_LibName {$ENDIF};
    
  {**
   *  Get the minimum size of a window's client area.
   *  
   *  w        Pointer to variable for storing the minimum width, may be nil
   *  h        Pointer to variable for storing the minimum height, may be nil
   *  
   *  SDL_GetWindowMaximumSize()
   *  SDL_SetWindowMinimumSize()
   *}

procedure SDL_GetWindowMinimumSize(window: PSDL_Window; w: PInt; h: PInt) cdecl; external {$IFDEF GPC} name 'SDL_GetWindowMinimumSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the maximum size of a window's client area.
   *
   *  max_w     The maximum width of the window, must be >0
   *  max_h     The maximum height of the window, must be >0
   *
   *  You can't change the maximum size of a fullscreen window, it
   *  automatically matches the size of the display mode.
   *
   *  SDL_GetWindowMaximumSize()
   *  SDL_SetWindowMinimumSize()
   *}

procedure SDL_SetWindowMaximumSize(window: PSDL_Window; max_w: SInt32; max_h: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowMaximumSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the maximum size of a window's client area.
   *  
   *  w        Pointer to variable for storing the maximum width, may be nil
   *  h        Pointer to variable for storing the maximum height, may be nil
   *
   *  SDL_GetWindowMinimumSize()
   *  SDL_SetWindowMaximumSize()
   *}

procedure SDL_GetWindowMaximumSize(window: PSDL_Window; w: PInt; h: PInt) cdecl; external {$IFDEF GPC} name 'SDL_GetWindowMaximumSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the border state of a window.
   *
   *  This will add or remove the window's SDL_WINDOW_BORDERLESS flag and
   *  add or remove the border from the actual window. This is a no-op if the
   *  window's border already matches the requested state.
   *
   *  window The window of which to change the border state.
   *  bordered SDL_FALSE to remove border, SDL_TRUE to add border.
   *
   *  You can't change the border state of a fullscreen window.
   *  
   *  SDL_GetWindowFlags()
   *}

procedure SDL_SetWindowBordered(window: PSDL_Window; bordered: TSDL_Bool) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowBordered' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Show a window.
   *  
   *  SDL_HideWindow()
   *}

procedure SDL_ShowWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_ShowWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Hide a window.
   *  
   *  SDL_ShowWindow()
   *}

procedure SDL_HideWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_HideWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Raise a window above other windows and set the input focus.
   *}

procedure SDL_RaiseWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_RaiseWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Make a window as large as possible.
   *  
   *  SDL_RestoreWindow()
   *}

procedure SDL_MaximizeWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_MaximizeWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Minimize a window to an iconic representation.
   *  
   *  SDL_RestoreWindow()
   *}

procedure SDL_MinimizeWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_MinimizeWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Restore the size and position of a minimized or maximized window.
   *  
   *  SDL_MaximizeWindow()
   *  SDL_MinimizeWindow()
   *}

procedure SDL_RestoreWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_RestoreWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set a window's fullscreen state.
   *  
   *  0 on success, or -1 if setting the display mode failed.
   *  
   *  SDL_SetWindowDisplayMode()
   *  SDL_GetWindowDisplayMode()
   *}

function SDL_SetWindowFullscreen(window: PSDL_Window; flags: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetWindowFullscreen' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the SDL surface associated with the window.
   *
   *  The window's framebuffer surface, or nil on error.
   *
   *  A new surface will be created with the optimal format for the window,
   *  if necessary. This surface will be freed when the window is destroyed.
   *
   *  You may not combine this with 3D or the rendering API on this window.
   *
   *  SDL_UpdateWindowSurface()
   *  SDL_UpdateWindowSurfaceRects()
   *}

function SDL_GetWindowSurface(window: PSDL_Window): PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_GetWindowSurface' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Copy the window surface to the screen.
   *
   *  0 on success, or -1 on error.
   *
   *  SDL_GetWindowSurface()
   *  SDL_UpdateWindowSurfaceRects()
   *}

function SDL_UpdateWindowSurface(window: PSDL_Window): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_UpdateWindowSurface' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Copy a number of rectangles on the window surface to the screen.
   *
   *  0 on success, or -1 on error.
   *
   *  SDL_GetWindowSurface()
   *  SDL_UpdateWindowSurfaceRect()
   *}

function SDL_UpdateWindowSurfaceRects(window: PSDL_Window; rects: PSDL_Rect; numrects: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_UpdateWindowSurfaceRects' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set a window's input grab mode.
   *  
   *  grabbed This is SDL_TRUE to grab input, and SDL_FALSE to release input.
   *  
   *  SDL_GetWindowGrab()
   *}

procedure SDL_SetWindowGrab(window: PSDL_Window; grabbed: TSDL_Bool) cdecl; external {$IFDEF GPC} name 'SDL_SetWindowGrab' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a window's input grab mode.
   *  
   *  This returns SDL_TRUE if input is grabbed, and SDL_FALSE otherwise.
   *
   *  SDL_SetWindowGrab()
   *}

function SDL_GetWindowGrab(window: PSDL_Window): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_GetWindowGrab' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the brightness (gamma correction) for a window.
   *
   *  0 on success, or -1 if setting the brightness isn't supported.
   *  
   *  SDL_GetWindowBrightness()
   *  SDL_SetWindowGammaRamp()
   *}

function SDL_SetWindowBrightness(window: PSDL_Window; brightness: Float): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetWindowBrightness' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the brightness (gamma correction) for a window.
   *  
   *  The last brightness value passed to SDL_SetWindowBrightness()
   *  
   *  SDL_SetWindowBrightness()
   *}

function SDL_GetWindowBrightness(window: PSDL_Window): Float cdecl; external {$IFDEF GPC} name 'SDL_GetWindowBrightness' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the gamma ramp for a window.
   *  
   *  red The translation table for the red channel, or nil.
   *  green The translation table for the green channel, or nil.
   *  blue The translation table for the blue channel, or nil.
   *
   *  0 on success, or -1 if gamma ramps are unsupported.
   *  
   *  Set the gamma translation table for the red, green, and blue channels
   *  of the video hardware.  Each table is an array of 256 16-bit quantities,
   *  representing a mapping between the input and output for that channel.
   *  The input is the index into the array, and the output is the 16-bit
   *  gamma value at that index, scaled to the output color precision.
   *
   *  SDL_GetWindowGammaRamp()
   *}

function SDL_SetWindowGammaRamp(window: PSDL_Window; const red: PUInt16; const green: PUInt16; const blue: PUInt16): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetWindowGammaRamp' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the gamma ramp for a window.
   *  
   *  red   A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the red channel, or nil.
   *  green A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the green channel, or nil.
   *  blue  A pointer to a 256 element array of 16-bit quantities to hold
   *        the translation table for the blue channel, or nil.
   *   
   *  0 on success, or -1 if gamma ramps are unsupported.
   *  
   *  SDL_SetWindowGammaRamp()
   *}

function SDL_GetWindowGammaRamp(window: PSDL_Window; red: PUInt16; green: PUInt16; blue: PUInt16): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetWindowGammaRamp' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Destroy a window.
   *}

procedure SDL_DestroyWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_DestroyWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns whether the screensaver is currently enabled (default on).
   *  
   *  SDL_EnableScreenSaver()
   *  SDL_DisableScreenSaver()
   *}

function SDL_IsScreenSaverEnabled: TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_IsScreenSaverEnabled' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Allow the screen to be blanked by a screensaver
   *  
   *  SDL_IsScreenSaverEnabled()
   *  SDL_DisableScreenSaver()
   *}

procedure SDL_EnableScreenSaver cdecl; external {$IFDEF GPC} name 'SDL_EnableScreenSaver' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Prevent the screen from being blanked by a screensaver
   *  
   *  SDL_IsScreenSaverEnabled()
   *  SDL_EnableScreenSaver()
   *}

procedure SDL_DisableScreenSaver cdecl; external {$IFDEF GPC} name 'SDL_DisableScreenSaver' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  OpenGL support functions
   *}

  {**
   *  Dynamically load an OpenGL library.
   *  
   *  path The platform dependent OpenGL library name, or nil to open the
   *              default OpenGL library.
   *  
   *  0 on success, or -1 if the library couldn't be loaded.
   *
   *  This should be done after initializing the video driver, but before
   *  creating any OpenGL windows.  If no OpenGL library is loaded, the default
   *  library will be loaded upon creation of the first OpenGL window.
   *  
   *  If you do this, you need to retrieve all of the GL functions used in
   *  your program from the dynamic library using SDL_GL_GetProcAddress().
   *  
   *  SDL_GL_GetProcAddress()
   *  SDL_GL_UnloadLibrary()
   *}

function SDL_GL_LoadLibrary(const path: PAnsiChar): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_LoadLibrary' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the address of an OpenGL function.
   *}

function SDL_GL_GetProcAddress(const proc: PAnsiChar): Pointer cdecl; external {$IFDEF GPC} name 'SDL_GL_GetProcAddress' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Unload the OpenGL library previously loaded by SDL_GL_LoadLibrary().
   *  
   *  SDL_GL_LoadLibrary()
   *}

procedure SDL_GL_UnloadLibrary cdecl; external {$IFDEF GPC} name 'SDL_GL_UnloadLibrary' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return true if an OpenGL extension is supported for the current
   *  context.
   *}

function SDL_GL_ExtensionSupported(const extension: PAnsiChar): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_GL_ExtensionSupported' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set an OpenGL window attribute before window creation.
   *}

function SDL_GL_SetAttribute(attr: TSDL_GLattr; value: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_SetAttribute' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the actual value for an attribute from the current context.
   *}

function SDL_GL_GetAttribute(attr: TSDL_GLattr; value: PInt): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_GetAttribute' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create an OpenGL context for use with an OpenGL window, and make it
   *  current.
   *
   *  SDL_GL_DeleteContext()
   *}

function SDL_GL_CreateContext(window: PSDL_Window): TSDL_GLContext cdecl; external {$IFDEF GPC} name 'SDL_GL_CreateContext' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set up an OpenGL context for rendering into an OpenGL window.
   *  
   *  The context must have been created with a compatible window.
   *}

function SDL_GL_MakeCurrent(window: PSDL_Window; context: TSDL_GLContext): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_MakeCurrent' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the swap interval for the current OpenGL context.
   *  
   *  interval 0 for immediate updates, 1 for updates synchronized with the
   *  vertical retrace. If the system supports it, you may
   *  specify -1 to allow late swaps to happen immediately
   *  instead of waiting for the next retrace.
   *
   *  0 on success, or -1 if setting the swap interval is not supported.
   *  
   *  SDL_GL_GetSwapInterval()
   *}

function SDL_GL_SetSwapInterval(interval: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_SetSwapInterval' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the swap interval for the current OpenGL context.
   *  
   *  0 if there is no vertical retrace synchronization, 1 if the buffer
   *  swap is synchronized with the vertical retrace, and -1 if late
   *  swaps happen immediately instead of waiting for the next retrace.
   *  If the system can't determine the swap interval, or there isn't a
   *  valid current context, this will return 0 as a safe default.
   *  
   *  SDL_GL_SetSwapInterval()
   *}

function SDL_GL_GetSwapInterval: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_GetSwapInterval' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Swap the OpenGL buffers for a window, if double-buffering is
   *  supported.
   *}

procedure SDL_GL_SwapWindow(window: PSDL_Window) cdecl; external {$IFDEF GPC} name 'SDL_GL_SwapWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Delete an OpenGL context.
   *  
   *  SDL_GL_CreateContext()
   *}

procedure SDL_GL_DeleteContext(context: TSDL_GLContext) cdecl; external {$IFDEF GPC} name 'SDL_GL_DeleteContext' {$ELSE} SDL_LibName {$ENDIF};

  {*OpenGL support functions*}

  //from "sdl_renderer.h"

  {**
   *  Flags used when creating a rendering context
   *}
const
  SDL_RENDERER_SOFTWARE = $00000001;          {**< The renderer is a software fallback *}
  SDL_RENDERER_ACCELERATED = $00000002;       {**< The renderer uses hardware
                                                   acceleration *}
  SDL_RENDERER_PRESENTVSYNC = $00000004;      {**< Present is synchronized
                                                   with the refresh rate *}
  SDL_RENDERER_TARGETTEXTURE = $00000008;     {**< The renderer supports
                                                   rendering to texture *}

type
  PSDL_RendererFlags = ^TSDL_RendererFlags;
  TSDL_RendererFlags = Word;

  {**
   *  Information on the capabilities of a render driver or context.
   *}
  PSDL_RendererInfo = ^TSDL_RendererInfo;
  TSDL_RendererInfo = record  
    name: PAnsiChar;                         {**< The name of the renderer *}
    flags: UInt32;                           {**< Supported ::SDL_RendererFlags *}
    num_texture_formats: UInt32;             {**< The number of available texture formats *}
    texture_formats: array[0..15] of UInt32; {**< The available texture formats *}
    max_texture_width: SInt32;               {**< The maximimum texture width *}
    max_texture_height: SInt32;              {**< The maximimum texture height *}
  end;

  {**
   *  The access pattern allowed for a texture.
   *}
type
  PSDL_TextureAccess = ^TSDL_TextureAccess;
  TSDL_TextureAccess = (
                        SDL_TEXTUREACCESS_STATIC,    {**< Changes rarely, not lockable *}
                        SDL_TEXTUREACCESS_STREAMING, {**< Changes frequently, lockable *}
                        SDL_TEXTUREACCESS_TARGET     {**< Texture can be used as a render target *}
                        );

  {**
   *  The texture channel modulation used in SDL_RenderCopy().
   *}
  PSDL_TextureModulate = ^TSDL_TextureModulate;
  TSDL_TextureModulate = (
                          SDL_TEXTUREMODULATE_NONE,     {**< No modulation *}
                          SDL_TEXTUREMODULATE_COLOR,    {**< srcC = srcC * color *}
                          SDL_TEXTUREMODULATE_ALPHA     {**< srcA = srcA * alpha *}
                          );

  {**
   *  Flip constants for SDL_RenderCopyEx
   *}
type
  PSDL_RendererFlip = ^TSDL_RendererFlip;
  TSDL_RendererFlip = (SDL_FLIP_NONE,       {**< Do not flip *}
                       SDL_FLIP_HORIZONTAL, {**< flip horizontally *}
                       SDL_FLIP_VERTICAL    {**< flip vertically *}
                       );

  {**
   *  A structure representing rendering state
   *}

  PPSDL_Renderer = ^PSDL_Renderer;
  PSDL_Renderer = Pointer; //todo!

  {**
   *  An efficient driver-specific representation of pixel data
   *}
  PSDL_Texture = Pointer; //todo!

  {* Function prototypes *}

  {**
   *  Get the number of 2D rendering drivers available for the current
   *  display.
   *
   *  A render driver is a set of code that handles rendering and texture
   *  management on a particular display.  Normally there is only one, but
   *  some drivers may have several available with different capabilities.
   *
   *   SDL_GetRenderDriverInfo()
   *   SDL_CreateRenderer()
   *}
function SDL_GetNumRenderDrivers: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumRenderDrivers' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get information about a specific 2D rendering driver for the current
   *  display.
   *
   *   index The index of the driver to query information about.
   *   info  A pointer to an SDL_RendererInfo struct to be filled with
   *               information on the rendering driver.
   *
   *   0 on success, -1 if the index was out of range.
   *
   *   SDL_CreateRenderer()
   *}
function SDL_GetRenderDriverInfo(index: SInt32; info: PSDL_RendererInfo): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRenderDriverInfo' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a window and default renderer
   *
   *   width    The width of the window
   *   height   The height of the window
   *   window_flags The flags used to create the window
   *   window   A pointer filled with the window, or NULL on error
   *   renderer A pointer filled with the renderer, or NULL on error
   *
   *   0 on success, or -1 on error
   *}
function SDL_CreateWindowAndRenderer(width: SInt32; height: SInt32; window_flags: UInt32; window: PPSDL_Window; renderer: PPSDL_Renderer): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_CreateWindowAndRenderer' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a 2D rendering context for a window.
   *
   *   window The window where rendering is displayed.
   *   index    The index of the rendering driver to initialize, or -1 to
   *                  initialize the first one supporting the requested flags.
   *   flags    ::SDL_RendererFlags.
   *
   *   A valid rendering context or NULL if there was an error.
   *
   *   SDL_CreateSoftwareRenderer()
   *   SDL_GetRendererInfo()
   *   SDL_DestroyRenderer()
   *}
function SDL_CreateRenderer(window: PSDL_Window; index: SInt32; flags: UInt32): PSDL_Renderer cdecl; external {$IFDEF GPC} name 'SDL_CreateRenderer' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a 2D software rendering context for a surface.
   *
   *   surface The surface where rendering is done.
   *
   *   A valid rendering context or NULL if there was an error.
   *
   *   SDL_CreateRenderer()
   *   SDL_DestroyRenderer()
   *}
function SDL_CreateSoftwareRenderer(surface: PSDL_Surface): PSDL_Renderer cdecl; external {$IFDEF GPC} name 'SDL_CreateSoftwareRenderer' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the renderer associated with a window.
   *}
function SDL_GetRenderer(window: PSDL_Window): PSDL_Renderer cdecl; external {$IFDEF GPC} name 'SDL_GetRenderer' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get information about a rendering context.
   *}
function SDL_GetRendererInfo(renderer: PSDL_Renderer; info: PSDL_RendererInfo): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRendererInfo' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the output size of a rendering context.
   *}
function SDL_GetRendererOutputSize(renderer: PSDL_Renderer; w: PInt; h: PInt): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRendererOutputSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a texture for a rendering context.
   *
   *   renderer The renderer.
   *   format The format of the texture.
   *   access One of the enumerated values in ::SDL_TextureAccess.
   *   w      The width of the texture in pixels.
   *   h      The height of the texture in pixels.
   *
   *   The created texture is returned, or 0 if no rendering context was
   *   active,  the format was unsupported, or the width or height were out
   *   of range.
   *
   *  SDL_QueryTexture()
   *  SDL_UpdateTexture()
   *  SDL_DestroyTexture()
   *}
function SDL_CreateTexture(renderer: PSDL_Renderer; format: UInt32; access: SInt32; w: SInt32; h: SInt32): PSDL_Texture cdecl; external {$IFDEF GPC} name 'SDL_CreateTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a texture from an existing surface.
   *
   *   renderer The renderer.
   *   surface The surface containing pixel data used to fill the texture.
   *
   *   The created texture is returned, or 0 on error.
   *
   *   The surface is not modified or freed by this function.
   *
   *   SDL_QueryTexture()
   *   SDL_DestroyTexture()
   *}
function SDL_CreateTextureFromSurface(renderer: PSDL_Renderer; surface: PSDL_Surface): PSDL_Texture cdecl; external {$IFDEF GPC} name 'SDL_CreateTextureFromSurface' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Query the attributes of a texture
   *
   *   texture A texture to be queried.
   *   format  A pointer filled in with the raw format of the texture.  The
   *           actual format may differ, but pixel transfers will use this
   *           format.
   *   access  A pointer filled in with the actual access to the texture.
   *   w       A pointer filled in with the width of the texture in pixels.
   *   h       A pointer filled in with the height of the texture in pixels.
   *
   *   0 on success, or -1 if the texture is not valid.
   *}
function SDL_QueryTexture(texture: PSDL_Texture; format: PUInt32; access: PInt; w: PInt; h: PInt): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_QueryTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set an additional color value used in render copy operations.
   *
   *   texture The texture to update.
   *   r       The red color value multiplied into copy operations.
   *   g       The green color value multiplied into copy operations.
   *   b       The blue color value multiplied into copy operations.
   *
   *   0 on success, or -1 if the texture is not valid or color modulation
   *   is not supported.
   *
   *   SDL_GetTextureColorMod()
   *}
function SDL_SetTextureColorMod(texture: PSDL_Texture; r: UInt8; g: UInt8; b: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetTextureColorMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the additional color value used in render copy operations.
   *
   *   texture The texture to query.
   *   r         A pointer filled in with the current red color value.
   *   g         A pointer filled in with the current green color value.
   *   b         A pointer filled in with the current blue color value.
   *
   *   0 on success, or -1 if the texture is not valid.
   *
   *   SDL_SetTextureColorMod()
   *}
function SDL_GetTextureColorMod(texture: PSDL_Texture; r: PUInt8; g: PUInt8; b: PUInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetTextureColorMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set an additional alpha value used in render copy operations.
   *
   *   texture The texture to update.
   *   alpha     The alpha value multiplied into copy operations.
   *
   *   0 on success, or -1 if the texture is not valid or alpha modulation
   *   is not supported.
   *
   *   SDL_GetTextureAlphaMod()
   *}
function SDL_SetTextureAlphaMod(texture: PSDL_Texture; alpha: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetTextureAlphaMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the additional alpha value used in render copy operations.
   *
   *   texture The texture to query.
   *   alpha     A pointer filled in with the current alpha value.
   *
   *   0 on success, or -1 if the texture is not valid.
   *
   *   SDL_SetTextureAlphaMod()
   *}
function SDL_GetTextureAlphaMod(texture: PSDL_Texture; alpha: PUInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetTextureAlphaMod' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *   Set the blend mode used for texture copy operations.
   *
   *   texture The texture to update.
   *   blendMode ::SDL_BlendMode to use for texture blending.
   *
   *   0 on success, or -1 if the texture is not valid or the blend mode is
   *   not supported.
   *
   *   If the blend mode is not supported, the closest supported mode is
   *   chosen.
   *
   *   SDL_GetTextureBlendMode()
   *}
function SDL_SetTextureBlendMode(texture: PSDL_Texture; blendMode: TSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetTextureBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the blend mode used for texture copy operations.
   *
   *   texture   The texture to query.
   *   blendMode A pointer filled in with the current blend mode.
   *
   *   0 on success, or -1 if the texture is not valid.
   *
   *   SDL_SetTextureBlendMode()
   *}
function SDL_GetTextureBlendMode(texture: PSDL_Texture; blendMode: PSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetTextureBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Update the given texture rectangle with new pixel data.
   *
   *   texture   The texture to update
   *   rect      A pointer to the rectangle of pixels to update, or NULL to
   *                   update the entire texture.
   *   pixels    The raw pixel data.
   *   pitch     The number of bytes between rows of pixel data.
   *
   *   0 on success, or -1 if the texture is not valid.
   *
   *   This is a fairly slow function.
   *}
function SDL_UpdateTexture(texture: PSDL_Texture; rect: PSDL_Rect; pixels: Pointer; pitch: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_UpdateTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Lock a portion of the texture for write-only pixel access.
   *
   *   texture   The texture to lock for access, which was created with
   *             SDL_TEXTUREACCESS_STREAMING.
   *   rect      A pointer to the rectangle to lock for access. If the rect
   *             is NULL, the entire texture will be locked.
   *   pixels    This is filled in with a pointer to the locked pixels,
   *             appropriately offset by the locked area.
   *   pitch     This is filled in with the pitch of the locked pixels.
   *
   *   0 on success, or -1 if the texture is not valid or was not created with ::SDL_TEXTUREACCESS_STREAMING.
   *
   *   SDL_UnlockTexture()
   *}
function SDL_LockTexture(texture: PSDL_Texture; rect: PSDL_Rect; pixels: PPointer; pitch: PInt): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LockTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Unlock a texture, uploading the changes to video memory, if needed.
   *
   *   SDL_LockTexture()
   *}
procedure SDL_UnlockTexture(texture: PSDL_Texture) cdecl; external {$IFDEF GPC} name 'SDL_LockTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Determines whether a window supports the use of render targets
   *
   *  renderer The renderer that will be checked
   *
   *  SDL_TRUE if supported, SDL_FALSE if not.
   *}
function SDL_RenderTargetSupported(renderer: PSDL_Renderer): Boolean cdecl; external {$IFDEF GPC} name 'SDL_RenderTargetSupported' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set a texture as the current rendering target.
   *
   *  renderer The renderer.
   *  texture The targeted texture, which must be created with the SDL_TEXTUREACCESS_TARGET flag, or NULL for the default render target
   *
   *  0 on success, or -1 on error
   *
   *   SDL_GetRenderTarget()
   *}
function SDL_SetRenderTarget(renderer: PSDL_Renderer; texture: PSDL_Texture): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetRenderTarget' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the current render target or NULL for the default render target.
   *
   *  The current render target
   *
   *   SDL_SetRenderTarget()
   *}
function SDL_GetRenderTarget(renderer: PSDL_Renderer): PSDL_Texture cdecl; external {$IFDEF GPC} name 'SDL_GetRenderTarget' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set device independent resolution for rendering
   *
   *   renderer The renderer for which resolution should be set.
   *   w      The width of the logical resolution
   *   h      The height of the logical resolution
   *
   *  This function uses the viewport and scaling functionality to allow a fixed logical
   *  resolution for rendering, regardless of the actual output resolution.  If the actual
   *  output resolution doesn't have the same aspect ratio the output rendering will be
   *  centered within the output display.
   *
   *  If the output display is a window, mouse events in the window will be filtered
   *  and scaled so they seem to arrive within the logical resolution.
   *
   *   If this function results in scaling or subpixel drawing by the
   *   rendering backend, it will be handled using the appropriate
   *   quality hints.
   *
   *   SDL_RenderGetLogicalSize()
   *   SDL_RenderSetScale()
   *   SDL_RenderSetViewport()
   *}
function SDL_RenderSetLogicalSize(renderer: PSDL_Renderer; w: SInt32; h: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderSetLogicalSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get device independent resolution for rendering
   *
   *   renderer The renderer from which resolution should be queried.
   *   w      A pointer filled with the width of the logical resolution
   *   h      A pointer filled with the height of the logical resolution
   *
   *   SDL_RenderSetLogicalSize()
   *}
procedure SDL_RenderGetLogicalSize(renderer: PSDL_Renderer; w: PInt; h: PInt) cdecl; external {$IFDEF GPC} name 'SDL_RenderGetLogicalSize' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the drawing area for rendering on the current target.
   *
   *   renderer The renderer for which the drawing area should be set.
   *   rect The rectangle representing the drawing area, or NULL to set the viewport to the entire target.
   *
   *  The x,y of the viewport rect represents the origin for rendering.
   *
   *   0 on success, or -1 on error
   *
   *  If the window associated with the renderer is resized, the viewport is automatically reset.
   *
   *   SDL_RenderGetViewport()
   *   SDL_RenderSetLogicalSize()
   *}
function SDL_RenderSetViewport(renderer: PSDL_Renderer; const rect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderSetViewport' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the drawing area for the current target.
   *
   *   SDL_RenderSetViewport()
   *}
procedure SDL_RenderGetViewport(renderer: PSDL_Renderer; rect: PSDL_Rect) cdecl; external {$IFDEF GPC} name 'SDL_RenderGetViewport' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the clip rectangle for the current target.
   *
   *   renderer The renderer for which clip rectangle should be set.
   *   rect   A pointer to the rectangle to set as the clip rectangle, or
   *          NULL to disable clipping.
   *
   *   0 on success, or -1 on error
   *
   *   SDL_RenderGetClipRect()
   *}
function SDL_RenderSetClipRect(renderer: PSDL_Renderer; rect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderSetClipRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the clip rectangle for the current target.
   *
   *   renderer The renderer from which clip rectangle should be queried.
   *   rect   A pointer filled in with the current clip rectangle, or
   *          an empty rectangle if clipping is disabled.
   *
   *   SDL_RenderSetClipRect()
   *}
procedure SDL_RenderGetClipRect(renderer: PSDL_Renderer; rect: PSDL_Rect) cdecl; external {$IFDEF GPC} name 'SDL_RenderGetClipRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the drawing scale for rendering on the current target.
   *
   *   renderer The renderer for which the drawing scale should be set.
   *   scaleX The horizontal scaling factor
   *   scaleY The vertical scaling factor
   *
   *  The drawing coordinates are scaled by the x/y scaling factors
   *  before they are used by the renderer.  This allows resolution
   *  independent drawing with a single coordinate system.
   *
   *  If this results in scaling or subpixel drawing by the
   *  rendering backend, it will be handled using the appropriate
   *  quality hints.  For best results use integer scaling factors.
   *
   *   SDL_RenderGetScale()
   *   SDL_RenderSetLogicalSize()
   *}
function SDL_RenderSetScale(renderer: PSDL_Renderer; scaleX: Float; scaleY: Float): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderSetScale' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the drawing scale for the current target.
   *
   *   renderer The renderer from which drawing scale should be queried.
   *   scaleX A pointer filled in with the horizontal scaling factor
   *   scaleY A pointer filled in with the vertical scaling factor
   *
   *   SDL_RenderSetScale()
   *}
procedure SDL_RenderGetScale(renderer: PSDL_Renderer; scaleX: PFloat; scaleY: PFloat) cdecl; external {$IFDEF GPC} name 'SDL_RenderGetScale' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the color used for drawing operations (Rect, Line and Clear).
   *
   *   renderer The renderer for which drawing color should be set.
   *   r The red value used to draw on the rendering target.
   *   g The green value used to draw on the rendering target.
   *   b The blue value used to draw on the rendering target.
   *   a The alpha value used to draw on the rendering target, usually
   *     SDL_ALPHA_OPAQUE (255).
   *
   *   0 on success, or -1 on error
   *}
function SDL_SetRenderDrawColor(renderer: PSDL_Renderer; r: UInt8; g: UInt8; b: UInt8; a: UInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetRenderDrawColor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the color used for drawing operations (Rect, Line and Clear).
   *
   *   renderer The renderer from which drawing color should be queried.
   *   r A pointer to the red value used to draw on the rendering target.
   *   g A pointer to the green value used to draw on the rendering target.
   *   b A pointer to the blue value used to draw on the rendering target.
   *   a A pointer to the alpha value used to draw on the rendering target,
   *     usually SDL_ALPHA_OPAQUE (255).
   *
   *   0 on success, or -1 on error
   *}
function SDL_GetRenderDrawColor(renderer: PSDL_Renderer; r: PUInt8; g: PUInt8; b: PUInt8; a: PUInt8): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRenderDrawColor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the blend mode used for drawing operations (Fill and Line).
   *
   *   renderer The renderer for which blend mode should be set.
   *   blendMode SDL_BlendMode to use for blending.
   *
   *   0 on success, or -1 on error
   *
   *   If the blend mode is not supported, the closest supported mode is
   *        chosen.
   *
   *   SDL_GetRenderDrawBlendMode()
   *}
function SDL_SetRenderDrawBlendMode(renderer: PSDL_Renderer; blendMode: TSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetRenderDrawBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the blend mode used for drawing operations.
   *
   *   renderer The renderer from which blend mode should be queried.
   *   blendMode A pointer filled in with the current blend mode.
   *
   *   0 on success, or -1 on error
   *
   *   SDL_SetRenderDrawBlendMode()
   *}
function SDL_GetRenderDrawBlendMode(renderer: PSDL_Renderer; blendMode: PSDL_BlendMode): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRenderDrawBlendMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Clear the current rendering target with the drawing color
   *
   *  This function clears the entire rendering target, ignoring the viewport.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderClear(renderer: PSDL_Renderer): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderClear' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Draw a point on the current rendering target.
   *
   *   renderer The renderer which should draw a point.
   *   x The x coordinate of the point.
   *   y The y coordinate of the point.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderDrawPoint(renderer: PSDL_Renderer; x: SInt32; y: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawPoint' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Draw multiple points on the current rendering target.
   *
   *   renderer The renderer which should draw multiple points.
   *   points The points to draw
   *   count The number of points to draw
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderDrawPoints(renderer: PSDL_Renderer; points: PSDL_Point; count: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawPoints' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Draw a line on the current rendering target.
   *
   *   renderer The renderer which should draw a line.
   *   x1 The x coordinate of the start point.
   *   y1 The y coordinate of the start point.
   *   x2 The x coordinate of the end point.
   *   y2 The y coordinate of the end point.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderDrawLine(renderer: PSDL_Renderer; x1: SInt32; y1: SInt32; x2: SInt32; y2: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawLine' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  \brief Draw a series of connected lines on the current rendering target.
   *
   *  \param renderer The renderer which should draw multiple lines.
   *  \param points The points along the lines
   *  \param count The number of points, drawing count-1 lines
   *
   *  \return 0 on success, or -1 on error
   *}
function SDL_RenderDrawLines(renderer: PSDL_Renderer; points: PSDL_Point; count: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawLines' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Draw a rectangle on the current rendering target.
   *
   *   renderer The renderer which should draw a rectangle.
   *   rect A pointer to the destination rectangle, or NULL to outline the entire rendering target.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderDrawRect(renderer: PSDL_Renderer; rect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Draw some number of rectangles on the current rendering target.
   *
   *   renderer The renderer which should draw multiple rectangles.
   *   rects A pointer to an array of destination rectangles.
   *   count The number of rectangles.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderDrawRects(renderer: PSDL_Renderer; rects: PSDL_Rect; count: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderDrawRects' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill a rectangle on the current rendering target with the drawing color.
   *
   *   renderer The renderer which should fill a rectangle.
   *   rect A pointer to the destination rectangle, or NULL for the entire
   *        rendering target.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderFillRect(renderer: PSDL_Renderer; rect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderFillRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Fill some number of rectangles on the current rendering target with the drawing color.
   *
   *   renderer The renderer which should fill multiple rectangles.
   *   rects A pointer to an array of destination rectangles.
   *   count The number of rectangles.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderFillRects(renderer: PSDL_Renderer; rects: PSDL_Rect; count: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderFillRects' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Copy a portion of the texture to the current rendering target.
   *
   *   renderer The renderer which should copy parts of a texture.
   *   texture The source texture.
   *   srcrect   A pointer to the source rectangle, or NULL for the entire
   *             texture.
   *   dstrect   A pointer to the destination rectangle, or NULL for the
   *             entire rendering target.
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderCopy(renderer: PSDL_Renderer; texture: PSDL_Texture; srcrect: PSDL_Rect; dstrect: PSDL_Rect): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderCopy' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Copy a portion of the source texture to the current rendering target, rotating it by angle around the given center
   *
   *   renderer The renderer which should copy parts of a texture.
   *   texture The source texture.
   *   srcrect   A pointer to the source rectangle, or NULL for the entire
   *                   texture.
   *   dstrect   A pointer to the destination rectangle, or NULL for the
   *                   entire rendering target.
   *   angle    An angle in degrees that indicates the rotation that will be applied to dstrect
   *   center   A pointer to a point indicating the point around which dstrect will be rotated (if NULL, rotation will be done aroud dstrect.w/2, dstrect.h/2)
   *   flip     An SDL_RendererFlip value stating which flipping actions should be performed on the texture
   *
   *   0 on success, or -1 on error
   *}
function SDL_RenderCopyEx(renderer: PSDL_Renderer; texture: PSDL_Texture; const srcrect: PSDL_Rect; dstrect: PSDL_Rect; angle: Double; center: PSDL_Point; flip: PSDL_RendererFlip): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderCopyEx' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Read pixels from the current rendering target.
   *
   *   renderer The renderer from which pixels should be read.
   *   rect   A pointer to the rectangle to read, or NULL for the entire
   *                render target.
   *   format The desired format of the pixel data, or 0 to use the format
   *                of the rendering target
   *   pixels A pointer to be filled in with the pixel data
   *   pitch  The pitch of the pixels parameter.
   *
   *   0 on success, or -1 if pixel reading is not supported.
   *
   *   This is a very slow operation, and should not be used frequently.
   *}
function SDL_RenderReadPixels(renderer: PSDL_Renderer; rect: PSDL_Rect; format: UInt32; pixels: Pointer; pitch: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RenderReadPixels' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Update the screen with rendering performed.
   *}
procedure SDL_RenderPresent(renderer: PSDL_Renderer) cdecl; external {$IFDEF GPC} name 'SDL_RenderPresent' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Destroy the specified texture.
   *
   *   SDL_CreateTexture()
   *   SDL_CreateTextureFromSurface()
   *}
procedure SDL_DestroyTexture(texture: PSDL_Texture) cdecl; external {$IFDEF GPC} name 'SDL_DestroyTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Destroy the rendering context for a window and free associated
   *  textures.
   *
   *   SDL_CreateRenderer()
   *}
procedure SDL_DestroyRenderer(renderer: PSDL_Renderer) cdecl; external {$IFDEF GPC} name 'SDL_DestroyRenderer' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Bind the texture to the current OpenGL/ES/ES2 context for use with
   *  OpenGL instructions.
   *
   *   texture  The SDL texture to bind
   *   texw     A pointer to a float that will be filled with the texture width
   *   texh     A pointer to a float that will be filled with the texture height
   *
   *   0 on success, or -1 if the operation is not supported
   *}
function SDL_GL_BindTexture(texture: PSDL_Texture; texw: PFloat; texh: PFloat): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_BindTexture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Unbind a texture from the current OpenGL/ES/ES2 context.
   *
   *   texture  The SDL texture to unbind
   *
   *   0 on success, or -1 if the operation is not supported
   *}
function SDL_GL_UnbindTexture(texture: PSDL_Texture): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GL_UnbindTexture' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_scancode.h"

  {**
   *  The SDL keyboard scancode representation.
   *
   *  Values of this type are used to represent keyboard keys, among other places
   *  in the SDL_Keysym.scancode key.keysym.scancode \endlink field of the
   *  SDL_Event structure.
   *
   *  The values in this enumeration are based on the USB usage page standard:
   *  http://www.usb.org/developers/devclass_docs/Hut1_12v2.pdf
   *}

const
  SDL_SCANCODE_UNKNOWN = 0;

  {**
   *  Usage page $07
   *
   *  These values are from usage page $07 (USB keyboard page).
   *}

  SDL_SCANCODE_A = 4;
  SDL_SCANCODE_B = 5;
  SDL_SCANCODE_C = 6;
  SDL_SCANCODE_D = 7;
  SDL_SCANCODE_E = 8;
  SDL_SCANCODE_F = 9;
  SDL_SCANCODE_G = 10;
  SDL_SCANCODE_H = 11;
  SDL_SCANCODE_I = 12;
  SDL_SCANCODE_J = 13;
  SDL_SCANCODE_K = 14;
  SDL_SCANCODE_L = 15;
  SDL_SCANCODE_M = 16;
  SDL_SCANCODE_N = 17;
  SDL_SCANCODE_O = 18;
  SDL_SCANCODE_P = 19;
  SDL_SCANCODE_Q = 20;
  SDL_SCANCODE_R = 21;
  SDL_SCANCODE_S = 22;
  SDL_SCANCODE_T = 23;
  SDL_SCANCODE_U = 24;
  SDL_SCANCODE_V = 25;
  SDL_SCANCODE_W = 26;
  SDL_SCANCODE_X = 27;
  SDL_SCANCODE_Y = 28;
  SDL_SCANCODE_Z = 29;

  SDL_SCANCODE_1 = 30;
  SDL_SCANCODE_2 = 31;
  SDL_SCANCODE_3 = 32;
  SDL_SCANCODE_4 = 33;
  SDL_SCANCODE_5 = 34;
  SDL_SCANCODE_6 = 35;
  SDL_SCANCODE_7 = 36;
  SDL_SCANCODE_8 = 37;
  SDL_SCANCODE_9 = 38;
  SDL_SCANCODE_0 = 39;

  SDL_SCANCODE_RETURN = 40;
  SDL_SCANCODE_ESCAPE = 41;
  SDL_SCANCODE_BACKSPACE = 42;
  SDL_SCANCODE_TAB = 43;
  SDL_SCANCODE_SPACE = 44;

  SDL_SCANCODE_MINUS = 45;
  SDL_SCANCODE_EQUALS = 46;
  SDL_SCANCODE_LEFTBRACKET = 47;
  SDL_SCANCODE_RIGHTBRACKET = 48;
  SDL_SCANCODE_BACKSLASH = 49; {**< Located at the lower left of the return
                                *   key on ISO keyboards and at the right end
                                *   of the QWERTY row on ANSI keyboards.
                                *   Produces REVERSE SOLIDUS (backslash) and
                                *   VERTICAL LINE in a US layout; REVERSE 
                                *   SOLIDUS and VERTICAL LINE in a UK Mac
                                *   layout; NUMBER SIGN and TILDE in a UK 
                                *   Windows layout; DOLLAR SIGN and POUND SIGN
                                *   in a Swiss German layout; NUMBER SIGN and
                                *   APOSTROPHE in a German layout; GRAVE
                                *   ACCENT and POUND SIGN in a French Mac 
                                *   layout; and ASTERISK and MICRO SIGN in a
                                *   French Windows layout.
                                *}
  SDL_SCANCODE_NONUSHASH = 50; {**< ISO USB keyboards actually use this code
                                *   instead of 49 for the same key; but all
                                *   OSes I've seen treat the two codes 
                                *   identically. So; as an implementor; unless
                                *   your keyboard generates both of those 
                                *   codes and your OS treats them differently;
                                *   you should generate SDL_SCANCODE_BACKSLASH
                                *   instead of this code. As a user; you
                                *   should not rely on this code because SDL
                                *   will never generate it with most (all?)
                                *   keyboards.
                                *}
  SDL_SCANCODE_SEMICOLON = 51;
  SDL_SCANCODE_APOSTROPHE = 52;
  SDL_SCANCODE_GRAVE = 53;     {**< Located in the top left corner (on both ANSI
                                *   and ISO keyboards). Produces GRAVE ACCENT and
                                *   TILDE in a US Windows layout and in US and UK
                                *   Mac layouts on ANSI keyboards; GRAVE ACCENT
                                *   and NOT SIGN in a UK Windows layout; SECTION
                                *   SIGN and PLUS-MINUS SIGN in US and UK Mac
                                *   layouts on ISO keyboards; SECTION SIGN and
                                *   DEGREE SIGN in a Swiss German layout (Mac:
                                *   only on ISO keyboards); CIRCUMFLEX ACCENT and
                                *   DEGREE SIGN in a German layout (Mac: only on
                                *   ISO keyboards); SUPERSCRIPT TWO and TILDE in a
                                *   French Windows layout; COMMERCIAL AT and
                                *   NUMBER SIGN in a French Mac layout on ISO
                                *   keyboards; and LESS-THAN SIGN and GREATER-THAN
                                *   SIGN in a Swiss German; German; or French Mac
                                *   layout on ANSI keyboards.
                                *}
  SDL_SCANCODE_COMMA = 54;
  SDL_SCANCODE_PERIOD = 55;
  SDL_SCANCODE_SLASH = 56;

  SDL_SCANCODE_CAPSLOCK = 57;

  SDL_SCANCODE_F1 = 58;
  SDL_SCANCODE_F2 = 59;
  SDL_SCANCODE_F3 = 60;
  SDL_SCANCODE_F4 = 61;
  SDL_SCANCODE_F5 = 62;
  SDL_SCANCODE_F6 = 63;
  SDL_SCANCODE_F7 = 64;
  SDL_SCANCODE_F8 = 65;
  SDL_SCANCODE_F9 = 66;
  SDL_SCANCODE_F10 = 67;
  SDL_SCANCODE_F11 = 68;
  SDL_SCANCODE_F12 = 69;

  SDL_SCANCODE_PRINTSCREEN = 70;
  SDL_SCANCODE_SCROLLLOCK = 71;
  SDL_SCANCODE_PAUSE = 72;
  SDL_SCANCODE_INSERT = 73; {**< insert on PC; help on some Mac keyboards (but
                                 does send code 73; not 117) *}
  SDL_SCANCODE_HOME = 74;
  SDL_SCANCODE_PAGEUP = 75;
  SDL_SCANCODE_DELETE = 76;
  SDL_SCANCODE_END = 77;
  SDL_SCANCODE_PAGEDOWN = 78;
  SDL_SCANCODE_RIGHT = 79;
  SDL_SCANCODE_LEFT = 80;
  SDL_SCANCODE_DOWN = 81;
  SDL_SCANCODE_UP = 82;

  SDL_SCANCODE_NUMLOCKCLEAR = 83; {**< num lock on PC; clear on Mac keyboards
                                   *}
  SDL_SCANCODE_KP_DIVIDE = 84;
  SDL_SCANCODE_KP_MULTIPLY = 85;
  SDL_SCANCODE_KP_MINUS = 86;
  SDL_SCANCODE_KP_PLUS = 87;
  SDL_SCANCODE_KP_ENTER = 88;
  SDL_SCANCODE_KP_1 = 89;
  SDL_SCANCODE_KP_2 = 90;
  SDL_SCANCODE_KP_3 = 91;
  SDL_SCANCODE_KP_4 = 92;
  SDL_SCANCODE_KP_5 = 93;
  SDL_SCANCODE_KP_6 = 94;
  SDL_SCANCODE_KP_7 = 95;
  SDL_SCANCODE_KP_8 = 96;
  SDL_SCANCODE_KP_9 = 97;
  SDL_SCANCODE_KP_0 = 98;
  SDL_SCANCODE_KP_PERIOD = 99;

  SDL_SCANCODE_NONUSBACKSLASH = 100; {**< This is the additional key that ISO
                                      *   keyboards have over ANSI ones; 
                                      *   located between left shift and Y. 
                                      *   Produces GRAVE ACCENT and TILDE in a
                                      *   US or UK Mac layout; REVERSE SOLIDUS
                                      *   (backslash) and VERTICAL LINE in a 
                                      *   US or UK Windows layout; and 
                                      *   LESS-THAN SIGN and GREATER-THAN SIGN
                                      *   in a Swiss German; German; or French
                                      *   layout. *}
  SDL_SCANCODE_APPLICATION = 101;    {**< windows contextual menu; compose *}
  SDL_SCANCODE_POWER = 102;          {**< The USB document says this is a status flag;
                                       *  not a physical key - but some Mac keyboards
                                       *  do have a power key. *}
  SDL_SCANCODE_KP_EQUALS = 103;
  SDL_SCANCODE_F13 = 104;
  SDL_SCANCODE_F14 = 105;
  SDL_SCANCODE_F15 = 106;
  SDL_SCANCODE_F16 = 107;
  SDL_SCANCODE_F17 = 108;
  SDL_SCANCODE_F18 = 109;
  SDL_SCANCODE_F19 = 110;
  SDL_SCANCODE_F20 = 111;
  SDL_SCANCODE_F21 = 112;
  SDL_SCANCODE_F22 = 113;
  SDL_SCANCODE_F23 = 114;
  SDL_SCANCODE_F24 = 115;
  SDL_SCANCODE_EXECUTE = 116;
  SDL_SCANCODE_HELP = 117;
  SDL_SCANCODE_MENU = 118;
  SDL_SCANCODE_SELECT = 119;
  SDL_SCANCODE_STOP = 120;
  SDL_SCANCODE_AGAIN = 121;   {**< redo *}
  SDL_SCANCODE_UNDO = 122;
  SDL_SCANCODE_CUT = 123;
  SDL_SCANCODE_COPY = 124;
  SDL_SCANCODE_PASTE = 125;
  SDL_SCANCODE_FIND = 126;
  SDL_SCANCODE_MUTE = 127;
  SDL_SCANCODE_VOLUMEUP = 128;
  SDL_SCANCODE_VOLUMEDOWN = 129;
  {* not sure whether there's a reason to enable these *}
  {*     SDL_SCANCODE_LOCKINGCAPSLOCK = 130;  *}
  {*     SDL_SCANCODE_LOCKINGNUMLOCK = 131; *}
  {*     SDL_SCANCODE_LOCKINGSCROLLLOCK = 132; *}
  SDL_SCANCODE_KP_COMMA = 133;
  SDL_SCANCODE_KP_EQUALSAS400 = 134;

  SDL_SCANCODE_INTERNATIONAL1 = 135; {**< used on Asian keyboards; see footnotes in USB doc *}
  SDL_SCANCODE_INTERNATIONAL2 = 136;
  SDL_SCANCODE_INTERNATIONAL3 = 137; {**< Yen *}
  SDL_SCANCODE_INTERNATIONAL4 = 138;
  SDL_SCANCODE_INTERNATIONAL5 = 139;
  SDL_SCANCODE_INTERNATIONAL6 = 140;
  SDL_SCANCODE_INTERNATIONAL7 = 141;
  SDL_SCANCODE_INTERNATIONAL8 = 142;
  SDL_SCANCODE_INTERNATIONAL9 = 143;
  SDL_SCANCODE_LANG1 = 144; {**< Hangul{English toggle *}
  SDL_SCANCODE_LANG2 = 145; {**< Hanja conversion *}
  SDL_SCANCODE_LANG3 = 146; {**< Katakana *}
  SDL_SCANCODE_LANG4 = 147; {**< Hiragana *}
  SDL_SCANCODE_LANG5 = 148; {**< Zenkaku{Hankaku *}
  SDL_SCANCODE_LANG6 = 149; {**< reserved *}
  SDL_SCANCODE_LANG7 = 150; {**< reserved *}
  SDL_SCANCODE_LANG8 = 151; {**< reserved *}
  SDL_SCANCODE_LANG9 = 152; {**< reserved *}

  SDL_SCANCODE_ALTERASE = 153; {**< Erase-Eaze *}
  SDL_SCANCODE_SYSREQ = 154;
  SDL_SCANCODE_CANCEL = 155;
  SDL_SCANCODE_CLEAR = 156;
  SDL_SCANCODE_PRIOR = 157;
  SDL_SCANCODE_RETURN2 = 158;
  SDL_SCANCODE_SEPARATOR = 159;
  SDL_SCANCODE_OUT = 160;
  SDL_SCANCODE_OPER = 161;
  SDL_SCANCODE_CLEARAGAIN = 162;
  SDL_SCANCODE_CRSEL = 163;
  SDL_SCANCODE_EXSEL = 164;

  SDL_SCANCODE_KP_00 = 176;
  SDL_SCANCODE_KP_000 = 177;
  SDL_SCANCODE_THOUSANDSSEPARATOR = 178;
  SDL_SCANCODE_DECIMALSEPARATOR = 179;
  SDL_SCANCODE_CURRENCYUNIT = 180;
  SDL_SCANCODE_CURRENCYSUBUNIT = 181;
  SDL_SCANCODE_KP_LEFTPAREN = 182;
  SDL_SCANCODE_KP_RIGHTPAREN = 183;
  SDL_SCANCODE_KP_LEFTBRACE = 184;
  SDL_SCANCODE_KP_RIGHTBRACE = 185;
  SDL_SCANCODE_KP_TAB = 186;
  SDL_SCANCODE_KP_BACKSPACE = 187;
  SDL_SCANCODE_KP_A = 188;
  SDL_SCANCODE_KP_B = 189;
  SDL_SCANCODE_KP_C = 190;
  SDL_SCANCODE_KP_D = 191;
  SDL_SCANCODE_KP_E = 192;
  SDL_SCANCODE_KP_F = 193;
  SDL_SCANCODE_KP_XOR = 194;
  SDL_SCANCODE_KP_POWER = 195;
  SDL_SCANCODE_KP_PERCENT = 196;
  SDL_SCANCODE_KP_LESS = 197;
  SDL_SCANCODE_KP_GREATER = 198;
  SDL_SCANCODE_KP_AMPERSAND = 199;
  SDL_SCANCODE_KP_DBLAMPERSAND = 200;
  SDL_SCANCODE_KP_VERTICALBAR = 201;
  SDL_SCANCODE_KP_DBLVERTICALBAR = 202;
  SDL_SCANCODE_KP_COLON = 203;
  SDL_SCANCODE_KP_HASH = 204;
  SDL_SCANCODE_KP_SPACE = 205;
  SDL_SCANCODE_KP_AT = 206;
  SDL_SCANCODE_KP_EXCLAM = 207;
  SDL_SCANCODE_KP_MEMSTORE = 208;
  SDL_SCANCODE_KP_MEMRECALL = 209;
  SDL_SCANCODE_KP_MEMCLEAR = 210;
  SDL_SCANCODE_KP_MEMADD = 211;
  SDL_SCANCODE_KP_MEMSUBTRACT = 212;
  SDL_SCANCODE_KP_MEMMULTIPLY = 213;
  SDL_SCANCODE_KP_MEMDIVIDE = 214;
  SDL_SCANCODE_KP_PLUSMINUS = 215;
  SDL_SCANCODE_KP_CLEAR = 216;
  SDL_SCANCODE_KP_CLEARENTRY = 217;
  SDL_SCANCODE_KP_BINARY = 218;
  SDL_SCANCODE_KP_OCTAL = 219;
  SDL_SCANCODE_KP_DECIMAL = 220;
  SDL_SCANCODE_KP_HEXADECIMAL = 221;

  SDL_SCANCODE_LCTRL = 224;
  SDL_SCANCODE_LSHIFT = 225;
  SDL_SCANCODE_LALT = 226; {**< alt; option *}
  SDL_SCANCODE_LGUI = 227; {**< windows; command (apple); meta *}
  SDL_SCANCODE_RCTRL = 228;
  SDL_SCANCODE_RSHIFT = 229;
  SDL_SCANCODE_RALT = 230; {**< alt gr; option *}
  SDL_SCANCODE_RGUI = 231; {**< windows; command (apple); meta *}

  SDL_SCANCODE_MODE = 257;    {**< I'm not sure if this is really not covered 
                               *   by any of the above; but since there's a 
                               *   special KMOD_MODE for it I'm adding it here
                               *}
    
  {*Usage page $07*}

  {**
   *  Usage page $0C
   *
   *  These values are mapped from usage page $0C (USB consumer page).
   *}

  SDL_SCANCODE_AUDIONEXT = 258;
  SDL_SCANCODE_AUDIOPREV = 259;
  SDL_SCANCODE_AUDIOSTOP = 260;
  SDL_SCANCODE_AUDIOPLAY = 261;
  SDL_SCANCODE_AUDIOMUTE = 262;
  SDL_SCANCODE_MEDIASELECT = 263;
  SDL_SCANCODE_WWW = 264;
  SDL_SCANCODE_MAIL = 265;
  SDL_SCANCODE_CALCULATOR = 266;
  SDL_SCANCODE_COMPUTER = 267;
  SDL_SCANCODE_AC_SEARCH = 268;
  SDL_SCANCODE_AC_HOME = 269;
  SDL_SCANCODE_AC_BACK = 270;
  SDL_SCANCODE_AC_FORWARD = 271;
  SDL_SCANCODE_AC_STOP = 272;
  SDL_SCANCODE_AC_REFRESH = 273;
  SDL_SCANCODE_AC_BOOKMARKS = 274;

  {*Usage page $0C*}

  {**
   *  Walther keys
   *
   *  These are values that Christian Walther added (for mac keyboard?).
   *}

  SDL_SCANCODE_BRIGHTNESSDOWN = 275;
  SDL_SCANCODE_BRIGHTNESSUP = 276;
  SDL_SCANCODE_DISPLAYSWITCH = 277; {**< display mirroring{dual display
                                         switch; video mode switch *}
  SDL_SCANCODE_KBDILLUMTOGGLE = 278;
  SDL_SCANCODE_KBDILLUMDOWN = 279;
  SDL_SCANCODE_KBDILLUMUP = 280;
  SDL_SCANCODE_EJECT = 281;
  SDL_SCANCODE_SLEEP = 282;

	SDL_SCANCODE_APP1 = 283;
	SDL_SCANCODE_APP2 = 284;

  {*Walther keys*}

  {* Add any other keys here. *}

  SDL_NUM_SCANCODES = 512; {**< not a key, just marks the number of scancodes
                               for array bounds *}

type
  PSDL_ScanCode = ^TSDL_ScanCode;
  TSDL_ScanCode = DWord;

  //from "sdl_keycode.h"


  {**
   *  The SDL virtual key representation.
   *
   *  Values of this type are used to represent keyboard keys using the current
   *  layout of the keyboard.  These values include Unicode values representing
   *  the unmodified character that would be generated by pressing the key, or
   *  an SDLK_* constant for those keys that do not generate characters.
   *}
  PSDL_KeyCode = ^TSDL_KeyCode;
  TSDL_KeyCode = SInt32;

const
  SDLK_SCANCODE_MASK = 1 shl 30;

  SDLK_UNKNOWN = 0;

  SDLK_RETURN = '\r';
  SDLK_ESCAPE = '\033';
  SDLK_BACKSPACE = '\b';
  SDLK_TAB = '\t';
  SDLK_SPACE = ' ';
  SDLK_EXCLAIM = '!';
  SDLK_QUOTEDBL = '"';
  SDLK_HASH = '#';
  SDLK_PERCENT = '%';
  SDLK_DOLLAR = '$';
  SDLK_AMPERSAND = '&';
  SDLK_QUOTE = '\';
  SDLK_LEFTPAREN = '(';
  SDLK_RIGHTPAREN = ')';
  SDLK_ASTERISK = '*';
  SDLK_PLUS = '+';
  SDLK_COMMA = ';';
  SDLK_MINUS = '-';
  SDLK_PERIOD = '.';
  SDLK_SLASH = '/';
  SDLK_0 = '0';
  SDLK_1 = '1';
  SDLK_2 = '2';
  SDLK_3 = '3';
  SDLK_4 = '4';
  SDLK_5 = '5';
  SDLK_6 = '6';
  SDLK_7 = '7';
  SDLK_8 = '8';
  SDLK_9 = '9';
  SDLK_COLON = ':';
  SDLK_SEMICOLON = ';';
  SDLK_LESS = '<';
  SDLK_EQUALS = '=';
  SDLK_GREATER = '>';
  SDLK_QUESTION = '?';
  SDLK_AT = '@';
  {*
     Skip uppercase letters
   *}
  SDLK_LEFTBRACKET = '[';
  SDLK_BACKSLASH = '\\';
  SDLK_RIGHTBRACKET = ']';
  SDLK_CARET = '^';
  SDLK_UNDERSCORE = '_';
  SDLK_BACKQUOTE = '`';
  SDLK_a = 'a';
  SDLK_b = 'b';
  SDLK_c = 'c';
  SDLK_d = 'd';
  SDLK_e = 'e';
  SDLK_f = 'f';
  SDLK_g = 'g';
  SDLK_h = 'h';
  SDLK_i = 'i';
  SDLK_j = 'j';
  SDLK_k = 'k';
  SDLK_l = 'l';
  SDLK_m = 'm';
  SDLK_n = 'n';
  SDLK_o = 'o';
  SDLK_p = 'p';
  SDLK_q = 'q';
  SDLK_r = 'r';
  SDLK_s = 's';
  SDLK_t = 't';
  SDLK_u = 'u';
  SDLK_v = 'v';
  SDLK_w = 'w';
  SDLK_x = 'x';
  SDLK_y = 'y';
  SDLK_z = 'z';

  SDLK_CAPSLOCK = SDL_SCANCODE_CAPSLOCK or SDLK_SCANCODE_MASK;

  SDLK_F1 = SDL_SCANCODE_F1 or SDLK_SCANCODE_MASK;
  SDLK_F2 = SDL_SCANCODE_F2 or SDLK_SCANCODE_MASK;
  SDLK_F3 = SDL_SCANCODE_F3 or SDLK_SCANCODE_MASK;
  SDLK_F4 = SDL_SCANCODE_F4 or SDLK_SCANCODE_MASK;
  SDLK_F5 = SDL_SCANCODE_F5 or SDLK_SCANCODE_MASK;
  SDLK_F6 = SDL_SCANCODE_F6 or SDLK_SCANCODE_MASK;
  SDLK_F7 = SDL_SCANCODE_F7 or SDLK_SCANCODE_MASK;
  SDLK_F8 = SDL_SCANCODE_F8 or SDLK_SCANCODE_MASK;
  SDLK_F9 = SDL_SCANCODE_F9 or SDLK_SCANCODE_MASK;
  SDLK_F10 = SDL_SCANCODE_F10 or SDLK_SCANCODE_MASK;
  SDLK_F11 = SDL_SCANCODE_F11 or SDLK_SCANCODE_MASK;
  SDLK_F12 = SDL_SCANCODE_F12 or SDLK_SCANCODE_MASK;

  SDLK_PRINTSCREEN = SDL_SCANCODE_PRINTSCREEN or SDLK_SCANCODE_MASK;
  SDLK_SCROLLLOCK = SDL_SCANCODE_SCROLLLOCK or SDLK_SCANCODE_MASK;
  SDLK_PAUSE = SDL_SCANCODE_PAUSE or SDLK_SCANCODE_MASK;
  SDLK_INSERT = SDL_SCANCODE_INSERT or SDLK_SCANCODE_MASK;
  SDLK_HOME = SDL_SCANCODE_HOME or SDLK_SCANCODE_MASK;
  SDLK_PAGEUP = SDL_SCANCODE_PAGEUP or SDLK_SCANCODE_MASK;
  SDLK_DELETE = '\177';
  SDLK_END = SDL_SCANCODE_END or SDLK_SCANCODE_MASK;
  SDLK_PAGEDOWN = SDL_SCANCODE_PAGEDOWN or SDLK_SCANCODE_MASK;
  SDLK_RIGHT = SDL_SCANCODE_RIGHT or SDLK_SCANCODE_MASK;
  SDLK_LEFT = SDL_SCANCODE_LEFT or SDLK_SCANCODE_MASK;
  SDLK_DOWN = SDL_SCANCODE_DOWN or SDLK_SCANCODE_MASK;
  SDLK_UP = SDL_SCANCODE_UP or SDLK_SCANCODE_MASK;

  SDLK_NUMLOCKCLEAR = SDL_SCANCODE_NUMLOCKCLEAR or SDLK_SCANCODE_MASK;
  SDLK_KP_DIVIDE = SDL_SCANCODE_KP_DIVIDE or SDLK_SCANCODE_MASK;
  SDLK_KP_MULTIPLY = SDL_SCANCODE_KP_MULTIPLY or SDLK_SCANCODE_MASK;
  SDLK_KP_MINUS = SDL_SCANCODE_KP_MINUS or SDLK_SCANCODE_MASK;
  SDLK_KP_PLUS = SDL_SCANCODE_KP_PLUS or SDLK_SCANCODE_MASK;
  SDLK_KP_ENTER = SDL_SCANCODE_KP_ENTER or SDLK_SCANCODE_MASK;
  SDLK_KP_1 = SDL_SCANCODE_KP_1 or SDLK_SCANCODE_MASK;
  SDLK_KP_2 = SDL_SCANCODE_KP_2 or SDLK_SCANCODE_MASK;
  SDLK_KP_3 = SDL_SCANCODE_KP_3 or SDLK_SCANCODE_MASK;
  SDLK_KP_4 = SDL_SCANCODE_KP_4 or SDLK_SCANCODE_MASK;
  SDLK_KP_5 = SDL_SCANCODE_KP_5 or SDLK_SCANCODE_MASK;
  SDLK_KP_6 = SDL_SCANCODE_KP_6 or SDLK_SCANCODE_MASK;
  SDLK_KP_7 = SDL_SCANCODE_KP_7 or SDLK_SCANCODE_MASK;
  SDLK_KP_8 = SDL_SCANCODE_KP_8 or SDLK_SCANCODE_MASK;
  SDLK_KP_9 = SDL_SCANCODE_KP_9 or SDLK_SCANCODE_MASK;
  SDLK_KP_0 = SDL_SCANCODE_KP_0 or SDLK_SCANCODE_MASK;
  SDLK_KP_PERIOD = SDL_SCANCODE_KP_PERIOD or SDLK_SCANCODE_MASK;

  SDLK_APPLICATION = SDL_SCANCODE_APPLICATION or SDLK_SCANCODE_MASK;
  SDLK_POWER = SDL_SCANCODE_POWER or SDLK_SCANCODE_MASK;
  SDLK_KP_EQUALS = SDL_SCANCODE_KP_EQUALS or SDLK_SCANCODE_MASK;
  SDLK_F13 = SDL_SCANCODE_F13 or SDLK_SCANCODE_MASK;
  SDLK_F14 = SDL_SCANCODE_F14 or SDLK_SCANCODE_MASK;
  SDLK_F15 = SDL_SCANCODE_F15 or SDLK_SCANCODE_MASK;
  SDLK_F16 = SDL_SCANCODE_F16 or SDLK_SCANCODE_MASK;
  SDLK_F17 = SDL_SCANCODE_F17 or SDLK_SCANCODE_MASK;
  SDLK_F18 = SDL_SCANCODE_F18 or SDLK_SCANCODE_MASK;
  SDLK_F19 = SDL_SCANCODE_F19 or SDLK_SCANCODE_MASK;
  SDLK_F20 = SDL_SCANCODE_F20 or SDLK_SCANCODE_MASK;
  SDLK_F21 = SDL_SCANCODE_F21 or SDLK_SCANCODE_MASK;
  SDLK_F22 = SDL_SCANCODE_F22 or SDLK_SCANCODE_MASK;
  SDLK_F23 = SDL_SCANCODE_F23 or SDLK_SCANCODE_MASK;
  SDLK_F24 = SDL_SCANCODE_F24 or SDLK_SCANCODE_MASK;
  SDLK_EXECUTE = SDL_SCANCODE_EXECUTE or SDLK_SCANCODE_MASK;
  SDLK_HELP = SDL_SCANCODE_HELP or SDLK_SCANCODE_MASK;
  SDLK_MENU = SDL_SCANCODE_MENU or SDLK_SCANCODE_MASK;
  SDLK_SELECT = SDL_SCANCODE_SELECT or SDLK_SCANCODE_MASK;
  SDLK_STOP = SDL_SCANCODE_STOP or SDLK_SCANCODE_MASK;
  SDLK_AGAIN = SDL_SCANCODE_AGAIN or SDLK_SCANCODE_MASK;
  SDLK_UNDO = SDL_SCANCODE_UNDO or SDLK_SCANCODE_MASK;
  SDLK_CUT = SDL_SCANCODE_CUT or SDLK_SCANCODE_MASK;
  SDLK_COPY = SDL_SCANCODE_COPY or SDLK_SCANCODE_MASK;
  SDLK_PASTE = SDL_SCANCODE_PASTE or SDLK_SCANCODE_MASK;
  SDLK_FIND = SDL_SCANCODE_FIND or SDLK_SCANCODE_MASK;
  SDLK_MUTE = SDL_SCANCODE_MUTE or SDLK_SCANCODE_MASK;
  SDLK_VOLUMEUP = SDL_SCANCODE_VOLUMEUP or SDLK_SCANCODE_MASK;
  SDLK_VOLUMEDOWN = SDL_SCANCODE_VOLUMEDOWN or SDLK_SCANCODE_MASK;
  SDLK_KP_COMMA = SDL_SCANCODE_KP_COMMA or SDLK_SCANCODE_MASK;
  SDLK_KP_EQUALSAS400 = SDL_SCANCODE_KP_EQUALSAS400 or SDLK_SCANCODE_MASK;

  SDLK_ALTERASE = SDL_SCANCODE_ALTERASE or SDLK_SCANCODE_MASK;
  SDLK_SYSREQ = SDL_SCANCODE_SYSREQ or SDLK_SCANCODE_MASK;
  SDLK_CANCEL = SDL_SCANCODE_CANCEL or SDLK_SCANCODE_MASK;
  SDLK_CLEAR = SDL_SCANCODE_CLEAR or SDLK_SCANCODE_MASK;
  SDLK_PRIOR = SDL_SCANCODE_PRIOR or SDLK_SCANCODE_MASK;
  SDLK_RETURN2 = SDL_SCANCODE_RETURN2 or SDLK_SCANCODE_MASK;
  SDLK_SEPARATOR = SDL_SCANCODE_SEPARATOR or SDLK_SCANCODE_MASK;
  SDLK_OUT = SDL_SCANCODE_OUT or SDLK_SCANCODE_MASK;
  SDLK_OPER = SDL_SCANCODE_OPER or SDLK_SCANCODE_MASK;
  SDLK_CLEARAGAIN = SDL_SCANCODE_CLEARAGAIN or SDLK_SCANCODE_MASK;
  SDLK_CRSEL = SDL_SCANCODE_CRSEL or SDLK_SCANCODE_MASK;
  SDLK_EXSEL = SDL_SCANCODE_EXSEL or SDLK_SCANCODE_MASK;

  SDLK_KP_00 = SDL_SCANCODE_KP_00 or SDLK_SCANCODE_MASK;
  SDLK_KP_000 = SDL_SCANCODE_KP_000 or SDLK_SCANCODE_MASK;
  SDLK_THOUSANDSSEPARATOR = SDL_SCANCODE_THOUSANDSSEPARATOR or SDLK_SCANCODE_MASK;
  SDLK_DECIMALSEPARATOR = SDL_SCANCODE_DECIMALSEPARATOR or SDLK_SCANCODE_MASK;
  SDLK_CURRENCYUNIT = SDL_SCANCODE_CURRENCYUNIT or SDLK_SCANCODE_MASK;
  SDLK_CURRENCYSUBUNIT = SDL_SCANCODE_CURRENCYSUBUNIT or SDLK_SCANCODE_MASK;
  SDLK_KP_LEFTPAREN = SDL_SCANCODE_KP_LEFTPAREN or SDLK_SCANCODE_MASK;
  SDLK_KP_RIGHTPAREN = SDL_SCANCODE_KP_RIGHTPAREN or SDLK_SCANCODE_MASK;
  SDLK_KP_LEFTBRACE = SDL_SCANCODE_KP_LEFTBRACE or SDLK_SCANCODE_MASK;
  SDLK_KP_RIGHTBRACE = SDL_SCANCODE_KP_RIGHTBRACE or SDLK_SCANCODE_MASK;
  SDLK_KP_TAB = SDL_SCANCODE_KP_TAB or SDLK_SCANCODE_MASK;
  SDLK_KP_BACKSPACE = SDL_SCANCODE_KP_BACKSPACE or SDLK_SCANCODE_MASK;
  SDLK_KP_A = SDL_SCANCODE_KP_A or SDLK_SCANCODE_MASK;
  SDLK_KP_B = SDL_SCANCODE_KP_B or SDLK_SCANCODE_MASK;
  SDLK_KP_C = SDL_SCANCODE_KP_C or SDLK_SCANCODE_MASK;
  SDLK_KP_D = SDL_SCANCODE_KP_D or SDLK_SCANCODE_MASK;
  SDLK_KP_E = SDL_SCANCODE_KP_E or SDLK_SCANCODE_MASK;
  SDLK_KP_F = SDL_SCANCODE_KP_F or SDLK_SCANCODE_MASK;
  SDLK_KP_XOR = SDL_SCANCODE_KP_XOR or SDLK_SCANCODE_MASK;
  SDLK_KP_POWER = SDL_SCANCODE_KP_POWER or SDLK_SCANCODE_MASK;
  SDLK_KP_PERCENT = SDL_SCANCODE_KP_PERCENT or SDLK_SCANCODE_MASK;
  SDLK_KP_LESS = SDL_SCANCODE_KP_LESS or SDLK_SCANCODE_MASK;
  SDLK_KP_GREATER = SDL_SCANCODE_KP_GREATER or SDLK_SCANCODE_MASK;
  SDLK_KP_AMPERSAND = SDL_SCANCODE_KP_AMPERSAND or SDLK_SCANCODE_MASK;
  SDLK_KP_DBLAMPERSAND = SDL_SCANCODE_KP_DBLAMPERSAND or SDLK_SCANCODE_MASK;
  SDLK_KP_VERTICALBAR = SDL_SCANCODE_KP_VERTICALBAR or SDLK_SCANCODE_MASK;
  SDLK_KP_DBLVERTICALBAR = SDL_SCANCODE_KP_DBLVERTICALBAR or SDLK_SCANCODE_MASK;
  SDLK_KP_COLON = SDL_SCANCODE_KP_COLON or SDLK_SCANCODE_MASK;
  SDLK_KP_HASH = SDL_SCANCODE_KP_HASH or SDLK_SCANCODE_MASK;
  SDLK_KP_SPACE = SDL_SCANCODE_KP_SPACE or SDLK_SCANCODE_MASK;
  SDLK_KP_AT = SDL_SCANCODE_KP_AT or SDLK_SCANCODE_MASK;
  SDLK_KP_EXCLAM = SDL_SCANCODE_KP_EXCLAM or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMSTORE = SDL_SCANCODE_KP_MEMSTORE or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMRECALL = SDL_SCANCODE_KP_MEMRECALL or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMCLEAR = SDL_SCANCODE_KP_MEMCLEAR or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMADD = SDL_SCANCODE_KP_MEMADD or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMSUBTRACT = SDL_SCANCODE_KP_MEMSUBTRACT or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMMULTIPLY = SDL_SCANCODE_KP_MEMMULTIPLY or SDLK_SCANCODE_MASK;
  SDLK_KP_MEMDIVIDE = SDL_SCANCODE_KP_MEMDIVIDE or SDLK_SCANCODE_MASK;
  SDLK_KP_PLUSMINUS = SDL_SCANCODE_KP_PLUSMINUS or SDLK_SCANCODE_MASK;
  SDLK_KP_CLEAR = SDL_SCANCODE_KP_CLEAR or SDLK_SCANCODE_MASK;
  SDLK_KP_CLEARENTRY = SDL_SCANCODE_KP_CLEARENTRY or SDLK_SCANCODE_MASK;
  SDLK_KP_BINARY = SDL_SCANCODE_KP_BINARY or SDLK_SCANCODE_MASK;
  SDLK_KP_OCTAL = SDL_SCANCODE_KP_OCTAL or SDLK_SCANCODE_MASK;
  SDLK_KP_DECIMAL = SDL_SCANCODE_KP_DECIMAL or SDLK_SCANCODE_MASK;
  SDLK_KP_HEXADECIMAL = SDL_SCANCODE_KP_HEXADECIMAL or SDLK_SCANCODE_MASK;

  SDLK_LCTRL = SDL_SCANCODE_LCTRL or SDLK_SCANCODE_MASK;
  SDLK_LSHIFT = SDL_SCANCODE_LSHIFT or SDLK_SCANCODE_MASK;
  SDLK_LALT = SDL_SCANCODE_LALT or SDLK_SCANCODE_MASK;
  SDLK_LGUI = SDL_SCANCODE_LGUI or SDLK_SCANCODE_MASK;
  SDLK_RCTRL = SDL_SCANCODE_RCTRL or SDLK_SCANCODE_MASK;
  SDLK_RSHIFT = SDL_SCANCODE_RSHIFT or SDLK_SCANCODE_MASK;
  SDLK_RALT = SDL_SCANCODE_RALT or SDLK_SCANCODE_MASK;
  SDLK_RGUI = SDL_SCANCODE_RGUI or SDLK_SCANCODE_MASK;

  SDLK_MODE = SDL_SCANCODE_MODE or SDLK_SCANCODE_MASK;

  SDLK_AUDIONEXT = SDL_SCANCODE_AUDIONEXT or SDLK_SCANCODE_MASK;
  SDLK_AUDIOPREV = SDL_SCANCODE_AUDIOPREV or SDLK_SCANCODE_MASK;
  SDLK_AUDIOSTOP = SDL_SCANCODE_AUDIOSTOP or SDLK_SCANCODE_MASK;
  SDLK_AUDIOPLAY = SDL_SCANCODE_AUDIOPLAY or SDLK_SCANCODE_MASK;
  SDLK_AUDIOMUTE = SDL_SCANCODE_AUDIOMUTE or SDLK_SCANCODE_MASK;
  SDLK_MEDIASELECT = SDL_SCANCODE_MEDIASELECT or SDLK_SCANCODE_MASK;
  SDLK_WWW = SDL_SCANCODE_WWW or SDLK_SCANCODE_MASK;
  SDLK_MAIL = SDL_SCANCODE_MAIL or SDLK_SCANCODE_MASK;
  SDLK_CALCULATOR = SDL_SCANCODE_CALCULATOR or SDLK_SCANCODE_MASK;
  SDLK_COMPUTER = SDL_SCANCODE_COMPUTER or SDLK_SCANCODE_MASK;
  SDLK_AC_SEARCH = SDL_SCANCODE_AC_SEARCH or SDLK_SCANCODE_MASK;
  SDLK_AC_HOME = SDL_SCANCODE_AC_HOME or SDLK_SCANCODE_MASK;
  SDLK_AC_BACK = SDL_SCANCODE_AC_BACK or SDLK_SCANCODE_MASK;
  SDLK_AC_FORWARD = SDL_SCANCODE_AC_FORWARD or SDLK_SCANCODE_MASK;
  SDLK_AC_STOP = SDL_SCANCODE_AC_STOP or SDLK_SCANCODE_MASK;
  SDLK_AC_REFRESH = SDL_SCANCODE_AC_REFRESH or SDLK_SCANCODE_MASK;
  SDLK_AC_BOOKMARKS = SDL_SCANCODE_AC_BOOKMARKS or SDLK_SCANCODE_MASK;

  SDLK_BRIGHTNESSDOWN = SDL_SCANCODE_BRIGHTNESSDOWN or SDLK_SCANCODE_MASK;
  SDLK_BRIGHTNESSUP = SDL_SCANCODE_BRIGHTNESSUP or SDLK_SCANCODE_MASK;
  SDLK_DISPLAYSWITCH = SDL_SCANCODE_DISPLAYSWITCH or SDLK_SCANCODE_MASK;
  SDLK_KBDILLUMTOGGLE = SDL_SCANCODE_KBDILLUMTOGGLE or SDLK_SCANCODE_MASK;
  SDLK_KBDILLUMDOWN = SDL_SCANCODE_KBDILLUMDOWN or SDLK_SCANCODE_MASK;
  SDLK_KBDILLUMUP = SDL_SCANCODE_KBDILLUMUP or SDLK_SCANCODE_MASK;
  SDLK_EJECT = SDL_SCANCODE_EJECT or SDLK_SCANCODE_MASK;
  SDLK_SLEEP = SDL_SCANCODE_SLEEP or SDLK_SCANCODE_MASK;

  {**
   *  Enumeration of valid key mods (possibly OR'd together).
   *}

  KMOD_NONE = $0000;
  KMOD_LSHIFT = $0001;
  KMOD_RSHIFT = $0002;
  KMOD_LCTRL = $0040;
  KMOD_RCTRL = $0080;
  KMOD_LALT = $0100;
  KMOD_RALT = $0200;
  KMOD_LGUI = $0400;
  KMOD_RGUI = $0800;
  KMOD_NUM = $1000;
  KMOD_CAPS = $2000;
  KMOD_MODE = $4000;
  KMOD_RESERVED = $8000;

type
  PSDL_KeyMod = ^TSDL_KeyMod;
  TSDL_KeyMod = Word;

const
  KMOD_CTRL	 = KMOD_LCTRL  or KMOD_RCTRL;
  KMOD_SHIFT = KMOD_LSHIFT or KMOD_RSHIFT;
  KMOD_ALT	 = KMOD_LALT   or KMOD_RALT;
  KMOD_GUI	 = KMOD_LGUI   or KMOD_RGUI;

  //from "sdl_keyboard.h"

type  
  {**
   *  The SDL keysym structure, used in key events.
   *}
  PSDL_Keysym = ^TSDL_Keysym;
  TSDL_Keysym = record
    scancode: TSDL_ScanCode;      // SDL physical key code - see SDL_Scancode for details
    sym: TSDL_KeyCode;            // SDL virtual key code - see SDL_Keycode for details
    _mod: UInt16;                 // current key modifiers
    unicode: UInt32;              // (deprecated) use SDL_TextInputEvent instead
  end;

  {**
   *  Get the window which currently has keyboard focus.
   *}

  function SDL_GetKeyboardFocus: PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_GetKeyboardFocus' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a snapshot of the current state of the keyboard.
   *
   *  numkeys if non-nil, receives the length of the returned array.
   *  
   *  An array of key states. Indexes into this array are obtained by using SDL_Scancode values.
   *
   *}

  function SDL_GetKeyboardState(numkeys: PInt): PUInt8 cdecl; external {$IFDEF GPC} name 'SDL_GetKeyboardState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the current key modifier state for the keyboard.
   *}

  function SDL_GetModState: TSDL_KeyMod cdecl; external {$IFDEF GPC} name 'SDL_GetModState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the current key modifier state for the keyboard.
   *  
   *  This does not change the keyboard state, only the key modifier flags.
   *}

  procedure SDL_SetModState(modstate: TSDL_KeyMod) cdecl; external {$IFDEF GPC} name 'SDL_SetModState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the key code corresponding to the given scancode according
   *         to the current keyboard layout.
   *
   *  See SDL_Keycode for details.
   *  
   *  SDL_GetKeyName()
   *}

  function SDL_GetKeyFromScancode(scancode: TSDL_ScanCode): TSDL_KeyCode cdecl; external {$IFDEF GPC} name 'SDL_GetKeyFromScancode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the scancode corresponding to the given key code according to the
   *         current keyboard layout.
   *
   *  See SDL_Scancode for details.
   *
   *  SDL_GetScancodeName()
   *}

  function SDL_GetScancodeFromKey(key: TSDL_KeyCode): TSDL_ScanCode cdecl; external {$IFDEF GPC} name 'SDL_GetScancodeFromKey' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a human-readable name for a scancode.
   *
   *  A pointer to the name for the scancode.
   *
   *  If the scancode doesn't have a name, this function returns
   *  an empty string ("").
   *
   *}

  function SDL_GetScancodeName(scancode: TSDL_ScanCode): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetScancodeName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a scancode from a human-readable name
   *
   *  scancode, or SDL_SCANCODE_UNKNOWN if the name wasn't recognized
   *
   *  SDL_Scancode
   *}

  function SDL_GetScancodeFromName(const name: PAnsiChar): TSDL_ScanCode cdecl; external {$IFDEF GPC} name 'SDL_GetScancodeFromName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a human-readable name for a key.
   *
   *  A pointer to a UTF-8 string that stays valid at least until the next
   *  call to this function. If you need it around any longer, you must
   *  copy it.  If the key doesn't have a name, this function returns an
   *  empty string ("").
   *  
   *  SDL_Key
   *}

  function SDL_GetKeyName(key: TSDL_ScanCode): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_GetKeyName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get a key code from a human-readable name
   *
   *  key code, or SDLK_UNKNOWN if the name wasn't recognized
   *
   *  SDL_Keycode
   *}

  function SDL_GetKeyFromName(const name: PAnsiChar): TSDL_KeyCode cdecl; external {$IFDEF GPC} name 'SDL_GetKeyFromName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Start accepting Unicode text input events.
   *  This function will show the on-screen keyboard if supported.
   *  
   *  SDL_StopTextInput()
   *  SDL_SetTextInputRect()
   *  SDL_HasScreenKeyboardSupport()
   *}

  procedure SDL_StartTextInput cdecl; external {$IFDEF GPC} name 'SDL_StartTextInput' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return whether or not Unicode text input events are enabled.
   *
   *  SDL_StartTextInput()
   *  SDL_StopTextInput()
   *}

  function SDL_IsTextInputActive: TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_IsTextInputActive' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Stop receiving any text input events.
   *  This function will hide the on-screen keyboard if supported.
   *  
   *  SDL_StartTextInput()
   *  SDL_HasScreenKeyboardSupport()
   *}

  procedure SDL_StopTextInput cdecl; external {$IFDEF GPC} name 'SDL_StopTextInput' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the rectangle used to type Unicode text inputs.
   *  This is used as a hint for IME and on-screen keyboard placement.
   *  
   *  SDL_StartTextInput()
   *}

  procedure SDL_SetTextInputRect(rect: PSDL_Rect) cdecl; external {$IFDEF GPC} name 'SDL_SetTextInputRect' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns whether the platform has some screen keyboard support.
   *  
   *  SDL_TRUE if some keyboard support is available else SDL_FALSE.
   *
   *  Not all screen keyboard functions are supported on all platforms.
   *
   *  SDL_IsScreenKeyboardShown()
   *}

  function SDL_HasScreenKeyboardSupport: TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_HasScreenKeyboardSupport' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns whether the screen keyboard is shown for given window.
   *
   *  window The window for which screen keyboard should be queried.
   *
   *  Result - SDL_TRUE if screen keyboard is shown else SDL_FALSE.
   *
   *  SDL_HasScreenKeyboardSupport()
   *}

  function SDL_IsScreenKeyboardShown(window: PSDL_Window): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_IsScreenKeyboardShown' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_mouse.h"
type
  PSDL_Cursor = Pointer;
  
const

  {**
   *  Cursor types for SDL_CreateSystemCursor.
   *}

  SDL_SYSTEM_CURSOR_ARROW = 0;     // Arrow
  SDL_SYSTEM_CURSOR_IBEAM = 1;     // I-beam
  SDL_SYSTEM_CURSOR_WAIT = 2;      // Wait
  SDL_SYSTEM_CURSOR_CROSSHAIR = 3; // Crosshair
  SDL_SYSTEM_CURSOR_WAITARROW = 4; // Small wait cursor (or Wait if not available)
  SDL_SYSTEM_CURSOR_SIZENWSE = 5;  // Double arrow pointing northwest and southeast
  SDL_SYSTEM_CURSOR_SIZENESW = 6;  // Double arrow pointing northeast and southwest
  SDL_SYSTEM_CURSOR_SIZEWE = 7;    // Double arrow pointing west and east
  SDL_SYSTEM_CURSOR_SIZENS = 8;    // Double arrow pointing north and south
  SDL_SYSTEM_CURSOR_SIZEALL = 9;   // Four pointed arrow pointing north, south, east, and west
  SDL_SYSTEM_CURSOR_NO = 10;        // Slashed circle or crossbones
  SDL_SYSTEM_CURSOR_HAND = 11;      // Hand
  SDL_NUM_SYSTEM_CURSORS = 12;

type
  PSDL_SystemCursor = ^TSDL_SystemCursor;
  TSDL_SystemCursor = Word;

  {* Function prototypes *}

  {**
   *  Get the window which currently has mouse focus.
   *}

  function SDL_GetMouseFocus: PSDL_Window cdecl; external {$IFDEF GPC} name 'SDL_GetMouseFocus' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Retrieve the current state of the mouse.
   *  
   *  The current button state is returned as a button bitmask, which can
   *  be tested using the SDL_BUTTON(X) macros, and x and y are set to the
   *  mouse cursor position relative to the focus window for the currently
   *  selected mouse.  You can pass nil for either x or y.
   *
   * SDL_Button = 1 shl ((X)-1)
   *}

  function SDL_GetMouseState(x: PInt; y: PInt): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetMouseState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Retrieve the relative state of the mouse.
   *
   *  The current button state is returned as a button bitmask, which can
   *  be tested using the SDL_BUTTON(X) macros, and x and y are set to the
   *  mouse deltas since the last call to SDL_GetRelativeMouseState().
   *}

  function SDL_GetRelativeMouseState(x: PInt; y: PInt): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetRelativeMouseState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Moves the mouse to the given position within the window.
   *
   *   window The window to move the mouse into, or nil for the current mouse focus
   *   x The x coordinate within the window
   *   y The y coordinate within the window
   *
   *  This function generates a mouse motion event
   *}

  procedure SDL_WarpMouseInWindow(window: PSDL_Window; x: SInt32; y: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_WarpMouseInWindow' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set relative mouse mode.
   *
   *  enabled Whether or not to enable relative mode
   *
   *  0 on success, or -1 if relative mode is not supported.
   *
   *  While the mouse is in relative mode, the cursor is hidden, and the
   *  driver will try to report continuous motion in the current window.
   *  Only relative motion events will be delivered, the mouse position
   *  will not change.
   *  
   *  This function will flush any pending mouse motion.
   *  
   *  SDL_GetRelativeMouseMode()
   *}

  function SDL_SetRelativeMouseMode(enabled: TSDL_Bool): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SetRelativeMouseMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Query whether relative mouse mode is enabled.
   *  
   *  SDL_SetRelativeMouseMode()
   *}

  function SDL_GetRelativeMouseMode: TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_GetRelativeMouseMode' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a cursor, using the specified bitmap data and
   *  mask (in MSB format).
   *
   *  The cursor width must be a multiple of 8 bits.
   *
   *  The cursor is created in black and white according to the following:
   *  <table>
   *  <tr><td> data </td><td> mask </td><td> resulting pixel on screen </td></tr>
   *  <tr><td>  0   </td><td>  1   </td><td> White </td></tr>
   *  <tr><td>  1   </td><td>  1   </td><td> Black </td></tr>
   *  <tr><td>  0   </td><td>  0   </td><td> Transparent </td></tr>
   *  <tr><td>  1   </td><td>  0   </td><td> Inverted color if possible, black 
   *                                         if not. </td></tr>
   *  </table>
   *  
   *  SDL_FreeCursor()
   *}

  function SDL_CreateCursor(const data: PUInt8; const mask: PUInt8; w: SInt32; h: SInt32; hot_x: SInt32; hot_y: SInt32): PSDL_Cursor cdecl; external {$IFDEF GPC} name 'SDL_CreateCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a color cursor.
   *
   *  SDL_FreeCursor()
   *}

  function SDL_CreateColorCursor(surface: PSDL_Surface; hot_x: SInt32; hot_y: SInt32): PSDL_Cursor cdecl; external {$IFDEF GPC} name 'SDL_CreateColorCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Create a system cursor.
   *
   *  SDL_FreeCursor()
   *}

  function SDL_CreateSystemCursor(id: TSDL_SystemCursor): PSDL_Cursor cdecl; external {$IFDEF GPC} name 'SDL_CreateSystemCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Set the active cursor.
   *}

  procedure SDL_SetCursor(cursor: PSDL_Cursor) cdecl; external {$IFDEF GPC} name 'SDL_SetCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return the active cursor.
   *}

  function SDL_GetCursor: PSDL_Cursor cdecl; external {$IFDEF GPC} name 'SDL_GetCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Frees a cursor created with SDL_CreateCursor().
   *
   *  SDL_CreateCursor()
   *}

  procedure SDL_FreeCursor(cursor: PSDL_Cursor) cdecl; external {$IFDEF GPC} name 'SDL_FreeCursor' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Toggle whether or not the cursor is shown.
   *
   *  toggle 1 to show the cursor, 0 to hide it, -1 to query the current
   *                state.
   *  
   *  1 if the cursor is shown, or 0 if the cursor is hidden.
   *}

  function SDL_ShowCursor(toggle: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_ShowCursor' {$ELSE} SDL_LibName {$ENDIF};

const
  {**
   *  Used as a mask when testing buttons in buttonstate.
   *   - Button 1:  Left mouse button
   *   - Button 2:  Middle mouse button
   *   - Button 3:  Right mouse button
   *}

  SDL_BUTTON_LEFT	= 1;
  SDL_BUTTON_MIDDLE	= 2;
  SDL_BUTTON_RIGHT	= 3;
  SDL_BUTTON_X1	    = 4;
  SDL_BUTTON_X2	    = 5;
  SDL_BUTTON_LMASK  = 1 shl ((SDL_BUTTON_LEFT) - 1);
  SDL_BUTTON_MMASK  = 1 shl ((SDL_BUTTON_MIDDLE) - 1);
  SDL_BUTTON_RMASK  = 1 shl ((SDL_BUTTON_RIGHT) - 1);
  SDL_BUTTON_X1MASK = 1 shl ((SDL_BUTTON_X1) - 1);
  SDL_BUTTON_X2MASK = 1 shl ((SDL_BUTTON_X2) - 1);

  //from "sdl_joystick.h"

  {**
   *  SDL_joystick.h
   *
   *  In order to use these functions, SDL_Init() must have been called
   *  with the ::SDL_INIT_JOYSTICK flag.  This causes SDL to scan the system
   *  for joysticks, and load appropriate drivers.
   *}

type

  {* The joystick structure used to identify an SDL joystick *}
  PSDL_Joystick = Pointer; // todo!!

{* A structure that encodes the stable unique id for a joystick device *}

  TSDL_JoystickGUID = record
    data: array[0..15] of UInt8;
  end;

  TSDL_JoystickID = SInt32;

  {* Function prototypes *}
  {**
   *  Count the number of joysticks attached to the system right now
   *}
function SDL_NumJoysticks: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_NumJoysticks' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the implementation dependent name of a joystick.
   *  This can be called before any joysticks are opened.
   *  If no name can be found, this function returns NULL.
   *}
function SDL_JoystickNameForIndex(device_index: SInt32): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_JoystickNameForIndex' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Open a joystick for use.
   *  The index passed as an argument refers tothe N'th joystick on the system.
   *  This index is the value which will identify this joystick in future joystick
   *  events.
   *
   *  A joystick identifier, or NULL if an error occurred.
   *}
function SDL_JoystickOpen(device_index: SInt32): PSDL_Joystick cdecl; external {$IFDEF GPC} name 'SDL_JoystickOpen' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return the name for this currently opened joystick.
   *  If no name can be found, this function returns NULL.
   *}
function SDL_JoystickName(joystick: PSDL_Joystick): PAnsiChar cdecl; external {$IFDEF GPC} name 'SDL_JoystickName' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return the GUID for the joystick at this index
   *}
function SDL_JoystickGetDeviceGUID(device_index: SInt32): TSDL_JoystickGUID cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetDeviceGUID' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return the GUID for this opened joystick
   *}
function SDL_JoystickGetGUID(joystick: PSDL_Joystick): TSDL_JoystickGUID cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetGUID' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return a string representation for this guid. pszGUID must point to at least 33 bytes
   *  (32 for the string plus a NULL terminator).
   *}
procedure SDL_JoystickGetGUIDString(guid: TSDL_JoystickGUId; pszGUID: PAnsiChar; cbGUID: SInt32) cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetGUIDString' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  convert a string into a joystick formatted guid
   *}
function SDL_JoystickGetGUIDFromString(const pchGUID: PAnsiChar): TSDL_JoystickGUID cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetGUIDFromString' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Returns SDL_TRUE if the joystick has been opened and currently connected, or SDL_FALSE if it has not.
   *}
function SDL_JoystickGetAttached(joystick: PSDL_Joystick): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetAttached' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the instance ID of an opened joystick or -1 if the joystick is invalid.
   *}
function SDL_JoystickInstanceID(joystick: PSDL_Joystick): TSDL_JoystickID cdecl; external {$IFDEF GPC} name 'SDL_JoystickInstanceID' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the number of general axis controls on a joystick.
   *}
function SDL_JoystickNumAxes(joystick: PSDL_Joystick): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickNumAxes' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the number of trackballs on a joystick.
   *
   *  Joystick trackballs have only relative motion events associated
   *  with them and their state cannot be polled.
   *}
function SDL_JoystickNumBalls(joystick: PSDL_Joystick): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickNumBalls' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the number of POV hats on a joystick.
   *}
function SDL_JoystickNumHats(joystick: PSDL_Joystick): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickNumHats' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the number of buttons on a joystick.
   *}
function SDL_JoystickNumButtons(joystick: PSDL_Joystick): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickNumButtons' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Update the current state of the open joysticks.
   *
   *  This is called automatically by the event loop if any joystick
   *  events are enabled.
   *}
procedure SDL_JoystickUpdate cdecl; external {$IFDEF GPC} name 'SDL_JoystickUpdate' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Enable/disable joystick event polling.
   *
   *  If joystick events are disabled, you must call SDL_JoystickUpdate()
   *  yourself and check the state of the joystick when you want joystick
   *  information.
   *
   *  The state can be one of ::SDL_QUERY, ::SDL_ENABLE or ::SDL_IGNORE.
   *}
function SDL_JoystickEventState(state: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickEventState' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the current state of an axis control on a joystick.
   *
   *  The state is a value ranging from -32768 to 32767.
   *
   *  The axis indices start at index 0.
   *}
function SDL_JoystickGetAxis(joystick: PSDL_Joystick; axis: SInt32): SInt16 cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetAxis' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Hat positions
   *}
const
  SDL_HAT_CENTERED  = $00;
  SDL_HAT_UP        = $01;
  SDL_HAT_RIGHT     = $02;
  SDL_HAT_DOWN      = $04;
  SDL_HAT_LEFT      = $08;
  SDL_HAT_RIGHTUP   = SDL_HAT_RIGHT or SDL_HAT_UP;
  SDL_HAT_RIGHTDOWN = SDL_HAT_RIGHT or SDL_HAT_DOWN;
  SDL_HAT_LEFTUP    = SDL_HAT_LEFT or SDL_HAT_UP;
  SDL_HAT_LEFTDOWN  = SDL_HAT_LEFT or SDL_HAT_DOWN;

  {**
   *  Get the current state of a POV hat on a joystick.
   *
   *  The hat indices start at index 0.
   *
   *  The return value is one of the following positions:
   *   - SDL_HAT_CENTERED
   *   - SDL_HAT_UP
   *   - SDL_HAT_RIGHT
   *   - SDL_HAT_DOWN
   *   - SDL_HAT_LEFT
   *   - SDL_HAT_RIGHTUP
   *   - SDL_HAT_RIGHTDOWN
   *   - SDL_HAT_LEFTUP
   *   - SDL_HAT_LEFTDOWN
   *}
function SDL_JoystickGetHat(joystick: PSDL_Joystick; hat: SInt32): UInt8 cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetHat' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the ball axis change since the last poll.
   *
   *  0, or -1 if you passed it invalid parameters.
   *
   *  The ball indices start at index 0.
   *}
function SDL_JoystickGetBall(joystick: PSDL_Joystick; ball: SInt32; dx: PInt; dy: PInt): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetBall' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the current state of a button on a joystick.
   *
   *  The button indices start at index 0.
   *}
function SDL_JoystickGetButton(joystick: PSDL_Joystick; button: SInt32): UInt8 cdecl; external {$IFDEF GPC} name 'SDL_JoystickGetButton' {$ELSE} SDL_LibName {$ENDIF};
  {**
   *  Close a joystick previously opened with SDL_JoystickOpen().
   *}
procedure SDL_JoystickClose(joystick: PSDL_Joystick) cdecl; external {$IFDEF GPC} name 'SDL_JoystickClose' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_touch.h"

type
  PSDL_TouchID  = ^TSDL_TouchID;
  TSDL_TouchID  = SInt64;

  PSDL_FingerID = ^TSDL_FingerID;
  TSDL_FingerID = SInt64;

  PSDL_Finger = ^TSDL_Finger;
  TSDL_Finger = record
    id: TSDL_FingerID;
    x: Float;
    y: Float;
    pressure: Float;
  end;

{* Used as the device ID for mouse events simulated with touch input *}
const
  SDL_TOUCH_MOUSEID = UInt32(-1);

  {* Function prototypes *}

  {**
   *  Get the number of registered touch devices.
   *}
function SDL_GetNumTouchDevices: SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumTouchDevices' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the touch ID with the given index, or 0 if the index is invalid.
   *}
function SDL_GetTouchDevice(index: SInt32): TSDL_TouchID cdecl; external {$IFDEF GPC} name 'SDL_GetTouchDevice' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the number of active fingers for a given touch device.
   *}
function SDL_GetNumTouchFingers(touchID: TSDL_TouchID): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_GetNumTouchFingers' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Get the finger object of the given touch, with the given index.
   *}
function SDL_GetTouchFinger(touchID: TSDL_TouchID; index: SInt32): PSDL_Finger cdecl; external {$IFDEF GPC} name 'SDL_GetTouchFinger' {$ELSE} SDL_LibName {$ENDIF};


  //from "sdl_gesture.h"

type
  TSDL_GestureID = SInt64;

  {* Function prototypes *}

  {**
   *  Begin Recording a gesture on the specified touch, or all touches (-1)
   *
   *
   *}
function SDL_RecordGesture(touchId: TSDL_TouchID): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_RecordGesture' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Save all currently loaded Dollar Gesture templates
   *
   *
   *}
function SDL_SaveAllDollarTemplates(src: PSDL_RWops): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SaveAllDollarTemplates' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Save a currently loaded Dollar Gesture template
   *
   *
   *}
function SDL_SaveDollarTemplate(gestureId: TSDL_GestureID; src: PSDL_RWops): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_SaveDollarTemplate' {$ELSE} SDL_LibName {$ENDIF};


  {**
   *  Load Dollar Gesture templates from a file
   *
   *
   *}
function SDL_LoadDollarTemplates(touchId: TSDL_TouchID; src: PSDL_RWops): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_LoadDollarTemplates' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl_events.h"

  {**
   *  The types of events that can be delivered.
   *}

const

  SDL_FIRSTEVENT       = 0;     // Unused (do not remove) (needed in pascal?)

  SDL_COMMONEVENT      = 1;     //added for pascal-compatibility

  { Application events }
  SDL_QUITEV           = $100;  // User-requested quit (originally SDL_QUIT, but changed, cause theres a method called SDL_QUIT)


  {* These application events have special meaning on iOS, see README.iOS for details *}
  SDL_APP_TERMINATING  = $101;   {**< The application is being terminated by the OS
                                      Called on iOS in applicationWillTerminate()
                                      Called on Android in onDestroy()
                                  *}
  SDL_APP_LOWMEMORY    = $102;   {**< The application is low on memory, free memory if possible.
                                      Called on iOS in applicationDidReceiveMemoryWarning()
                                      Called on Android in onLowMemory()
                                  *}
  SDL_APP_WILLENTERBACKGROUND = $103; {**< The application is about to enter the background
                                           Called on iOS in applicationWillResignActive()
                                           Called on Android in onPause()
                                       *}
  SDL_APP_DIDENTERBACKGROUND = $104;  {**< The application did enter the background and may not get CPU for some time
                                           Called on iOS in applicationDidEnterBackground()
                                           Called on Android in onPause()
                                       *}
  SDL_APP_WILLENTERFOREGROUND = $105; {**< The application is about to enter the foreground
                                           Called on iOS in applicationWillEnterForeground()
                                           Called on Android in onResume()
                                       *}
  SDL_APP_DIDENTERFOREGROUND = $106;  {**< The application is now interactive
                                           Called on iOS in applicationDidBecomeActive()
                                           Called on Android in onResume()
                                       *}

  { Window events }
  SDL_WINDOWEVENT      = $200;  // Window state change
  SDL_SYSWMEVENT       = $201;  // System specific event

  { Keyboard events }
  SDL_KEYDOWN          = $300;  // Key pressed
  SDL_KEYUP            = $301;  // Key released
  SDL_TEXTEDITING      = $302;  // Keyboard text editing (composition)
  SDL_TEXTINPUT        = $303;  // Keyboard text input

  { Mouse events }
  SDL_MOUSEMOTION      = $400;  // Mouse moved
  SDL_MOUSEBUTTONDOWN  = $401;  // Mouse button pressed
  SDL_MOUSEBUTTONUP    = $402;  // Mouse button released
  SDL_MOUSEWHEEL       = $403;  // Mouse wheel motion

  { Joystick events }
  SDL_JOYAXISMOTION    = $600;  // Joystick axis motion
  SDL_JOYBALLMOTION    = $601;  // Joystick trackball motion
  SDL_JOYHATMOTION     = $602;  // Joystick hat position change
  SDL_JOYBUTTONDOWN    = $603;  // Joystick button pressed
  SDL_JOYBUTTONUP      = $604;  // Joystick button released 
  SDL_JOYDEVICEADDED   = $605;  // A new joystick has been inserted into the system 
  SDL_JOYDEVICEREMOVED = $606;  // An opened joystick has been removed 

  { Game controller events }
  SDL_CONTROLLERAXISMOTION     = $650;  // Game controller axis motion
  SDL_CONTROLLERBUTTONDOWN     = $651;  // Game controller button pressed 
  SDL_CONTROLLERBUTTONUP       = $652;  // Game controller button released 
  SDL_CONTROLLERDEVICEADDED    = $653;  // A new Game controller has been inserted into the system 
  SDL_CONTROLLERDEVICEREMOVED  = $654;  // An opened Game controller has been removed 
  SDL_CONTROLLERDEVICEREMAPPED = $655;  // The controller mapping was updated 

  { Touch events }
  SDL_FINGERDOWN      = $700;
  SDL_FINGERUP        = $701;
  SDL_FINGERMOTION    = $702;

  { Gesture events }
  SDL_DOLLARGESTURE   = $800;
  SDL_DOLLARRECORD    = $801;
  SDL_MULTIGESTURE    = $802;

  { Clipboard events }
  SDL_CLIPBOARDUPDATE = $900; // The clipboard changed

  { Drag and drop events }
  SDL_DROPFILE        = $1000; // The system requests a file open

  {** Events SDL_USEREVENT through SDL_LASTEVENT are for your use,
   *  and should be allocated with SDL_RegisterEvents()
   *}
  SDL_USEREVENT    = $8000;

  {**
   *  This last event is only for bounding internal arrays (needed in pascal ??)
   *}
  SDL_LASTEVENT    = $FFFF;

type

  TSDL_EventType = Word;

  {**
   *  Fields shared by every event
   *}

  TSDL_CommonEvent = record
    type_: UInt32;
    timestamp: UInt32;
  end;

  {**
   *  Window state change event data (event.window.*)
   *}

  TSDL_WindowEvent = record
    type_: UInt32;       // SDL_WINDOWEVENT 
    timestamp: UInt32;
    windowID: UInt32;    // The associated window 
    event: UInt8;        // SDL_WindowEventID 
    padding1: UInt8;
    padding2: UInt8;
    padding3: UInt8;
    data1: SInt32;       // event dependent data
    data2: SInt32;       // event dependent data 
  end;

  {**
   *  Keyboard button event structure (event.key.*)
   *}
  TSDL_KeyboardEvent = record
    type_: UInt32;        // SDL_KEYDOWN or SDL_KEYUP 
    timestamp: UInt32;
    windowID: UInt32;     // The window with keyboard focus, if any 
    state: UInt8;         // SDL_PRESSED or SDL_RELEASED 
    _repeat: UInt8;       // Non-zero if this is a key repeat
    padding2: UInt8;
    padding3: UInt8;
    keysym: TSDL_KeySym;  // The key that was pressed or released
  end;

const
  SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32;
  
type
 
  {**
   *  Keyboard text editing event structure (event.edit.*)
   *}
 
  TSDL_TextEditingEvent = record
    type_: UInt32;                               // SDL_TEXTEDITING 
    timestamp: UInt32;
    windowID: UInt32;                            // The window with keyboard focus, if any
    text: array[0..SDL_TEXTEDITINGEVENT_TEXT_SIZE] of Char;  // The editing text 
    start: SInt32;                               // The start cursor of selected editing text 
    length: SInt32;                              // The length of selected editing text
  end;

const
  SDL_TEXTINPUTEVENT_TEXT_SIZE = 32;

type

  {**
   *  Keyboard text input event structure (event.text.*)
   *}
 
  TSDL_TextInputEvent = record
    type_: UInt32;                                          // SDL_TEXTINPUT 
    timestamp: UInt32;
    windowID: UInt32;                                       // The window with keyboard focus, if any
    text: array[0..SDL_TEXTINPUTEVENT_TEXT_SIZE] of Char;   // The input text 
  end;

  {**
   *  Mouse motion event structure (event.motion.*)
   *}
 
  TSDL_MouseMotionEvent = record
    type_: UInt32;       // SDL_MOUSEMOTION
    timestamp: UInt32;
    windowID: UInt32;    // The window with mouse focus, if any 
    which: UInt32;       // The mouse instance id, or SDL_TOUCH_MOUSEID
    state: UInt8;        // The current button state 
    padding1: UInt8;
    padding2: UInt8;
    padding3: UInt8;
    x: SInt32;           // X coordinate, relative to window 
    y: SInt32;           // Y coordinate, relative to window
    xrel: SInt32;        // The relative motion in the X direction 
    yrel: SInt32;        // The relative motion in the Y direction 
  end;

  {**
   *  Mouse button event structure (event.button.*)
   *}
 
  TSDL_MouseButtonEvent = record
    type_: UInt32;       // SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP 
    timestamp: UInt32;
    windowID: UInt32;    // The window with mouse focus, if any
    which: UInt32;       // The mouse instance id, or SDL_TOUCH_MOUSEID 
    button: UInt8;       // The mouse button index 
    state: UInt8;        // SDL_PRESSED or SDL_RELEASED
    padding1: UInt8;
    padding2: UInt8;
    x: SInt32;           // X coordinate, relative to window
    y: SInt32;           // Y coordinate, relative to window 
  end;

  {**
   *  Mouse wheel event structure (event.wheel.*)
   *}
 
  TSDL_MouseWheelEvent = record
    type_: UInt32;        // SDL_MOUSEWHEEL
    timestamp: UInt32;
    windowID: UInt32;    // The window with mouse focus, if any 
    which: UInt32;       // The mouse instance id, or SDL_TOUCH_MOUSEID
    x: SInt32;           // The amount scrolled horizontally 
    y: SInt32;           // The amount scrolled vertically 
  end;

  {**
   *  Joystick axis motion event structure (event.jaxis.*)
   *}
 
  TSDL_JoyAxisEvent = record
    type_: UInt32;         // SDL_JOYAXISMOTION 
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id
    axis: UInt8;           // The joystick axis index 
    padding1: UInt8;
    padding2: UInt8;
    padding3: UInt8;
    value: SInt16;         // The axis value (range: -32768 to 32767) 
    padding4: UInt16;
  end;

  {**
   *  Joystick trackball motion event structure (event.jball.*)
   *}

  TSDL_JoyBallEvent = record
    type_: UInt32;         // SDL_JOYBALLMOTION
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id
    ball: UInt8;           // The joystick trackball index
    padding1: UInt8;
    padding2: UInt8;
    padding3: UInt8;
    xrel: SInt16;          // The relative motion in the X direction
    yrel: SInt16;          // The relative motion in the Y direction
  end;

  {**
   *  Joystick hat position change event structure (event.jhat.*)
   *}

  TSDL_JoyHatEvent = record
    type_: UInt32;         // SDL_JOYHATMOTION
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id
    hat: UInt8;            // The joystick hat index
    value: UInt8;         {*  The hat position value.
                           *  SDL_HAT_LEFTUP   SDL_HAT_UP       SDL_HAT_RIGHTUP
                           *  SDL_HAT_LEFT     SDL_HAT_CENTERED SDL_HAT_RIGHT
                           *  SDL_HAT_LEFTDOWN SDL_HAT_DOWN     SDL_HAT_RIGHTDOWN
                           *
                           *  Note that zero means the POV is centered.
                           *}
    padding1: UInt8;
    padding2: UInt8;
  end;

  {**
   *  Joystick button event structure (event.jbutton.*)
   *}

  TSDL_JoyButtonEvent = record
    type_: UInt32;        // SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id 
    button: UInt8;         // The joystick button index 
    state: UInt8;          // SDL_PRESSED or SDL_RELEASED
    padding1: UInt8;
    padding2: UInt8;
  end;

  {**
   *  Joystick device event structure (event.jdevice.*)
   *}

  TSDL_JoyDeviceEvent = record
    type_: UInt32;      // SDL_JOYDEVICEADDED or SDL_JOYDEVICEREMOVED
    timestamp: UInt32;
    which: SInt32;      // The joystick device index for the ADDED event, instance id for the REMOVED event
  end;

  {**
   *  Game controller axis motion event structure (event.caxis.*)
   *}

  TSDL_ControllerAxisEvent = record
    type_: UInt32;         // SDL_CONTROLLERAXISMOTION
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id
    axis: UInt8;           // The controller axis (SDL_GameControllerAxis)
    padding1: UInt8;
    padding2: UInt8;
    padding3: UInt8;
    value: SInt16;         // The axis value (range: -32768 to 32767)
    padding4: UInt16;
  end;

  {**
   *  Game controller button event structure (event.cbutton.*)
   *}

  TSDL_ControllerButtonEvent = record
    type_: UInt32;         // SDL_CONTROLLERBUTTONDOWN or SDL_CONTROLLERBUTTONUP
    timestamp: UInt32;
    which: TSDL_JoystickID; // The joystick instance id
    button: UInt8;         // The controller button (SDL_GameControllerButton)
    state: UInt8;          // SDL_PRESSED or SDL_RELEASED
    padding1: UInt8;
    padding2: UInt8;
  end;


  {**
   *  Controller device event structure (event.cdevice.*)
   *}

  TSDL_ControllerDeviceEvent = record
    type_: UInt32;       // SDL_CONTROLLERDEVICEADDED, SDL_CONTROLLERDEVICEREMOVED, or SDL_CONTROLLERDEVICEREMAPPED
    timestamp: UInt32;
    which: SInt32;       // The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event
  end;

  {**
   *  Touch finger event structure (event.tfinger.*)
   *}

  TSDL_TouchFingerEvent = record
    type_: UInt32;         // SDL_FINGERMOTION or SDL_FINGERDOWN or SDL_FINGERUP
    timestamp: UInt32;
    touchId: TSDL_TouchID;  // The touch device id
    fingerId: TSDL_FingerID;
    x: Float;              // Normalized in the range 0...1
    y: Float;              // Normalized in the range 0...1
    dx: Float;             // Normalized in the range 0...1
    dy: Float;             // Normalized in the range 0...1
    pressure: Float;       // Normalized in the range 0...1
  end;

  {**
   *  Multiple Finger Gesture Event (event.mgesture.*)
   *}
  TSDL_MultiGestureEvent = record
    type_: UInt32;        // SDL_MULTIGESTURE
    timestamp: UInt32;
    touchId: TSDL_TouchID; // The touch device index
    dTheta: Float;
    dDist: Float;
    x: Float;
    y: Float;
    numFingers: UInt16;
    padding: UInt16;
  end;


  {* (event.dgesture.*) *}
  TSDL_DollarGestureEvent = record
    type_: UInt32;         // SDL_DOLLARGESTURE
    timestamp: UInt32;
    touchId: TSDL_TouchID;  // The touch device id
    gestureId: TSDL_GestureID;
    numFingers: UInt32;
    error: Float;
    x: Float;              // Normalized center of gesture
    y: Float;              // Normalized center of gesture
  end;


  {**
   *  An event used to request a file open by the system (event.drop.*)
   *  This event is disabled by default, you can enable it with SDL_EventState()
   *  If you enable this event, you must free the filename in the event.
   *}

  TSDL_DropEvent = record
    type_: UInt32;      // SDL_DROPFILE
    timestamp: UInt32;
    _file: PAnsiChar;   // The file name, which should be freed with SDL_free() 
  end;

  {**
   *  The "quit requested" event
   *}

  TSDL_QuitEvent = record
    type_: UInt32;        // SDL_QUIT
    timestamp: UInt32;
  end;

  {**
   *  A user-defined event type (event.user.*)
   *}

  TSDL_UserEvent = record
    type_: UInt32;       // SDL_USEREVENT through SDL_NUMEVENTS-1
    timestamp: UInt32;
    windowID: UInt32;    // The associated window if any
    code: SInt32;        // User defined event code
    data1: Pointer;      // User defined data pointer
    data2: Pointer;      // User defined data pointer
  end;

  {$IFDEF Unix}
    //These are the various supported subsystems under UNIX
    TSDL_SysWm = ( SDL_SYSWM_X11 ) ;
  {$ENDIF}

  // The windows custom event structure
  {$IFDEF Windows}
    PSDL_SysWMmsg = ^TSDL_SysWMmsg;
    TSDL_SysWMmsg = record
      version: TSDL_Version;
      h_wnd: HWND; // The window for the message
      msg: UInt32; // The type of message
      w_Param: WPARAM; // WORD message parameter
      lParam: LPARAM; // LONG message parameter
    end;
  {$ELSE}

    {$IFDEF Unix}
      { The Linux custom event structure }
      PSDL_SysWMmsg = ^TSDL_SysWMmsg;
      TSDL_SysWMmsg = record
        version : TSDL_Version;
        subsystem : TSDL_SysWm;
        {$IFDEF FPC}
          event : TXEvent;
        {$ELSE}
          event : XEvent;
        {$ENDIF}
      end;
    {$ELSE}
      { The generic custom event structure }
      PSDL_SysWMmsg = ^TSDL_SysWMmsg;
      TSDL_SysWMmsg = record
        version: TSDL_Version;
        data: Integer;
      end;
    {$ENDIF}

  {$ENDIF}

  // The Windows custom window manager information structure
  {$IFDEF Windows}
    PSDL_SysWMinfo = ^TSDL_SysWMinfo;
    TSDL_SysWMinfo = record
      version : TSDL_Version;
      window : HWnd;	// The display window
    end;
  {$ELSE}
    // The Linux custom window manager information structure
    {$IFDEF Unix}
      TX11 = record
        display : PDisplay;	// The X11 display
        window : TWindow;		// The X11 display window */
        {* These locking functions should be called around
           any X11 functions using the display variable.
           They lock the event thread, so should not be
           called around event functions or from event filters.
         *}
        lock_func : Pointer;
        unlock_func : Pointer;

        // Introduced in SDL 1.0.2
        fswindow : TWindow;	// The X11 fullscreen window */
        wmwindow : TWindow;	// The X11 managed input window */
      end;

      PSDL_SysWMinfo = ^TSDL_SysWMinfo;
      TSDL_SysWMinfo = record
         version : TSDL_Version;
         subsystem : TSDL_SysWm;
         X11 : TX11;
      end;
    {$ELSE}
      // The generic custom window manager information structure
      PSDL_SysWMinfo = ^TSDL_SysWMinfo;
      TSDL_SysWMinfo = record
        version : TSDL_Version;
        data : integer;
      end;
    {$ENDIF}

  {$ENDIF}

  {**
   *  A video driver dependent system event (event.syswm.*)
   *  This event is disabled by default, you can enable it with SDL_EventState()
   *
   *  If you want to use this event, you should include SDL_syswm.h.
   *}

  PSDL_SysWMEvent = ^TSDL_SysWMEvent;
  TSDL_SysWMEvent = record
    type_: UInt32;       // SDL_SYSWMEVENT
    timestamp: UInt32;
    msg: PSDL_SysWMmsg;  // driver dependent data (defined in SDL_syswm.h)
  end;

  {**
   *  General event structure
   *}

  PSDL_Event = ^TSDL_Event;
  TSDL_Event = record
    case Integer of
      0:  (type_: UInt32);

      SDL_COMMONEVENT:  (common: TSDL_CommonEvent);
      SDL_WINDOWEVENT:  (window: TSDL_WindowEvent);

      SDL_KEYUP,
      SDL_KEYDOWN:  (key: TSDL_KeyboardEvent);
      SDL_TEXTEDITING:  (edit: TSDL_TextEditingEvent);
      SDL_TEXTINPUT:  (text: TSDL_TextInputEvent);

      SDL_MOUSEMOTION:  (motion: TSDL_MouseMotionEvent);
      SDL_MOUSEBUTTONUP,
      SDL_MOUSEBUTTONDOWN:  (button: TSDL_MouseButtonEvent);
      SDL_MOUSEWHEEL:  (wheel: TSDL_MouseWheelEvent);
	  
      SDL_JOYAXISMOTION:  (jaxis: TSDL_JoyAxisEvent);
      SDL_JOYBALLMOTION: (jball: TSDL_JoyBallEvent);
      SDL_JOYHATMOTION: (jhat: TSDL_JoyHatEvent);
      SDL_JOYBUTTONDOWN,
      SDL_JOYBUTTONUP: (jbutton: TSDL_JoyButtonEvent);
      SDL_JOYDEVICEADDED,
      SDL_JOYDEVICEREMOVED: (jdevice: TSDL_JoyDeviceEvent);

      SDL_CONTROLLERAXISMOTION: (caxis: TSDL_ControllerAxisEvent);
      SDL_CONTROLLERBUTTONUP,
      SDL_CONTROLLERBUTTONDOWN: (cbutton: TSDL_ControllerButtonEvent);
      SDL_CONTROLLERDEVICEADDED,
      SDL_CONTROLLERDEVICEREMOVED,
      SDL_CONTROLLERDEVICEREMAPPED: (cdevice: TSDL_ControllerDeviceEvent);

      SDL_QUITEV: (quit: TSDL_QuitEvent);

      SDL_USEREVENT: (user: TSDL_UserEvent);
      SDL_SYSWMEVENT: (syswm: TSDL_SysWMEvent);

      SDL_FINGERDOWN,
      SDL_FINGERUP,
      SDL_FINGERMOTION: (tfinger: TSDL_TouchFingerEvent);
      SDL_MULTIGESTURE: (mgesture: TSDL_MultiGestureEvent);
      SDL_DOLLARGESTURE,SDL_DOLLARRECORD: (dgesture: TSDL_DollarGestureEvent);

      SDL_DROPFILE: (drop: TSDL_DropEvent);
  end;


  {* Function prototypes *}

  {**
   *  Pumps the event loop, gathering events from the input devices.
   *  
   *  This function updates the event queue and internal input device state.
   *  
   *  This should only be run in the thread that sets the video mode.
   *}
  procedure SDL_PumpEvents cdecl; external {$IFDEF GPC} name 'SDL_PumpEvents' {$ELSE} SDL_LibName {$ENDIF};

const
  SDL_ADDEVENT = 0;
  SDL_PEEKEVENT = 1;
  SDL_GETEVENT = 2;

type
  TSDL_EventAction = Word;

  {**
   *  Checks the event queue for messages and optionally returns them.
   *
   *  If action is SDL_ADDEVENT, up to numevents events will be added to
   *  the back of the event queue.
   *
   *  If action is SDL_PEEKEVENT, up to numevents events at the front
   *  of the event queue, within the specified minimum and maximum type,
   *  will be returned and will not be removed from the queue.
   *
   *  If action is SDL_GETEVENT, up to numevents events at the front
   *  of the event queue, within the specified minimum and maximum type,
   *  will be returned and will be removed from the queue.
   *
   *  Result: The number of events actually stored, or -1 if there was an error.
   *
   *  This function is thread-safe.
   *}

  function SDL_PeepEvents(events: PSDL_Event; numevents: SInt32; action: TSDL_EventAction; minType: UInt32; maxType: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_PeepEvents' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Checks to see if certain event types are in the event queue.
   *}
 
  function SDL_HasEvent(type_: UInt32): TSDL_Bool  cdecl; external {$IFDEF GPC} name 'SDL_HasEvent' {$ELSE} SDL_LibName {$ENDIF};
  function SDL_HasEvents(minType: UInt32; maxType: UInt32): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_HasEvents' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  This function clears events from the event queue
   *}

  procedure SDL_FlushEvent(type_: UInt32) cdecl; external {$IFDEF GPC} name 'SDL_FlushEvent' {$ELSE} SDL_LibName {$ENDIF};
  procedure SDL_FlushEvents(minType: UInt32; maxType: UInt32) cdecl; external {$IFDEF GPC} name 'SDL_FlushEvents' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Polls for currently pending events.
   *
   *  1 if there are any pending events, or 0 if there are none available.
   *  
   *  event - If not nil, the next event is removed from the queue and
   *               stored in that area.
   *}

  function SDL_PollEvent(event: PSDL_Event): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_PollEvent' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Waits indefinitely for the next available event.
   *  
   *  1, or 0 if there was an error while waiting for events.
   *   
   *  event - If not nil, the next event is removed from the queue and 
   *  stored in that area.
   *}
 
  function SDL_WaitEvent(event: PSDL_Event): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_WaitEvent' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Waits until the specified timeout (in milliseconds) for the next
   *  available event.
   *  
   *  1, or 0 if there was an error while waiting for events.
   *  
   *  event - If not nil, the next event is removed from the queue and
   *  stored in that area.
   *}
 
  function SDL_WaitEventTimeout(event: PSDL_Event; timeout: SInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_WaitEventTimeout' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Add an event to the event queue.
   *  
   *  1 on success, 0 if the event was filtered, or -1 if the event queue
   *  was full or there was some other error.
   *}

  function SDL_PushEvent(event: PSDL_Event): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_PumpEvents' {$ELSE} SDL_LibName {$ENDIF};

type
  PSDL_EventFilter = ^TSDL_EventFilter;
  {$IFNDEF GPC}
    TSDL_EventFilter = function( event: PSDL_Event ): Integer; cdecl;
  {$ELSE}
    TSDL_EventFilter = function( event: PSDL_Event ): Integer;
  {$ENDIF}

  {**
   *  Sets up a filter to process all events before they change internal state and
   *  are posted to the internal event queue.
   *  
   *  If the filter returns 1, then the event will be added to the internal queue.
   *  If it returns 0, then the event will be dropped from the queue, but the 
   *  internal state will still be updated.  This allows selective filtering of
   *  dynamically arriving events.
   *  
   *  Be very careful of what you do in the event filter function, as 
   *  it may run in a different thread!
   *  
   *  There is one caveat when dealing with the SDL_QUITEVENT event type.  The
   *  event filter is only called when the window manager desires to close the
   *  application window.  If the event filter returns 1, then the window will
   *  be closed, otherwise the window will remain open if possible.
   *
   *  If the quit event is generated by an interrupt signal, it will bypass the
   *  internal queue and be delivered to the application at the next event poll.
   *}
 
  procedure SDL_SetEventFilter(filter: TSDL_EventFilter; userdata: Pointer) cdecl; external {$IFDEF GPC} name 'SDL_SetEventFilter' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Return the current event filter - can be used to "chain" filters.
   *  If there is no event filter set, this function returns SDL_FALSE.
   *}

  function SDL_GetEventFilter(filter: PSDL_EventFilter; userdata: Pointer): TSDL_Bool cdecl; external {$IFDEF GPC} name 'SDL_GetEventFilter' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Add a function which is called when an event is added to the queue.
   *}
 
  procedure SDL_AddEventWatch(filter: TSDL_EventFilter; userdata: Pointer) cdecl; external {$IFDEF GPC} name 'SDL_AddEventWatch' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Remove an event watch function added with SDL_AddEventWatch()
   *}
 
  procedure SDL_DelEventWatch(filter: TSDL_EventFilter; userdata: Pointer) cdecl; external {$IFDEF GPC} name 'SDL_DelEventWatch' {$ELSE} SDL_LibName {$ENDIF};

  {**
   *  Run the filter function on the current event queue, removing any
   *  events for which the filter returns 0.
   *}

  procedure SDL_FilterEvents(filter: TSDL_EventFilter; userdata: Pointer) cdecl; external {$IFDEF GPC} name 'SDL_FilterEvents' {$ELSE} SDL_LibName {$ENDIF};

const

  SDL_QUERY   =	-1;
  SDL_IGNORE  =	 0;
  SDL_DISABLE =	 0;
  SDL_ENABLE  =  1;

  {**
   *  This function allows you to set the state of processing certain events.
   *   - If state is set to SDL_IGNORE, that event will be automatically
   *     dropped from the event queue and will not event be filtered.
   *   - If state is set to SDL_ENABLE, that event will be processed
   *     normally.
   *   - If state is set to SDL_QUERY, SDL_EventState() will return the
   *     current processing state of the specified event.
   *}

  function SDL_EventState(type_: UInt32; state: SInt32): UInt8 cdecl; external {$IFDEF GPC} name 'SDL_EventState' {$ELSE} SDL_LibName {$ENDIF};

  procedure SDL_GetEventState(type_: UInt32);

  {**
   *  This function allocates a set of user-defined events, and returns
   *  the beginning event number for that set of events.
   *
   *  If there aren't enough user-defined events left, this function
   *  returns (Uint32)-1
   *}
   
  function SDL_RegisterEvents(numevents: SInt32): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_RegisterEvents' {$ELSE} SDL_LibName {$ENDIF};

  //from "sdl.h"

const

  SDL_INIT_TIMER          = $00000001;
  {$EXTERNALSYM SDL_INIT_TIMER}
  SDL_INIT_AUDIO          = $00000010;
  {$EXTERNALSYM SDL_INIT_AUDIO}
  SDL_INIT_VIDEO          = $00000020;
  {$EXTERNALSYM SDL_INIT_VIDEO}
  SDL_INIT_JOYSTICK       = $00000200;
  {$EXTERNALSYM SDL_INIT_JOYSTICK}
  SDL_INIT_HAPTIC         = $00001000;
  {$EXTERNALSYM SDL_INIT_HAPTIC}
  SDL_INIT_GAMECONTROLLER = $00002000;  //turn on game controller also implicitly does JOYSTICK 
  {$EXTERNALSYM SDL_INIT_GAMECONTROLLER}
  SDL_INIT_NOPARACHUTE    = $00100000;  //Don't catch fatal signals
  {$EXTERNALSYM SDL_INIT_NOPARACHUTE}
  SDL_INIT_EVERYTHING     = SDL_INIT_TIMER    or
							SDL_INIT_AUDIO    or
							SDL_INIT_VIDEO    or
							SDL_INIT_JOYSTICK or
							SDL_INIT_HAPTIC   or
							SDL_INIT_GAMECONTROLLER;
  {$EXTERNALSYM SDL_INIT_EVERYTHING}

{**
 *  This function initializes  the subsystems specified by flags
 *  Unless the SDL_INIT_NOPARACHUTE flag is set, it will install cleanup
 *  signal handlers for some commonly ignored fatal signals (like SIGSEGV).
 *}

function SDL_Init(flags: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_Init' {$ELSE} SDL_LibName {$ENDIF};

{**
 *  This function initializes specific SDL subsystems
 *}
 
function SDL_InitSubSystem(flags: UInt32): SInt32 cdecl; external {$IFDEF GPC} name 'SDL_InitSubSystem' {$ELSE} SDL_LibName {$ENDIF};

{**
 *  This function cleans up specific SDL subsystems
 *}
 
procedure SDL_QuitSubSystem(flags: UInt32) cdecl; external {$IFDEF GPC} name 'SDL_QuitSubSystem' {$ELSE} SDL_LibName {$ENDIF};

{**
 *  This function returns a mask of the specified subsystems which have
 *  previously been initialized.
 *  
 *  If flags is 0, it returns a mask of all initialized subsystems.
 *}
 
function SDL_WasInit(flags: UInt32): UInt32 cdecl; external {$IFDEF GPC} name 'SDL_WasInit' {$ELSE} SDL_LibName {$ENDIF};

{**
 *  This function cleans up all initialized subsystems. You should
 *  call it upon all exit conditions.
 *}
 
procedure SDL_Quit cdecl; external {$IFDEF GPC} name 'SDL_Quit' {$ELSE} SDL_LibName {$ENDIF};

implementation

//from "sdl_version.h"
procedure SDL_VERSION(x: PSDL_Version);
begin
  x.major := SDL_MAJOR_VERSION;
  x.minor := SDL_MINOR_VERSION;
  x.patch := SDL_PATCHLEVEL;
end;

function SDL_VERSIONNUM(X,Y,Z: UInt32): Cardinal;
begin
  Result := X*1000 + Y*100 + Z;
end;

function SDL_COMPILEDVERSION: Cardinal;
begin
  Result := SDL_VERSIONNUM(SDL_MAJOR_VERSION,
                           SDL_MINOR_VERSION,
                           SDL_PATCHLEVEL);
end;

function SDL_VERSION_ATLEAST(X,Y,Z: Cardinal): Boolean;
begin
  Result := SDL_COMPILEDVERSION >= SDL_VERSIONNUM(X,Y,Z);
end;

//from "sdl_rect.h"
function SDL_RectEmpty(X: TSDL_Rect): Boolean;
begin
  Result := (X.w <= 0) or (X.h <= 0);
end;

function SDL_RectEquals(A: TSDL_Rect; B: TSDL_Rect): Boolean;
begin
  Result := (A.x = B.x) and (A.y = B.y) and (A.w = B.w) and (A.h = B.h);
end;

//from "sdl_pixels.h"

function SDL_PIXELFLAG(X: Cardinal): Boolean;
begin
  Result := (X shr 28) = $0F;
end;

function SDL_PIXELTYPE(X: Cardinal): Boolean;
begin
  Result := (X shr 24) = $0F;
end;

function SDL_PIXELORDER(X: Cardinal): Boolean;
begin
  Result := (X shr 20) = $0F;
end;

function SDL_PIXELLAYOUT(X: Cardinal): Boolean;
begin
  Result := (X shr 16) = $0F;
end;

function SDL_BITSPERPIXEL(X: Cardinal): Boolean;
begin
  Result := (X shr 8) = $FF;
end;

function SDL_IsPixelFormat_FOURCC(format: Variant): Boolean;
begin
  {* The flag is set to 1 because 0x1? is not in the printable ASCII range *}
  Result := format and SDL_PIXELFLAG(format) <> 1;
end;

//from "sdl_surface.h"
function SDL_LoadBMP(_file: PAnsiChar): PSDL_Surface;
begin
  Result := SDL_LoadBMP_RW(SDL_RWFromFile(_file, 'rb'), 1);
end;

//from "sdl_video.h"
function SDL_WindowPos_IsUndefined(X: Variant): Variant;
begin
  Result := (X and $FFFF0000) = SDL_WINDOWPOS_UNDEFINED_MASK;
end;

function SDL_WindowPos_IsCentered(X: Variant): Variant;
begin
  Result := (X and $FFFF0000) = SDL_WINDOWPOS_CENTERED_MASK;
end;

//from "sdl_events.h"

procedure SDL_GetEventState(type_: UInt32);
begin
  SDL_EventState(type_, SDL_QUERY);
end;

end.
