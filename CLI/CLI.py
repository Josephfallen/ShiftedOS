import os
import sys
import subprocess
import ctypes

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def banner():
    WHITE = "\033[37m"

    print(f"{WHITE}  ______   __        __   ______     __                      __         ______    ______  ")
    print(f"{WHITE} /      \\ |  \\      |  \\ /      \\   |  \\                    |  \\       /      \\  /      \\ ")
    print(f"{WHITE}|  $$$$$$\\| $$____   \\$$|  $$$$$$\\ _| $$_     ______    ____| $$      |  $$$$$$\\|  $$$$$$\\")
    print(f"{WHITE}| $$___\\$$| $$    \\ |  \\| $$_  \\$$|   $$ \\   /      \\  /      $$      | $$  | $$| $$___\\$$")
    print(f"{WHITE} \\$$    \\ | $$$$$$$\\| $$| $$ \\     \\$$$$$$  |  $$$$$$\\|  $$$$$$$      | $$  | $$ \\$$    \\ ")
    print(f"{WHITE} _\\$$$$$$$\\| $$  | $$| $$| $$$$      | $$ __ | $$    $$| $$  | $$      | $$  | $$ _\\$$$$$$$\\")
    print(f"{WHITE}|  \\__| $$| $$  | $$| $$| $$        | $$|  \\| $$$$$$$$| $$__| $$      | $$__/ $$|  \\__| $$")
    print(f"{WHITE} \\$$    $$| $$  | $$| $$| $$         \\$$  $$ \\$$     \\ \\$$    $$ ______\\$$    $$ \\$$    $$")
    print(f"{WHITE}  \\$$$$$$  \\$$   \\$$ \\$$ \\$$          \\$$$$   \\$$$$$$$  \\$$$$$$$|      \\\\$$$$$$   \\$$$$$$ ")
    print(f"                                                                                         ")
    print(f"                                                                                         ")

def welcome_screen():
    banner()
    print("1. Launch CLI")
    print("2. Exit")

def shell_loop():
    while True:
        # Display welcome screen
        welcome_screen()

        # Get user choice
        choice = input("Enter your choice: ")

        if choice == "1":
            start_cli()
        elif choice == "2":
            sys.exit()
        else:
            print("Invalid choice. Please enter 1 or 2.")

def start_cli():
    while True:
        command = input(f"{os.getcwd()} $ ")
        tokens = command.split()
        
        if tokens:
            if tokens[0] == "exit":
                break
            elif tokens[0] == "editor":
                run_text_editor()
            elif tokens[0] == "cd":
                change_directory(tokens)
            elif tokens[0] == "ls":
                list_directory(tokens)
            elif tokens[0] == "mkdir":
                make_directory(tokens)
            elif tokens[0] == "rm":
                remove_file(tokens)
            elif tokens[0] == "cp":
                copy_file(tokens)
            elif tokens[0] == "mv":
                move_file(tokens)
            elif tokens[0] == "ipinfo":
                get_ip_info()
            # Add other commands here
            else:
                print("Command not found.")

def run_text_editor():
    lines = []
    print("Enter your text below. Press Ctrl + D (Ctrl + Z on Windows) to save and exit.")
    try:
        while True:
            try:
                line = input()
            except EOFError:
                break
            lines.append(line)
    except KeyboardInterrupt:
        print("\nEditor terminated. No changes were saved.")
        return

    text = '\n'.join(lines)
    print("\nYour text:")
    print(text)

def change_directory(tokens):
    if len(tokens) == 1:
        os.chdir(os.path.expanduser("~"))
    else:
        try:
            os.chdir(tokens[1])
        except FileNotFoundError:
            print("Directory not found.")
        except PermissionError:
            print("Permission denied.")

def list_directory(tokens):
    path = tokens[1] if len(tokens) > 1 else "."
    try:
        files = os.listdir(path)
        for file in files:
            print(file)
    except FileNotFoundError:
        print("Directory not found.")

def make_directory(tokens):
    if len(tokens) > 1:
        try:
            os.mkdir(tokens[1])
        except FileExistsError:
            print("Directory already exists.")

def remove_file(tokens):
    if len(tokens) > 1:
        try:
            os.remove(tokens[1])
        except FileNotFoundError:
            print("File not found.")
        except IsADirectoryError:
            print("Cannot remove a directory. Use 'rm -r' to remove directories.")

def copy_file(tokens):
    if len(tokens) > 2:
        try:
            subprocess.run(["cp", tokens[1], tokens[2]])
        except FileNotFoundError:
            print("File not found.")

def move_file(tokens):
    if len(tokens) > 2:
        try:
            subprocess.run(["mv", tokens[1], tokens[2]])
        except FileNotFoundError:
            print("File not found.")

def get_ip_info():
    try:
        subprocess.run(["ipconfig"])
    except FileNotFoundError:
        print("Command not found. This command only works on Windows.")

if __name__ == "__main__":
    shell_loop()
