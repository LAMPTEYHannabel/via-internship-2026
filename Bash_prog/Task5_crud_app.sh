#!/bin/bash

# ==============================================================================
# Script Name : Task5_crud_app.sh
# Author      : LAMPTEY AKWELEY HANNABEL
# Date        : September 2026
# Description : Menu-driven Phonebook CRUD console application using CSV storage.
# ==============================================================================

DATA_FILE="phonebook.csv"

# Initialize data file if it does not exist
if [[ ! -f "$DATA_FILE" ]]; then
    touch "$DATA_FILE"
fi

# ------------------------------------------------------------------------------
# Help Function
# ------------------------------------------------------------------------------
show_help() {
    echo "Usage: $0 [-h|--help]"
    echo ""
    echo "Description:"
    echo "  A terminal-based Phonebook CRUD application storing records in phonebook.csv."
    echo "  Supports adding, listing, searching, updating, and deleting contact records."
    echo ""
    echo "Options:"
    echo "  -h, --help    Display this usage guide and exit."
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# ------------------------------------------------------------------------------
# Backup Helper Function
# ------------------------------------------------------------------------------
backup_data() {
    cp "$DATA_FILE" "${DATA_FILE}.bak"
}

# ------------------------------------------------------------------------------
# CRUD Functions
# ------------------------------------------------------------------------------

# 1. Create (Add Record)
create_record() {
    echo ""
    echo "--- Add New Contact ---"
    
    # Auto-generate ID
    if [[ ! -s "$DATA_FILE" ]]; then
        id=1
    else
        last_id=$(awk -F',' 'END {print $1}' "$DATA_FILE")
        id=$((last_id + 1))
    fi

    read -p "Enter Name: " name
    if [[ -z "$name" ]]; then
        echo "Error: Name cannot be empty."
        return
    fi

    read -p "Enter Phone Number: " phone
    if [[ -z "$phone" ]]; then
        echo "Error: Phone number cannot be empty."
        return
    fi

    read -p "Enter Email: " email
    if [[ -z "$email" ]]; then
        echo "Error: Email cannot be empty."
        return
    fi

    echo "${id},${name},${phone},${email}" >> "$DATA_FILE"
    echo "Contact added successfully! (Assigned ID: $id)"
}

# 2. Read / View All Records
read_records() {
    echo ""
    echo "--- Phonebook Contacts ---"
    if [[ ! -s "$DATA_FILE" ]]; then
        echo "No records found in phonebook."
        return
    fi

    printf "%-5s | %-20s | %-15s | %-25s\n" "ID" "Name" "Phone" "Email"
    echo "-------------------------------------------------------------------"
    while IFS=',' read -r id name phone email; do
        printf "%-5s | %-20s | %-15s | %-25s\n" "$id" "$name" "$phone" "$email"
    done < "$DATA_FILE"
}

# 3. Search Record
search_record() {
    echo ""
    echo "--- Search Contact ---"
    read -p "Enter Name, Phone, or Email to search: " query
    if [[ -z "$query" ]]; then
        echo "Error: Search query cannot be empty."
        return
    fi

    results=$(grep -i "$query" "$DATA_FILE")
    if [[ -n "$results" ]]; then
        printf "%-5s | %-20s | %-15s | %-25s\n" "ID" "Name" "Phone" "Email"
        echo "-------------------------------------------------------------------"
        echo "$results" | while IFS=',' read -r id name phone email; do
            printf "%-5s | %-20s | %-15s | %-25s\n" "$id" "$name" "$phone" "$email"
        done
    else
        echo "Record not found gracefully: No contacts matching '$query'."
    fi
}

# 4. Update Record
update_record() {
    echo ""
    echo "--- Update Contact ---"
    read -p "Enter ID of contact to update: " target_id
    if [[ -z "$target_id" ]]; then
        echo "Error: ID cannot be empty."
        return
    fi

    record=$(grep "^${target_id}," "$DATA_FILE")
    if [[ -z "$record" ]]; then
        echo "Record not found gracefully: No contact with ID '$target_id'."
        return
    fi

    echo "Current record: $record"
    read -p "Enter New Name: " new_name
    read -p "Enter New Phone: " new_phone
    read -p "Enter New Email: " new_email

    if [[ -z "$new_name" || -z "$new_phone" || -z "$new_email" ]]; then
        echo "Error: Fields cannot be left empty."
        return
    fi

    backup_data
    sed -i "/^${target_id},/c\\${target_id},${new_name},${new_phone},${new_email}" "$DATA_FILE"
    echo "Contact updated successfully! (Backup created at ${DATA_FILE}.bak)"
}

# 5. Delete Record
delete_record() {
    echo ""
    echo "--- Delete Contact ---"
    read -p "Enter ID of contact to delete: " target_id
    if [[ -z "$target_id" ]]; then
        echo "Error: ID cannot be empty."
        return
    fi

    record=$(grep "^${target_id}," "$DATA_FILE")
    if [[ -z "$record" ]]; then
        echo "Record not found gracefully: No contact with ID '$target_id'."
        return
    fi

    echo "Found record: $record"
    read -p "Are you sure you want to delete this contact? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Deletion canceled."
        return
    fi

    backup_data
    sed -i "/^${target_id},/d" "$DATA_FILE"
    echo "Contact deleted successfully! (Backup created at ${DATA_FILE}.bak)"
}

# ------------------------------------------------------------------------------
# Main Menu Loop
# ------------------------------------------------------------------------------
while true; do
    echo ""
    echo "==================================="
    echo "     PHONEBOOK CRUD APP (TASK 5)   "
    echo "==================================="
    echo "1. Add Contact (Create)"
    echo "2. View All Contacts (Read)"
    echo "3. Search Contact"
    echo "4. Update Contact"
    echo "5. Delete Contact"
    echo "6. Exit"
    echo "==================================="
    read -p "Select an option [1-6]: " choice

    case $choice in
        1) create_record ;;
        2) read_records ;;
        3) search_record ;;
        4) update_record ;;
        5) delete_record ;;
        6) 
            echo "Exiting application. Goodbye!"
            exit 0
            ;;
        *) 
            echo "Invalid option. Please enter a number between 1 and 6."
            ;;
    esac
done

