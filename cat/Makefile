Flags = -Wall -Werror -Wextra -D_GNU_SOURCE -g
CComp = gcc

all: s21_cat

s21_cat: s21_cat.c s21_cat.h
	@$(CComp) $(Flags) s21_cat.c -o s21_cat

clean:
	-@rm s21_cat *.txt

test: s21_cat
	chmod +x my_cat_test.sh
	./my_cat_test.sh

rebuild: clean s21_cat

style_check: s21_cat.c s21_cat.h
	clang-format -n *.c *.h

style: s21_cat.c s21_cat.h
	clang-format -i *.c *.h
	clang-format -n *.c *.h
