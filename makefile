image-name = my-tv-channel
instance-name = mychannel
video-location = ./vids

build:
	docker build -t $(image-name) ./

start: build
	docker run \
		--name $(instance-name) \
		-v $(video-location):/vids \
		-p 8080:80 \
		-p 1935:1935 \
		-p 8088:8088 \
		$(image-name)

stop:
	docker stop $(instance-name)
	docker rm $(instance-name)

restart: stop start
