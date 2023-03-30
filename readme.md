## Synthèse :
Le package R COGugaison est ici utilisé pour gérer des variables numériques possédant un COG à l'évolution de ce dernier dans le temps. 
On utilise en particulier les fonctions ```changement_COG_varNum()``` (variables numériques) et ```changement_COG_typo()``` (variables discrètes)

## Cas d'usage :
### Variable numérique : 
La situation type est que l'on souhaite évaluer un territoire (au regard d'une variable numérique) sur une période donnée. Au sein de ce territoire les communes évoluent, se fusionnent, se défusionnent. Afin de ne pas avoir à gérer cette problématique manuellement, le package, à l'aide de tables de passage de l'INSEE, permet de ramener vos tables décrivant une série temporelle vers une seule géographie sur laquelle vous souhaitez réaliser votre analyse.

|![Alt text](./supports/illustrations/fusion.png "Exemple de fusion de 10 communes en 2015 pour former la commune de Beaupréeau (INSEE 49023) en 2016 (visuel produit à l'aide de la fonction trajectoire_commune() du package COGugaison)")|
|:--:| 
|*Exemple de fusion de 10 communes en 2015 pour former la commune de Beaupréeau (INSEE 49023) en 2016 (visuel produit à l'aide de la fonction trajectoire_commune() du package COGugaison)*|

En cas de fusion, la fonction additionne les observations des communes concernées.
En cas de défusion, elle pondère la variable en fonction du nombre d'habitants.

### Variable discrète : 
Pour une raison ou pour une autre on peut avoir besoin de "cogugaisonner" une typologie. En l'occurrence le package offre une diversité de règles pouvant être appliquées afin d'attribuer une typologie lorsque plusieurs communes sont fusionnées et qu'elles possèdent plusieurs typologie. 
- ```methode_max_pop``` : attribuer la classe de la commune contenant le maximum de population des communes fusionnées
- ```methode_classe_absorbante``` : attribuer la classe dite absorbante à toute commune fusionnée contenant au moins une ancienne commune appartenant à cette classe absorbante
- ```methode_classe_absorbee``` : ne pas tenir compte de cette classe dite "absorbée" pour toute commune fusionnée contenant au moins une ancienne commune appartenant à cette classe absorbée
-  ```methode_classe_fusion``` : pour toutes les communes qui ont fusionné entre 2 dates indiquer comme classe la valeur inscrite dans "mot_fusion" y compris pour les fusions de communes de mêmes classes (sinon utiliser la méthode : "methode_difference")
-...
