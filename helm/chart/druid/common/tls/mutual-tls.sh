#!/usr/bin/env bash

# scripts/mutual-tls.sh

keytool -genkey -noprompt -alias druid-client -keyalg RSA -keystore client-keystore.p12 -keysize 2048 -storeType PKCS12 -dname "CN=druid, OU=datas, O=stxkxs, L=sandiego, S=ca, C=us" -storepass changeit
keytool -export -noprompt -keystore client-keystore.p12 -alias druid-client -file client.crt -storepass changeit
keytool -genkey -noprompt -alias druid-server -keyalg RSA -keystore server-keystore.p12 -keysize 2048 -storeType PKCS12 -dname "CN=druid, OU=datas, O=stxkxs, L=sandiego, S=ca, C=us" -storepass changeit
keytool -export -noprompt -keystore server-keystore.p12 -alias druid-server -file server.crt -storepass changeit
keytool -genkey -noprompt -alias druid-client-trust -keyalg RSA -keystore client-truststore.p12 -keysize 2048 -storeType PKCS12 -dname "CN=druid, OU=datas, O=stxkxs, L=sandiego, S=ca, C=us" -storepass changeit
keytool -genkey -noprompt -alias druid-server-trust -keyalg RSA -keystore server-truststore.p12 -keysize 2048 -storeType PKCS12 -dname "CN=druid, OU=datas, O=stxkxs, L=sandiego, S=ca, C=us" -storepass changeit
keytool -import -trustcacerts -keystore server-truststore.p12 -alias druid-client -file client.crt -storepass changeit
keytool -import -trustcacerts -keystore client-truststore.p12 -alias druid-server -file server.crt -storepass changeit
