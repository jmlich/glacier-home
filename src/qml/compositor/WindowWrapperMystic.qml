// Copyright (C) 2013 Jolla Ltd, Robin Burchell: <robin.burchell@jolla.com>
// Copyright (C) 2014 Aleksi Suomalainen: <suomalainen.aleksi@gmail.com>
//
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

import QtQuick
import QtQuick.Window
import org.nemomobile.lipstick

WindowWrapperBase {
    id: wrapper
    property bool windowed: parent != applicationLayer
    readonly property bool isActive: windowed && parent.activeWindow == wrapper
    onIsActiveChanged: console.log("isActive:", isActive)
    z: isActive ? 1 : 0

    ShaderEffect {
        anchors.fill: parent
        z: 2
        // source Item must be a texture provider
        property Item source: wrapper.window

        fragmentShader: "
           uniform sampler2D source;
           uniform mediump float qt_Opacity;
           varying highp vec2 qt_TexCoord0;
           void main() {
               gl_FragColor = qt_Opacity * vec4(texture2D(source, qt_TexCoord0).rgb, 1);
           }"
    }
    onWindowChanged: {
        if (window != null) {
            // do not paint the QWaylandSurfaceItem, just use it as
            // a texture provider
            window.setPaintEnabled(false)
        }
    }


    MouseArea{
        id: windowHeader
        width: parent.width + size.dp(8)
        height: parent.height - y + size.dp(8)
        y: -Theme.itemHeightMedium
        x: -size.dp(4)
        z: (window) ? window.z - 1 : 0
        visible: (window) ? (window.width != Screen.width || window.height != Screen.height) : false

        onPressAndHold: {
            drag.target = window.userData
        }

        onReleased: {
            drag.target = null
        }

        onClicked: {
            wrapper.parent.activeWindow = wrapper
        }

        onDoubleClicked: {
            window.userData.x = 0
            window.userData.y = 0
            requestWindowSize(window,Qt.size(Screen.width, Screen.height))
            wrapper.parent = root.applicationLayer
            setCurrentWindow(wrapper)
        }

        Image {
            id: closeWindow
            source: "image://theme/times"

            height: Theme.itemHeightMedium
            width: height

            anchors{
                top: parent.top
                topMargin: 1
                right: parent.right
                rightMargin: 1
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    Lipstick.compositor.closeClientForWindowId(window.windowId)
                }
            }

            z: windowHeader.z + 2
        }

        Rectangle{
            anchors.fill: parent
            color: parent.drag.target
                   ? Theme.backgroundAccentColor
                   : Theme.accentColor
        }
    }
}
