@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\com\sun\faces\jsf-api\2.2.4\jsf-api-2.2.4.jar;"%REPO%"\com\sun\faces\jsf-impl\2.2.4\jsf-impl-2.2.4.jar;"%REPO%"\org\primefaces\primefaces\4.0\primefaces-4.0.jar;"%REPO%"\org\hibernate\hibernate-entitymanager\4.0.1.Final\hibernate-entitymanager-4.0.1.Final.jar;"%REPO%"\org\jboss\spec\javax\transaction\jboss-transaction-api_1.1_spec\1.0.0.Final\jboss-transaction-api_1.1_spec-1.0.0.Final.jar;"%REPO%"\dom4j\dom4j\1.6.1\dom4j-1.6.1.jar;"%REPO%"\xml-apis\xml-apis\1.0.b2\xml-apis-1.0.b2.jar;"%REPO%"\org\hibernate\hibernate-core\4.0.1.Final\hibernate-core-4.0.1.Final.jar;"%REPO%"\commons-collections\commons-collections\3.2.1\commons-collections-3.2.1.jar;"%REPO%"\antlr\antlr\2.7.7\antlr-2.7.7.jar;"%REPO%"\org\hibernate\javax\persistence\hibernate-jpa-2.0-api\1.0.1.Final\hibernate-jpa-2.0-api-1.0.1.Final.jar;"%REPO%"\org\jboss\logging\jboss-logging\3.1.0.CR2\jboss-logging-3.1.0.CR2.jar;"%REPO%"\org\javassist\javassist\3.15.0-GA\javassist-3.15.0-GA.jar;"%REPO%"\org\hibernate\common\hibernate-commons-annotations\4.0.1.Final\hibernate-commons-annotations-4.0.1.Final.jar;"%REPO%"\org\hibernate\hibernate-c3p0\4.0.1.Final\hibernate-c3p0-4.0.1.Final.jar;"%REPO%"\c3p0\c3p0\0.9.1\c3p0-0.9.1.jar;"%REPO%"\org\hibernate\hibernate-validator\4.2.0.Final\hibernate-validator-4.2.0.Final.jar;"%REPO%"\javax\validation\validation-api\1.0.0.GA\validation-api-1.0.0.GA.jar;"%REPO%"\org\slf4j\slf4j-api\1.6.1\slf4j-api-1.6.1.jar;"%REPO%"\joda-time\joda-time\2.0\joda-time-2.0.jar;"%REPO%"\javax\servlet\servlet-api\2.5\servlet-api-2.5.jar;"%REPO%"\javax\servlet\jstl\1.2\jstl-1.2.jar;"%REPO%"\org\hsqldb\hsqldb\2.2.8\hsqldb-2.2.8.jar;"%REPO%"\com\yahoo\platform\yui\yuicompressor\2.4.7\yuicompressor-2.4.7.jar;"%REPO%"\rhino\js\1.6R7\js-1.6R7.jar;"%REPO%"\br\edu\unirriter\liquid-democracy\1.0-SNAPSHOT\liquid-democracy-1.0-SNAPSHOT.war
set EXTRA_JVM_ARGUMENTS=-Xmx512m
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="webapp" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" Main %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
