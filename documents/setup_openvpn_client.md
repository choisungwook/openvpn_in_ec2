# 1. 개요
* openvpn client 설정파일 생성
* client 설정파일은 쉘 스크립트로 생성합니다.
* 쉘 스크립트를 실행하기 위해 인증서 등이 필요합니다.

# 2. 전제조건
* ca 인증서, client 인증서, client private key가 있어야 함
    * [생성 메뉴얼 바로가기](./issue_certificate.md)
* 무결성에 사용하는 ta.key 생성
    * [생성 메뉴얼 바로가기](./setup_openvpn.md)

# 3. 준비
* 디렉터리 생성
```bash
mkdir ~/client-configs
mkdir -p ~/client-configs/keys
mkdir -p ~/client-configs/files
```

## 3.1 ca 인증서, 클라이언트 인증서 복사
```bash
CLIENT_NAME=client1
cp ~/easy-rsa/pki/ca.crt ~/client-configs/keys/
cp ~/easy-rsa/pki/private/$CLIENT_NAME.key ~/client-configs/keys/
cp ~/easy-rsa/pki/issued/$CLIENT_NAME.crt ~/client-configs/keys/
```

## 3.2 ta.key 복사
```bash
sudo cp /etc/openvpn/server/ta.key ~/client-configs/keys/ta.key
chmod 755 ~/client-configs/keys/ta.key
```

## 3.3 클라이언트 설정 파일 복사
* [클라이언트 설정 파일을](./client.conf)을 ~/client-configs/client.conf에 복사
```bash
vi /etc/openvpn/server/server.conf
```

* client.conf에서 remote 주소를 openvpn ec2 instance pulbic ip로 변경
```bash
43줄 remote 52.78.120.108 1194
```

# 4. client 설정파일 생성 스크립트 생성
* 작업 디렉터리 이동
```bash
cd ~/client-configs
```

* opvn파일 생성 스크립트 생성
```bash
vi make_config.sh
```

```bash
#!/bin/bash
# First argument: Client identifier

set -e

KEY_DIR=~/client-configs/keys
OUTPUT_DIR=~/client-configs/files
BASE_CONFIG=~/client-configs/client.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n<tls-crypt>') \
    ${KEY_DIR}/ta.key \
    <(echo -e '</tls-crypt>') \
    > ${OUTPUT_DIR}/${1}.ovpn
```

# 5. client 설정파일 생성 스크립트 실행
```bash
cd ~/client-configs
chmod u+x ~/client-configs/make_config.sh
```

```bash
cd ~/client-configs
./make_config.sh {클라이언트 이름}
```
