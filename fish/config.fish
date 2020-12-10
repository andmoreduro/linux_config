set fish_greeting
set TERM "xterm-256color"
set BROWSER /usr/bin/google-chrome-stable
set GOPATH /home/andresm/dev/Golang
set -a PATH $GOPATH/bin
set -a PATH /home/andresm/.cargo/bin

### PROMPT ###
#function fish_prompt
#  set -l last_status $status
#  set -l cyan (set_color -o cyan)
#  set -l yellow (set_color -o yellow)
#  set -g red (set_color -o red)
#  set -g blue (set_color -o blue)
#  set -l green (set_color -o green)
#  set -g normal (set_color normal)
#
#  set -l ahead (_git_ahead)
#  set -g whitespace ' '
#
#  if test $last_status = 0
#    set initial_indicator "$green◆ $red(\$)"
#    set status_indicator "$normal❯$green❯$blue❯"
#  else
#    set initial_indicator "$red✖ $last_status $red(\$)"
#    set status_indicator "$red❯$red❯$red❯"
#  end
#  set -l cwd $cyan(basename (prompt_pwd))
#
#  if [ (_git_branch_name) ]
#
#    if test (_git_branch_name) = 'master'
#      set -l git_branch (_git_branch_name)
#      set git_info "$normal git:($red$git_branch$normal)"
#    else
#      set -l git_branch (_git_branch_name)
#      set git_info "$normal git:($blue$git_branch$normal)"
#    end
#
#    if [ (_is_git_dirty) ]
#      set -l dirty "$yellow ✗"
#      set git_info "$git_info$dirty"
#    end
#  end
#
#  # Notify if a command took more than 5 minutes
#  if [ "$CMD_DURATION" -gt 300000 ]
#    echo The last command took (math "$CMD_DURATION/1000") seconds.
#  end
#
#  echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
#end
#
#function _git_ahead
#  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null)
#  if [ $status != 0 ]
#    return
#  end
#  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
#  set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
#  switch "$ahead $behind"
#    case ''     # no upstream
#    case '0 0'  # equal to upstream
#      return
#    case '* 0'  # ahead of upstream
#      echo "$blue↑$normal_c$ahead$whitespace"
#    case '0 *'  # behind upstream
#      echo "$red↓$normal_c$behind$whitespace"
#    case '*'    # diverged from upstream
#      echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
#  end
#end
#
#function _git_branch_name
#  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
#end
#
#function _is_git_dirty
#  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
#end
#
#function fish_mode_prompt
#  switch $fish_bind_mode
#    case default
#      echo ''
#    case insert
#      set_color --bold green
#      echo '(I) '
#    case replace_one
#      set_color --bold green
#      echo '(R) '
#    case visual
#      set_color --bold brmagenta
#      echo '(V) '
#    case '*'
#      set_color --bold red
#      echo '(?) '
#  end
#  set_color normal
#end
### END OF PROMPT ###

# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end
# The bindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Function for printing a column (splits input on whitespace)
# ex: echo 1 2 3 | coln 3
# output: 3
function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# Function for printing a row
# ex: seq 3 | rown 3
# output: 3
function rown --argument index
    sed -n "$index p"
end

# Function for ignoring the first 'n' lines
# ex: seq 10 | skip 5
# results: prints everything but the first 5 lines
function skip --argument n
    tail +(math 1 + $n)
end

# Function for taking the first 'n' lines
# ex: seq 10 | take 5
# results: prints only the first 5 lines
function take --argument number
    head -$number
end
### END OF FUNCTIONS ###

### ALIASES ###
alias ..='cd ..'             # Go back 1 time
alias .2='cd ../..'          # ''  ''  2  ''
alias .3='cd ../../..'       # ''  ''  3  ''
alias .4='cd ../../../..'    # ''  ''  4  ''
alias .5='cd ../../../../..' # ''  ''  5  ''

# Changing "ls" to "exa"
alias list='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'    # all files and dirs
alias ll='exa -l --color=always --group-directories-first'    # long format
alias lt='exa -aT --color=always --group-directories-first'   # tree listing

# pacman and yay
alias pacsyu='sudo pacman -Syyu'                 # update only standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cpi="cp -i"
alias mvi='mv -i'
alias rmi='rm -i'

# Get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# Oher stuff
alias vim="nvim"

### STARSHIP SHELL ###
starship init fish | source
