# === Компилятор и флаги ===
CC = gcc
CFLAGS = -Wall -I./src/include

# === Целевой исполняемый файл ===
TARGET = bin/myapp

# === Исходные и объектные файлы ===
SRCS = src/main/main.c src/core/app.c src/core/funct.c src/core/krnt.c
OBJS = build/main.o build/app.o build/funct.o build/krnt.o

# === Цель по умолчанию ===
all: $(TARGET)

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


# === Очистка всех сборок ===
clean:
	rm -rf build/*.o $(TARGET)
	@echo "🧹 Очистка завершена."

.PHONY: all clean run

