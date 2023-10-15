image-name = my-tv-channel
instance-name = mychannel
video-location = ./vids

clean:
	- docker rm $(instance-name)

build:
	docker build -t $(image-name) ./

run: stop clean build
	docker run \
		--name $(instance-name) \
		-v $(video-location):/vids \
		-v ./index.html:/var/www/html/index.html \
		-p 8080:80 \
		$(image-name)

daemon: stop clean build
	docker run \
		--name $(instance-name) \
		-v $(video-location):/vids \
		-v ./index.html:/var/www/html/index.html \
		-p 8080:80 \
		--restart unless-stopped \
		-d \
		$(image-name)

stop: 
	- docker stop $(image-name)

restart: stop start
