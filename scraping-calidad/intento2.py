import requests

url = "https://www.upm.es/webmail_alumnos/?_task=mail&_mbox=INBOX"
data = {'userName':'d.galgora   ',
        'password':'1234',
        # 'challenge':'zzzzzzzzz',
        # 'hash':''} 
       }
# note that in email have encoded '@' like uuuuuuu%40gmail.com      

session = requests.Session()

# r = session.post(url, headers=headers, data=data)
r = session.post(url, data=data)

print(r.text)
print(r.status_code)