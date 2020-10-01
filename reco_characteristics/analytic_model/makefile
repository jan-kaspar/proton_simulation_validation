all: calculate_systematics calculate_bias_resolution

calculate_systematics: calculate_systematics.cc common_code.h
	g++ `root-config --libs` -lMinuit `root-config --cflags` -Wall --std=c++17 -g\
		calculate_systematics.cc -o calculate_systematics

calculate_bias_resolution: calculate_bias_resolution.cc common_code.h
	g++ `root-config --libs` -lMinuit `root-config --cflags` -Wall --std=c++17 -g\
		calculate_bias_resolution.cc -o calculate_bias_resolution
