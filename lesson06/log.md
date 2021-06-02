### Настройка сервера отправки

- Установка syslog-ng 
```
root@Server:/home/vagrant# apt update
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease

root@Server:/home/vagrant# apt install syslog-ng
Reading package lists... Done
```
- Расширение конфигурации syslog-ng полями
```
root@Server:/home/vagrant# nano /etc/syslog-ng/syslog-ng.conf 
root@Server:/home/vagrant# cat /etc/syslog-ng/syslog-ng.conf | grep -A4 "options {"
options { chain_hostnames(off); flush_lines(0); use_dns(no); use_fqdn(yes); keep_hostname(yes);
          owner("root"); group("adm"); perm(0640); stats_freq(0);
          bad_hostname("^gconfd$");
};
```
-  Создаем правило источника
```
root@Server:/home/vagrant# nano /etc/syslog-ng/conf.d/src.conf
root@Server:/home/vagrant# ll /etc/syslog-ng/conf.d/
total 12
drwxr-xr-x 2 root root 4096 May 30 06:49 ./
drwxr-xr-x 4 root root 4096 May 30 06:46 ../
-rw-r--r-- 1 root root   84 May 30 06:49 src.conf
root@Server:/home/vagrant# cat /etc/syslog-ng/conf.d/src.conf 
Server s_net {
    tcp (
        ip (0.0.0.0)
        port (514)
        max-connections (300)
    );
};
```
- Создаем правило назначения
```
root@Server:/home/vagrant# nano /etc/syslog-ng/conf.d/dst.conf
root@Server:/home/vagrant# cat /etc/syslog-ng/conf.d/dst.conf 
destination d_slog {
    file (
        "/var/log/remote/$HOST/$FACILITY/$DAY-$MONTH-$YEAR/syslog.log"
        create_dirs(yes)
    );
};
```
- Формируем правило обработки логов
```
root@Server:/home/vagrant# nano /etc/syslog-ng/conf.d/log.conf
root@Server:/home/vagrant# cat /etc/syslog-ng/conf.d/log.conf 
log {
    Server(s_net);
    destination(d_slog);
};
```
- Проверяем синтаксис и перезапускаем сервис
```
root@Server:/etc/syslog-ng/conf.d# syslog-ng -s
root@Server:/etc/syslog-ng/conf.d# systemctl restart syslog-ng
root@Server:/etc/syslog-ng/conf.d# netstat -an -4 | grep :514
tcp        0      0 0.0.0.0:514             0.0.0.0:*               LISTEN
```

### Настройка сервера приема сообщений

- Установка syslog-ng
```
root@Client:/home/vagrant# apt update
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease

root@Client:/home/vagrant# apt install syslog-ng
Reading package lists... Done
```
- Расширение конфигурации syslog-ng полями
```
root@Client:/home/vagrant# nano /etc/syslog-ng/syslog-ng.conf 
root@Client:/home/vagrant# cat /etc/syslog-ng/syslog-ng.conf | grep -A4 "options {"
options { chain_hostnames(off); flush_lines(0); use_dns(no); use_fqdn(yes); keep_hostname(yes);
          owner("root"); group("adm"); perm(0640); stats_freq(0);
          bad_hostname("^gconfd$");
};
```
- Правило приема сообщений
```
root@Client:/etc/syslog-ng# nano ./conf.d/src.conf
root@Client:/etc/syslog-ng# cat ./conf.d/src.conf 
source s_slog {
    file (
        "/var/log/syslog"
        program_override("syslog")
    );
};
```
- Правило сохранения
```
root@Client:/etc/syslog-ng# nano ./conf.d/dst.conf
root@Client:/etc/syslog-ng# cat ./conf.d/dst.conf 
destination d_logserver {
    tcp (
        10.0.0.11
        port (514)
    );
};
```
- Запускаем правило
```
root@Client:/etc/syslog-ng# nano ./conf.d/log.conf
root@Client:/etc/syslog-ng# cat ./conf.d/log.conf 
log {
    source (s_slog);
    destination (d_logserver);
};
```
- Проверяем конфигурация и перезапускаем сервис
```
root@Client:/etc/syslog-ng# syslog-ng -s
root@Client:/etc/syslog-ng# systemctl restart syslog-ng
```

### Проверка работоспособности

- Новые файлы создаются согласно структуре определенной в dst
```
root@Server:/home/vagrant# tree /var/log/remote
.
└── client.hillel.ua
    └── user
        └── 30-05-2021
            └── syslog.log

3 directories, 1 file
```