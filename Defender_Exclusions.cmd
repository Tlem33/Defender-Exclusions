:: Defender_Exclusions.cmd - Créer par Tlem
:: Defender_Exclusions permet de rajouter ou supprimer automatiquement une liste d'exclusions dans Microsoft Defender.
:: Vous devez compléter le fichier modèle Exceptions.ini ou créer vos propres fichiers de configuration.
::
:: Version 1.2 du 18/06/2020
:: Lire le fichier LisezMoi.txt pour plus d'informations.
::


@Echo Off
::Mode con cols=80 lines=20
Cls

:: Version :
Set Version=1.2

PushD "%~DP0"
Set PowerShellExe="%WINDIR%\system32\WindowsPowerShell\v1.0\powershell.exe"
Set CfgFile=*.ini
Set CfgPath=%~DP0CfgFiles\
Set FirstCfg=0
Set Error=0

Call :TestOS
Call :TestDefender

::Get Admin Right
"%WINDIR%\system32\Net.exe" session 1>NUL 2>NUL || (%PowerShellExe% start-process """%~dpnx0""" -verb RunAs & Exit /b 1)

:: Vérifie si le dossier des fichiers de configuration existe et le crée si nécessaire.
If Not Exist "%CfgPath%" MD "%CfgPath%">Nul 2>Nul

:: Création d'un modèle de fichier de configuration (Exceptions.ini) si aucun fichier n'existe.
If Not Exist "%CfgPath%%CfgFile%" (
	Set FirstCfg=1
	Echo ; Veuillez indiquer les exceptions en les séparant par un point virgule.>"%CfgPath%Exceptions.ini"
	Echo ; Path    = C:\Dossier1;C:\Dossier2  ^(Chemins de dossier à exclure^)>>"%CfgPath%Exceptions.ini"
	Echo ; Ext     = *.tmp;*.bak;*.xxx        ^(Extensions de fichiers à exclure^)>>"%CfgPath%Exceptions.ini"
	Echo ; Process = galsvw32.exe;ccm.exe     ^(Noms des processus à exclure^)>>"%CfgPath%Exceptions.ini"
	Echo ; >>"%CfgPath%Exceptions.ini"
	Echo.>>"%CfgPath%Exceptions.ini"
	Echo Path=>>"%CfgPath%Exceptions.ini"
	Echo.>>"%CfgPath%Exceptions.ini"
	Echo Ext=>>"%CfgPath%Exceptions.ini"
	Echo.>>"%CfgPath%Exceptions.ini"
	Echo Process=>>"%CfgPath%Exceptions.ini"
	If Not Exist "%CfgPath%Exceptions.ini" (
		Call :ErrorMsg
		Echo.
		Echo		Impossible de lire ou de cr‚er le fichier Exceptions.ini !!!
		Echo.
		Call :Pause
		Exit
	)	
)	


If %FirstCfg%==1 (
	Call :ErrorMsg
	Echo.
	Echo			Avant de pouvoir choisir un fichier de configuration,
	Echo			Vous devez completer le fichier Exceptions.ini ou cr‚er
	echo			d'autres fichiers de configuration dans le dossier CfgFiles !!!
	Echo.
	Call :Pause
	Exit
)	


:CfgSelection
Set Start=1
Set FileCmpt=0
Set a=
Set b=

Setlocal EnableDelayedExpansion

:: Go to the CfgPath
PushD %CfgPath%

:: Get file list in one array
For %%a In ("%CfgFile%") Do (
   Set /A FileCmpt+=1
   Set "name[!FileCmpt!]=%%a"
)
::If %FileCmpt% GTR 9

:: Check the max size of the array
Set end=%FileCmpt%

:: Affiche un tableau de fichiers
Cls
Set Var=
Color 0F
Echo                         ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                         º                              º
Echo                         º    Defender Exclusion v%version%   º
Echo                         º                              º
Echo                         ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Echo.

For /L %%b In (%Start%,1,%End%) Do (
   Echo     %%b - !name[%%b]!
)
Echo     Q - Quitte le programme
Echo.
Echo.

:CfgChoice
Set /p Var="Entrez votre choix : 1 a %FileCmpt% ou Q : "
If "%var%"=="" Goto :CfgSelection
If /I "%var%"=="Q" Exit
If %var% gtr %FileCmpt% Goto :CfgSelection

:: Check if input is a number
Echo %var%| findstr /r "^[1-9][0-9]*$">nul
If %errorlevel% EQU 1 Goto :CfgSelection

:: Get the result from array
For %%a In ("!name[%var%]!") Do Set "result=%%~Fa"

Set CfgFile=%result%
::endlocal


:: Lecture du fichier de configuration
For /F "Tokens=1,2 Delims==" %%a In ('Type "%CfgFile%"') Do (
If %%a==Path Set sPath=%%b
If %%a==Ext Set sExt=%%b
If %%a==Process Set sProcess=%%b
)


:: Si les 3 paramètres ne sont pas renseignés
If "%sPath%%sExt%%sProcess%"=="" (
	Call :ErrorMsg
	Echo.
	Echo			"%CfgFile%"
	Echo			Ce fichier de configuration n'est pas param‚tr‚.
	Echo			Veuillez l'‚diter et le compl‚ter avant de poursuivre.
	Echo.
	Call :Pause
	Exit
)


:: Mise en forme des valeurs pour Windows Defender
If "%sPath%" NEQ "" Set Path=('%sPath:;=','%')
If "%sExt%" NEQ "" Set Ext=('%sExt:;=','%')
If "%sProcess%" NEQ "" Set Process=('%sProcess:;=','%')


:Choix
Cls
Set Var=
Echo  Quelle action d‚sirez-vous effecter ?
Echo.
Echo.
Echo      A - Ajouter les exceptions dans Microsoft Defender
Echo.
Echo      S - Supprimer les exceptions dans Microsoft Defender
Echo.
Echo      Q - Quitter
Echo.
Echo.
Echo.
Set /P Var="Veuillez taper votre choix : A (par d‚faut), S ou Q  : "
If "%var%"=="" Goto :Add
If /I "%var%"=="A" Goto :Add
If /I "%var%"=="S" Goto :Delete
If /I "%var%"=="Q" Exit
Goto :Choix



:Add
CLS
Echo Ajout des exclusions en cours. Veuillez patienter ...
REM -inputformat none -outputformat none -NonInteractive
%PowerShellExe% -Command Add-MpPreference -ExclusionPath %Path%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionPath

%PowerShellExe% -Command Add-MpPreference -ExclusionExtension %Ext%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionExtension

%PowerShellExe% -Command Add-MpPreference -ExclusionProcess %Process%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionProcess

If %Error%==0 (
	Color 0A
	Echo Ajout des exclusions termin‚ avec succ‚s.
) Else (
	Call :ErrorMsg
	Echo Echec lors de l'ajout des exclusions.
	Echo V‚rifiez les messages ci-dessus pour voir les erreurs.
)
Call :Pause
Exit



:Delete
REM -inputformat none -outputformat none -NonInteractive
%PowerShellExe% -Command Remove-MpPreference -ExclusionPath %Path%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionPath

%PowerShellExe% -Command Remove-MpPreference -ExclusionExtension %Ext%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionExtension

%PowerShellExe% -Command Remove-MpPreference -ExclusionProcess %Process%
If %ERRORLEVEL%==1 Set Error=1
%PowerShellExe% -Command Get-MpPreference ^| Select-Object -Property ExclusionProcess

If %Error%==0 (
	Color 0A
	Echo Suppression des exclusions termin‚ avec succ‚s.
) Else (
	Call :ErrorMsg
	Echo Echec lors de la suppression des exclusions.
	Echo V‚rifiez les messages ci-dessus pour voir les erreurs.
)
Call :Pause
Exit


:ErrorMsg
Color 0C
Echo.
Echo                          ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
Echo                          º                          º
Echo                          º          ERREUR          º
Echo                          º                          º
Echo                          ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
Echo.
Echo.
Goto :EOF


:TestOS
:: NT  5.0 = Windows 2000
:: NT  5.1 = Windows XP
:: NT  5.2 = Windows 2003 Server
:: NT  6.0 = Windows Vista / 2008 Server
:: NT  6.1 = Windows 7 / 2011 Server
:: NT  6.2 = Windows 8 / 2012 Server
:: NT  6.3 = Windows 8.1
:: NT 10.0 = Windows 10
::
:: EQU - Egal
:: NEQ - Différent
:: LSS - Inférieur
:: LEQ - Inferieur ou égal
:: GTR - Supérieur
:: GEQ - supérieur ou égal
::
For /F "Tokens=1,2* delims=[]" %%a In ('ver') Do Set OSversion=%%b
For /F "Tokens=1,2 delims=." %%a In ('Echo %OSversion:~8,10%') Do Set OSversion=%%a%%b

If %OSVersion% LSS 62 (
	Color 0C
	Cls
	Call :ErrorMsg
	Echo.
	Echo Votre version de Windows n'est pas compatible avec ce programme.
	Echo.
	Echo Veuillez ouvrir Microsoft Security et dans l'onglet "ParamŠtres",
	Echo rajoutez manuellement les exceptions pour chaque type.
	Echo.
	Echo Le fichier "Exceptions.ini" va ˆtre ouvert aprŠs cette ‚tape.
	Echo Utilisez le Copier/Coller pour rajouter les exceptions manuellement
	Echo dans l'antivirus que vous utilisez actuellement.
	Call :Pause
	Start "ini" Exceptions.ini
	Exit
)
Goto :Eof

:TestDefender
Echo Test si Defender est actif ...
SC Query Windefend|Findstr RUNNING
If %errorlevel%==1 (
	Color 0C
	Cls
	Call :ErrorMsg
	Echo.
	Echo                Windows Defender n'est pas actif sur ce poste.
	Echo                Vous avez probablement un autre antivirus actif.
	Echo                Ajout automatique des exclusions impossible
	Echo.
	Echo.
	Call :Pause
	Exit
)
Goto :Eof
	

:Pause
Echo.
Echo Appuyez sur une touche pour quitter.
Pause>Nul

:Eof