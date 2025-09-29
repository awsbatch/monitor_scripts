# Introduction to grep command
`grep` is a command-line tool in Linux used for searching a pattern of characters in a specific file. That pattern is called the regular expression. grep stands for Global Regular Expression Print. It prints all lines containing the pattern in a file. grep command is a useful tool to search through large text files.

## 1. Use `grep` command to search a file

> This is the most basic `grep` command to find a pattern of characters in a specific file.
> You can also enclose a pattern in single or double inverted commas. It is useful when there are multiple words to search.

```
$ grep pattern file_name
```

## 2. Search multiple files using `grep` command
> `grep` command can search through multiple files in a single line of code. To do so, you have to separate file names with a space. It prints every lines that contain pattern along with a file name.
```
$ grep pattern file_name1 file_name2 file_name 
```

## 3. Perform case sensitive search using `grep` command
> This is an important command in `grep -i` which allows you to search for strings pattern case insensitively. It prints the matched pattern having both lowercase and uppercase letters.
```
$ grep -i pattern file_name
```

## 4. `grep` command to search whole words (exact word) only
> Normally, `grep -w` prints every matching characters in a file. But with the help of this command, it only prints if the whole words are matched. When the whole word is not matched, it prints nothing.
```
$ grep -w pattern file_name
```

## 5. Count the number of lines using `grep` command
> `grep -c` command counts the number of lines that contain matching pattern in a file and prints it. It does not count the number of matches in a file.
```
$ grep -c pattern file_name
```

## 6. Inverse the search in `grep` command
> `grep -v` command can be used to inverse the search and print all lines that do not contain the matching pattern.
```
grep -v pattern file_name
```

## 7. `grep` command to print line number
> `grep -n` prints the line number of the pattern that is matched. It is very useful command to locate characters in large files.
```
$ grep -n pattern file_name
```

## 8. Print only the matched pattern with `grep` command
> `grep -o` command prints only the matched pattern instead of the whole line. Normally, grep command prints the whole line that contain pattern till the line breaks.
```
$ grep -o pattern file_name
```

## 9. Search all files in directory using `grep` command
> `grep` command allows you to search all files in the current directory using asterisk(*). It does not search files that are in the sub-directories.
```
$ grep pattern *
```
## 10. `grep` command to search in directories and sub-directories
> This command searches the matches in all files in the current directory including its sub-directories. It also prints the exact path for the file in sub-directories.
```
$ grep -r pattern *
```
## 11. `grep` command to print list of matching files only
> `grep -l` command prints the file names only that contain the matching patterns instead of printing the whole line. It is a useful command when you want to know file names only.
```
$ grep -l pattern *
```
## 12. Print files name having unmatched patterns using `grep` command
> This is just the opposite version of previous command. You can print the names of file that do not contain the matching patterns using `grep -L` command.
```
$ grep -L pattern *
```
## 13. Stop reading a file after NUM matching lines with grep command
> `grep -m` command prints the limited number of line that contains the matching patterns. grep command normally prints all matched patterns in a file.
> It takes a number(NUM) as an argument along with it to print NUM lines. The first NUM lines with the match will only be printed.
```
$ grep -m2 pattern file_name
```

## 14. Take pattern from file using grep command
> `grep -f` command allows you to take pattern from file. It takes pattern from each line.
```
grep -f pattern_file file_name
```
## 15. Print filename along with the match in grep command
> `grep -H` command prints the every line with file name that contain the matching patterns. By default, grep command only prints file names if there are multiple files.
```
$ grep -H pattern file_name
```

## 16. Hide filename of the matched pattern with grep command
> `grep -h` command hides the file name in the output. grep command normally shows file names when there are matched patterns in multiple files. You can use any commands that search in multiple files.
```
$ grep -h pattern file_name1 file_name2 file_name3
```

## 17. Print lines before or after pattern match
> You can print the lines that come before and after the matching patterns.

- `grep -A` n prints the n lines after the match.
- `grep -B` n prints the n lines before the match.
- `grep -C` n prints the n lines before and after the match.
```
$ grep -A n pattern file_name
$ grep -B n pattern file_name
$ grep -C n pattern file_name
```

## 18. Search lines that start with pattern using grep command
> You can search specific lines that start with a pattern using grep command. It does not print other lines that contain the matching pattern elsewhere.
```
$ grep ^pattern file_name
```
## 19. grep command to search lines that end with matching pattern
> You can also search specific lines that end with a pattern using grep command.  You have to put dollar sign`($)` in the end of pattern.
```
$ grep pattern$ file_name
```

## 20. Search for multiple patterns with single command using grep command
`grep -e` command allows you to use multiple patterns at once. -e option indicates an expression in the grep command. Suppose, you need to search three different patterns in a file then you can use:
```
$ grep -e pattern1 -e pattern2 -e pattern3 file_name
```
 
