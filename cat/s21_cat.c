#include "s21_cat.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void param_null(Parameters *param) {
  param->b = 0;
  param->n = 0;
  param->s = 0;
  param->v = 0;
  param->E = 0;
  param->T = 0;
  param->filename[0] = '\0';
}

int arg_process(Parameters *param, char *arg) {
  int res = 1;
  while (*arg && res) {
    if (*arg == 'b')
      param->b = 1;
    else if (*arg == 'v')
      param->v = 1;
    else if (*arg == 's')
      param->s = 1;
    else if (*arg == 'e')
      param->v = 1, param->E = 1;
    else if (*arg == 't')
      param->T = 1, param->v = 1;
    else if (*arg == 'n')
      param->n = 1;
    else if (*arg == 'E')
      param->E = 1;
    else if (*arg == 'T')
      param->T = 1;
    else {
      res = 0;
      fprintf(stderr,
              "cat: invalid option -- '%s'\nTry 'cat --help' for more "
              "information.\n",
              arg);
    }
    ++arg;
  }
  return res;
}

int gnu_to_gcc(Parameters *param, char *arg) {
  int res = 1;
  if (!strcmp(arg, "--number-nonblank")) {
    param->b = 1;
  } else if (!strcmp(arg, "--number")) {
    param->n = 1;
  } else if (!strcmp(arg, "--squeeze-blank")) {
    param->s = 1;
  } else {
    res = 0;
  }
  return res;
}

int arg_parse(Parameters *param, char **arg_str, int arg_num) {
  int res = 1;
  char sym_old = 10;
  for (int i = 1; i < arg_num && res; ++i) {
    if (gnu_to_gcc(param, arg_str[i])) {
      *arg_str[i] = '\0';
    } else if (*arg_str[i] == '-') {
      res = arg_process(param, ++arg_str[i]);
      *arg_str[i] = '\0';
    }
  }

  if (res) {
    for (int i = 1; i < arg_num; ++i) {
      if (*arg_str[i]) {
        res = !(access(arg_str[i], R_OK));
        if (res)
          sym_old = print_file(param, arg_str[i], sym_old);
        else
          fprintf(stderr, "cat: %s: No such file or directory\n", arg_str[i]);
      }
    }
  }
  return res;
}

char print_file(Parameters *param, char *filename, char sym_old) {
  FILE *file;
  char sym, newfile = 1;
  file = fopen(filename, "r");
  sym = fgetc(file);
  if (!feof(file) && (param->b || param->n || param->s)) {
    str_numbering(param, file, sym, newfile);
    newfile = 0;
  }
  while (!feof(file)) {
    show_symbol(param, sym);
    if (sym == 10 && (param->b || param->n || param->s)) {
      str_numbering(param, file, sym, newfile);
    }
    sym_old = sym;
    if (!feof(file))
      sym = fgetc(file);
    newfile = 0;
  }
  fclose(file);
  return sym_old;
}

void str_numbering(Parameters *param, FILE *file, char enter, char filestart) {
  static int num = 1;
  char sym, sym_old;
  int flag = 0;
  long int position;
  if (!feof(file))
    position = ftell(file);
  sym = fgetc(file);
  sym_old = sym;
  if (filestart)
    num = 1;
  if (param->s && enter == '\n') {
    while (sym == '\n') {
      position = ftell(file);
      sym = fgetc(file);
      ++flag;
    }
  }

  if (!feof(file)) {
    fseek(file, position, SEEK_SET);
  }

  if ((!feof(file) || flag || filestart) && param->b) {
    if (sym_old != 10 || enter != '\n' || filestart)
      printf("%6d\t", num++);
  } else if ((!feof(file) || flag || enter != '\n') && param->n) {
    printf("%6d\t", num++);
  }

  if (flag) {
    show_symbol(param, 10);
    if (!feof(file) && param->b) {
      if (sym != 10)
        printf("%6d\t", num++);
    } else if (!feof(file) && param->n) {
      printf("%6d\t", num++);
    }
  }
}

void show_symbol(Parameters *param, char sym) {
  if (sym >= 32 && sym <= 126) {
    printf("%c", sym);
  } else if (sym == 10) {
    if (param->E == 1)
      printf("$");
    printf("%c", sym);
  } else if (sym == '\t') {
    if (param->T == 1)
      printf("^I");
    else
      printf("%c", sym);
  } else if (param->v == 1) {
    printf("^%c", sym + 64);
  } else {
    printf("%c", sym);
  }
}

int main(int argc, char *argv[]) {
  Parameters param;
  if (argc > 1) {
    param_null(&param);
    arg_parse(&param, argv, argc);
  } else {
    fprintf(stderr, "cat: name of file not found\n");
  }
}
