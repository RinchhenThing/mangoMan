#!/bin/bash

#Ask the user append/write

file_path=/home/yat0/my_stuff/mangoMan/secrets_and_variables/commands.txt
echo -e "\n"
read -p "Do you want to write (w) or append (a) the commands?" choice
echo "Please enter the commands."
echo "After you're Done press CTRL + D"
echo "----------------------------------"

#read multiple lines from the use input until ctrl + d
user_input=$(</dev/stdin)

#append or overwrite based on choice"
if [[ "$choice" == "a" || "$choice" == "A" ]]; then
	echo "$user_input" >> "$file_path" 
	echo "Content appended to $file_path"
elif [[ "$choice" == "w" || "$choice" == "W" ]]; then
	echo "$user_input" > "$file_path"
	echo "File $file_path overwritten with new content"
else
	echo "Invalid choice. Please enter 'a' or 'w'."
fi 


