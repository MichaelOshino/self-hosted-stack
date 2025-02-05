# Проект личного сервера

В данном репозитории солянка из разного ПО, в основном полезного для личного пользования:  
[Firefly-III](https://github.com/firefly-iii/docker) - учет финансов;  
[Mailu](https://github.com/Mailu/Mailu) - почта;  
[Nextcloud](https://github.com/nextcloud/docker) - облако;   
[Ryot](https://github.com/IgnisDa/ryot) - трекер для отслеживания всякого, от дневника тренировок до просмотренных анимок;  
[WG-Easy](https://github.com/wg-easy/wg-easy) - VPN wireguard.

Ниже представлено описание структуры и инструкции по настройке.

__________________________

## Структура проекта

```
.
├── docker-compose.firefly.yml
├── docker-compose.mailu.yml
├── docker-compose-manager.sh
├── docker-compose.networks.yml
├── docker-compose.nextcloud.yml
├── docker-compose.nginx-rp.yml
├── docker-compose.ryot.yml
├── docker-compose.wireguard.yml
├── env                                # Файлы с переменными окружений
│   ├── firefly-app.env
│   ├── firefly-mariadb.env
│   ├── mailu.env
│   ├── nextcloud.env
│   ├── nginx-rp.env
│   ├── ryot-app.env
│   ├── ryot-postgres.env
│   └── wireguard.env
├── services-data                      # Директория с данными сервисов
│   └── nginx-rp                       # Директория с конфиками nginx, который используется как реверс прокси
│       ├── nginx.conf
│       ├── sites-available
│       └── sites-enabled
│           ├── default.conf.template
│           ├── firefly.conf.template
│           ├── mailu.conf.template
│           ├── nextcloud.conf.template
│           ├── ryot.conf.template
│           └── wireguard.conf.template
└── ssl-certificates                   # SSL сертификаты
    ├── mailu
    └── nginx-rp

```

Дополнительно в `services-data` будут созданы директории под каждый сервис:

```
└── services-data
    ├── firefly
    ├── mailu
    ├── nextcloud
    ├── ryot
    └── wireguard
```

---

## Ключевые особенности

Для более тонкой настройки стоит обратиться к документации каждого ПО:  
[Firefly-III](https://docs.firefly-iii.org/);  
[Mailu](https://mailu.io/2024.06/);  
[NextCloud](https://docs.nextcloud.com/server/latest/admin_manual/contents.html);  
[Ryot](https://docs.ryot.io/);     
[WG-Easy](https://github.com/wg-easy/wg-easy).  

---

## Инструкция по настройке

1. **Клонируйте репозиторий**:
   ```bash
   git clone https://github.com/MichaelOshino/self-hosted-stack.git
   cd self-hosted-stack
   ```
2. **SSL-сертификаты (опционально)**:
   - Изначально имеется самоподписанный сертификат. Можно оставить его либо для локального использования, либо тестирования, но для корректной работы mailu по TLS требуется валидный сертификат.  
   
   - Сгенерируйте SSL-сертификат или приобритите, а затем поместите сертификат и его ключ в директорию: `ssl-сertificates`

3. **Настройте переменные окружения**:
   - Каждый файл окружения относится к конкретному сервису, и изменение значений в этих файлах влияет на соответствующие сервисы в проекте.
    
   - Отредактируйте файлы окружения в директории `env/`, указав свои данные. Согласно комментариям в файлах, измените переменные как минимум:
   
      - `nginx-rp.env` - для настройки nginx revers proxy:
         - Требуется указать домен/поддомен для каждого сервиса, если домена нет, то укажите IPv4 сервера.

         - И, если имеется валидный SSL сертификат, замените уже укзанный самоподписанный сертикиат на него.
      - `firefly-mariadb.env`:
         ```
         MYSQL_USER=        #Пользователь  
         MYSQL_DATABASE=    #Название БД  
         MYSQL_PASSWORD=    #Пароль пользователя БД  
         ```
      - `firefly-app.env`:
         ```
         SITE_OWNER=
         APP_KEY=
         DB_DATABASE=       #заначение MYSQL_DATABASE из firefly-mariadb.env
         DB_USERNAME=       #заначение MYSQL_USER из firefly-mariadb.env
         DB_PASSWORD=       #заначение MYSQL_PASSWORD из firefly-mariadb.env
         STATIC_CRON_TOKEN= #так же замените у firefly-cron в компоуз файле 
         APP_URL=

         #Для отправки писем:
         MAIL_HOST=
         MAIL_PORT=
         MAIL_FROM=
         MAIL_USERNAME=
         MAIL_PASSWORD=
         MAIL_ENCRYPTION=
         ```
      - `mailu.env`:
         ```
         SECRET_KEY=
         DOMAIN=
         HOSTNAMES=     #Для корректной работы почты должен совпадать с PTR
         POSTMASTER=
         INITIAL_ADMIN_ACCOUNT=
         INITIAL_ADMIN_DOMAIN=
         INITIAL_ADMIN_PW=
         SITENAME=
         WEBSITE=
         ```
      - `nextcloud.env`:
         ```
         MYSQL_ROOT_PASSWORD=
         MYSQL_USER=
         MYSQL_DATABASE=
         MYSQL_PASSWORD=
         OVERWRITECLIURL=
         ```
       - `ryot.env`:
         ```
         POSTGRES_PASSWORD=
         POSTGRES_USER=
         POSTGRES_DB=
         DATABASE_URL= #Указать URL для подключения к БД, заменить на данные котоыре указали выше. 
         SERVER_ADMIN_ACCESS_TOKEN=
         ```
       - `wireguard.env`:
         ```
         WG_HOST= #Опционально
         PASSWORD_HASH= #Сгенерировать пароль потребуется по инструкции: https://github.com/wg-easy/wg-easy/blob/master/How_to_generate_an_bcrypt_hash.md

         ```

   - Для более тонкой настройики обратитесь к [документации каждого ПО](#ключевые-особенности).

     
4. **Запуск**:  
   - Запустить можно обычным образом:
   ```bash
   docker compose -f docker-compose.networks.yml -f docker-compose.firefly.yml -f docker-compose.mailu.yml \
                  -f docker-compose.nextcloud.yml -f docker-compose.nginx-rp.yml -f docker-compose.ryot.yml \
                  -f docker-compose.wireguard.yml up -d
   ```
   - Так же можно через скрипт:
   ```bash
   chmod +x docker-compose-manager.sh
   ./docker-compose-manager.sh
   ```
   **При первом запуске может потребоваться несколько минут**
---

## Лицензия

Проект распространяется под лицензией MIT. Подробнее см. в файле `LICENSE`.

---

## Контакты

Если у вас есть вопросы или предложения, вы можете связаться со мной по электронной почте: neet@michaeloshino.ru

