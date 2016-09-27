python /etc/postfix/parse_email.py | curl --data-binary @- http://localhost:$METEOR_PORT/internal/submit-by-email
