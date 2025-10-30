import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
	id: root
	anchors.fill: parent

	property bool editMode : false
	property list<BaseWidget> widgets
	property list<BaseWidget> selectedWidgets
	property int widgetId : 0

	Rectangle{
		id: canvas
		anchors.fill: parent
		color: "gray"

		MouseArea{
			anchors.fill: parent
			onClicked: function(mouse){
				console.log("onNoWhereClicked")
				deselectAll()
			}
		}
	}

	function add(_type){
		var component = Qt.createComponent(_type)

		if (component.status === Component.Ready) {
			var widget = component.createObject(root, {
				"x": x || 50,
				"y": y,
				"widgetFile": _type,
				"widgetId": widgetId++,
				"editMode": Qt.binding(function() { return root.editMode })
			})
			if (widget){
				widget.moveRequested.connect(function(newX,newY) {
					doOnMoveRequested(widget,newX,newY)
				})
				widget.selectRequested.connect(function() {
					doOnSelectRequested(widget)
				})
				widget.resizeRequested.connect(function(newW,newH) {
					doOnResizeRequested(widget,newW,newH)
				})
				widgets.push(widget)
				return widget
			}
			else{
				console.error("widget null")
			}
		}
		else{
			console.error("Error loading component:", component.errorString())
		}
	}

	function removeWidget(widget) {
		let index = selectedWidgets.indexOf(widget)
		if (index !== -1) {
			selectedWidgets.splice(index, 1)
		}

		index = widgets.indexOf(widget)
		if (index !== -1) {
			widgets.splice(index, 1)
			widget.destroy()
		}
	}

	function removeSelected(){
		let itemsToRemove = [...root.selectedWidgets]
		for (let item of itemsToRemove) {
			removeWidget(item)
		}
	}

	function addToSelection(item){
		if (!selectedWidgets.includes(this)){
			selectedWidgets.push(this)
		}
	}

	function removeFromSelection(item){
		const i = selectedWidgets.indexOf(item)
		if (i !== -1)
			selectedWidgets.splice(i, 1)
	}

	function deselectAll(){
		console.log(selectedWidgets)
		for (let item of root.selectedWidgets) {
			item.deselect()
		}
		selectedWidgets = []
	}

	function doOnMoveRequested(_item, dx, dy){
		_item.x += dx
		_item.y += dy
		for (let item of root.selectedWidgets) {
			if (item === _item) continue
			item.x += dx
			item.y += dy
		}
	}

	function doOnSelectRequested(_item){
		console.log("selected ",editMode)
		console.log(selectedWidgets)
		if (!selectedWidgets.includes(_item)){
			_item.select()
			root.selectedWidgets.push(_item)
			console.log(root.selectedWidgets)
		}
	}

	function doOnResizeRequested(_item,newWidth,newHeight){
		_item.width = newWidth
		_item.height = newHeight
	}

	function saveLayout(){
		let data = []
		for (let w of root.widgets) {
			let wData = {
				widgetFile: w.widgetFile,
				x: w.x,
				y: w.y,
				width : w.width,
				height : w.height
			}
			data.push(wData)
		}
		let res = JSON.stringify(data, null, 2)
		return res
	}

	function loadLayoutFromTable(_tab){
		let d = _tab
		for (var i = 0; i < d.length; i++) {
			var wData = d[i]
			let nw = add(wData.widgetFile)
			if (nw){
				nw.x = wData.x
				nw.y = wData.y
				nw.width = wData.width
				nw.height = wData.height
			}
		}
	}

	function loadLayout(_json){
		let d = JSON.parse(_json)
		loadLayoutFromTable(d)
	}

}
