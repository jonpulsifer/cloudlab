function getScriptMode() {
  var documentProperties = PropertiesService.getDocumentProperties();
  var mode = documentProperties.getProperty('MODE');
  return mode
}

function setScriptMode(mode) {
  var documentProperties = PropertiesService.getDocumentProperties();
  documentProperties.setProperty('MODE', mode);
}