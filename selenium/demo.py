import os
import time

from selenium.webdriver import Chrome, ChromeOptions

print('Docker & Chrome & Selenium Demo...')

options = ChromeOptions()
options.add_argument('--no-sandbox')
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--incognito')

brower = Chrome(options=options)
brower.get('http://icanhazip.com')
time.sleep(1)

print('''
RESULT
===
Current URL:
    {v.current_url}
Page Source:
    {v.page_source}
'''.format(v=brower))

brower.quit()
