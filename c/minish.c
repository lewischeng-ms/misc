///////////////////////////////////////////////////////////////////////////////
//
//    minish.c - source file for minish
//
//    Author: Lewis Cheng
//	  E-Mail: leecrix@126.com
//    Created@ 	2010/04/28
//    Updated@ 	2010/05/02
//
//    Project: minish (Mini Shell For *nix OS)
//
//    Copyright (C) 2010 Crix(the name of my ideal corporation in the future).
//
//	  Summary:
//	      'minish' as its name mini shell shows, is a lite '*sh'-like shell
//		  which aims at *nix OS(including linux, unix and minix).
//
//        It supports the following functions as it likes in bash(A famous
//		  and popular shell in linux):
//		      1. Three kind of redirections: '<', '>' and '>>'.
//            2. Executing consecutive commands(number unlimited) that are 
//               either connected by pipes('|') or separated by ';' or both.
//            3. Background running('&').
//            4. Integrated commands. Now it just has 'cd', 'clear', 'echo',
//               'exit', 'help', 'history' and 'ver' supported. But additional
//               ones can be added into minish with ease.
//
//	      'minish' tries its best to act like bash(actually I tested many cases
//        in bash to see what it tells us about them and how to deal with them.
//        But still many functions haven't been implmented like tab expansion,
//        switching commands on pressing of arrow keys, conditional statement...
//        and there may be some bugs within existed codes. So I am sincerely 
//        looking forward to your suggestions and advices.
//
//        Thanks for your supporting!
//
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//                                Includes
///////////////////////////////////////////////////////////////////////////////

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// If not debugging.
#define NDEBUG
#include <assert.h>

///////////////////////////////////////////////////////////////////////////////
//                            Constants and Types
///////////////////////////////////////////////////////////////////////////////

// Return type and value indicating success or failure.
#define RESULT int
#define OK 0
#define FAIL 1

// Return type and value indicating true or false.
#define BOOL int
#define TRUE 1
#define FALSE 0

// Limits in minish.
#define MAX_LINE_BUF_SIZE 1024
#define MAX_TOKEN_LENGTH 256
#define MAX_FILENAME_LENGTH MAX_TOKEN_LENGTH
#define MAX_DIRNAME_LENGTH MAX_TOKEN_LENGTH
#define MAX_ARG_COUNT 10
#define MAX_HISTORY_COUNT 20
#define MAX_HELP_COUNT 8
#define INTEGRATED_CMD_COUNT 7

// Types of token.
enum TOKEN_TYPES {
	TOK_NULL,				// NULL
	TOK_REDIR0,				// '<' (input redirection)
	TOK_REDIR1,				// '>' (output redirection)
	TOK_REDIR2,				// '>>' (output redirection append)
	TOK_SEMI,				// ';' (command concatenation)
	TOK_PIPE,				// '|' (pipe)
	TOK_BG,					// '&' (background running)
	TOK_ARG					// ARG (argument)
};

// DFA States.
enum DFA_STATES {
	ST_START,				// Start.
	ST_ASSUME_REDIR1,		// Assume it's '>' but expecting another '>' to form '>>'.
	ST_REMARK,				// Reading remark.
	ST_STRING,				// Reading string quoted by a pair of double quotation marks.
	ST_STRING_ASSUME_END,	// Assume it's single ", but expecting another " to form a " in the target string.
	ST_ARG,					// Reading an argument.
	ST_END					// A token identified.
};

// Types of cmd.
// Integrated commands are defined inside minish,
// and minish knows how to deal with that command
// other than leave them to the user program.
enum CMD_TYPES {
	CMD_CD,			// Integrated command 'cd'.
	CMD_CLEAR,		// Integrated command 'clear'.
	CMD_ECHO,		// Integrated command 'echo'.
	CMD_EXIT,		// Integrated command 'exit'.
	CMD_HELP,		// Integrated command 'help'.
	CMD_HISTORY,	// Integrated command 'history'.
	CMD_VER,		// Integrated command 'ver'.
	CMD_EXEC		// User program.
};

// Flags for command.
enum CMD_FLAGS {
	FL_DEFAULT = 0,
	FL_REDIR0 = 1,
	FL_REDIR1 = 2,
	FL_REDIR2 = 4,
	FL_PIPED = 8,
	FL_BG = 16
};

// Represent a command in the command linked list.
struct CmdNode {
	int type;									// Which type of cmd.
	char name[MAX_FILENAME_LENGTH];				// CmdNode name or file name.
	char * args[MAX_ARG_COUNT];					// Arguments.
	int argc;									// Count of arguments.
	unsigned flags;								// Flags.
	char redir_file[2][MAX_FILENAME_LENGTH];	// Redirection target, 0 for input redir, 1 for output redir.
	struct CmdNode * link;						// Link to next cmd node.
};

struct Token {
	int type;
	char str[MAX_TOKEN_LENGTH];
};

struct CmdMapEntry {
	char * cmd_name;
	int type;
	struct CmdNode * (*act)(struct CmdNode *);
};

struct HelpEntry {
	char * topic;
	char * help;
};

///////////////////////////////////////////////////////////////////////////////
//                             Global Variables
///////////////////////////////////////////////////////////////////////////////

// Current token is stored.
struct Token current_token = { TOK_NULL };

// Head of the command linked list.
struct CmdNode * cmdlist_head;

// do functions.
struct CmdNode * do_cd(struct CmdNode *);
struct CmdNode * do_clear(struct CmdNode *);
struct CmdNode * do_echo(struct CmdNode *);
struct CmdNode * do_exit(struct CmdNode *);
struct CmdNode * do_help(struct CmdNode *);
struct CmdNode * do_history(struct CmdNode *);
struct CmdNode * do_ver(struct CmdNode *);
struct CmdNode * do_exec(struct CmdNode *);

// Map the type of command to its name and action.
struct CmdMapEntry cmd_map[] = {
	{ "cd", 		CMD_CD,			do_cd },
	{ "clear",		CMD_CLEAR,		do_clear },
	{ "echo",		CMD_ECHO,		do_echo },
	{ "exit", 		CMD_EXIT,		do_exit },
	{ "help",		CMD_HELP,		do_help },
	{ "history", 	CMD_HISTORY,	do_history },
	{ "ver",		CMD_VER,		do_ver },
	{ "exec",		CMD_EXEC,		do_exec }
};

// Help database.
struct HelpEntry helps[] = {
	{ "index", 		"index: integrated commands are: cd clear echo exit help history ver" },
	{ "cd",	   		"cd: change current working directory to the specified one" },
	{ "clear", 		"clear: clear the screen (output cannot be redirected)" },
	{ "echo",  		"echo: print each argument passed in their orders" },
	{ "exit",  		"exit: exit minish" },
	{ "help",  		"help: show help usage" },
	{ "history", 	"history: show(no args) or execute history command('-' for last and 'n' for index)" },
	{ "ver", 		"ver: show version info about minish" }
};

char * special_chars = "&<>#;|\" \t";

// Global buffer for the whole line.
char line_buf[MAX_LINE_BUF_SIZE];
char * line_buf_ptr;

// History buffer.
char history[MAX_HISTORY_COUNT][MAX_LINE_BUF_SIZE];
int history_index;

// Whether read new line from input or execute history command.
BOOL executing_history_cmd;

// Whether not to save current command to history.
BOOL dont_save_to_history;

// Whether history isn't empty.
BOOL history_not_empty;

///////////////////////////////////////////////////////////////////////////////
//                              Forward Declaration
///////////////////////////////////////////////////////////////////////////////

// Signals.
void signal_handler(int);
RESULT install_signals();

// Utils.
void show_version();
void show_prompt();
char * get_lite_dir_name();
inline BOOL check_dir(char *);
char * check_existance(char *);

// History.
void load_from_history(int);
void save_to_history();
void clear_history();
void print_history(int);

// Help.
RESULT show_help();

// Debugging.
void debug_print_current_token();
void debug_print_command(struct CmdNode *);

// Lex.
int get_line();
inline BOOL is_special_char(char);
void next_token();

// Parse.
int get_cmd_type(char *);
RESULT parse_to_cmdlist();

// Redirection.
int open_redir_file(char *, mode_t);
RESULT do_inplace_redir(struct CmdNode *);
RESULT do_redir(struct CmdNode *);

// Processing cmdlist.
void free_cmdlist();
void exec_cmdlist();

// do_exec related
char * exec_helper_check(struct CmdNode *);
void do_exec_rec(struct CmdNode *);

///////////////////////////////////////////////////////////////////////////////
//                               Main Entry Point
///////////////////////////////////////////////////////////////////////////////

// Main entry point.
int main(int argc, char * argv[]) {
	// Print welcome.
	show_version();
	
	// Install signal to handle ctrl-c.
	if (install_signals() == FAIL) return FAIL;
	
	// Allocate command list head.
	cmdlist_head = (struct CmdNode *)malloc(sizeof(struct CmdNode));
	if (cmdlist_head == NULL) {
		fprintf(stderr, "minish: not enough memory!\n");
		return 1;
	}
	
	// Begin interactive shell.
	while (TRUE) {
		show_prompt();
		if (get_line() == 0 || parse_to_cmdlist() == FAIL)
			continue;
		exec_cmdlist();
		save_to_history();
		free_cmdlist();
	}
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
//                                 Signals
///////////////////////////////////////////////////////////////////////////////

// Handle signals sent to minish.
void signal_handler(int signo) {
	switch (signo) {
	case SIGINT:
		printf("\n");
		show_prompt();
		break;
	
	default:
		// No other handlers.
		break;
	}
}

// Install signals for minish.
RESULT install_signals() {
	struct sigaction act;
	act.sa_handler = signal_handler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;

	struct sigaction oact;

	if (sigaction(SIGINT, &act, &oact)) {
		fprintf(stderr, "minish: error while installing signals.\n");
		return FAIL;
	}
	return OK;
}

///////////////////////////////////////////////////////////////////////////////
//                                   Utils
///////////////////////////////////////////////////////////////////////////////

// Show version.
void show_version() {
	printf("minish - Mini Shell for *nix OS [ver 0.1 alpha]\n"
		   "Copyright (C) 2010 Crix.\n\n"
		   "Type <help> if you have some questions.\n\n");
}

// Show prompt.
void show_prompt() {
	if (executing_history_cmd == FALSE) {
		printf("[minish %s]>", get_lite_dir_name());
	}
}

// Return the current directory name in the lite mode, not complete path.
char * get_lite_dir_name() {
	// Current directory name is stored.
	static char curr_dir_name[MAX_DIRNAME_LENGTH];
	
	getcwd(curr_dir_name, MAX_DIRNAME_LENGTH);
	return strrchr(curr_dir_name, '/') + 1;
}

// Check if the file is a directory.
inline BOOL check_dir(char * abfn) {
	assert(abfn != NULL);
	struct stat buf;
	if (!stat(abfn, &buf) && (buf.st_mode & S_IFDIR)) {
		return TRUE;
	} else {
		return FALSE;
	}
}

// Check if file specified by filename exists.
// 1. Check if the file exists in the current directory.
//	  This step filters absolute path(contains '/') and relative path based on
//	  the current directory.
// 2. After step 1 fails, if filename contains '/', then it means not found.
//	  Otherwise, combine filename with each item in the env_path(skip leading blanks).
// Returns absolute path if exists or NULL if not.
char * check_existance(char * filename) {
	assert(filename != NULL);

	// Absolute file name buffer.
	static char buf[MAX_FILENAME_LENGTH];
	
	if (access(filename, F_OK)) {
		// Not exist in the current directory.
		if (strchr(filename, '/') != NULL) {
			return NULL;
		} else {
			// Need to synthesize the filename.
			char * buf_ptr = buf;
			int buf_count = 0;
			char * env_ptr = getenv("PATH");
			
			while (TRUE) {
				// Skip leading blanks.
				while (*env_ptr == ' ' || *env_ptr == '\t')
					env_ptr++;
					
				// Get next item in the environment variable 'PATH'.
				while (*env_ptr != '\0' && (*buf_ptr = *env_ptr++) != ':') {
					buf_ptr++;
					buf_count++;
				}
				
				// Add '/' to the end of the path.
				if (buf_count > 0 && buf[buf_count] != '/')
					*buf_ptr++ = '/';
				*buf_ptr = '\0';
				
				// Make full path.
				strncat(buf, filename, MAX_FILENAME_LENGTH);

				// Check existance.
				if (access(buf, F_OK)) {
					// Next item.
					buf_ptr = buf;
					buf_count = 0;
				} else {
					// Exist.
					return buf;
				}
				
				// Meet end.
				if (*env_ptr == '\0') break;
			}
			
			// Not exist.
			return NULL;
		}
	} else {
		return filename;
	}
}

///////////////////////////////////////////////////////////////////////////////
//                                History
///////////////////////////////////////////////////////////////////////////////

// Load the specified history item into the line buffer.
void load_from_history(int index) {
	assert(index >= 0 && index < MAX_HISTORY_COUNT);

	strncpy(line_buf, history[index], MAX_LINE_BUF_SIZE);
	executing_history_cmd = TRUE;
	line_buf_ptr = line_buf;
}

// Save current line buffer to history.
void save_to_history() {
	if (dont_save_to_history) {
		dont_save_to_history = FALSE;
		return;
	}
	strncpy(history[history_index], line_buf, MAX_LINE_BUF_SIZE);
	history_index = (history_index + 1) % MAX_HISTORY_COUNT;
	if (history_not_empty == FALSE) history_not_empty = TRUE;
}

// Clear history.
void clear_history() {
	int i;
	for (i = 0; i < MAX_HISTORY_COUNT; i++)
		history[i][0] = '\0';
	history_index = 0;
	history_not_empty = FALSE;
	printf("minish: history has been cleared.\n");
}

// Print history.
void print_history(int last_cmd_index) {
	// Don't show empty history.
	if (history_not_empty == FALSE) {
		printf("minish: no history yet.\n");
	} else {
		// Print title.
		printf("History: \n");
		
		// Print each command in the history.
		int i;
		for (i = 0; i < MAX_HISTORY_COUNT && history[i][0] != '\0'; i++) {
			if ((i == 0 && history_not_empty == FALSE) || 
				(history_not_empty == TRUE && i == last_cmd_index)) {
				printf("->");
			} else {
				printf("  ");
			}
			printf("%2d %s\n", i, history[i]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//                        		     Help
///////////////////////////////////////////////////////////////////////////////

RESULT show_help(char * topic) {
	if (topic == NULL) {
		printf("usage: help <topic | index>.\n");
		return OK;
	} else {
		int i;
		for (i = 0; i < MAX_HELP_COUNT; i++) {
			if (!strncmp(topic, helps[i].topic, MAX_TOKEN_LENGTH))
				break;
		}
		if (i == MAX_HELP_COUNT) {
			fprintf(stderr, "minish: help: help for '%s' not found.\n", topic);
			return FAIL;
		} else {
			printf("minish: help: %s.\n", helps[i].help);
			return OK;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//                                Debugging
///////////////////////////////////////////////////////////////////////////////

// Print current token when debugging.
void debug_print_current_token() {
	printf("debug: token id = %d, str = %s\n", current_token.type, current_token.str);
}

// Print the command when debugging.
void debug_print_command(struct CmdNode * cmd) {
	assert(cmd != NULL);

	printf("debug: command type = %d, argc = %d, redir0 = %d, redir1 = %d, redir2 = %d, piped = %d.\n",
		   cmd->type, cmd->argc, (cmd->flags & FL_REDIR0) != 0, (cmd->flags & FL_REDIR1) != 0,
		   (cmd->flags & FL_REDIR2) != 0,
		   (cmd->flags & FL_PIPED) != 0);
		   
	// Print args for each cmd.
	int i;
	for (i = 0; i < cmd->argc; i++)
		printf("       with arg[%d] = %s.\n", i, cmd->args[i]);
}

///////////////////////////////////////////////////////////////////////////////
//                                  Lex
///////////////////////////////////////////////////////////////////////////////

// Read a whole line to the line_buf.
int get_line() {
	// Execute history command which has already been stored in the buf.
	// So no need to read a new line from stdin.
	// This should happen after calling 'history <n | ->'.
	if (executing_history_cmd == TRUE) {
		executing_history_cmd = FALSE;
		return strlen(line_buf);
	}
	
	int read_count = 0;
	char * ptr = line_buf;
	
	// Skip leading ctrl-characters.
	char c;
	while ((c = getchar()) == 0xFFFFFFFF);
	ungetc(c, stdin);
	
	while ((*ptr = getchar()) != '\n' &&
		   (read_count < MAX_LINE_BUF_SIZE - 1)) {
		
		++read_count;
		++ptr;
	}
	*ptr = '\0';
	line_buf_ptr = line_buf;
	return read_count;
}

// Return 1 if c is a special char otherwise 0.
inline BOOL is_special_char(char c) {
	char * ptr = special_chars;
	while (*ptr)
		if (*ptr == c)
			return TRUE;
		else
			ptr++;
	return FALSE;
}

// Read next token to the current_token.
void next_token() {
	current_token.type = TOK_NULL;
	char * ptr = current_token.str;
	int curr_state = ST_START;
	while (curr_state != ST_END) {
		switch (curr_state) {
		case ST_START:
			if (*line_buf_ptr == '\0') {
				// No input so directly go to ST_END.
				curr_state = ST_END;
				line_buf_ptr--;
			} else if (*line_buf_ptr < 0 || *line_buf_ptr > 127) {
				// Invalid character encountered.
				fprintf(stderr, "minish: invalid character %c(0x%x) encountered.\n", *line_buf_ptr, *line_buf_ptr);
				curr_state = ST_END;
			} else if (*line_buf_ptr == ' ' || *line_buf_ptr == '\t') {
				// Nothing to do here. Current state is still ST_START.
			} else if (*line_buf_ptr == '>') {
				// Input one > and maybe there's another > following.
				curr_state = ST_ASSUME_REDIR1;
			} else if (*line_buf_ptr == '<') {
				// It's an input redirection mark.
				*ptr++ = '<';
				current_token.type = TOK_REDIR0;
				curr_state = ST_END;
			} else if (*line_buf_ptr == '&') {
				// It's an background mark.
				*ptr++ = '&';
				current_token.type = TOK_BG;
				curr_state = ST_END;
			} else if (*line_buf_ptr == '#') {
				// Begin reading remark to the line end.
				curr_state = ST_REMARK;
			} else if (*line_buf_ptr == ';') {
				// It's an semicolon.
				*ptr++ = ';';
				current_token.type = TOK_SEMI;
				curr_state = ST_END;
			} else if (*line_buf_ptr == '\"') {
				// Begin reading an argument quoted by a pair of double quotation marks.
				current_token.type = TOK_ARG;
				curr_state = ST_STRING;
			} else if (*line_buf_ptr == '|') {
				// It's an pipe mark.
				*ptr++ = '|';
				current_token.type = TOK_PIPE;
				curr_state = ST_END;
			} else {
				// Begin reading an ordinary argument.
				*ptr++ = *line_buf_ptr;
				current_token.type = TOK_ARG;
				curr_state = ST_ARG;
			}
			break;
			
		case ST_ASSUME_REDIR1:
			if (*line_buf_ptr == '>') {
				// Another '>' found so form '>>'.
				*ptr++ = '>';
				*ptr++ = '>';
				current_token.type = TOK_REDIR2;
				curr_state = ST_END;
			} else {
				// Only one '>' so form '>'.
				*ptr++ = '>';
				current_token.type = TOK_REDIR1;
				curr_state = ST_END;
				line_buf_ptr--;
			}
			break;
			
		case ST_REMARK:
			if (*line_buf_ptr == '\0') {
				// Line end.
				curr_state = ST_END;
			}
			break;
			
		case ST_ARG:
			if (*line_buf_ptr == '\0' || is_special_char(*line_buf_ptr)) {
				// End of an ordinary argument.
				line_buf_ptr--;
				curr_state = ST_END;
			} else {
				// Concatenation.
				*ptr++ = *line_buf_ptr;
			}
			break;
			
		case ST_STRING:
			if (*line_buf_ptr == '\0') {
				// Abnormal end of a string, " expected.
				current_token.type = TOK_NULL;
				fprintf(stderr, "minish: double quotation mark expected to enclose the string.\n");
				curr_state = ST_END;
			} else if (*line_buf_ptr == '\"') {
				// Maybe end of a string, but still expect another " to form " in the target string.
				curr_state = ST_STRING_ASSUME_END;
			} else {
				// Concatenation.
				*ptr++ = *line_buf_ptr;
			}
			break;
			
		case ST_STRING_ASSUME_END:
			if (*line_buf_ptr == '\"') {
				*ptr++ = '\"';
				curr_state = ST_STRING;
			} else {
				curr_state = ST_END;
				line_buf_ptr--;
			}
			break;
		}
		line_buf_ptr++;
	}
	if (current_token.type == TOK_NULL)
		strncpy(current_token.str, "<null>", MAX_TOKEN_LENGTH);
	else
		*ptr = '\0';
	
	// Print debugging info about the current token.
#	ifndef NDEBUG
	debug_print_current_token();
#	endif
}

///////////////////////////////////////////////////////////////////////////////
//                                  Parse
///////////////////////////////////////////////////////////////////////////////

// Return the corresponding cmd type to the specified name.
int get_cmd_type(char * name) {
	assert(name != NULL);
	int i;
	for (i = 0; i < INTEGRATED_CMD_COUNT; i++)
		if (!strncmp(name, cmd_map[i].cmd_name, MAX_FILENAME_LENGTH))
			return cmd_map[i].type;
	return CMD_EXEC;
}

// Parse the line to cmd linked list.
RESULT parse_to_cmdlist() {
	struct CmdNode * temp;
	struct CmdNode * lastcmd = cmdlist_head;
	
	// Get first token.
	next_token();
	
	// Create command list.
	while (TRUE) {
		if (current_token.type == TOK_NULL) break;
		
		switch (current_token.type) {
		case TOK_REDIR0:
		case TOK_REDIR1:
		case TOK_REDIR2:
		case TOK_SEMI:
		case TOK_PIPE:
		case TOK_BG:
			// Raise syntax error.
			fprintf(stderr, "minish: syntax error near unexpected token '%s'.\n", current_token.str);
			return FAIL;
			break;
			
		case TOK_ARG:
			// Create a new command.
			temp = (struct CmdNode *)malloc(sizeof(struct CmdNode));
			if (temp == NULL) {
				fprintf(stderr, "minish: not enough memory!\n");
				return FAIL;
			}
			temp->link = NULL;
			temp->flags = FL_DEFAULT;
			
			// Set last cmd pointer.
			lastcmd->link = temp;
			lastcmd = temp;

			// Decide cmd type.
			temp->type = get_cmd_type(current_token.str);
			
			// Decide cmd name.
			if (temp->type == CMD_EXEC) {
				// User command.
				strncpy(temp->name, current_token.str, MAX_TOKEN_LENGTH);
			} else {
				// Built-in command.
				temp->name[0] = '\0';
			}
			
			// Set args[0] to the command name.
			temp->args[0] = (char *)malloc(sizeof(char) * MAX_TOKEN_LENGTH);
			if (temp->args[0] == NULL) {
				fprintf(stderr, "minish: not enough memory!\n");
				return FAIL;
			}
			char * lite_name = strrchr(current_token.str, '/');
			strncpy(temp->args[0], (lite_name ? lite_name + 1 : current_token.str), MAX_TOKEN_LENGTH);
			temp->argc = 1;
			
			// Decide args and redirs.
			next_token();
			
			// According to bash, EOF, ';', '|' and '&' are all recognized as the end of a command.
			// So any consecutive combinaton of the chars above will lead to an error because any
			// valid command won't begin with any of them.
			while (current_token.type != TOK_NULL && current_token.type != TOK_SEMI &&
			       current_token.type != TOK_PIPE && current_token.type != TOK_BG) {
				switch (current_token.type) {
				case TOK_ARG:
					// Read an argument.
					temp->args[temp->argc] = (char *)malloc(sizeof(char) * MAX_TOKEN_LENGTH);
					if (!temp->args[temp->argc]) {
						fprintf(stderr, "minish: not enough memory!\n");
						return FAIL;
					}
					strncpy(temp->args[temp->argc], current_token.str, MAX_TOKEN_LENGTH);
					temp->argc++;
					if (temp->argc > MAX_ARG_COUNT) {
						fprintf(stderr, "minish: too many arguments for command(> %d).\n", MAX_ARG_COUNT);
						return FAIL;
					}
					break;
					
				case TOK_REDIR0:
					// Set input redirection.
					if (temp->flags & FL_REDIR0) {
						fprintf(stderr, "minish: input redirection '<' has been specified.\n");
						return FAIL;
					}
					temp->flags |= FL_REDIR0;
					
					// Read redirection source.
					next_token();
					if (current_token.type != TOK_ARG) {
						fprintf(stderr, "minish: input redirection source missing.\n");
						return FAIL;
					}
					strncpy(temp->redir_file[0], current_token.str, MAX_TOKEN_LENGTH);
					break;
					
				case TOK_REDIR1:
					// Set output redirection.
					if (temp->flags & FL_REDIR2) {
						fprintf(stderr, "minish: output redirection '>>' has been specified.\n");
						return FAIL;
					} else if (temp->flags & FL_REDIR1) {
						fprintf(stderr, "minish: output redirection '>' has been specified.\n");
						return FAIL;
					}
					temp->flags |= FL_REDIR1;
					
					// Read redirection target.
					next_token();
					if (current_token.type != TOK_ARG) {
						fprintf(stderr, "minish: output redirection target missing.\n");
						return FAIL;
					}
					strncpy(temp->redir_file[1], current_token.str, MAX_TOKEN_LENGTH);
					break;
					
				case TOK_REDIR2:
					// Set output-append redirection.
					if (temp->flags & FL_REDIR1) {
						fprintf(stderr, "minish: output redirection '>' has been specified.\n");
						return FAIL;
					} else if (temp->flags & FL_REDIR2) {
						fprintf(stderr, "minish: output redirection '>>' has been specified.\n");
						return FAIL;
					}
					temp->flags |= FL_REDIR2;
					
					// Read redirection target.
					next_token();
					if (current_token.type != TOK_ARG) {
						fprintf(stderr, "minish: output redirection target missing.\n");
						return FAIL;
					}
					strncpy(temp->redir_file[1], current_token.str, MAX_TOKEN_LENGTH);
					break;
				}
				next_token();
			}
			
			// args are terminated by NULL to conform to posix standard.
			temp->args[temp->argc] = NULL;
			
			// TOK_SEMI and TOK_PIPE are both commands-separating tokens.
			if (current_token.type == TOK_SEMI) {
				// Nothing to do.
			} else if (current_token.type == TOK_PIPE) {
				temp->flags |= FL_PIPED;
			} else if (current_token.type == TOK_BG) {
				temp->flags |= FL_BG;
			}
			
			next_token();
			
#			ifndef NDEBUG
			debug_print_command(temp);
#			endif
			break;
		}
	}
	
	return OK;
}

///////////////////////////////////////////////////////////////////////////////
//                               Redirection
///////////////////////////////////////////////////////////////////////////////

// Open or Create(and set file attributes(rights, owner, group...) to default) redir file.
int open_redir_file(char * filename, mode_t open_mode) {
	assert(filename != NULL);

	int fd;
	if (access(filename, F_OK)) {
		// Not exist so create file.
		fd = open(filename, O_CREAT);
		close(fd);
		chown(filename, getuid(), getgid());
		chmod(filename, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
	}
	fd = open(filename, open_mode);
	return fd;
}

// This function should be called in shell processes to handle redirection
// of integrated commands. When cmd is NULL it recovers stdin and stdout
// for shell, otherwise do redirection.
RESULT do_inplace_redir(struct CmdNode * cmd) {
		static int stdin_bak = -1;
		static int stdout_bak = -1;
		
		if (cmd != NULL) {
			// Do redirection.
			assert(cmd->type != CMD_EXEC);
			
			// If input redir is provided.
			if (cmd->flags & FL_REDIR0) {
				// Backup stdin.
				stdin_bak = dup(STDIN_FILENO);
				
				int ifd = open(cmd->redir_file[0], O_RDONLY);
				if (ifd == -1) {
					fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[0]);
					return FAIL;
				}
				
				// Close standard input.
				close(STDIN_FILENO);
				dup(ifd);
				close(ifd);
			}
		
			// If output redir is provided.
			if (cmd->flags & FL_REDIR1) {
				// Backup stdout.
				stdout_bak = dup(STDOUT_FILENO);
				
				int ofd = open_redir_file(cmd->redir_file[1], O_CREAT | O_WRONLY);
				if (ofd == -1) {
					fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[1]);
					return FAIL;
				}
				
				// Close standard output.
				close(STDOUT_FILENO);
				dup(ofd);
				close(ofd);
			} else if (cmd->flags & FL_REDIR2) {
				// Backup stdout.
				stdout_bak = dup(STDOUT_FILENO);
				
				int ofd = open_redir_file(cmd->redir_file[1], O_CREAT | O_APPEND | O_WRONLY);
				if (ofd == -1) {
					fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[1]);
					return FAIL;
				}
				
				// Close standard output.
				close(STDOUT_FILENO);
				dup(ofd);
				close(ofd);
			}
		} else {
			// Do recover.
			if (stdin_bak != -1) {
				close(STDIN_FILENO);
				dup(stdin_bak);
				close(stdin_bak);
				stdin_bak = -1;
			}
			if (stdout_bak != -1) {
				close(STDOUT_FILENO);
				dup(stdout_bak);
				close(stdout_bak);
				stdout_bak = -1;
			}
		}
		return OK;
}

// This function should be called in child processes to do redirection.
RESULT do_redir(struct CmdNode * cmd) {
		assert(cmd != NULL);
		assert(cmd->type == CMD_EXEC);

		// If input redir is provided.
		if (cmd->flags & FL_REDIR0) {
			int ifd = open(cmd->redir_file[0], O_RDONLY);
			if (ifd == -1) {
				fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[0]);
				return FAIL;
			}
			// Close standard input.
			close(STDIN_FILENO);
			dup(ifd);
			close(ifd);
		}
		
		// If output redir is provided.
		if (cmd->flags & FL_REDIR1) {
			int ofd = open_redir_file(cmd->redir_file[1], O_CREAT | O_WRONLY);
			if (ofd == -1) {
				fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[1]);
				return FAIL;
			}
			
			// Close standard output.
			close(STDOUT_FILENO);
			dup(ofd);
			close(ofd);
		} else if (cmd->flags & FL_REDIR2) {
			int ofd = open_redir_file(cmd->redir_file[1], O_CREAT | O_APPEND | O_WRONLY);
			if (ofd == -1) {
				fprintf(stderr, "minish: cannot access %s.\n", cmd->redir_file[1]);
				return FAIL;
			}
			
			// Close standard output.
			close(STDOUT_FILENO);
			dup(ofd);
			close(ofd);
		}
		
		return OK;
}

///////////////////////////////////////////////////////////////////////////////
//                            Processing cmdlist
///////////////////////////////////////////////////////////////////////////////

// Free cmdlist and its related resources.
void free_cmdlist() {
	struct CmdNode * curr = cmdlist_head->link;
	while (curr)
	{
		int i;
		for (i = 0; i < MAX_ARG_COUNT; i++) {
			if (curr->args[i] == NULL) {
				break;
			} else {
				free(curr->args[i]);
				curr->args[i] = NULL;
			}
		}
		struct CmdNode * temp = curr->link;
		free(curr);
		curr = temp;
	}
	cmdlist_head->link = NULL;
}

// Execute all cmds in the cmdlist.
void exec_cmdlist() {
	struct CmdNode * curr = cmdlist_head->link;
	while (curr) {
		struct CmdNode * nextcmd = (*(cmd_map[curr->type].act))(curr);
		curr = nextcmd;
	}
}

///////////////////////////////////////////////////////////////////////////////
//                             do functions
///////////////////////////////////////////////////////////////////////////////

// Change current working directory.
struct CmdNode * do_cd(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_CD);

	// Assume error occurs.
	dont_save_to_history = TRUE;

	if (cmd->argc == 2) {
		if (access(cmd->args[1], F_OK)) {
			// Directory not exist.
			fprintf(stderr, "minish: %s: no such file or directory.\n", cmd->args[1]);
		} else if (check_dir(cmd->args[1]) == FALSE) {
			// It's not a directory.
			fprintf(stderr, "minish: %s: not a directory.\n", cmd->args[1]);
		} else {
			// Change directory.
			chdir(cmd->args[1]);

			// Cmd succeeds, change it to 0.
			dont_save_to_history = FALSE;
		}
		return cmd->link;
	} else {
		fprintf(stderr, "minish: wrong argument numbers specified for command 'cd'.\n");
		return NULL;
	}
}

// Clear the console screen and show prompt at the top of the console.
struct CmdNode * do_clear(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_CLEAR);
	
	printf("\033[1H\033[2J");
	
	return cmd->link;
}

// Echo each args separated by one space.
struct CmdNode * do_echo(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_ECHO);
	
	// Output of command 'echo' can be redirected.
	if (do_inplace_redir(cmd) == FAIL) return NULL;
	
	int i;
	for (i = 1; i < cmd->argc; i++) {
		printf("%s ", cmd->args[i]);
	}
	printf("\n");
	
	do_inplace_redir(NULL);
	
	return cmd->link;
}

// Exit the minish.
struct CmdNode * do_exit(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_EXIT);

	// Output of command 'exit' can be redirected.
	if (do_inplace_redir(cmd) == FAIL) return NULL;
	
	printf("minish: goodbye!\n");
	
	do_inplace_redir(NULL);
	
	exit(OK);
	
	return cmd->link;
}

// Show help for user.
struct CmdNode * do_help(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_HELP);
	
	// Output of command 'help' can be redirected.
	if (do_inplace_redir(cmd) == FAIL) return NULL;

	dont_save_to_history = TRUE;

	if (cmd->argc == 1) {
		show_help(NULL);
		dont_save_to_history = FALSE;
	} else if (cmd->argc == 2) {
		if (show_help(cmd->args[1]) == OK)
			dont_save_to_history = FALSE;
	} else {
		fprintf(stderr, "minish: too many arguments for command 'help'.\n");
	}
	
	do_inplace_redir(NULL);
	
	return cmd->link;
}

// Show and execute history cmd.
struct CmdNode * do_history(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_HISTORY);

	// Output of command 'history' can be redirected.
	if (do_inplace_redir(cmd) == FAIL) return NULL;

	// Don't save command 'history' in command history.
	dont_save_to_history = TRUE;
	
	int last_cmd_index = (history_index - 1 < 0 ? (history_index - 1 + MAX_HISTORY_COUNT) :
		                                          (history_index - 1));
	// Act upon argc.
	if (cmd->argc == 1) {
		// 'history'
		print_history(last_cmd_index);
	} else if (cmd->argc == 2) {
		if (!strncmp(cmd->args[1], "-", MAX_TOKEN_LENGTH)) {
			// 'history -'
			if (strlen(history[last_cmd_index]) == 0) {
				fprintf(stderr, "minish: no last command for command 'history'.\n");
			} else {
				load_from_history(last_cmd_index);
			}
		} else if (!strncmp(cmd->args[1], "clear", MAX_TOKEN_LENGTH)) {
			// 'history clear'
			clear_history();
		} else {
			// 'history n'
			int index;
			sscanf(cmd->args[1], "%d", &index);
			if (index >= 0 && index < MAX_HISTORY_COUNT && strlen(history[index]) > 0) {
				load_from_history(index);
			} else {
				fprintf(stderr, "minish: history command %s not found for command 'history'.\n", cmd->args[1]);
			}
		}
	} else {
		fprintf(stderr, "minish: too many arguments for command 'history'.\n");
	}

	do_inplace_redir(NULL);
	
	return cmd->link;
}

// Print version information.
struct CmdNode * do_ver(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_VER);
	
	// Output of command 'ver' can be redirected.
	if (do_inplace_redir(cmd) == FAIL) return NULL;
	
	show_version();
	
	do_inplace_redir(NULL);
	
	return cmd->link;
}

///////////////////////////////////////////////////////////////////////////////
//                             do_exec related
///////////////////////////////////////////////////////////////////////////////

// Called in shell to check executable file.
char * exec_helper_check(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd ->type == CMD_EXEC);

	// Check if cmd exists and is executable.
	char * abfn = check_existance(cmd->name);
	if (!abfn || access(abfn, X_OK)) {
		fprintf(stderr, "minish: %s: command or file not found.\n", cmd->name);
		return NULL;
	}
	
	// Check if it's a directory.
	if (check_dir(abfn) == TRUE) {
		fprintf(stderr, "minish: %s: is a directory.\n", cmd->name);
		return NULL;
	}
	
	return abfn;
}

// A recursive function to fork off consecutive piped cmds.
// do_exec() creates the proxy process and it calls do_exec_rec().
// The usage of the proxy is to create consecutive processes for
// the piped commands and naturally passes input fd of last pipe
// created(and last child process have the output fd of it) to the new
// child process.
// Note: A process must create a pipe itself, then do close, dup ...
// and finally passes the two fd to its child process. You cannot just
// build up all the pipes at first, and let child processes to do close,
// dup...This will cause lost of some information of the pipes and result
// in some unexpected errors. REMEMBER: Only the one who created a pipe and
// its clones can have operations on that pipe!
void do_exec_rec(struct CmdNode * cmd) {
	assert(cmd != NULL);
	
	char * filename;
	if (cmd->type == CMD_EXEC) {
		// Do checks and get abosulte filename if exists.
		filename = exec_helper_check(cmd);
		if (filename == NULL) {
			exit(FAIL);
			return;
		}
	}
	
	int fd[2];
	if (cmd->flags & FL_PIPED) {
		pipe(fd);
	}
	
	pid_t pid = fork();
	if (pid == 0) {
		// Child process.
	
		if (cmd->flags & FL_PIPED) {
			// Redirect stdout to pipe.
			close(fd[0]);
			close(STDOUT_FILENO);
			dup(fd[1]);
			close(fd[1]);
		}
		
		if (cmd->type == CMD_EXEC) {
			// Do redirections for user program.
			if (do_redir(cmd) == FAIL) {
				exit(FAIL);
				return;
			}
			
			execv(filename, cmd->args);
		} else {
			// Execute integrated command.
			// Redirection will be done inside integrated command.
			// After execution, must exit the child process.
			if ((*(cmd_map[cmd->type].act))(cmd) == NULL)
				exit(FAIL);
			else
				exit(OK);
			return;
		}
	} else {
		// Proxy process.
		
		if (cmd->flags & FL_PIPED) {
			// Redirect stdin to pipe.
			close(fd[1]);
			close(STDIN_FILENO);
			dup(fd[0]);
			close(fd[0]);
			
			// Execute next piped cmd.
			// Note: only call recursively when cmd have
			//       next node and it's flagged piped.
			if (cmd->link != NULL) {
				do_exec_rec(cmd->link);
			}
		}
		
		// If run in background.
		if (!(cmd->flags & FL_BG)) {
			int status = 0;
			waitpid(pid, &status, 0);
		}
		
		// Pipe is not longer used, close it.
		if (cmd->flags & FL_PIPED) {
			close(fd[0]);
			close(fd[1]);
		}
	}
}

// Execute the user command.
struct CmdNode * do_exec(struct CmdNode * cmd) {
	assert(cmd != NULL);
	assert(cmd->type == CMD_EXEC);

	// Create proxy process.
	pid_t pid = fork();
	if (pid == 0) {
		// Proxy process.
		do_exec_rec(cmd);

		// Exit the proxy process after it finishes.
		// Cannot exit from do_exec_rec() because it's a recursive call.
		exit(OK);
		return;
	} else {
		// Shell process.
		
		// Wait for proxy process to exit.
		int status = OK;
		waitpid(pid, &status, 0);

		if (status != OK) dont_save_to_history = TRUE;
		
		// Iterate to next command with no pipe.
		struct CmdNode * curr = cmd;
		while (curr != NULL) {
			if (!(curr->flags & FL_PIPED)) break;
			curr = curr->link;
		}
		
		return curr == NULL ? NULL : curr->link;
	}
}
