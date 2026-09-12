import Quickshell
import "components"

ShellRoot {
    id: root

    settings {
        onLastWindowClosed: {
            Qt.quit();
        }
    }

    Launcher {}
}
