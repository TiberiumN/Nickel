include base
import times

module "📅 Текущее время":
  command ["время", "дата"]:
    usage = "время - вывести текущее время по МСК"
    answer "Текущие дата и время по МСК:\n" & utils.getMoscowTime()