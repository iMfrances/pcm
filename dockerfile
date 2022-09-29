FROM fedora:35 as builder

ENV HTTP_PROXY="http://child-prc.intel.com:913"
ENV HTTPS_PROXY="http://child-prc.intel.com:913"
ENV NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
RUN dnf -y install gcc-c++ git findutils make cmake wget
RUN git clone https://github.com/opcm/pcm.git
RUN cd pcm/src&& git clone https://github.com/simdjson/simdjson.git
RUN cd pcm && wget -e use_proxy=yes -e http_proxy=http://child-prc.intel.com:913 -e https_proxy=http://child-prc.intel.com:913 https://download.01.org/perfmon/mapfile.csv
RUN cd pcm && mkdir build && cd build && cmake .. && make && mv ./bin/PMURegisterDeclarations ./../
RUN cd pcm && wget -m -p -k -np -R '*html*,*htm*,*asp*,*php*,*css*' -X 'www' -e use_proxy=yes -e http_proxy=http://child-prc.intel.com:913 -e https_proxy=http://child-prc.intel.com:913 -r -l2 --no-parent https://download.01.org/perfmon/ICX/ && mv download.01.org/perfmon/ICX . && ls ICX
#icelakex_core_v1.16.json
#icelakex_uncore_v1.16.json
#icelakex_uncore_v1.16_experimental.json

ENV PCM_NO_PERF=1

ENTRYPOINT [ "/pcm/build/bin/pcm-sensor-server", "-p", "9736", "-r" ]
