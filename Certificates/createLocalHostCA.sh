#!/bin/sh
DOMAINKEY=~/ServerCA/domain.key
DOMAINCSR=~/ServerCA/domain.csr
openssl genrsa -out $DOMAINKEY 4096
openssl req -key $DOMAINKEY -new -out $DOMAINCSR
openssl req -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr

openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT -config printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

