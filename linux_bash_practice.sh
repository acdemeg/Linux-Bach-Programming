: '
***********************************************************************************************************************************
Task1
Сгенерировать набор файлов вида
YYYY-mm-dd.csv
по каждому дню за год с содержимым такого вида (числовые поля заполнить случайными
значениями):
cite ; country ; date ; views ; clicks
www.abc.com ; USA ; 2017-01-01 ; 1000 ; 3
www.cba.com ; France ; 2017-01-01 ; 750 ; 0

***********************************************************************************************************************************
'

#!/bin/bash

##############################_____TASK-1______________#######################
echo 'start'
# установим дату начала года от которой будет идти отсчет дней
dateStartYear=2019-01-01

mkdir list_of_dates
cd list_of_dates

for((i = 0; i < 365; i++))
do

  file_name=$(date +%F -d "$dateStartYear + $i day")  #запишем вычесленную дату в переменную из которой берется имя файла
  touch $file_name.csv
  random_views_1=$(( 100 + ($RANDOM*999)>>15 ))           #
  random_clicks_1=$(( 1 + ($RANDOM*99)>>15 ))             #генерация рандомный кликов и
  random_views_2=$(( 100 + ($RANDOM*999)>>15 ))           #просмотров
  random_clicks_2=$(( 1 + ($RANDOM*99)>>15 ))             #
  {
    echo    'cite         ; country ; date        ; views ; clicks  ;'
    echo -n 'www.abc.com  ; USA     ; 2017-01-01  ; '; echo -n $random_views_1'   ; ';  echo $random_clicks_1'    ;'    #с помощью блока команд echo
    echo -n 'www.cba.com  ; France  ; 2017-01-01  ; '; echo -n $random_views_2'   ; '; echo $random_clicks_2'     ;'    #записываем данные в файл
  } > $file_name.csv
done

: '
***********************************************************************************************************************************
Task2
В условиях предыдущей задачи
- Проверить, что все файлы за год присутствуют и нет лишних.
- Во всех исходных файлах переставить дату на первое место и привести к виду
dd/mm/YYYY:
date ; cite ; country ; views ; clicks
01/01/2017 ; www.abc.com ; usa ; 1000 ; 3
01/01/2017 ; www.cba.com ; France ; 750 ; 0
***********************************************************************************************************************************
'

##############################_____TASK-2__________#######################

cout_files=$(ls | wc -w)    #узнаем кол-во файлов в директории

if [ $cout_files -eq 365 ]  #проверям что все файлы на месте
then
  echo 'all files are contained'
else
   echo 'do not right count files'
   exit
fi

for file in ./*                                                         #в цикле перебираем  все файлы директории
do                                                                      #и с помощью утилиты awk меняем поля файла
  awk -v out_file=$file 'BEGIN{FS=";"; OFS=";"}                         #местами и изменям формат даты в файле
    {                                                                   #результат перезаписываем в тот же файл
      if(FNR > 1)                                                       #если это строка заголовок форматирование не выполняется
      {
        split($3, date, /-/)
        gsub (" ", "", date[3])
        gsub (" ", "", date[2])
        gsub (" ", "", date[1])
        $3 = date[3]"-"date[2]"-"date[1]
      }
      print $3,$1,$2,$4,$5 > out_file
    }' $file
done

: '
***********************************************************************************************************************************
Task3

Сформировать набор файлов monday.csv, tuesday.csv и т.д. куда вывести содержимое
всех исходных файлов отдельно по каждому дню недели. Строку заголовка вывести один
раз. Исходные файлы удалить.
***********************************************************************************************************************************
'
##############################_____TASK-3__________#######################

cd ..
mkdir days_of_week
cd days_of_week
touch monday.csv tuesday.csv wednesday.csv thursday.csv friday.csv saturday.csv sanday.csv    #создадим новую директорию и необходимые файлы

echo 'start sorting'

for file in ../list_of_dates/*
do
  file_name=$(basename $file)                 #из текующего файла получим его имя без полного пути до него
  file_name="${file_name%.*}"                 #затем получим имя без расширения файла - это будет дата
  day_of_week=$(date -d $file_name +%A)       #затем по полученной дате узнаем день недели

  case "$day_of_week" in
    Понедельник) [ -s monday.csv ] && sed -n '2,$p' $file >> monday.csv || cat $file >> monday.csv ;;                 #с помощью case  определяем к
    Вторник)     [ -s tuesday.csv ] && sed -n '2,$p' $file >> tuesday.csv || cat $file >> tuesday.csv ;;              #какому дню относится текущая дата
    Среда)       [ -s wednesday.csv ] && sed -n '2,$p' $file >> wednesday.csv || cat $file >> wednesday.csv ;;        #и отпрявлямеся в нужную ветку
    Четверг)     [ -s thursday.csv ] && sed -n '2,$p' $file >> thursday.csv || cat $file >> thursday.csv ;;           #чтобы вывести строку заголовка только
    Пятница)     [ -s friday.csv ] && sed -n '2,$p' $file >> friday.csv || cat $file >> friday.csv ;;                 #один раз мы проверяем файл на пустоту
    Суббота)     [ -s saturday.csv ] && sed -n '2,$p' $file >> saturday.csv || cat $file >> saturday.csv ;;           #и если файл не пустой то пишем со
    Воскресенье) [ -s sanday.csv ] && sed -n '2,$p' $file >> sanday.csv || cat $file >> sanday.csv ;;                 #второй строки с помощью sed
    *) echo     "$day_of_week is not an option" ;;
  esac

done

echo 'end sorting'
cd ..
rm -r list_of_dates                               #удалим исходные файлы
echo 'end'

: '
***********************************************************************************************************************************
Task4
Вывести в отдельный файл содержимое всех файлов *.java из своего репозитория
(локальный проект заочной школы или любой другой, где есть java классы), в которых
встречается ArrayList.
***********************************************************************************************************************************
'

##############################_____TASK-4__________#######################

echo 'start Java parse'

for file in $(find /home/valery/thumbtack_online_school_2018_2_valerii_krylov -iname '*.java')
do
  coincidence=$(grep -o -m 1 'ArrayList' $file | grep -m 1 'ArrayList')               #извлечем из вывода grep
                                                                                      #точное совпадение с шаблоном
  if [[ $coincidence == 'ArrayList' ]]                                                #и если наша переменная содежит
    then cat $file >> target.java                                                     #шаблон пишем текущий файл в
    fi                                                                                #целевой файл

done

echo 'end Java parse'

: '
***********************************************************************************************************************************
Task5

Вывести содержимое каталога /etc (каждая строка с полным путем) затем заменить
первые вхождения ‘/’ на “C:\”, остальные на ‘\’
***********************************************************************************************************************************
'
##############################_____TASK-5__________#######################

find /etc/ | sed -e 's!/!C:\\!1; s!/!\\!g'