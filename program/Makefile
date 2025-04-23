# === Компилятор и флаги ===
CC = gcc
CFLAGS = -Wall -I./src/include

# === Целевой исполняемый файл ===
TARGET = bin/myapp

# === Исходные и объектные файлы ===
SRCS = src/main/main.c src/core/app.c src/core/funct.c src/core/krnt.c src/core/rpzt.c
OBJS = build/main.o build/app.o build/funct.o build/krnt.o build/rpzt.o

# === Цель по умолчанию ===
all: clean
	$(MAKE) $(TARGET)

# === Правило сборки итогового файла ===
$(TARGET): $(OBJS)
	@mkdir -p bin
	$(CC) $(OBJS) -o $(TARGET)
	@echo "✅ Скомпилировано: $(TARGET)"

# === Правило сборки объектных файлов ===
build/main.o: src/main.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "📦 main: $<"

build/%.o: src/core/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "📦 core: $<"


# === Запуск программы ===
run:
	./scripts/menu.sh

lss:
	@echo "\033[0;34mbin  build  config  data  scripts  src\033[0m  makefile  \033[0;34moutput  doc\033[0m"

# === Очистка всех сборок ===
clean:
	rm -rf build/*.o $(TARGET)
	@echo "🧹 Очистка завершена."

.PHONY: all clean run lss

