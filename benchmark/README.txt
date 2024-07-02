---- How to disable irqbalance: ----

Check if it is enabled:
sudo systemctl status irqbalance

Stop service if enabled and running:
sudo systemctl stop irqbalance

Disable service (won't turn on during boot):
sudo systemctl disable irqbalance
update-rc.d -f irqbalance remove