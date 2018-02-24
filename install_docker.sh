#!/usr/bin/env bash

# Interactive script to aid in the installation of Docker on Ubuntu hosts. 
# This encompasses all the necessary steps to establish a Docker environment in which to host and run your Docker images.
# Author: Carlos Mendez
# Created: 21AUG2016
# License: Do what you want but don't blame me!

# 1. Determine if prerequisites are met

#<<<<<<<<<< Suporting Methods >>>>>>>>>>#

# define the valid_kernel function
function valid_kernel() {
    echo "Since you have a qualifying version of the kernel,"
    echo "we're going to go ahead and install the linux-image-extra package."
    echo "This package contains the aufs storage driver."
    echo

    read -p "Do you wish to proceed with the install of linux-image-extra (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Installing linux-image-extra..."
            echo

            sudo apt-get install linux-image-extra-$(uname -r)
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will need to start over if you wish to meet the prerequisites for installing Docker."
            echo
            echo "Exiting."
            echo
        ;;
    esac
}

# define the update_packages function
function update_packages() {
    echo "Now we will run apt-get update to make sure we have the most recent packages."
    echo

    read -p "Do you wish to proceed with the package update (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Running apt-get update..."
            echo

            sudo apt-get update
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will need to start over if you wish to meet the prerequisites for installing Docker."
            echo
            echo "Exiting."
            echo
        ;;
    esac
}


#<<<<<<<<<< Primary Decisioning Logic >>>>>>>>>>#

# First, let's confirm we've got a sufficiently recent Linux kernel.
function prerequisites() {
    echo "Determining if Ubuntu has a sufficiently recent kernel to support the install of Docker."
    echo "Look at the output below and locate your kernel version number."
    echo
    # We will use the uname command
    uname -a

    # Based on the version of the users kernel let them choose the next move
    read -p "Is your kernel version 3.13.0 or greater (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo
            echo "Great, that's one big step saved!"
            # call the function continue to proceed with the install
            valid_kernel
            # call the function to update the packages list
            update_packages
        ;;
        n|N )
            echo "Ok so you don't have a recent enough version."
            echo "You're going to need to update your kernel to a more recent version before continuing."
            echo "Because updating the kernel of an operating system is a complex business, we will not attempt to script this process."
            echo "Please complete this step according to your specific circumstances and then rerun this script when you have updated to a version that satisfies the prerequisites for installing Docker."
        ;;
    esac
}
# call the function to verify prerequisites for a Docker installation
prerequisites


# 2. Install Docker on the host

#<<<<<<<<<< Suporting Methods >>>>>>>>>>#

function docker_repo() {
    echo "Now we will add the Docker repo to our Docker list."
    echo

    read -p "Do you wish to proceed with adding the repo to our Docker list (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Adding the repository..."
            echo

            # set a variable with the release name of the ubuntu installation
            release=$( lsb_release --codename | cut -f2 )

            if [ -n $release ]; then
                echo "Your Ubuntu release is $release"

                # add the Docker APT repository
                sudo sh -c "echo deb https://apt.dockerproject.org/repo/ ubuntu-$release main > /etc/apt/sources.list.d/docker.list"

                echo "Repository added to the docker list"

            else
                echo "There has been a problem."
                echo "Repository was not added to the docker list."
                echo "Please try again or contact your systems administrator."

            fi
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will need to add this repository to complete the installation of Docker."
            echo
            echo "Exiting."
            echo
        ;;
    esac
}

function add_gpg_key() {
    echo "Now we will add the Docker repo GPG key."
    echo

    read -p "Do you wish to proceed with adding the key (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Adding the key..."
            echo

            sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will need to complete the addition of the Public Key if you wish to have access to the Docker repository."
            echo
            echo "Exiting."
            echo
        ;;
    esac

}

function install_docker-engine() {
    echo "Now we will install the Docker engine."
    echo

    read -p "Do you wish to proceed with installing the Docker engine (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Installing Docker engine..."
            echo

            sudo apt-get install docker-engine
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will need to complete installing Docker if you wish to take advantage of it."
            echo
            echo "Exiting."
            echo
        ;;
    esac

}

function hello_docker() {
    echo "Now we will verify that Docker is installed."
    echo

    read -p "Do you wish to proceed with the verification (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            echo "Requesting info from the Docker engine..."
            echo

            docker_info=$( sudo docker info )
            if [ -n docker_info ]; then
                sudo docker run ubuntu /bin/echo 'Hello world'
                echo
                echo "You should now see Hello World which is a response from an actual docker container!"
                echo "This will indicate that Docker has successfully installed and is currently running."
                echo "Congratulations!"
                echo
            fi
        ;;
        n|N )
            echo "Exiting now will leave this process incomplete."
            echo "You will not get the validation you have been working towards."
            echo
            echo "Exiting."
            echo
        ;;
    esac

}

#<<<<<<<<<< Primary Decisioning Logic >>>>>>>>>>#
function installing_docker() {
    echo "Now that the prerequisites have been met we can proceed with installing docker."
    echo "This will be done using the Docker team's DEB packages."
    echo

    # call the function to add the docker repo to our list
    docker_repo
    # call the function to add the Docker repo GPG key
    add_gpg_key
    # call the function to update the packages list
    update_packages
    # call the function to install docker-engine
    install_docker-engine
    # call the function to check whether Docker was successfully installed
    hello_docker
}
# call the function to install docker on our host
installing_docker
