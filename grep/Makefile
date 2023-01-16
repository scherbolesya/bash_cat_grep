Flags = -Wall -Werror -Wextra -D_GNU_SOURCE
CComp = gcc

all: s21_grep

s21_grep: s21_grep.c s21_grep.h
	@$(CComp) $(Flags) s21_grep.c -o s21_grep

clean:
	-@rm s21_grep *.txt

test: s21_grep
	chmod +x my_test_grep.sh
	./my_test_grep.sh

rebuild: clean s21_grep

style_check: s21_grep.c s21_grep.h
	clang-format -n *.c *.h

style: s21_grep.c s21_grep.h
	clang-format -i *.c *.h
	clang-format -n *.c *.h