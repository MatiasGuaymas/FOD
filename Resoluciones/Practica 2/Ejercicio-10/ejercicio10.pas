{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
......             ..........    .........
......             ..........    .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.}

program ejercicio10;
const
    valoralto = 999;
type
    subCat = 1..15;
    empleado = record
        departamento: integer;
        division: integer;
        num: integer;
        categoria: integer;
        cantHoras: integer;
    end;
    maestro = file of empleado;
    categoria = array[subCat] of real;
procedure crearMaestro(var mae: maestro);
var
    carga: text;
    nombre: string;
    infoMae: empleado;
begin
    assign(carga, 'empleados.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, departamento, division, num, categoria, cantHoras);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure cargarVector(var vecCat: categoria);
var
    txt: text;
    categoria: subCat;
    monto: real;
begin
    assign(txt, 'categoriaValor.txt');
    reset(txt);
    while(not eof(txt)) do
        begin
            read(txt, categoria, monto);
            vecCat[categoria]:= monto;
        end;
    close(txt);
end;
procedure leer(var mae: maestro; var emp: empleado);
begin
    if(not eof(mae)) then
        read(mae, emp)
    else
        emp.departamento:= valoralto;
end;
procedure corteDeControl(var mae: maestro; vecCat: categoria);
var
    emp: empleado;
    montoHorasDepto, montoTotalDiv, montoTotalEmp: real;
    cantHorasDepto, cantHorasDiv, cantHorasEmp, deptoActual, divActual, empActual, categoria: integer;
begin
    reset(mae);
    leer(mae, emp);
    while(emp.departamento <> valoralto) do
        begin
            writeln();
            writeln('-------Departamento: ', emp.departamento, ' -------');
            deptoActual:= emp.departamento;
            cantHorasDepto:= 0;
            montoHorasDepto:= 0;
            while(deptoActual = emp.departamento) do
                begin
                    writeln();
                    writeln('Division: ', emp.division);
                    montoTotalDiv:= 0;
                    cantHorasDiv:= 0;
                    divActual:= emp.division;
                    writeln('Numero de Empleado     Total de HS    Importe a cobrar');
                    while((deptoActual = emp.departamento) and (divActual = emp.division)) do
                        begin
                            montoTotalEmp:= 0;
                            cantHorasEmp:= 0;
                            empActual := emp.num;
                            categoria:= emp.categoria;
                            while((deptoActual = emp.departamento) and (divActual = emp.division) and (empActual = emp.num)) do
                                begin
                                    cantHorasEmp:= cantHorasEmp + emp.cantHoras;
                                    leer(mae, emp);
                                end;
                            montoTotalEmp:= vecCat[categoria] * cantHorasEmp;
                            writeln(empActual, '                          ', cantHorasEmp, '           ', montoTotalEmp:0:2);
                            montoTotalDiv:= montoTotalDiv + montoTotalEmp;
                            cantHorasDiv:= cantHorasDiv + cantHorasEmp;
                        end;
                    writeln('Total de horas por division: ', cantHorasDiv);
                    writeln('Monto total por division: ', montoTotalDiv:0:2);
                    montoHorasDepto:= montoHorasDepto + montoTotalDiv;
                    cantHorasDepto:= cantHorasDepto + cantHorasDiv;
                end;
            writeln();
            writeln('Total horas departamento: ', cantHorasDepto);
            writeln('Monto total departamento: ', montoHorasDepto:0:2);
        end;
end;
var
    mae: maestro;
    vecCat: categoria;
begin
    crearMaestro(mae);
    cargarVector(vecCat);
    corteDeControl(mae, vecCat);
end.