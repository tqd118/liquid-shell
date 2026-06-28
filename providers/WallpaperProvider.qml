pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property var wallpapers: [
        { name: "Anime Skull",  path: "/home/Hequa/themes/wallpapers/gruvbox/anime_skull.jpg" },
        { name: "Astronaut",    path: "/home/Hequa/themes/wallpapers/gruvbox/astronaut.jpg" },
        { name: "Cyborg",       path: "/home/Hequa/themes/wallpapers/gruvbox/cyborg.jpg" },
        { name: "Dragon",       path: "/home/Hequa/themes/wallpapers/gruvbox/dragon.jpg" },
        { name: "GNU Linux",    path: "/home/Hequa/themes/wallpapers/gruvbox/gnulinux.jpg" },
        { name: "Kita",         path: "/home/Hequa/themes/wallpapers/gruvbox/Kita.jpg" },
        { name: "Orbit",        path: "/home/Hequa/themes/wallpapers/gruvbox/orbit.jpg" },
        { name: "Space",        path: "/home/Hequa/themes/wallpapers/gruvbox/space.jpg" },
        { name: "Wallhaven",    path: "/home/Hequa/themes/wallpapers/gruvbox/wallhaven.jpg" },
    ]


    readonly property int current: _state.currentIndex


    function set(index) {
        if (index < 0 || index >= wallpapers.length) return
        _state.currentIndex = index
        _applyCmd.path = wallpapers[index].path
        _applyCmd.running = true
    }

    PersistentProperties {
        id: _state
        property real currentIndex
    }

    Process {
        id: _applyCmd
        property string path: ""
        command: [
            "awww", "img", path,
            "--transition-type", "grow",
            "--transition-pos", "0.5,0.5",
            "--transition-duration", "0.8"
        ]
    }

}
