#!/bin/bash
# ~/.config/hypr/Scripts/lock.sh

PIDFILE="/tmp/hyprlock-watcher.pid"
CAFFEINEFILE="/tmp/hyprlock-caffeine"

start_watcher() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
        echo "Watcher already running."
        exit 0
    fi

    (
        while true; do
            sleep 5

            if pidof hyprlock >/dev/null; then
                hyprctl dispatch dpms off
            fi
        done
    ) &

    echo $! > "$PIDFILE"
}

stop_watcher() {
    [ -f "$PIDFILE" ] && kill $(cat "$PIDFILE") 2>/dev/null && rm -f "$PIDFILE"
}

enable_caffeine() {
    touch "$CAFFEINEFILE";
}

disable_caffeine() {
    rm -f "$CAFFEINEFILE";
}

toggle_caffeine() {
    if [ -f "$CAFFEINEFILE" ]; then
        disable_caffeine
    else
        enable_caffeine
    fi
}

status() {
    if [ -f "$CAFFEINEFILE" ]; then
        echo '{"text":"ON","alt":"on","tooltip":"Caffeine mode ON","class":"on"}'
    else
        echo '{"text":"OFF","alt":"off","tooltip":"Caffeine mode OFF","class":"off"}'
    fi
}

lock() {
  if [ ! -f "${CAFFEINEFILE:-}" ]; then
    pidof hyprlock || hyprlock
  fi
}

case "$1" in
    start) start_watcher ;;
    stop) stop_watcher ;;
    caffeine-on) enable_caffeine ;;
    caffeine-off) disable_caffeine ;;
    toggle-caffeine) toggle_caffeine ;;
    status) status ;;
    lock) lock ;;
    *) echo "Usage: $0 {start|stop|caffeine-on|caffeine-off|toggle-caffeine|status|lock}" ;;
esac
