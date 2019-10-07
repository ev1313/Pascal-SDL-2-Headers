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

type
  PSDL_BlendOperation = ^TSDL_BlendOperation;
  TSDL_BlendOperation = DWord;

const
  SDL_BLENDOPERATION_ADD              = $1;  {**< dst + src: supported by all renderers *}
  SDL_BLENDOPERATION_SUBTRACT         = $2;  {**< dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES}
  SDL_BLENDOPERATION_REV_SUBTRACT     = $3;  {**< src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES}
  SDL_BLENDOPERATION_MINIMUM          = $4;  {**< min(dst, src) : supported by D3D11 *}
  SDL_BLENDOPERATION_MAXIMUM          = $5;  {**< max(dst, src) : supported by D3D11 *}
