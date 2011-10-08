#!/bin/bash

# Dependencies:
#  http://www.macports.org/
#  http://www.videohelp.com/tools/mp4box
#  sudo port install ffmpeg

# Usage:
#  cd dir_where_are_your_videos
#  encode4iphone3gs *.flv *.avi ...etc...
#  ...now your encoded videos are in the subdirectory 'encoded',
#  so just drop them into iTunes.

ee=""
t=""

# uncomment to test stuff:
#ee="echo"
# uncomment to encode from specified time:
#t="-t 120"

threads="-threads 4"
width=480

options="-vcodec libx264 -b 700k -flags +loop+mv4 -cmp 256 \
	-partitions +parti4x4+parti8x8+partp4x4+partp8x8+partb8x8 \
	-me_method hex -subq 7 -trellis 1 -refs 7 -bf 0 \
	-flags2 +mixed_refs -coder 0 -me_range 16 \
	-g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -qmin 10 \
	-qmax 51 -qdiff 4"	

mkdir -p encoded

for F in "$@"; do
	
	rm -f *.log *.log.mbtree
	
	echo \"$F\"
	
	W=`ffprobe -show_streams "$F" 2>/dev/null | grep "width=" | cut -d'=' -f2`
	H=`ffprobe -show_streams "$F" 2>/dev/null | grep "height=" | cut -d'=' -f2`
	Ws=$width
	Hs=$(($width*$H/$W))
	
	if [ $(( $Hs % 2 )) -ne 0 ] ; then Hs=$(($Hs+1)); fi
		
	scale="-s $Ws:$Hs"
	#scale="-vfilter scale=$width:-1"

	# 2 pass encoding:
	#$ee ffmpeg $t -y -i $F -an -pass 1 $scale $threads $options -f rawvideo /dev/null
	#$ee ffmpeg $t -y -i $F -acodec libfaac -ab 128k -ac 2 -pass 2 $scale $threads $options "encoded/$F.mp4"
	
	# 1 pass encoding
	$ee ffmpeg $t -y -i "$F" -acodec libfaac -ab 128k -ac 2 $scale $threads $options "encoded/$F.mp4"
	
	rm -f *.log *.log.mbtree
	
	/Applications/Osmo4.app/Contents/MacOS/MP4Box -inter 5000 "encoded/$F.mp4"

done;
