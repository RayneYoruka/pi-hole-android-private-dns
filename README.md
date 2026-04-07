# Pi-Hole Android Private DNS Installer

Fork created to to update the scripts as well as to experiment.




## License & Conduct
- [**GNU General Public License v3.0**](https://github.com/varunsridharan/pi-hole-android-private-dns/blob/main/LICENSE) © [Varun Sridharan](website)
- [Code of Conduct](https://github.com/varunsridharan/.github/blob/main/CODE_OF_CONDUCT.md)




<img src="https://raw.githubusercontent.com/varunsridharan/pi-hole-android-private-dns/master/assets/banner.jpg"> <br/>





## Requirements
1. Ubuntu / Debain Based (Any Version)
2. Pi-Hole Installed With Web Server
3. Forward The Following Ports in TCP (`80,443,853`) to your Pihole instance.
4. This works as well with IPv6 only setups that only use IPv4 for local references.
   Pihole binds to the 80 port. You need to navigate to your pihole instance "/admin/settings/all" and change the port to ex. 8080, that way it won't have issues when renewing the certificate.


## Installation (First time use)
This is a simple script which requires 2 arguments
1. Domain Name To Run Android Private DNS Service Example: dns.myhomenetwork.net 
2. Email To Share with letsencrypt to get an SSL For Android Private DNS

### For Pihole 5/6 (Tested with Pihole V6 and works without issues)
```
wget https://raw.githubusercontent.com/RayneYoruka/pi-hole-android-private-dns/refs/heads/main/pi-hole-android-private-dns.sh
chmod -x pi-hole-android-private-dns.sh
sudo bash pi-hole-android-private-dns.sh {domain_name} {email_for_letsencrypt}
```

**Example Run** `sudo bash pi-hole-android-private-dns.sh mydns.example.com myemail@gmail.com`



### **Update 7 April 2026**

You can now use this little script to simply update the certificate, you can simply add it to cron to work every 30 days, it'll need to be run with root to make things simpler.

**Example Run:** 
```
wget https://raw.githubusercontent.com/RayneYoruka/pi-hole-android-private-dns/refs/heads/main/updater-testing.sh

chmod -x updater-testing.sh

sudo bash updater-testing.sh {domain_name} {email_for_letsencrypt}
```

It's been tested on Debian 13 working only with IPV6.


--------------


### **Extra notes from the past:**
The script "does" use the HTTP-01 challenge for verification, for some uses/reasons it's very annoying since it needs both ports 80 and 443 open, which can lead in to issues. See: https://letsencrypt.org/docs/challenge-types/


If you own a domain you can simply use the DNS-01 challenge with: ```certbot -d example.com --manual --preferred-challenges dns certonly```. This way you only need to create a TXT record when issuing a new certificate/renewing. I'd suggest only doing the TXT records when adding/renewing and just rinse and repeat.

I've seen being recommended [LEGO](https://github.com/go-acme/lego) but I have not yet tested it so I cannot say. 

### **Other notes:**
Since Lets Encrypt will be discontinuing the [Certificate renewal emails](https://letsencrypt.org/2025/01/22/ending-expiration-emails/) by June 4 2025, the simplest solution to monitor your certificate renewal date is to use [Uptime Kuma](https://github.com/louislam/uptime-kuma) if you don't want to use LEGO or any automated method to renew your certificate as they can get *very tedious.*

* If you use your same pihole instance for PrivateDNS and your ports don't change anytime or have any other machine that needs certificates, you can simply make a quick bash script with the execution command to renew on it's own every 90 days. Up to you. Since I have to renew the certificate on several machines (both by the pihole script and with the DNS-01 challenge) I simply renew all at the same time. Uptime Kuma notifiying me with enough time to do so.

### **Known issues:**
Every time you re-run the script to renew the certificates, a new line will be added to ```/etc/nginx/nginx.conf``` that needs to be removed manually. 

These duplicate line causes Nginx to not be able to start automatically after the script finishes to run.

The lines are:

    stream {
            include /etc/nginx/streams/*;
    }

Simply remove that line respecting the opening and the closing } and use ```sudo systemctl start nginx``` to solve the issue.
Just use the below script to update instead.





<!-- END common-footer.mustache -->
