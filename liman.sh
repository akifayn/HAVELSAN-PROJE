#!/bin/bash


# KALDIRMA İŞLEMLERİNİ GERÇEKLEŞTİRDİĞİMİZ FONKSİYON.
kaldır(){
    echo $(date)" LİMAN KALDIRMA İŞLEMİ BAŞLATILIYOR----------------------------" >> liman_new.log
    sudo service liman stop
    sudo apt remove liman
    sudo apt remove node.js
    sudo apt remove postgresql
    sudo apt autoremove
    sudo apt clean
    echo  $(date)" LİMAN KALDIRILDI.----------------------------------------------------------------------------" >> liman_new.log
}

# LİMAN ARAYÜZ ŞİFRESİNİ UNUTTUĞUMUZDA AŞAĞIDAKİ KOMUT SATIRINI ÇALIŞTIRARAK YENİ ŞİFRE GÖNDEREN FONKSİYON.
reset(){
    sudo limanctl reset administrator@liman.dev
    echo $(date)" ŞİFRE SIFIRLANDI.-------------------------------------------------------------------------------------" >> liman_new.log
}

# limanctl KOMUTLARI HAKKINDA BİLGİ ALMAK İSTEYENLER İÇİN KULLANILABİLECEK KOMUT FONKSİYONU.
help(){
    sudo limanctl help
    echo $(date)" limanctl KOMUTLARI HAKKINDA KULLANIM KILAVUZU YUKARIDA VERİLDİ.---------------------------------------" 
}

# LİMAN KURMA İŞLEMİ BARARILI OLMASI DURUMUNDA BURADAKİ KOMUT KULLANILARAK GEÇİCİ MAİL VE ŞİFREYE ULAŞILABİLİNİYOR.
administrator(){
    sudo limanctl administrator
    echo $(date)" GEÇİCİ GİRİŞ BİLGİLERİ VERİLDİ.---------------------------------------------------------------" >> liman_new.log
    ip="10.0.2.15"
    echo $(date) "$ip"
}

# ARAYÜZE DOĞRUDAN ERİŞİMİ SAĞLAYAN KOD SATIRIMIZ, İP BİLGİSİNİ SİZE VEREREK VERİLEN LİNK İLE DOĞRUDAN WEB ARAYÜZÜNE ERİŞİMİ SAĞLIYOR.
arayuz(){
    ip="10.0.2.15"
    echo $(date) $ip "ADRESİNE GİDİLİYOR" >> liman_new.log
    xdg-open https://$ip/auth/login?redirect=/

}

# BURADAKİ FONSİYON ÇALIŞTIRILARAK GEREKLİ TÜM İNDİRME İŞLEMLERİNİ GERÇEKLEŞTİRİLEBİLİYOR. 
kur(){
    echo $(date)" LİMAN KURULUYOR.--------------------------------------------------------------------------------------" >> liman_new.log
    NODE_MAJOR=18

    # Repoları indirme fonksiyonu
    download_repos() {
        echo $(date)" REPOLARI İNDİRİLİYOR.------------------------------------------------------------------------------" >> liman_new.log
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        echo $(date) "REPOLARIN KURULUMU TAMAMLANDI" >> liman_new.log    
}

    # Node.js kurma fonksiyonu
    install_nodejs() {
        echo $(date)" Node.js KURULUYOR.--------------------------------------------------------------------------------" >> liman_new.log
        sudo apt-get install -y nodejs
        echo $(date)" Node.js KURULUMU TAMAMLANDI " >> liman_new.log
    }

    # PHP repolarını ekleme fonksiyonu
    add_php_repos() {
        echo $(date)" PHP REPOLARI  EKLENİYOR.---------------------------------------------------------------------------" >> liman_new.log
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository ppa:ondrej/php
	echo $(date)" PHP REPOLARI EKLENDİ " >> liman_new.log
    }

    # PostgreSQL repolarını ekleme fonksiyonu
    add_postgresql_repos() {
        echo $(date)" PostgreSQL REPOLAR EKLENİYOR.--------------------------------------------------------------------" >> liman_new.log
        sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
        wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > pgsql.gpg
        sudo mv pgsql.gpg /etc/apt/trusted.gpg.d/pgsql.gpg
	echo $(date)" PostgreSQL REPOLARI EKLENDİ " >> liman_new.log
    }

    # Debian paketini indirme ve kurma fonksiyonu
    install_debian_package() {
        echo $(date)" DEBİAN PAKETİ İNDİRİLİYOR.-----------------------------------------------------------------------" >> liman_new.log
        wget https://github.com/limanmys/core/releases/download/release.feature-new-ui.863/liman-2.0-RC2-863.deb
        sudo apt-get install -y ./liman-2.0-RC2-863.deb
	echo $(date)" DEBİAN PAKETİ İNDİRİLDİ " >> liman_new.log    
}

    # Repoları indir
    download_repos

    # Repoları başarıyla indirildiyse Node.js'i kur
    if [ $? -eq 0 ]; then
        install_nodejs

        # Node.js kurulumu başarıyla tamamlandıysa PHP repolarını ekle
        if [ $? -eq 0 ]; then
            add_php_repos

            # PHP repoları eklendiyse PostgreSQL repolarını ekle
            if [ $? -eq 0 ]; then
                add_postgresql_repos

                # PostgreSQL repoları eklendiyse Debian paketini indir ve kur
                if [ $? -eq 0 ]; then
                    install_debian_package
                else
                    echo $(date)" Hata: PostgreSQL REPOLARI EKLENEMEDİ!--------------------------------------------------" >> liman_new.log
                fi
            else
                echo $(date)" Hata: PHP REPOLARI EKLENEMEDİ!-------------------------------------------------------------" >> liman_new.log
            fi
        else
            echo $(date)" Hata: Node.js KURULUMU BAŞARISIZ!--------------------------------------------------------------" >> liman_new.log
        fi
    else
        echo $(date)" Hata: REPOLARI  İNDİRME BAŞARISIZ!-----------------------------------------------------------------" >> liman_new.log
    fi
}

#TERMİNALDEN ÇAĞIRMA.
if [ "$1" == "kaldır" ]; then
    kaldır
elif [ "$1" == "reset" ]; then
    reset
elif [ "$1" == "help" ]; then
    help
elif [ "$1" == "administrator" ]; then
    administrator
elif [ "$1" == "arayuz" ]; then
    arayuz
elif [ "$1" == "kur" ]; then
    kur
fi

