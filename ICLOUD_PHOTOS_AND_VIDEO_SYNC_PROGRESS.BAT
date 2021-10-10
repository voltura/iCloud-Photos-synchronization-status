@ECHO OFF
TITLE=Apple iCloud Photos and Videos synchronization status
MODE 70,4
COLOR 1E
SETLOCAL
SET DATA_FILENAME=ICLOUD.DATA
SET DATA_FULLFILENAME=%TEMP%\%DATA_FILENAME%
SET ICLOUD_PHOTOS_FOLDER="%HOMEPATH%\iCloudPhotos\Photos"
CLS
ECHO Collecting data...
@powershell -ExecutionPolicy UnRestricted -Command "(Add-Type -memberDefinition \"[DllImport(\"\"user32.dll\"\")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x,int y,int cx, int xy, uint flagsw);\" -name \"Win32SetWindowPos\" -passThru )::SetWindowPos((Add-Type -memberDefinition \"[DllImport(\"\"Kernel32.dll\"\")] public static extern IntPtr GetConsoleWindow();\" -name \"Win32GetConsoleWindow\" -passThru )::GetConsoleWindow(),-1,0,0,0,0,67)">NUL 2>&1
:GATHER_STATUS
CD /D %ICLOUD_PHOTOS_FOLDER%
FOR /F "usebackq skip=7 tokens=3" %%i IN (`DIR`) DO ECHO %%i>>"%DATA_FULLFILENAME%"
CD /D "%TEMP%"
FOR /F "usebackq skip=1 tokens=3 delims=: " %%i IN (`FIND /C "(" %DATA_FILENAME%`) DO SET /A NOTDOWNLOADED=%%i
FOR /F "usebackq skip=1 tokens=3 delims=: " %%i IN (`FIND /V /C "(" %DATA_FILENAME%`) DO SET /A DOWNLOADED=%%i
DEL /F /Q "%DATA_FULLFILENAME%">NUL 2>&1
SET /A "TOTAL=DOWNLOADED+NOTDOWNLOADED"
SET /A "PERCENTAGE=DOWNLOADED*100/TOTAL"
CLS
ECHO %PERCENTAGE%%% done...
ECHO %TOTAL% total files, %DOWNLOADED% downloaded, %NOTDOWNLOADED% not downloaded.
IF %PERCENTAGE%==100 GOTO DONE
GOTO GATHER_STATUS
:DONE
ECHO All files downloaded.
TIMEOUT /T 300
EXIT