#include "s21_grep.h"

int main(int argc, char *argv[]) {
  FLAGS flags = {0};
  char token[1000] = {"\0"};
  flag_parce(argc, argv, &flags, token);
  // print_flags(flags);
}

int flag_parce(int argc, char **argv, FLAGS *flags, char *token) {
  int flag, num_of_files = 0;
  const char str_flags[] = "e:ivclnhsf:o";
  extern int optind;
  extern char *optarg;
  do {
    flag = getopt_long(argc, argv, (const char *)str_flags, long_options,
                       &option_index);
    switch (flag) {
    case 'e':
      flags->e += 1;
      strcat(token, optarg);
      strcat(token, "|");
      *optarg = 0;
      break;
    case 'i':
      flags->i = 1;
      break;
    case 'v':
      flags->v = 1;
      break;
    case 'c':
      flags->c = 1;
      break;
    case 'l':
      flags->l = 1;
      break;
    case 'n':
      flags->n = 1;
      break;
    case 'h':
      flags->h = 1;
      break;
    case 's':
      flags->s = 1;
      break;
    case 'f':
      flags->f = 1;
      FILE *filename = fopen(optarg, "r");
      if (filename) {
        get_token_from_file(filename, token);
        fclose(filename);
      } else if (flags->s == 0) {
        fprintf(stderr, "grep: %s: No such file or directory\n", optarg);
      }
      *optarg = 0;
      break;
    case 'o':
      flags->o = 1;
      break;
    }
  } while (flag >= 0);
  if (flags->e + flags->f == 0) {
    find_pattern_without_ef(argc, argv, token);
  }
  for (int i = 1; i < argc; ++i) {
    if (argv[i][0] != '-' && argv[i][0])
      ++num_of_files;
  }
  for (int i = 1; i < argc; ++i) {
    if (argv[i][0] != '-' && argv[i][0])
      print_fun(argv[i], flags, token, num_of_files);
  }
  return 1;
}

void find_pattern_without_ef(int argc, char **argv, char *token) {
  int i = 1;
  for (; i < argc && argv[i][0] == '-'; ++i)
    ;
  strcat(token, argv[i]);
  // strcat(token, "|");
  argv[i][0] = 0;
}

void print_fun(char *filename, FLAGS *flags, char *token, int num_of_files) {
  FILE *file;
  regex_t pattern;
  int current_num = 0, number_of_str = 0, comp_res;
  size_t n = 1000;
  char *line;
  line = malloc(n * sizeof(char) + 1);
  file = fopen(filename, "r");
  if (token[strlen(token) - 1] == '|')
    token[strlen(token) - 1] = 0;
  if (file == NULL && flags->s == 0) {
    fprintf(stderr, "grep: %s: No such file or directory\n", filename);
  } else if (file) {
    pattern_former(flags, token, &pattern);
    while (!feof(file) && getline(&line, &n, file) >= 0) {
      ++current_num;
      comp_res = regexec(&pattern, line, 0, NULL, 0);
      if ((!comp_res && !(flags->v)) || (comp_res && flags->v)) {
        ++number_of_str;
        if (flags->l)
          break;
        if (num_of_files > 1 && !(flags->h) && !(flags->c)) {
          printf("%s:", filename);
        }
        if (flags->n && !(flags->c)) {
          printf("%d:", current_num);
        }
        if (!(flags->o) && !(flags->c)) {
          printf("%s", line);
          if (line[strlen(line) - 1] != '\n')
            printf("\n");
        }
      }
    }
    if (flags->c) {
      if (num_of_files > 1 && (!flags->h))
        printf("%s:", filename);
      printf("%d\n", number_of_str);
    }
    if (flags->l && number_of_str) {
      printf("%s\n", filename);
    }
    fclose(file);
    regfree(&pattern);
  }
  free(line);
}

void pattern_former(FLAGS *flags, char *token, regex_t *pattern) {
  if (flags->i)
    regcomp(pattern, token, (REG_EXTENDED | REG_ICASE));
  else
    regcomp(pattern, token, REG_EXTENDED);
}

void print_flags(FLAGS flags) {
  printf("-e: %d\n-i: %d\n-v: %d\n-c: %d\n-l: %d\n-n: %d\n-h: %d\n-s: %d\n-f: "
         "%d\n-o: %d\n",
         flags.e, flags.i, flags.v, flags.c, flags.l, flags.n, flags.h, flags.s,
         flags.f, flags.o);
}

void get_token_from_file(FILE *filename, char *token) {
  size_t n = 1000;
  char *line;
  line = malloc(n * sizeof(char) + 1);
  for (size_t i = 0; i < n; ++i, line[i] = 0)
    ;
  while (getline(&line, &n, filename) != -1) {
    strncat(token, line, strlen(line) - 1);
    strcat(token, "|");
  }
  free(line);
}