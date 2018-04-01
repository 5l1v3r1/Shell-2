#!/usr/bin/python

import os, smtplib, getpass, sys, time, socket
from requests import get

def getlocalip():
    # Connect to a reomte server and return the socketname, aka the ip address
    # using socket
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('8.8.8.8', 80))
    return s.getsockname()[0]

def getexternalip():
    # This grabs the content of a remote website.
    # Usung 'get' from requests
    ip = get('https://ident.me').text
    return ip

# --------------------------------------------------------
# I recommand using a dummy email for this.
# This account must not have two-step-verification
# Paste the password in clear-text

to = '<ENTER EMAIL ADDRESS>'    # To Email
user = '<ENTER EMAIL ADDRESS>'  # Sent with this Email account
passwd = '<YOUR PASSWORD>'      # Email Password

smtp = 'smtp.gmail.com'         # SMTP server
smtp_port = 587                 # SMTP port
# --------------------------------------------------------

body = '''
Dear user,

   _______     _______ _______ ______ __  __
  / ____\ \   / / ____|__   __|  ____|  \/  |
 | (___  \ \_/ / (___    | |  | |__  | \  / |
  \___ \  \   / \___ \   | |  |  __| | |\/| |
  ____) |  | |  ____) |  | |  | |____| |  | |
 |_____/___|_| |_____/   |_|  |______|_|  |_|
 |  _ \|  __ \|  ____|   /\   / ____| |  | |
 | |_) | |__) | |__     /  \ | |    | |__| |
 |  _ <|  _  /|  __|   / /\ \| |    |  __  |
 | |_) | | \ \| |____ / ____ \ |____| |  | |
 |____/|_|  \_\______/_/    \_\_____|_|  |_|

Time
 [%s]

Hostname
 [%s]

Local
 [%s]

External
 [%s]

Kind regards,

Administrator

''' % (time.strftime('%d-%m-%Y %X'), socket.gethostbyaddr('127.0.1.1')[0], getlocalip(), getexternalip())

print ''

try:
    server = smtplib.SMTP(smtp,int(smtp_port))
    server.ehlo()
    server.starttls()
    server.login(user,passwd)
    for i in range(1, 1+1): # Send one
       subject = 'Incorrect password attempt'
       msg = 'From: ' + user + '\nSubject: ' + subject + '\n' + body
       server.sendmail(user,to,msg) # Send message
       server.quit()

       print '\nMessage was successfully sent to: ' + to

except KeyboardInterrupt:
   print('[-] Canceled')
   sys.exit(0)

except smtplib.SMTPAuthenticationError:
   print('\n[!] Failed to login: The username or password you entered is incorrect.')
   sys.exit(1)
