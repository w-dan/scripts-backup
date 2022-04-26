# Required dependencies
import requests
from config import username, upasswd


# Login form post details
payload = {
    'username': username,
    'upasswd': upasswd
}

# Setting url
url = 'https://www.upm.es/gauss/principal.upm/informes_asignatura/consulta/consulta-informes_asignatura/2020-21/1S/61SI/615000350/2/anexos'

# Using 'with' to ensure the session context is closed after use
with requests.Session() as s:
    response = s.post(url, data=payload)
    
    # print the html returned or something more intelligent to see if it's a successful login page.
    print(response.text)

    with open('index.html', 'w') as f:
        f.write(response.text)

    response2 = s.post(url, data=payload)

    # An authorised request.
    gauss_request = s.get(url)
    print(gauss_request.text)
    print('STATUS CODE')
    print(response.status_code)
