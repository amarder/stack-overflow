%.xml:
	wget https://archive.org/download/stackexchange/stackoverflow.com-$*.7z -O $*.7z
	7za x $*.7z
	rm $*.7z

all: Posts.xml Users.xml Badges.xml PostHistory.xml
