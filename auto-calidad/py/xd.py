# required libraries
import requests
from requests.auth import HTTPDigestAuth
import pandas as pd
from bs4 import BeautifulSoup

# html download from site
url = 'https://www.upm.es/gauss/principal.upm/informes_asignatura/consulta/consulta-informes_asignatura/2020-21/1S/61SI/615000350/2/anexos'

payload = {
    'username': 'd.galgora@alumnos.upm.es',
    'upasswd': 'asfafadfasdf'
}

with requests.Session() as s:
    login = s.post(url, data=payload)
    print(login.text)
    
    data = s.get(url)
    print(data.text)

    # BeautifulSoup parsed object and other variables
    soup = BeautifulSoup(data.text, 'html.parser')
    print(soup.text)
    annex_name = 'TASAS'

    # fetch dropdown accordion groups
    accordions = soup.find_all('div', class_ = 'accordion-group')

    # selecting target annex
    for annex in accordions:
        heading = annex.find('div', class_ = 'accordion-heading')
    
        if(annex_name in heading.text):
            target_annex = annex
            print('la clase master')
            print(target_annex.type()) 
    
    print(target_annex.get('class')) 
