#!/bin/sh

#forever loop on a random listing of the 'vids' directory
while true; do
        find ./vids/ -iname \*.mkv -o -iname \*.mp4 -o -iname \*.avi | sort -R | while read file; do

            ffmpeg \
                -re \
                -fflags +genpts \
                -i "$file" \
                -flags +global_header -r 30000/1001 \
                -filter_complex "scale=640x360" \
                -pix_fmt yuv420p \
                -c:v libx264 \
                -b:v:0 730K -maxrate:v:0 730K -bufsize:v:0 730K/2 \
                -g:v 30 -keyint_min:v 30 -sc_threshold:v 0 \
                -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
                -c:a aac -ar 48000 -b:a 96k \
                -map 0:v:0 \
                -map 0:a:0 \
                -preset veryfast \
                -f flv \
                rtmp://localhost/live/stream
        done;
done;
