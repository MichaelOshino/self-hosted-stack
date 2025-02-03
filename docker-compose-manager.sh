#!/bin/bash

compose_files=($(ls | grep -E 'docker-compose.*.yml'))

function select_services {
  while true; do
    compose_files_to_run=()

    printf "Доступные файлы:\n"
    for i in "${!compose_files[@]}"; do
      echo "$((i + 1))) ${compose_files[$i]}"
    done
    printf "*) Выбрать все\n"
    local choices
    read -p "Выберите (несколько через пробел): " -a choices
    

    if [ ${#choices[@]} -eq 0 ]; then
      printf "Предупреждение: ввод не должен быть пустым.\n" >&2
      continue
    fi

    local all_selected=0
    for choice in "${choices[@]}"; do
      if [[ "$choice" == "*" ]]; then
        all_selected=1
        break
      fi
    done
    if (( all_selected )); then
      compose_files_to_run=("${compose_files[@]}")
      break
    fi

    local invalid=0
    for choice in "${choices[@]}"; do
      if [[ "$choice" =~ ^[0-9]+$ ]]; then
        local index=$((choice - 1))
        if (( index >= 0 && index < ${#compose_files[@]} )); then
          compose_files_to_run+=("${compose_files[index]}")
        else
          printf "Предупреждение: номер '%s' выходит за допустимый диапазон.\n" "$choice" >&2
          invalid=1
          fi
      else
        printf "Предупреждение: некорректный ввод '%s'. Ожидается число или '*'.\n" "$choice" >&2
        invalid=1
      fi
    done
    if (( invalid )); then
      continue
    fi

    if [ ${#compose_files_to_run[@]} -gt 0 ]; then
        break
    else
        printf "Предупреждение: не выбран ни один файл.\n" >&2
    fi
  done
}

function show_menu {
  echo "1) Запустить"
  echo "2) Остановить"
  echo "3) Выйти"
  read -p "Выберите действие: " action
}

function execute_action {
  local action=$1
  case $action in
    1)
      select_services
      echo "Запуск..."
      cmd="docker-compose -f docker-compose.networks.yml"
      for file in ${compose_files_to_run[@]}; do
        cmd+=" -f $file"
      done
      cmd+=" up -d"
      eval $cmd
      ;;
    2)
      select_services
      echo "Остановка..."
      cmd="docker-compose -f docker-compose.networks.yml"
      for file in ${compose_files_to_run[@]}; do
        cmd+=" -f $file"
      done
      cmd+=" down"
      eval $cmd
      ;;
    3) 
      echo "Выход."
      exit 0
      ;;
    *)
      echo "Неверный выбор действия!"
      exit 0
      ;;
  esac
}

show_menu
execute_action "$action"