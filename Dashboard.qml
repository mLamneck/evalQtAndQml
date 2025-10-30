import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
	id: dashboard
	anchors.fill: parent
	property int cellWidth: 160
	property int cellHeight: 120

	// Dynamische Liste aller Widgets
	ListModel {
		id: widgetModel
		ListElement { title: "item1"; color: "blue"; x1: 100; y1: 100; width1: 200; height1: 100; type: "slider" }
		ListElement { title: "item2"; color: "red"; x1: 350; y1: 150; width1: 250; height1: 150; type: "chart" }

	}

	// Menü zum Hinzufügen von Widgets
	Button {
		text: "+"
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.margins: 8
		onClicked: {
			widgetModel.append({
				title: "Widget " + (widgetModel.count + 1),
				color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0)
			})
		}
	}

	// Dynamisches Grid
	GridView {
		id: grid
		anchors.fill: parent
		anchors.margins: 10
		cellWidth: dashboard.cellWidth
		cellHeight: dashboard.cellHeight
		model: widgetModel
		interactive: true
		clip: true

		delegate: WidgetItem {
			id: widget
			title: model.title
			color: model.color
			onRemoveRequested: {
				widgetModel.remove(index)
			}
		}
	}
}
