# Задача 1.3. Тема "Многопоточность".
# Десять заданий выполняются одновременно, у каждого своя задержка от 1 до 3 секунд.
# Язык: Elixir 1.20.4 / OTP 29. Запуск: elixir main.exs

defmodule DelayedTasks do
  @task_count 10

  # Шаг 1. Задержка задания: 1, 2 или 3 секунды по кругу.
  def task_delay(task_number) do
    rem(task_number, 3) + 1
  end

  # Шаг 2. Счётчик одновременных заданий: обычные функции, состояние лежит в Agent.
  def start_task(state) do
    running = state.running + 1
    %{running: running, peak: max(state.peak, running)}
  end

  def finish_task(state) do
    %{state | running: state.running - 1}
  end

  def mark_started(counter) do
    Agent.get_and_update(counter, fn state ->
      new_state = start_task(state)
      {new_state.running, new_state}
    end)
  end

  def mark_finished(counter) do
    Agent.update(counter, &finish_task/1)
  end

  # Шаг 3. Одно задание: печатаем начало, спим задержку, печатаем конец.
  def run_task(task_number, counter, started_at) do
    delay = task_delay(task_number)
    running_now = mark_started(counter)
    IO.puts("TASK #{task_number} START delay #{delay} s, running now #{running_now}")
    Process.sleep(delay * 1000)
    IO.puts("TASK #{task_number} FINISH delay #{delay} s, elapsed #{elapsed_ms(started_at)} ms")
    mark_finished(counter)
    task_number * delay
  end

  def elapsed_ms(started_at) do
    System.monotonic_time(:millisecond) - started_at
  end

  def main do
    IO.puts("=== Task 1.3: 10 tasks with delays ===")
    {:ok, counter} = Agent.start_link(fn -> %{running: 0, peak: 0} end)
    started_at = System.monotonic_time(:millisecond)

    # Шаг 4. Запускаем все задания сразу и ждём их все.
    tasks =
      for task_number <- 1..@task_count do
        Task.async(fn -> run_task(task_number, counter, started_at) end)
      end

    IO.puts("All #{@task_count} tasks are running")
    results = Task.await_many(tasks, 10_000)

    # Шаг 5. Печатаем пик одновременных заданий и общее время.
    peak = Agent.get(counter, & &1.peak)
    IO.puts("Peak concurrent tasks: #{peak}")
    IO.puts("Total time: #{div(elapsed_ms(started_at), 1000)} s")
    IO.puts("Sum of task work: #{Enum.sum(results)}")
    IO.puts("Check passed: #{peak == @task_count}")
  end
end

# Файл открывают как программу. Тест подгружает его через Code.require_file
# и переменная SKIP_RUN говорит ему не запускать main.
if System.get_env("SKIP_RUN") != "1" do
  DelayedTasks.main()
end