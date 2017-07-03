# ZeroNet

Decentralized websites using Bitcoin crypto and the BitTorrent network - https://zeronet.io

## Image features
 * Tor usage by default
 * smallest image possible (frankly if you can do better tell us!)
 * create/sign/publish CLI integration (see below)
 * optional variables: ENABLE_TOR and UIPASSWORD

```bash
$ docker build -t my/zeronet .
$ docker run -d \
  --name zeronet \
  -e "ENABLE_TOR=true" \
  -e "UIPASSWORD=yourpassword" \
  -v /var/lib/zeronet:/data \
  -p 127.0.0.1:43110:43110 \
  -p 127.0.0.1:15441:15441 \
  my/zeronet
```

Access via `http://127.0.0.1:43110`

Data can be backed up via:

```bash
$ docker run --rm \
  -v /var/lib/zeronet:/data:ro \
  -v $(pwd):/backup alpine tar cvf /backup/zeronetdata.tar /data
...or
$ tar cvf zeronetdata.tar /var/lib/zeronet
```

### CLI integration

```bash
$ docker run -rm -v /var/lib/zeronet:/data my/zeronet create
...
- Generating new privatekey...
- ----------------------------------------------------------------------
- Site private key: 5KH7HEDj4p1cMKb32sVvENXJZqSweZ2JuPhRf3W5Gpdsu2jH51A
-                   !!! ^ Save it now, required to modify the site ^ !!!
- Site address:     1Nj1VBtjM31AYoV2Wy8CwQNGxsasvdEV6Q
- ----------------------------------------------------------------------
? Have you secured your private key? (yes, no) >
...
$ docker run -rm -v /var/lib/zeronet:/data my/zeronet sign 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2
...
$ docker run -rm -v /var/lib/zeronet:/data my/zeronet publish 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2
```

## Zeronet Features
 * Real-time updated sites
 * Namecoin .bit domains support
 * Easy to setup: unpack & run
 * Clone websites in one click
 * Password-less [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)
   based authorization: Your account is protected by the same cryptography as your Bitcoin wallet
 * Built-in SQL server with P2P data synchronization: Allows easier site development and faster page load times
 * Anonymity: Full Tor network support with .onion hidden services instead of IPv4 addresses
 * TLS encrypted connections
 * Automatic uPnP port opening
 * Plugin for multiuser (openproxy) support
 * Works with any browser/OS


## How does Zeronet work?

* After starting `zeronet.py` you will be able to visit zeronet sites using
  `http://127.0.0.1:43110/{zeronet_address}` (eg.
  `http://127.0.0.1:43110/1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D`).
* When you visit a new zeronet site, it tries to find peers using the BitTorrent
  network so it can download the site files (html, css, js...) from them.
* Each visited site is also served by you.
* Every site contains a `content.json` file which holds all other files in a sha512 hash
  and a signature generated using the site's private key.
* If the site owner (who has the private key for the site address) modifies the
  site, then he/she signs the new `content.json` and publishes it to the peers.
  Afterwards, the peers verify the `content.json` integrity (using the
  signature), they download the modified files and publish the new content to
  other peers.

####  [Slideshow about ZeroNet cryptography, site updates, multi-user sites »](https://docs.google.com/presentation/d/1_2qK1IuOKJ51pgBvllZ9Yu7Au2l551t3XBgyTSvilew/pub?start=false&loop=false&delayms=3000)
####  [Frequently asked questions »](https://zeronet.readthedocs.org/en/latest/faq/)

####  [ZeroNet Developer Documentation »](https://zeronet.readthedocs.org/en/latest/site_development/getting_started/)

#### [Screenshots in ZeroNet docs »](https://zeronet.readthedocs.org/en/latest/using_zeronet/sample_sites/)


### Default docker image (not this one)
* `docker run -d -v <local_data_folder>:/root/data -p 15441:15441 -p 127.0.0.1:43110:43110 nofish/zeronet`
* This Docker image includes the Tor proxy, which is disabled by default. Beware that some
hosting providers may not allow you running Tor in their servers. If you want to enable it,
set `ENABLE_TOR` environment variable to `true` (Default: `false`). E.g.:

 `docker run -d -e "ENABLE_TOR=true" -v <local_data_folder>:/root/data -p 15441:15441 -p 127.0.0.1:43110:43110 nofish/zeronet`
* Open http://127.0.0.1:43110/ in your browser

## Current limitations

* No torrent-like file splitting for big file support
* ~~more anonymous than Bittorrent~~ (built-in full Tor support added)
* File transactions are not compressed ~~or encrypted yet~~ (TLS encryption added)
* No private sites


## How can I create a ZeroNet site?

Shut down zeronet if you are running it already

```bash
$ zeronet.py siteCreate
...
- Site private key: 23DKQpzxhbVBrAtvLEc2uvk7DZweh4qL3fn3jpM3LgHDczMK2TtYUq
- Site address: 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2
...
- Site created!
$ zeronet.py
...
```

Congratulations, you're finished! Now anyone can access your site using
`http://localhost:43110/13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2`

Next steps: [ZeroNet Developer Documentation](https://zeronet.readthedocs.org/en/latest/site_development/getting_started/)


## How can I modify a ZeroNet site?

* Modify files located in data/13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2 directory.
  After you're finished:

```bash
$ zeronet.py siteSign 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2
- Signing site: 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2...
Private key (input hidden):
```

* Enter the private key you got when you created the site, then:

```bash
$ zeronet.py sitePublish 13DNDkMUExRf9Xa9ogwPKqp7zyHFEqbhC2
...
Site:13DNDk..bhC2 Publishing to 3/10 peers...
Site:13DNDk..bhC2 Successfuly published to 3 peers
- Serving files....
```

* That's it! You've successfully signed and published your modifications.


## Help keep this project alive

- Bitcoin: 1QDhxQ6PraUZa21ET5fYUCPgdrwBomnFgX
- Paypal: https://zeronet.readthedocs.org/en/latest/help_zeronet/donate/
- Gratipay: https://gratipay.com/zeronet/

#### Thank you!

* More info, help, changelog, zeronet sites: https://www.reddit.com/r/zeronet/
* Come, chat with us: [#zeronet @ FreeNode](https://kiwiirc.com/client/irc.freenode.net/zeronet) or on [gitter](https://gitter.im/HelloZeroNet/ZeroNet)
* Email: hello@zeronet.io (PGP: CB9613AE)
