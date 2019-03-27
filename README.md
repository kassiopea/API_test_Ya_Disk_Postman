

## Необходимые программы для установки
* Node.js
* npm
* newman
* postman (optional)
----------------------

1. [Подготовка среды. Установка необходимых приложений](#installation)
2. [Содержание тестов](#tests_contains)


### <a name="installation"></a> Подготовка среды в linux (Ubuntu, linux mint)

Для пакетной установки всех файлов перейдите в директорию с проектом и запустите в консоли:
```
env.sh
```
Этот скрипт установит все программы из списка. Чтобы установить программы отдельно, установите:

**node.js**
```
sudo apt install nodejs
```

**npm**

```
sudo apt install -g npm
```

**newman**

Находясь в директории проекта запустите:

```
npm init
```

Для newman я использовала newman-reporter-html отображения отчетов.

```
sudo npm install -g newman-reporter-html
```

**Postman**
Есть несколько способов поставить Postman. Один из них с помощью snap. Для этого сначала поставим snap
```
sudo install snap
```
А затем и сам Postman

```
sudo snap install postman
```
Postman можно установить и [другим способом](https://learning.getpostman.com/docs/postman/launching_postman/installation_and_updates/#linux-installation).


###<a name="tests_contains"></a>Содержание тестов
