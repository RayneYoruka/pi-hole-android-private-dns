# Pi-Hole Android Private DNS Installer

Fork created to to update the scripts as well as to experiment with other types of certificates that aren't from Let's Encrypt since they will be removing the [**notification emails**](https://letsencrypt.org/2025/01/22/ending-expiration-emails/) they used to send every 90 days.




## License & Conduct
- [**GNU General Public License v3.0**](https://github.com/varunsridharan/pi-hole-android-private-dns/blob/main/LICENSE) © [Varun Sridharan](website)
- [Code of Conduct](https://github.com/varunsridharan/.github/blob/main/CODE_OF_CONDUCT.md)




<img src="https://raw.githubusercontent.com/varunsridharan/pi-hole-android-private-dns/master/assets/banner.jpg"> <br/>





## Requirements
1. Ubuntu / Debain Based (Any Version)
2. Pi-Hole Installed With Web Server
3. Forward The Following Ports in TCP (`80,443,853`) to your Pihole instance.


## Installation
This is a simple script which requires 2 arguments
1. Domain Name To Run Android Private DNS Service Example: dns.myhomenetwork.net 
2. Email To Share with letsencrypt to get an SSL For Android Private DNS

### For Pihole 5/6 (Tested with Pihole V6 and works withut issues)
```
wget https://raw.githubusercontent.com/RayneYoruka/pi-hole-android-private-dns/refs/heads/main/pi-hole-android-private-dns.sh
bash -x pi-hole-android-private-dns.sh
sudo bash pi-hole-android-private-dns.sh {domain_name} {email_for_letsencrypt}
```

**Example Run** `sudo bash pi-hole-android-private-dns.sh mydns.example.com myemail@gmail.com`


### **Notes on this:**
The script "does" use the HTTP-01 challenge for verification, for some uses/reasons it's very annoying since it needs both ports 80 and 443 open, which can lead in to issues. See: https://letsencrypt.org/docs/challenge-types/


If you own a domain you can simply use the DNS-01 challenge with: ```certbot -d example.com --manual --preferred-challenges dns certonly```. This way you only need to create a TXT record when issuing a new certificate/renewing. I'd suggest only doing the TXT records when adding/renewing and just rinse and repeat.

I've seen being recommended LEGO [LEGO](https://github.com/go-acme/lego) but I have not yet tested it so I cannot say. 





<!-- END common-footer.mustache -->
