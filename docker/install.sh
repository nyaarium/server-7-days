#!/bin/bash

steamcmd \
	+force_install_dir /app \
	+login anonymous \
	+app_update 294420 validate \
	+quit
