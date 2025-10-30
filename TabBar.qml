import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
	id: root
	width: 800
	height: 500
	visible: true
	title: "Chrome-ähnliche Tabs (ohne Flackern)"

	property int currentIndex: 0
	property int spacing: 6
	property string currentTabTitle: "" // Aktuellen Tab über Titel tracken

	ListModel {
		id: tabModel
		ListElement { title: "Home"; color: "teal" }
		ListElement { title: "Discover"; color: "plum" }
		ListElement { title: "Activity"; color: "blue" }
	}

	Row {
		id: tabBar
		width: parent.width
		height: 40
		anchors.top: parent.top
		spacing: root.spacing

		Repeater {
			id: tabRepeater
			model: tabModel

			delegate: Rectangle {
				id: tab
				height: parent.height - 4
				radius: 6
				border.color: "#999"
				color: index === root.currentIndex ? "#555" : "#777"
				z: dragArea.drag.active ? 100 : 1

				property int tabIndex: index
				property real targetX: 0
				property real padding: 20
				property bool isDragging: dragArea.drag.active

				width: titleText.paintedWidth + padding

				// Nur animieren wenn nicht gedragged wird
				x: isDragging ? x : targetX

				Behavior on x {
					enabled: !tab.isDragging
					NumberAnimation {
						duration: 150
						easing.type: Easing.OutQuad
					}
				}

				Behavior on color {
					ColorAnimation { duration: 150 }
				}

				Text {
					id: titleText
					anchors.centerIn: parent
					text: model.title
					color: "white"
				}

				MouseArea {
					id: dragArea
					anchors.fill: parent
					drag.target: tab
					drag.axis: Drag.XAxis

					property real startX: 0
					property int startIndex: -1
					property bool wasActive: false

					onPressed: {
						startX = tab.x
						startIndex = tab.tabIndex
						wasActive = (root.currentIndex === tab.tabIndex)
					}

					onReleased: {
						// Position auf Ziel-X snappen
						updateTabPositions()

						// Wenn dieser Tab aktiv war, Index aktualisieren
						if (wasActive) {
							root.currentIndex = tab.tabIndex
						}
					}

					onClicked: {
						root.currentIndex = tabIndex
					}

					onPositionChanged: {
						if (!drag.active) return

						// Mitte des gezogenen Tabs
						var dragCenterX = tab.x + tab.width / 2
						var targetIndex = -1
						var cumulative = 0

						// Finde den Index, an dem der Tab sein sollte
						for (var i = 0; i < tabRepeater.count; ++i) {
							var t = tabRepeater.itemAt(i)
							if (!t) continue

							var left = cumulative
							var right = cumulative + t.width

							if (dragCenterX >= left && dragCenterX <= right) {
								targetIndex = i
								break
							}

							cumulative += t.width + root.spacing
						}

						// Nur verschieben wenn sich der Index geändert hat
						if (targetIndex !== -1 && targetIndex !== tab.tabIndex) {
							var wasCurrentTab = (root.currentIndex === tab.tabIndex)

							tabModel.move(tab.tabIndex, targetIndex, 1)

							// Wenn dieser Tab aktiv war, den Index mitbewegen
							if (wasCurrentTab) {
								root.currentIndex = targetIndex
							} else if (targetIndex <= root.currentIndex && tab.tabIndex > root.currentIndex) {
								// Tab wurde vor den aktiven Tab geschoben
								root.currentIndex++
							} else if (targetIndex > root.currentIndex && tab.tabIndex <= root.currentIndex) {
								// Tab wurde nach dem aktiven Tab geschoben
								root.currentIndex--
							}

							// Positionen aktualisieren, aber gedraggten Tab ausschließen
							updateTabPositions()
						}
					}
				}
			}
		}

		Button {
			text: "+"
			height: 30
			width: 40
			onClicked: {
				tabModel.append({
					title: "New " + (tabModel.count + 1),
					color: "red"//Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
				})
				root.currentIndex = tabModel.count - 1
				Qt.callLater(updateTabPositions)
			}
		}
	}

	Rectangle {
		anchors.top: tabBar.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		color: tabModel.count > 0 ? tabModel.get(root.currentIndex).color : "black"

		Behavior on color {
			ColorAnimation { duration: 200 }
		}

		Text {
			anchors.centerIn: parent
			text: tabModel.count > 0 ? tabModel.get(root.currentIndex).title : "Keine Tabs"
			color: "white"
			font.pixelSize: 24
		}
	}

	function updateTabPositions() {
		var x = 0
		for (var i = 0; i < tabRepeater.count; ++i) {
			var t = tabRepeater.itemAt(i)
			if (!t) continue

			t.tabIndex = i
			t.targetX = x
			x += t.width + root.spacing
		}
	}

	Component.onCompleted: updateTabPositions()
}
