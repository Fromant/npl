# Тесты к задаче 1.1. Проверяем внутренние функции main.jl.
# Язык: Julia 1.11.5. Запуск: julia test_main.jl

include("main.jl")

failed = 0

# Проверка одного условия: печатаем OK или FAIL и считаем провалы.
function check(name::String, got, want)
    if got == want
        println("OK   ", name, ": ", got)
    else
        global failed += 1
        println("FAIL ", name, ": got ", got, ", want ", want)
    end
end

println("=== Tests for task 1.1 ===")

# Сумма квадратов на маленьких числах, где легко посчитать вручную.
check("sum_of_squares 1..3", sum_of_squares(1, 3), 14)
check("sum_of_squares 4..4", sum_of_squares(4, 4), 16)
check("sum_of_squares 1..1", sum_of_squares(1, 1), 1)

# Пустой участок даёт ноль.
check("sum_of_squares 5..4", sum_of_squares(5, 4), 0)

# Части диапазона складываются в полную сумму.
small_limit = 100
part_size = div(small_limit, 4)
manual_total = sum_of_squares(1, small_limit)
parts_total = sum(sum_of_squares((part - 1) * part_size + 1,
                                part == 4 ? small_limit : part * part_size)
                  for part in 1:4)
check("four parts equal whole", parts_total, manual_total)

# Проверочная формула совпадает с прямым подсчётом.
check("expected_sum 100", expected_sum(100), manual_total)
check("expected_sum 1", expected_sum(1), 1)

# Тип Int128 держит сумму, которая не влезает в Int64.
big_total = sum_of_squares(1, 10_000_000)
check("big sum fits Int128", big_total isa Int128, true)
check("big sum equals formula", big_total, expected_sum(10_000_000))

println(failed == 0 ? "All tests passed" : "Failed tests: $failed")
exit(failed == 0 ? 0 : 1)