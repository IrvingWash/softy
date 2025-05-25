.PHONY: build

build_path = ./build
exe_name = main.out
exe_path = $(build_path)/$(exe_name)
compile_flags = -Wall -Werror -std=c99
linker_flags = -lSDL2

build:
	@mkdir -p $(build_path)
	gcc $(compile_flags) $(linker_flags) ./src/*.c -o $(exe_path)

run:
	./$(exe_path)

clean:
	@rm -rf $(build_path)
