from bs4 import BeautifulSoup


with open('data.html', 'r') as html_file:
        content = html_file.read()
        
        soup = BeautifulSoup(content, 'lxml')
        # elements = soup.find_all('td', class_ = 'span3') 
        # o 'p', class_ = 'data' pero info inútil creo

        # for element in elements:
                # print(element.text)
                # print(element.p.text)


        rows = soup.find_all('tbody', class_ = 'tr')
        
        for sing_row in rows:
            col = sing_row.find_all('table', class_ = 'td')
            print(col.text)
