#ifndef SRC_CAT_S21_CAT_H_
#define SRC_CAT_S21_CAT_H_

#include <stdio.h>
#include <string.h>

typedef struct Parameter {
  int b;
  int n;
  int s;
  int v;
  int E;
  int T;
  char filename[100];
} Parameters;

void param_null(Parameters *param);
int arg_process(Parameters *param, char *arg);
int gnu_to_gcc(Parameters *param, char *arg);
int arg_parse(Parameters *param, char **arg_str, int arg_num);
char print_file(Parameters *param, char *filename, char sym_old);
void str_numbering(Parameters *param, FILE *file, char enter, char filestart);
void show_symbol(Parameters *param, char sym);
void str_squeese(Parameters *param, FILE *file);
#endif // SRC_CAT_S21_CAT_H_
