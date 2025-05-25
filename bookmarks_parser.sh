#!/bin/bash

# Input HTML file
INPUT_FILE="bookmarks.html"
# Output text file
OUTPUT_FILE="urls.txt"

# Check if the input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Clear the output file if it exists, or create it
> "$OUTPUT_FILE"

echo "Extracting URLs, categories, and titles from '$INPUT_FILE'..."

# Use a here-document for the awk script to prevent shell interpretation issues.
awk -f - "$INPUT_FILE" >> "$OUTPUT_FILE" << 'AWK_SCRIPT_END'
BEGIN {
    folder_depth = 0
}

{
    # If a new folder (H3) is found
    if ($0 ~ /<DT><H3[^>]*>/) {
        match($0, /<H3[^>]*>(.*)<\/H3>/, arr)
        folder_depth++
        folder_stack[folder_depth] = arr[1]
    }
    # If a folder closing tag (</DL><p>) is found
    else if ($0 ~ /<\/DL><p>/) {
        if (folder_depth > 0) {
            folder_depth--
        }
    }
    # If a link (A HREF) is found
    # This regex is simplified to just identify a link line
    else if ($0 ~ /<DT><A HREF="[^"]*".*<\/A>/) {
        # --- Extract URL ---
        # Matches <A HREF=" and captures everything until the next "
        match($0, /<A HREF="([^"]*)"/, arr_url)
        url = arr_url[1]

        # --- Extract Title ---
        # Find the end of the line, which should be </A>
        # Find the *start* of the </A> closing tag
        end_tag_start_pos = index($0, "</A>")

        # If </A> is not found, or it's not a valid link, skip this line
        if (end_tag_start_pos == 0) {
            next # Skip to the next line
        }

        # Get the substring of the line *before* the </A> tag
        part_before_end_tag = substr($0, 1, end_tag_start_pos - 1)

        # Now, find the position of the *last* '>' in `part_before_end_tag`.
        # This '>' character is the end of the opening <A> tag (including all its attributes).
        last_gt_pos_in_opening_tag = 0
        for (i = 1; i <= length(part_before_end_tag); i++) {
            if (substr(part_before_end_tag, i, 1) == ">") {
                last_gt_pos_in_opening_tag = i
            }
        }

        # If no '>' was found before the </A> (shouldn't happen with valid HTML)
        if (last_gt_pos_in_opening_tag == 0) {
            next # Skip to the next line
        }

        # The title is the substring starting right after `last_gt_pos_in_opening_tag`
        # and going to the end of `part_before_end_tag`.
        title = substr(part_before_end_tag, last_gt_pos_in_opening_tag + 1)

        # Trim leading/trailing whitespace from the title
        title = trim(title)

        # --- Construct Category Path ---
        category_path = ""
        for (i = 1; i <= folder_depth; i++) {
            if (i > 1) {
                category_path = category_path "/"
            }
            category_path = category_path folder_stack[i]
        }

        # Print in the desired format: URL - CATEGORY - TITLE
        print url " - " category_path " - " title
    }
}

# Custom function to trim leading/trailing whitespace
function trim(s) {
    # Remove leading whitespace
    sub(/^\s+/, "", s)
    # Remove trailing whitespace
    sub(/\s+$/, "", s)
    return s
}
AWK_SCRIPT_END

echo "URLs, categories, and titles extracted to '$OUTPUT_FILE'."
