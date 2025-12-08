note
	description: "Test application for simple_setup"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_TEST_APP

inherit
	EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests
		do
			default_create
			test_manifest_loads
			test_library_info
			test_env_manager
			test_inno_generator
			print ("All tests passed!%N")
		end

feature -- Tests

	test_manifest_loads
			-- Test that manifest loads all libraries
		local
			l_manifest: SST_MANIFEST
		do
			create l_manifest.make
			assert ("has_libraries", l_manifest.libraries.count > 30)
			assert ("has_simple_json", attached l_manifest.library_by_name ("simple_json"))
			assert ("has_simple_process", attached l_manifest.library_by_name ("simple_process"))
			print ("test_manifest_loads: PASSED%N")
		end

	test_library_info
			-- Test library info creation
		local
			l_lib: SST_LIBRARY_INFO
		do
			create l_lib.make ("simple_test", "Test library", "foundation", "https://github.com/test/test")
			assert ("name_correct", l_lib.name.same_string ("simple_test"))
			assert ("env_var_correct", l_lib.env_var_name.same_string ("SIMPLE_TEST"))
			assert ("ecf_correct", l_lib.ecf_name.same_string ("simple_test.ecf"))
			print ("test_library_info: PASSED%N")
		end

	test_env_manager
			-- Test environment manager
		local
			l_env: SST_ENV_MANAGER
			l_value: detachable STRING_32
		do
			create l_env.make

			-- Test getting existing env var
			l_value := l_env.get ("PATH")
			assert ("path_exists", attached l_value)

			print ("test_env_manager: PASSED%N")
		end

	test_inno_generator
			-- Test Inno Setup script generation
		local
			l_manifest: SST_MANIFEST
			l_generator: SST_INNO_GENERATOR
			l_content: STRING
		do
			create l_manifest.make
			create l_generator.make (l_manifest)

			l_content := l_generator.generate_script_content ("1.0.0")

			assert ("has_setup_section", l_content.has_substring ("[Setup]"))
			assert ("has_files_section", l_content.has_substring ("[Files]"))
			assert ("has_code_section", l_content.has_substring ("[Code]"))
			assert ("has_version", l_content.has_substring ("1.0.0"))

			print ("test_inno_generator: PASSED%N")
		end

end
