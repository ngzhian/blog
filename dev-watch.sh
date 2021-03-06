# kill hotreload server when this script exits
# from https://www.linuxjournal.com/content/bash-trap-command
trap "kill %?hotreload.py" EXIT

# start hotreload and background it
python3 hotreload.py &

# watch for file changes
fswatch -or template/ posts/ | xargs -o -n 1 -I {} sh -c 'make dev-pages && curl localhost:9001'
