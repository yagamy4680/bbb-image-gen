
## `compare-dpkg-list.ls`

The simple utility to compare the debian packages installed between 2 images.

Usage:

Generate package list from one image:

```bash
$ kparted -a /tmp/aa.img
$ mount -t ext4 /dev/mapper/loop0p1 /mnt/rootfs
$ yac chroot script /mnt/rootfs -c "dpkg-query -l > /tmp/aa.txt"
$ umount /mnt/rootfs
$ kparted -v -d /tmp/aa.img
$ cat /tmp/aa.txt | grep "^ii" | awk '{printf "%s\t%s\n", $2, $3}' > /tmp/aa.csv
```

Repeat same step to produce the package list of another image, and the run the tool to compare:

```bash
$ ./compare-dpkg-list.ls /tmp/aa.csv /tmp/bb.csv
```

