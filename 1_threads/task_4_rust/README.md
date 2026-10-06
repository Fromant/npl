# Задача 1.4. Параллельная запись четырёх файлов

## Назначение

Программа запускает четыре потока, каждый из которых пишет свой файл. В конце
печатаются размеры файлов, общее число строк и время работы.

## Язык и запуск

- Язык: Rust 1.98.1
- Файл: `main.rs`, описание пакета в `Cargo.toml`
- Запуск:

```
cargo run
```

Файлы `part1.txt` - `part4.txt` появляются в той папке, откуда запущена программа.
Папка `target` с результатами сборки не нужна и удаляется целиком.

## Пример вывода

```
=== Task 1.4: four threads write four files ===
Each file gets 250000 lines
part1.txt: 250000 lines, 4638895 bytes
part2.txt: 250000 lines, 4638895 bytes
part3.txt: 250000 lines, 4638895 bytes
part4.txt: 250000 lines, 4638895 bytes
Total lines: 1000000
Total bytes: 18555580
Time: 2.872 s
Check passed: true
```

Число строк и размеры файлов всегда одинаковые, меняется только время работы.

## Тесты

Тесты лежат в том же файле `main.rs` под модулем `tests`: они проверяют, сколько строк
записано, что получившийся файл содержит нужные строки и что каждый поток пишет свой файл.

```
cargo test
```

```
running 3 tests
test tests::empty_file_has_zero_lines ... ok
test tests::writes_requested_number_of_lines ... ok
test tests::each_part_writes_its_own_file ... ok

test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.01s
```

Тест возвращает код 0, если все проверки прошли, и не 0, если есть провалы.
