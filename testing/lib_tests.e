note
	description: "Tests for SIMPLE_SETUP"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Manifest

	test_manifest_make
			-- Test manifest creation.
		note
			testing: "covers/{SST_MANIFEST}.make"
		local
			manifest: SST_MANIFEST
		do
			create manifest.make
			assert_attached ("manifest created", manifest)
			assert_true ("has libraries", manifest.libraries.count > 0)
		end

feature -- Test: Library Info

	test_library_info_make
			-- Test library info creation.
		note
			testing: "covers/{SST_LIBRARY_INFO}.make"
		local
			info: SST_LIBRARY_INFO
		do
			create info.make ("simple_json", "JSON library", "data", "simple-eiffel/simple_json")
			assert_strings_equal ("name", "simple_json", info.name)
		end

feature -- Test: Environment Manager

	test_env_manager_make
			-- Test environment manager creation.
		note
			testing: "covers/{SST_ENV_MANAGER}.make"
		local
			manager: SST_ENV_MANAGER
		do
			create manager.make
			assert_attached ("manager created", manager)
		end

feature -- Test: Installer

	test_installer_make
			-- Test installer creation.
		note
			testing: "covers/{SST_INSTALLER}.make"
		local
			manifest: SST_MANIFEST
			installer: SST_INSTALLER
		do
			create manifest.make
			create installer.make (manifest)
			assert_attached ("installer created", installer)
		end

end
