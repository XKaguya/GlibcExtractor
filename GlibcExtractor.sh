#!/bin/bash

deb_file1="$1"
deb_file2="$2"

temp_dbg="temp/dbg"
temp_libc="temp/libc"

mkdir -p "$temp_dbg"
mkdir -p "$temp_libc"
mkdir -p "result"

if [[ "$deb_file2" == *"dbg"* ]]; then
    dpkg-deb -x "$deb_file2" "$temp_dbg"
    dpkg-deb -x "$deb_file1" "$temp_libc"
else
    dpkg-deb -x "$deb_file1" "$temp_dbg"
    dpkg-deb -x "$deb_file2" "$temp_libc"
fi

ld_pattern="^ld-[0-9]+\.[0-9]+\.so$"
libc_pattern="^libc-[0-9]+\.[0-9]+\.so$"

process_files() {
    local dir=$1
    
    find "$dir" -type f | while read -r file; do
        filename=$(basename "$file")
        
        if [[ "$filename" =~ $ld_pattern ]] || [[ "$filename" =~ $libc_pattern ]]; then
            version_number=$(echo "$filename" | grep -oE "[0-9]+\.[0-9]+")
            
            echo "File found: $filename, Version: $version_number"
            
            if [[ $(echo "$version_number >= 2.35" | bc -l) -eq 1 ]]; then
                echo "This tool is not support for glibc 2.35 and higher."
                exit 0
            fi
            
            dbg_file=$(find "$temp_dbg" -name "$filename" | head -n 1)
            libc_file=$(find "$temp_libc" -name "$filename" | head -n 1)
            
            if [[ -f "$dbg_file" && -f "$libc_file" ]]; then
                echo "Running eu-unstrip: $libc_file -> $dbg_file"
                eu-unstrip "$libc_file" "$dbg_file"
                
                result_dir="result/$version_number"
                mkdir -p "$result_dir"
                
                mv "$libc_file" "$result_dir/"
                mv "$dbg_file" "$result_dir/"
            else
                echo "File not found. $dbg_file or $libc_file"
            fi
        fi

    done
}

process_files "$temp_dbg"
process_files "$temp_libc"
rm -rf temp

