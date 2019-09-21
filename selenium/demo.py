# -*- coding: utf-8 -*-
from __future__ import (unicode_literals, absolute_import,
                        division, print_function)
import os
import time

from selenium.webdriver import Chrome, ChromeOptions

print('Docker & Chrome & Selenium Demo...')

options = ChromeOptions()
#! 必须带此参数 否则无法正常启动
options.add_argument('--no-sandbox')
# 无界面
options.add_argument('--headless')
options.add_argument('--disable-gpu')
# 隐身模式
options.add_argument('--incognito')

brower = Chrome(chrome_options=options)
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
