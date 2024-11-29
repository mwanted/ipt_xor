iptables xor module
===================
The XOR target enables the user to encrypt TCP and UDP traffic using a very simple xor encryption.  
[Xor](https://en.wikipedia.org/wiki/XOR_cipher) is its own inverse. That is, to undo xor, the same algorithm is applied, so the same action can be used for encoding and decoding.  
**warning:** This is not a real encryption.


## Install (for Debian/Ubuntu)
1. ```sudo apt install linux-headers libxtables-dev xtables-addons-common dkms```
2. ```make```
3. ```sudo make install```

## Uninstall (for Debian/Ubuntu)
1. Ensure that all firewall rules are cleared
2. ```sudo make uninstall```

## Build to .deb
1. Edit ```debian/control```, ```debian/changelog``` and may be ```debian/copyright```
2. ```sudo apt install linux-headers libxtables-dev xtables-addons-common dkms```
3. ```make```
4. ```make deb```
5. Look for ```../libiptxor.*``` 

## Usage

XOR takes one mandatory parameter.  

`--key '1234'` where 1234 is a byte string (As `5f6e == 0x5f, 0x6e`). Warning: don't use key of length > 1 with tcp, because tcp is a stream.

## Example

To use this target between hosts 1.2.3.4 and 1.2.3.5.

### (on host A, 1.2.3.4)
```bash
iptables -t mangle -A OUTPUT -d 1.2.3.5 -p udp --dport 1234 -j XOR --key 6142
iptables -t mangle -A INPUT -s 1.2.3.5 -p udp --sport 1234 -j XOR --key 6142
```

### (on host B, 1.2.3.5)
```bash
iptables -t mangle -A OUTPUT -d 1.2.3.4 -p udp --sport 1234 -j XOR --key 6142
iptables -t mangle -A INPUT -s 1.2.3.4 -p udp --dport 1234 -j XOR --key 6142
```

### Notice
* Support kernel version >= 2.6.32.
* Tested on Centos6.5(2.6.32-431.23.3.el6.x86_64), centos7.2(3.10.0-327.22.2.el7.x86_64) and kernel 4.1.0.
* Tested on Ubuntu18.04(4.15.0-101-generic) and Ubuntu 20.04(5.4.0-29-generic)
* Tested on Debian 12(6.1.0-28-amd64)

### License

This project is under the MIT license. See the [LICENSE](LICENSE) file for the full license text.
