<h1 align="center">
  my-tv-channel

</h1>

<p align="center">
  <i align="center">A project to create your own personal tv channel</i>
</p>

[DockerHub image](https://hub.docker.com/r/nullfocus/my-tv-channel)

## Introduction

There was a Hacker News post recently where the OP asked what cool side-projects people had built. Some one replied that they had built a personal tv channel, streaming all their own content. 

I thought that sounded so awesome - fighting the "paradox of choice" by recreating the serendipitous discovery of your favorite show, movie, or music video already playing on TV. 

So, I started looking into how to easily create a video stream and broadcast it, and came upon combining `NGINX` with `ffmpeg`, and decided to wrap it up nicely in a `Docker` container! I hope you enjoy it!

## Example use cases

_This all assumes you legally own the content or have licensing for it!_

- Run a tv channel of your favorite episodic comedy shows to leave on as background noise
- Recreate the golden years of MTV with a bunch of music videos
- Run an HBO competitor with your all-time favorite films


## Usage

0. Pre-requisites of `make` and `docker` on your unix-like machine. For Windows you need Docker Desktop, and replace `make` below with `make.bat` at the command line.

1. Grab locally: 
```
git clone https://github.com/nullfocus/my-tv-channel.git
```

2. Fill up the `./vids/` directory with movies, music videos, home movies, etc. To change the location of videos, edit the `makefile` and update the `video-location` variable.  

3. To run it in the background forever:

```
make daemon
```
OR just run it directly in your command line:
```
make run
```


4. Browse to [http://localhost:8080](http://localhost:8080) to view the stream in your browser, or point `VLC` or other media players to [http://localhost:8080/dash/stream.mpd](http://localhost:8080/dash/stream.mpd)


To stop the daemonized background instance (this will also delete the instance and image):

``` 
make stop 
```

## How does this work?

This is a bunch of fun technologies rolled into one! Primarly it's leveraging `NGINX` which is the web server used by a _third_ of the web, and `ffmpeg` which is an A/V tool used directly or behind the scenes by _practically everyone with audio and video files to manipulate_.

It's all packaged up with `Docker` which is basically a self-contained mini linux system, which supports repeatability and reproducability of software. This means if "it works on my machine" it will most likely work on yours.

The `makefile` has a `build` command for building a docker image from the files in the proejct, and the directives in the `Dockerfile`. It uses a heavy-weight base image `ubuntu`, which avoids the need for downloading and comiling `NGINX`, and just installs a couple of tools and a libary. It saves this image locally as `my-tv-channel`. 

You'll notice the `makefile` also has two similar commands `run` and `daemon`, which run the image directly in the command line or as a background service. It does two critical things, it _mounts_ the local `./vids/` file into the container, so that if you drop new files in there, they get automatically picked up and played, and it _exposes_ port `8080` locally for your web browser.

When the docker instance runs, it kicks off `supervisord` which runs and monitor multiple processes. We're using it to run two in parallel: `NGINX` and the `run_stream.sh` script. 

When `NGINX` fires up, its `nginx.conf` file, sets up an `RTMP` server on port `1935` using `Dash` technology. Essentially it turns the web server into a video streaming platform, by allowing a video source to push a stream to that port. The web server then hosts that stream for multiple clients! The configuration also lets us host html files, so we use that to host a simple `index.html` which uses the `dash.js` library to _view_ the stream in an embedded HTML5 `<video>` tag.

_Finally_ the `run_stream.sh` runs, and continually searches for files in the `./vids/` directory with the extensions `.mkv`, `.mp4`, or `.avi`, and randomizes them. Then it runs the `ffmpeg` over each file, and streams the converted output to the `RTMP` endpoint created in `NGINX`. Don't ask me what all the flags do, `ffmpeg` is still high wizardy to me, so I used the [Akamai ffmpeg builder](https://moctodemo.akamaized.net/tools/ffbuilder/) to get to a starting point.

## Goals

The primary outcomes desired here are:

- enable network streaming of video content
- from a centralized location (ie. a tucked away server)
- the videos should be streamed in random order, continually

Secondary desired outcomes:

- extremely simple setup of the server
- minimal technical needs for clients (browsers based ideally)
- supporting multiple clients at once

## Alternative approaches

1. **Script it** - If the desire to host multiple clients were dropped, this could all be "faked" with a script that picks a random video and jumps to a random point within that video, then queues the rest of the videos randomly as well in a playlist.
2. **Use VLC** - Again if it's just a single viewer, you could point VLC to a directory and simply click repeat and randomize

## Open issues and next steps

- [ ] DLNA module for NGINX to more easily stream to smart TVs and Roku devices
- [ ] Get HLS streams working again
- [ ] Error handling for the script so it's resilient and won't bomb out if there's a hiccup somewhere
- [ ] Add SSL support (gets rid of the scary browser messages, and pairs well with Basic Auth below)
- [ ] Add Basic Auth for some semblance of security?
- [x] `make.bat` file to support Docker Desktop on Windows  
- [x] Fix Dash or HLS streaming
- [x] Improve script to randomize videos
