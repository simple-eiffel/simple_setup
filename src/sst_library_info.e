note
	description: "Information about a simple_* library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SST_LIBRARY_INFO

create
	make

feature {NONE} -- Initialization

	make (a_name, a_description, a_layer, a_github: STRING)
			-- Create library info
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			description := a_description
			layer := a_layer
			github_url := a_github
			create dependencies.make (5)
			create tags.make (5)
		ensure
			name_set: name = a_name
		end

feature -- Access

	name: STRING
			-- Library name (e.g., "simple_json")

	description: STRING
			-- Brief description

	layer: STRING
			-- Layer: foundation, service, platform, api

	github_url: STRING
			-- GitHub repository URL

	dependencies: ARRAYED_LIST [STRING]
			-- Required libraries

	tags: ARRAYED_LIST [STRING]
			-- Tags for categorization

feature -- Derived

	env_var_name: STRING
			-- Environment variable name (e.g., SIMPLE_JSON)
		do
			Result := name.as_upper
		end

	ecf_name: STRING
			-- ECF filename (e.g., simple_json.ecf)
		do
			Result := name + ".ecf"
		end

feature -- Modification

	add_dependency (a_dep: STRING)
			-- Add a dependency
		do
			dependencies.extend (a_dep)
		end

	add_tag (a_tag: STRING)
			-- Add a tag
		do
			tags.extend (a_tag)
		end

end
