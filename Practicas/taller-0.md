Creación de una solicitud de firma de certificado (Certificate Signing Request o CSR)



```
root@toyota-hilux:/home/madandy# openssl genrsa 4096 > /etc/ssl/private/toyota-hilux.key
root@toyota-hilux:/home/madandy# openssl req -new -key /etc/ssl/private/toyota-hilux.key -out /root/toyota-hilux.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ES
State or Province Name (full name) [Some-State]:Sevilla
Locality Name (eg, city) []:Dos Hermanas
Organization Name (eg, company) [Internet Widgits Pty Ltd]:IES Gonzalo Nazareno
Organizational Unit Name (eg, section) []:Informatica
Common Name (e.g. server FQDN or YOUR name) []:toyota-hilux
Email Address []:asirandy@gmail.com           

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
root@toyota-hilux:/home/madandy# cd
root@toyota-hilux:~# ls
toyota-hilux.csr
root@toyota-hilux:~# pwd
/root
root@toyota-hilux:~# 

```