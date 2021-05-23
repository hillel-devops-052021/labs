## Users
- Создаем пользователя demo1

```
vagrant@ubuntu-bionic:~$ sudo useradd demo1
```

- Пробуем войти под пользователем demo1 и получает ошибку, так как у пользователя несуществует пароль
```
vagrant@ubuntu-bionic:~$ su demo1
Password: 

su: Authentication failure

vagrant@ubuntu-bionic:~$ 
```

- Установим пароль в интерактивном режиме через утилиту passwd
```
vagrant@ubuntu-bionic:~$ sudo passwd demo1
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
```
- Попробуем войти
```
vagrant@ubuntu-bionic:~$ su demo1
Password: 
```
- Так как мы не установили оболку по умолчанию и не определили ее при создании пользователя используется shell в котором не совсем кто мы, проверим через утилиту whoami
```
$ whoami
demo1
```
- выходим из пользователя
```
$ exit
```
- Модифицируем пользователя определив ему оболочку
```
vagrant@ubuntu-bionic:~$ sudo usermod demo1 -s /bin/bash
```
- Пробуем войти
```
vagrant@ubuntu-bionic:~$ su demo1
Password: 
```
- Видим приглашение в стиле bash
```
demo1@ubuntu-bionic:/home/vagrant$ 
```
- Смотрим настройки по-умолчанию на необходимость определение персонального домашнего каталога, иначе будет /home
```
demo1@ubuntu-bionic:/home/vagrant$ grep DEFAULT_HOME /etc/login.defs
DEFAULT_HOME    yes
```
- Проверяем что у пользователя определен персональный домашний каталог
```
demo1@ubuntu-bionic:/home/vagrant$ grep demo1 /etc/passwd
demo1:x:1002:1002::/home/demo1:/bin/bash
```
- При проверке наличие каталога, видим что его нет
```
demo1@ubuntu-bionic:/home/vagrant$ ls -la /home
total 16
drwxr-xr-x  4 root    root    4096 May 17 10:32 .
drwxr-xr-x 24 root    root    4096 May 17 10:32 ..
drwxr-xr-x  3 ubuntu  ubuntu  4096 May 17 10:32 ubuntu
drwxr-xr-x  5 vagrant vagrant 4096 May 17 10:42 vagrant
```
- Проверяем наличие переменной CREATE_HOME которая могла бы создавать каталоги по умолчанию, так же это можно было избежать передав параметр -m при создании пользователя
```
vagrant@ubuntu-bionic:~$ grep CREATE_HOME /etc/login.defs
vagrant@ubuntu-bionic:~$
```
- Так как ее нет, добавим строку определеющую данную переменную
```
root@ubuntu-bionic:/home/vagrant- echo "CREATE_HOME yes" >> /etc/login.defs
root@ubuntu-bionic:/home/vagrant- exit
exit
```
- Проверяем наличие
```
vagrant@ubuntu-bionic:~$ grep CREATE_HOME /etc/login.defs
CREATE_HOME yes
```

- Удалим пользователя
```
vagrant@ubuntu-bionic:~$ sudo userdel demo1
```
- Создаем пользователя
```
vagrant@ubuntu-bionic:~$ sudo useradd demo1
```
- Проверяем наличие домашнего каталога пользователя
```
vagrant@ubuntu-bionic:~$ ls -la /home
total 20
drwxr-xr-x  5 root    root    4096 May 17 13:58 .
drwxr-xr-x 24 root    root    4096 May 17 10:32 ..
drwxr-xr-x  2 demo1   demo1   4096 May 17 13:58 demo1
drwxr-xr-x  3 ubuntu  ubuntu  4096 May 17 10:32 ubuntu
drwxr-xr-x  5 vagrant vagrant 4096 May 17 10:42 vagrant

vagrant@ubuntu-bionic:~$ grep demo1 /etc/passwd
demo1:x:1002:1002::/home/demo1:/bin/sh
```
- Удалим пользователя с удаление домашнего каталога
```
vagrant@ubuntu-bionic:~$ sudo userdel -r demo1
userdel: demo1 mail spool (/var/mail/demo1) not found
```
- Посмотрим содержимое каталога шаблона на базе которого будет создан домашний каталог
```
vagrant@ubuntu-bionic:~$ ls -la /etc/skel
total 20
drwxr-xr-x  2 root root 4096 May 14 15:52 .
drwxr-xr-x 91 root root 4096 May 17 14:00 ..
-rw-r--r--  1 root root  220 Apr  4  2018 .bash_logout
-rw-r--r--  1 root root 3771 Apr  4  2018 .bashrc
-rw-r--r--  1 root root  807 Apr  4  2018 .profile
```
- Пересоздадим пользователя с использованием ключа -m
```
vagrant@ubuntu-bionic:~$ sudo useradd -m demo1 -s /bin/bash
```
- Проверим еще раз наличие каталога
```
vagrant@ubuntu-bionic:~$ ls -la /home
total 20
drwxr-xr-x  5 root    root    4096 May 17 14:01 .
drwxr-xr-x 24 root    root    4096 May 17 10:32 ..
drwxr-xr-x  2 demo1   demo1   4096 May 17 14:01 demo1
drwxr-xr-x  3 ubuntu  ubuntu  4096 May 17 10:32 ubuntu
drwxr-xr-x  5 vagrant vagrant 4096 May 17 10:42 vagrant
```
- Проверим параметры пользователя
```
vagrant@ubuntu-bionic:~$ grep demo1 /etc/passwd
demo1:x:1002:1002::/home/demo1:/bin/bash
```
- Установим пароль для пользователя другой утилитой chpasswd которая принимает построчно значение user:password, что может позволить построен скрипт для создание пользователей к примеру
```
vagrant@ubuntu-bionic:~$ sudo chpasswd
demo1:demo1
```
- Попробуем войти
```
vagrant@ubuntu-bionic:~$ su - demo1
Password: 
```
- Посмотрим как работает утилита df, которая выдает значение в байтах
```
demo1@ubuntu-bionic:~$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev              491380         0    491380   0% /dev
tmpfs             100856       596    100260   1% /run
/dev/sda1       40593612   1090260  39486968   3% /
tmpfs             504276         0    504276   0% /dev/shm
tmpfs               5120         0      5120   0% /run/lock
tmpfs             504276         0    504276   0% /sys/fs/cgroup
vagrant        488347692 351468372 136879320  72% /vagrant
tmpfs             100852         0    100852   0% /run/user/1000
```
- Воспользуемся функционалом файла .bashrc и создадим alias на команду df с определенным параметром -h, который организует вывод в более приятный.
```
demo1@ubuntu-bionic:~$ echo "alias df='df -h'" >> ~/.bashrc
```
- Перечитаем конфигурационный файл .bashrc с помощью утилиты source
```
demo1@ubuntu-bionic:~$ source ~/.bashrc
```
- Проверим как работает наш новосозданный alias
```
demo1@ubuntu-bionic:~$ df
Filesystem      Size  Used Avail Use% Mounted on
udev            480M     0  480M   0% /dev
tmpfs            99M  596K   98M   1% /run
/dev/sda1        39G  1.1G   38G   3% /
tmpfs           493M     0  493M   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           493M     0  493M   0% /sys/fs/cgroup
vagrant         466G  336G  131G  72% /vagrant
tmpfs            99M     0   99M   0% /run/user/1000
```
- Выходим
```
demo1@ubuntu-bionic:~$ exit
logout
```
- Еще один способ исполнения команды от имени другого пользователя
```
vagrant@ubuntu-bionic:~$ sudo -u demo1 mkdir /home/demo1/reports
```
- Проверим наличие каталога
```
vagrant@ubuntu-bionic:~$ ls -la /home/demo1/
total 32
drwxr-xr-x 4 demo1 demo1 4096 May 17 14:09 .
drwxr-xr-x 5 root  root  4096 May 17 14:01 ..
-rw------- 1 demo1 demo1  227 May 17 14:07 .bash_history
-rw-r--r-- 1 demo1 demo1  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo1 demo1 3807 May 17 14:06 .bashrc
drwxrwxr-x 3 demo1 demo1 4096 May 17 14:04 .local
-rw-r--r-- 1 demo1 demo1  807 Apr  4  2018 .profile
drwxr-xr-x 2 demo1 demo1 4096 May 17 14:09 reports
```
## Groups
- Создаем простую группу
```
vagrant@ubuntu-bionic:~$ sudo useradd -r service01
```
- Проверим ее наличие
```
vagrant@ubuntu-bionic:~$ grep service01 /etc/```passwd
s#rvice01:x:999:999::/home/service01:/bin/sh

```
- Посмотрим первые 3 строки файла с группами
```
vagrant@ubuntu-bionic:~$ grep root -A3 /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
```
- Посмотрим последний 5 строк от строки с нашей новосозданной группой
```
vagrant@ubuntu-bionic:~$ grep service01 -B5 /etc/group
netdev:x:114:ubuntu
vboxsf:x:115:
vagrant:x:1000:
ubuntu:x:1001:
demo1:x:1002:
service01:x:999:
```
- Посмотрим в каком виде храниться пароль от группы, если конечно он был бы
```
vagrant@ubuntu-bionic:~$ sudo grep service01 /etc/gshadow
service01:!::
```
- У нас есть возможность определить основную группу пользователя по умолчанию (одноименную или users)
```
vagrant@ubuntu-bionic:~$ grep USERGROUPS_ENAB /etc/login.defs
# If USERGROUPS_ENAB is set to "yes", that will modify this UMASK default value
USERGROUPS_ENAB yes
```
- Установим по умолчанию users
```
vagrant@ubuntu-bionic:~$ sudo sed -i -e 's/USERGROUPS_ENAB yes/USERGROUPS_ENAB no/g' /etc/login.defs
```
- Проверим значение данной переменной
```
vagrant@ubuntu-bionic:~$ grep USERGROUPS_ENAB /etc/login.defs
# If USERGROUPS_ENAB is set to "yes", that will modify this UMASK default value
USERGROUPS_ENAB no
```
- Создадим дополнительного пользователя
```
vagrant@ubuntu-bionic:~$ sudo useradd -m demo2 -s /bin/bash
```
- Проверим какая группа основная для ```новосозданного пользователя
```
vagrant@ubuntu-bionic:~$ grep demo /etc/passwd
demo1:x:1002:1002::/home/demo1:/bin/bash
demo2:x:1003:100::/home/demo2:/bin/bash
```
- Проверим какой группе сооответствует GID=100
```
vagrant@ubuntu-bionic:~$ grep 100: /etc/group
users:x:100:
```
- Создадим новую группу
```
vagrant@ubuntu-bionic:~$ sudo groupadd mygroup
```
- Так же может создать новую системную группу
```
vagrant@ubuntu-bionic:~$ sudo groupadd -r service_mygroup
```
- Проверим их наличие
```
vagrant@ubuntu-bionic:~$ grep mygroup /etc/group
mygroup:x:1003:
service_mygroup:x:997:
```
- Установим пароль на нового пользователя
```
vagrant@ubuntu-bionic:~$ sudo chpasswd
demo2:demo2
```
- запретим всем остальным кроме пользователя demo1 и его одноименной группы права на взаимодействие с каталогом reports
```
vagrant@ubuntu-bionic:~$ sudo -u demo1 chmod 770 /home/demo1/reports
```
- Проверим права
```
vagrant@ubuntu-bionic:~$ sudo -u demo2 ls -la /home/demo1/
total 32
drwxr-xr-x 4 demo1 demo1 4096 May 17 14:09 .
drwxr-xr-x 6 root  root  4096 May 17 14:18 ..
-rw------- 1 demo1 demo1  227 May 17 14:07 .bash_history
-rw-r--r-- 1 demo1 demo1  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo1 demo1 3807 May 17 14:06 .bashrc
drwxrwxr-x 3 demo1 demo1 4096 May 17 14:04 .local
-rw-r--r-- 1 demo1 demo1  807 Apr  4  2018 .profile
drwxrwx--- 2 demo1 demo1 4096 May 17 14:09 reports
```
- Проверим возможность прочитать каталог от имени пользователя demo2
```
vagrant@ubuntu-bionic:~$ sudo -u demo2 ls -la /home/demo1/reports
ls: cannot open directory '/home/demo1/reports': Permission denied
```
- Установим пароль на группу
```
vagrant@ubuntu-bionic:~$ sudo gpasswd demo1
Changing the password for group demo1
New Password: 
Re-enter new password: 
```
- Проверим наличие пароля для группы
```
vagrant@ubuntu-bionic:~$ sudo grep demo1 /etc/gshadow
demo1:$6$6fwE3/lDl8W/j.z$WBNheFu9kBK2oJsP0oeIYc3gyI.EaXvyPpKFOEjZpuJQeLRh9gEOdPtM7X65iLRymuby68j0qkbAtE.Ov3tDq/::
```
- Попробуем исполнять действия от имени группы demo1 с помощью утилиты sg
```
vagrant@ubuntu-bionic:~$ sg demo1
Password: 
```
- Обратим к каталогу
```
vagrant@ubuntu-bionic:~$ ls -la /home/demo1/reports
total 8
drwxrwx--- 2 demo1 demo1 4096 May 17 14:09 .
drwxr-xr-x 4 demo1 demo1 4096 May 17 14:09 ..
```
- Выйдем из под групы
```
vagrant@ubuntu-bionic:~$ exit
exit
```
- Перепроверим что потеряли возможность работы с каталогом reports
```
vagrant@ubuntu-bionic:~$ ls -la /home/demo1/reports
ls: cannot open directory '/home/demo1/reports': Permission denied
```
- Первый вариант добавить группу пользователю указать ее при создании, но такая группа будет основная
```
vagrant@ubuntu-bionic:~$ sudo useradd -m demo3 -s /bin/bash -g mygroup
```
- Проверим первичную группу для пользователя demo3
```
vagrant@ubuntu-bionic:~$ grep demo3 /etc/passwd
demo3:x:1004:1003::/home/demo3:/bin/bash
```
- Проверим какой группе соответствует GID=1003
```
vagrant@ubuntu-bionic:~$ grep 1003: /etc/group
mygroup:x:1003:demo2
```
- в следующих 2 вариант мы добавим пользователям demo1 & demo2 группу mygroup
```
vagrant@ubuntu-bionic:~$ sudo usermod -G mygroup demo1
vagrant@ubuntu-bionic:~$ sudo usermod -G mygroup demo2
```
- Так же добавим еще одну группу через параметр -G
```
vagrant@ubuntu-bionic:~$ sudo usermod -G ubuntu demo1
```
- Так же добавим еще одну группу через параметр -aG
```
vagrant@ubuntu-bionic:~$ sudo usermod -aG ubuntu demo2
```
- Проверим наличие пользователей в группе ubuntu
```
vagrant@ubuntu-bionic:~$ grep ubuntu: /etc/group
ubuntu:x:1001:demo1,demo2
```
- Разница в том что для demo1 группа ubuntu перезатерла первую вторичную группу, случае -aG добавила
```
vagrant@ubuntu-bionic:~$ grep mygroup: /etc/group
mygroup:x:1003:demo2
```
-  заблокируем пользователя
```
vagrant@ubuntu-bionic:~$ sudo usermod -L demo1
```
-  Попробуем войти
```
vagrant@ubuntu-bionic:~$ su - demo1
Password: 
su: Authentication failure
```
- Разблокируем пользователя
```
vagrant@ubuntu-bionic:~$ sudo usermod -U demo1
```
- Проверим вход
```
vagrant@ubuntu-bionic:~$ su - demo1
Password: 
demo1@ubuntu-bionic:~$ exit
logout
```
- Сделаем пароль пользователя не валидным, для инициирования принудительной смены
``` vagrant@ubuntu-bionic:~$ sudo passwd -e demo1
passwd: password expiry information changed.
```
- Попробуем войти под пользователем и встретим приглашение на смену пароля
```
vagrant@ubuntu-bionic:~$ su - demo1
Password: 
You are required to change your password immediately (root enforced)
Changing password for demo1.
(current) UNIX password: 
Enter new UNIX password: 
Retype new UNIX password:
```
## Управление свойствами пароля

-  Посмотрим справку утилиты chage
vagrant@ubuntu-bionic:~$ chage --help
```
Usage: chage [options] LOGIN

Options:
  -d, --lastday LAST_DAY        set date of last password change to LAST_DAY
  -E, --expiredate EXPIRE_DATE  set account expiration date to EXPIRE_DATE
  -h, --help                    display this ```help message and exit
  -#, --inactive INACTIVE       set password 
  inactive after expiration
                                to INACTIVE
  -l, --list                    show account aging information
  -m, --mindays MIN_DAYS        set minimum number of days before password
                                change to MIN_DAYS
  -M, --maxdays MAX_DAYS        set maximim number of days before password
                                change to MAX_DAYS
  -R, --root CHROOT_DIR         directory to chroot into
  -W, --warndays WARN_DAYS      set expiration warning days to WARN_DAYS
```
- Попробуем в интерактивном режиме сменить значения для пользователя demo1 
```
vagrant@ubuntu-bionic:~$ sudo chage demo1
Changing the aging information for demo1
Enter the new value, or press ENTER for the default

        Minimum Password Age [0]: 15
        Maximum Password Age [99999]: 30
        Last Password Change (YYYY-MM-DD) ```[2021-05-17]: 
      # Password Expiration Warning [7]: 
     
        Password Inactive [-1]: 2
        Account Expiration Date (YYYY-MM-DD) [-1]: 
vagrant@ubuntu-bionic:~$ 
```
- Значение умолчанию
- Определены в /etc/login.defs
```
vagrant@ubuntu-bionic:~$ grep ^PASS_ /etc/login.defs
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_WARN_AGE   7
```
- А так же в /etc/default/useradd
```
vagrant@ubuntu-bionic:~$ grep INACTIVE -B2 -A3 /etc/default/useradd
# The number of days after a password expires until the account 
# is permanently disabled
# INACTIVE=-1
# The default expire date
# EXPIRE=
```

### Права
- Создадим под пользователем demo2 каталог Catalog
```
vagrant@ubuntu-bionic:~$ su - demo2
Password: 
demo2@ubuntu-bionic:~$ pwd
/home/demo2
demo2@ubuntu-bionic:~$ mkdir catalog
demo2@ubuntu-bionic:~$ ls
catalog
demo2@ubuntu-bionic:~$ exit
logout
```
- Будем права под пользователем с правами root
```
vagrant@ubuntu-bionic:~$ cd /home/demo2
vagrant@ubuntu-bionic:/home/demo2$ ls
catalog
```
- Переопределим владельца
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chown demo1 catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls
catalog
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwxr-xr-x 2 demo1 users 4096 May 17 16:01 catalog
```
- Переопределим группу
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chgrp demo1 catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwxr-xr-x 2 demo1 demo1 4096 May 17 16:01 catalog
```
- Переопределим владельца с пустым полем группы
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chown demo2: catalog/
```
- Получим в качестве группы primary группу владельца
```
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwxr-xr-x 2 demo2 users 4096 May 17 16:01 catalog
```
- забем права на исполнение
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chmod a-x catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drw-r--r-- 2 demo2 users 4096 May 17 16:01 catalog
```
- Назначим права на все типы обьектов
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chmod u+rwx,g+wrx,o+rwx catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwxrwxrwx 2 demo2 users 4096 May 17 16:01 catalog
```
- Определим так же права с помощью цифровых значений
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chmod 755 catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwxr-xr-x 2 demo2 users 4096 May 17 16:01 catalog
```
- Добавим дополнительные биты
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chmod 4755 catalog/
vagrant@ubuntu-bionic:/home/demo2$ ls -la
total 28
drwxr-xr-x 3 demo2 users 4096 May 17 16:01 .
drwxr-xr-x 7 root  root  4096 May 17 14:31 ..
-rw------- 1 demo2 users   88 May 17 16:02 .bash_history
-rw-r--r-- 1 demo2 users  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 demo2 users 3771 Apr  4  2018 .bashrc
-rw-r--r-- 1 demo2 users  807 Apr  4  2018 .profile
drwsr-xr-x 2 demo2 users 4096 May 17 16:01 catalog
```
- Определим максимальные полномочия для всех пользователей
```
vagrant@ubuntu-bionic:/home/demo2$ sudo chmod 777 catalog/
```

### ACL
- Создадим новые файлы и посмотрим на права через утилиту getfacl
```
vagrant@ubuntu-bionic:/home/demo2$ cd catalog/
vagrant@ubuntu-bionic:/home/demo2/catalog$ touch file01
vagrant@ubuntu-bionic:/home/demo2/catalog$ touch file02
vagrant@ubuntu-bionic:/home/demo2/catalog$ getfacl file01
# file: file01
# owner: vagrant
# group: vagrant
user::rw-
group::rw-
other::r--
```
- Определим отдельные полномочия для пользователя demo3
```
vagrant@ubuntu-bionic:/home/demo2/catalog$ setfacl -m u:demo3:rwx file01
vagrant@ubuntu-bionic:/home/demo2/catalog$ getfacl file01
# file: file01
# owner: vagrant
# group: vagrant
user::rw-
user:demo3:rwx
group::rw-
mask::rwx
other::r--
```

### Управление SUDO
- Посмотрим базовый конфиг
```
vagrant@ubuntu-bionic:/home/demo2/catalog$ sudo cat /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```
- Так же посмотрим дополнительные правила, что является хорошей практикой, так как базовый конфиг может менять в релизах
```
vagrant@ubuntu-bionic:/home/demo2/catalog$ sudo ls -la /etc/sudoers.d
total 20
drwxr-x---  2 root root 4096 May 17 10:32 .
drwxr-xr-x 91 root root 4096 May 17 14:45 ..
-r--r-----  1 root root  152 May 17 10:32 90-cloud-init-users
-r--r-----  1 root root  958 Jan 18  2018 README
-r--r-----  1 root root   31 May 14 16:40 vagrant
```
- Перейдем под root и создадим свои правила для пользователя demo2 с использованием User Alias & Command Alias
```
vagrant@ubuntu-bionic:/home/demo2/catalog$ sudo su

root@ubuntu-bionic:/home/demo2/catalog# echo "Cmnd_Alias CMD=/bin/ls -l /root" >> /etc/sudoers.d/myrule

root@ubuntu-bionic:/home/demo2/catalog# echo "User_Alias ADMINS=demo1,demo2,demo3" >> /etc/sudoers.d/myrule

root@ubuntu-bionic:/home/demo2/catalog# echo "ADMINS  ALL=(ALL) NOPASSWD:  CMD" >> /etc/sudoers.d/myrule 

root@ubuntu-bionic:/home/demo2/catalog# exit

exit
```
- Проверим возможность исполнение заданной команды под пользователем demo2
```
demo2@ubuntu-bionic:~$ sudo ls -l /root
total 0
```