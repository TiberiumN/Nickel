#[С помощью include мы "встраиваем" код файла base.nim в код нашего модуля для 
того, чтобы не нужно было писать множество импортов в каждом модуле]#
include base

#[Модуль объявляется через module "Любое", "Количество", "Строк".
Эти строки объединятся в одну при компиляции. Они обозначают название модуля]#
module "ℹ Пример модуля":
  #[Секция запуска обозначается "start". Если необходима конфигурация,
  то нужно использовать "startConfig".
  Всё, что внутри, выполнится один раз при запуске бота.
  Доступные объекты:
    bot: VkBot - объект бота
    config: TomlTableRef (при использовании startConfig)
  Код внутри является асинхронным (можно использовать await).
  Код внутри по умолчанию возвращает true, если же вернуть false - 
  данный модуль отключится]#
  start:
    # Для логгирования используется библиотека "chronicles"
    info "Initialized example module"
  #[command - объявление команд; при получении этих команд выполнится этот код 
  Внутри command доступны объекты: 
    msg: Message (объект сообщения),
    api: VkApi (объект для работы с VK API),
    text: string (все аргументы в одной строке)
    args: seq[string] (последовательность аргументов в виде строк)]#
  command "тест", "test":
    #[Переменная usage - использование команды, выводится в команде "помощь".
    usage обязан быть константой (значение известно во время компиляции).
    usage также можно использовать в самом коде команды]#
    usage = "тест <аргументы> - вывести полученные аргументы"
    # Получаем список приложений к сообщению через API
    let attaches = await msg.attaches(api)
    # Отвечаем пользователю. Макрос & - строковая интерполяция
    answer &"Это тестовая команда. Аргументы - {args}\n Вложения - {attaches}"

  #[Секций "command" может быть сколько угодно.
  Все секции имеют отдельную область видимости переменных, так что
  нельзя, например, получить FormatString из команды выше]#
  command "пример":
    usage = "пример - вывести `пример модуля`"
    # Благодаря синтаксису Nim при вызове процедуры можно убрать скобки
    answer "Это пример модуля!"