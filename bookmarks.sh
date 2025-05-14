#!/bin/bash

USAGE="usage: m [-ar] <flag name>"
UNRECOGNIZED_FLAG="flag $1 is not recognized"
UNRECOGNIZED_ARG="argument $1 is not recognized"

PRINT_DEBUG=1

#ensure there is input provided
[[ -z "$1" ]] && echo "no arguments were provided" && echo $USAGE

change_current_path()
{
	local path="$1"
	echo "jumping to: $path"
	[[ -z "$1" ]] && path="/Users/jk"
	[[ -n "$2" ]] && echo "too many arguments provided" && return
	echo "jumping to: $path"
	cd $path
}

jump_to_bookmark()
{
	local file_name="/Users/jk/temp/bookmark_locations"
	local file_location="/Users/jk/temp"
	local bookmark_name="$1"
	#echo $bookmark_name
	#echo $file_name
	local line=$("/bin/cat" "$file_name" | "/usr/bin/grep" "| $bookmark_name$")
	#echo "line: $line"
	local retrieved_path=$(echo $line | awk '/ /{print $1}')
	echo "after awk: $retrieved_path"
	#echo $retrieved_path
	if [[ $retrieved_path == "" ]] && echo "no such tag found" && return

	change_current_path "$retrieved_path"
}

create_new_bookmark()
{
	local path="$(pwd)"
	local bookmark_name="$1"
	local file_name="/Users/jk/temp/bookmark_locations"
	local file_location="/Users/jk/temp"

	# check if location + file exist
	if [[ ! -e $file_name ]]; then
		echo "location file not found, initializing new"
		$(where "mkdir") -p "$file_location"
		$(where "touch") "$file_name"
	fi

	# check if bookmark already present - if so return
	if [[ PRINT_DEBUG -ne 0 ]]; then
		local thing=$("/bin/cat" "$file_name" | "/usr/bin/grep" "| $bookmark_name$")
		echo $thing
	fi
	if [[ $("/bin/cat" "$file_name" | "/usr/bin/grep" "| $bookmark_name$") != "" ]] && echo "tag already exists! exiting..." && return

	# else save tag to file
	if [[ PRINT_DEBUG -ne 0 ]]; then
		echo "saving this:"
		echo "$path | $bookmark_name"
		echo "into a file: $file_name"
	fi

	echo "$path | $bookmark_name" >> "$file_name"
}

case $1 in
	'-a') echo "create flag called" && create_new_bookmark "$2";;
	'-r') echo "remove flag called";;
	'-test') change_current_path "/Users/jk/";;
	'-test2') create_new_bookmark "$2";;
	'-test3') jump_to_bookmark "$2";;
	'-'*) echo "$UNRECOGNIZED_FLAG";;
	*)	  jump_to_bookmark "$1";;
esac


