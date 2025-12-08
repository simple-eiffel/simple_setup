note
	description: "[
		Generates Inno Setup scripts for creating Windows installers.
		Uses SIMPLE_TEMPLATE for script generation.
		Can also compile the script using iscc.exe if available.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_INNO_GENERATOR

create
	make

feature {NONE} -- Initialization

	make (a_manifest: SST_MANIFEST)
			-- Create generator with manifest
		do
			manifest := a_manifest
			create process.make
			install_directory := default_install_dir
			detect_inno_setup
		end

feature -- Access

	manifest: SST_MANIFEST
			-- Library manifest

	install_directory: STRING
			-- Target installation directory

	inno_compiler_path: detachable STRING
			-- Path to iscc.exe (Inno Setup compiler)

	last_error: detachable STRING
			-- Last error message

feature -- Status

	is_inno_available: BOOLEAN
			-- Is Inno Setup compiler available?
		do
			Result := attached inno_compiler_path
		end

feature -- Configuration

	set_install_directory (a_path: STRING)
			-- Set target installation directory for generated installer
		do
			install_directory := a_path
		end

feature -- Generation

	generate (a_version, a_output: STRING)
			-- Generate Inno Setup script
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING
		do
			l_content := generate_script_content (a_version)

			create l_file.make_create_read_write (a_output)
			l_file.put_string (l_content)
			l_file.close
		end

	generate_script_content (a_version: STRING): STRING
			-- Generate full Inno Setup script content
		do
			create Result.make (10000)

			Result.append (generate_header (a_version))
			Result.append (generate_languages)
			Result.append (generate_tasks)
			Result.append (generate_files)
			Result.append (generate_icons)
			Result.append (generate_registry)
			Result.append (generate_run)
			Result.append (generate_code)
		end

	compile_installer (a_script: STRING): BOOLEAN
			-- Compile Inno Setup script to create installer
		local
			l_cmd: STRING
		do
			last_error := Void

			if attached inno_compiler_path as l_iscc then
				l_cmd := "%"" + l_iscc + "%" %"" + a_script + "%""
				process.execute (l_cmd)
				Result := process.was_successful

				if not Result then
					if attached process.last_error as l_err then
						last_error := l_err.to_string_8
					else
						last_error := "Inno Setup compilation failed"
					end
				end
			else
				last_error := "Inno Setup compiler not found"
				Result := False
			end
		end

feature {NONE} -- Script Generation

	generate_header (a_version: STRING): STRING
			-- Generate [Setup] section using SIMPLE_TEMPLATE
		local
			l_template: SIMPLE_TEMPLATE
		do
			create l_template.make_from_string (header_template)
			l_template.set_variable ("version", a_version)
			l_template.set_variable ("install_dir", install_directory)
			Result := l_template.render
		end

	generate_languages: STRING
			-- Generate [Languages] section
		do
			Result := "[Languages]%N"
			Result.append ("Name: %"english%"; MessagesFile: %"compiler:Default.isl%"%N")
			Result.append ("%N")
		end

	generate_tasks: STRING
			-- Generate [Tasks] section
		do
			Result := "[Tasks]%N"
			Result.append ("Name: %"envpath%"; Description: %"Set environment variables%"; GroupDescription: %"Configuration:%"%N")
			Result.append ("%N")
		end

	generate_files: STRING
			-- Generate [Files] section with all libraries
		do
			create Result.make (2000)
			Result.append ("[Files]%N")
			Result.append ("; Source files are expected in a 'source' subdirectory%N")

			across manifest.libraries as l_cursor loop
				Result.append ("Source: %"source\" + l_cursor.name + "\*%"; ")
				Result.append ("DestDir: %"{app}\" + l_cursor.name + "%"; ")
				Result.append ("Flags: ignoreversion recursesubdirs createallsubdirs%N")
			end

			Result.append ("%N")
		end

	generate_icons: STRING
			-- Generate [Icons] section
		do
			Result := "[Icons]%N"
			Result.append ("Name: %"{group}\Simple Ecosystem Documentation%"; Filename: %"{app}\README.md%"%N")
			Result.append ("Name: %"{group}\{cm:UninstallProgram,Simple Ecosystem}%"; Filename: %"{uninstallexe}%"%N")
			Result.append ("%N")
		end

	generate_registry: STRING
			-- Generate [Registry] section for environment variables
		do
			Result := "[Registry]%N"
			Result.append ("; Environment variables are set via [Code] section for user-level%N")
			Result.append ("%N")
		end

	generate_run: STRING
			-- Generate [Run] section
		do
			Result := "[Run]%N"
			Result.append ("; Post-installation actions%N")
			Result.append ("%N")
		end

	generate_code: STRING
			-- Generate [Code] section with Pascal script for env vars
		do
			create Result.make (5000)

			Result.append ("[Code]%N")
			Result.append ("procedure SetEnvVar(Name, Value: string);%N")
			Result.append ("begin%N")
			Result.append ("  RegWriteStringValue(HKEY_CURRENT_USER, 'Environment', Name, Value);%N")
			Result.append ("end;%N")
			Result.append ("%N")

			Result.append ("procedure RemoveEnvVar(Name: string);%N")
			Result.append ("begin%N")
			Result.append ("  RegDeleteValue(HKEY_CURRENT_USER, 'Environment', Name);%N")
			Result.append ("end;%N")
			Result.append ("%N")

			Result.append ("procedure CurStepChanged(CurStep: TSetupStep);%N")
			Result.append ("begin%N")
			Result.append ("  if CurStep = ssPostInstall then%N")
			Result.append ("  begin%N")
			Result.append ("    if IsTaskSelected('envpath') then%N")
			Result.append ("    begin%N")

			-- Generate SetEnvVar calls for each library
			across manifest.libraries as l_cursor loop
				Result.append ("      SetEnvVar('" + l_cursor.env_var_name + "', ExpandConstant('{app}\" + l_cursor.name + "'));%N")
			end

			Result.append ("    end;%N")
			Result.append ("  end;%N")
			Result.append ("end;%N")
			Result.append ("%N")

			Result.append ("procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);%N")
			Result.append ("begin%N")
			Result.append ("  if CurUninstallStep = usPostUninstall then%N")
			Result.append ("  begin%N")

			-- Generate RemoveEnvVar calls for each library
			across manifest.libraries as l_cursor loop
				Result.append ("    RemoveEnvVar('" + l_cursor.env_var_name + "');%N")
			end

			Result.append ("  end;%N")
			Result.append ("end;%N")
		end

feature {NONE} -- Templates

	header_template: STRING = "[
; Simple Ecosystem Installer
; Generated by simple_setup

[Setup]
AppId={{F8A3B2C1-4D5E-6F7A-8B9C-0D1E2F3A4B5C}
AppName=Simple Ecosystem
AppVersion={{version}}
AppVerName=Simple Ecosystem {{version}}
AppPublisher=Larry Rix
AppPublisherURL=https://github.com/ljr1981
AppSupportURL=https://github.com/ljr1981
AppUpdatesURL=https://github.com/ljr1981
DefaultDirName={{install_dir}}
DefaultGroupName=Simple Ecosystem
AllowNoIcons=yes
OutputDir=output
OutputBaseFilename=simple_ecosystem_{{version}}_setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest

]"

feature {NONE} -- Implementation

	process: SIMPLE_PROCESS
			-- Process executor

	default_install_dir: STRING = "D:\prod"
			-- Default installation directory

	detect_inno_setup
			-- Detect Inno Setup compiler location
		local
			l_file: RAW_FILE
			l_candidates: ARRAYED_LIST [STRING]
		do
			create l_candidates.make (5)
			l_candidates.extend ("C:\Program Files (x86)\Inno Setup 6\ISCC.exe")
			l_candidates.extend ("C:\Program Files\Inno Setup 6\ISCC.exe")
			l_candidates.extend ("C:\Program Files (x86)\Inno Setup 5\ISCC.exe")
			l_candidates.extend ("C:\Program Files\Inno Setup 5\ISCC.exe")

			-- Also check local bin folder
			l_candidates.extend ("bin\ISCC.exe")

			across l_candidates as l_cursor loop
				if inno_compiler_path = Void then
					create l_file.make_with_name (l_cursor)
					if l_file.exists then
						inno_compiler_path := l_cursor
					end
				end
			end
		end

end
