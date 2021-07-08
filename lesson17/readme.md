# Ansible

## Находим и fork-ем свой репозиторий

https://github.com/hillel-devops-052021/YourLogin-hw

## Создаем новую ветку hw-ansible-01

## Установка и конфигурация

- Установите и проверьте доступность на вашем локальном окружении python.
    
    NOTICE: Хорошей практикой является использование виртуальных окружений. Почитать можно здесь:
    
    https://pipenv.pypa.io/en/latest/

    https://virtualenv.pypa.io/en/latest/

    https://docs.python.org/3/library/venv.html

- Проверьте версию python
```
python --version
```
- Создайте каталог ansible в корне репозитория

- Создайте в директории ansible файл requirements.txt с содержимым
```
ansible>=2.9
```
- Установите ansible на базе файла requirements.txt любым из выбранных вами вариантом.
```
    For example:
    pipenv install -r requirements.txt
    pip install -r requirements.txt
    pip install ansible>=2.9
```
- Проверяем наличие ansible
```
    ansible --version
```

## Подготовим host над которым будет выполнять действия

- Установим Vagrant если его еще нет - https://www.vagrantup.com/downloads
- Создадим Vagrant файл с описание нескольких VM
```
    Vagrant.configure("2") do |config|
  
        config.vm.define "web" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.hostname = 'web'
        end

        config.vm.define "db" do |db|
            db.vm.box = "ubuntu/bionic64"
            db.vm.hostname = 'db'
        end

    end
```
- Посмотрим как мы можем работать с VM под Vagrant
```
    vagrant ssh-config
    Host web
    HostName 127.0.0.1
    User vagrant
    Port 2200
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile /Users/sergeykudelin/GIT/hillel/Labs/lesson17/.vagrant/machines/web/virtualbox/private_key
    IdentitiesOnly yes
    LogLevel FATAL

    Host db
    HostName 127.0.0.1
    User vagrant
    Port 2201
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile /Users/sergeykudelin/GIT/hillel/Labs/lesson17/.vagrant/machines/db/virtualbox/private_key
    IdentitiesOnly yes
    LogLevel FATAL

```
- На базе полученной информации сформирует inventory файл
```
    web ansible_host=127.0.0.1 ansible_port=2200  ansible_user=vagrant ansible_private_key_file=.vagrant/machines/web/virtualbox/private_key
    db ansible_host=127.0.0.1 ansible_port=2201  ansible_user=vagrant ansible_private_key_file=.vagrant/machines/db/virtualbox/private_key
    
```
- Проверим корректность подключения через ansible
```
    ansible web -i ./inventory -m ping
    The authenticity of host '[127.0.0.1]:2201 ([127.0.0.1]:2201)' can't be established.
    ECDSA key fingerprint is SHA256:W7Y377oDtA14Vk3VmgYhCpSkkP1NTUw0zx5ITgsZXYs.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    127.0.0.1 | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python3"
        },
        "changed": false,
        "ping": "pong"
    }
```
- Создадим базовый конфиг, так как:

    Для того чтобы управлять инстансами нам приходится вписывать много данных в наш инвентори файл. К тому же, чтобы использовать данный инвентори, нам приходится каждый раз указывать его явно, как опцию команды ansible. Многое из этого мы можем определить в конфигурации Ansible. Для того чтобы настроить Ansible под нашу работу, создадим конфигурационный файл для него ansible.cfg в директории ansible.

```
    curl https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg --output ansible.cfg
```
- Теперь у нас есть возможность указать глобальные настройки и не повторяться в inventory файле, к пример
```
    [defaults]
    inventory = ./inventory
    remote_user = vagrant
    host_key_checking = False
    retry_files_enabled = False
```
- Уберите самостоятельно все общие значения из файла inventory

##  Работа с группой хостов

- Управление при помощи Ansible отдельными хостами становится неудобно, когда этих хостов становится более одного. В инвентори файле мы можем определить группу хостов для управления конфигурацией сразу нескольких хостов. Определим группы хостов в инвентори файле. Изменим инвентори файл следующим образом

```
    [web_hosts]
    web ansible_host=127.0.0.1 ansible_port=2200  ansible_user=vagrant ansible_private_key_file=.vagrant/machines/web/virtualbox/private_key
    [db_hosts]
    db ansible_host=127.0.0.1 ansible_port=2201  ansible_user=vagrant ansible_private_key_file=.vagrant/machines/db/virtualbox/private_key
```
- Проверим подключение через группы
```
    ansible web_hosts -i ./inventory -m ping
```
- Провери подключение на все хосты
```
    ansible all -i ./inventory -m ping
```
- !!! Самостоятельно попробуйте сформировать inventory в формате yaml и так же проверьте возможность подключиться через ansible
```
    ansible web -i ./inventory -m ping
    ansible db -i ./inventory -m ping
    ansible web_hosts -i ./inventory -m ping
    ansible db_hosts -i ./inventory -m ping
    ansible all -i ./inventory -m ping
```

## ad hoc

- Попробуем проверить версию python на хостах
```
    ansible web -m command -a 'python3 --version'
    web | CHANGED | rc=0 >>
    Python 3.6.9
```
- Попробуйте аналогичную операцию с двумя командами
```
    ansible web -m command -a 'python3 --version; uname -a'
    web | FAILED | rc=2 >>
    Unknown option: --
    usage: python3 [option] ... [-c cmd | -m mod | file | -] [arg] ...
    Try `python -h' for more information.non-zero return code
```
- Попробуем аналогично 2 команды но через shell
```
    ansible web -m shell -a 'python3 --version; uname -a'
    web | CHANGED | rc=0 >>
    Python 3.6.9
    Linux web 4.15.0-143-generic #147-Ubuntu SMP Wed Apr 14 16:10:11 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```
- почему?
    
    Модуль command выполняет команды, не используя shell, поэтому в нем не работают перенаправления потоков и нет доступа к некоторым переменным окружения.

## Дальше будем развавать репозиторий...