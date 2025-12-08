note
	description: "[
		Handles git operations for installing and updating libraries.
		Uses simple_process to execute git commands.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_INSTALLER

create
	make

feature {NONE} -- Initialization

	make (a_manifest: SST_MANIFEST)
			-- Create installer with manifest
		do
			manifest := a_manifest
			create process.make
			install_directory := default_install_dir
		end

feature -- Access

	manifest: SST_MANIFEST
			-- Library manifest

	install_directory: STRING
			-- Base directory for installations

	last_error: detachable STRING
			-- Last error message

feature -- Configuration

	set_install_directory (a_path: STRING)
			-- Set installation directory
		require
			path_not_empty: not a_path.is_empty
		do
			install_directory := a_path
		ensure
			directory_set: install_directory = a_path
		end

feature -- Status

	is_installed (a_lib: SST_LIBRARY_INFO): BOOLEAN
			-- Is library installed?
		local
			l_path: STRING
			l_file: RAW_FILE
		do
			l_path := install_path (a_lib) + "/" + a_lib.ecf_name
			create l_file.make_with_name (l_path)
			Result := l_file.exists
		end

	is_git_available: BOOLEAN
			-- Is git available on the system?
		do
			process.execute ("git --version")
			Result := process.was_successful
		end

	install_path (a_lib: SST_LIBRARY_INFO): STRING
			-- Full path where library is/will be installed
		do
			Result := install_directory + "/" + a_lib.name
		end

feature -- Operations

	install (a_lib: SST_LIBRARY_INFO): BOOLEAN
			-- Install a library from GitHub
		local
			l_cmd: STRING
		do
			last_error := Void

			if is_installed (a_lib) then
				-- Already installed, just verify
				Result := True
			else
				-- Clone from GitHub
				l_cmd := "git clone " + a_lib.github_url + " " + "%"" + install_path (a_lib) + "%""
				process.execute (l_cmd)

				if process.was_successful then
					Result := True
				else
					if attached process.last_error as l_err then
						last_error := l_err.to_string_8
					else
						last_error := "Git clone failed"
					end
				end
			end
		end

	update (a_lib: SST_LIBRARY_INFO): BOOLEAN
			-- Update an installed library
		local
			l_cmd: STRING
		do
			last_error := Void

			if not is_installed (a_lib) then
				last_error := "Library not installed"
				Result := False
			else
				-- Pull latest changes
				l_cmd := "git -C %"" + install_path (a_lib) + "%" pull"
				process.execute (l_cmd)

				if process.was_successful then
					Result := True
				else
					if attached process.last_error as l_err then
						last_error := l_err.to_string_8
					else
						last_error := "Git pull failed"
					end
				end
			end
		end

	uninstall (a_lib: SST_LIBRARY_INFO): BOOLEAN
			-- Remove an installed library
		local
			l_cmd: STRING
		do
			last_error := Void

			if not is_installed (a_lib) then
				Result := True -- Already not installed
			else
				-- Remove directory (Windows)
				l_cmd := "cmd /c rmdir /s /q %"" + install_path (a_lib) + "%""
				process.execute (l_cmd)
				Result := not is_installed (a_lib)

				if not Result then
					last_error := "Failed to remove directory"
				end
			end
		end

	install_all: BOOLEAN
			-- Install all libraries in correct dependency order
		local
			l_installed: ARRAYED_LIST [STRING]
			l_remaining: ARRAYED_LIST [SST_LIBRARY_INFO]
			l_progress: BOOLEAN
			l_lib: SST_LIBRARY_INFO
		do
			create l_installed.make (50)
			create l_remaining.make (50)
			l_remaining.append (manifest.libraries)
			Result := True

			from
				l_progress := True
			until
				l_remaining.is_empty or not l_progress
			loop
				l_progress := False

				from l_remaining.start until l_remaining.after loop
					l_lib := l_remaining.item

					if dependencies_satisfied (l_lib, l_installed) then
						if install (l_lib) then
							l_installed.extend (l_lib.name)
							l_remaining.remove
							l_progress := True
						else
							Result := False
							l_remaining.forth
						end
					else
						l_remaining.forth
					end
				end
			end

			if not l_remaining.is_empty then
				create {STRING} last_error.make_from_string ("Could not resolve dependencies for: ")
				if attached last_error as l_err then
					across l_remaining as l_cursor loop
						l_err.append (l_cursor.name + " ")
					end
				end
				Result := False
			end
		end

feature {NONE} -- Implementation

	process: SIMPLE_PROCESS
			-- Process executor

	default_install_dir: STRING = "D:\prod"
			-- Default installation directory

	dependencies_satisfied (a_lib: SST_LIBRARY_INFO; a_installed: LIST [STRING]): BOOLEAN
			-- Are all dependencies of a_lib in a_installed?
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > a_lib.dependencies.count loop
				if not a_installed.has (a_lib.dependencies [i]) then
					Result := False
				end
				i := i + 1
			end
		end

end
