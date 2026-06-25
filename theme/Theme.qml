pragma Singleton

import QtQuick

QtObject {
    // Backgrounds (Dark)

    readonly property color dark0Hard: "#1d2021"
    readonly property color dark0: "#282828"
    readonly property color dark0Soft: "#32302f"

    readonly property color dark1: "#3c3836"
    readonly property color dark2: "#504945"
    readonly property color dark3: "#665c54"
    readonly property color dark4: "#7c6f64"

    // Foregrounds (Light)

    readonly property color light0Hard: "#f9f5d7"
    readonly property color light0: "#fbf1c7"
    readonly property color light0Soft: "#f2e5bc"

    readonly property color light1: "#ebdbb2"
    readonly property color light2: "#d5c4a1"
    readonly property color light3: "#bdae93"
    readonly property color light4: "#a89984"

    // Grays

    readonly property color gray: "#928374"

    // Bright colors

    readonly property color brightRed: "#fb4934"
    readonly property color brightGreen: "#b8bb26"
    readonly property color brightYellow: "#fabd2f"
    readonly property color brightBlue: "#83a598"
    readonly property color brightPurple: "#d3869b"
    readonly property color brightAqua: "#8ec07c"
    readonly property color brightOrange: "#fe8019"

    // Neutral colors

    readonly property color neutralRed: "#cc241d"
    readonly property color neutralGreen: "#98971a"
    readonly property color neutralYellow: "#d79921"
    readonly property color neutralBlue: "#458588"
    readonly property color neutralPurple: "#b16286"
    readonly property color neutralAqua: "#689d6a"
    readonly property color neutralOrange: "#d65d0e"

    // Faded colors

    readonly property color fadedRed: "#9d0006"
    readonly property color fadedGreen: "#79740e"
    readonly property color fadedYellow: "#b57614"
    readonly property color fadedBlue: "#076678"
    readonly property color fadedPurple: "#8f3f71"
    readonly property color fadedAqua: "#427b58"
    readonly property color fadedOrange: "#af3a03"

    // Common aliases

    readonly property color backgroundHard: dark0Hard
    readonly property color background: dark0
    readonly property color backgroundSoft: dark0Soft

    readonly property color foreground: light1
    readonly property color foregroundDim: light4

    readonly property color accent: neutralBlue
    readonly property color accentDim: fadedBlue
}