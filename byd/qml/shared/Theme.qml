import QtQuick

pragma Singleton

Item {
    property int mode: ui ? ui.controlCenterThemeMode : 0
    readonly property bool dark: mode === 1

    property color backgroundColor: dark ? "#0D1117" : "#F5F6F8"
    property color backgroundSecondary: dark ? "#161B22" : "#FFFFFF"

    property color cardColor: dark ? "#1C2128" : "#FFFFFF"
    property color cardBorder: dark ? "#30363D" : "#E1E4E8"

    property color textPrimary: dark ? "#F0F6FC" : "#1F2328"
    property color textSecondary: dark ? "#8B949E" : "#656D76"
    property color textTertiary: dark ? "#484F58" : "#9AFFFFFF"

    property color accentColor: "#0BC3C4"
    property color accentSecondary: "#3874F2"

    property real shadowOpacity: dark ? 0.3 : 0.1
    property color shadowColor: "#000000"

    property real cardRadius: 20
    property real buttonRadius: 12
}
