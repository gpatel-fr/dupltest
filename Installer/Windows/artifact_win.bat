@rem Installation instructions when building locally (March 2023)
@rem The life expectancy of any URL on MS servers is about one or two years
@rem so links can become obsolete fast.
@rem   - setup a Windows 2022 VM 
@rem     (should work for Win10 but a 2022 VM is valid for 6 months vs 1 for Win10)
@rem   - install git from https://git-scm.com/download/win
@rem   - add to the PATH the directory c:\program files\git
@rem   - install .NET SDK 4.7 from https://dotnet.microsoft.com/en-us/download/visual-studio-sdks
@rem   - install msbuild (visual studio community)
@rem   - install nuget from https://learn.microsoft.com/en-us/nuget/install-nuget-client-tools
@rem   - install wix 3 from https://wixtoolset.org
@rem   - add to the PATH msbuild, wix3 and nuget
set RUNTMP=%USERPROFILE%
where /q bash.exe
if ERRORLEVEL 1 (
git-bash -x Installer\bundleduplicati.sh
) ELSE (
bash -x Installer\bundleduplicati.sh
)
cd Installer\Windows
call build-msi %RUNTMP%\bundleduplicati.zip
mkdir %RUNTMP%\artifacts
@echo on
move *.msi %RUNTMP%\artifacts
cd ..\..
