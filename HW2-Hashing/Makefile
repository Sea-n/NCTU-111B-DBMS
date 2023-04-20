release:
	g++ -std=c++17 -O3 \
	-o hw2 main.cpp utils.cpp hash.cpp
	strip hw2

prof:
	g++ -std=c++17 -O3 -pg \
	-o hw2 main.cpp utils.cpp hash.cpp
	./hw2
	gprof hw2 gmon.out > gprof.txt

debug:
	g++ -std=c++17 -g -Wall -Wextra -fsanitize=address,undefined \
	-o hw2 main.cpp utils.cpp hash.cpp
