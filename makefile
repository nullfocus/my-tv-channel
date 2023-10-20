image-name = nullfocus/my-tv-channel
instance-name = mychannel
video-location = ./vids

# TIL  .PHONY is just a saftey net for make if there are physical FILES 
#      which match the names of targets below in the build directory, 
#      so make doesn't get confused
.PHONY: clean build run daemon stop restart

clean:
	- docker rm $(instance-name)

build:
	docker build -t $(image-name) ./

run: stop clean build
	docker run \
		--name $(instance-name) \
		-v "$(video-location):/vids" \
		-p 8080:80 \
		$(image-name)

daemon: stop clean build
	docker run \
		--name $(instance-name) \
		-v "$(video-location):/vids" \
		-p 8080:80 \
		--restart unless-stopped \
		-d \
		$(image-name)

stop: 
	- docker stop $(instance-name)

restart: stop clean build daemon
