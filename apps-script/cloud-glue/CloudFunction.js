function cloudfunction(message) {
  var url = 'https://us-east4-cloud-glue.cloudfunctions.net/cloud-glue';

  var response = UrlFetchApp.fetch(url, {
    method: "POST",
    contentType: 'application/json',
    muteHttpExceptions: true,
    payload: JSON.stringify(message),
    headers: {
      Authorization: 'Bearer '.concat(ScriptApp.getOAuthToken())
    }
  });

  var result = JSON.parse(response.getContentText());
  var message = JSON.stringify(result);
  return {
    log: message,
    result: result,
  };
}
