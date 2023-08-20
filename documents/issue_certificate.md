# 개요
* openvpn ca, server, client 인증서 생성

# openVPN EC2 instance접속 방법
* [문서 링크](./connect_openvpn_ec2_instance.md)

# 작업 전 설정
## easy-rsa 작업디렉터리 이동
```bash
cd ~/easy-rsa/
```

## easy-rsa 환경변수 설정
* 암호화 알고리즘 설정
```bash
export EASYRSA_ALGO="ec"
export EASYRSA_DIGEST="sha512"
```

## easy-rsa 초기화
```bash
./easyrsa init-pki
```

# CA 생성
## self-signed ca 인증서 생성
```bash
./easyrsa build-ca nopass
# prompt가 나오면 server 문자열 입력
```

```bash
# 인증서 확인
ls ~/easy-rsa/pki/ca.crt
```

# 서버 인증서 생성
```bash
# csr 생성
./easyrsa gen-req {서버 도메인} nopass
# csr 승인
./easyrsa sign-req {서버 도메인} server
```

```bash
# 인증서 확인
ls ~/easy-rsa/pki/issued/
ls ~/easy-rsa/pki/private/
openssl x509 -in ~/easy-rsa/pki/ca.crt -text -noout
```

# 클라이언트 인증서 생성
```bash
# csr 생성
./easyrsa gen-req {클라이언트 이름} nopass
# csr 승인
./easyrsa sign-req {클라이언트 이름} server
```

```bash
# 인증서 확인
ls ~/easy-rsa/pki/issued/
ls ~/easy-rsa/pki/private/
openssl x509 -in ~/easy-rsa/pki/issued/{인증서이름}.crt -text -noout
```

# 참고자료
* openvpn CA 공식문서: https://openvpn.net/community-resources/setting-up-your-own-certificate-authority-ca/
