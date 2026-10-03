# Задача 1.1. Тема "Многопоточность".
# Считаем сумму квадратов чисел от 1 до 10 000 000, распределяя работу между потоками Julia.
# Язык: Julia 1.11.5. Обычный запуск: julia --threads=4 main.jl
# Число потоков берём у самой Julia, поэтому работает и --threads=N: частей будет N.

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
    return div(n * (n + 1) * (2 * n + 1), 6) # в julia оператор '/' всегда floating point division, 5/2->2.5, для деления нацело есть '÷' и 'div(a, b)'
end

function main()
    # Шаг 3. Julia сообщает, сколько потоков ей выделили при запуске.
    thread_count = Threads.nthreads()
    println("=== Task 1.1: sum of squares on ", thread_count, " threads ===")
    println("Julia ", VERSION, ", threads available: ", thread_count)
    if thread_count == 1
        println("Hint: start Julia with --threads=4 to count on four threads")
    end

    # Шаг 4. Делим диапазон на столько же частей, сколько потоков.
    # Размер части считаем нацело, а остаток отдаём последней части,
    # иначе при неудобном числе потоков конец диапазона потеряется.
    part_size = MAX_NUMBER ÷ thread_count
    part_sums = zeros(Int128, thread_count)
    println("Range: 1..", MAX_NUMBER, ", parts: ", thread_count, ", each has ",
            part_size, " numbers, the last part takes the rest")

    # Шаг 5. Считаем части одновременно, каждый поток пишет в свою ячейку.
    elapsed_seconds = @elapsed begin
        Threads.@threads for part in 1:thread_count
            first_number = (part - 1) * part_size + 1
            last_number = part == thread_count ? MAX_NUMBER : part * part_size
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