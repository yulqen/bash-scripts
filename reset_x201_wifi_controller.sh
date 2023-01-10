sudo echo "1" > /sys/bus/pci/devices/0000:02:00.0/remove    # remove pci device, you might have to change the 03:00.0 part to yours
sleep 3
sudo echo "1" > /sys/bus/pci/rescan                                      # rescan for devices

# find pci device reference with lspci | grep Centrino

