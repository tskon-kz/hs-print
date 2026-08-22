# hs-print

Домашний шлюз AirPrint для Epson L3250.

Проект даёт iPhone/iPad обнаруживать принтер в домашней сети и печатать по AirPrint. Ubuntu-сервер принимает задания через CUPS и передаёт их Epson L3250 по IPP.

## Статус

Рабочее решение: контейнеры CUPS и Avahi, очередь Epson и диагностические команды. Печать с iPhone подтверждена.

## Быстрый старт

```bash
cp .env.example .env   # заполнить PRINTER_URI, LAN_SUBNET, AVAHI_INTERFACES и имена
make up
make status
```

Если на хосте активен firewall (UFW и т.п.), откройте TCP/631 для локальной сети — см. [Эксплуатация](docs/operations.md).

## Документация

- [Архитектура](docs/architecture.md)
- [Решения и допущения](docs/decisions.md)
- [Эксплуатация](docs/operations.md)

## Целевой стек

- Docker Compose в Ubuntu;
- CUPS с драйвером Epson ESC/P-R;
- Avahi для mDNS/Bonjour и обнаружения AirPrint;
- Epson L3250 в домашней Wi-Fi-сети.
