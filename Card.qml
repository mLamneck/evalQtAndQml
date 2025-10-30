import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
	id: card
	property alias content: contentItem.data
	property string title: ""
	property color backgroundColor: "white"
	property color borderColor: "#999"
	property int borderWidth: 1
	property int radius: 12
	property int elevation: 8   // Schattenhöhe

	width: 250
	height: 150

	// Hauptrechteck mit Schatten
	Rectangle {
		id: mainRect
		anchors.fill: parent
		color: backgroundColor
		radius: card.radius
		border.color: borderColor
		border.width: borderWidth

		// Platz für Inhalt
		Item {
			id: contentItem
			anchors.fill: parent
			anchors.margins: 16
		}
	}

	// Caption/Titel oben
	Rectangle {
		visible: title !== ""
		width: titleText.width + 16
		height: titleText.height + 4
		x: 16
		y: -titleText.height / 2
		color: backgroundColor
		border.color: borderColor
		radius: 4

		Text {
			id: titleText
			text: card.title
			anchors.centerIn: parent
			font.bold: true
		}
	}
}
