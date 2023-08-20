# 개요
* openvpn client 설정파일 생성
* client 설정파일은 쉘 스크립트로 생성합니다.
* 쉘 스크립트를 실행하기 위해 인증서 등이 필요합니다.

# 전제조건
* ca 인증서, client 인증서, client private key가 있어야 함
    * [생성 메뉴얼 바로가기](./issue_certificate.md)

# 준비
* 디렉터리 생성
```bash
mkdir -p ~/client-configs/keys
```

* ca 인증서, 클라이언트 인증서 복사
```bash
CLIENT_NAME=client1
cp ~/easy-rsa/pki/ca.crt ~/client-configs/keys/
cp ~/easy-rsa/pki/private/$CLIENT_NAME.key ~/client-configs/keys/
cp ~/easy-rsa/pki/issued/$CLIENT_NAME.crt ~/client-configs/keys/
```

* 예제 클라이언트 설정 파일 복사
```bash
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf
```

* 클라이언트 설정 파일 수정
```conf
# openvpn 서버 주소
remote {openvpn ec2_instance public ip} 1194

# 인증서 경로
ca.crt
client1.crt
client1.key

# 인증서 암호 알고리즘 설정
auth SHA256
cipher AES-256-GCM

# key-direction 1
key-direction 1

# tls-crypt 주석
;tls-auth ta.key 1

# openvpn실행 최소권한
user nobody
group nogroup
```

# client 설정파일 생성 스크립트 생성
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
KEY_DIR=~/client-configs/keys
OUTPUT_DIR=~/client-configs/
BASE_CONFIG=~/client-configs/base.conf

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    ${KEY_DIR}/${1}.crt \
    <(echo -e '</cert>\n<key>') \
    ${KEY_DIR}/${1}.key \
    <(echo -e '</key>\n') \
    > ${OUTPUT_DIR}/${1}.ovpn
```

# client 설정파일 생성 스크립트 실행
```bash
cd ~/client-configs
chmod 700 ~/client-configs/make_config.sh
```

```bash
cd ~/client-configs
./make_config.sh {클라이언트 이름}
```
