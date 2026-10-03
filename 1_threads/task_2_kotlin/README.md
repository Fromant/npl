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

## Разбор решения

1. **Очередь.** Все 20 заданий кладутся в `ArrayBlockingQueue`. Задание забирается
   одним вызовом `poll()`, поэтому два воркера не получат одно и то же задание.
2. **Три воркера.** Для каждого создаётся свой поток через `thread`. В цикле он берёт
   очередное задание, пока `poll()` не вернёт `null` - это значит, что очередь пуста.
3. **Счётчики.** У каждого воркера своя ячейка в массиве `takenByWorker` и своя
   `AtomicInteger` для общей суммы, поэтому воркеры не мешают друг другу.
4. **Ожидание.** `join()` ждёт завершения всех трёх потоков, и только после этого
   печатаются итоги.
5. **Проверка.** Общая сумма ответов сравнивается с той же суммой, посчитанной обычным
   циклом. Всего обработано 20 заданий из 20.