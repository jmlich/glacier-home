
// This file is part of colorful-home, a nice user experience for touchscreens.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Copyright (c) 2020-2024, Chupligin Sergey <neochapay@gmail.com>
// Copyright (c) 2017, Eetu Kahelin
// Copyright (c) 2013, Jolla Ltd <robin.burchell@jollamobile.com>
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>
// Copyright (c) 2011, Tom Swindell <t.swindell@rubyx.co.uk>


import QtQuick
import Nemo.Controls
import org.nemomobile.lipstick

Item {
    id: wrapper
    property alias source: iconImage.source
    property alias iconCaption: iconText
    property bool reordering: launcherItem.reordering
    property bool isFolder
    property alias parentItem: launcherItem.parentItem
    property alias folderModel:launcherItem.folderModel

    onXChanged: moveTimer.start()
    onYChanged: moveTimer.start()
    clip: true

    Timer {
        id: moveTimer
        interval: 1
        onTriggered: moveIcon()
    }

    function moveIcon() {
        if (!reordering) {
            if (!launcherItem.slideMoveAnim.running) {
                launcherItem.slideMoveAnim.start()
            }
        }
    }
    // Application icon for the launcher
    LauncherItemWrapper {
        id: launcherItem
        width: wrapper.width
        height: iconWrapper.height+Theme.itemSpacingSmall+Theme.fontSizeTiny*3
        isFolder: wrapper.isFolder

        Item {
            id: iconWrapper
            height: width
            width: parent.width-Theme.itemSpacingSmall*2
            anchors{
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                left: parent.left
                leftMargin: Theme.itemSpacingSmall
            }

            Image {
                id: iconImage
                anchors.centerIn: parent
                height: launcherItem.reordering ? parent.height*1.2 : parent.height
                width: launcherItem.reordering ? parent.width*1.2 : parent.width
                asynchronous: true
                onStatusChanged: {
                    if (iconImage.status == Image.Error) {
                        iconImage.source = "/usr/share/glacier-home/qml/theme/default-icon.png"
                    }
                }
            }

            Spinner {
                id: startSpinner
                anchors.centerIn:  iconImage
                width: parent.width - Theme.itemSpacingHuge
                height: width
                enabled: modelData ? (modelData.object.type === LauncherModel.Application) ? modelData.object.isLaunching ? switcher.switchModel.getWindowIdForTitle(modelData.object.title) == 0 : false : false : false

                Connections {
                    target: Lipstick.compositor
                    function onWindowAdded(window) {
                        if(window.title == modelData.object.title){
                            startSpinner.stop()
                        }
                    }
                }

                onEnabledChanged: {
                    if(enabled) {
                        idleTimer.start()
                    } else {
                        idleTimer.stop();
                    }
                }

                Timer {
                    id: idleTimer
                    interval: 500
                    onTriggered: {
                        startSpinner.stop()
                    }
                }
            }

        }
        // Caption for the icon
        Text {
            id: iconText
            // elide only works if an explicit width is set
            width: iconWrapper.width
            height: Theme.fontSizeTiny*3
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.textColor

            wrapMode: Text.WordWrap

            anchors {
                top: iconWrapper.bottom
                topMargin: Theme.itemSpacingSmall
                horizontalCenter: iconWrapper.horizontalCenter
            }
        }
    }
}
