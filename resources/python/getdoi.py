from bs4 import BeautifulSoup
import requests
def main(url):
    header = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" ,'referer':'https://www.google.com/'}
    r = requests.get(url,headers = header)
    soup = BeautifulSoup(r.content, "lxml")
    meta = soup.find_all('meta')
    for tag in meta:
        if 'name' in tag.attrs.keys() and tag.attrs['name'].strip().lower() in ["citation_doi"]:
          doi =  tag.attrs["content"]
    return (doi)
