from attr import attr
import requests
from bs4 import BeautifulSoup 
import time
from sqlalchemy import true
from tqdm import tqdm
import sqlite3
import re

URL = 'http://www.geocoding.jp/api/'

def coordinate(address):

    # addressに住所を指定すると緯度経度を返す

    payload = {'q': address}
    html = requests.get(URL, params=payload)
    soup = BeautifulSoup(html.content, "html.parser")

    if soup.find('error'):
        html = requests.get(URL, params=payload)
        soup = BeautifulSoup(html.content, "html.parser")
        if soup.find('error'):
            latitude = 0
            longitude = 0
        else:
            latitude = soup.find('lat').string
            longitude = soup.find('lng').string
    elif soup is None:
        html = requests.get(URL, params=payload)
        soup = BeautifulSoup(html.content, "html.parser")
        if soup is None:
            latitude = 0
            longitude = 0
        else:
            latitude = soup.find('lat').string
            longitude = soup.find('lng').string
    else: 
        latitude = soup.find('lat').string
        longitude = soup.find('lng').string
        return [latitude, longitude]

def coordinates(addresses, interval=2, progress=True):

    # addressesに住所リストを指定すると、緯度経度リストを返す

    coordinates = []
    for address in progress and tqdm(addresses) or addresses:
        coordinates.append(coordinate(address))
        time.sleep(interval)
    return coordinates



id = []
shopname = []
wifiinfo = []
eigyojikan = []

#----------------------------------------------------------------------------
# 埼玉
url = 'https://www.h9v.net/category/%E5%9F%BC%E7%8E%89/'
soup = BeautifulSoup(requests.get(url).content, 'html.parser')
# HTML情報からページ数を取得
liner = soup.find('div', class_='page_navi2 clearfix').text
liner.replace(' ', '')
s_shopnum = liner.split('件中')
shopnum = int(s_shopnum[0])
# ページ数を取得 件数を10で割って切り上げ
pagenum = -(-shopnum // 10)
for i in range(1, pagenum+1):
    soup = BeautifulSoup(requests.get(url).content, 'html.parser')
    # 各ページでの処理
    for j in soup.find_all('p', class_='excerpt'):
        info_line = j.text
        s = info_line.split('スターバックス')
        # sは'スターバックス'より前と後の要素数2リスト
        s_replace = s[0].replace('が使える店', '：◯ ')
        ss_replace = s_replace.replace('が使えない店', '：× ')
        t = s[1].split('店')
        u = t[0].replace('（スタバ）', '')
        # リストに情報を追加
        wifiinfo.append(ss_replace)
        shopname.append('スターバックス' + u + '店')
        eigyojikan.append(t[1][0:16])

    # url書き換えて次のページへ
    url = f'https://www.h9v.net/category/%E5%9F%BC%E7%8E%89/page/{i+1}/'

    # サーバ負荷軽減
    time.sleep(10)
    # ここまでで各県の操作. URLは変える
# ----------------------------------------------------------------------------
# 神奈川
url = 'https://www.h9v.net/category/%e7%a5%9e%e5%a5%88%e5%b7%9d/'
soup = BeautifulSoup(requests.get(url).content, 'html.parser')
# HTML情報からページ数を取得
liner = soup.find('div', class_='page_navi2 clearfix').text
liner.replace(' ', '')
s_shopnum = liner.split('件中')
shopnum = int(s_shopnum[0])
# ページ数を取得 件数を10で割って切り上げ
pagenum = -(-shopnum // 10)
for i in range(1, pagenum+1):
    soup = BeautifulSoup(requests.get(url).content, 'html.parser')
    # 各ページでの処理
    for j in soup.find_all('p', class_='excerpt'):
        info_line = j.text
        s = info_line.split('スターバックス')
        # sは'スターバックス'より前と後の要素数2リスト
        s_replace = s[0].replace('が使える店', '：◯ ')
        ss_replace = s_replace.replace('が使えない店', '：× ')
        t = s[1].split('店')
        u = t[0].replace('（スタバ）', '')
        # リストに情報を追加
        wifiinfo.append(ss_replace)
        shopname.append('スターバックス' + u + '店')
        eigyojikan.append(t[1][0:16])

    # url書き換えて次のページへ
    url = f'https://www.h9v.net/category/%e7%a5%9e%e5%a5%88%e5%b7%9d/page/{i+1}/'
    time.sleep(10)


#----------------------------------------------------------------------------
# 東京
url = 'https://www.h9v.net/category/%e6%9d%b1%e4%ba%ac/'
soup = BeautifulSoup(requests.get(url).content, 'html.parser')
# HTML情報からページ数を取得
liner = soup.find('div', class_='page_navi2 clearfix').text
liner.replace(' ', '')
s_shopnum = liner.split('件中')
shopnum = int(s_shopnum[0])
# ページ数を取得 件数を10で割って切り上げ
pagenum = -(-shopnum // 10)
for i in range(1, pagenum+1):
    soup = BeautifulSoup(requests.get(url).content, 'html.parser')
    # 各ページでの処理
    for j in soup.find_all('p', class_='excerpt'):
        info_line = j.text
        s = re.split('スターバックス|STARBUCKS', info_line)
        # sは'スターバックス'より前と後の要素数2リスト
        s_replace = s[0].replace('が使える店', '：◯ ')
        ss_replace = s_replace.replace('が使えない店', '：× ')
        t = re.split('店|TOKYO', s[-1])
        u = t[0].replace('（スタバ）', '')
        # リストに情報を追加
        wifiinfo.append(ss_replace)
        shopname.append('スターバックス' + u + '店')
        eigyojikan.append(t[-1][0:16])

    # url書き換えて次のページへ
    url = f'https://www.h9v.net/category/%e6%9d%b1%e4%ba%ac/page/{i+1}/'

    # サーバ負荷軽減
    time.sleep(10)
    # ここまでで各県の操作. URLは変える

#----------------------------------------------------------------------------
# 千葉
url = 'https://www.h9v.net/category/%e5%8d%83%e8%91%89/'
soup = BeautifulSoup(requests.get(url).content, 'html.parser')
# HTML情報からページ数を取得
liner = soup.find('div', class_='page_navi2 clearfix').text
liner.replace(' ', '')
s_shopnum = liner.split('件中')
shopnum = int(s_shopnum[0])
# ページ数を取得 件数を10で割って切り上げ
pagenum = -(-shopnum // 10)
for i in range(1, pagenum+1):
    soup = BeautifulSoup(requests.get(url).content, 'html.parser')
    # 各ページでの処理
    for j in soup.find_all('p', class_='excerpt'):
        info_line = j.text
        s = re.split('スターバックス|STARBUCKS', info_line)
        # sは'スターバックス'より前と後の要素数2リスト
        s_replace = s[0].replace('が使える店', '：◯ ')
        ss_replace = s_replace.replace('が使えない店', '：× ')
        t = re.split('店|TOKYO', s[-1])
        u = t[0].replace('（スタバ）', '')
        # リストに情報を追加
        wifiinfo.append(ss_replace)
        shopname.append('スターバックス' + u + '店')
        eigyojikan.append(t[-1][0:16])

    # url書き換えて次のページへ
    url = f'https://www.h9v.net/category/%e5%8d%83%e8%91%89/page/{i+1}/'

    # サーバ負荷軽減
    time.sleep(10)
    # ここまでで各県の操作. URLは変える    


# 店名リストから緯度経度取得
shoplatlng = coordinates(shopname)

# print文デバッグ
print(len(shopname))

# ここまでで店舗情報（緯度経度、店名、wifi電源、営業時間）取得完了

# idは手動で追加
for i in range(len(shopname)):
    id.append(i)

# 以降SQliteでデータベース作成
con = sqlite3.connect('cafe_map.db', detect_types=sqlite3.PARSE_DECLTYPES)
cur = con.cursor()

# latlngでリストを用いるため適合関数
sqlite3.register_adapter(list, lambda l: ','.join([str(i) for i in l]))
sqlite3.register_converter('List', lambda s: [item.decode('utf-8')  for item in s.split(bytes(b';'))])

sqlite3.register_adapter(bool, lambda b: str(b))
sqlite3.register_converter('Bool', lambda l: bool(eval(l)))

cur.executescript("""
drop table if exists shop_data;
CREATE TABLE shop_data(id, shopname, shoplatlng, wifiinfo, eigyojikan)""")

for id,a,b,c,d in zip(id, shopname, shoplatlng, wifiinfo, eigyojikan):
    cur.execute("INSERT INTO shop_data VALUES(?,?,?,?,?);",(id,a,b,c,d))

con.commit()
cur.close()
con.close()
