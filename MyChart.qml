import QtQuick
import QtQuick.Controls
import QtCharts

BaseWidget{
	width: 800
	height: 500

	ChartView {
		id: chart

		//title: "Line Chart"
		anchors.fill: parent
		antialiasing: true
		legend.alignment: Qt.AlignRight
		legend.visible: true

		DateTimeAxis {
			id: axBottom
			titleText: "Zeit"
			tickCount: 10
			format: "hh:mm"
			min: new Date(Date.now())
			max: new Date(Date.now() + 10000)

			property real range: max - min
			property bool isDate: true

			onRangeChanged: {
				const seconds = range / 1000
				if (seconds < 60)
					format = "ss's'"
				else if (seconds < 3600)
					format = "hh:mm:ss"
				else if (seconds < 86400)
					format = "hh:mm"
				else
					format = "dd.MM.yyyy"
			}
		}

		ValueAxis {
			id: axBottom1
			min: 0
			max: 10
			titleText: "Time (s)"
		}

		ValueAxis {
			id: axLeft
			min: 0
			max: 10
			titleText: "Value"
		}

		ValueAxis {
			id: axRight

			min: 0
			max: 10
			titleText: "Value"
		}

		LineSeries {
			id: s1
			name: "series 1"

			axisX: axBottom
			axisY: axLeft
		}

		LineSeries {
			id: s2
			name: "series 2"

			axisX: axBottom
			axisYRight: axRight
			//axisY: axRight

		}

		function zoomAxisLR(axisY, wheel, zoomFactor) {
			const plotArea = chart.plotArea
			const mouseY = wheel.y
			const yRatio = (plotArea.bottom - mouseY) / plotArea.height

			let minVal = axisY.min
			let maxVal = axisY.max

			if (axisY.isDate) {
				minVal = axisY.min.getTime()
				maxVal = axisY.max.getTime()
			}

			const valueAtMouse = minVal + (maxVal - minVal) * yRatio
			const newRange = (maxVal - minVal) * zoomFactor
			const newMin = valueAtMouse - (valueAtMouse - minVal) * zoomFactor
			const newMax = newMin + newRange

			console.log(axisY.isDate)
			if (axisY.isDate) {
				axisY.min = new Date(newMin)
				axisY.max = new Date(newMax)
			} else {
				axisY.min = newMin
				axisY.max = newMax
			}
		}


		MouseArea {
			id: myMouse
			anchors.fill: parent
			hoverEnabled: true
			property bool dragging: false
			property real lastY: 0

			onPressed: (mouse) => {
				const plotArea = chart.plotArea
				if (mouse.x < plotArea.left || mouse.x > plotArea.right) {
					dragging = true
					lastY = mouse.y
					mouse.accepted = true
				}
			}

			onReleased: () => dragging = false

			onPositionChanged: (mouse) => {
				if (!dragging) return
				const plotArea = chart.plotArea
				const dy = mouse.y - lastY
				lastY = mouse.y

				let axis = null
				if (mouse.x < plotArea.left)
					axis = axLeft
				else if (mouse.x > plotArea.right)
					axis = axRight
				if (!axis) return

				const range = axis.max - axis.min
				const delta = (dy / plotArea.height) * range
				axis.min += delta
				axis.max += delta
			}

			onWheel: function(wheel) {
				const zoomFactor = (wheel.angleDelta.y > 0) ? 0.9 : 1.1; // < 1 = zoom in
				const plotArea = chart.plotArea;

				if (mouseX > 0 && mouseX < plotArea.left)//const overYAxis
					chart.zoomAxisLR(axLeft, wheel, zoomFactor)
				else if (mouseX > plotArea.right)
					chart.zoomAxisLR(axRight, wheel, zoomFactor)
				else if (mouseY > plotArea.bottom){
					chart.zoomAxisLR(axBottom, wheel, zoomFactor)
					console.log("over bottom")
				}

				console.log(axRight.alignment)
			}
		}

		Timer {
			running: true
			interval: 10
			repeat: true
			onTriggered: {
				var t = new Date(Date.now()) //s1.count > 0 ? s1.at(s1.count - 1).x + 1 : 0;
				var y = Math.random() * 5;
				s1.append(t, y)
				s2.append(t, y+5)
				if (t > axBottom.max) {
					axBottom.max = t
				}
			}
		}
	}
}
