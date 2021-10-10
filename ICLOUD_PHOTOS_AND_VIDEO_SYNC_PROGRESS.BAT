
MODE 70,4
COLOR 1E
SETLOCAL
SET DATA_FILENAME=ICLOUD.DATA
SET DATA_FULLFILENAME=%TEMP%\%DATA_FILENAME%
SET ICLOUD_PHOTOS_FOLDER="%HOMEPATH%\iCloudPhotos\Photos"
TITLE=Apple iCloud Photos and Videos synchronization status
CLS
@ECHO OFF
:: Make CMD window topmost
@powershell -ExecutionPolicy UnRestricted -Command "(Add-Type -memberDefinition \"[DllImport(\"\"user32.dll\"\")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x,int y,int cx, int xy, uint flagsw);\" -name \"Win32SetWindowPos\" -passThru )::SetWindowPos((Add-Type -memberDefinition \"[DllImport(\"\"Kernel32.dll\"\")] public static extern IntPtr GetConsoleWindow();\" -name \"Win32GetConsoleWindow\" -passThru )::GetConsoleWindow(),-1,0,0,0,0,67)">NUL 2>&1
ECHO Collecting data...
:GATHER_STATUS
IF EXIST "%DATA_FULLFILENAME%" DEL /F /Q "%DATA_FULLFILENAME%">NUL 2>&1
CD /D %ICLOUD_PHOTOS_FOLDER%
:: List file sizes of all files in the iCloud photos folder to a temp file
FOR /F "usebackq skip=7 tokens=3" %%i IN (`DIR`) DO ECHO %%i >>"%DATA_FULLFILENAME%"
CD /D "%TEMP%"
:: Count files downloaded by locating file size rows in temp file prefixed by a left paranthesis character
FOR /F "usebackq skip=1 tokens=3 delims=: " %%i IN (`FIND /C "(" %DATA_FILENAME%`) DO SET /A NOTDOWNLOADED=%%i
:: Count files not downloaded by locating file size rows in temp file prefixed by a left paranthesis character
FOR /F "usebackq skip=1 tokens=3 delims=: " %%i IN (`FIND /V /C "(" %DATA_FILENAME%`) DO SET /A DOWNLOADED=%%i
IF EXIST "%DATA_FULLFILENAME%" DEL /F /Q "%DATA_FULLFILENAME%">NUL 2>&1
:: Calculate total by adding downloaded and not downloaded file counts
SET /A "TOTAL=DOWNLOADED+NOTDOWNLOADED"
:: Calculate % downloaded
SET /A "PERCENTAGE=DOWNLOADED*100/TOTAL"
CLS
ECHO %PERCENTAGE%%% complete...
ECHO %TOTAL% total files; %DOWNLOADED% downloaded, %NOTDOWNLOADED% not.
IF %PERCENTAGE%==100 GOTO DONE
GOTO GATHER_STATUS
:DONE
ECHO All files downloaded.
TIMEOUT /T 300
EXIT
