#!/bin/bash

#### LOGO ####
echo -e "\e[93m .___/\        __________         __                             \e[0m"
echo -e "\e[93m |   )/_____   \______   \_____ _/  |_  _____ _____    ____      \e[0m"
echo -e "\e[93m |   |/     \   |    |  _/\__  \\   __\/     \\__  \  /    \     \e[0m"
echo -e "\e[93m |   |  Y Y  \  |    |   \ / __ \|  | |  Y Y  \/ __ \|   |  \    \e[0m"
echo -e "\e[93m |___|__|_|  /  |______  /(____  /__| |__|_|  (____  /___|  / /\ \e[0m"
echo -e "\e[93m           \/          \/      \/           \/     \/     \/  \/ \e[0m"
echo ""


#### DIST INFO ####
[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
	# Fall back to using the very slow lsb_release utility
	DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

printf " Welcome to %s (%s %s %s)\n" "$DISTRIB_DESCRIPTION" "$(uname -o)" "$(uname -r)" "$(uname -m)"


#### HDD SPACE ####
re='^[0-9]+([.][0-9]+)?$'

echo -e "\n ==== == HDD SPACE == ===="

df -h | grep -vE '^tmpfs|cdrom|dev/root' | awk '{ print "  " $5 "\t" $4 "\t" $6 }' | while read output;

do
	usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1 )

	partition=$(echo $output | awk '{ print $2 }')

	if [[ $usep =~ $re ]] && [ $usep -ge 95 ]; then
		echo -e " \e[91m$output\e[0m    \e[41m *** Running out of space *** \e[0m"
	else
		if [[ $usep =~ $re ]]; then
			echo -e " \e[92m$output\e[0m"
		else
			echo -e " $output"
		fi
	fi
done

echo -e "\n"


#### SYSTEM INFO ####
if [ -x /usr/lib/update-notifier/update-motd-fsck-at-reboot ]; then
    exec /usr/lib/update-notifier/update-motd-fsck-at-reboot
fi

if [ -x /usr/lib/update-notifier/update-motd-reboot-required ]; then
    exec /usr/lib/update-notifier/update-motd-reboot-required
fi