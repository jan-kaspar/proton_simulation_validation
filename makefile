all: collect_systematics

collect_systematics : collect_systematics.cc
	g++ --std=c++11 `root-config --libs` `root-config --cflags` -Wall -Werror -g\
		collect_systematics.cc -o collect_systematics
