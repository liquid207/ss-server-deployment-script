#!/user/bin/env bash
if [ $1 = "install" ]
then
    echo "begin to deploy ss-server"
    apt-get install python-pip
    pip install setuptools
    pip install shadowsocks
    sed -i '52c \ \ \ \ libcrypto.EVP_CIPHER_CTX_reset.argtypes = (c_void_p,)' /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
    sed -i '111c \ \ \ \ \ \ \ \ \ \ \ \ libcrypto.EVP_CIPHER_CTX_reset' /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
    echo "please input server_port"
    read server_port
    echo "please input password"
    read password
    echo "create default config file /etc/shadowscoks.json"
    file="/etc/shadowscoks.json"
    if [ -f "$file" ]
    then
    	rm ${file}
    fi
    touch ${file}
    echo "{" >> ${file}
    echo "    \"server\":\"0.0.0.0\"," >> ${file}
    echo "    \"server_port\":${server_port}," >> ${file}
    echo "    \"local_address\":\"127.0.0.1\"," >> ${file}
    echo "    \"local_port\":1080," >> ${file}
    echo "    \"password\":\"${password}\"," >> ${file}
    echo "    \"timeout\":300," >> ${file}
    echo "    \"method\":\"aes-256-cfb\"," >> ${file}
    echo "    \"fast_open\":true," >> ${file}
    echo "    \"workers\":1" >> ${file}
    echo "}" >> ${file}
    ssserver -c /etc/shadowscoks.json -d start
fi

if [ $1 = "uninstall" ]
then
    ssserver -c /etc/shadowscoks.json -d stop
    pip uninstall shadowsocks
    pip uninstall setuptools
    rm "/etc/shadowscoks.json"
fi

