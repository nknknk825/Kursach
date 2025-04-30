#!/bash/sh

p_blue="$(tput setaf 6)"
p_res="$(tput sgr0)"

red="\033[0;31m"
blue="\033[0;34m"
green="\033[0;32m"
yellow="\033[0;33m"
i_yellow='\033[93m'

bold="\033[1m"
nc="\033[0m"
alfv="abcdefghijklmnopqrstuvwxyz"

variant_menu=(
        "1 — Контрольный расчет для n точек"
        "2 — Расчёт параметра с заданной точностью"
        "3 - Вывод пояснений к параметру"
        "4 — Запись данных в файлы"
        "q — Выход из программы"
)

file_name_zast="./config/zast.txt"
def_data=(
    12     # a
    48     # b
    10     # tn
    35     # tk
    30     # t1
)

