#!/bin/bash
whenever --update-crontab RateJob
foreman start -f Procfile.dev "$@"