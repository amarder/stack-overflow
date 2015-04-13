# Downloading the latest Stack Exchange Data Dump from the Internet
# Archive is a little tricky. I found the fastest way to download the
# tables of interest (Posts, Users, Badges, and PostHistory) was to
# use bittorrent. I didn't find a great command line client so that
# portion of the download was done by hand.
# https://archive.org/details/stackexchange

%.xml:
	wget http://2015.msrconf.org/challenge_data/stackoverflow.com-$*.7z -O $*.7z
	7za x $*.7z
	rm $*.7z

all: Posts.xml Users.xml Badges.xml PostHistory.xml
