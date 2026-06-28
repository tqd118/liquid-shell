pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property real   percentage:  UPower.displayDevice.percentage * 100
    readonly property var    state:       UPower.displayDevice.state
    readonly property string stateString: UPowerDeviceState.toString(state)
    readonly property real   ttl: {
        const s = UPower.displayDevice.state
        if (s === UPowerDeviceState.Charging)    return UPower.displayDevice.timeToFull
        if (s === UPowerDeviceState.Discharging) return UPower.displayDevice.timeToEmpty
        return 0
    }
    readonly property string timeString: `Time to ${isCharging ? "full" : "empty"}: ${formatTime(ttl)}`

    readonly property bool isFull: state === UPowerDeviceState.FullyCharged
    readonly property bool isCharging: state === UPowerDeviceState.Charging

    function formatTime(seconds) {
        seconds = Number(seconds);

        var hours = Math.floor(seconds / 3600);
        var minutes = Math.floor((seconds % 3600) / 60);

        if (hours === 0) {
            return minutes + " min";
        }

        return hours + " hour, " + minutes + " min";
    }
}
