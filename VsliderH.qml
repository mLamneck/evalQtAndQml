import QtQuick
import QtQuick.Controls

BaseWidget {
	Column {
		anchors.top: parent.top
		anchors.topMargin: 5
		id: sliderGroup
		anchors.fill: parent
		spacing: 5

		Row {
			height: parent.height-anchors.topMargin-currValue.height
			spacing: 10
			Column {
				id: scale
				width: 30
				anchors.verticalCenter: parent.verticalCenter
				Repeater {
					model: 11 // 0, 10, 20, ..., 100
					Item {
						width: parent.width
						height: wd.height / 10
						Row {
							anchors.right: parent.right
							anchors.verticalCenter: parent.verticalCenter
							spacing: 5
							Text {
								text: 100 - (index * 10)
								font.pixelSize: 10
								anchors.verticalCenter: parent.verticalCenter
							}
							Rectangle {
								width: 5
								height: 1
								color: "black"
								anchors.verticalCenter: parent.verticalCenter
							}
						}
					}
				}
			}
			// Slider
			Slider {
				id: wd
				height: parent.height
				orientation: "Vertical"
				from: 0
				to: 100
				value: 50
			}
		}


		Text {
			x: wd.x + (wd.width-width)/2
			id: currValue
			text: Math.round(wd.value)
			font.pixelSize: 14
			font.bold: true
		}

	}
}
