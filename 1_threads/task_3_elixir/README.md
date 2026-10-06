# Задача 1.3. Десять заданий с задержкой и пик одновременных

## Назначение

Программа запускает десять заданий одновременно, у каждого своя задержка от 1 до 3 секунд.
Для каждого задания печатаются начало и конец, а в конце - сколько заданий выполнялось
одновременно и сколько заняла вся работа.

## Язык и запуск

- Язык: Elixir 1.20.4 / OTP 29
- Файл: `main.exs`
- Запуск:

```
elixir main.exs
```

Программа идёт около трёх секунд - столько длится самая длинная задержка.

## Пример вывода

```
=== Task 1.3: 10 tasks with delays ===
All 10 tasks are running
TASK 1 START delay 2 s, running now 1
TASK 2 START delay 3 s, running now 2
TASK 3 START delay 1 s, running now 3
TASK 4 START delay 2 s, running now 4
TASK 5 START delay 3 s, running now 5
TASK 6 START delay 1 s, running now 6
TASK 7 START delay 2 s, running now 7
TASK 8 START delay 3 s, running now 8
TASK 9 START delay 1 s, running now 9
TASK 10 START delay 2 s, running now 10
TASK 3 FINISH delay 1 s, elapsed 1019 ms
TASK 6 FINISH delay 1 s, elapsed 1019 ms
TASK 9 FINISH delay 1 s, elapsed 1019 ms
TASK 1 FINISH delay 2 s, elapsed 2031 ms
TASK 4 FINISH delay 2 s, elapsed 2031 ms
TASK 7 FINISH delay 2 s, elapsed 2031 ms
TASK 10 FINISH delay 2 s, elapsed 2031 ms
TASK 2 FINISH delay 3 s, elapsed 3027 ms
TASK 5 FINISH delay 3 s, elapsed 3027 ms
TASK 8 FINISH delay 3 s, elapsed 3027 ms
Peak concurrent tasks: 10
Total time: 3 s
Sum of task work: 107
Check passed: true
```

Порядок строк и миллисекунды от запуска к запуску меняются. Всегда одинаково только одно:
пик равен 10, потому что все задания стартуют одновременно, а общее время равно самой
длинной задержке, а не сумме задержек.

## Тесты

Файл `test_main.exs` подгружает `main.exs` и проверяет внутренние функции: задержки
заданий, рост и максимум счётчика одновременных заданий и сумму работы.

```
elixir test_main.exs
```

```
=== Tests for task 1.3 ===
OK   delays 1..10: [2, 3, 1, 2, 3, 1, 2, 3, 1, 2]
OK   sum of delays: 20
OK   running after start: 1
OK   peak after two starts: 2
OK   running after finish: 1
OK   peak kept after finish: 2
OK   peak of ten tasks: 10
OK   running of ten tasks: 10
OK   sum of task work: 107
All tests passed
```

Тест возвращает код 0, если все проверки прошли, и 1, если есть провалы.
