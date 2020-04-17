# OBJETIVO Y REGLAS BÁSICAS DEL JUEGO
El objetivo es identificar en un tablero de juego las posiciones donde se esconden un conjunto de espejos. Para ganar el juego es necesario marcar correctamente todas las casillas del tablero donde pensamos que están los espejos escondidos.

Para ello nos podemos ayudar disparando rayos láser. Estos rayos pueden modificar su trayectoria (hacia arriba, hacia abajo, hacia la derecha o hacia la izquierda) dependiendo de la orientación de los espejos que se encuentran en su camino.

Las orientaciones que pueden tener los espejos son: ``'|'``, ``'/'``, ``'-'``, ``'\'`` y el comportamiento del rayo láser al incidir sobre cada tipo de espejo es: un espejo en diagonal (``‘\’`` o ``‘/’``) cambia en 90º la trayectoria; un espejo paralelo al rayo deja pasar el rayo sin modificar su trayectoria; un espejo perpendicular al rayo lo devuelve en dirección contraria a la que venía.

La siguiente tabla muestra todas las posibilidades:

| Trayectoria del rayo láser antes de llegar al espejo | Tipo de espejo encontrado | Trayectoria del rayo láser tras incidir en el espejo
| --- | --- |---|
| → | \| | ←
| | / | ↑
||-|→
||`\`|↓
|←||
|||
|||
|||
|↓||
|||
|||
|||
|↑||
|||
|||
|||
