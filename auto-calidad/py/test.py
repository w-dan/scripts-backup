import requests
from requests import auth
from requests.auth import HTTPDigestAuth
url = 'https://www.upm.es/gauss/'
logueo = requests.get(url, auth=HTTPDigestAuth('d.galgora@alumnos.upm.es', 'petazeta1234423'))

print(logueo.status_code)
print(auth)



# url = "<any valid url>"
# login = requests.get(url, auth = HTTPDigestAuth("username", "password"))
