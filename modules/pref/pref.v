module pref

import os

const (
	builtin_path = os.real_path('./builtin')
	
)

pub enum Backend {
	pex
	original // use a vanilla compiler to compile files
}

pub enum RunMode {
	compile
	read 
}

[heap]
pub struct Preferences {
pub mut:
	paths				[]string	// folders with files to compile
	out_dir				[]string	// folders for output files
	mode				RunMode = .compile
	backend				Backend = .pex
	no_cache			bool
	crutches_enabled	bool
	builtin_path		string = builtin_path
}

fn (mut p Preferences) parse_compile_args(args []string) {
	p.mode = .compile
	p.backend = .pex

	if args.len < 3  {
		error("invalid number of arguments")
	}

	mut i := 0

	for i < args.len {
		match args[i] {
			"-i",
			"-input" {
				i++
				
				for i < args.len {
					if args[i].starts_with("-") {
						i--
						break
					}

					path := os.real_path(args[i])
					
					if !os.is_dir(path) {
						error("invalid input path: '$path'")
					}

					if path in p.paths {
						error("path already exists: '$path'")
					}

					p.paths << path

					i++
				}
			}
			"-o",
			"-output" {
				i++
				
				for i < args.len {
					if args[i].starts_with("-") {
						i--
						break
					}

					path := os.real_path(args[i])

					if !os.is_dir(path) {
						error("invalid output path: '$path'")
					}

					if path in p.out_dir {
						error("path already exists: '$path'")
					}

					p.out_dir << path

					i++
				}
			}
			"-nocache" {
				p.no_cache = true
			}
			"-crutches" {
				p.crutches_enabled = true
			}
			"-original" {
				p.backend = .original
			}
			else {
				error("invalid argument `${args[i]}`")
			}
		}

		i++
	}
}

pub fn parse_args() Preferences {
	mut p := Preferences{}

	args := os.args[1..]

	if args.len == 0 {
		help()
		exit(0)
	}

	match args[0] {
		"help" {
			if args.len > 1 {
				if args[1] == "compile" || args[1] == "read" {
					help_command(args[1])
				}
			}

			help()
		}
		"-compile", // outdated
		"compile" {
			p.mode = .compile
			p.parse_compile_args(args[1..])
		}
		"read" {
			if args.len < 2 {
				error("invalid number of arguments")
			}

			p.mode = .read
			p.paths << os.real_path(args[1])
		}
		else {
			if args[0].starts_with("-") {
				p.mode = .compile
				p.parse_compile_args(args)
			}
			else {
				error("unknown command: `${args[0]}`")
			}
		}
	}

	return p
}

fn error(msg string) {
	eprintln(msg)
	exit(1)
}

fn help() {
	println("Papyrus language compiler")
	println("")
	println("Usage:")
	println("")
	println("	papyrus <command> [arguments]")
	println("")
	println("The commands are:")
	println("")
	println("		compile")
	println("			compile papyrus files")
	println("")
	println("		read")
	println("			read \"*.pex\" file and output result to console")
	println("")
	println("")
	println("Use \"papyrus help <command>\" for more information about a command.")
	exit(0)
}

fn help_command(command string) {
	println("Arguments:")

	match command {
		"compile" {
			println("")
			println("		-i")
			println("			folder with files(*.psc) to compile")
			println("")
			println("		-o")
			println("			folder for compiled files(*.pex)")
			println("")
			println("		-nocache")
			println("			compile all files, regardless of the modification date")
			println("")
			println("		-original")
			println("			compile using a vanilla compiler")
			println("")
		}
		"read" {
			println("papyrus read \"path/to/file.pex\"")
		}
		else {
		}
	}

	exit(0)
}