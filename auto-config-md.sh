#! /bin/bash
function customTerminal() {
[general]
fontname=Courier New 18
selchars=-A-Za-z0-9,./?%&#:_
scrollback=1000
bgcolor=#000000000000
bgalpha=65535
fgcolor=#d3d3d7d7cfcf
palette_color_0=#000000000000
palette_color_1=#cdcd00000000
palette_color_2=#4e4e9a9a0606
palette_color_3=#c4c4a0a00000
palette_color_4=#34346565a4a4
palette_color_5=#757550507b7b
palette_color_6=#060698989a9a
palette_color_7=#d3d3d7d7cfcf
palette_color_8=#555557575353
palette_color_9=#efef29292929
palette_color_10=#8a8ae2e23434
palette_color_11=#fcfce9e94f4f
palette_color_12=#72729f9fcfcf
palette_color_13=#adad7f7fa8a8
palette_color_14=#3434e2e2e2e2
palette_color_15=#eeeeeeeeecec
color_preset=Tango
disallowbold=false
cursorblinks=false
cursorunderline=false
audiblebell=false
tabpos=top
geometry_columns=80
geometry_rows=24
hidescrollbar=false
hidemenubar=false
hideclosebutton=false
hidepointer=false
disablef10=false
disablealt=false
disableconfirm=false

[shortcut]
new_window_accel=<CTRL><SHIFT>N
new_tab_accel=<CTRL><SHIFT>T
close_tab_accel=<CTRL><SHIFT>W
close_window_accel=<CTRL><SHIFT>Q
copy_accel=<CTRL><SHIFT>C
paste_accel=<CTRL><SHIFT>V
name_tab_accel=<CTRL><SHIFT>I
previous_tab_accel=<CTRL>Page_Up
next_tab_accel=<CTRL>Page_Down
move_tab_left_accel=<CTRL><SHIFT>Page_Up
move_tab_right_accel=<CTRL><SHIFT>Page_Down
zoom_in_accel=<CTRL>plus
zoom_out_accel=<CTRL>underscore
zoom_reset_accel=<CTRL>parenright
}

function aliaTerminal() {
	no_duplicates=`grep -c "0x4004" /home/$USER/.bashrc`
echo "entra en la funcion alias"
	if [ "$no_duplicates" -eq "0" ]; then
        	echo "
	        #Alias 0x4004
	        alias apagar='sudo shutdown -h now'
	        alias reiniciar='sudo shutdown -r now'
	        alias instalar='sudo apt-get update && sudo apt-get install'
	        alias actualizar='sudo apt-get update && sudo apt-get upgrade && sudo a$
	        alias buscar='apt-cache search'
	        alias desinstalar='sudo apt-get purge'" | tee -a /home/$USER/.bashrc
	        if [ "$?" -eq 0 ]; then
	                echo "[ OK ] Registro de alias .bashrc"
        	else
	                echo "[FAIL] Registro de alias .bashrc"
	        fi
	else
	        echo "[ OK ] Los alias ya estaban registrados, saltando paso"
	fi
}

function fondoPantalla() {
	sed -i 's/wallpaper_mode=.*/wallpaper_mode=color/'   /home/$USER/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
	var1=$?
	sed -i 's/desktop_bg=#.*/desktop_bg=#000000000000/' /home/$USER/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
	var2=$?

	let var3=$var1+$var2

	if [ "$var3" -eq 0 ]; then
        	echo "[ OK ] Fondo de pantalla"
	else
        	echo "[FAIL] Fondo de pantalla"
	fi

}

function resolucionPantalla() {
	echo -n "Creando copia de seguridad /boot/config.txt.backup..."
	sudo cp /boot/config.txt /boot/config.txt.backup
	if [ "$?" -eq 0 ]; then
	        echo "OK"
	else
	        echo "FAIL"
	        echo "No se ha podido crear copia de seguridad, ningun archivo ha sido modificado, terminando..."
	        exit
	fi
	sudo sed -i 's/.*dmi_force_hotplug=.*/hdmi_force_hotplug=1/' /boot/config.txt
	aux1=$?
	sudo sed -i 's/.*dmi_group=.*/hdmi_group=2/' /boot/config.txt
	aux2=$?
	sudo sed -i 's/.*dmi_mode=.*/hdmi_mode=82/' /boot/config.txt
	aux3=$?

	let aux4=$aux1+$aux2+$aux3
	if [ "$aux4" -eq 0 ]; then
        	echo "[ OK ] Cambio de resolucion de pantalla"
	        echo -n "Eliminando copia de seguridad..."
	        sudo rm /boot/config.txt.backup
        	if [[ "$?" -eq 0 ]]; then
                	echo "OK"
        	else
                	echo "ERROR"
        	fi
	else
        	echo "[FAIL] Error al cambiar la resolucion de pantalla"
	        echo -n "Restaurando el archivo original..."
		sudo rm /boot/config.txt
	        sudo cp /boot/config.txt.backup /boot/config.txt
        	if [[ "$?" -eq 0 ]]; then
	                echo "OK"
	        else
	                echo "ERROR"
        	        exit
	        fi
        	echo -n "Eliminando copia de seguridad..."
	        sudo rm /boot/config.txt.backup
	        if [[ "$?" -eq 0 ]]; then
	                echo "OK"
	        else
	                echo "ERROR"
	        fi
	fi
}
echo -n "¿Desea ingresar alias?[y/n]"
read aliax
echo -n "¿Desea poner un fondo de pantalla negro solido?[y/n]"
read fondo
echo -n "¿Desea cambiar el tamaño de pantalla a HDMI 1920x1080?[y/n]"
read size
echo -n "(Recomendado)¿Desea reiniciar automaticamente despues de aplicar los cambios?[y/n]"
read reset
if [ "$aliax" = "y" ]; then
	# bash sources/scriptaliasrpi.sh
	aliaTerminal
fi

if [ "$fondo" = "y" ]; then
	#bash sources/scriptbackground.sh
	fondoPantalla
fi

if [ "$size" = "y" ]; then
	#bash sources/scriptscreensize.sh
 	resolucionPantalla
fi

if [ "$aliax" == "y" -o "$fondo" == "y" -o "$size" -o "y" ] ; then
  if [[ "$reset" = "y" ]] ; then
    shutdown -r now
  fi
else
  echo "No se ha aplicado ningun cambio, no es necesario reiniciar"
fi


