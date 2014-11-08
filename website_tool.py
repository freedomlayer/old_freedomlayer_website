"""
Thu Oct 23 11:38:56 IDT 2014
Automation script for building and deploying the website,
by xorpd.

Should be later ported to fabric, when fabric supports python3.
"""

import os
import shutil
import sys

import inspect


OUTPUT_DIR = "./output"

class ExceptDeploy(Exception):
    pass

class ExceptBuild(Exception):
    pass

def run_sys(sys_cmd):
    """
    Run a system command and also print the command being run.
    """
    print(sys_cmd)
    return os.system(sys_cmd)

def clear_dst_dir(dst_dir):
    """
    Delete everything from dst dir, except for git repository stuff:
    """
    def should_delete(f):
        """
        Check if we should delete the file/folder f
        when cleaning dst_dir.
        """
        GIT_INITIAL = ".git"
        if f.startswith(GIT_INITIAL):
            return False
        return True

    # Check if the directory exists:
    if not os.path.exists(dst_dir):
        return

    assert os.path.isdir(dst_dir),"Only directories are allowed!"

    # Go over the top level directory files.
    # Remove any file or directory that doesn't begin with ".git".
    files = os.listdir(dst_dir)
    for f in files:
        if should_delete(f):
            f_path = os.path.join(dst_dir,f)
            if os.path.isdir(f_path):
                # If directory: remove the directory.
                shutil.rmtree(f_path)
            else:
                # If file: remove the file.
                os.remove(f_path)


def cmd_clean():
    """
    Clean output directory. (But do not delete git repository files).
    """
    print("Cleaning destination directory")
    clear_dst_dir(OUTPUT_DIR)


def cmd_build():
    """
    Build the website.
    """
    cmd_clean()
    res_build = run_sys('python3 make_website.py')
    if res_build != 0:
        raise ExceptBuild()

# More info could be found here:
# http://stackoverflow.com/questions/10280691/
#   cant-commit-from-fabric-script-for-github
#
CNAME_DOMAIN = "www.freedomlayer.org"
def cmd_deploy(commit_msg):
    """
    First build the website.

    Next add changes to website repository, commit them and finally push to
    remote origin.
    """
    cmd_build()
    # Keep original directory.
    original_dir = os.getcwd() 
    os.chdir(OUTPUT_DIR)
    try:
        # Add a CNAME record if needed:
        # Set up the CNAME file:
        run_sys('echo ' + CNAME_DOMAIN + ' > CNAME')
        res_git_add = run_sys('git add -A')
        if res_git_add != 0:
            raise ExceptDeploy("git add -A didn't work.")

        commit_res = run_sys('git commit -m "%s"'%(commit_msg))
        if commit_res != 0:
            print("Commit returned error code.")

        res_git_push = run_sys('git push origin master')
        if res_git_push != 0:
            raise ExceptDeploy("Git push origin master didn't work.")
    finally:
        # Restore original directory:
        os.chdir(original_dir)


def go():
    argv = list(sys.argv)
    prog_name = argv.pop(0)
    if len(argv) <= 0:
        print("Usage: ",prog_name,"command")
        return

    command_name = argv.pop(0)
    func_name = "cmd_" + command_name

    # Look for relevant function:
    if func_name not in globals():
        print("command not found.")
        return

    # Get function object:
    func = globals()[func_name]

    # Check if we have enough arguments:
    num_args = len(inspect.getargspec(func).args)
    if len(argv) < num_args:
        print("Not enough arguments.",num_args, "are needed.")
        return

    # Run the function with the arguments: 
    func(*argv[:num_args])


if __name__ == "__main__":
    go()

