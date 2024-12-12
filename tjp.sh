#!/bin/sh

# Tool to add entries to journal on postgres on rimsky.
# Requires server to be up, ~/.pgpass to be in place.

# Database connection details
HOST="postgres.banded-neon.ts.net"
USER="postgresql"
DB="journal"
DB_CONTACTS="contacts"

# Add MOD contact
add_MOD_contact() {
	echo "Enter first name:"
	read mod_first_name
	echo "Enter last name:"
	read mod_last_name
    contact_id=$(psql -h "$HOST" -U "$USER" -d "$DB_CONTACTS" -c "INSERT INTO contacts (first_name, last_name, contact_type) VALUES ('$mod_first_name', '$mod_last_name', 3) RETURNING id;")
    echo "MOD contact added with ID: $contact_id. Feel free to go in and add comments, email and phone number separately."
}

# Function to add a personal entry
add_personal_entry() {
    echo "Enter your personal journal entry:"
    read entry
    psql -h "$HOST" -U "$USER" -d "$DB" -c "INSERT INTO journal_entries (entry, type) VALUES ('$entry', 2);"
}

# Function to add a MOD entry
add_MOD_entry() {
    echo "Enter your MOD journal entry:"
    read entry
    psql -h "$HOST" -U "$USER" -d "$DB" -c "INSERT INTO journal_entries (entry, type) VALUES ('$entry', 1);"
}

# Function to select all personal entries
list_personal_entries() {
    psql -h "$HOST" -U "$USER" -d "$DB" -c "SELECT id, date_added, entry, comment FROM journal_entries WHERE type = 2;"
}

# Function to select all MOD entries
list_MOD_entries() {
    psql -h "$HOST" -U "$USER" -d "$DB" -c "\x" -c "SELECT * FROM journal_entries WHERE type = 1;"
}

# Function to list all MOD contacts
list_MOD_contacts() {
    psql -h "$HOST" -U "$USER" -d "$DB_CONTACTS" -c "SELECT id, first_name, last_name, email, phone, contact_comments FROM contacts WHERE contact_type = 3;"
}

# Function to list all MOD meetings
list_MOD_meetings() {
    psql -h "$HOST" -U "$USER" -d "$DB" -c "SELECT id, name, date, subject FROM meetings;"
}

# Function to add a new meeting
add_meeting() {
    echo "Enter meeting name:"
    read meeting_name
	echo "Enter date (ISO):"
	read meeting_date
	echo "Enter meeting subject:"
	read meeting_subject
    meeting_id=$(psql -h "$HOST" -U "$USER" -d "$DB" -t -c "INSERT INTO meetings (name, date, subject) VALUES ('$meeting_name', '$meeting_date', '$meeting_subject') RETURNING id;")
    echo "Meeting added with ID: $meeting_id"
}

# Function to add a journal entry for an existing meeting
add_entry_to_meeting() {
    meeting_id=$1
    echo "Enter your journal entry for meeting ID $meeting_id:"
    read entry
    psql -h "$HOST" -U "$USER" -d "$DB" -c "INSERT INTO journal_entries (entry, meeting_id) VALUES ('$entry', $meeting_id);"
}

# Main script logic
case "$1" in
    -p)
        add_personal_entry
        ;;
    -m)
        add_MOD_entry
        ;;
	-C)
		add_MOD_contact
		;;
    -Y) list_MOD_contacts
        ;;
    -l)
        list_personal_entries
        ;;
    -M)
        list_MOD_entries
        ;;
    -F)
        list_MOD_meetings
        ;;
    -e)
        add_meeting
        ;;
    -E)
        if [ -n "$2" ]; then
            add_entry_to_meeting "$2"
        else
            echo "Error: Meeting ID required."
        fi
        ;;
    *)
        echo "Usage:"
        echo "  tjp -p - Add personal entry"
        echo "  tjp -m - Add MOD entry"
        echo "  tjp -C - Add MOD contact"
        echo "  tjp -Y - Select all MOD contacts"
        echo "  tjp -l - Select all personal entries"
        echo "  tjp -M - Select all MOD entries"
        echo "  tjp -F - Select all MOD meetings"
        echo "  tjp -e - Add new meeting (returns meeting ID)"
        echo "  tjp -E ID - Add new journal entry for meeting whose ID is ID"
        ;;
esac

