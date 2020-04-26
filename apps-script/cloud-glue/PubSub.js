function pubsub(message) {
  var project = "cloud-glue";
  var topic = "gas";
  var url = 'https://pubsub.googleapis.com/v1/projects/[PROJECT]/topics/[TOPIC]:publish'
  .replace("[TOPIC]", topic)
  .replace("[PROJECT]", project);

  var body = {
    messages: [message]
  };

  var response = UrlFetchApp.fetch(url, {
    method: "POST",
    contentType: 'application/json',
    muteHttpExceptions: true,
    payload: JSON.stringify(body),
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
