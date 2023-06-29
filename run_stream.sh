#!/bin/sh

while true
do
  for file in /vids/*
  do
    ffmpeg \
      -re \
      -i \
      "$file" \
      -filter:v scale=720:-1 \
      -c:a aac \
      -ar 44100 \
      -f flv \
      rtmp://localhost/live/stream
  done
done
