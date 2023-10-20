#!/run/current-system/sw/bin/bash
set -e
set -u
set -o pipefail

# Check if the required commands are available
if ! command -v rofi &> /dev/null; then
    echo "rofi could not be found"
    exit
fi

if ! command -v wallust &> /dev/null; then
    echo "wallust could not be found"
    exit
fi

# Rest of the script
selected=$(ls -1 ~/wallpapers | grep "jpg" | rofi -dmenu -p "Wallpapers")

if [ "$selected" ]; then
    echo "Changing theme..."
    wallpaper=~/wallpapers/"$selected"

    echo $wallpaper;

    # Update wallpaper with pywal
    wallust "$wallpaper"

    # Get new theme
    # source "$HOME/.config/hypr/colors-hyprland.conf"

    # Copy color file to waybar folder
    cp "$wallpaper" ~/.cache/current_wallpaper.jpg

    newwall=$(echo "$wallpaper" | sed "s|$HOME/wallpapers/||g")

    # Set the new wallpaper
    swww img "$wallpaper" --transition-step 20 --transition-fps=20
    ~/.config/waybar/reload.sh

    # Send notification
    notify-send "Theme and Wallpaper updated" "With image $newwall"

    echo "Done."
fi
