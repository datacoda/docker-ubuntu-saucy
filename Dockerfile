#
# Image Name:: dataferret/ubuntu
#
# Copyright 2014, Ted Chen
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


FROM stackbrew/ubuntu:saucy
MAINTAINER Ted Chen <ted@nephilagraphic.com>


# Enable the necessary sources and upgrade to latest
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy-security main universe" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confnew"

# Install system packages
RUN apt-get update && apt-get install supervisor logrotate cron rsyslog -y && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

# Setup supervisor to run child processes
ADD ./etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./etc/supervisor/conf.d/cron.conf /etc/supervisor/conf.d/cron.conf
ADD ./etc/supervisor/conf.d/rsyslogd.conf /etc/supervisor/conf.d/rsyslogd.conf
RUN chown root:root /etc/supervisor/conf.d/* && chmod 644 /etc/supervisor/conf.d/*

CMD ["/usr/bin/supervisord", "-n"]
