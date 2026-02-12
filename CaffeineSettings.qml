import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    pluginId: "dankCaffeine"

    ToggleSetting {
        settingKey: "isActive"
        label: "Caffeine Active"
        defaultValue: false
    }

    ToggleSetting {
        settingKey: "restoreOnStartup"
        label: "Restore state on startup"
        defaultValue: true
    }
}
