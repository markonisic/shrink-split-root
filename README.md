# shrink-split-sda
Bash script which shrinks the asigned hdd partition/s on a GNU/Linux with fdisk utility, 
splits the partition and creates a new partition from the reamaining free space, formats it and mounts it.

/dev/vda partition in the script used as an example.

Script will only run if less or equal than 45% of the partition space is used.






