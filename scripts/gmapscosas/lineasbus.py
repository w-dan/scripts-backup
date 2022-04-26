# required libraries
import requests
import pandas as pd
from bs4 import BeautifulSoup

# html download from site
line = 'N25'
url = 'https://es.wikipedia.org/wiki/L%C3%ADnea_' + line + '_(EMT_Madrid)'
data = requests.get(url).text

# parsing object
soup = BeautifulSoup(data, 'lxml')

# fetching tables
tables = soup.find_all('table', class_ = 'wikitable center')
table = tables[0]

# forming dataframe
df = pd.DataFrame(columns = ['Parada'])

# gathering data
for row in table.tbody.find_all('tr'):
    columns = row.find_all('td')        # td?

    if(columns != []):
        paradas = columns[1].text.strip()

        df = df.append({'Parada': paradas}, ignore_index = True)


print(df)
df.to_csv('lineas/'+ line +'.csv')
