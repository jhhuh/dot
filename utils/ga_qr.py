#!/usr/bin/env python

import qrcode
import sqlite3
conn = sqlite3.connect('databases')
c = conn.cursor()

for idx, (email, secret, issuer) in enumerate(c.execute("SELECT email,secret,issuer FROM accounts").fetchall()):
    url = 'otpauth://totp/{}?secret={}&issuer={}'.format(email, secret, issuer)
    print(url)
    im = qrcode.make(url)
    im.save('{}.png'.format(idx))
