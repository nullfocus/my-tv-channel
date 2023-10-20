@echo off
if %1.==. goto NoArgs

set image-name=nullfocus/my-tv-channel
set instance-name=mychannel
set video-location=.\vids

goto %1

:clean
	docker rm %instance-name%
    goto End

:build
	docker build -t %image-name% .\
    goto End

:run
	docker run --name %instance-name% -v "%video-location%:/vids" -p 8080:80 %image-name%
    goto End

:daemon 
	docker run --name %instance-name% -v "%video-location%:/vids" -p 8080:80 --restart unless-stopped -d %image-name% 
    goto End

:stop
	docker stop %instance-name%
    goto End

:NoArgs
    echo No arguments passed

:End
    exit /b 0
    