import sys, urllib
import email
import json
message = email.message_from_string(sys.stdin.read())
body = ""
if message.is_multipart():
  for payload in message.get_payload():
    if payload.get_content_type() == 'text/plain':
      body += payload.get_payload(decode=True)
else:
  body = message.get_payload(decode=True)
message_obj = dict(message)
message_obj["body"] = body
print "email=" + urllib.quote(json.dumps(message_obj))
