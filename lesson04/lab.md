## RAID

- Проверим какие диски есть и какие разделы на них созданы
```
root@ubuntu-bionic:/home/vagrant# fdisk -l
Disk /dev/sdb: 10 MiB, 10485760 bytes, 20480 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 40 GiB, 42949672960 bytes, 83886080 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x78e65fa0

Device     Boot Start      End  Sectors Size Id Type
/dev/sda1  *     2048 83886046 83883999  40G 83 Linux


Disk /dev/sdc: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdd: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sde: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdf: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
- Создадим разделы на дисках /dev/sdc /dev/sdd /dev/sde /dev/sdf
```
root@ubuntu-bionic:/home/vagrant# fdisk /dev/sdc

Welcome to fdisk (util-linux 2.31.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x152f013b.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 
First sector (2048-8388607, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-8388607, default 8388607): 

Created a new partition 1 of type 'Linux' and of size 4 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
- Создаем RAID
```
root@ubuntu-bionic:/home/vagrant# mdadm -C /dev/md0 -l 1 -n 2 /dev/sd[cd]1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? 
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
- Проверим статус RAID
```
root@ubuntu-bionic:/home/vagrant# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun May 23 08:35:57 2021
        Raid Level : raid1
        Array Size : 4190208 (4.00 GiB 4.29 GB)
     Used Dev Size : 4190208 (4.00 GiB 4.29 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sun May 23 08:36:22 2021
             State : clean, resyncing 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

     Resync Status : 49% complete

              Name : ubuntu-bionic:0  (local to host ubuntu-bionic)
              UUID : 155c4077:989398c9:bb1833ba:a303728e
            Events : 7

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
```
- Можем наблюдать за процессом
```
root@ubuntu-bionic:/home/vagrant# watch -c cat /proc/mdstat
Every 2.0s: cat /proc/mdstat                                                                  ubuntu-bionic: Sun May 23 08:36:48 2021

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid1 sdd1[1] sdc1[0]
      4190208 blocks super 1.2 [2/2] [UU]
      [==================>..]  resync = 90.0% (3775936/4190208) finish=0.0min speed=75492K/sec

unused devices: <none>
```
- Проверяем повторно статус
```
root@ubuntu-bionic:/home/vagrant# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun May 23 08:35:57 2021
        Raid Level : raid1
        Array Size : 4190208 (4.00 GiB 4.29 GB)
     Used Dev Size : 4190208 (4.00 GiB 4.29 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Sun May 23 08:36:53 2021
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : ubuntu-bionic:0  (local to host ubuntu-bionic)
              UUID : 155c4077:989398c9:bb1833ba:a303728e
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
```
- Создадим файловую систему
```
root@ubuntu-bionic:/home/vagrant# mkfs.ext4 //dev/md0
mke2fs 1.44.1 (24-Mar-2018)
Creating filesystem with 1047552 4k blocks and 262144 inodes
Filesystem UUID: 9d80d298-25ad-4229-a76c-478a42651252
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 
```
- Создадим каталог /mnt/raid
```
root@ubuntu-bionic:/home/vagrant# mkdir /mnt/raid
```
- Проверим конфигурацию fstab
```
root@ubuntu-bionic:/home/vagrant# cat /etc/fstab
LABEL=cloudimg-rootfs   /        ext4   defaults        0 1
```
- Узнаем UUID
```
root@ubuntu-bionic:/home/vagrant# blkid /dev/md0
/dev/md0: UUID="9d80d298-25ad-4229-a76c-478a42651252" TYPE="ext4"
```
- Добавим конфигурацию монтирования и проверим ее наличие
```
vagrant@ubuntu-bionic:~$ cat /etc/fstab
LABEL=cloudimg-rootfs   /        ext4   defaults        0 1
UUID=3efd801e-222c-4b86-963d-4f98d9e996ab /mnt/raid ext4 defaults 0 0
```
- Смонтируем нашу конфигурацию
```
root@ubuntu-bionic:/home/vagrant# mount /dev/md0
```
- Проверим наличие монтирования
```
root@ubuntu-bionic:/home/vagrant# mount | grep md0
/dev/md0 on /mnt/raid type ext4 (rw,relatime,data=ordered)
```
- Проверим возможность создадания файлов
```
root@ubuntu-bionic:/home/vagrant# touch /mnt/raid/file01
root@ubuntu-bionic:/home/vagrant# ll /mnt/raid
total 24
drwxr-xr-x 3 root root  4096 May 23 08:57 ./
drwxr-xr-x 3 root root  4096 May 23 08:55 ../
-rw-r--r-- 1 root root     0 May 23 08:57 file01
drwx------ 2 root root 16384 May 23 08:46 lost+found/
```
- Размонтируем и остановим RAID
```
root@ubuntu-bionic:/home/vagrant# umount /dev/md0
root@ubuntu-bionic:/home/vagrant# mdadm -S /dev/md0
```
- Отключим разделы от RAID-а
```
root@ubuntu-bionic:/home/vagrant# mdadm --zero-superblock /dev/sd[cd]1
```
- Создаем аналогично RAID5
```
root@ubuntu-bionic:/home/vagrant# mdadm -C /dev/md0 -l 5 -n 4 /dev/sd[c-f]1
```
- На любом RAID можем проверить вывод из строя диска
```
root@ubuntu-bionic:/mnt/raid# mdadm /dev/md0 -f /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
root@ubuntu-bionic:/mnt/raid# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun May 23 09:11:24 2021
        Raid Level : raid5
        Array Size : 12570624 (11.99 GiB 12.87 GB)
     Used Dev Size : 4190208 (4.00 GiB 4.29 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Sun May 23 09:15:50 2021
             State : clean, degraded 
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : ubuntu-bionic:0  (local to host ubuntu-bionic)
              UUID : 9c47afde:2cd5c4de:48f2212e:a7cc27a8
            Events : 34

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       4       8       81        3      active sync   /dev/sdf1

       0       8       33        -      faulty   /dev/sdc1
```
- Удалим диск из RAID и добавим заново, посмотрим статус
```
root@ubuntu-bionic:/mnt/raid# mdadm /dev/md0 -r /dev/sdc1
mdadm: hot removed /dev/sdc1 from /dev/md0
root@ubuntu-bionic:/mnt/raid# mdadm /dev/md0 -a /dev/sdc1
mdadm: added /dev/sdc1
root@ubuntu-bionic:/mnt/raid# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun May 23 09:11:24 2021
        Raid Level : raid5
        Array Size : 12570624 (11.99 GiB 12.87 GB)
     Used Dev Size : 4190208 (4.00 GiB 4.29 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Sun May 23 09:17:01 2021
             State : clean, degraded, recovering 
    Active Devices : 3
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

    Rebuild Status : 7% complete

              Name : ubuntu-bionic:0  (local to host ubuntu-bionic)
              UUID : 9c47afde:2cd5c4de:48f2212e:a7cc27a8
            Events : 140

    Number   Major   Minor   RaidDevice State
       5       8       33        0      spare rebuilding   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       4       8       81        3      active sync   /dev/sdf1
```

## LVM
- Убираем связи со старым RAID
```
root@ubuntu-bionic:/mnt# cd /mnt
root@ubuntu-bionic:/mnt# umount /dev/md0
root@ubuntu-bionic:/mnt# mdadm -S /dev/md0
mdadm: stopped /dev/md0
root@ubuntu-bionic:/mnt# mdadm --zero-superblock /dev/sd[c-f]1
```
- Если утилита не найден, надо будет установить
```
sudo apt install lvm2
```
- Создаем на базе существующих разделом PV
```
root@ubuntu-bionic:/mnt# pvcreate /dev/sd[c-f]1
  Physical volume "/dev/sdc1" successfully created.
  Physical volume "/dev/sdd1" successfully created.
  Physical volume "/dev/sde1" successfully created.
  Physical volume "/dev/sdf1" successfully created.
```
- Проверим их наличие
```
root@ubuntu-bionic:/mnt# pvdisplay /dev/sd[c-f]1
  "/dev/sdc1" is a new physical volume of "<4.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc1
  VG Name               
  PV Size               <4.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               cTln41-Oqdp-Uip3-JLrT-ZsYC-bD4F-4onRo8
```
-  Создадим группу
```
root@ubuntu-bionic:/mnt# vgcreate vg1 /dev/sd[c-f]1
  Volume group "vg1" successfully created
```
- Проверим группуv
```
root@ubuntu-bionic:/mnt# vgdisplay vg1
  --- Volume group ---
  VG Name               vg1
  System ID             
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               15.98 GiB
  PE Size               4.00 MiB
  Total PE              4092
  Alloc PE / Size       0 / 0   
  Free  PE / Size       4092 / 15.98 GiB
  VG UUID               8g9Ete-eYU7-0eXf-RgVc-sjjs-GO6S-eDyAxz
```
- Создадими логический раздел
```
root@ubuntu-bionic:/mnt# lvcreate -L 16000M -n lv1 vg1
  Logical volume "lv1" created.
```
- Проверим
```
root@ubuntu-bionic:/mnt# lvdisplay /dev/vg1/lv1
  --- Logical volume ---
  LV Path                /dev/vg1/lv1
  LV Name                lv1
  VG Name                vg1
  LV UUID                Zj7f6P-24FU-FwQP-LGfg-h11f-iPvv-CeTlrf
  LV Write Access        read/write
  LV Creation host, time ubuntu-bionic, 2021-05-23 09:27:23 +0000
  LV Status              available
  # open                 0
  LV Size                15.62 GiB
  Current LE             4000
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```
-  Удалим LV и создадим с указание размера в LE
```
root@ubuntu-bionic:/mnt# lvremove /dev/vg1/lv1
Do you really want to remove and DISCARD active logical volume vg1/lv1? [y/n]: y
  Logical volume "lv1" successfully removed
root@ubuntu-bionic:/mnt# lvcreate -l 4092 -n lv1 vg1
  Logical volume "lv1" created.
```
- Проверим объем
```
root@ubuntu-bionic:/mnt# lvdisplay /dev/vg1/lv1
  --- Logical volume ---
  LV Path                /dev/vg1/lv1
  LV Name                lv1
  VG Name                vg1
  LV UUID                8YWAlg-ioQb-Mqhi-DV2v-Cald-PKif-sXcgM0
  LV Write Access        read/write
  LV Creation host, time ubuntu-bionic, 2021-05-23 09:28:38 +0000
  LV Status              available
  # open                 0
  LV Size                15.98 GiB
  Current LE             4092
  Segments               4
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```
- Дальнейшние этапы такие же: создаем файловую систему, монтируем.
- Демонтируем и удаляем LVM объекты
```
root@ubuntu-bionic:/mnt# lvremove /dev/vg1/lv1
Do you really want to remove and DISCARD active logical volume vg1/lv1? [y/n]: y
  Logical volume "lv1" successfully removed
root@ubuntu-bionic:/mnt# vgremove vg1
  Volume group "vg1" successfully removed
root@ubuntu-bionic:/mnt# pvremove /dev/sd[c-f]1
  Labels on physical volume "/dev/sdc1" successfully wiped.
  Labels on physical volume "/dev/sdd1" successfully wiped.
  Labels on physical volume "/dev/sde1" successfully wiped.
  Labels on physical volume "/dev/sdf1" successfully wiped.
```