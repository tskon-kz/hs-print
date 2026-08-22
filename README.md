# hs-print

Домашний шлюз AirPrint для Epson L3250.

Проект позволит iPhone обнаруживать принтер в домашней сети и отправлять на него задания по AirPrint. Ubuntu-сервер будет принимать задания через CUPS и передавать их Epson L3250 по сети.

## Статус

Реализованы контейнеры CUPS и Avahi, очередь Epson и диагностические команды. Развёртывание и приёмочная печать выполняются на целевом Ubuntu-сервере.

## Документация

- [План реализации](docs/implementation-plan.md)
- [Архитектура](docs/architecture.md)
- [Решения и допущения](docs/decisions.md)
- [Эксплуатация](docs/operations.md)

## Целевой стек

- Docker Compose в Ubuntu;
- CUPS с драйвером Epson ESC/P-R;
- Avahi для mDNS/Bonjour и обнаружения AirPrint;
- Epson L3250 в домашней Wi-Fi-сети.
