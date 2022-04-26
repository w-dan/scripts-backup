# required libraries
import requests
import pandas as pd
from bs4 import BeautifulSoup

with open('../data.html', 'r') as html_file:
        content = html_file.read()
        annex_name = 'TASAS'

        # BeautifulSoup parsed object
        soup = BeautifulSoup(content, 'lxml')

        # fetch dropdown accordion groups
        accordions = soup.find_all('div', class_ = 'accordion-group')

        # selecting target annex
        for annex in accordions:
            heading = annex.find('div', class_ = 'accordion-heading')
            
            if(annex_name in heading.text):
                target_annex = annex
                break 
        
        print(target_annex.get('class'))

        # creating a list with all tables in the annex
        tables = target_annex.find_all('table', class_ = 'tabla_resultado')

        # first table
        table_zero = tables[0];
        
        ##############################################
        #                                            #
        #           first table dataframe            #
        #                                            #
        ##############################################
        df = pd.DataFrame(columns = ['Matriculas', 'Nº matriculados', 'Nº aprobados', 'Tasa rendimiento'])
        # Defining dataframes is a full hardcode mode procedure.
        # Future changes and different tables will require different dataframes.

        # collecting data
        for row in table_zero.tbody.find_all('tr'):
            # find all data for each column
            columns = row.find_all('td')
            
            if(columns != []):
                matriculas = columns[0].text.strip()
                nmatriculados = columns[1].text.strip()
                naprobados = columns[2].text.strip()
                trendimiento = columns[3].text.strip()

                df = df.append({'Matriculas': matriculas, 'Nº aprobados': naprobados, 'Tasa rendimiento': trendimiento}, ignore_index = True)

print('aqui la head master')
print(df)

