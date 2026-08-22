# Эксплуатация

## Первый запуск на Ubuntu

1. Установите Docker Engine с Docker Compose plugin.
2. Убедитесь, что на хосте нет работающих CUPS или Avahi: они конфликтуют с портом TCP/631 и mDNS UDP/5353.
3. Создайте локальную конфигурацию: `cp .env.example .env`.
4. Проверьте `PRINTER_URI`, `LAN_SUBNET` и имя принтера в `.env`. Закрепите IP принтера в DHCP роутера.
5. Выполните `make up`, затем `make status`.

`network_mode: host` обязателен для обнаружения через Bonjour. Запускайте стек на Linux; Docker Desktop на macOS/Windows не воспроизводит сетевую модель целевого Ubuntu-хоста.

### Firewall (обязательно)

Если на хосте активен UFW с политикой `deny incoming` (по умолчанию), mDNS (multicast) проходит, а TCP/631 — нет. Принтер тогда **виден** в списке AirPrint, но iOS не может открыть IPP-сессию и **прячет** его. Откройте порт для локальной сети:

```bash
sudo ufw allow from <LAN_SUBNET> to any port 631 proto tcp
# при необходимости явно и mDNS:
sudo ufw allow from <LAN_SUBNET> to any port 5353 proto udp
```

Проверка с другого хоста (Mac/Linux с CUPS): `ipptool -tv ipp://<server-ip>:631/printers/<PRINTER_NAME> get-printer-attributes.test` должен вернуть `successful-ok`.

Если у хоста несколько интерфейсов в одной подсети (например, провод + Wi-Fi), укажите в `.env` только основной в `AVAHI_INTERFACES` (например, `enp2s0`), чтобы `home-server.local` не резолвился в несколько адресов.

## Проверка и тестовая печать

Проверьте очередь: `make status`. Если она отображается как доступная, отправьте встроенную страницу CUPS: `make test`.

На iPhone в той же локальной сети откройте PDF, выберите «Поделиться» → «Печать». Должно появиться имя из `AIRPRINT_NAME`.

## Обновление и восстановление

Для обновления образов выполните `make down`, затем `make up`; именованные volumes CUPS сохранят очередь и задания. После обновления всегда выполните `make status` и `make test`.

Чтобы заново применить настройки очереди после изменения `PRINTER_URI` или `PRINTER_MODEL`, выполните `./scripts/install-printer.sh`. Скрипт идемпотентен.

Не публикуйте TCP/631 в интернет и не коммитьте `.env`. Для диагностики используйте `make logs`; передавайте журналы только после удаления адресов и других локальных данных, если они чувствительны.
