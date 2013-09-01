
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
