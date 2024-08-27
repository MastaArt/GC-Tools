:: xNormal
:: 1.0.0
:: Vasyl Lukianenko 
:: 3DGROUND
:: https://3dground.net

echo off
cls

set input=%1
set xnormal=
set fbx=
set jpg=
set size=

for /f "tokens=1,2,3,4 delims=;" %%i in (%input%) do (
	set xnormal="%%i"
	set fbx=%%j
	set jpg=%%k
	set size=%%l
)

set pth=%~dp0
set config="%pth%xnormal.xml"
set tmp_config="%pth%_tmp_xnormal.xml"

powershell -Command "(Get-Content -Path '%config%') -replace '@FBX@', '%fbx%' | Set-Content -Path '%tmp_config%'"
powershell -Command "(Get-Content -Path '%tmp_config%') -replace '@JPG@', '%jpg%' | Set-Content -Path '%tmp_config%'"
powershell -Command "(Get-Content -Path '%tmp_config%') -replace '@SIZE@', '%size%' | Set-Content -Path '%tmp_config%'"

%xnormal% %tmp_config%

del %tmp_config%