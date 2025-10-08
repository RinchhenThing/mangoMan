#!/bin/bash

echo -e "\n"
# Ask for IP
read -p "Enter the host IP: " IP

# Ask for username
read -p "Enter the user name: " user

# Write to file with newline properly
echo -e "host=$IP\nuser=$user" > /home/yat0/my_stuff/mangoMan/secrets_and_variables/credentials.txt
