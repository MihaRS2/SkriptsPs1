# Указываем адрес KMS сервера
$kmsServer = "172.33.0.2"

# Устанавливаем KMS сервер для активации
slmgr.vbs /skms $kmsServer

# Принудительная активация
slmgr.vbs /ato

# Логирование
Write-Output "KMS Server set to $kmsServer and activation command sent."
