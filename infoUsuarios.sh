#!/bin/bash

function info {
	
	# separador internacional
	IFS=":"
	usuario=($1);

	echo "** INFORMACION PARA ${usuario[0]} **"
	echo "El espacio ocupado por su directorio personal ${usuario[5]} es: " $(du -sh ${usuario[5]} | cut -f1)

	# verificar si el usuario esta logeado;  \b --> separador de palabra
	if $(who | egrep "^${usuario[0]}}\b" &> /dev/null); then
		echo "Actualmente esta logueado en el sistema"
	else

		# extraer la ultima linea del archihvo para verificar su ultima conexion  tr --> si hay varios espacios solo toma 1
		acceso=$(grep opened.*${usuario[0]} /var/log/auth.log | tail -n1 | tr -s " " | cut -d" " -f1-3)
		
		# si no ha accesado
		if [ -z $acceso]; then
			echo "Nunca ha estado en el sistema"
		else
			# -n --> evitar salto de linea
			echo " su ultimo acceso fue: $acceso"
		fi
	fi

	IFS=" "
	
}


read -p "Introduzca el nombre del grupo: " grupo

# obtener el GID del grupo introducido
gid=$(egrep ^$grupo: /etc/group | cut -d":" -f3)

# obtener todos los usuarios con ese GID
usuarios=$(egrep "^\w+:x:\w+:$gid" /etc/passwd)

# si no hay usuarios
if [ -z "$usuarios" ]; then
	echo "No se han encontrado usuarios"
	exit 1
fi


for usuario in $usuarios; do
	info $usuario
done















