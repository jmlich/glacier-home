/* This file is part of glacier-home, a nice user experience for touchscreens.
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
// Copyright (c) 2011, Tom Swindell <t.swindell@rubyx.co.uk>
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>
// Copyright (c) 2021-2022, Chipligin Sergey <neochapay@gmail.com>
*/

import QtQuick 2.6
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.lipstick 0.1
// Feeds page:
// the place for an event feed.

import "feedspage"
import "notifications"

Item {
    id: feedsPage
    width: desktop.width
    height: desktop.height-statusbar.height

    Rectangle{
        id: bg
        anchors.fill: parent
        color: Theme.backgroundColor
        opacity: 0.6
    }

    // Day of week
    Item {
        id: dateRow
        height: Theme.itemHeightExtraLarge
        width: parent.width - Theme.itemSpacingExtraSmall*2
        clip: true

        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingMedium
            left: parent.left
            leftMargin: Theme.itemSpacingExtraSmall
        }

        Label {
            id: displayDayOfWeek
            text: Qt.formatDateTime(wallClock.time, "dddd, MMMM d")
            color: Theme.textColor
            font.pixelSize: Theme.fontSizeLarge
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
    }

    ControlCenter{
        id: controlCenter
        height: Theme.itemHeightExtraLarge
        width: parent.width - Theme.itemSpacingExtraSmall*2

        anchors{
            top: dateRow.bottom
            left: parent.left
            leftMargin: Theme.itemSpacingExtraSmall
        }
    }

    Flickable {
        id: mainFlickable
        width: parent.width - Theme.itemSpacingExtraSmall*2
        height: feedsPage.height-dateRow.height-controlCenter.height-Theme.itemSpacingMedium*4
        contentHeight: notificationColumn.height

        anchors{
            top: controlCenter.bottom
            topMargin: Theme.itemSpacingMedium
            left: parent.left
            leftMargin: Theme.itemSpacingExtraSmall
        }

        clip: true

        Column {
            id: notificationColumn
            width: parent.width
            spacing: Theme.itemSpacingExtraSmall

            Repeater {
                model: NotificationListModel {
                    id: notifmodel
                }
                delegate: NotificationItem{
                    id: notifItem
                    Connections {
                        target: timestampTimer
                        function onTriggered() {
                            notifItem.refreshTimestamp()
                        }

                        function onRunningChanged(running) {
                            if (timestampTimer.running) {
                                notifItem.refreshTimestamp()
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: timestampTimer
        interval: 60000
        running: true
        repeat: true
    }
}
