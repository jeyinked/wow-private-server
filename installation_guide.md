[Prerequisites]:

1) Ubuntu server 24.04 lts
2) 8go sdram
3) 2~4 vcpu
4) 60 go 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[Installation de Docker]:


#Maj des pacquet
sudo apt update && sudo apt upgrade -y

#Desinstallation des des dependance inutile
sudo apt autoremove -y

#Install les tools
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common byobu

#Telecharge la clé gpg docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#configure le repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install docker
sudo apt update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Ajout l'utilisateur dans le group docker
sudo usermod -aG docker {username}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[Installation d'AzerothCore 3.3.5 avec le Playerbots Module Docker Setup]:


#Création d'un repertoire docker
mkdir /home/{username}/docker

#Changememt de droit sur le repertoire docker
chown -R digital:digital /home/{username}/docker

#Se positione dans le repertoire docker
cd /home/{username}/docker

#Clone le depot du server wow
git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot

#Se positione dans le repertoire module
cd /home/{username}/docker/azerothcore-wotlk/modules

#Clone le depot des bots
git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master

#Changer les droits
sudo chmod -R 777 /home/{username}/docker/

#Edite le fichier docker-compose
sudo vim docker-compose.yml

#Ajoute dans le fichier docker-compose.yml, les 2 lignes:
(Add To Line 90):

      # playerbots folder
      - ./modules/mod-playerbots/:/azerothcore/modules/mod-playerbots:ro

#Build du docker compose
sudo docker compose up -d --build

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[Configuration du Royaume]:

#Affiche les procecus docker
docker ps -a

#Acces au conteneur docker mysql  (Acccount: root)  (Password: password):
docker exec -it {idcontainer}   mysql -uroot -p     

#Selection de la table acore_auth
use acore_auth

#Modif dans la table acore_auth 
DELETE FROM realmlist WHERE id=1;
INSERT INTO realmlist (id, name, address, localAddress, localSubnetMask, port, icon, flag, timezone, allowedSecurityLevel, gamebuild)
VALUES ('1', 'servername', 'ippublic', 'ipprivée','255.255.255.0','8085', '1', '0', '1', '0', '12340');

exit

#Reboot les élèments du Docker
docker compose restart

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

[Ajout d'un compte]:

#Se connecte sur le docker ac-worldserver
docker attach ac-worldserver

#Crée un compte
account create username userpassword

#ajout d'un compte GM
account set addon username 2

#quitter
Control + P + Control + Q 



