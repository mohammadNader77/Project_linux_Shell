# Function to generate manuals for commands
generate_manual_for_commands() {
    command_name="$1"
    file="${command_name}_manual.txt" #to store manual for command in file

    # get description for manual
    description=$(man "$command_name" | awk '/^DESCRIPTION$/,/^OPTIONS$/' | grep -v '^OPTIONS$' | head -n 10)

    # get example for manual
	if [ $command_name == "echo" ]
	 then
 	     example=$(get_example_for_commands  "$command_name")
        elif [ $command_name == "ps" ]
         then
             example=$(get_example_for_commands  "$command_name")
        elif [ $command_name == "cat" ]
         then
             example=$(get_example_for_commands  "$command_name")

        else
             example=$($command_name --help | head -n 1)

        fi

    #get version for command
    version=$(uname --version | head -n 1)

    #related command
    related_commands=$(compgen -c | grep ${command_name})
#create manuals for the commands     
manuals_For_Commands="Manuals For > ${command_name}
---------------------------------------
Description: ${description}
---------------------------------------
Version:  ${version}
---------------------------------------
Example:  ${example}
---------------------------------------
Related Commands: 
${related_commands}
---------------------------------------
"
#write the manuals in file
echo -e "${manuals_For_Commands}" > "$file"




}
#function to get example for spictal commands
get_example_for_commands () {
	case $1
	 in 

    	"echo") echo "$1 'hello world'";; #example for "echo"
	"ps") echo "$1 -e";; #example for "ps"
	"cat") echo "$1 filename";;  #example for "cat"
	esac
}

# Function to display list of manuals avariable
display_all_manuals() {
    n=1 #number of manuals
    for manual in *_manual.txt
	 do
            echo "$n- $manual"
            n=$((n+1))  #increas number of manual by one
         done
}
# Function to verify old_manual vs new_manual
verify() {
    command_name="$1"

    old_man="${command_name}_old_manual.txt"
    new_man="${command_name}_manual.txt"


    # diff to find the differences between nanuals
    differences=$(diff "$old_man" "$new_man")
	if [ "$differences" ] #if differences exist print section of differences
	 then
   	   	echo "$differences"
	else
		echo "No differences between manuals"
	fi
}
#function to display contents on manuals for commands
display_content_of_manual() {

    command_name="$1"
    file="${command_name}_manual.txt"

    echo "**********************************************"

    if [ -f "$file" ] #to check if the file exist
      then
        cat "$file" #print file content
    else
        echo "Manual file does not exist for: $command_name"
    fi

    echo "**********************************************"
}
# Function to generate command manual(old)
generate_old_command_manual() {
    command="$1"
    old_file="${command}_old_manual.txt"

    # copy the content of file to new file(e.g ls_old_manual.txt)
    cp "${command}_manual.txt" "$old_file"

    # print message to stating the operation was successfully
    echo "generated manual for: $command"
}
#function to print the suggestion commands for the command use
suggestion_commands() {

        command_name=$1
	#print 5 suggestion commands
	suggestion_commands=$(compgen -c | grep ${command_name} | head -n 5)
	echo "$suggestion_commands are :"
}


action=$1
command_name=$2

case $action 
in 
   generate)

    command_number="$3" #to evaluate number of command 
	#list of commands to generete its manual
        for list_command in "ps" "ls" "echo" "cat" "pico" "find" "kill" "nano" "sed" "cp" "pwd" "rm" "grep" "tr" "mv" "mkdir"
	 do
    	    generate_manual_for_commands "$list_command"
            command_number=$((command_number+1))

         done

	echo "the generate is successful for $command_number: command"
	echo "-------------------------------"
	echo " Available command manuals are:"
        display_all_manuals "$command_name"


;;
generate_old)

        generate_old_command_manual "$command_name" ;;
search)

      	display_content_of_manual "$command_name" 
;;
suggestion)
	suggestion_commands "$command_name"
;;
verify)
	old_command=$3
	new_command=$4

        verify "$old_command" "$new_command"
;;
*) echo "Invalid Option";;
esac
