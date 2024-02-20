;--------------------------------
; Includes

  !include "MUI2.nsh"
  !include "logiclib.nsh"

;--------------------------------
; Custom defines
  !define NAME "sb_ffmpeg"
  !define VERSION "6.1.1"
  !define SLUG "${NAME} v${VERSION}"

;--------------------------------
; General

  Name "${NAME}"
  OutFile "${NAME}_setup.exe"
  InstallDir "$PROGRAMFILES\${NAME}"
  InstallDirRegKey HKCU "Software\${NAME}" ""
  RequestExecutionLevel admin

;--------------------------------
; UI
  !define MUI_ABORTWARNING
  !define MUI_WELCOMEPAGE_TITLE "${SLUG} Setup"

;--------------------------------
; Pages
  
  ; Installer pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "LICENSE"
  ; !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller pages
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  ; !insertmacro MUI_PAGE_FINISH
  
  ; Set UI language
  !insertmacro MUI_LANGUAGE "Russian"

;--------------------------------
; Section - Install App

  Section "-hidden app"
    SectionIn RO
    SetOutPath "$INSTDIR"

    file /r bin
    file /r doc
    file /r presets
    file /r README.txt
    file /r LICENSE

    WriteRegStr HKCU "Software\${NAME}" "" $INSTDIR
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" \
                 "DisplayName" "${NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" \
                    "UninstallString" "$\"$INSTDIR\uninstall.exe$\""

    EnVar::Check "Path" "$INSTDIR\bin"
    Pop $0
    ${If} $0 = 0
      DetailPrint "Already there"
    ${Else}
      EnVar::AddValue "Path" "$INSTDIR\bin"
      Pop $0 ; 0 on success
    ${EndIf}
  SectionEnd

;--------------------------------
; Section - Shortcut

  ; Section "Desktop Shortcut" DeskShort
  ;   CreateShortCut "$DESKTOP\${NAME}.lnk" "$INSTDIR\${APPFILE}"
  ; SectionEnd

;--------------------------------
; Descriptions

  ; ;Language strings
  ; LangString DESC_DeskShort ${LANG_ENGLISH} "Create Shortcut on Dekstop."
  ; LangString DESC_DirectX ${LANG_ENGLISH} "Microsoft DirectX is a collection of application programming interfaces for handling tasks related to multimedia."

  ; ;Assign language strings to sections
  ; !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ;   !insertmacro MUI_DESCRIPTION_TEXT ${DeskShort} $(DESC_DeskShort)
  ;   !insertmacro MUI_DESCRIPTION_TEXT ${DirectX} $(DESC_DirectX)
  ; !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Remove empty parent directories

  Function un.RMDirUP
    !define RMDirUP '!insertmacro RMDirUPCall'

    !macro RMDirUPCall _PATH
          push '${_PATH}'
          Call un.RMDirUP
    !macroend

    ; $0 - current folder
    ClearErrors

    Exch $0
    ;DetailPrint "ASDF - $0\.."
    RMDir "$0\.."

    IfErrors Skip
    ${RMDirUP} "$0\.."
    Skip:

    Pop $0

  FunctionEnd

;--------------------------------
; Section - Uninstaller

Section "Uninstall"
  SetAutoClose false

  ; ;Delete Shortcut
  ; Delete "$DESKTOP\${NAME}.lnk"

  ;Delete Uninstall
  Delete "$INSTDIR\Uninstall.exe"

  ;Delete Folder
  RMDir /r "$INSTDIR"
  ${RMDirUP} "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\${NAME}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"

  EnVar::DeleteValue "Path" "$InstDir"
  Pop $0

SectionEnd










