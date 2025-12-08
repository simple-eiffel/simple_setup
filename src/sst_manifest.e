note
	description: "[
		Manifest of all simple_* libraries.
		Contains metadata about each library including dependencies, layer, and GitHub URL.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_MANIFEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize manifest with all libraries
		do
			create libraries.make (50)
			create library_index.make (50)
			load_libraries
		end

feature -- Access

	libraries: ARRAYED_LIST [SST_LIBRARY_INFO]
			-- All libraries in the ecosystem

	library_index: HASH_TABLE [SST_LIBRARY_INFO, STRING]
			-- Libraries indexed by name

	library_by_name (a_name: STRING): detachable SST_LIBRARY_INFO
			-- Find library by name
		do
			Result := library_index.item (a_name)
		end

	libraries_by_layer (a_layer: STRING): ARRAYED_LIST [SST_LIBRARY_INFO]
			-- Get all libraries in a layer
		do
			create Result.make (10)
			across libraries as l_cursor loop
				if l_cursor.layer.same_string (a_layer) then
					Result.extend (l_cursor)
				end
			end
		end

feature -- Constants

	default_install_dir: STRING = "D:\prod"
			-- Default installation directory

	github_org: STRING = "simple-eiffel"
			-- GitHub organization

feature {NONE} -- Implementation

	load_libraries
			-- Load all library definitions
		local
			l_empty: ARRAY [STRING]
		do
			l_empty := {ARRAY [STRING]} <<>>

			-- Foundation Layer (no external dependencies)
			add_library ("simple_base64", "Base64 encoding and decoding", "foundation", l_empty)
			add_library ("simple_hash", "SHA256, SHA1, MD5, HMAC hashing", "foundation", l_empty)
			add_library ("simple_uuid", "UUID/GUID generation", "foundation", l_empty)
			add_library ("simple_randomizer", "Random data generation", "foundation", l_empty)
			add_library ("simple_json", "JSON parsing and building", "foundation", l_empty)
			add_library ("simple_xml", "XML parsing and building", "foundation", l_empty)
			add_library ("simple_csv", "CSV parsing and generation", "foundation", l_empty)
			add_library ("simple_markdown", "Markdown to HTML conversion", "foundation", l_empty)
			add_library ("simple_datetime", "Date/time utilities and formatting", "foundation", l_empty)
			add_library ("simple_validation", "Fluent validation rules", "foundation", l_empty)
			add_library ("simple_regex", "Regular expression matching", "foundation", l_empty)
			add_library ("simple_process", "Shell command execution", "foundation", l_empty)
			add_library ("simple_logger", "Structured JSON logging", "foundation", <<"simple_json">>)
			add_library ("simple_htmx", "HTMX HTML components", "foundation", l_empty)

			-- Platform Layer (Windows-specific)
			add_library ("simple_env", "Environment variable access", "platform", l_empty)
			add_library ("simple_system", "System information utilities", "platform", l_empty)
			add_library ("simple_console", "Console output with colors", "platform", l_empty)
			add_library ("simple_clipboard", "Clipboard operations", "platform", l_empty)
			add_library ("simple_registry", "Windows registry access", "platform", l_empty)
			add_library ("simple_mmap", "Memory-mapped files", "platform", l_empty)
			add_library ("simple_ipc", "Inter-process communication", "platform", l_empty)
			add_library ("simple_watcher", "File system watching", "platform", l_empty)
			add_library ("simple_win32_api", "Windows API wrappers", "platform", l_empty)

			-- Service Layer (depends on foundation)
			add_library ("simple_cache", "In-memory caching", "service", <<"simple_json">>)
			add_library ("simple_template", "Template rendering engine", "service", l_empty)
			add_library ("simple_jwt", "JSON Web Token handling", "service", <<"simple_json", "simple_base64", "simple_hash">>)
			add_library ("simple_cors", "CORS header handling", "service", l_empty)
			add_library ("simple_rate_limiter", "API rate limiting", "service", l_empty)
			add_library ("simple_smtp", "Email sending", "service", l_empty)
			add_library ("simple_sql", "SQLite database operations", "service", l_empty)
			add_library ("simple_websocket", "WebSocket connections", "service", l_empty)
			add_library ("simple_http", "HTTP client requests", "service", l_empty)
			add_library ("simple_encryption", "AES/RSA encryption", "service", <<"simple_base64">>)
			add_library ("simple_config", "Configuration file handling", "service", <<"simple_json">>)
			add_library ("simple_pdf", "PDF generation", "service", <<"simple_process">>)

			-- API Facades (aggregate layers)
			add_library ("simple_testing", "Testing framework", "api", l_empty)
			add_library ("simple_foundation_api", "Foundation layer facade", "api",
				<<"simple_base64", "simple_hash", "simple_uuid", "simple_json", "simple_xml",
				  "simple_csv", "simple_markdown", "simple_datetime", "simple_validation",
				  "simple_regex", "simple_process", "simple_logger", "simple_htmx", "simple_randomizer">>)
			add_library ("simple_service_api", "Service layer facade", "api",
				<<"simple_foundation_api", "simple_cache", "simple_template", "simple_jwt",
				  "simple_cors", "simple_rate_limiter", "simple_smtp", "simple_sql",
				  "simple_websocket", "simple_http", "simple_pdf">>)
			add_library ("simple_web", "EWF web server wrapper", "api", <<"simple_service_api">>)
			add_library ("simple_app_api", "Full application facade", "api", <<"simple_service_api", "simple_web">>)
			add_library ("simple_alpine", "Alpine.js integration", "api", <<"simple_htmx">>)
			add_library ("simple_ai_client", "AI API client", "api", <<"simple_http", "simple_json">>)
			add_library ("simple_gui_designer", "GUI designer utilities", "api", l_empty)
		end

	add_library (a_name, a_desc, a_layer: STRING; a_deps: ARRAY [STRING])
			-- Add a library to the manifest
		local
			l_lib: SST_LIBRARY_INFO
			l_github: STRING
			i: INTEGER
		do
			l_github := "https://github.com/" + github_org + "/" + a_name
			create l_lib.make (a_name, a_desc, a_layer, l_github)

			from i := a_deps.lower until i > a_deps.upper loop
				l_lib.add_dependency (a_deps [i])
				i := i + 1
			end

			libraries.extend (l_lib)
			library_index.force (l_lib, a_name)
		end

end
