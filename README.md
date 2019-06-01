# teraform-first

## etapes 1:

Inscription à aws (https://aws.amazon.com):
	- remplir tous les champs (email tel region..)
	- rentrer carte bancaire valide
	- valider le numero de téléphone
	- choisir le service gratuit 

se connecter a Aws


## etapes 2:
créer un Service S3 : 
	- cliquer sur services sur la page d'acceuil 
	- selectionner Stockage -> S3
	- cliquer sur créer un compartiment
	- le nom du compartiment est jp-caillet-firstbucket
	- region -> UE (ireland)
	- suivant
	- suivant 
	- creer un compartiment 



## etapes 3:

Créer un utilisateur : 
	- cliquer sur services sur la page d'acceuil 
	- selectionner 	Sécurité, Identité Et Conformité -> IAM
	- sélectionner Tableau de bord -> Utilisateur
	- ajouter un utilisateurs
	- nom utilisateur jp
	- type d’acces : accès par programmation uniquement 
	- Attacher directement les stratégies existantes -> cocher le premier (administrator access) 
	- suivant 
	- suivant 
	- créer un utilisateur 
	- Télécharger le *.csv* 
	- Creer un *.env* 
	- copier coller dedans le clef d'acces et la clef secrete 
	```
	export AWS_ACCESS_KEY=
	export AWS_SECRET_KEY=
	```
	- `source .env`


## etapes 4:

Packer (créateur d'AMI): 
	- `brew install packer`
	- `cd live/eu-west-1/database`
	- `packer build packer.json`
	- allez dans Services -> EC2 -> AMI (Images)
	- Sélectionner l’AMI, puis cliquer sur « Lancer », sélectionner « t2 micro » (Gratuit) et cliquer sur « vérifier et lancer »
	- Etape 7 : Examiner le lancement de l’instance -> cliquer directement sur « Lancer »
	- Dans la liste déroulante, choisir « créer une nouvelle paire de clés »  et la nommer « jpKey », télécharger les clés et enfin lancer les instances.
	-  copier / coller le fichier téléchargé (jpKey.pem) dans `~/.zsh`
	- Aller dans `cd ~/.ssh` puis donner les droits `chmod 6OO jpKey.pem`
	- Exécuter `ssh-add jpKey.pem`
	- Copier / coller l'ID AMI dans EC2 -> AMI dans le *main.tf* ligne 113

## etapes 5:

Terraform (creer une instance):
	- `terraform init` 
	- `terraform apply`

## etapes 6:

Cpnnection au SSH:
	- Récupérer le DNS public (IPv4) dans Services -> EC2 -> Instances
	- `ssh ubuntu@[DNS-PUBLIC]` (DNS recuperé ci dessus)
	- une fois connecter à l'instance via le ssh executer :
  		- `mkdir config`
  		- `nano config/config.json`
 		- copier / coller le fichier suivant dans config.json en modifiant l'host par le point de terminaison de la base de donnée (RDS -> base de données cliquer sur la base en cours postgreSLQL -> puis point de terminaison
```
{
  "server": {
    "host": "0.0.0.0",
    "port": "8080"
  },
  "options": {
    "prefix": "http://localhost:8080/"
  },
  "postgres": {
    "host": "",
    "port": "5432",
    "user": "jp",
    "password": "france98",
    "db": "firstdatabase"
  }
}
```
		- `ursho`
	- Enfin, ouvrir un nouveau terminal et se connecter en ssh 
	- `ssh ubuntu@[DNS-PUBLIC]`  (DNS recuperé plus haut)
	- Executer en remplacant LOCALHOST par IP Publique IPv4 qui se trouve dans EC2 -> Instances, cliquer sur l'Instance en cours et récuper l'IP Publique IPv4  :  
	`curl -H "Content-Type: application/json" -X POST -d '{"url":"www.google.com"}' http://localhost:8080/encode/`