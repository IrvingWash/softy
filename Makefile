build_path = ./build
exe_name = main.out
exe_path = $(build_path)/$(exe_name)

build:
	@mkdir -p $(build_path)
	gcc ./src/main.c -o $(exe_path)
run:
	./$(exe_path)
clean:
	@rm -rf $(build_path)
