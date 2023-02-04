#!/bin/bash
set -e
sudo apt update
sudo apt install wireguard
read -p 'Enter Email ID: ' email
read -p 'Enter Friendly Name: ' id
read -p 'Enter API Key: ' api
json='{"Email":"'"${email}"'","Identifier":"'"${id}"'"}'
curl --silent  -f -k -X POST "https://newnew.korplink.com/api/v1/provisioning/peers" -H "accept: text/plain" -H "authorization: Basic $api" -H "Content-Type: application/json" -d $json -o "/etc/wireguard/wg0.conf"
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0
