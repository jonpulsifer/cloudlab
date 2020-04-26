function pubsub(project, topic, message) {
  var url = 'https://pubsub.googleapis.com/v1/projects/[PROJECT]/topics/[TOPIC]:publish'
  .replace("[TOPIC]", topic)
  .replace("[PROJECT]", project);
  
  // The data attribute is of 'string' type and needs to be base64 Encoded!
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
  }
}