// Задача 1.4. Тема "Многопоточность".
// Четыре потока параллельно пишут каждый свой файл.
// Язык: Rust 1.98.1. 
// cargo run

use std::fs::File;
use std::io::Write;
use std::thread;
use std::time::Instant;

const THREAD_COUNT: usize = 4;
const LINES_PER_FILE: usize = 250_000;

// Шаг 1. Поток пишет свой файл и возвращает имя файла и число строк.
fn write_part(part_number: usize, lines_per_file: usize) -> std::io::Result<(String, usize)> {
    let file_name = format!("part{}.txt", part_number);
    let mut file = File::create(&file_name)?;
    let mut lines_written = 0;

    for line_number in 1..=lines_per_file {
        writeln!(file, "part {} line {}", part_number, line_number)?;
        lines_written += 1;
    }

    Ok((file_name, lines_written))
}

fn main() {
    println!("=== Task 1.4: four threads write four files ===");
    println!("Each file gets {} lines", LINES_PER_FILE);
    let started_at = Instant::now();
    let mut handles = Vec::new();

    // Шаг 2. Запускаем четыре потока, каждый пишет свой файл.
    for part_number in 1..=THREAD_COUNT {
        handles.push(thread::spawn(move || write_part(part_number, LINES_PER_FILE)));
    }

    // Шаг 3. Ждём все потоки и собираем результаты.
    let mut total_lines = 0;
    let mut total_bytes = 0;

    for handle in handles {
        match handle.join() {
            Ok(Ok((file_name, lines))) => {
                let size = std::fs::metadata(&file_name).map_or(0, |data| data.len());
                println!("{}: {} lines, {} bytes", file_name, lines, size);
                total_lines += lines;
                total_bytes += size as usize;
            }
            Ok(Err(error)) => println!("thread failed: {}", error),
            Err(_) => println!("thread panicked"),
        }
    }

    // Шаг 4. Печатаем итог и проверяем, что все файлы записаны полностью.
    println!("Total lines: {}", total_lines);
    println!("Total bytes: {}", total_bytes);
    println!("Time: {:.3} s", started_at.elapsed().as_secs_f64());
    println!("Check passed: {}", total_lines == THREAD_COUNT * LINES_PER_FILE);
}

// cargo test
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn writes_requested_number_of_lines() {
        let (file_name, lines) = write_part(9, 5).expect("write should work");
        assert_eq!(file_name, "part9.txt");
        assert_eq!(lines, 5);

        let text = std::fs::read_to_string(&file_name).expect("read should work");
        assert_eq!(text, "part 9 line 1\npart 9 line 2\npart 9 line 3\npart 9 line 4\npart 9 line 5\n");
        std::fs::remove_file(&file_name).ok();
    }

    #[test]
    fn empty_file_has_zero_lines() {
        let (file_name, lines) = write_part(3, 0).expect("write should work");
        assert_eq!(lines, 0);
        assert_eq!(std::fs::read_to_string(&file_name).expect("read should work"), "");
        std::fs::remove_file(&file_name).ok();
    }

    #[test]
    fn each_part_writes_its_own_file() {
        let (first_name, first_lines) = write_part(1, 2).expect("write should work");
        let (second_name, second_lines) = write_part(2, 3).expect("write should work");
        assert_eq!(first_lines, 2);
        assert_eq!(second_lines, 3);

        let first_text = std::fs::read_to_string(&first_name).expect("read should work");
        let second_text = std::fs::read_to_string(&second_name).expect("read should work");
        assert!(first_text.starts_with("part 1 line 1\n"));
        assert!(second_text.starts_with("part 2 line 1\n"));
        std::fs::remove_file(&first_name).ok();
        std::fs::remove_file(&second_name).ok();
    }
}