// Задача 1.2. Тема "Многопоточность".
// Очередь из 20 заданий разбирают три потока-воркера.
// Язык: Kotlin 2.4.20 (JVM 21).
// Запуск: kotlinc main.kt -include-runtime -d app.jar, затем java -jar app.jar

import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.atomic.AtomicInteger
import kotlin.concurrent.thread

const val TASK_COUNT = 20       // сколько заданий кладём в очередь
const val WORKER_COUNT = 3      // сколько потоков-воркеров их разбирают
const val QUEUE_SIZE = 20       // размер очереди, помещаются все задания

// Шаг 1. Задание - это сумма цифр числа.
fun digitSum(number: Int): Int {
    var rest = number
    var total = 0
    while (rest > 0) {
        total += rest % 10
        rest /= 10
    }
    return total
}

fun main() {
    println("=== Task 1.2: 20 tasks and 3 workers ===")

    val tasks = ArrayBlockingQueue<Int>(QUEUE_SIZE)
    val takenByWorker = IntArray(WORKER_COUNT)
    val answerSum = AtomicInteger(0)

    // Шаг 2. Кладём задания в очередь и печатаем, сколько их там.
    for (taskNumber in 1..TASK_COUNT) {
        tasks.put(taskNumber)
    }
    println("Queue ready: ${tasks.size} tasks, workers: $WORKER_COUNT")

    // Шаг 3. Запускаем воркеров. Каждый берёт задание из общей очереди,
    // пока очередь не опустеет. Счётчик воркера свой, чужой он не трогает.
    val workers = (1..WORKER_COUNT).map { workerId ->
        thread(name = "worker-$workerId") {
            while (true) {
                val taskNumber = tasks.poll()
                if (taskNumber == null) {
                    break
                }
                val answer = digitSum(taskNumber)
                takenByWorker[workerId - 1] += 1
                answerSum.addAndGet(answer)
                println("  worker $workerId took task $taskNumber -> $answer")
            }
        }
    }

    // Шаг 4. Ждём, пока все воркеры закончат работу.
    for (worker in workers) {
        worker.join()
    }

    // Шаг 5. Печатаем, сколько заданий досталось каждому воркеру.
    println("Tasks per worker:")
    for (workerId in 1..WORKER_COUNT) {
        println("  worker $workerId: ${takenByWorker[workerId - 1]} tasks")
    }

    // Шаг 6. Печатаем итог и проверяем, что обработаны все задания.
    val expectedSum = (1..TASK_COUNT).sumOf { digitSum(it) }
    println("Tasks done: ${takenByWorker.sum()} of $TASK_COUNT")
    println("Sum of answers: ${answerSum.get()}")
    println("Check passed: ${answerSum.get() == expectedSum}")
}