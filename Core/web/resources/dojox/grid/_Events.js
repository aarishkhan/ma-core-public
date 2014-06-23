//>>built
define("dojox/grid/_Events",["dojo/keys","dojo/dom-class","dojo/_base/declare","dojo/_base/event","dojo/_base/sniff"],function(c,e,f,d,g){return f("dojox.grid._Events",null,{cellOverClass:"dojoxGridCellOver",onKeyEvent:function(a){this.dispatchKeyEvent(a)},onContentEvent:function(a){this.dispatchContentEvent(a)},onHeaderEvent:function(a){this.dispatchHeaderEvent(a)},onStyleRow:function(a){a.customClasses+=(a.odd?" dojoxGridRowOdd":"")+(a.selected?" dojoxGridRowSelected":"")+(a.over?" dojoxGridRowOver":
"");this.focus.styleRow(a);this.edit.styleRow(a)},onKeyDown:function(a){if(!a.altKey&&!a.metaKey){var b;switch(a.keyCode){case c.ESCAPE:this.edit.cancel();break;case c.ENTER:if(!this.edit.isEditing()){b=this.focus.getHeaderIndex();if(0<=b){this.setSortIndex(b);break}else this.selection.clickSelect(this.focus.rowIndex,dojo.isCopyKey(a),a.shiftKey);d.stop(a)}a.shiftKey||(b=this.edit.isEditing(),this.edit.apply(),b||this.edit.setEditCell(this.focus.cell,this.focus.rowIndex));this.edit.isEditing()||((this.focus.focusView||
this.views.views[0]).content.decorateEvent(a),this.onRowClick(a),d.stop(a));break;case c.SPACE:if(!this.edit.isEditing()){b=this.focus.getHeaderIndex();if(0<=b){this.setSortIndex(b);break}else this.selection.clickSelect(this.focus.rowIndex,dojo.isCopyKey(a),a.shiftKey);d.stop(a)}break;case c.TAB:this.focus[a.shiftKey?"previousKey":"nextKey"](a);break;case c.LEFT_ARROW:case c.RIGHT_ARROW:if(!this.edit.isEditing()){var e=a.keyCode;d.stop(a);b=this.focus.getHeaderIndex();0<=b&&a.shiftKey&&a.ctrlKey?
this.focus.colSizeAdjust(a,b,5*(e==c.LEFT_ARROW?-1:1)):(a=e==c.LEFT_ARROW?1:-1,this.isLeftToRight()&&(a*=-1),this.focus.move(0,a))}break;case c.UP_ARROW:!this.edit.isEditing()&&0!==this.focus.rowIndex&&(d.stop(a),this.focus.move(-1,0));break;case c.DOWN_ARROW:!this.edit.isEditing()&&this.focus.rowIndex+1!=this.rowCount&&(d.stop(a),this.focus.move(1,0));break;case c.PAGE_UP:!this.edit.isEditing()&&0!==this.focus.rowIndex&&(d.stop(a),this.focus.rowIndex!=this.scroller.firstVisibleRow+1?this.focus.move(this.scroller.firstVisibleRow-
this.focus.rowIndex,0):(this.setScrollTop(this.scroller.findScrollTop(this.focus.rowIndex-1)),this.focus.move(this.scroller.firstVisibleRow-this.scroller.lastVisibleRow+1,0)));break;case c.PAGE_DOWN:!this.edit.isEditing()&&this.focus.rowIndex+1!=this.rowCount&&(d.stop(a),this.focus.rowIndex!=this.scroller.lastVisibleRow-1?this.focus.move(this.scroller.lastVisibleRow-this.focus.rowIndex-1,0):(this.setScrollTop(this.scroller.findScrollTop(this.focus.rowIndex+1)),this.focus.move(this.scroller.lastVisibleRow-
this.scroller.firstVisibleRow-1,0)))}}},onMouseOver:function(a){-1==a.rowIndex?this.onHeaderCellMouseOver(a):this.onCellMouseOver(a)},onMouseOut:function(a){-1==a.rowIndex?this.onHeaderCellMouseOut(a):this.onCellMouseOut(a)},onMouseDown:function(a){-1==a.rowIndex?this.onHeaderCellMouseDown(a):this.onCellMouseDown(a)},onMouseOverRow:function(a){this.rows.isOver(a.rowIndex)||(this.rows.setOverRow(a.rowIndex),-1==a.rowIndex?this.onHeaderMouseOver(a):this.onRowMouseOver(a))},onMouseOutRow:function(a){if(this.rows.isOver(-1))this.onHeaderMouseOut(a);
else this.rows.isOver(-2)||(this.rows.setOverRow(-2),this.onRowMouseOut(a))},onMouseDownRow:function(a){if(-1!=a.rowIndex)this.onRowMouseDown(a)},onCellMouseOver:function(a){a.cellNode&&e.add(a.cellNode,this.cellOverClass)},onCellMouseOut:function(a){a.cellNode&&e.remove(a.cellNode,this.cellOverClass)},onCellMouseDown:function(a){},onCellClick:function(a){this._click[0]=this._click[1];this._click[1]=a;this.edit.isEditCell(a.rowIndex,a.cellIndex)||this.focus.setFocusCell(a.cell,a.rowIndex);1<this._click.length&&
null==this._click[0]&&this._click.shift();this.onRowClick(a)},onCellDblClick:function(a){var b;b=1<this._click.length&&g("ie")?this._click[1]:1<this._click.length&&this._click[0].rowIndex!=this._click[1].rowIndex?this._click[0]:a;this.focus.setFocusCell(b.cell,b.rowIndex);this.edit.setEditCell(b.cell,b.rowIndex);this.onRowDblClick(a)},onCellContextMenu:function(a){this.onRowContextMenu(a)},onCellFocus:function(a,b){this.edit.cellFocus(a,b)},onRowClick:function(a){this.edit.rowClick(a);this.selection.clickSelectEvent(a)},
onRowDblClick:function(a){},onRowMouseOver:function(a){},onRowMouseOut:function(a){},onRowMouseDown:function(a){},onRowContextMenu:function(a){d.stop(a)},onHeaderMouseOver:function(a){},onHeaderMouseOut:function(a){},onHeaderCellMouseOver:function(a){a.cellNode&&e.add(a.cellNode,this.cellOverClass)},onHeaderCellMouseOut:function(a){a.cellNode&&e.remove(a.cellNode,this.cellOverClass)},onHeaderCellMouseDown:function(a){},onHeaderClick:function(a){},onHeaderCellClick:function(a){this.setSortIndex(a.cell.index);
this.onHeaderClick(a)},onHeaderDblClick:function(a){},onHeaderCellDblClick:function(a){this.onHeaderDblClick(a)},onHeaderCellContextMenu:function(a){this.onHeaderContextMenu(a)},onHeaderContextMenu:function(a){this.headerMenu||d.stop(a)},onStartEdit:function(a,b){},onApplyCellEdit:function(a,b,c){},onCancelEdit:function(a){},onApplyEdit:function(a){},onCanSelect:function(a){return!0},onCanDeselect:function(a){return!0},onSelected:function(a){this.updateRowStyles(a)},onDeselected:function(a){this.updateRowStyles(a)},
onSelectionChanged:function(){}})});
//@ sourceMappingURL=_Events.js.map