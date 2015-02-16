%.xml:
	wget http://2015.msrconf.org/challenge_data/stackoverflow.com-$*.7z -O $*.7z
	7za x $*.7z
	rm $*.7z

all: Posts.xml Users.xml Badges.xml PostHistory.xml
