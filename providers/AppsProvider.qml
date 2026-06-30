pragma Singleton

import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property var applications: DesktopEntries.applications.values

    function filter(query) {
        if (!query || query.length === 0)
            return applications

        const needle = query.toLowerCase()

        const startsWith = []
        const contains = []

        for (const app of applications) {
            const name = app.name.toLowerCase()
            const index = name.indexOf(needle)
            if (index === 0)
                startsWith.push(app)
            else if (index > 0)
                contains.push(app)
        }

        const byName = (a, b) => a.name.localeCompare(b.name)
        startsWith.sort(byName)
        contains.sort(byName)

        return startsWith.concat(contains)
    }

    // Returns the single best matching application for a query, or null.
    function findBest(query) {
        const matches = filter(query)
        return matches.length > 0 ? matches[0] : null
    }
}
