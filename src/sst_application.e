note
	description: "[
		Simple Setup - CLI application for managing simple_* ecosystem.

		Commands:
			install <lib> [<lib>...]   Install libraries
			update [--all | <lib>...]  Update libraries
			list                       List available libraries
			info <lib>                 Show library information
			status                     Show installed libraries
			generate-inno              Generate Inno Setup script
			build-installer            Build Windows installer
			help                       Show help

		Examples:
			simple_setup install simple_json simple_csv
			simple_setup update --all
			simple_setup generate-inno --version 1.0.0
			simple_setup build-installer --version 1.0.0
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run the installer application
		do
			create console
			create manifest.make
			create installer.make (manifest)
			create env_manager.make
			create inno_generator.make (manifest)

			parse_arguments
			execute_command
		end

feature -- Access

	console: SIMPLE_CONSOLE
			-- Console for color control

	manifest: SST_MANIFEST
			-- Library manifest

	installer: SST_INSTALLER
			-- Installation handler

	env_manager: SST_ENV_MANAGER
			-- Environment variable manager

	inno_generator: SST_INNO_GENERATOR
			-- Inno Setup script generator

feature -- Output helpers

	print_line (a_text: READABLE_STRING_GENERAL)
			-- Print text followed by newline
		do
			print (a_text)
			print ("%N")
		end

	print_error (a_text: READABLE_STRING_GENERAL)
			-- Print error text in red
		do
			console.set_foreground (console.Red)
			print (a_text)
			print ("%N")
			console.reset_color
		end

	print_success (a_text: READABLE_STRING_GENERAL)
			-- Print success text in green
		do
			console.set_foreground (console.Green)
			print (a_text)
			print ("%N")
			console.reset_color
		end

feature {NONE} -- Command Parsing

	command: STRING_32
			-- Current command to execute
		attribute
			create Result.make_empty
		end

	command_args: ARRAYED_LIST [STRING_32]
			-- Arguments for the command
		attribute
			create Result.make (10)
		end

	options: HASH_TABLE [STRING_32, STRING_32]
			-- Command options (--key=value or --flag)
		attribute
			create Result.make (10)
		end

	parse_arguments
			-- Parse command line arguments
		local
			i: INTEGER
			l_arg: STRING_32
		do
			create command_args.make (10)
			create options.make (10)

			if argument_count = 0 then
				command := "help"
			else
				command := argument (1)

				from i := 2 until i > argument_count loop
					l_arg := argument (i)
					if l_arg.starts_with ("--") then
						parse_option (l_arg)
					else
						command_args.extend (l_arg)
					end
					i := i + 1
				end
			end
		end

	parse_option (a_option: STRING_32)
			-- Parse a --option or --key=value argument
		local
			l_eq_pos: INTEGER
			l_key, l_value: STRING_32
		do
			l_eq_pos := a_option.index_of ('=', 1)
			if l_eq_pos > 0 then
				l_key := a_option.substring (3, l_eq_pos - 1)
				l_value := a_option.substring (l_eq_pos + 1, a_option.count)
			else
				l_key := a_option.substring (3, a_option.count)
				l_value := "true"
			end
			options.force (l_value, l_key)
		end

feature {NONE} -- Command Execution

	execute_command
			-- Execute the parsed command
		do
			if command.same_string ("install") then
				execute_install
			elseif command.same_string ("update") then
				execute_update
			elseif command.same_string ("list") then
				execute_list
			elseif command.same_string ("info") then
				execute_info
			elseif command.same_string ("status") then
				execute_status
			elseif command.same_string ("generate-inno") then
				execute_generate_inno
			elseif command.same_string ("build-installer") then
				execute_build_installer
			elseif command.same_string ("help") then
				execute_help
			else
				print_error ("Unknown command: " + command)
				execute_help
			end
		end

	execute_install
			-- Install specified libraries
		do
			print_line ("Installing libraries...")
			if command_args.is_empty then
				print_error ("No libraries specified. Use: simple_setup install <lib1> [<lib2>...]")
			else
				across command_args as l_cursor loop
					install_library (l_cursor)
				end
				print_success ("Installation complete. Restart your terminal to apply environment variables.")
			end
		end

	execute_update
			-- Update libraries
		do
			if options.has ("all") then
				print_line ("Updating all installed libraries...")
				across manifest.libraries as l_cursor loop
					if installer.is_installed (l_cursor) then
						update_library (l_cursor.name.to_string_32)
					end
				end
			elseif command_args.is_empty then
				print_error ("Specify libraries or use --all. Usage: simple_setup update [--all | <lib>...]")
			else
				across command_args as l_cursor loop
					update_library (l_cursor)
				end
			end
			print_success ("Update complete.")
		end

	execute_list
			-- List available libraries
		do
			print_line ("Available libraries in simple_* ecosystem:")
			print_line ("")

			print_line ("== Foundation Layer ==")
			print_libraries_by_layer ("foundation")

			print_line ("")
			print_line ("== Service Layer ==")
			print_libraries_by_layer ("service")

			print_line ("")
			print_line ("== Platform Layer ==")
			print_libraries_by_layer ("platform")

			print_line ("")
			print_line ("== API Facades ==")
			print_libraries_by_layer ("api")
		end

	execute_info
			-- Show library information
		local
			l_lib: detachable SST_LIBRARY_INFO
		do
			if command_args.is_empty then
				print_error ("Specify a library. Usage: simple_setup info <lib>")
			else
				l_lib := manifest.library_by_name (command_args.first.to_string_8)
				if attached l_lib as l_info then
					print_library_info (l_info)
				else
					print_error ("Unknown library: " + command_args.first)
				end
			end
		end

	execute_status
			-- Show installed libraries
		local
			l_installed, l_missing: INTEGER
		do
			print_line ("Installed libraries:")
			print_line ("")

			across manifest.libraries as l_cursor loop
				if installer.is_installed (l_cursor) then
					print_success ("  [x] " + l_cursor.name)
					l_installed := l_installed + 1
				else
					print_line ("  [ ] " + l_cursor.name)
					l_missing := l_missing + 1
				end
			end

			print_line ("")
			print_line ("Installed: " + l_installed.out + " / " + manifest.libraries.count.out)
		end

	execute_generate_inno
			-- Generate Inno Setup script
		local
			l_version, l_output: STRING
		do
			if attached options.item ("version") as l_v then
				l_version := l_v.to_string_8
			else
				l_version := "1.0.0"
			end

			if attached options.item ("output") as l_o then
				l_output := l_o.to_string_8
			else
				l_output := "simple_ecosystem_setup.iss"
			end

			print_line ("Generating Inno Setup script...")
			inno_generator.generate (l_version, l_output)
			print_success ("Generated: " + l_output)
		end

	execute_build_installer
			-- Build Windows installer using Inno Setup
		local
			l_version: STRING
		do
			if attached options.item ("version") as l_v then
				l_version := l_v.to_string_8
			else
				l_version := "1.0.0"
			end

			print_line ("Building Windows installer...")

			-- First generate the .iss file
			inno_generator.generate (l_version, "simple_ecosystem_setup.iss")

			-- Then compile it with Inno Setup
			if inno_generator.compile_installer ("simple_ecosystem_setup.iss") then
				print_success ("Installer built successfully!")
			else
				print_error ("Failed to build installer. Is Inno Setup installed?")
			end
		end

	execute_help
			-- Show help information
		do
			print_line ("Simple Setup - Package manager for simple_* ecosystem")
			print_line ("")
			print_line ("Usage: simple_setup <command> [options] [arguments]")
			print_line ("")
			print_line ("Commands:")
			print_line ("  install <lib> [<lib>...]   Install one or more libraries")
			print_line ("  update [--all | <lib>...]  Update libraries (--all for all installed)")
			print_line ("  list                       List all available libraries")
			print_line ("  info <lib>                 Show detailed library information")
			print_line ("  status                     Show which libraries are installed")
			print_line ("  generate-inno              Generate Inno Setup script")
			print_line ("  build-installer            Build Windows installer")
			print_line ("  help                       Show this help message")
			print_line ("")
			print_line ("Options:")
			print_line ("  --version=X.Y.Z            Version for installer generation")
			print_line ("  --output=<file>            Output filename for generated script")
			print_line ("  --install-dir=<path>       Installation directory (default: D:\prod)")
			print_line ("  --all                      Apply to all libraries (with update)")
			print_line ("")
			print_line ("Examples:")
			print_line ("  simple_setup install simple_json simple_csv")
			print_line ("  simple_setup update --all")
			print_line ("  simple_setup build-installer --version=1.0.0")
		end

feature {NONE} -- Implementation

	install_library (a_name: STRING_32)
			-- Install a library by name
		local
			l_lib: detachable SST_LIBRARY_INFO
			i: INTEGER
		do
			l_lib := manifest.library_by_name (a_name.to_string_8)
			if attached l_lib as l_info then
				print_line ("  Installing " + l_info.name + "...")

				-- Install dependencies first
				from i := 1 until i > l_info.dependencies.count loop
					if attached manifest.library_by_name (l_info.dependencies [i]) as l_dep_lib then
						if not installer.is_installed (l_dep_lib) then
							install_library (l_info.dependencies [i].to_string_32)
						end
					end
					i := i + 1
				end

				-- Install the library
				if installer.install (l_info) then
					env_manager.set_library_env (l_info)
					print_success ("    " + l_info.name + " installed")
				else
					print_error ("    Failed to install " + l_info.name)
				end
			else
				print_error ("  Unknown library: " + a_name)
			end
		end

	update_library (a_name: STRING_32)
			-- Update a library by name
		local
			l_lib: detachable SST_LIBRARY_INFO
		do
			l_lib := manifest.library_by_name (a_name.to_string_8)
			if attached l_lib as l_info then
				print_line ("  Updating " + l_info.name + "...")
				if installer.update (l_info) then
					print_success ("    " + l_info.name + " updated")
				else
					print_error ("    Failed to update " + l_info.name)
				end
			else
				print_error ("  Unknown library: " + a_name)
			end
		end

	print_libraries_by_layer (a_layer: STRING)
			-- Print libraries belonging to specified layer
		do
			across manifest.libraries as l_cursor loop
				if l_cursor.layer.same_string (a_layer) then
					if installer.is_installed (l_cursor) then
						print_line ("  [x] " + l_cursor.name + " - " + l_cursor.description)
					else
						print_line ("  [ ] " + l_cursor.name + " - " + l_cursor.description)
					end
				end
			end
		end

	print_library_info (a_lib: SST_LIBRARY_INFO)
			-- Print detailed library information
		local
			i: INTEGER
		do
			print_line ("Library: " + a_lib.name)
			print_line ("Description: " + a_lib.description)
			print_line ("Layer: " + a_lib.layer)
			print_line ("GitHub: " + a_lib.github_url)

			if not a_lib.dependencies.is_empty then
				print_line ("Dependencies:")
				from i := 1 until i > a_lib.dependencies.count loop
					print_line ("  - " + a_lib.dependencies [i])
					i := i + 1
				end
			end

			print_line ("Environment Variable: " + a_lib.env_var_name)

			if installer.is_installed (a_lib) then
				print_success ("Status: Installed")
				print_line ("Path: " + installer.install_path (a_lib))
			else
				print_line ("Status: Not installed")
			end
		end

end
