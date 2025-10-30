import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Effects


Item {
	id: baseItem

	property string widgetFile : ""
	property int widgetId : 0
	property int gridSize : 10
	property string itemId: ""
	property bool editMode: false
	property bool isSelected: false
	default property alias content: contentItem.data
	property bool isMovingSource: false

	signal clicked(var mouse)
	signal dragDelta(real deltaX, real deltaY)

	signal resizeRequested(real newWidth, real newHeight)
	signal moveRequested(real newX, real newY)
	signal selectRequested()

	width: 200
	height: 150

	z: editMode ? 100 : 1

	function deselect(){
		console.log("deselect")
		isSelected = false
	}

	function select(){
		isSelected = true
	}

	// Background
	Rectangle {
		id: background
		anchors.fill: parent
		color: isSelected && editMode? "#f5f5f5" : "#f5f5f5"
		//color: isSelected && editMode? "#f5f5f5" : "blue"
		border.color: editMode ? (isSelected ? "#3b82f6" : "#93c5fd") : "#aaaaaa"
		border.width: editMode ? (isSelected ? 3 : 2) : 1
		radius: 4
	}

	// Content
	Container {
		//border.color: "black"
		id: contentItem
		anchors.fill: parent
		anchors.margins: 4
		visible: true
		enabled: !editMode
		onEnabledChanged: console.log("enable changed to ",enabled)
	}

	// move widget
	MouseArea {
		id: dragArea
		anchors.fill: parent
		enabled: editMode
		hoverEnabled: false
		cursorShape: editMode ? Qt.SizeAllCursor : Qt.ArrowCursor
		propagateComposedEvents: !editMode

		property real startX: 0
		property real startY: 0
		property bool isDragging: false

		onPressed: function(mouse){
			console.log("onPressed")
			if (!editMode) {
				mouse.accepted = false
				return
			}

			startX = mouse.x
			startY = mouse.y
		}

		onPositionChanged: function(mouse){
			console.log("onPositionChange")
			let deltaX = Math.round((mouse.x - startX) / gridSize) * gridSize
			let deltaY = Math.round((mouse.y - startY) / gridSize) * gridSize
			isDragging = true
			moveRequested(deltaX,deltaY)
		}

		onReleased: {
			console.log("onReleased")
			if (!isDragging){
				selectRequested()
			}
			isDragging = false
		}
	}

	// Bottom Right
	Rectangle {
		id: resizeHandleBR
		width: 10
		height: 10
		color: "#3b82f6"
		radius: 2
		visible: editMode
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.rightMargin: -5
		anchors.bottomMargin: -5
		z: 10

		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.SizeFDiagCursor

			property real startWidth
			property real startHeight
			property real startGlobalX
			property real startGlobalY

			onPressed: function(mouse) {
				console.log("bottomRight onPressed")
				let g = mapToItem(null, mouse.x, mouse.y)
				startGlobalX = g.x
				startGlobalY = g.y
				startWidth = baseItem.width
				startHeight = baseItem.height
			}

			onPositionChanged: function(mouse) {
				console.log("bottomRight onPositionChanged")
				if (!pressed)
					return

				let g = mapToItem(null, mouse.x, mouse.y)
				let dx = g.x - startGlobalX
				let dy = g.y - startGlobalY
				let newWidth = Math.round( Math.max(50, startWidth + dx) / gridSize) * gridSize
				let newHeight = Math.round(Math.max(50, startHeight + dy) / gridSize) * gridSize
				resizeRequested(newWidth, newHeight)
			}
		}
	}
}
