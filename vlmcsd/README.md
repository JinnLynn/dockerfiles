## KMS激活服务器

REF:

* https://wind4.github.io/vlmcsd/
* https://www.bilibili.com/read/cv6907989
* https://technet.microsoft.com/en-us/library/jj612867
* https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys

---

# Microsoft KMS Activation

## Usage

Start a Command Prompt as an `Administrator`.

### Windows

```cmd
slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr.vbs -skms kms.srv.crsoo.com
slmgr.vbs -ato
```

### Office

```cmd
cd C:\Program Files\Microsoft Office\Office15
cscript ospp.vbs /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT
cscript ospp.vbs /sethst:kms.srv.crsoo.com
cscript ospp.vbs /act
```

## GVLKs

Authoritative source on Microsoft's [TechNet](https://technet.microsoft.com/en-us/library/jj612867) and [Windows Server Activation Guide](https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys).
