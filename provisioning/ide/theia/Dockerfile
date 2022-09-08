FROM theiaide/theia-python:1.7.0

RUN pip3 install semgrep

RUN curl https://packages.chef.io/files/stable/inspec/4.18.51/ubuntu/18.04/inspec_4.18.51-1_amd64.deb -o /tmp/inspec.deb

RUN dpkg -i /tmp/inspec.deb