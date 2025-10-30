import QtQuick

BaseWidget {
	width: 100
	height: 50

	TextInput {
		id: wd
		anchors.fill: parent
		color: "black"
		text: "0.121323"

		font.pixelSize: Math.min(width, height) * 0.7
	}
}
