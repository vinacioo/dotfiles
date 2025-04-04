#!/usr/bin/env bash
# This script manages a scratchpad terminal using Alacritty,
# toggling its visibility and showing the Hyprland keybindings cheatsheet.
# It opens a floating Alacritty terminal with `fzf` for interactive selection
# of keybindings and descriptions, using a custom Alacritty config file.

# The class name for the scratchpad terminal
winclass="hyprland-keybinds-scratchpad"

# Define the custom Alacritty config file path
alacritty_config="$HOME/.config/alacritty/alacritty-hyprland.toml"

# Determine if we're running under Hyprland
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  # Using hyprctl to find window with our class
  winclass_id=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$winclass\") | .address")

  if [ -z "$winclass_id" ]; then
    # If no such window exists, open a new Alacritty terminal and run the cheatsheet
    alacritty --class "$winclass" --config-file "$alacritty_config" -e bash -c "
      # Create a temporary file for the processed config
      TEMP_FILE=\"/tmp/hyprland_keybinds_temp.txt\"
      
      # Process the Hyprland config to extract bindings in the desired format
      awk '
        BEGIN {
          current_section = \"\";
          print_section = 0;
          empty_line_count = 0;
          # Define a fixed column width for consistent alignment
          keybind_width = 35;  # Increased from 25 to accommodate longer keybindings
          dots_width = 40;     # Reduced from 50 to better balance the display
          description_column = keybind_width + dots_width + 5;  # Fixed position for descriptions
          
          # Print a nicely formatted title header
          printf \"\\n                                                \033[1;36mHyprland Keybindings\033[0m                                        \\n\\n\";
        }
        
        # Track empty lines
        /^[ \t]*$/ {
          empty_line_count++;
          next;
        }
        
        # Detect section headers
        /^[ \t]*#/ {
          if (empty_line_count > 0 || NR == 1) {
            # Store potential section header
            current_section = \$0;
            print_section = 1;
            empty_line_count = 0;
            next;
          }
        }
        
        # Process all types of bindings
        /^[ \t]*(bind|bindm|bindel|bindl)[ \t]*=/ {
          # Print section header if needed
          if (print_section) {
            printf \"\\n%s\\n\", current_section;
            print_section = 0;
          }
          
          # Extract the binding components
          line = \$0;
          
          # Get the bind type
          bind_type = \"\";
          if (match(line, /^[ \t]*(bind|bindm|bindel|bindl)/)) {
            bind_type = substr(line, RSTART, RLENGTH);
            gsub(/^[ \t]+|[ \t]+$/, \"\", bind_type);
          }
          
          # Remove bind type prefix
          sub(/^[ \t]*(bind|bindm|bindel|bindl)[ \t]*=[ \t]*/, \"\", line);
          
          # Extract inline comment if present
          description = \"\";
          if (match(line, /#/)) {
            description = substr(line, RSTART+1);
            line = substr(line, 1, RSTART-1);
            # Clean up spaces
            gsub(/^[ \t]+/, \"\", description);
            gsub(/[ \t]+$/, \"\", line);
          }
          
          # Split the line by comma to separate the parts
          split(line, parts, \",\");
          
          # Format the modifier and key based on binding type
          mod = parts[1];
          key = parts[2];
          gsub(/^[ \t]+/, \"\", key);
          gsub(/[ \t]+$/, \"\", key);
          
          # Special handling for different binding types
          if (bind_type == \"bindm\" && parts[3] ~ /mouse:/) {
            key = parts[3];
            gsub(/^[ \t]+/, \"\", key);
          } else if ((bind_type == \"bindel\" || bind_type == \"bindl\") && parts[3] ~ /XF86/) {
            key = parts[3];
            gsub(/^[ \t]+/, \"\", key);
          }
          
          # Construct the modkey string
          if (mod == \"\") {
            # For keys without modifiers (like XF86 keys)
            modkey = key;
          } else if (key == \"\") {
            # For entries that might only have a modifier
            modkey = mod;
          } else {
            # Normal case with both modifier and key
            modkey = mod \" \" key;
          }
          
          # Make modkey bold
          modkey = \"\\033[1m\" modkey \"\\033[0m\";
          
          # Calculate the actual length of the modkey without ANSI escape codes
          modkey_visible_length = length(modkey) - 9;  # Subtract the length of ANSI codes (9 chars)
          
          # Pad the keybind with spaces to fixed width
          formatted_key = modkey;
          for (i = modkey_visible_length; i < keybind_width; i++) {
            formatted_key = formatted_key \" \";
          }
          
          # Add connecting dots
          dots = \"\";
          for (i = 0; i < dots_width; i++) {
            dots = dots \".\";
          }
          
          # Format description with italic
          if (description != \"\") {
            description = \"\\033[3m\" description \"\\033[0m\";
            printf \"%s%s %s\\n\", formatted_key, dots, description;
          } else {
            printf \"%s\\n\", formatted_key;
          }
          
          empty_line_count = 0;
          next;
        }
        
        # Any other line resets the section tracking
        {
          if (!match(\$0, /^[ \t]*#/)) {
            print_section = 0;
          }
          empty_line_count = 0;
        }
      ' \"$HOME/.config/hypr/hyprland.conf\" > \"\$TEMP_FILE\"
      
      # Display with fzf using appropriate colors
      fzf --reverse --border --height 100% --prompt 'Hyprland Keybinds: ' \\
          --ansi --no-bold --no-multi --layout=reverse-list \\
          < \"\$TEMP_FILE\"
          
      # Clean up temp file
      rm -f \"\$TEMP_FILE\"
    "
  else
    # Toggle the window's visibility using hyprctl
    if [ ! -f /tmp/hyprland-keybinds-scratchpad ]; then
      # If the file doesn't exist, create it and hide the terminal window
      touch /tmp/hyprland-keybinds-scratchpad
      hyprctl dispatch movetoworkspacesilent special:minimized "$winclass_id"
    else
      # If the file exists, remove it and show the terminal window
      rm /tmp/hyprland-keybinds-scratchpad
      hyprctl dispatch movetoworkspace current "$winclass_id"
    fi
  fi
else
  # Fallback for running under X11/other WM
  winclass_id="$(xdotool search --class "$winclass" 2>/dev/null)"

  if [ -z "$winclass_id" ]; then
    # If no such window exists, open a new Alacritty terminal and run the cheatsheet
    alacritty --class "$winclass" --config-file "$alacritty_config" -e bash -c "
      # Create a temporary file for the processed config
      TEMP_FILE=\"/tmp/hyprland_keybinds_temp.txt\"
      
      # Process the Hyprland config to extract bindings in the desired format
      awk '
        BEGIN {
          current_section = \"\";
          print_section = 0;
          empty_line_count = 0;
          # Define a fixed column width for consistent alignment
          keybind_width = 35;  # Increased from 25 to accommodate longer keybindings
          dots_width = 40;     # Reduced from 50 to better balance the display
          description_column = keybind_width + dots_width + 5;  # Fixed position for descriptions
        }
        
        # Track empty lines
        /^[ \t]*$/ {
          empty_line_count++;
          next;
        }
        
        # Detect section headers
        /^[ \t]*#/ {
          if (empty_line_count > 0 || NR == 1) {
            # Store potential section header
            current_section = \$0;
            print_section = 1;
            empty_line_count = 0;
            next;
          }
        }
        
        # Process all types of bindings
        /^[ \t]*(bind|bindm|bindel|bindl)[ \t]*=/ {
          # Print section header if needed
          if (print_section) {
            printf \"\\n%s\\n\", current_section;
            print_section = 0;
          }
          
          # Extract the binding components
          line = \$0;
          
          # Get the bind type
          bind_type = \"\";
          if (match(line, /^[ \t]*(bind|bindm|bindel|bindl)/)) {
            bind_type = substr(line, RSTART, RLENGTH);
            gsub(/^[ \t]+|[ \t]+$/, \"\", bind_type);
          }
          
          # Remove bind type prefix
          sub(/^[ \t]*(bind|bindm|bindel|bindl)[ \t]*=[ \t]*/, \"\", line);
          
          # Extract inline comment if present
          description = \"\";
          if (match(line, /#/)) {
            description = substr(line, RSTART+1);
            line = substr(line, 1, RSTART-1);
            # Clean up spaces
            gsub(/^[ \t]+/, \"\", description);
            gsub(/[ \t]+$/, \"\", line);
          }
          
          # Split the line by comma to separate the parts
          split(line, parts, \",\");
          
          # Format the modifier and key based on binding type
          mod = parts[1];
          key = parts[2];
          gsub(/^[ \t]+/, \"\", key);
          gsub(/[ \t]+$/, \"\", key);
          
          # Special handling for different binding types
          if (bind_type == \"bindm\" && parts[3] ~ /mouse:/) {
            key = parts[3];
            gsub(/^[ \t]+/, \"\", key);
          } else if ((bind_type == \"bindel\" || bind_type == \"bindl\") && parts[3] ~ /XF86/) {
            key = parts[3];
            gsub(/^[ \t]+/, \"\", key);
          }
          
          # Construct the modkey string
          if (mod == \"\") {
            # For keys without modifiers (like XF86 keys)
            modkey = key;
          } else if (key == \"\") {
            # For entries that might only have a modifier
            modkey = mod;
          } else {
            # Normal case with both modifier and key
            modkey = mod \" \" key;
          }
          
          # Make modkey bold
          modkey = \"\\033[1m\" modkey \"\\033[0m\";
          
          # Calculate the actual length of the modkey without ANSI escape codes
          modkey_visible_length = length(modkey) - 9;  # Subtract the length of ANSI codes (9 chars)
          
          # Pad the keybind with spaces to fixed width
          formatted_key = modkey;
          for (i = modkey_visible_length; i < keybind_width; i++) {
            formatted_key = formatted_key \" \";
          }
          
          # Add connecting dots
          dots = \"\";
          for (i = 0; i < dots_width; i++) {
            dots = dots \".\";
          }
          
          # Format description with italic
          if (description != \"\") {
            description = \"\\033[3m\" description \"\\033[0m\";
            printf \"%s%s %s\\n\", formatted_key, dots, description;
          } else {
            printf \"%s\\n\", formatted_key;
          }
          
          empty_line_count = 0;
          next;
        }
        
        # Any other line resets the section tracking
        {
          if (!match(\$0, /^[ \t]*#/)) {
            print_section = 0;
          }
          empty_line_count = 0;
        }
      ' \"$HOME/.config/hypr/hyprland.conf\" > \"\$TEMP_FILE\"
      
      # Display with fzf using appropriate colors
      fzf --reverse --border --height 100% --prompt 'Hyprland Keybinds: ' \\
          --ansi --no-bold --no-multi --layout=reverse-list \\
          < \"\$TEMP_FILE\"
          
      # Clean up temp file
      rm -f \"\$TEMP_FILE\"
    "
  else
    # Toggle its visibility with xdotool
    if [ ! -f /tmp/hyprland-keybinds-scratchpad ]; then
      # If the file doesn't exist, create it and hide the terminal window
      touch /tmp/hyprland-keybinds-scratchpad && xdotool windowunmap "$winclass_id"
    else
      # If the file exists, remove it and show the terminal window
      rm /tmp/hyprland-keybinds-scratchpad && xdotool windowmap "$winclass_id"
    fi
  fi
fi
