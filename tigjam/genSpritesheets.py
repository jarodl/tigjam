#!/usr/bin/env python

import os
from subprocess import call

SPRITESHEET_SRC_DIR='Resources/Spritesheet Sources'
SPRITESHEET_DST_DIR='Generated/Spritesheets'
TEXTURE_PACKER='Tools/TexturePacker.app/Contents/MacOS/TexturePacker'

def main():
    path = os.path.join(os.getcwd(), SPRITESHEET_SRC_DIR)
    sheets = []
    if os.path.isdir(path):
        files = os.listdir(path)
        dirs = [d for d in files if os.path.isdir(os.path.join(path, d))]
        sheets.extend(dirs)

    for sheet in sheets:
        source = os.path.join(path, sheet)
        texture_packer = os.path.join(os.getcwd(), TEXTURE_PACKER)
        destination = os.path.join(os.getcwd(), SPRITESHEET_DST_DIR)
        if not os.path.exists(destination):
            os.makedirs(destination)
        destination = os.path.join(destination, sheet)
        data = destination + '-hd.plist'
        sheetname = destination + '-hd.pvr.ccz'
        pixel_format = 'RGBA8888'
        call([texture_packer, '--shape-padding', '10', '--border-padding',
            '20', '--format', 'cocos2d', '--auto-sd', '--opt', pixel_format,
            '--data', data, '--sheet',
        sheetname, source])

if __name__ == '__main__':
    main()
