#!/usr/bin/env python3

import paramiko #paramiko handles SSH connections and command executions
import argparse #argparse parses the command-line arguments
import sys #sys is used for printing to stdout/stderr and exiting with a status code 

#this is the main function to connect to a host 
def ssh_run_command(host, username, key_path, command, port=22):
    client = paramiko.SSHClient() #creates a new ssh client instance 
    clien.set_missing_host_key_policy(paramiko.AutoAddPolicy()) #this line tells paramiko to automatically trust unkown host keys
    pkey = paramiko.RSAKey.from_private_key_file(key_path) #this loads the private key from the key from_private_key_file
    client.connect(hostname=host, port=port, username=username, pkey=pkey) #connects to the server

    stdin, stdout, stderr = client.exec_command(command) #executes the three file-like objects stdin, stdout, stderr

    #To print the command's output and errors live
    for line in stdout:
    sys.stdout.write(line)
for line in stderr:
    sys.stderr.write(line)

    exit_code = stdout.channel.recv_exit_status() #waits for remote command to complete and get its exit status code
    client.close()
    return exit_code

#for parsing argument in the cli
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run a single command on a remote SSH host.")
    parser.add_argument("--host", required=True)
    parser.add_argument("--username", required=True)
    parser.add_argument("--key", required=True)
    parser.add_argument("--cmd", required=True)
    args = parser.parse_args()

    rc = ssh_run_command(args.host, args.username, args.key, args.cmd)
    sys.exit(rc)


