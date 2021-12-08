
BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")

# путь к директории хранилища ключей
export __STORE_NAME__="store"

# путь к файлу хранилища ключей
export __STORE__="${BIN}/${__STORE_NAME__}/keystore.jks"

# путь к файлу конфига
export __CONF__="${BIN}/${__STORE_NAME__}/keystore.conf"

# пароль к файлу хранилища ключей [только для разработки]
export __PIN__="passw0rd4^282"

# алиас закрытого ключа
export __ALIAS_KEY__="2021"

# Common Name сертификата afsc
export __DNAME__="CN=wa4"

# путь к файлу запроса на выпуск сертификата afsc
export __REQ_CERT__="${BIN}/${__STORE_NAME__}/req-cert.pem"
