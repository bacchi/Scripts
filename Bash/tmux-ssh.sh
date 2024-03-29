#!/bin/bash

set -eu

PANE_MINIMUM=2

usage() {
  cat <<USAGE
Usage: $(basename $0) [-c COL] [-r ROW] [--ssh-option SSH_OPTIONS] HOST [HOST2 ...]
  -c, --col int              The number of columns
  -h, --help                Show this message
  -r, --row int              The number of rows
      --ssh-option string    Options passed to SSH
USAGE
}

build_cmd() {
  local host=$1
  local ssh_option=$2
  cmd="ssh $ssh_option $host"
  # Sleep a little to display error messages like "Permission denied (publickey)."
  echo "echo $ $cmd && $cmd || sleep 2"
}

# Parse options
hosts=()
ssh_option=""
tiled=false
while (( $# > 0 )); do
  case $1 in
    -c|--col)
      if [ -n "${row-}" ]; then
        echo -e "Can't specify both of 'col' and 'row'\n" >&2
        exit 1
      fi
      col=$2; shift 2;;
    -h|--help)
      usage
      exit;;
    -r|--row)
      if [ -n "${col-}" ]; then
        echo -e "Can't specify both of 'col' and 'row'\n" >&2
        exit 1
      fi
      row=$2; shift 2;;
    --ssh-option)
      ssh_option=$2; shift 2;;
    -*)
      echo -e "Unknown option: $1\n" >&2
      usage
      exit 1;;
    *)
      hosts+=($1); shift;;
  esac
done

if (( ${#hosts[@]} == 0 )); then
  echo -e "No hosts specified\n" >&2
  usage
  exit 1
fi

if [ -n "${row-}" ]; then
  col=$(( (${#hosts[@]} + $row - 1) / $row ))
elif [ -n "${col-}" ]; then
  row=$(( (${#hosts[@]} + $col - 1) / $col ))
else
  col=${#hosts[@]}
  row=1
  tiled=true
fi


# Split windows
host=${hosts[0]}
cmd=$(build_cmd $host "$ssh_option")
if [ -z "${TMUX-}" ]; then
  tmux new-session -d "$cmd"
else
  tmux new-window "$cmd"
fi

declare $(tmux display -p 'window_width=#{window_width} window_height=#{window_height}')
pane_width=$(( ($window_width - $col + 1) / $col ))
pane_height=$(( ($window_height - $row + 1) / $row ))

for (( r = 0; r < row - 1; ++r )); do
  host=${hosts[$(( $col * ($r + 1) ))]}
  cmd=$(build_cmd $host "$ssh_option")
  tmux split-window -v -l $pane_height -d "$cmd"
done

for (( r = 0; r < row; ++r )); do
  for (( c = 0; c < col - 1; ++c )); do
    idx=$(( $col * $r + $c + 1 ))
    (( $idx == ${#hosts[@]})) && break
    host=${hosts[$idx]}
    cmd=$(build_cmd $host "$ssh_option")
    tmux split-window -h -l $pane_width -d -t $(( $col * $r )) "$cmd"
  done
done

[ "$tiled" = "true" ] && tmux select-layout tiled

tmux set-window-option synchronize-panes on
[ -z "${TMUX-}" ] && tmux attach-session
