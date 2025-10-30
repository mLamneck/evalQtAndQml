import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
	id: root
	width: GridView.view.cellWidth
	height: GridView.view.cellHeight
	radius: 8
	color: Qt.darker(color, 0.9)
	border.color: "#444"
	border.width: 1
	clip: true

	property alias title: titleLabel.text
	property color baseColor: "#4CAF50"
	signal removeRequested()

	Component.onCompleted: console.log("BaseWidget created")
	// Titelzeile
	Rectangle {
		id: header
		anchors.top: parent.top
		width: parent.width
		height: 30
		color: Qt.darker(root.baseColor, 1.2)
		radius: 8

		Row {
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 8
			spacing: 8

			Text {
				id: titleLabel
				color: "white"
				font.bold: true
				font.pixelSize: 14
			}

			Button {
				text: "×"
				width: 24; height: 24
				background: Rectangle { color: "transparent" }
				onClicked: root.removeRequested()
			}
		}
	}

	// Beispielinhalt
	Text {
		anchors.centerIn: parent
		text: "Inhalt"
		color: "white"
		font.pixelSize: 16
	}

	// Einfaches Dragging / Größenänderung
	MouseArea {
		id: dragArea
		anchors.fill: parent
		drag.target: root
		drag.axis: Drag.XAndYAxis
		onPressed: root.z = 1
		onReleased: root.z = 0
	}

	Rectangle {
		id: resizeHandle
		width: 20
		height: 20
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		color: "#888"
		radius: 4
		opacity: 0.6
		visible: true

		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.SizeFDiagCursor
			drag.target: root
			drag.axis: Drag.XAndYAxis
			onPositionChanged: {
				root.width = Math.max(100, root.width + mouse.x)
				root.height = Math.max(80, root.height + mouse.y)
			}
		}
	}
}
