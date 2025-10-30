import QtQuick
import QtQuick.Controls
import QtGraphs

BaseWidget {
	width: 800
	height: 500
	id: root
	/*
	Action {
		id: openAction
		text: "&Open"
		shortcut: "PgUp"
		onTriggered: console.log("pgUp",widgetId)
	}
	*/
	/*
	MouseArea {
		z: 9999
		Keys.onUpPressed: console.log("PgUp")
		Keys.onDownPressed: console.log("PgDown")
		anchors.fill: parent
		hoverEnabled: true
		//acceptedButtons: Qt.NoButton

		onEntered: {
			console.log("entered")
			this.focus = true
			this.forceActiveFocus() // sorgt dafür, dass die Rectangle wieder Fokus bekommt
		}
		onExited: {
			console.log("exited")
			this.focus = false
		}
	}
	*/

	GraphsView {
		id: chart
		anchors.fill: parent
		antialiasing: true
		theme: GraphsTheme {
			colorScheme: GraphsTheme.ColorScheme.Dark
			seriesColors: ["#E0D080", "#B0A060"]
			borderColors: ["#807040", "#706030"]
			grid.mainColor: "#ccccff"
			grid.subColor: "#eeeeff"
			axisY.mainColor: "#ccccff"
			axisY.subColor: "#eeeeff"
		}

		zoomAreaEnabled: false

		ValueAxis {
			id: axX
			min: 0
			max: 100
			alignment: Qt.AlignBottom
		}

		ValueAxis {
			id: axYLeft
			min: 0
			max: 10
			alignment: Qt.AlignLeft
		}

		ValueAxis {
			alignment: Qt.AlignRight
			id: axYRight
			min: 0
			max: 10
		}

		LineSeries {
			id: s1
			name: "Series 1"
			axisX: axX
			axisY: axYLeft
			color: "steelblue"
		}

		LineSeries {
			id: s2
			name: "Series 2"
			axisX: axX
			axisY: axYRight
			color: "orange"
		}
	}

	function getAxisAtPosition(x, y) {
		console.log("-> getAxisAtPosition",x,y)

		let axes = [];
		/*
		let list = chart.seriesList
		for (let i = 0; i < chart.children.length; i++) {
			let child = chart.children[i];
			console.log("add axis", child)
			if (child.toString().indexOf("ValueAxis") !== -1) {
				axes.push(child);
			}
		}
		*/
		let list = chart.seriesList
		for (let i = 0; i < list.length; i++) {
			let s = list[i];
			console.log("add axis", s, s.axisY.labelDelegate)
			if (axes.indexOf(s.axisY) < 0)
				axes.push(s.axisY);
			if (axes.indexOf(s.axisX) < 0)
				axes.push(s.axisX);

		}

		const plotArea = chart.plotArea
		console.log("-> iterate axes", axes,plotArea, plotArea.left, plotArea.right, plotArea.top, plotArea.bottom)
		for (let axis of axes) {
			console.log("alignment",axis.alignment)
			if (axis.alignment === Qt.AlignLeft) {
				if (x < plotArea.left) {
					console.log("left axis")
					return axis;
				}
			} else if (axis.alignment === Qt.AlignRight) {
				if (x >= plotArea.right) {
					console.log("right axis")
					return axis;
				}
			} else if (axis.alignment === Qt.AlignBottom) {
				console.log("bottom")
				if (y > plotArea.bottom) {
					console.log("bottom axis")
					return axis;
				}
			}
		}
		console.log("<- iterate axes")

		console.log("<- getAxisAtPosition NULL")
		return null;
	}

	MouseArea {
		id: mouseIn
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		propagateComposedEvents: false
		preventStealing: true
		hoverEnabled: true
		focus: true

		property bool dragging: false
		property point lastPos: Qt.point(0, 0)
		property var activeYAxis: null

		onPressed: (mouse) => {
			dragging = true
			lastPos = Qt.point(mouse.x, mouse.y)
			activeYAxis = root.getAxisAtPosition(mouse.x, mouse.y);
		}

		onReleased: (mouse) => {
			dragging = false
			activeYAxis = null
		}

		onPositionChanged: function(mouse) {
			if (!dragging) return

			const dx = mouse.x - lastPos.x
			const dy = mouse.y - lastPos.y
			lastPos = Qt.point(mouse.x, mouse.y)

			if (activeYAxis) {
				const rangeY = activeYAxis.max - activeYAxis.min
				const deltaY = (dy / chart.height) * rangeY
				activeYAxis.min += deltaY
				activeYAxis.max += deltaY
			}
		}

		function zoom(zoomFactor){

		}

		onWheel: function(wheel){
			const plotArea = chart.plotArea
			const zoomFactor = wheel.angleDelta.y > 0 ? 0.9 : 1.1
			const yAxis = root.getAxisAtPosition(wheel.x, wheel.y);
			if (yAxis) {
				//const plotY = wheel.y / chart.height
				const plotY = wheel.y / plotArea.height
				const rangeY = yAxis.max - yAxis.min
				const mouseValueY = yAxis.max - plotY * rangeY
				const newRangeY = rangeY * zoomFactor
				const ratioY = (mouseValueY - yAxis.min) / rangeY

				yAxis.min = mouseValueY - ratioY * newRangeY
				yAxis.max = mouseValueY + (1 - ratioY) * newRangeY
			}
		}
	}

	Timer {
		running: true
		interval: 10
		repeat: true
		property real xValue: 0

		onTriggered: {
			xValue += 1
			const y1 = Math.random() * 5
			const y2 = y1 + 5

			s1.append(xValue, y1)
			s2.append(xValue, y2)

			if (xValue > axX.max) {
				axX.max = xValue
			}
		}
	}

	Rectangle {
		id: dbg
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.margins: 10
		width: 200
		height: 60
		color: "#80000000"
		border.color: "white"
		visible: true

		Column {
			anchors.fill: parent
			anchors.margins: 5
			spacing: 2

			Text {
				color: "white"
				font.pixelSize: 10
				text: "Left Y: [" + axYLeft.min.toFixed(2) + ", " + axYLeft.max.toFixed(2) + "]"
			}
			Text {
				color: "white"
				font.pixelSize: 10
				text: "Right Y: [" + axYRight.min.toFixed(2) + ", " + axYRight.max.toFixed(2) + "]"
			}
			Text {
				color: "white"
				font.pixelSize: 10
				text: "X: [" + mouseIn.mouseX.toFixed(2) + ", " + mouseIn.mouseY.toFixed(2) + "]"
			}
		}
	}
}
