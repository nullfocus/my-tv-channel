<h1 align="center">
  my-tv-channel

</h1>

<p align="center">
  <i align="center">A project to create a quasi tv channel</i>
</p>

## Introduction

There was a Hacker News post recently where the OP asked what cool side-projects people had built. Some one replied that they had built a personal tv channel, streaming all their own content. 

I thought that sounded so awesome, to fight the "paradox of choice", recreating the old days of cable tv surfing where you would stumble upon your favorite show or movie and just leave it on. 

## Usage
To run this service:

```
git clone https://github.com/nullfocus/my-tv-channel.git 

make daemon
```

This will look for videos in the `./vids` directory and start streaming them.

To change the location of videos, edit the `makefile` and update the `video-location` variable.  

To stop the daemonized instance:
```make stop```

This will also delete the instance and the image.

## Goals

The primary outcomes desired here are:

- enable network streaming of video content
- the videos should be streamed in random order, continually

Secondary desired outcomes:

- extremely simple setup of the server
- minimal technical needs for clients (browsers based ideally)
- supporting multiple clients at once


## Example use cases

_This all assumes you legally own the content or have licensing for it!_

- Run a tv channel of your favorite episodic comedy shows to leave on as background noise
- Recreate the golden years of MTV with a bunch of music videos
- Run an HBO competitor with your all-time favorite films


## Alternative approaches

1. **Script it** - If the desire to host multiple clients were dropped, this could all be "faked" with a script that picks a random video and jumps to a random point within that video, then queues the rest of the videos randomly as well in a playlist.
2. **Just use VLC** - You can point VLC to a directory and simply click repeat and randomize, and _done_!

## Open issues and next steps

- [ ] Improve script to randomize videos
- [ ] Consider adding Basic Auth for public internet hosting
- [ ] Consider adding a UI to download from youtube directly
- [x] Fix Dash or HLS streaming
