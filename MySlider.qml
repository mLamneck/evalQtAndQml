// TestWidget.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

BaseWidget {
	id: root

	width: 250
	height: 180

	// Custom Properties
	property string customText: "Hello Widget!"
	property color customColor: "#4CAF50"

	Rectangle{
		border.color : "red"
		anchors.fill: parent

		// Content
		ColumnLayout {
			id: cdl
			anchors.fill: parent
			spacing: 10

			Rectangle {
				Layout.fillWidth: true
				Layout.preferredHeight: 60
				color: customColor
				radius: 4

				Text {
					anchors.centerIn: parent
					text: customText
					color: "white"
					font.pixelSize: 18
					font.bold: true
				}
			}

			TextField {
				Layout.fillWidth: true
				placeholderText: "Edit text..."
				text: customText
				onTextChanged: customText = text
			}

			Slider {
				Layout.fillWidth: true
				from: 0
				to: 100
				value: 50

				Label {
					anchors.top: parent.bottom
					anchors.topMargin: 2
					text: "Value: " + Math.round(parent.value)
					font.pixelSize: 10
				}
			}
		}

	}
}
