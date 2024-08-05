@echo off
mkdir my-windows-app
cd my-windows-app
mkdir content

echo ^<html^>^<head^>^<title^>Windows containers^</title^>^</head^>^<body^>^<p^>Windows containers are cool!^</p^>^</body^>^</html^> > content\index.html

echo FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019 > Dockerfile
echo RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\* >> Dockerfile
echo WORKDIR /inetpub/wwwroot >> Dockerfile
echo COPY content/ . >> Dockerfile

docker build -t gcr.io/dotnet-atamel/iis-site-windows .
docker images
