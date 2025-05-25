build_path = ./build
exe_name = main.out
exe_path = $(build_path)/$(exe_name)
compile_flags = -Wall -std=c99

build:
	@mkdir -p $(build_path)
	gcc $(compile_flags) ./src/*.c -o $(exe_path)
run:
	./$(exe_path)
clean:
	@rm -rf $(build_path)
