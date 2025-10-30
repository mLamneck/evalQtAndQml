import QtQuick

BaseWidget{
	Rectangle{
		visible: true
		focus: true
		//z: 2000
		anchors.fill: parent

		Keys.onRightPressed: console.log("kasjdflkasjdfl")

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onEntered: {
				console.log("entered")
				parent.focus = true
				parent.forceActiveFocus() // sorgt dafür, dass die Rectangle wieder Fokus bekommt
			}
			onExited: {
				console.log("exited")
				parent.focus = false
			}
		}

	}
}
