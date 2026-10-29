import sys
import os
import subprocess

from PyQt6.QtWidgets import QApplication, QSystemTrayIcon, QMenu
from PyQt6.QtGui import QIcon, QAction

STATE_FILE = os.path.expanduser("~/.fan_mode_state")

def get_state():
    if os.path.exists(STATE_FILE):
        return open(STATE_FILE).read().strip()
    return "auto"

def set_state(state):
    with open(STATE_FILE, "w") as f:
        f.write(state)

def run_cmd(cmd):
    subprocess.run(cmd)

def get_icon(state):
    if state == "full":
        icon = QIcon.fromTheme("speedometer")
        if icon.isNull():
            icon = QIcon.fromTheme("media-playback-start")
        return icon
    else:
        icon = QIcon.fromTheme("view-refresh")
        if icon.isNull():
            icon = QIcon.fromTheme("process-stop")
        return icon

def apply_state():
    state = get_state()

    tray.setIcon(get_icon(state))

    if state == "full":
        tray.setToolTip("Fan Mode: Full Speed")
    else:
        tray.setToolTip("Fan Mode: Auto")

def toggle():
    state = get_state()

    if state == "full":
        run_cmd(["sudo", "asus-fan-control-ec", "set", "-1"])
        set_state("auto")
    else:
        run_cmd(["sudo", "asus-fan-control-ec", "set", "255"])
        set_state("full")

    apply_state()

def quit_app():
    QApplication.quit()

app = QApplication(sys.argv)

tray = QSystemTrayIcon()

# Menu
menu = QMenu()

toggle_action = QAction("Toggle Fan Mode")
toggle_action.triggered.connect(toggle)
menu.addAction(toggle_action)

quit_action = QAction("Quit")
quit_action.triggered.connect(quit_app)
menu.addAction(quit_action)

tray.setContextMenu(menu)

# Left click toggle
tray.activated.connect(
    lambda reason: toggle()
    if reason == QSystemTrayIcon.ActivationReason.Trigger
    else None
)

apply_state()

tray.show()

sys.exit(app.exec())
