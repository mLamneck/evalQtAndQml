import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import QtQuick.Controls.Material 2.15
import QtQuick.Dialogs

ApplicationWindow {
	id: root
	width: 800
	height: 500
	visible: true
	title: `Vbus Mockup - Qt (${qtversion}) - project: "${filename}"`

	property string filename : ""
	property int currentIndex: 0
	property int spacing: 6
	property string currentTabTitle: "" // Aktuellen Tab über Titel tracken
	property var currentLayoutManager: stackLayoutRepeater.count > 0 ?
		stackLayoutRepeater.itemAt(root.currentIndex)?.children[0] : null

	ListModel {
		id: tabModel
		ListElement { title: "Tab1" }
	}

	header: ToolBar {
		ColumnLayout {
			anchors.fill: parent
			spacing: 0

			RowLayout {
				Layout.fillWidth: true
				Layout.preferredHeight: 40

				Label {
					text: "Mode:"
					font.bold: true
				}
				Switch {
					id: editModeSwitch
					text: checked ? "Edit Mode" : "View Mode"
					checked: true
					onCheckedChanged: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.editMode = checked
						}
					}
				}
				ToolSeparator {}
				Button {
					text: "+ Add Slider"
					onClicked: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.add("VsliderH.qml")
						}
					}
				}
				Button {
					text: "+ Add vEdit"
					onClicked: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.add("Vedit.qml")
						}
					}
				}
				Button {
					text: "+ Add Chart"
					onClicked: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.add("MyChart.qml")
						}
					}
				}
				Button {
					text: "+ Add Graphs"
					onClicked: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.add("MyGraph.qml")
						}
					}
				}

				Button {
					text: "Remove Selected"
					onClicked: {
						if (root.currentLayoutManager) {
							root.currentLayoutManager.removeSelected()
						}
					}
				}

				ToolSeparator {}

				Button {
					text: "Save"
					onClicked: {
						save()
					}
				}
				Button {
					text: "Load"
					onClicked: {
						load()
					}
				}
				Button {
					text: "Clear"
					onClicked: {
						clear()
					}
				}
				Item { Layout.fillWidth: true }
				Switch {
					text: "Light Mode"
					//checked: Material.theme === Material.Light
					//onToggled: Material.theme = checked ? Material.Light : Material.Dark
				}
			}

			// Tab-Leiste
			Row {
				id: tabBar
				Layout.fillWidth: true
				Layout.preferredHeight: 40
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
						newTab()
						Qt.callLater(updateTabPositions)
					}
				}
			}
		}
	}

	Rectangle {
		id: contentArea
		anchors.fill: parent

/*
		color: tabModel.count > 0 ? tabModel.get(root.currentIndex).color : "black"
		Behavior on color {
			ColorAnimation { duration: 200 }
		}
*/
		StackLayout {
			anchors.fill: parent
			currentIndex: root.currentIndex

			Repeater {
				id: stackLayoutRepeater
				model: tabModel

				delegate: Item {
					LayoutManager {
						id: layoutManager
						anchors.fill: parent

						editMode: editModeSwitch.checked
					}
				}
			}
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

	function loadTabsFromJson(jsonString) {
		try {
			var data = JSON.parse(jsonString)

			tabModel.clear()

			if (data.tabs && Array.isArray(data.tabs)) {
				for (var i = 0; i < data.tabs.length; i++) {
					var tab = data.tabs[i]
					tabModel.append({
						title: tab.title || "Tab " + (i + 1),
					})
				}
			}

			// Aktiven Tab setzen
			if (data.currentIndex !== undefined && data.currentIndex < tabModel.count) {
				root.currentIndex = data.currentIndex
			} else {
				root.currentIndex = 0
			}

			updateTabPositions()

			// Layout für jeden LayoutManager laden
			Qt.callLater(function() {
				if (data.tabs && Array.isArray(data.tabs)) {
					for (var i = 0; i < data.tabs.length; i++) {
						if (data.tabs[i].layout) {
							var layoutMgr = stackLayoutRepeater.itemAt(i)?.children[0]
							if (layoutMgr && layoutMgr.loadLayout) {
								layoutMgr.loadLayout(JSON.stringify(data.tabs[i].layout))
							}
						}
					}
				}
			})

			return true
		} catch (e) {
			console.error("Error loading tabs:", e)
			return false
		}
	}

	function loadTabsFromFile(filePath) {
		var xhr = new XMLHttpRequest()
		xhr.open("GET", filePath, true)
		xhr.onreadystatechange = function() {
			if (xhr.readyState === XMLHttpRequest.DONE) {
				if (xhr.status === 200) {
					loadTabsFromJson(xhr.responseText)
				} else {
					console.error("Failed to load file:", filePath)
					statusText.text = "Failed to load file"
				}
			}
		}
		xhr.send()
	}

	function saveTabsToJson() {
		var data = {
			currentIndex: root.currentIndex,
			tabs: []
		}

		for (var i = 0; i < tabModel.count; i++) {
			var tab = tabModel.get(i)
			var tabData = {
				title: tab.title,
			}

			// Layout von LayoutManager speichern
			var layoutMgr = stackLayoutRepeater.itemAt(i)?.children[0]

			if (layoutMgr && layoutMgr.saveLayout) {
				var layoutJson = layoutMgr.saveLayout()
				if (layoutJson) {
					tabData.layout = JSON.parse(layoutJson)
				}
			}

			data.tabs.push(tabData)
		}
		let res = JSON.stringify(data, null, 2)
		console.log(res)
		return res
	}

	property string savedLayout: ""

	function newTab(){
		tabModel.append({
			title: "Tab " + (tabModel.count + 1),
		})
		root.currentIndex = tabModel.count - 1
	}

	function save(){
		saveDialog.open()
	}

	function load(){
		loadDialog.open()
		//loadTabsFromJson(savedLayout)
	}

	function clear(){
		tabModel.clear()
		newTab()
	}

	FileDialog {
		id: saveDialog
		title: "Save JSON"
		fileMode: FileDialog.SaveFile
		nameFilters: ["JSON files (*.json)"]

		onAccepted: {
			filename = selectedFile
			let res = saveTabsToJson()
			filehandler.saveJsonToFile(selectedFile.toString(),res);
		}
	}

	FileDialog {
		id: loadDialog
		title: "Load JSON File"
		fileMode: FileDialog.OpenFile
		nameFilters: ["JSON files (*.json)"]

		onAccepted: {
			filename = selectedFile
			const jsonStr = filehandler.loadJsonFromFile(selectedFile)
			loadTabsFromJson(jsonStr)
		}
	}

	Component.onCompleted: {
		updateTabPositions()
	}
}
