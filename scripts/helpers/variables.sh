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
        "3 — Запись данных в файлы"
        "0 — Выход из программы"
)

file_name_zast="./config/zast.txt"
def_data=(
    12     # a     — коэффициент нарастания сигнала Uvx
    12     # b     — коэффициент спада сигнала Uvx
    10     # tn    — начальное время
    35     # tk    — конечное время
    22.5   # t1    — время пика сигнала (максимума Uvx)
    5      # Uvx1  — нижний порог Uvx
    25     # Uvx2  — верхний порог Uvx
    20     # U1    — значение Uvix, если Uvx < Uvx1
    150    # U2    — значение Uvix, если Uvx > Uvx2
)

