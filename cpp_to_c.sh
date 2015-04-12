#!/bin/bash 

sed "s?//\(.*\)?/*\1 */?" -i $1
