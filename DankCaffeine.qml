import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    // --- State ---
    property bool isActive: false
    property bool restoreOnStartup: pluginData.restoreOnStartup !== undefined
                                    ? pluginData.restoreOnStartup : true

    // --- Toggle logic ---
    function toggle() {
        if (isActive) {
            deactivate()
        } else {
            activate()
        }
    }

    function activate() {
        if (isActive) return
        Quickshell.execDetached(["dms", "ipc", "call", "inhibit", "enable"])
        isActive = true
        if (pluginService) {
            pluginService.savePluginData(pluginId, "isActive", true)
        }
        ToastService.showInfo("Caffeine", I18n.tr("Screen blanking inhibited"))
    }

    function deactivate() {
        if (!isActive) return
        Quickshell.execDetached(["dms", "ipc", "call", "inhibit", "disable"])
        isActive = false
        if (pluginService) {
            pluginService.savePluginData(pluginId, "isActive", false)
        }
        ToastService.showInfo("Caffeine", I18n.tr("Screen blanking resumed"))
    }

    // --- Restore state on load ---
    Component.onCompleted: {
        if (restoreOnStartup && pluginData.isActive) {
            activate()
        }
    }

    // --- Clean up on unload ---
    Component.onDestruction: {
        if (isActive) {
            Quickshell.execDetached(["dms", "ipc", "call", "inhibit", "disable"])
        }
    }

    // --- DankBar: Horizontal pill ---
    horizontalBarPill: Component {
        Item {
            implicitWidth: hRow.implicitWidth
            implicitHeight: hRow.implicitHeight

            Row {
                id: hRow
                spacing: Theme.spacingS

                DankIcon {
                    name: root.isActive ? "coffee" : "coffee_maker"
                    size: root.iconSize
                    color: root.isActive ? Theme.primary : Theme.surfaceVariantText
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: root.isActive ? I18n.tr("Awake") : I18n.tr("Caffeine")
                    font.pixelSize: Theme.fontSizeMedium
                    color: root.isActive ? Theme.primary : Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.section === "center" || root.section === "left"
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggle()
            }
        }
    }

    // --- DankBar: Vertical pill ---
    verticalBarPill: Component {
        Item {
            implicitWidth: vCol.implicitWidth
            implicitHeight: vCol.implicitHeight

            Column {
                id: vCol
                spacing: Theme.spacingXS

                DankIcon {
                    name: root.isActive ? "coffee" : "coffee_maker"
                    size: root.iconSize
                    color: root.isActive ? Theme.primary : Theme.surfaceVariantText
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggle()
            }
        }
    }
}
