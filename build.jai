#!jai

Compiler :: #import "Compiler";
#import "Basic";
File :: #import "File";

BUILD_DIR_NAME :: ".build";
DEBUG_DIR_NAME :: "debug";
RELEASE_DIR_NAME :: "release";
EXE_NAME :: "softy";
SOURCE_DIR_NAME :: "src";
ENTRY_FILE_NAME :: "main.jai";
BASE_BUILD_PATH :: #run make_base_build_path();

Config :: struct {
    build: bool;
    clean: bool;
    mode: Mode;
}

Mode :: enum u8 {
    Debug;
    Release;
}

#run {
    Compiler.set_build_options_dc(.{do_output = false});

    config := make_config_from_args();

    if config.clean {
        clean();
    }

    if config.build {
        build(config);
    }

    reset_temporary_storage();
}

clean :: () {
    File.delete_directory(BASE_BUILD_PATH);
}

build :: (config: Config) {
    w := Compiler.compiler_create_workspace("Executable");
    if !w {
        print("Failed to create a workspace\n", to_standard_error = true);
    }

    build_options := Compiler.get_build_options();

    build_options.output_type = .EXECUTABLE;
    build_options.output_executable_name = EXE_NAME;

    optimization_type: Compiler.Optimization_Type = ---;
    build_path: string = ---;
    if #complete config.mode == {
        case .Debug;
            optimization_type = .DEBUG;
            build_path = tprint("%/%", BASE_BUILD_PATH, DEBUG_DIR_NAME);
        case .Release;
            optimization_type = .OPTIMIZED;
            build_path = tprint("%/%", BASE_BUILD_PATH, RELEASE_DIR_NAME);
    }

    Compiler.set_optimization(*build_options, optimization_type);
    build_options.output_path = build_path;
    build_options.intermediate_path = build_path;

    Compiler.set_build_options(build_options, w);

    File.make_directory_if_it_does_not_exist(build_path, recursive = true);

    source_path := tprint("%0%/%", #filepath, SOURCE_DIR_NAME, ENTRY_FILE_NAME);
    Compiler.add_build_file(source_path, w);
}

make_base_build_path :: () -> string #compile_time {
    return tprint("%0%", #filepath, BUILD_DIR_NAME);
}

make_config_from_args :: () -> Config {
    args := Compiler.get_build_options().compile_time_command_line;

    config: Config;

    for arg: args {
        if arg == {
            case "build";
                config.build = true;
            case "clean";
                config.clean = true;
            case "release";
                config.mode = .Release;
            case;
                print("Unsupported argument `%`\n", arg, to_standard_error = true);
        }
    }

    return config;
}
