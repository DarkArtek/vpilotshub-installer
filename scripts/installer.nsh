!macro customInit
   ${ifNot} ${isUpdated}
     nsExec::Exec '"$LOCALAPPDATA\vpilotshub_installer\Update.exe" --uninstall -s'
     delete "$LOCALAPPDATA\vpilotshub_installer\Update.exe"
     delete "$LOCALAPPDATA\vpilotshub_installer\.dead"
     rmDir "$LOCALAPPDATA\vpilotshub_installer"
   ${endIf}
 !macroend
