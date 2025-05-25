.PHONY: build

build_path = build
exe_name = main.out
exe_path = $(build_path)/$(exe_name)
compile_flags = -Wall -Werror -std=c99
linker_flags = -lSDL2

build:
	@mkdir -p $(build_path)
	@echo "Building softy..."
	gcc $(compile_flags) $(linker_flags) ./src/*.c -o $(exe_path)

run:
	@echo "Running softy..."
	@./$(exe_path)

clean:
	@echo "Cleaning softy..."
	@rm -rf $(build_path)
