#!/usr/bin/env bash

module load git 

###################
### Usage check ###
###################
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {clone_icon|copy_exe|exp_only}"
    exit 1
fi

ACTION="$1"
###################

#####################
### Configuration ###
#####################

ICON_REPO='https://gitlab.dkrz.de/icon/icon-model.git'
ART_NOTEBOOKS_REPO='https://github.com/J-Bruckert/icon-art-training.git'
#ART_NOTEBOOKS_REPO='git@github.com:J-Bruckert/icon-art-training.git'
ICON_EXE_FILE=
####################



HPC=$(hostname -s)
echo "Detected host: ${HPC}"


#########################
### Clone and compile ###
#########################

echo ${ACTION}
case "${ACTION}" in
	clone_icon)
		case "${HPC}" in 
			levante*)
				echo "Clone ICON-ART"
				# clone ICON-ART
				git clone --recursive ${ICON_REPO}
				cd icon-model

				# compile ICON-ART
				echo 'compile ICON-ART on Levante'
				./config/dkrz/levante.intel --enable-art
				make -j 8
				;;
			horeka*)
				echo 'To Do'
				;;
			*)
				echo "unknown HPC system"
				;;
		esac
	
	;;

################################
### copy ICON-ART executable ###
################################
	copy_exe)
	        case "${HPC}" in
        	        levante*)
				wget --content-disposition "https://bwsyncandshare.kit.edu/public.php/dav/files/tMyRqQytrYCnMmj/?accept=zip"
				chmod 755 icon
				;;
	                horeka*)
        	                echo 'To Do'
				;;
                	*)
                        	echo "unknown HPC system"
				;;
	        esac
	;;

##############################
### only clone experiments ###
##############################
	exp_only)
		echo "only clone ICON-ART experiments"
		;;
	*)
		echo "unknown argument: '${ACTION}'"
		echo "Valid arguments:"
	        echo "  clone_icon   Clone ICON-ART repository"
        	echo "  copy_exe     Copy ICON-ART executable file"
		echo "  exp_only     Clone experiments only"
        exit 1

		;;
esac


# clone ICON-ART Notebooks
git clone ${ART_NOTEBOOKS_REPO}

# copy Initial data
wget --content-disposition "https://bwsyncandshare.kit.edu/public.php/dav/files/AD9EL9pGEEEyazB/?accept=zip"
unzip INPUT_DATA.zip
chmod -R 755 INPUT_DATA

### FINISH ###
echo 'Setup completed successfully'
