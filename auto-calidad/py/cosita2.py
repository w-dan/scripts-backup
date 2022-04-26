# required libraries
import requests
import pandas as pd
import mechanize
from bs4 import BeautifulSoup
import urllib
import http.cookiejar as cookielib

# html download from site
cook = cookielib.CookieJar()
req = mechanize.Browser()
req.set_handle_robots(False)
req.set_cookiejar(cook)

req.open('https://www.upm.es/gauss/principal.upm/informes_asignatura/consulta/consulta-informes_asignatura/2020-21/1S/61SI/615000350/2/anexos')

req.select_form(nr = 0)
req.form['username'] = 'd.galgora@alumnos.upm.es'
req.form['upasswd'] = 'ayuso123'
req.submit()

print(req.response().read())


# BeautifulSoup parsed object and other variables
soup = BeautifulSoup(req.response(), 'html.parser') # req.text
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
