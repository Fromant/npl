# Задача 1.2. Очередь задач и три потока-воркера

## Назначение

Программа кладёт в очередь 20 заданий и запускает три потока-воркера, которые разбирают
очередь, пока она не опустеет. Задание - посчитать сумму цифр числа.

## Язык и запуск

- Язык: Kotlin 2.4.20 (JVM 21)
- Файл: `main.kt`
- Сборка и запуск:

```
kotlinc main.kt -include-runtime -d app.jar
java -jar app.jar
```

## Пример вывода

```
=== Task 1.2: 20 tasks and 3 workers ===
Queue ready: 20 tasks, workers: 3
  worker 1 took task 1 -> 1
  worker 3 took task 3 -> 3
  worker 3 took task 5 -> 5
  worker 3 took task 6 -> 6
  worker 2 took task 2 -> 2
  worker 3 took task 7 -> 7
  worker 3 took task 9 -> 9
  worker 3 took task 10 -> 1
  worker 3 took task 11 -> 2
  worker 1 took task 4 -> 4
  worker 2 took task 8 -> 8
  worker 2 took task 14 -> 5
  worker 2 took task 15 -> 6
  worker 2 took task 16 -> 7
  worker 2 took task 17 -> 8
  worker 2 took task 18 -> 9
  worker 2 took task 19 -> 10
  worker 3 took task 12 -> 3
  worker 1 took task 13 -> 4
  worker 2 took task 20 -> 2
Tasks per worker:
  worker 1: 3 tasks
  worker 2: 9 tasks
  worker 3: 8 tasks
Tasks done: 20 of 20
Sum of answers: 102
Check passed: true
```

Порядок строк и то, сколько заданий достанется каждому воркеру, от запуска к запуску
меняются: кто быстрее берёт задание, тот успевает взять больше. Всего заданий всегда 20,
сумма ответов всегда 102.

## Тесты

Файл `test_main.kt` компилируется вместе с `main.kt` и проверяет внутренние функции:
сумму цифр на числах, которые легко посчитать вручную, сумму по всем заданиям и поведение
очереди при вставке и извлечении.

```
kotlinc main.kt test_main.kt -include-runtime -d test.jar
java -cp test.jar Test_mainKt
```

```
=== Tests for task 1.2 ===
OK   digitSum 0: 0
OK   digitSum 7: 7
OK   digitSum 19: 10
OK   digitSum 100: 1
OK   digitSum 98765: 35
OK   sum of 20 tasks: 102
OK   queue size after put: 20
OK   queue is empty after poll: 0
OK   queue gives all tasks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
OK   poll on empty queue: null
OK   take in order: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
All tests passed
```

Тест возвращает код 0, если все проверки прошли, и 1, если есть провалы.
