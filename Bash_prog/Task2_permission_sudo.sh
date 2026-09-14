#!/usr/bin/env bash
# @title  Task2_permissions_sudo.sh
# @author LAMPTEY AKWEEEY HANNABEL
# @index  4191424
# @school KWAME NKRUMAH UNIVERSITY OF SCIENCE AND TECHNOLOGY (KNUST)
# description Demonstrates file permissions,chmod numeric/symbolic , and root check with chwon
# @date  14-09-2026

usage() {
    echo "Usage: $0 <target-file-path>" &2
    exit 1
}
if [ "$1" = "-h" ]; then 
    usage 
fi
if [ -z "$1" ]; then 
     usage
fi
TARGET_FILE="$1"

if [  ! -f "$TARGET_FILE" ]; then 
     echo "Error :File'$TARGET_FILE' does not exist. " &2
     exit 1
fi


#function to report file permissions in symblic and numeric form 
report_permission() {
    echo "-----File  Permissions Report-----"
    echo "File: $TARGET_FILE"
    echo -n "symbolic: "
    stat -c "%A" "$TARGET_FILE"
    echo -n "numeric: "
    stat -c "%a" "$TARGET_FILE"
    echo "---------------------------------"
}

#1. report initial permissions 
echo "Initial File Status"
report_permission
#2. chnage permissions using numneric syntax 
echo "Changing permissions to 644 (numeric)..."
chmod 644 "$TARGET_FILE"

#Change permissions using symbolic syntax 
echo "ADding execute permissions for owner (u+x symbolic)..."
chmod u+x "$TARGET_FILE"

# CHECK FOR ROOT PRIVILEDGES AND ATTEMPT CHOWN SAFELY
if [ "$(id -u)" -eq 0 ]; then
    echo "Runnig as root. Attempting chown..."
   chown root "$TARGET_FILE"
   echo "chown completed successfully"
else 
   echo  "Skipping chwon: Root priviledges required (run with the sudo to execute chown)."
fi 
 #4. report final permission 
  echo "Final File Status"
report_permission 
