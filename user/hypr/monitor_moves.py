import os
import socket
from pathlib import Path
from time import sleep

PINNED_WORKSPACES = [1, 2, 3, 4, 5, 6]


def parse_line(line: str) -> (str, str):
    parts = line.split(">>")[1].split(",")
    return (
        parts[0],
        parts[1]
    )


def handler_add(line: str):
    number, name = parse_line(line)

    # ensure_monitor(name)

    for workspace in PINNED_WORKSPACES:
        cmd = f"hyprctl dispatch moveworkspacetomonitor {workspace} {name}"
        print(cmd)
        os.system(cmd)

    os.system("swww img ~/.config/wallpaper/walls-catppuccin-mocha/bluehour.jpg")


def handler_remove(line: str, active_workspace: int):
    sleep(1)
    os.system(f"hyprctl dispatch workspace {active_workspace}")


def handler_focused(line: str):
    name, workspace = line.split(">>")[1].split(",")
    return int(workspace)


def main():
    runtime_dir = Path(os.environ["XDG_RUNTIME_DIR"])
    instance_signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
    socket_path = runtime_dir / "hypr" / instance_signature / ".socket2.sock"

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(str(socket_path))

    active_workspace = 1

    while True:
        buf = sock.recv(4096)

        if buf == bytes():
            break

        parts = buf.decode("utf-8").split("\n")
        lines = list(filter(lambda x: len(x) > 0, parts))

        for line in lines:
            if "monitorremovedv2>>" in line:
                handler_remove(line, active_workspace)
            if "monitoraddedv2>>" in line:
                handler_add(line)
            if "focusedmonv2>>" in line:
                active_workspace = handler_focused(line)

    sock.close()


if __name__ == "__main__":
    main()
