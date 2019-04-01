## Коллекции для тестирования загрузки файлов на Яндекс.Диск

-- [Коллекция для тестирования основной функциональности загрузки файлов](#main_tests)

-- Коллекция для тестирования:
   * [срока действия ссылки для загрузки файлов](#additional)
   * [загрузки больших файлов на диск](#additional)

-- [Коллекция для заполнения тестовыми данными Я.Диск](#upload)

-- [Коллекция для удаления данных с диска (запускается перед каждой новой коллекцией)](#delete_files)

----
#### Приложения для установки
* Node.js
* npm
* newman
* postman (optional)

#### Документация
[Документация API Диска Яндекс](https://tech.yandex.ru/disk/api/concepts/about-docpage/)
---

### Коллекции с данными:

1. [YaDisk_upload_file.postman_collection.json](#tests_upload)
   * [upload_data.json](#upload_data)

2. [YADisk_upload_file_iteration.postman_collection.json](#upload_file_iteration)
   * [data_long_wait_and_large_files.csv](#data_long_large_files)

3. [YADisk_test_data.postman_collection.json](#test_upload)

4. [YADisk_delete_before_running_the_scripts.postman_collection.json](#delete_files)

### Файл с данными об окружении:

1. [dev.postman_environment.json](#env)

-------
#### Условия запуска тестов

Перед запуском любой из коллекции, необходимо запустить ***YADisk_delete_before_running_the_scripts.postman_collection.json*** с указанием окружения для очистки Я.Диск.

Для запуска тестов c помощью коллекции ***YADisk_upload_file_iteration.postman_collection.json*** необходимо дополнительно создать файлы больших размеров (в репозитории в папке files они отсутствуют).

В готовых данных для запуска я использовала файлы:

* ***9_99GbTestData.png*** размером 9,99ГБ

* ***2GbTestData.png*** размером 2ГБ

Создать файлы в Linux терминале можно командой:
```
fallocate -l 2G files/2GbTestData.png; fallocate -l 10229M files/9_99GbTestData.png
```
Команда для запуска коллекций выглядит следущим образом:

newman run <название коллекции> -e <файл с окружением> -d <файл с данными для коллекции>

Пример запуска тестов через newman(из директории, где лежат коллекции):
```
newman run YADisk_upload_file.postman_collection.json -e dev.postman_environment.json -d upload_data.json
```

### Данные окружения
**<a name="env"></a> dev.postman_environment.json**

Файл содержит следующие данные:
- headers (значение обязательных заголовков)
- auth (данные для авторизации)
- folder_path (путь к папке с файлами для загрузки)

 ### Коллекции
#### <a name="tests_upload"></a> YADisk_upload_file.postman_collection.json

***Получение ссылки - запрос на получение ссылки для загрузки файла***

1. Папка "single iteration" - все тесты для первой итерации (с постоянными параметрами. Без возможности воздействия через файл с данными):

   * To verify Users Ya Disk - проверка, что ЯДиск пуст при первой итерации. При последующих перенаправление на один из запросов в папке "loop get links with different data" в зависимости от подаваемых данных)
   * To get test link for upload - проверка стандартного запроса на получение ссылки для "test.txt" без дополнительных параметров
   * upload test file - загрузка файла по полученной ссылке
   * upload test file without attach - отправка запроса по полученной ссылке без вложения
   * To get link without token - отправка запроса на получение ссылки без токена
   * To get link with invalid token - отправка запроса на получение ссылки с невалидным токеном
   * To get link without headers - отправка запроса на получение ссылки без обязательных заголовков (Accept, Content-Type)
   * To get link with wrong/xml headers - отравка запроса на получение ссылки с невалидными значениями в заголовках (xml вместо json)
   * To get link without required filds - отправка запроса на получение ссылки без обязательных полей

2. Папка "loop get links with different data" с шаблонами запросов на получение ссылки с разными параметрами с использованием данных из файла "upload_data.json":
   * To get link with requiered param - получение ссылки с указанием обязательного параметра и проверка ответа на наличие перечисленных полей
   * To get link with overwrite param - получение ссылки с указанием необязательного параметра "overwrite" (возможность перезаписывать уже имеющийся файл) и проверка ответа на наличие перечисленных полей
   * To get link with fields param - получение ссылки с указанием необязательного параметра "fields" (перечисление полей, которые должны вернуться в ответе) и проверка наличия этих полей в ответе
   * To get link with all param - получение ссылки со всеми параметрами (обязательным - path, необязательными - overwrite, fields) и проверка наличия указанных полей в ответе

3. Upload file - отправка файла по ранее полученной ссылке на загрузку
4. To verify uploaded file - проверка наличия файла в ЯДиске после его загрузки по пути, который отправляли в запросе на получение ссылки

**<a name="upload_data"></a> Структура данных upload_data.json**

Файл ***upload_data.json*** в формате json может содержать следующие поля:

-- "comment" содержит комментарий к проверке. Создан исключительно для удобства понимания при прочтении файла. Данные в тестах не используются

-- "linkPath" содержит путь к файлу на ЯДиске. Может быть как относительный, так и абсолютный. По документации необходимо использовать путь в формате url.

-- "linkStatusCode" содежит ожидаемый код ответа на запрос для получения ссылки

-- "responseFields" содежит массив названия полей, которые должны присутствовать в ответе на запрос для получения ссылки

-- "method" содежит метод, который должен быть указан в поле "method" в ответе на запрос для получения ссылки. Ключ "method" можно не указывать, если предполагается, что в ответе этого поля не будет

-- "file" - название файла, который будет загружен (без указания пути к этому файлу. Путь ко всем файлам указан отдельно в environment "dev.postman_environment.json"). Ключ "file" можно не указывать, если предполагается, что ссылка не была получена при предыдущем запросе, либо ожидаемый запрос пришел с ошибкой.

-- "uploadStatusCode" содежит код ответа на запрос загрузки файла. Ключ "uploadStatusCode" можно не указывать, если предполагаемый запрос на получение ссылки содержит ошибку или ссылка отсутствует.

-- "linkPath1" содержит первую часть пути к файлу на ЯДиск в том случае, если путь длинный

-- "linkPath2" содержит вторую часть пути к файлу на ЯДиск в том случае, если путь длинный

-- "overwrite" содержит boolean значение. Ключ не указывается в случае, если планируется не передавать значение в параметрах запроса

-- "fields" содежит список полей через запятую, которые должны быть возвращены в ответе. Ключ не указывается, если не планируется передавать этот необязательный параметр в запросе.

#### <a name="upload_file_iteration"></a> YADisk_upload_file_iteration.postman_collection.json

Универсальный пул запросов для следующего вида запросов:

* проверка срока действия ссылки
* проверка загрузки больших файлов
* простая проверка на загрузку файла с минимально обязательными параметрами
* проверка запроса с отложенной отправкой (secTimeOut перед отправкой запроса)

1. To get link - запрос с обязательным параметром ("path") для получения ссылки

2. Upload file - запрос для загрузки файла с вложением

3. To verify uploaded file - запрос для проверки наличия загруженного файла на ЯДиске по пути, указанному в первом запросе


**<a name="data_long_large_files"></a> Структура данных data_long_wait_and_large_files.csv**

Файл ***data_long_wait_and_large_files.csv*** в формате csv, разделитель запятая. Содержит следующие данные:

-- linkPath - путь до файла в ЯДиске

-- linkStatusCode - ожидаемый код ответа на запрос ссылки

-- timeOut - boolean значение. True указывается, если нужна задержка в отправке запроса. False указывается, если задержка не нужна

-- minTimeOut - время в мин. для задержки отправки запроса. Значение не обрабатывается, если в предыдущей ячейке (timeOut) стоит false. Следовательно, если временная задержка не нужна, поле можно оставить пустым, либо проставить 0

-- secTimeOut - время в сек. для задержки отправки запроса. Значение не обрабатывается, если в предыдущей ячейке (timeOut) стоит false. Следовательно, если временная задержка не нужна, поле можно оставить пустым, либо проставить 0

-- file - название файла с расширением без пути до папки с файлом. Путь указывается отдельно в environment (dev.postman_environment.json)

-- uploadStatusCode - код ответа, который ожидается после загрузки файла

#### <a name="test_upload"></a> YADisk_test_data.postman_collection.json

В коллекции прописана переменная с необходимым свободным местом на диске и рекурсивной загрузкой файла до тех пор, пока пространство на диске будет меньше либо равно указанному числу.

Значение переменной можно вручную поменять (число в байтах):

```
"const necessarySpace = 2147483648;"
```
**Загрузка тестовых данных** на Я.Диск осуществляется с помощью запроса на получение ссылки (к названию файла добавляется рандомное число от 1 до 13) и загрузки одного и того же файла, размером 2GB.

#### <a name="delete_files"></a> YADisk_delete_before_running_the_scripts.postman_collection.json

Сначала осуществляется запрос для проверки свободного места на Я.Диск. Если диск пуст, то последующие запросы не отправляются.

Если диск не пустой, то делается запрос плоского списка загруженных файлов. И для каждого файла из этого списка посылается запрос на удаление.

### Проверки
**<a name="main_tests"></a> Основные** тесты на загрузку файла
* простая проверка загрузки файла без дополнительных параметров
* проверка загрузки файла без вложения
* проверка запроса ссылки без токена
* проверка запроса с невалидным токеном
* проверка запроса без обязательных заголовков
* проверка запроса с неправильными заголовками (accept, content-type xml вместо json)
* проверка запроса без обязательного поля
* проверка абсолютного пути
* проверка относительного пути до корневой директории
* проверка относительного пути до некорневой директории (заранее создана папка test в корневой директории)
* проверка невалидного относительного пути в некорневой директории
* проверка пути незакодированного в формате url
* проверка запроса с длинным названием пути, например, 255 символов и вложением с отличным от пути названием.
* проверка запроса с длинным названием пути, например, 256 символов и вложением с другим названием.
* проверка запроса на загрузку уже имеющегося на диске файла (без указания параметра перезаписи)
* проверка запроса с пустым значением "overwrite"
* проверка запроса с overwrite = false и с указанием пути к уже существующему на диске файлу
* проверка запроса с overwrite = true и вложением с названием, не совпадающим с названием в пути до файла на ЯДиске
* проверка запроса с overwrite = true и с вложением, которое уже было загружено на YADisk ранее
* проверка запроса с overwrite невалидным значением и ранее загруженным файлом.
* проверка запроса с параметром fields = href
* проверка запроса с невалидным параметром fields  
* проверка запроса с несколькими значениями fields, одно из которых невалидно
* проверка запроса со всеми валидными параметрами (path, overwrite, fields)

**<a name="additional"></a> Дополнительные** проверки на загрузку файла
* загрузка файла с небольшой задержкой после получения ссылки
* загрузка файла с задержкой в 29мин.59сек после получения ссылки
* загрузка файла с задержкой в 30мин после поулчения ссылки
* загрузка файла с задержкой в 30мин01сек после получения ссылки
* загрузка большого файла, например, 9,99ГБ
* загрузка файла, по размерам превышающего свободное пространство на ЯДиске

В случае с последним пунктом, во избежании зависимости от других тестов, можно сделать дополнительную проверку, чтобы файл грузился только тогда и только тот, который превышает место на диске, либо запустить тест отдельно, предварительно заполнив свободное пространство на диске тестовыми данными. Для этого можно воспользоваться коллекцией YADisk_test_data.postman_collection.json
