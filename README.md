# ImageSquash
Ce projet à pour but de rétablir les images d'un export provenant de SquashTM

# Cas traités
- Des balises <v:shape></v:shape> contienent une image dans le alt => on les mets dans une <img /> 

- Les balises <img /> ont les données d'une image dans l'attribut alt => on les déplace dans le src

# Suggestions d'améliorations
- Mode silencieux (sans UI) : 
  > ImageSquash.exe fichierSource.html
  
  > ImageSquash.exe dossierSource
- Gérer de multiples fichiers sources dans l'UI
- Améliorer les performances : Le StringReplace de Delphi est très lent, et très utilisé dans cette implémentation
- Faire en sorte de ne pas modifier un fichier déjà réparé
- Nettoyer le fichier de sortie
