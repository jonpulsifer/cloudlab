#!/usr/bin/env sh
# enable mlock
setcap cap_ipc_lock=+ep $(readlink -f $(which vault))
# replace shell with command
exec $@
