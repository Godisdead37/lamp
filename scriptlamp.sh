#!/bin/bash

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installer Apache
echo "Installation d'Apache..."
sudo apt install -y apache2
sudo systemctl enable --now apache2

# Installer MariaDB
echo "Installation de MariaDB..."
sudo apt install -y mariadb-server
sudo systemctl enable --now mariadb

# Sécuriser MariaDB automatiquement
echo "Sécurisation automatique de MariaDB..."
sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('1234') WHERE User='root';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "MariaDB sécurisé avec un mot de passe par défaut : 1234"

# Installer PHP et modules
echo "Installation de PHP et des modules nécessaires..."
sudo apt install -y php php-mysql php-cli php-curl php-gd php-mbstring php-xml libapache2-mod-php

# Redémarrer Apache pour prendre en compte PHP
echo "Redémarrage d'Apache..."
sudo systemctl restart apache2

# Créer une page PHP de test
echo "Création de la page phpinfo..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Affichage de l'adresse du serveur
echo "Installation terminée. Rendez-vous sur http://$(hostname -I | awk '{print $1}')/info.php pour tester PHP."
