all: export_characteristics

export_characteristics: export_characteristics.cc
	g++ `root-config --libs` -lMinuit `root-config --cflags` -Wall --std=c++17 -g\
		export_characteristics.cc -o export_characteristics
