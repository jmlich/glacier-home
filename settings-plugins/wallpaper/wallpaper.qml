/*
 * Copyright (C) 2018-2022 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
import QtQuick
import Nemo
import Nemo.Controls

import Nemo.Configuration 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: wallpaperSettingsPage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Wallpapers")}

    ConfigurationValue {
        id: differentWallpaper
        key: "/home/glacier/differentWallpaper"
        defaultValue: true
    }

    ConfigurationValue {
        id: homeWallpaperImage
        key: "/home/glacier/homeScreen/wallpaperImage"
        defaultValue: "file:///usr/share/glacier-home/qml/images/wallpaper-portrait-bubbles.png"
    }

    ConfigurationValue{
        id: lockScreenWallpaperImage
        key: "/home/glacier/lockScreen/wallpaperImage"
        defaultValue: "file:///usr/share/glacier-home/qml/images/graphics-wallpaper-home.jpg"
    }

    SettingsColumn{
        id: wallpaperSettings
        spacing: Theme.itemSpacingLarge

        RightCheckBox{
            id: differentImagesCheck
            label: qsTr("Use different images for lockscreen and home screen");
            checked: differentWallpaper.value
            onClicked: differentWallpaper.value = checked
        }

        Rectangle{
            id: homeWallpaper
            width: parent.width
            height: width/4

            color: "transparent"

            Image{
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: homeWallpaperImage.value

                Text{
                    text: (differentWallpaper.value == true) ? qsTr("Homescreen wallpaper") : qsTr("Wallpaper")
                    color: Theme.textColor
                    styleColor: Theme.backgroundColor
                    style: Text.Outline;
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeLarge
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: pageStack.push("file:///usr/share/glacier-settings/plugins/wallpaper/selectImage.qml",{valueKey: "/home/glacier/homeScreen/wallpaperImage"})
                    onPressAndHold: homeWallpaperImage.value = homeWallpaperImage.defaultValue
                }
            }
        }

        Rectangle{
            id: lockScreenWallpaper
            width: parent.width
            height: width/4

            color: "transparent"
            visible: differentWallpaper.value == true

            Image{
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: lockScreenWallpaperImage.value

                Text{
                    text: qsTr("Lockscreen wallpaper")
                    color: Theme.textColor
                    styleColor: Theme.backgroundColor
                    style: Text.Outline;
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSizeLarge
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: pageStack.push("/usr/share/glacier-settings/plugins/wallpaper/selectImage.qml",{valueKey: "/home/glacier/lockScreen/wallpaperImage"})
                onPressAndHold: lockScreenWallpaperImage.value = lockScreenWallpaperImage.defaultValue
            }
        }
    }
}

