# Defender_Exclusions.cmd

Version 1.2 du 18/06/2020 - Par Tlem33
https://github.com/Tlem33/Defender-Exclusions  

***

## DESCRIPTION :

Defender_Exclusions.cmd est un utilitaire qui permet de rajouter ou de supprimer des exclusions de chemin,  
d'extension et de processus dans le programme de protection Windows Defender.  

Les exceptions sont enregistrées dans des fichiers .ini situés dans le sous dossier "CfgFiles".  
Le format des fichiers est tel que :  

               Path    = C:\Dossier1;C:\Dossier2    (Chemins des dossiers à exclure)  
               Ext     = *.tmp;*.bak;*.xxx             (Extensions de fichiers à exclure)  
               Process = Programme1.exe;Programme2.exe     (Noms des processus à exclure)  


## UTILISATION de CePC+.cmd :

Lancez simplement Defender_Exclusions.cmd et choisisez le fichier des exceptions à ajouter ou supprimer.    

## SYSTEME(S) :

Testé sous :

        - Windows 8  
        - Windows 10  

***

## LICENCE :

Licence [MIT](https://fr.wikipedia.org/wiki/Licence_MIT)  

Droit d'auteur (c) 2020 Tlem33  

Une autorisation est accordée, gratuitement, à toute personne obtenant une copie de ce logiciel  
et des fichiers de documentation associés (le «logiciel»), afin de traiter le logiciel sans restriction,  
y compris et sans s’y limiter, les droits d’utilisation, de copie, de modification, de fusion, publiez,  
distribuez, sous-licence et/ou vendez des copies du logiciel, et pour permettre aux personnes  
auxquelles le logiciel est fourni, selon les conditions suivantes:  

La notification du droit d’auteur ci-dessus et cette notification de permission doivent être incluses  
dans toutes les copies ou portions substantielles du Logiciel.  

LE LOGICIEL EST FOURNI « EN L’ÉTAT » SANS GARANTIE OU CONDITION D’AUCUNE SORTE, EXPLICITE OU IMPLICITE  
NOTAMMENT, MAIS SANS S’Y LIMITER LES GARANTIES OU CONDITIONS RELATIVES À SA QUALITÉ MARCHANDE,  
SON ADÉQUATION À UN BUT PARTICULIER OU AU RESPECT DES DROITS DE PARTIES TIERCES. EN AUCUN CAS LES  
AUTEURS OU LES TITULAIRES DES DROITS DE COPYRIGHT NE SAURAIENT ÊTRE TENUS RESPONSABLES POUR TOUT  
DÉFAUT, DEMANDE OU DOMMAGE, Y COMPRIS DANS LE CADRE D’UN CONTRAT OU NON, OU EN LIEN DIRECT OU  
INDIRECT AVEC L’UTILISATION DE CE LOGICIEL.

---

## HISTORIQUE :

30/04/2018 - Version 1.0  

	    - Première version.

14/08/2018 - Verion 1.1

	    - Ajout de la lecture du fichier Exceptions.ini
                   - Contrôle de la version de Windows (Windows 8 mini)
                   - Contrôle du service WinDefend pour vérifier que Defender soit actif

18/06/2020 - Verion 1.2

	    - Modification du batch afin de sélectionner un fichier de configuration parmis plusieurs
