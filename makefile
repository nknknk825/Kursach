# компилятор
CC = gcc

# Флаги компиляции
CFLAGS = -Wall -g

CCF = $(CC) $(CFLAGS)

TRG = bin/myapp

# Исходники и объектники
SOR = $(wildcard src/*.c)
OBJ = $(patsubst src/%.c,build/%.o,$(SOR))

all: $(TRG)

$(TRG): $(OBJ)
	@mkdir -p bin
	$(CCF) -o $@ $<

build/%.o: src/%.c
	@mkdir -p build
	$(CCF) -c -o $@ $<

run: $(TRG)
	./scripts/menu

clean:
	rm -rf build/*.o $(TARGET)

clean-all:
	rm -rf build bin

