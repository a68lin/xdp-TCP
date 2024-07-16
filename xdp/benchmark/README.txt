---- How to decrease MTU of NIC (paper cluster): ----

Set new MTU:
sudo ip link set dev <interface_name> mtu 1500

Reload:
sudo ip link set dev <interface_name> down
sudo ip link set dev <interface_name> up


---- How to disable irqbalance: ----

Check if it is enabled:
sudo systemctl status irqbalance

Stop service if enabled and running:
sudo systemctl stop irqbalance

Disable service (won't turn on during boot):
sudo systemctl disable irqbalance
update-rc.d -f irqbalance remove