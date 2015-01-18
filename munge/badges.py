from bs4 import BeautifulSoup
import pandas as pd

def my_split(s, delim=':'):
    i = s.find(delim)
    return s[:i], s[i+2:]

def info(badge):
    title = badge.find('a').attrs['title']
    color, description = my_split(title)
    return {
        'name': badge.text.strip(),
        'color': color.replace(' badge', ''),
        'description': description
    }

def badge_data():
    with open('badges.html') as f:
        soup = BeautifulSoup(f)

    badges = soup.findAll(class_='badge-container')

    return pd.DataFrame([info(b) for b in badges])

if __name__ == '__main__':
    badges = badge_data()
    badges.to_csv('badges.csv', index=False)
