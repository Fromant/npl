# Тесты к задаче 1.3. Проверяем внутренние функции main.exs.
# Язык: Elixir 1.20.4 / OTP 29. Запуск: elixir test_main.exs

System.put_env("SKIP_RUN", "1")
Code.require_file(Path.join(__DIR__, "main.exs"))

defmodule DelayedTasksTest do
  alias DelayedTasks, as: Tasks

  # Проверка одного условия: печатаем OK или FAIL, провалы собираем в список.
  def check(failures, name, got, want) do
    if got == want do
      IO.puts("OK   #{name}: #{inspect(got)}")
      failures
    else
      IO.puts("FAIL #{name}: got #{inspect(got)}, want #{inspect(want)}")
      [name | failures]
    end
  end

  def run do
    IO.puts("=== Tests for task 1.3 ===")
    failures = run_checks([])

    if failures == [] do
      IO.puts("All tests passed")
      System.halt(0)
    else
      IO.puts("Failed tests: #{length(failures)}")
      System.halt(1)
    end
  end

  def run_checks(failures) do
    delays = Enum.map(1..10, &Tasks.task_delay/1)

    # Задержки идут по кругу 2, 3, 1 секунды.
    failures = check(failures, "delays 1..10", delays, [2, 3, 1, 2, 3, 1, 2, 3, 1, 2])
    failures = check(failures, "sum of delays", Enum.sum(delays), 20)

    # Счётчик одновременных заданий растёт и запоминает максимум.
    one = Tasks.start_task(%{running: 0, peak: 0})
    failures = check(failures, "running after start", one.running, 1)
    two = Tasks.start_task(one)
    failures = check(failures, "peak after two starts", two.peak, 2)
    failures = check(failures, "running after finish", Tasks.finish_task(two).running, 1)
    failures = check(failures, "peak kept after finish", Tasks.finish_task(two).peak, 2)

    # Если все десять заданий стартуют сразу, пик равен десяти.
    state = Enum.reduce(1..10, %{running: 0, peak: 0}, fn _number, acc -> Tasks.start_task(acc) end)
    failures = check(failures, "peak of ten tasks", state.peak, 10)
    failures = check(failures, "running of ten tasks", state.running, 10)

    # Сумма работы заданий равна сумме номеров, умноженных на их задержки.
    work = Enum.sum(Enum.map(1..10, fn number -> number * Tasks.task_delay(number) end))
    failures = check(failures, "sum of task work", work, 107)

    failures
  end
end

DelayedTasksTest.run()