# Ubuntu'ya Güncel PHP Ekleme

sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Ubuntu'ya NodeJS Yükleme

sudo apt install -y ca-certificates curl gnupg gnupg2
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update

# Ubuntu'ya PostgreSQL Yükleme

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt install gnupg2 ca-certificates -y
wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > pgsql.gpg
sudo mv pgsql.gpg /etc/apt/trusted.gpg.d/pgsql.gpg
sudo apt update


sudo apt install -y postgresql-common   
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

->i386 hatası aldığımız için PstgreSQL paketini indiremedik. Çözüm olarak başka bir siteden yukarıdaki 2 kod satırını aldık.


# Liman Paketi Indirilmesi

sudo apt install ./liman-2.0-868.deb -y
echo "deb [arch=amd64] http://depo.aciklab.org/ jammy main" | sudo tee /etc/apt/sources.list.d/acikdepo.list
wget -O- http://depo.aciklab.org/public.key  | gpg --dearmor > aciklab.gpg
sudo mv aciklab.gpg /etc/apt/trusted.gpg.d/aciklab.gpg

# Depodan Liman Paketini Yükleme

sudo apt update
sudo apt install liman

# Yönetici Parolası Oluşturma

sudo limanctl administrator 

->liman paketi kurulduğunda geçici olarak e-posta ve şifre verildi.Web Arayüzüne erişmek için ip adresimi aşağıdaki komut ile öğrendim.Liman Arayüzüne girdikten sonra bana verilen geçici şifreyi güncelleyerek admin girişi yaptım.


# Web Arayüzüne Girmek İçin Ip Adresi Bulma

ip a

# Yönetici Parolası Resetleme

->Liman yönetici parolasını unutmamız durumunda aşağıdaki komutu kullanarak parolayı sıfırlayabiliyoruz.

sudo limanctl reset administrator@liman.dev

# Help Komutu Kullanımı

->limanctl Komutlarının nasıl kulanıldığı hakkında bilgi verir.

sudo limanctl help

# Liman Arayüzünü Kaldırma

sudo service liman stop     ->Limanı Durdurmak
sudo apt remove liman       ->Limanı Kaldırma İşlemi
sudo rm -r /etc/liman       ->Konfigürasyon Dosyalarını Kaldırın 
sudo apt autoremove         ->Liman'ın kaldırılması sırasında kullanılmayan bağımlılıkların temizlenmesi 
sudo apt clean              ->Sistemden Kalan Gereksiz Dosyaları Temizleyin
