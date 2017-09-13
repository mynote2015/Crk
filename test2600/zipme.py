import os
import zipfile

zf = zipfile.ZipFile('C2600-BI.BIN.ROEXEC.zip','w',zipfile.ZIP_DEFLATED)
zf.write('C2600-BI.BIN.ROEXEC')
zf.close()
