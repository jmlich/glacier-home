import QtQuick 2.6
import Connman 0.2

StatusbarItem {
    id: bluetoothIndicator
    iconSize:       parent.height * 0.671875
    iconSizeHeight: parent.height
    source: "/usr/share/lipstick-glacier-home-qt5/qml/theme/icon_bluetooth.png"
    visible: bluetoothTechnology.powered

    transparent: true


    NetworkTechnology {
        id: bluetoothTechnology
        path: "/net/connman/technology/bluetooth"
    }
}
