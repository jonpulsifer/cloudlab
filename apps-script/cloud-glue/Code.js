/**
* @OnlyCurrentDoc  Limits the script to only accessing the current spreadsheet.
*/

var DIALOG_TITLE = 'Example Dialog';
var SIDEBAR_TITLE = 'Example Sidebar';
var VERSION = '0.1.22'

/**
* Adds a custom menu with items to show the sidebar and dialog.
*
* @param {Object} e The event parameter for a simple onOpen trigger.
*/
function onOpen(e) {
  var ui = SpreadsheetApp.getUi();
  ui.createAddonMenu()
  .addItem('💰 Show a sidebar', 'showSidebar')
  .addItem('📥 Show a dialog box', 'showDialog')
  .addItem('📤 Send a pubsub message', 'makeAPubSub')
  .addSeparator()
  .addSubMenu(ui.createMenu('System')
              .addItem('Version: '.concat(VERSION), 'showSidebar')
             )
  .addToUi();
}

/**
* Runs when the add-on is installed; calls onOpen() to ensure menu creation and
* any other initializion work is done immediately.
*
* @param {Object} e The event parameter for a simple onInstall trigger.
*/
function onInstall(e) {
  onOpen(e);
}

/**
* Opens a sidebar. The sidebar structure is described in the Sidebar.html
* project file.
*/
function showSidebar() {
  var ui = HtmlService.createTemplateFromFile('Sidebar')
  .evaluate()
  .setTitle(SIDEBAR_TITLE)
  .setSandboxMode(HtmlService.SandboxMode.IFRAME);
  SpreadsheetApp.getUi().showSidebar(ui);
}

/**
* Opens a dialog. The dialog structure is described in the Dialog.html
* project file.
*/
function showDialog() {
  var ui = HtmlService.createTemplateFromFile('Dialog')
  .evaluate()
  .setWidth(400)
  .setHeight(190)
  .setSandboxMode(HtmlService.SandboxMode.IFRAME);
  SpreadsheetApp.getUi().showModalDialog(ui, DIALOG_TITLE);
}

/**
* Returns the value in the active cell.
*
* @return {String} The value of the active cell.
*/
function getActiveValue() {
  // Retrieve and return the information requested by the sidebar.
  var cell = SpreadsheetApp.getActiveSheet().getActiveCell();
  return cell.getValue();
}

/**
* Replaces the active cell value with the given value.
*
* @param {Number} value A reference number to replace with.
*/
function setActiveValue(value) {
  // Use data collected from sidebar to manipulate the sheet.
  var cell = SpreadsheetApp.getActiveSheet().getActiveCell();
  cell.setValue(value);
}

/**
* Executes the specified action (create a new sheet, copy the active sheet, or
* clear the current sheet).
*
* @param {String} action An identifier for the action to take.
*/
function modifySheets(action) {
  // Use data collected from dialog to manipulate the spreadsheet.
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var currentSheet = ss.getActiveSheet();
  if (action == "create") {
    ss.insertSheet();
  } else if (action == "copy") {
    currentSheet.copyTo(ss);
  } else if (action == "clear") {
    currentSheet.clear();
  }
}

function makeAPubSub(){
  var message = {};
  var topic = "gas";
  var project = "cloud-glue";
  message.data = Utilities.base64Encode("hi")
  message.attributes = {
    email: Session.getActiveUser(),
    spreadsheet: SpreadsheetApp.getActiveSpreadsheet().getId(),
    sheet: SpreadsheetApp.getActiveSheet().getName()
  };
  
  var response = pubsub(project, topic, message);
  Logger.log(response.log);
  Logger.log(response.result);
  SpreadsheetApp.getUi().alert(response.log)
}
