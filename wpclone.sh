#!/bin/bash

# Description: This script clones a WordPress site to another domain.
# Usage: wpclonetool <Source> <Destination>

# Variables ##############
# $1 Source domain
# $2 Destination domain
sdir=$(awk -F"[:= ]" '/'"^$1"'/ {print $11}' /etc/userdatadomains | column -t)
ddir=$(awk -F"[:= ]" '/'"^$2"'/ {print $11}' /etc/userdatadomains | column -t)
duser=$(stat -c '%U' "$ddir")
suser=$(stat -c '%U' "$sdir")

echo "⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣶⣶⣶⣶⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣤⡾⠛⠋⣁⣠⣤⣤⣤⣤⣄⣈⠙⠛⢷⣤⡀⠀⠀⠀⠀
⠀⠀⠀⣴⡿⠋⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⠄⠙⢿⣦⠀⠀⠀
⠀⢀⣾⠋⠀⠾⠿⠿⢿⣿⠿⠿⠿⠿⠿⠿⣿⣿⠁⠀⠀⠀⠙⣷⡀⠀
⠀⣾⠏⢠⡀⠀⠀⢲⣿⣿⣿⣆⠀⠀⠀⢿⣿⣿⣆⠀⠀⠐⡀⠹⣷⠀
⢠⣿⠀⣾⣇⠀⠀⠈⣿⣿⣿⣿⡆⠀⠀⠘⣿⣿⣿⡆⠀⢰⣷⠀⣿⡄
⢸⣿⠀⣿⣿⡆⠀⠀⠸⣿⣿⣿⠃⠀⠀⠀⠹⣿⣿⡇⠀⣸⣿⠀⣿⡇
⠘⣿⠀⢿⣿⣿⡀⠀⠀⢻⣿⠇⢠⣇⠀⠀⠀⢿⣿⠇⢰⣿⡿⠀⣿⠃
⠀⢿⣆⠘⣿⣿⣧⠀⠀⠈⡟⠀⣾⣿⡄⠀⠀⠈⡟⢀⣾⣿⠃⣰⡿⠀
⠀⠈⢿⣄⠈⢿⣿⣇⠀⠀⠀⣸⣿⣿⣷⡀⠀⠀⠀⣸⡿⠃⣠⡿⠁⠀
⠀⠀⠀⠻⣷⣄⠙⠻⠄⠀⢠⣿⣿⣿⣿⣷⠀⠀⠰⠋⣠⣾⠟⠀⠀⠀
⠀⠀⠀⠀⠈⠛⢷⣤⣄⡀⠙⠛⠛⠛⠛⠋⢀⣠⣤⡾⠛⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠿⠿⠿⠿⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[32m\033[1mWordPress Cloning Script\033[0m"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# Check if source is a WordPress site
# Checks for wp-config file
if [[ ! -f "$sdir/wp-config.php" ]]; then
    echo -e "\e[1;31mSource does not appear to be a WordPress install [FAILED]\e[0m"

echo "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠖⠛⠉⠉⠉⠙⠳⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢀⣰⠀⠀⠀⠀⠀⣾⣶⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀⣰⡶⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡼⣿⣇⠀⠀⠀⠀⠙⠋⠀⠀⠀⠀⠀⠀⣼⠀⠀⣶⢧⡀⢀⡾⣋⢀⣿⣠⣶⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⣤⣀⣸⡎⣷⡞⠁⢨⡾⠋⠁⣴⡟⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣻⡄⠀⠀⣠⣤⠤⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠈⣙⣷⠾⠃⣠⠆⠀⣤⡾⢟⣶⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠛⠉⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡾⠛⠁⣠⠞⠁⠀⠀⢻⣯⣾⣯⣄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⠀⠈⠓⠀⠀⠀⠀⠀⠀⢀⣀⣤⠶⠛⣩⠟⠉⠀⣠⠞⠁⠀⣠⠖⠁⠀⠡⣠⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀⠀⠀⠶⢤⣄⣀⣠⡤⠶⠖⠛⠋⢁⣠⠞⠋⠀⣀⡴⠎⠁⠀⣠⠞⡁⢀⣠⡶⠛⠻⣤⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⠀⠈⠓⠀⠀⠀⠀⠀⠀⢀⣀⣤⠶⠛⣩⠟⠉⠀⣠⠞⠁⠀⣠⠖⠁⠀⠡⣠⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀⠀⠀⠶⢤⣄⣀⣠⡤⠶⠖⠛⠋⢁⣠⠞⠋⠀⣀⡴⠎⠁⠀⣠⠞⡁⢀⣠⡶⠛⠻⣤⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⠚⠁⢀⣠⠴⠛⠁⠀⢀⡴⢚⣡⡴⠟⠋⠀⠀⠀⠀⠈⠻⣦⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣠⡤⠶⠂⢀⣤⣶⣶⡴⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠖⠋⠁⠀⠀⠀⠉⠁⠀⢀⣤⢞⣯⡶⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡄⠀⠀
⠀⠀⠀⣠⡶⣫⠵⠂⠐⠚⠛⠿⠟⠉⢀⣤⣶⣦⣴⠞⠃⠀⠀⠀⡇⠀⠀⠀⠀⠀⢀⡴⠚⠉⠀⠀⠀⠀⠀⠀⠀⢀⡤⣶⣿⣶⠟⠋⠀⠀⠀⠀⢶⡄⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀
⠀⠀⣰⠏⠈⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣞⡽⣿⡅⣠⣆⠀⠀⠀⢻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣴⠾⠟⣫⠵⠋⠁⠀⠀⠀⠀⠀⠀⠀⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠹⡆
⠀⢰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⣋⡵⠞⠁⡟⢷⣄⣀⣀⣈⣟⠻⠶⠦⠤⣤⡤⠶⢛⡿⠟⠋⠁⣠⠴⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡳⣄⠀⠀⠀⠀⠀⠀⠀⢻
⠀⣿⠀⠀⠀⢀⣤⢶⣢⣤⠶⠄⠀⠀⠀⠀⠀⠀⢀⣼⠇⠀⠀⠉⢉⣿⣃⡤⠤⣖⣻⠽⣿⠋⠁⣀⡤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠙⣧⠀⠀⠀⠀⠀⠀⠀
⠀⣇⣀⠀⠀⠚⡿⠋⣭⡾⠂⠀⠀⠀⠀⢤⣤⣶⡟⠁⠀⠀⠒⠋⠹⣿⠒⠒⠊⠉⠀⠀⢻⡄⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡆⠸⣧⠀⠀⠀⠀⠀⠀
⢰⣿⠿⠋⠁⠀⠀⢸⢃⣠⡄⠀⠀⠀⠀⠀⠀⣀⠝⢳⡄⠀⠀⠀⠀⠻⠦⣤⡶⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⠀⢻⠀⠀⠀⠀⠀⠀
⠠⣯⠀⠀⠀⠀⠠⢿⣿⡵⠂⢀⠀⠀⣠⣶⣻⠇⠀⢀⡟⢀⡀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀⢸⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⣿⠀⠀⠀⠀⠀⠀
⣤⢿⡟⠀⢀⣀⠀⠛⢣⡤⣞⡯⠄⡠⠿⣋⡥⠆⢀⣿⠛⠋⠙⠻⣄⠀⣿⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀
⠀⢸⣟⣻⣟⡏⠀⠀⠀⠘⢯⣤⣞⠵⠚⠉⠀⢀⣸⠃⠀⠀⠀⠀⠙⠃⠛⠃⠀⠀⠀⠀⠀⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⢀⡄⠀⡀⠀⠀⢠
⠀⠈⢙⣿⣿⣥⠶⢤⠀⠀⠀⠉⠁⠀⠀⠀⠀⠘⠛⠛⠙⠓⠲⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠷⢻⣧⡴⣿⣴⣦⣼
⠀⠀⠈⠛⠙⠓⣻⣿⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠉⠉⠛⠉
⠀⠀⠀⢀⣴⠞⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣇⠀⠀⠀⠀
⠀⠀⣰⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡀⠀⠀⠀
⠀⢰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡀⠀⠀
⢀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⠀⠸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀
⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⡞⠀⠀⠀⠀⠀"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

    exit 1
else
    echo -e "WordPress site present at source $1 [\033[32mOK\033[0m]"
fi

# Check if destination is empty
if [ -d "$ddir" ]; then
    if [ "$(ls -A "$ddir")" ]; then
        echo -e "Destination directory $ddir is not empty, it must be empty to use this scriipt \e[91m[FAILED]\e[0m"
echo "
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠶⠞⠋⠉⠉⠉⠉⠉⠙⠷⢦⣄⣀⣠⠶⠞⠛⠉⠙⠛⠷⢶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠋⠀⠀⠀⠀⠀⠀⣠⣤⣤⣤⣤⣤⡤⣤⣤⣤⣄⡙⣧⠀⣀⣄⣀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠁⠀⠀⠀⠀⢠⣴⠟⠛⠁⠀⠀⠀⠀⠀⠀⠀⠉⠉⠻⣿⣿⡍⠉⠛⠛⠳⣦⣄⣀⠀⠀⠈⢿⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⡿⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣴⣶⣤⣤⣌⣿⡄⠀⠀⠀⠀⠙⠋⠉⠛⠷⣦⣿⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⢶⣶⣤⣄⣤⣿⣛⣁⣠⣤⣶⣶⣦⣤⣝⠛⣿⣤⣄⣀⣤⣤⣤⣥⣤⣤⣌⡛⣿⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⢠⡏⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣴⠾⢿⡾⠛⠋⠉⠀⠀⠀⠀⠀⠈⠙⠻⣾⣯⣉⢛⣛⣭⣭⣭⣍⣙⠛⠿⣿⣿⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠁⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⣷⡀⢀⣀⣤⣤⡶⠶⣞⣻⣛⠛⠛⠿⢶⣶⣤⣍⣉⣁⣠⣤⣬⣭⣛⡛⣷⣦⡉⢿⡄
⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⡉⠀⢀⣼⣿⣿⣿⣿⣿⣿⣷⡄⠀⢈⣿⠉⠉⠉⠉⠉⣉⣽⣛⠻⢾⣿⣾⠃
⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢮⣟⣶⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣼⡟⠀⠀⠀⣠⣾⣿⣿⣿⣿⡄⠈⢻⣷
⠀⠀⠀⠀⠀⠀⢠⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⡟⠿⠷⣾⣿⣿⣿⣿⣿⣿⣿⠀⣼⡿
⠀⠀⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣉⣉⣻⡿⠻⠛⠛⠉⠘⣿⣄⠀⠀⠉⠻⣿⣿⣿⣿⣿⣶⡿⠃
⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠳⠞⠋⠉⠉⠁⠀⠀⠀⠀⠀⠹⣿⢷⣦⣀⠀⠀⠉⣉⣭⣾⠟⠁⠀
⠀⠀⠀⠀⠀⣸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⠉⠙⠛⠛⠛⣿⡏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⠉⠙⠛⠛⠛⣿⡏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠸⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡾⠟⠛⠉⠛⠛⠻⠿⢶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢿⡇⡀⠀⠀⠀⠀⠀⠀⠀⠀⢤⡀⠀⠀⠀⠠⣿⡇⢀⣀⣀⣀⣀⣀⡀⠀⠀⠙⠻⠷⢶⣦⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠀⠀⠀⠀⢻⣧⡈⠉⠉⠉⠉⠉⠛⠻⠶⢶⣤⣀⡀⠈⠉⠛⠻⠿⠶⠶⢶⣶⡶⠶⠶⠶⠶⣾⣿⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢹⣧⡀⠀⠀⠀⠀⠀⠀⠀⠐⢻⣦⡀⢠⠀⠀⠉⠻⢷⣤⣤⣤⣤⣄⡀⠀⠀⠉⠙⠿⢶⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠛⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠻⣷⣦⣄⡀⠀⠀⠈⠉⠛⠛⠻⠿⣶⣦⣤⣤⣤⣀⣀⣠⣾⠟⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⢻⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⢷⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠈⣹⡏⠀⠀⠀⠀
⠀⠀⠀⢀⣴⡿⠟⠋⠀⠹⣷⣌⠛⢷⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠛⣾⡿⠿⠛⠁⠀⠀⠀⠀
⠀⢀⣼⡿⠋⠀⠀⠀⠀⠀⠈⠛⠿⠶⣬⣟⠻⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⠟⠀⠀⠀⠀⠀⠀⠀⠀
⢀⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣶⣤⣉⠛⠛⠿⣶⣦⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣤⣤⣴⡾⠿⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⠷⣦⣤⣄⣈⠉⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⣩⣽⠛⢿⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠛⠿⣶⣤⡤⠶⠶⠶⠟⠋⠀⠀⠀⠙⢿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀
"
        exit 1
    else
        echo -e "$ddir is empty [\033[32mOK\033[0m]"
    fi
else
    echo "Directory $ddir not found."
    exit 1
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Copying files from $sdir to $ddir"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp -r "$sdir/." "$ddir"
echo -e "Files successfully copied [\033[32mOK\033[0m]"


# Remove old .htaccess file and create new one with default WordPress rules
rm "$ddir/.htaccess"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Creating new .htaccess file with default WordPress rules"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# BEGIN WordPress" > "$ddir/.htaccess"
echo "<IfModule mod_rewrite.c>" >> "$ddir/.htaccess"
echo "RewriteEngine On" >> "$ddir/.htaccess"
echo "RewriteBase /" >> "$ddir/.htaccess"
echo "RewriteRule ^index\.php$ - [L]" >> "$ddir/.htaccess"
echo "RewriteCond %{REQUEST_FILENAME} !-f" >> "$ddir/.htaccess"
echo "RewriteCond %{REQUEST_FILENAME} !-d" >> "$ddir/.htaccess"
echo "RewriteRule . /index.php [L]" >> "$ddir/.htaccess"
echo "</IfModule>" >> "$ddir/.htaccess"
echo "# END WordPress" >> "$ddir/.htaccess"
echo "</IfModule>" >> "$ddir/.htaccess"
echo "# END WordPress" >> "$ddir/.htaccess"
echo -e "New .htaccess file created [\033[32mOK\033[0m]"

# Fix destination permissions recursively
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "fixing perms and ownership of files"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
find "$ddir" -type f -exec chmod 644 {} \;
echo "Still in progress [25%]"
find "$ddir" -type d -exec chmod 755 {} \;
echo "Still in progress [50%]"
chown -R "$duser:nobody" "$ddir"
find "$ddir" -type f -exec chown "$duser:$duser" {} \;
echo "Almost done [75%]"
find "$ddir" -type d -exec chown "$duser:$duser" {} \;
echo -e "Permissions fixed [\033[32mOK\033[0m]"

# Request for new database name, username, and password
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Enter new database credentials (You must create this is cPanel > Mysql Databases before proceeding)"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Enter the new database name: "
read new_dbname
echo "Enter the new database username: "
read new_dbuser
echo "Enter the new database password: "
read new_dbpass

# Update wp-config.php with new database details
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Updating wp-config with new database credentials"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sed -i "s/'DB_NAME', '.*'/'DB_NAME', '$new_dbname'/g; s/'DB_USER', '.*'/'DB_USER', '$new_dbuser'/g; s/'DB_PASSWORD', '.*'/'DB_PASSWORD', '$new_dbpass'/g" "$ddir/wp-config.php"
echo -e "wp-config updated with new database credentials [\033[32mOK\033[0m]"

# Dump db (check source config file for details) copy source db to destination
WPDBNAME=$(sed -n "s/define( *'DB_NAME', *'\([^']*\)'.*/\1/p" /home/"$suser"/public_html/wp-config.php)
echo "Dumping source account database"
mysqldump "$WPDBNAME" > source.sql
echo -e "Database dumped to source.sql [\033[32mOK\033[0m]"

# Search and replace on destination site from $1 to $2; will need to run command as user
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Starting search and replace on database file "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sed -i "s/$1/$2/g" source.sql
sed -i "s/$WPDBNAME/$new_dbname/g" source.sql
sed -i "s/$1/$2/g" source.sql
sed -i "s/$WPDBNAME/$new_dbname/g" source.sql
sed -i "s/$suser/$duser/g" source.sql
echo -e "Search and replace completed [\033[32mOK\033[0m]"

# Import file to destination
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Importing database to destination account"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
mysql --user="$new_dbuser" --password="$new_dbpass" "$new_dbname" < source.sql
echo -e "Import completed [\033[32mOK\033[0m]"

#export and then import widgets fro source to destination
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Copying widgets over - MAY PRODUCE SOME ERRORS IN OUTPUT"

cd "$sdir" || exit
su -c "wp option get sidebars_widgets --format=json > widgets.txt" "$suser"
#loop through widgets tables and output to files
WIDGETSARRAY=($(wp db query "SELECT option_name FROM $(wp db prefix --allow-root)options WHERE option_name LIKE 'widget\_%'" --skip-column-names --allow-root))

# loop through widgets
for WIDGET in ${WIDGETSARRAY[@]}
do
    wp option get ${WIDGET} --format=json --allow-root > ${WIDGET}.txt
done

#copy widget files to desitination directory
cp widget* "$ddir"

chown -R "$duser:nobody" "$ddir"
find "$ddir" -type f -exec chown "$duser:$duser" {} \;
find "$ddir" -type d -exec chown "$duser:$duser" {} \;



cd "$ddir" || exit
su -c "wp option update sidebars_widgets --format=json < widgets.txt" "$duser"
rm widgets.txt
rm widgets1.txt
rm widgets.json
# loop through widget backups and import to new database
for WIDGETBACKUP in widget*
do
    # extract filename
    WIDGETFILE=$(basename ${WIDGETBACKUP})
    # get filename only without extension
    WIDGET="${WIDGETFILE%%.*}"
 # get filename only without extension
    WIDGET="${WIDGETFILE%%.*}"
    # output which widget is being updated
    #echo "$WIDGET"
    # show widget backup contents
    #cat ${WIDGETBACKUP}
    WIDGETTEST=$(wp option get ${WIDGET} --allow-root)
    if [[ ! -z "$WIDGETTEST" ]]; then
         wp option update ${WIDGET} --format=json --allow-root < ${WIDGETBACKUP}
    else
         wp option add ${WIDGET} --format=json --allow-root < ${WIDGETBACKUP}
    fi
done


# Use curl to get the HTTP status code of the website
http_status=$(curl -sL -w "%{http_code}" "$2" -o /dev/null)

# Check if the status code is 200 OK
if [[ "$http_status" -eq 200 ]]; then
  echo -e "Website is loading [\033[32mSuccess\033[0m]"
echo "
  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠏⠉⢿⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠀⠀⢤⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠀⠀⠀⢺⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⢃⣀⠀⢰⣞⣿⣽⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠇⠈⠉⢻⣿⣿⣻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠃⠀⠐⠠⣿⣿⣫⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠁⠀⣀⣾⡿⠿⢷⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠁⠀⠀⢀⣮⣿⣯⣭⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠁⠀⠀⣀⣐⠛⣿⣿⢻⣇⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠃⠸⠾⠧⠽⡟⣯⣽⣿⢼⣯⠩⠙⠛⠓⠶⢤⣤⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣻⠀⠀⠀⣤⣈⣓⡾⢿⣿⣿⣷⠴⣶⣤⣠⣷⣀⣴⣄⣀⣀⣈⣉⡻⢦⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⢷⠁⠀⠀⠀⠐⠫⢿⣿⣾⣟⠛⢘⣿⠟⠋⠉⠛⠛⠛⠛⠛⠉⠁⠀⠀⠀⢹⣷⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡃⠀⠀⠀⠀⠀⠀⠀⠀⣷⢾⣷⣶⣾⣧⣱⣄⠀⠀⠀⠀⠀⢀⡀⣀⣀⡰⣶⢠⣿⣿
⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⢀⣀⣠⣄⠀⠀⢀⣴⠟⠟⠁⠀⠀⠀⠀⠀⠀⣀⣠⣿⣿⣿⣿⣿⣿⣟⣿⣷⣤⣿⣿⣿⣾⣿⣷⣿⣧⣿⣾⣿⣿
⠀⣠⣴⣶⣶⣾⣿⣿⣽⣏⣯⣿⣿⣶⣿⠟⠋⠉⢳⢌⡀⠀⣀⠀⠀⢠⣶⡶⢿⣿⣿⣿⣿⣿⣿⡏⠘⠉⠛⠿⢿⣿⣿⣟⣿⣛⣻⣿⣿⣿⡿⠋
⢠⣿⣿⣿⣿⢿⣯⡏⣿⣿⡏⡟⣿⣯⡇⠀⠀⠀⢻⡆⢿⣆⠈⣿⢳⣮⣿⣿⣦⣴⣾⣿⣿⣿⣿⣿⡀⢀⡀⡠⠀⠀⠉⠉⠈⠙⠙⠛⢻⣿⡄⠀
⢸⣿⣿⣟⢻⢸⣿⢁⡇⠿⢷⠿⡟⣿⡀⠀⠀⠀⢸⣿⣆⢻⣷⣌⢷⣶⣿⣛⣻⣿⣿⣿⢿⣿⣯⣿⡳⢾⣿⡁⢠⣄⣀⣤⣶⢲⢲⣾⣿⣏⡇⠀
⠨⣿⣿⢹⣿⢸⣿⢸⠛⡆⠀⠀⠀⠋⡇⠀⠀⠀⢀⢙⣿⣧⠈⠈⠛⠻⠟⠛⠛⠛⠿⠷⣾⣿⣿⠟⠿⣗⡦⢭⣛⣿⣯⣿⣿⣿⣿⣿⣿⣿⠃⠀
⠀⣿⡟⠸⡼⣞⢹⣼⣎⠁⠀⠀⠀⠀⣿⣒⣀⣾⣿⡾⢿⡿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢴⢿⣿⣿⡄⠀⠈⠉⠀⠀⠽⠭⠿⣷⣿⣿⣿⠋⠁⠀⠀
⠀⢻⡟⠂⠁⠈⠛⡟⡏⠀⠀⠀⠀⠀⠸⡄⠀⠀⠀⢀⣿⣧⡀⡀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣟⢶⣤⣀⣀⡀⢀⡄⠀⠀⢀⣺⣿⠀⠀⠀⠀
⠀⠀⣿⣽⡄⠀⠀⠵⡇⠀⠀⠀⠀⠀⠀⢷⡀⠀⢀⣀⣿⢧⢿⣿⣦⣀⠀⠀⠀⠀⠈⢩⣭⣽⠏⠙⠿⣯⣝⣿⠿⣿⣠⣶⣾⣿⣿⡿⠀⠀⠀⠀
⠀⠀⠹⣿⣿⡌⡓⠀⢻⡀⠀⠀⠀⠀⠀⠘⣧⣄⣒⣳⣿⣿⣯⣿⣟⡻⣿⣆⣤⣤⣒⣿⣿⣾⣧⡀⠀⠈⠓⠽⠿⣾⡿⣿⣿⡿⠟⠁⠀⠀⠀⠀
⠀⠀⠀⠘⣿⡇⢹⣞⣿⣧⠀⠀⠀⠀⠀⠀⠸⣿⣵⢟⣿⣿⡿⠿⠿⠿⠾⢿⣿⣿⣿⣿⣿⣿⣿⣟⡶⢤⠄⡀⢀⡈⣙⣿⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢹⡇⢸⣿⡏⢿⡆⠀⠀⠀⢀⣀⡀⢹⣿⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⡌⣏⣾⡸⣿⣄⣤⠯⠿⠷⠚⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠸⣧⠹⣻⣧⢿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
