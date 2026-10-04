// Тесты к задаче 1.2. Проверяем внутренние функции main.kt.
// Язык: Kotlin 2.4.20 (JVM 21).
// Запуск:
//   kotlinc main.kt test_main.kt -include-runtime -d test.jar
//   java -cp test.jar Test_mainKt

import java.util.concurrent.ArrayBlockingQueue
import kotlin.system.exitProcess

var failed = 0

// Проверка одного условия: печатаем OK или FAIL и считаем провалы.
fun check(name: String, got: Any?, want: Any?) {
    if (got == want) {
        println("OK   $name: $got")
    } else {
        failed += 1
        println("FAIL $name: got $got, want $want")
    }
}

fun main() {
    println("=== Tests for task 1.2 ===")

    // Сумма цифр на числах, которые легко посчитать вручную.
    check("digitSum 0", digitSum(0), 0)
    check("digitSum 7", digitSum(7), 7)
    check("digitSum 19", digitSum(19), 10)
    check("digitSum 100", digitSum(100), 1)
    check("digitSum 98765", digitSum(98765), 35)

    // Сумма по всем заданиям совпадает с ручным подсчётом.
    val manualSum = (1..TASK_COUNT).sumOf { digitSum(it) }
    check("sum of 20 tasks", manualSum, 102)

    // Очередь принимает все задания и отдаёт их по одному, без повторов.
    val queue = ArrayBlockingQueue<Int>(QUEUE_SIZE)
    for (taskNumber in 1..TASK_COUNT) {
        queue.put(taskNumber)
    }
    check("queue size after put", queue.size, TASK_COUNT)
    val taken = (1..TASK_COUNT).map { queue.poll() }
    check("queue is empty after poll", queue.size, 0)
    check("queue gives all tasks", taken.toSet(), (1..TASK_COUNT).toSet())
    check("poll on empty queue", queue.poll(), null)
    check("take in order", taken, (1..TASK_COUNT).toList())

    println(if (failed == 0) "All tests passed" else "Failed tests: $failed")
    exitProcess(if (failed == 0) 0 else 1)
}