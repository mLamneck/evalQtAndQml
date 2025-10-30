// TestDemo.qml - Demo Application 6
import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts

ApplicationWindow {
	visible: true
	width: 1200
	height: 800
	title: "Vbus Mockup - Qt Version: " + qtversion

	/*
	Action {
		shortcut: "PgUp"
		onTriggered: console.log("PgUp pressed")
	}
	*/

	id: root

	header: ToolBar {
		RowLayout {
			anchors.fill: parent

			Label {
				text: "Mode:"
				font.bold: true
			}

			Switch {
				id: editModeSwitch
				text: checked ? "Edit Mode" : "View Mode"
				checked: true
			}

			ToolSeparator {}

			Button {
				text: "+ Add Slider"
				onClicked: {
					layoutManager.add("VsliderH.qml")
				}
			}

			Button {
				text: "+ Add vEdit"
				onClicked: {
					layoutManager.add("Vedit.qml")
				}
			}

			Button {
				text: "+ Add Chart"
				onClicked: {
					layoutManager.add("MyChart.qml")
				}
			}

			Button {
				text: "+ Add Graphs"
				onClicked: {
					layoutManager.add("MyGraph.qml")
				}
			}

			Button {
				text: "+ Add TestRect"
				onClicked: {
					layoutManager.add("TestRect.qml")
				}
			}

			Button {
				text: "Remove Selected"
				onClicked: {
					layoutManager.removeSelected()
				}
			}

			Item { Layout.fillWidth: true }

			Switch {
				text: "Light Mode"
				checked: Material.theme === Material.Light
				onToggled: Material.theme = checked ? Material.Light : Material.Dark
			}

			Label {
				id: statusText
				text: "Ready"
				font.italic: true
			}
		}
	}

	LayoutManager{
		id: layoutManager
		editMode : editModeSwitch.checked
	}

	/*
	Rectangle{
		width:100
		height: 100
		visible: true
		focus: true
		z: 2000
		Keys.onRightPressed: console.log("kasjdflkasjdfl")
	}
	*/

	/*
	SplitView {
		anchors.fill: parent
		orientation: Qt.Horizontal

		// ⬇️ Hier definieren wir den Splitter-Stil
		handle: Rectangle {
			implicitWidth: 8       // Dicke bei horizontaler Ausrichtung
			implicitHeight: 8      // Dicke bei vertikaler Ausrichtung
			color: "#888"
			radius: 4

			// Optional: Hover- oder Drag-Effekt
			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.SplitHCursor
				hoverEnabled: true
				onEntered: parent.color = "#555"
				onExited: parent.color = "#888"
			}
		}

		Rectangle {
			color: "#81C784"
			implicitWidth: 200
			Text { anchors.centerIn: parent; text: "Links" }
		}

		Rectangle {
			color: "#64B5F6"
			implicitWidth: 200
			Text { anchors.centerIn: parent; text: "Rechts" }
		}
	}

*/
}
