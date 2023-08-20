# 1. 개요
* openvpn server 설정

# 2. openVPN EC2 instance접속 방법
* [문서 링크](./connect_openvpn_ec2_instance.md)

# 3. 전제조건
* ca 인증서, server 인증서, server private key가 있어야 함
  * [생성 메뉴얼 바로가기](./issue_certificate.md)


# 4. openvpn 설정 방법
## 4.1 ca 인증서, server 인증서, 키 복사
```bash
sudo cp /home/ssm-user/easy-rsa/pki/ca.crt /etc/openvpn/server/
sudo cp /home/ssm-user/easy-rsa/pki/issued/server.crt /etc/openvpn/server/
sudo cp /home/ssm-user/easy-rsa/pki/private/server.key /etc/openvpn/server/
```

## 4.2 dh 파라미터 생성 및 복사
> 암호화 통신에 사용
```bash
cd ~/easy-rsa
./easyrsa gen-dh
sudo cp ./pki/dh.pem /etc/openvpn/server/
```

## 4.3 ta.key 생성
> HMAC 무결성 검증에 사용
```bash
cd /etc/openvpn/server
sudo openvpn --genkey secret ta.key
```

## 4.4 server.conf 파일 복사
* [server.conf파일](./server.conf)을 /etc/openvpn/server/server.conf경로에 복사
```bash
sudo vi /etc/openvpn/server/server.conf
```

* server.conf는 기본 설정만 되어 있으므로 실무에 적용할 떄는 파라미터를 적절히 수정해주세요.
```bash
예) openvpn 라우팅 설정
142줄 push "route 192.168.170.39 255.255.255.0"
143줄 push "route 192.168.140.0 255.255.255.0"
```

# 5. 커널 파라미터 수정
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

# 6. openvpn 실행
```bash
# 실행
sudo systemctl start openvpn-server@server.service

# 상태확인
sudo systemctl status openvpn-server@server.service

# 영구실행 설정
sudo systemctl -f enable openvpn-server@server.service
```

# 7. 참고자료
* https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04
* https://hiteit.tistory.com/5
