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
├── env
│   ├── firefly-app.env
│   ├── firefly-mariadb.env
│   ├── mailu.env
│   ├── nextcloud.env
│   ├── nginx-rp.env
│   ├── ryot-app.env
│   ├── ryot-postgres.env
│   └── wireguard.env
├── LICENSE
├── README.md
├── services-data
│   ├── nginx-rp
│       ├── nginx.conf
│       ├── sites-available
│       └── sites-enabled
│           ├── default.conf.template
│           ├── firefly.conf.template
│           ├── mailu.conf.template
│           ├── nextcloud.conf.template
│           ├── ryot.conf.template
│           └── wireguard.conf.template
└── ssl-certificates
    ├── mailu
    └── nginx-rp

```

Дополнительно в `services-data` будут созданы директории под каждый сервис:

```
├── services-data
│   ├── firefly
│   ├── mailu
│   ├── nextcloud
│   ├── ryot
│   └── wireguard
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
2. **SSL-сертификаты**:
   - Изначально имеется самоподписанный сертификат. Можно оставить его либо для локального использования, либо тестирования.
   - Сгенерируйте SSL-сертификат или приобритите, а затем поместите сертификат и его ключ в директорию: `ssl-сertificates`

3. **Настройте переменные окружения**:
   - Отредактируйте файлы окружения в директории `env/` указав свои данные. Каждый файл окружения относится к конкретному сервису, и изменение значений в этих файлах влияет на соответствующие сервисы в проекте.
   - В файлах есть комментарии, но не лишним будет обратиться к [документации каждого ПО](#ключевые-особенности).
   - Домен/IP и путь к сертификатам ssl в конфигах nginx указывается через переменные в nginx-rp.env
     
4. **Запуск**:  
   - Запустить можно обычным образом:
   ```bash
   docker-compose -f docker-compose.networks.yml -f docker-compose.firefly.yml -f docker-compose.mailu.yml \
                  -f docker-compose.nextcloud.yml -f docker-compose.nginx-rp.yml -f docker-compose.ryot.yml \
                  -f docker-compose.wireguard.yml up -d
   ```
   - Так же можно через скрипт:
   ```bash
   chmod +x docker-compose-manager.sh
   ./docker-compose-manager.sh
   ```

---

## Лицензия

Проект распространяется под лицензией MIT. Подробнее см. в файле `LICENSE`.

---

## Контакты

Если у вас есть вопросы или предложения, вы можете связаться со мной по электронной почте: neet@michaeloshino.ru

