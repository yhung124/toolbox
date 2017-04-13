#!/bin/bash
set -e

QUICK_UPGRADE="0"
arr=$(readlink /sys/class/block/* -e | sed -n "s/\(.*ata[0-9]\{,2\}\).*\/\(sd[a-z]\)$/\2/p")
read -a all_disk_arr <<< $arr

sys_disk=$(df | grep -w '/' | awk '{print $1}' | sed -n 's/.*\/\([a-z]*\)[0-9]/\1/p')

while getopts "y" OPTION
do
  case $OPTION in
    y) QUICK_UPGRADE="1" ;;
    *) echo "Unknown argument"; exit 1 ;;
  esac
done


function asksure() {
  read -p "Are you sure to delete all OSD disks? (Y/n): " -r
  #echo
  if [[ ! $REPLY =~ ^[Y]$ ]]; then
    echo "Exit!"
    exit 1
  fi

}

if [ "${QUICK_UPGRADE}" == "0" ]; then
  asksure
fi

# Wipe osd disks only
for disk in "${all_disk_arr[@]}"
do
  if [ "${disk}" != "${sys_disk}" ]; then
    echo "Wipe OSD disk: /dev/${disk}"
    sudo parted --script /dev/${disk} mktable gpt
    sudo sgdisk --zap-all --clear -g /dev/${disk}
    echo ""
  else
    echo "Skip system disk: /dev/${sys_disk}"
    echo ""
    continue
  fi
done

echo "Done!"