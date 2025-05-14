# === Компилятор и флаги ===
CC = gcc
CFLAGS = -Wall -I./src/include

# === Целевой исполняемый файл ===
TARGET = bin/prg

# === Исходные и объектные файлы ===
SRCS = src/main.c src/app.c src/funct.c
OBJS = build/main.o build/app.o build/funct.o

# === Цель по умолчанию ===
all: clean
	$(MAKE) $(TARGET)

# === Правило сборки итогового файла ===
$(TARGET): $(OBJS)
	@mkdir -p bin
	$(CC) $(OBJS) -o $(TARGET) -lm
	@echo "✅ Скомпилировано: $(TARGET)"

# === Правило сборки объектных файлов ===
build/%.o: src/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "📦 src: $<"


# === Запуск программы ===
run:
	@chmod +x ./scripts/menu.sh
	@mkdir -p data/graphs
	@mkdir -p data/tabls
	bash ./scripts/menu.sh

test1:
	./bin/myapp 1 20

test2:
	./bin/myapp 2 10 0.01

# === Очистка всех сборок ===
clean:
	rm -rf build/*.o $(TARGET)
	@echo "🧹 Очистка завершена."

.PHONY: all clean run lss test1 test2

