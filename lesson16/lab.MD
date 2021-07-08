# Практика работы с Git и GitHub

## Конфигурация клиента

- устанавливаем git по ссылке https://git-scm.com/download
- конфигурирует пользователя под которым будем работать
```
    git config --global user.name "Vasil Chumak"
    git config --global user.email vasil.chumak@gmail.com
    # email должен совпадать с вашей учетной записью GitHub, для проверки полномочий на доступ в проект
```

- Создаем пустой каталог для лабораторной работы
- Переходи в него и инициализурет git проект.
```
    git init
```

## Базовые действия

- Cоздаем файл
```
    echo "First line in project" >> file.txt
    git status # смотрит статус untracked
```
- Добавляем в index
```
    git add file.txt
    git status # смотрим статус staged
    git diff --cached # смотрим проиндексированные изменения
```
- Добавляем изменения в историю
```
    git commit -m "First commit"
    git log # смотрим историю коммитов
    git show # смотрим информацию о коммите
```
- Добавляем новые изменения
```
    echo "London is the capital of GB" >> file.txt
    git diff # непроиндексированные изменения, сравните с git diff --cached
    git commit -am "Capital added" # удалось ли нам сделать комит без добавления в Index или в Index мы все же добавляем изменения перед комитом?
    git log # проверяем в истории, сделали ли мы комит
    # Попробуем обновить коммит, дополнительными действиями
    echo "Moscow is the capital of Russia" >> file.txt
    git add file.txt
    git commit --amend # поменяйте сообщение, что добавлена была не одна столица, а несколько
    git log # проверяем кол-во коммитов
    git show # смотрим содержание последнего коммита
```
## Самостоятельно отработайте следующее

- Paris is the capital of France в конец файла и сохраните с комментарием в коммите "Another capital was added"

## Откат действий

- Возьмите hash 2 коммита из git log и откатите изменения из него (example)
```
    git revert 5re2sf3 # Рекомендуется ипользовать первые 7 символов или HEAD~1
```
- Должен возникнуть конфликт из-за ранее созданого 3 коммита
- Решаем конфликт
```
    git status
    cat file.txt
    First line in project
    <<<<<<< HEAD
    London is the capital of GB
    Moscow is the capital of Russia
    Paris capital of France
    =======
    >>>>>>> parent of bb14131 (Capital added)
    git show HEAD~1 # смотрим какие строчки были добавлены  в данном коммите
```
- Убираем строчки добавленные в рамках того коммита
```
    First line in project
    <<<<<<< HEAD
    Paris capital of France
    =======
    >>>>>>> parent of bb14131 (Capital added)
```
- Убираем технические поля
```
    First line in project
    Paris capital of France
```
- Добавляем изменения в index
```
    git add file.txt
    git revert --continue
    git log
    git show
```
## Работа с gitignore
- Создаем временный файл
```
    echo "this is a garbage file" | tee garbage1.tmp garbage2.tmp
    git status
```
- Создайте gitignore и добавьте данные файл в исключения, через фильтр по расширению
- Проверьте их отсутствие для добавления в index
```
    git status
```
- Добавьте Ваш gitignore в index и создайте коммит для его сохранения.

## Index
- Попробуйте воссоздать случай когда файл file.txt находиться в двух состояниях одновременно
```
    git status

    On branch master
    Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
	modified:   file.txt

    Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
	modified:   file.txt
```
- Исправьте ситуация за счет добавления всех изменений в коммит, со следующим состоянием
```
➜  new_tmp git:(master) git status
On branch master
nothing to commit, working tree clean
```

## Работа с ветками

- Создаем ветку
```
    git branch first # создает ветку
    git branch # смотрим локальные ветки
    git checkout first # переключаемся
    git checkout -b second # создаем дополнительную
    git status # проверяем текущую ветку
    git branch # смотрим локальные ветки
```
- Внесем изменения в текущую ветку
```
    echo "Let's change the branch" > branch.txt
```
- Закомитьте данные правки с комментарием "Branch was changed"
- Переключаемся на первую ветку
```
    git checkout first
    echo "And this branch too" > first.txt
    git add first.txt
    git commit -m "First branch changed"
```
- Строим граф изменений
```
    git log --all --decorate --oneline --graph
    git config --global alias.g 'log --all --decorate --oneline --graph'
    git g
```
- Попробуйте выполнить!
- Проведем слияние веток
```
    git checkout master
    ls
    git merge first
    ls
    git g # merge прозошел без создания дополнительного коммита
    git checkout second
    git rebase master
    git g # история ветки изменилась
```
- Удалем ветку first
```
    git branch -d first
    git branch # смотрим оставшиеся ветки
```
- Прекращаем действия с данным репозиторием

## Отправляем изменения в origin

- Создайте пустой репозиторий под своим аккаунтов GitHub
- Добавляем remote в Ваш текущий локальный проект
```
    git remote add origin git@github.com:<YourUserName>/lab-git.git
```
- Отправим все ветки в remote
```
    git push origin -u --all
```

## Отправка на проверку

- Установите **Change repository visibility: This repository is currently private**
- Пригласите sergeykudelin как участника проекта.
- Линк на репозиторий продублируйте в описание домашнего задания.