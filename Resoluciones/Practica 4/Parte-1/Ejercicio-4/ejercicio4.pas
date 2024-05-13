{4. Dado el siguiente algoritmo de búsqueda en un árbol B:
procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var 
    clave_encontrada: boolean;
begin
    if (nodo = null)
        resultado := false //clave no encontrada
    else
        begin
            posicionarYLeerNodo(A, nodo, NRR);
            claveEncontrada(A, nodo, clave, pos, clave_encontrada);
            if (clave_encontrada) then begin
                NRR_encontrado := NRR;  //NRR actual 
                pos_encontrada := pos;  //posicion dentro del array 
                resultado := true;
            end
            else
                 buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado)
        end;
end;
Asuma que para la primera llamada, el parámetro NRR contiene la posición de la raíz
del árbol. Responda detalladamente:
a. PosicionarYLeerNodo(): Indique qué hace y la forma en que deben ser
enviados los parámetros (valor o referencia). Implemente este módulo en Pascal.
b. claveEncontrada(): Indique qué hace y la forma en que deben ser enviados los
parámetros (valor o referencia). ¿Cómo lo implementaría?
c. ¿Existe algún error en este código? En caso afirmativo, modifique lo que
considere necesario.
d. ¿Qué cambios son necesarios en el procedimiento de búsqueda implementado
sobre un árbol B para que funcione en un árbol B+?}

{A. posicionarYLeerNodo(A, nodo, NRR) es un procedimiento que se posiciona en un nodo hijo de la raíz para poder seguir buscando la clave buscada. 
La variable nodo corresponde al array de claves correspondiente al nodo hijo, A es el árbol y NRR el índice. 
NRR debe ser pasado por valor, mientras que nodo y A por referencia.}

{B. El método claveEncontrada() es un procedimiento que almacena en la variable clave_encontrada true o false, 
dependiendo si la variable clave se encontró en el árbol, y si se encontró almacena la posición en la variable pos.
La variable clave_encontrada debe ser pasada por referencia ya que se debe cambiar su valor, al igual que pos, 
clave por valor porque sólo se necesita su valor y no modificarlo, y nodo y A se deben pasar por referencia.}

{C. function buscar(NRR,clave:integer;var A:arbol;var pos_encontrada:integer; var NRR_encontrado:integer):boolean;
var
	nodo: array[1..M] of integer;
	pos:integer;
begin
	if (nodo=nil) then buscar:=false;
	else begin
			posicionarYLeerNodo(NRR,A,nodo);
			if (claveEncontrada(A,nodo,clave,pos)) then begin
				pos_encontrada:=pos;
				NRR_encontrado:=NRR
			end
			else buscar:= buscar(nodo.hijo[pos],clave,A,pos_encontrada,NRR_encontrado);
	end;
end;}

{D. El cambio necesario en el procedimiento de busqueda implementado deberia terminar al llegar a una hoja.}