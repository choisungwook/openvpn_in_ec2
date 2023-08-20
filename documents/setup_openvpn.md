# 개요
* openvpn 설정

# openVPN EC2 instance접속 방법
* [문서 링크](./connect_openvpn_ec2_instance.md)

# 전제조건
* server 인증서가 있어야 함
  * [생성 메뉴얼 바로가기](./issue_certificate.md)


# openvpn 설정 방법
* server 인증서 복사
```bash
sudo cp /home/ssm-user/easy-rsa/pki/issued/server.crt /etc/openvpn/server/
```

* dh 파라미터 생성 및 복사
> 암호화 통신에 사용
```bash
./easyrsa gen-dh
cp ./dh /etc/openvpn/server/
```

* ta.key 생성
> HMAC 무결성 검증에 사용
```bash
cd /etc/openvpn/server
sudo openvpn --genkey secret ta.key
```

* 디폴트 설정 복사
```bash
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/server/server.conf
```

* server.conf 설정
```conf
# 인증서 경로

# dh 파라미터 경로
dh dh2048.pem

# 인증서 암호 알고리즘 설정
cipher AES-256-GCM

# 무결성 설정
tls-crypt ta.key

# openvpn실행 최소권한
user nobody
group nogroup
```

# 커널 파라미터 수정
* 트래픽을 라우팅(포워딩)하기 위해 커널 파라미터 수정
```bash
sudo vi /etc/sysctl.conf
net.ipv4.ip_forward = 1
```

* 확인
```bash
sudo sysctl -p
...
net.ipv4.ip_forward = 1
```

# openvpn 실행
```bash
sudo systemctl start openvpn-server@server.service
sudo systemctl status openvpn-server@server.service

sudo systemctl -f enable openvpn-server@server.service
```

# 참고자료
* https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04
