const SIDEBAR_TITLE = '🧰 Cloud Glue Configuration'
const VERSION = '0.1.3.37'

/**
* Adds a custom menu with items to show the sidebar and dialog.
*
* @param {Object} e The event parameter for a simple onOpen trigger.
*/
function onOpen(e) {
  var ui = SpreadsheetApp.getUi();
  ui.createAddonMenu()
    .addItem('🔖 open sidebar', 'sidebar')
    .addSeparator()
    .addItem('Version: '.concat(VERSION), 'sidebar')
    .addToUi();
  Logger.log(e);
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
function sidebar() {
  var ui = HtmlService.createTemplateFromFile('dist/sidebar')
    .evaluate()
    .setTitle(SIDEBAR_TITLE)
    .setSandboxMode(HtmlService.SandboxMode.IFRAME);
  SpreadsheetApp.getUi().showSidebar(ui);
}

function makeAPubSub(dataObj) {
  let message = {};
  message.data = Utilities.base64Encode(JSON.stringify(dataObj));
  message.attributes = {
    email: Session.getActiveUser().getEmail(),
    spreadsheet: SpreadsheetApp.getActiveSpreadsheet().getId(),
    sheet: SpreadsheetApp.getActiveSheet().getName()
  };

  let response = pubsub(message);
  console.log(response.obj)
  SpreadsheetApp.getUi().alert(response.str)
}

function getFunky(message) {
  if (!message) message = {};
  message.email = Session.getActiveUser().getEmail();
  message.spreadsheet = SpreadsheetApp.getActiveSpreadsheet().getId();
  message.sheet = SpreadsheetApp.getActiveSheet().getName();
  message.score = Math.floor(Math.random() * 100);

  let response = cloudfunction(message);
  console.log(response.obj)
  SpreadsheetApp.getUi().alert(response.str);
}

/**
 * 
 * @param {Object} things object from the sidebar form
 */
function setDocumentProperties(things) {
  return PropertiesService.getDocumentProperties().setProperties(things, false);
}

function pubsub(message) {
  const project = "cloud-glue";
  const topic = "gas";
  let url = 'https://pubsub.googleapis.com/v1/projects/[PROJECT]/topics/[TOPIC]:publish'
    .replace("[TOPIC]", topic)
    .replace("[PROJECT]", project);

  let body = {
    messages: [message]
  };

  let response = UrlFetchApp.fetch(url, {
    method: "POST",
    contentType: 'application/json',
    muteHttpExceptions: true,
    payload: JSON.stringify(body),
    headers: {
      Authorization: 'Bearer '.concat(ScriptApp.getOAuthToken())
    }
  });

  return {
    str: JSON.stringify(response.getContentText()),
    obj: JSON.parse(response.getContentText()),
  };
}

function cloudfunction(message) {
  const url = 'https://us-east4-cloud-glue.cloudfunctions.net/cloud-glue';

  let response = UrlFetchApp.fetch(url, {
    method: "POST",
    contentType: 'application/json',
    muteHttpExceptions: true,
    payload: JSON.stringify(message),
    headers: {
      Authorization: 'Bearer '.concat(ScriptApp.getOAuthToken())
    }
  });

  return {
    str: JSON.stringify(response.getContentText()),
    obj: JSON.parse(response.getContentText()),
  };
}
