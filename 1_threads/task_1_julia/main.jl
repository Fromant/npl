# Задача 1.1. Тема "Многопоточность".
# Считаем сумму квадратов чисел от 1 до 10 000 000 на четыре потока Julia.
# Язык: Julia 1.11.5. Запуск: julia --threads=4 main.jl

const THREAD_COUNT = 4          # столько потоков должно быть у программы
const MAX_NUMBER = 10_000_000   # верхняя граница диапазона чисел

# Шаг 1. Сумма квадратов одного участка диапазона.
# Считаем в Int128, потому что результат не помещается в Int64.
function sum_of_squares(first_number::Int, last_number::Int)
    total = Int128(0)
    for number in first_number:last_number
        square = Int128(number) * Int128(number)
        total += square
    end
    return total
end

# Шаг 2. Проверочная сумма по формуле суммы квадратов: n(n+1)(2n+1)/6.
function expected_sum(limit::Int)
    n = Int128(limit)
    return n * (n + 1) * (2 * n + 1) ÷ 6
end

function main()
    println("=== Task 1.1: sum of squares on four threads ===")
    println("Julia ", VERSION, ", threads available: ", Threads.nthreads())

    # Шаг 3. Без четырех потоков программа не запускается.
    if Threads.nthreads() != THREAD_COUNT
        println("ERROR: start Julia with --threads=4")
        return
    end
    println("Range: 1..", MAX_NUMBER)

    # Шаг 4. Делим диапазон на четыре равные части, по одной части на поток.
    part_size = MAX_NUMBER ÷ THREAD_COUNT
    part_sums = zeros(Int128, THREAD_COUNT)
    println("Four parts, each has ", part_size, " numbers")

    # Шаг 5. Считаем части одновременно, каждый поток пишет в свою ячейку.
    elapsed_seconds = @elapsed begin
        Threads.@threads for part in 1:THREAD_COUNT
            first_number = (part - 1) * part_size + 1
            last_number = part * part_size
            part_sums[part] = sum_of_squares(first_number, last_number)
            println("  Thread ", Threads.threadid(), ": part ", part, " (",
                    first_number, "..", last_number, ") sum = ", part_sums[part])
        end
    end

    # Шаг 6. Складываем результаты частей и печатаем итог.
    total_sum = sum(part_sums)
    println("Total sum: ", total_sum)
    println("Elapsed: ", round(elapsed_seconds, digits=3), " s")

    # Шаг 7. Проверяем итог по формуле и печатаем вердикт.
    formula_sum = expected_sum(MAX_NUMBER)
    println("Formula: ", formula_sum)
    println("Check passed: ", total_sum == formula_sum)
end

main()