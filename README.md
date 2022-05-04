# Sketchy Router Controller

Basic web UI to control power on/off of an EC2 instance using Amazon API Gateway.
The solution in implemented via Terraform on AWS.

## Features

- Power on/off a specified EC2 instance from a web browser
- Implemented **completely** in Amazon API Gateway
- CORS headers
- Crude *anti-spider* feature to prevent drive by crawling of API URL
- Free to run under AWS free tier

## Why!?

I use an EC2 instance to route traffic over a WireGuard VPN for accessing region-locked content. Certainly not illegal but potentially ethecially sketchy. Hense the name.
It's rarely used so I wanted to easily power it on/off via a web page which can be embedded in a widget.

Mainly though, it's just to learn the API Gateway product and create a complete reference implementation in Terraform.

## Screenshot

![alt text](screenshot.png "Screenshot")