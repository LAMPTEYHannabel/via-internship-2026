 
#!/usr/bin/env bash
#--------------------------------------------------------------------
#@title       Task1_file_handling.sh
#@author      LAMPTEY AKWLELEY HANNABEL
#@index       4191424
#@school      KWAME NKRUMAH UNIVERSITY OF SCIENCE AND TECHNOLOGY (KNUST)
#@description  Demonstrates file handling:directory creation,file creaction,appending content ,reading,backup creation,and safe deletion.
#@date         13-09-2026
#---------------------------------------------------------------------
usage() {
      echo "usage: $0 <target-directory>" >&2
      echo "<target-directory> : path to the directory to perform operations in." >&2
      exit 1
}

#check for help flags or missing arguments 
if [ "$1" ="-h" ]; then 
    usage 
fi
if [ -z "$1" ];then 
    usage 
fi
# set target  dirtcetory 
TARGET_DIR="$1"
FILE_PATH="${TARGET_DIR}/demo_file.txt"
BAK-PATH="${FILE_PATH}.bak"

#requirement 1: create directory if it does not exist
if  [ ! -d "$TARGET_DIR" ]; then
     mkdir -p  "$TARGET_DIR"
     echo "created directory : $ TARGET_DIR"
else
    echo "Directory already exists: $TARGET_DIR"
fi
 
